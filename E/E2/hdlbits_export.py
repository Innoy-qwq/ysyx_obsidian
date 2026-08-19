#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
hdlbits_export.py — 批量导出你在 HDLBits (https://hdlbits.01xz.net) 上完成的每道题的
"Last success" 代码, 并按 Problem_sets 的目录结构保存到本地。

工作方式(全部通过公网 HTTP, 不需要浏览器本地数据, WSL 下可直接运行):

  1. 登录: POST /wiki/Special:VlgLogin (字段 vlg_username / password / login),
     会话由 Cookie `vlgsession` 维持。
  2. 抓取任意一个题目页面(如 /wiki/step_one)。该页面由服务器按登录用户动态渲染,
     内含完整题目导航树 <ul id="pmenu_top">, 与 /wiki/Problem_sets 的目录结构一致
     (题集 -> 子集 -> 题目, 每题带状态 "Not attempted" / 其他)。
  3. 每题页面还内嵌 "Load a previous submission" 下拉框数据:
         var d = [ [id,'Last success',ts],[id,'Last non-success',ts] ];
     其中的 id 即该题 "Last success" 提交的服务器文件号。
  4. POST /load.php (tc=<题目id>&name=<提交id>) 返回 {"status":2,"data":"<代码>"},
     即该题最近一次通过的代码。备用方案: /tcstat.php?show_sln&tc=<id> -> sln_data。

仅使用 Python 标准库, 无需安装任何依赖。

用法示例:
    python3 hdlbits_export.py --username 你的账号
    python3 hdlbits_export.py            # 交互式输入用户名/密码
    python3 hdlbits_export.py --out ./solutions --concurrency 6 --check-all
"""

import argparse
import getpass
import html.parser
import http.cookiejar
import json
import os
import re
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed

BASE = "https://hdlbits.01xz.net"
UA = (
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
    "(KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"
)

LOGIN_URL = BASE + "/wiki/Special:VlgLogin"
FIRST_PROBLEM_URL = BASE + "/wiki/step_one"  # 用它的导航树得到完整目录结构 + 每题状态
NOT_ATTEMPTED = "Not attempted"


# --------------------------------------------------------------------------- #
# 基础 HTTP 工具
# --------------------------------------------------------------------------- #

def _new_opener(cookie_jar=None):
    cj = cookie_jar if cookie_jar is not None else http.cookiejar.CookieJar()
    op = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj))
    op.addheaders = [
        ("User-Agent", UA),
        ("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"),
    ]
    return op, cj


def _opener_with_session(session_cookies):
    """为每个工作线程创建一个只带会话 Cookie 的 opener(线程安全, 无共享状态)。"""
    cj = http.cookiejar.CookieJar()
    for name, value in session_cookies.items():
        c = http.cookiejar.Cookie(
            version=0, name=name, value=value,
            port=None, port_specified=False,
            domain="hdlbits.01xz.net", domain_specified=True, domain_initial_dot=False,
            path="/", path_specified=True, secure=False,
            expires=None, discard=True, comment=None, comment_url=None,
            rest={}, rfc2109=False,
        )
        cj.set_cookie(c)
    op = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj))
    op.addheaders = [
        ("User-Agent", UA),
        ("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"),
    ]
    return op


def http_get(op, url, tries=4, backoff=1.0, timeout=30):
    last = None
    for i in range(tries):
        try:
            with op.open(url, timeout=timeout) as r:
                return r.read().decode("utf-8", "replace")
        except Exception as e:  # noqa: BLE001 - 重试所有瞬时错误
            last = e
            time.sleep(backoff * (i + 1))
    raise last


def http_post(op, url, data, timeout=60):
    body = urllib.parse.urlencode(data).encode("ascii")
    req = urllib.request.Request(url, data=body, method="POST")
    req.add_header("Content-Type", "application/x-www-form-urlencoded")
    with op.open(req, timeout=timeout) as r:
        return r.read().decode("utf-8", "replace")


# --------------------------------------------------------------------------- #
# 页面解析
# --------------------------------------------------------------------------- #

class _TreeParser(html.parser.HTMLParser):
    """解析 <ul id="pmenu_top"> 嵌套结构。

    每个叶子 <li> 含 <a href="/wiki/<id>"> 和状态图标 <span title="<id>: <status>">;
    每组 <li> 无 id, 名称为其标题文本, 内含子 <ul>。
    """

    def __init__(self):
        super().__init__()
        self.root = None
        self.stack = []   # 栈: 当前 ul 的内容列表
        self.cur_li = None

    def handle_starttag(self, tag, attrs):
        a = dict(attrs)
        if tag == "ul":
            newul = []
            if self.cur_li is not None:
                self.cur_li["children"].append(newul)
            elif self.root is None:
                self.root = newul
            self.stack.append(newul)
        elif tag == "li":
            self.cur_li = {"id": None, "name": "", "status": None, "children": []}
            self.stack[-1].append(self.cur_li)
        elif tag == "a" and self.cur_li is not None:
            href = a.get("href", "")
            if href.startswith("/wiki/"):
                self.cur_li["id"] = urllib.parse.unquote(href[len("/wiki/"):])
        elif tag == "span" and self.cur_li is not None:
            t = a.get("title")
            if t:
                m = re.match(r"^([^:]+): (.*)$", t)
                if m:
                    self.cur_li["status"] = m.group(2)

    def handle_endtag(self, tag):
        if tag == "ul":
            self.stack.pop()
        elif tag == "li":
            self.cur_li = None

    def handle_data(self, d):
        if self.cur_li is not None:
            self.cur_li["name"] += d


def parse_tree(html):
    """返回 pmenu_top 的嵌套结构: 顶层是 list, 元素为
    {'id': None|str, 'name': str, 'status': str|None, 'children': [ ... ]}"""
    start = html.find('<ul id="pmenu_top">')
    if start < 0:
        raise RuntimeError(
            "找不到题目导航树 (pmenu_top), 网站结构可能已变化"
        )
    seg = html[start:]
    depth = 0
    end = None
    for i in range(len(seg)):
        if seg.startswith("<ul", i):
            depth += 1
        elif seg.startswith("</ul>", i):
            depth -= 1
            if depth == 0:
                end = i + 5
                break
    if end is None:
        raise RuntimeError("pmenu_top 结构不完整, 无法解析")
    p = _TreeParser()
    p.feed(seg[:end])
    return p.root


def iter_leaves(nodes, path=()):
    """深度优先遍历, 产出 (路径元组, 叶子节点)。路径只含各级组名。"""
    for node in nodes:
        if node["id"] is not None:
            yield path, node
        else:
            name = node["name"].strip()
            for sub in node["children"]:
                yield from iter_leaves(sub, path + (name,))


def parse_dropdown(html):
    """提取 "Load a previous submission" 的 var d = [[id,'Last success',ts?],
    [id,'Last non-success',ts?]]; 无则返回 None。"""
    m = re.search(r"var\s+d\s*=\s*(\[)", html)
    if not m:
        return None
    i = m.end() - 1  # '['
    depth = 0
    j = i
    while j < len(html):
        ch = html[j]
        if ch == "[":
            depth += 1
        elif ch == "]":
            depth -= 1
            if depth == 0:
                break
        j += 1
    if depth != 0:
        return None
    arr = html[i:j + 1].replace("'", '"')
    try:
        return json.loads(arr)
    except ValueError:
        return None


def safe_name(s):
    """目录名/文件名安全化(兼容 Windows 文件系统, 便于拷回 Windows 使用)。"""
    s = s.strip()
    s = re.sub(r'[<>:"/\\|?*]', "-", s)
    s = re.sub(r"[\x00-\x1f]", "", s)
    s = s.rstrip(". ")
    return s or "untitled"


# --------------------------------------------------------------------------- #
# 登录与校验
# --------------------------------------------------------------------------- #

def login(username, password):
    """POST 登录表单, 返回会话 Cookie 字典。"""
    op, cj = _new_opener()
    http_get(op, LOGIN_URL)  # 初始化会话
    http_post(op, LOGIN_URL, {
        "vlg_username": username,
        "password": password,
        "login": "Login",
    })
    return {c.name: c.value for c in cj}


def verify_login(session, ignore_check=False):
    """抓取 step_one 页, 检查服务器是否返回了登录用户的数据。
    返回 (ok, tree, 说明信息)。"""
    op = _opener_with_session(session)
    html = http_get(op, FIRST_PROBLEM_URL)
    tree = parse_tree(html)
    leaves = list(iter_leaves(tree))
    d = parse_dropdown(html)
    has_progress = any((n.get("status") or "") != NOT_ATTEMPTED for _, n in leaves)
    has_ids = any(bool(x) and x[0] is not None for x in (d or []))
    if has_progress or has_ids:
        return True, tree, "登录成功(页面包含你的做题数据)"
    # 无任何用户数据: 再看登录页是否仍显示表单
    body = http_get(op, LOGIN_URL)
    form_still_there = 'name="vlg_username"' in body
    if form_still_there:
        msg = "登录失败: 用户名或密码不正确(登录表单仍被返回)"
        if ignore_check:
            return True, tree, msg + "; 已用 --ignore-login-check 强制继续"
        return False, tree, msg
    msg = "登录状态不确定: 未看到任何做题数据(可能账号确实没有进度)"
    if ignore_check:
        return True, tree, msg + "; 已用 --ignore-login-check 强制继续"
    return False, tree, msg


# --------------------------------------------------------------------------- #
# 获取 "Last success" 代码
# --------------------------------------------------------------------------- #

def fetch_solution(op, problem_id, page_html):
    """优先: 页面内嵌的 Last success 提交号 -> /load.php。
    备用: /tcstat.php?show_sln&tc=<id> 的 sln_data。
    返回 {'code': str} 或 {'code': '', 'error': str}。"""
    d = parse_dropdown(page_html)
    if d and len(d) > 0 and d[0] and d[0][0] is not None:
        sid = d[0][0]
        ts = d[0][2] if len(d[0]) > 2 else None
        try:
            resp = http_post(op, BASE + "/load.php", {"tc": problem_id, "name": str(sid)})
            obj = json.loads(resp)
            if obj.get("status") == 2 and obj.get("data") is not None:
                return {"code": obj["data"], "method": "load.php",
                        "submission_id": sid, "ts": ts}
            print(f"  [warn] {problem_id}: load.php 返回异常: {resp[:160]}",
                  file=sys.stderr)
        except Exception as e:  # noqa: BLE001
            print(f"  [warn] {problem_id}: load.php 请求失败: {e}", file=sys.stderr)
    try:
        resp = http_get(op, BASE + "/tcstat.php?show_sln&tc=" + urllib.parse.quote(problem_id))
        obj = json.loads(resp)
        if obj.get("status") == 2 and obj.get("sln_data"):
            return {"code": obj["sln_data"], "method": "tcstat",
                    "submission_id": None, "ts": None}
        return {"code": "", "error": "没有 Last success(status=%s)" % obj.get("status")}
    except Exception as e:  # noqa: BLE001
        return {"code": "", "error": "tcstat 请求失败: %s" % e}


# --------------------------------------------------------------------------- #
# 导出主流程
# --------------------------------------------------------------------------- #

def _process_one(session, item, args):
    """单个题目: 抓页面 -> 取 Last success -> 写文件。返回结果 dict。"""
    path, leaf, rel_dir, rel_file = item
    pid = leaf["id"]
    name = leaf["name"].strip()
    status = leaf.get("status") or ""
    op = _opener_with_session(session)
    result = {
        "id": pid, "name": name, "status": status,
        "set": path[0] if path else "", "file": None, "error": None,
        "method": None, "last_success_ts": None,
    }
    if args.skip_existing and os.path.exists(rel_file) and os.path.getsize(rel_file) > 0:
        result["file"] = rel_file
        result["skipped"] = True
        return result
    if args.delay:
        time.sleep(args.delay)
    try:
        page = http_get(op, BASE + "/wiki/" + urllib.parse.quote(pid, safe="/"))
        sln = fetch_solution(op, pid, page)
        if sln.get("code"):
            code = sln["code"].replace("\r\n", "\n").replace("\r", "\n")
            if not code.endswith("\n"):
                code += "\n"
            if args.header:
                code = f"// HDLBits: {pid} — {name}\n" + code
            os.makedirs(rel_dir, exist_ok=True)
            with open(rel_file, "w", encoding="utf-8", newline="\n") as f:
                f.write(code)
            result["file"] = rel_file
            result["method"] = sln.get("method")
            result["last_success_ts"] = sln.get("ts")
            result["submission_id"] = sln.get("submission_id")
        else:
            result["error"] = sln.get("error", "no solution")
            # 可选: 同时导出 "Last non-success" 草稿
            if args.include_failed:
                d = parse_dropdown(page)
                if d and len(d) > 1 and d[1] and d[1][0] is not None:
                    sid = d[1][0]
                    try:
                        resp = http_post(op, BASE + "/load.php",
                                         {"tc": pid, "name": str(sid)})
                        obj = json.loads(resp)
                        if obj.get("status") == 2 and obj.get("data"):
                            draft = obj["data"].replace("\r\n", "\n").replace("\r", "\n")
                            if not draft.endswith("\n"):
                                draft += "\n"
                            os.makedirs(rel_dir, exist_ok=True)
                            draft_file = os.path.splitext(rel_file)[0] + ".failed.v"
                            with open(draft_file, "w", encoding="utf-8", newline="\n") as f:
                                f.write(draft)
                            result["failed_file"] = draft_file
                    except Exception as e:  # noqa: BLE001
                        pass
    except Exception as e:  # noqa: BLE001
        result["error"] = "页面抓取失败: %s" % e
    return result


def export_all(session, tree, args):
    leaves = list(iter_leaves(tree))
    total = len(leaves)
    print(f"共 {total} 道题。", file=sys.stderr)

    todo = []   # (path, leaf, rel_dir, rel_file)
    results = []
    for path, leaf in leaves:
        pid = leaf["id"]
        rel_dir = os.path.join(args.out, *(safe_name(p) for p in path))
        rel_file = os.path.join(rel_dir, pid.split("/")[-1] + ".v")
        status = leaf.get("status") or ""
        if status == NOT_ATTEMPTED and not args.check_all:
            results.append({
                "id": pid, "name": leaf["name"].strip(), "status": status,
                "set": path[0] if path else "", "file": None, "error": "未尝试",
            })
        else:
            todo.append((path, leaf, rel_dir, rel_file))

    # 无论是否有导出, 先按 Problem_sets 建立完整目录骨架
    def mk_skeleton(nodes, cur):
        for node in nodes:
            if node["id"] is None:
                sub = os.path.join(cur, safe_name(node["name"]))
                os.makedirs(sub, exist_ok=True)
                mk_skeleton(node["children"], sub)
    os.makedirs(args.out, exist_ok=True)
    mk_skeleton(tree, args.out)

    if not todo:
        print("没有需要导出的题目(全为 Not attempted? 请确认已登录且账号有进度)。",
              file=sys.stderr)
        return results

    print(f"将检查 {len(todo)} 道有记录的题(并发 {args.concurrency})...", file=sys.stderr)
    done = 0
    with ThreadPoolExecutor(max_workers=args.concurrency) as ex:
        futs = {ex.submit(_process_one, session, item, args): item for item in todo}
        for fut in as_completed(futs):
            item = futs[fut]
            r = fut.result()
            results.append(r)
            done += 1
            pid = item[1]["id"]
            if r.get("file"):
                print(f"  [{done}/{len(todo)}] {pid} -> {r['file']} "
                      f"({r.get('method')})", file=sys.stderr)
            elif r.get("failed_file"):
                print(f"  [{done}/{len(todo)}] {pid}: 无 Last success"
                      f"(已存草稿 {r['failed_file']})", file=sys.stderr)
            else:
                print(f"  [{done}/{len(todo)}] {pid}: 跳过 — {r.get('error')}",
                      file=sys.stderr)
    return results


def write_reports(results, tree, args, username):
    exported = [r for r in results if r.get("file")]
    failed = [r for r in results if r.get("error")]

    stats = {
        "exported_at": time.strftime("%Y-%m-%d %H:%M:%S %z"),
        "username": username,
        "out_dir": args.out,
        "total_problems": len(results),
        "exported": len(exported),
        "problems": results,
    }
    with open(os.path.join(args.out, "stats.json"), "w", encoding="utf-8") as f:
        json.dump(stats, f, ensure_ascii=False, indent=2)

    with open(os.path.join(args.out, "problems.json"), "w", encoding="utf-8") as f:
        json.dump(tree, f, ensure_ascii=False, indent=2)

    lines = [
        "# HDLBits Solutions (自动导出)",
        "",
        f"- 导出时间: {stats['exported_at']}",
        f"- 账号: {username}",
        f"- 共 {stats['total_problems']} 题, 成功导出 {len(exported)} 题"
        + (f", 其中 {len(failed)} 题失败" if failed else ""),
        "",
        "目录结构与 https://hdlbits.01xz.net/wiki/Problem_sets 一致",
        "(目录名已做 Windows 安全化, 如 `:` -> `-`)。",
        "",
        "## 导出的题目",
        "",
        "| 题目 | 状态 | 文件 | 来源 | Last success 时间 |",
        "| --- | --- | --- | --- | --- |",
    ]
    for r in sorted(results, key=lambda x: (x["set"], x["id"])):
        ts = r.get("last_success_ts")
        ts_s = time.strftime("%Y-%m-%d %H:%M:%S",
                             time.localtime(ts)) if isinstance(ts, (int, float)) else "-"
        lines.append(
            f"| `{r['id']}` | {r.get('status') or '-'} | "
            f"{r['file'] or (r.get('error') or '-')} | "
            f"{r.get('method') or '-'} | {ts_s} |"
        )
    lines += ["", "## 失败/未导出", ""]
    for r in failed:
        lines.append(f"- `{r['id']}` ({r.get('name')}): {r.get('error')}")
    if not failed:
        lines.append("- (无)")
    with open(os.path.join(args.out, "README.md"), "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")

    return exported, failed


# --------------------------------------------------------------------------- #
# 命令行入口
# --------------------------------------------------------------------------- #

def parse_args(argv):
    p = argparse.ArgumentParser(
        prog="hdlbits_export.py",
        description="批量导出 HDLBits 每道题的 Last success 代码, 并按 Problem_sets 结构保存。",
    )
    p.add_argument("--username", "-u", help="HDLBits 用户名(也可用环境变量 HDLBITS_USER)")
    p.add_argument("--password", "-p", help="HDLBits 密码(也可用环境变量 HDLBITS_PASSWORD; 不填则交互输入)")
    p.add_argument("--out", "-o", default="hdlbits_solutions", help="输出目录(默认: hdlbits_solutions)")
    p.add_argument("--concurrency", "-j", type=int, default=4, help="并发请求数(默认 4)")
    p.add_argument("--delay", type=float, default=0.0, help="每个请求前额外延时秒数(礼貌模式)")
    p.add_argument("--check-all", action="store_true",
                   help="对每道题都实际检查(默认信任导航树状态, 只检查有记录的题)")
    p.add_argument("--skip-existing", action="store_true", help="跳过已存在且非空的 .v 文件")
    p.add_argument("--include-failed", action="store_true",
                   help="对没有 Last success 的题, 额外保存最近一次失败提交为 <name>.failed.v")
    p.add_argument("--header", action="store_true", help="在 .v 文件头部加一行 `// HDLBits: <id>` 注释")
    p.add_argument("--dry-run", action="store_true", help="只登录并列出结构/状态, 不导出")
    p.add_argument("--ignore-login-check", action="store_true",
                   help="登录校验不通过也强制继续(不推荐)")
    return p.parse_args(argv)


def main(argv=None):
    args = parse_args(argv)
    username = args.username or os.environ.get("HDLBITS_USER")
    password = args.password or os.environ.get("HDLBITS_PASSWORD")
    if not username:
        username = input("HDLBits 用户名: ").strip()
    if not password:
        password = getpass.getpass("HDLBits 密码: ")

    print("正在登录 hdlbits.01xz.net ...", file=sys.stderr)
    session = login(username, password)
    ok, tree, msg = verify_login(session, ignore_check=args.ignore_login_check)
    print(msg, file=sys.stderr)
    if not ok:
        print(
            "登录失败。请检查用户名/密码。\n"
            "提示: 若账号是通过第三方登录(Google/GitHub/微信)创建的, 请先在网站 "
            "/wiki/Special:VlgProfile (Create profile...) 设置/确认密码账号。",
            file=sys.stderr,
        )
        return 2

    if args.dry_run:
        print("\n=== 目录结构(来自 Problem_sets 导航树)===", file=sys.stderr)
        for path, leaf in iter_leaves(tree):
            status = leaf.get("status") or "?"
            print(f"{'  ' * len(path)}{path[-1] if path else ''} / "
                  f"{leaf['name'].strip()} [{leaf['id']}] [{status}]", file=sys.stderr)
        return 0

    results = export_all(session, tree, args)
    exported, failed = write_reports(results, tree, args, username)

    print(file=sys.stderr)
    print(f"完成: 成功导出 {len(exported)} 题, 失败 {len(failed)} 题。", file=sys.stderr)
    print(f"输出目录: {os.path.abspath(args.out)}", file=sys.stderr)
    print(f"  - 每题代码: <题集>/<子集>/<题目>.v", file=sys.stderr)
    print(f"  - 汇总: README.md, stats.json, problems.json", file=sys.stderr)
    if failed:
        print("失败详情见 README.md / stats.json。", file=sys.stderr)
    return 0 if not failed else 1


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        print("\n已中断。", file=sys.stderr)
        sys.exit(130)
