### 字符串操作函数

那段调试就不分析了. 看到strtok的实现, 感觉c面对返回多个结果的场景, 可能都是类似的做法: 单次只返回首个结果, 后续通过多次调用返回后续结果. 

这有点像Python的迭代器. 总之这个函数存在隐藏的状态. 

**strtok_r**的调用案例又用了一堆没见过的东西, 好吧至少这个教材挺能催人学习的. 

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
    char *str1, *str2, *token, *subtoken;
    char *saveptr1, *saveptr2;
    int j;

    if (argc != 4)
    {
        fprintf(stderr, "Usage: %s string delim subdelim\n",
                argv[0]);
        exit(EXIT_FAILURE);
    }

    for (j = 1, str1 = argv[1];; j++, str1 = NULL)
    {
        token = strtok_r(str1, argv[2], &saveptr1);
        if (token == NULL)
            break;
        printf("%d: %s\n", j, token);

        for (str2 = token;; str2 = NULL)
        {
            subtoken = strtok_r(str2, argv[3], &saveptr2);
            if (subtoken == NULL)
                break;
            printf(" --> %s\n", subtoken);
        }
    }

    exit(EXIT_SUCCESS);
}
```

先看这一段: 

```c
    if (argc != 4)
    {
        fprintf(stderr, "Usage: %s string delim subdelim\n",
                argv[0]);
        exit(EXIT_FAILURE);
    }
```

这里强硬要求函数调用时需要3个参数, 由于这是main函数，加上程序名算是四个.

不是4的话就print用法, 给出指南. 这里的print是打印到strerr上的.  

exit(EXIT_FALURE)就相当于退出. 

#### 习题:

1、出于练习的目的，`strtok`和`strtok_r`函数非常值得自己动手实现一遍，在这个过程中不仅可以更深刻地理解这两个函数的工作原理，也为以后理解“可重入”和“线程安全”这两个重要概念打下基础。

>答: 代码如下. 

```c
#include <stdio.h>
#include <string.h>


int if_delim(char c, const char *delim){
    while (*delim){
        if (c == *delim) return 1;
        delim++;
    }
    return 0;
}


char *my_strtok(char *str, const char *delim){
    static char *next = NULL;

    if (str==NULL) str = next;
    else next = str;

    if (!str) return NULL; /*考虑用户可能调用不规范, 首次调用str填了NULL*/
    
    while (*next){
        if (if_delim(*next, delim)){
            *next = '\0';
            next++;
            return str;
        }
        next++;
    }

    next = NULL;
    return str;
}


char *my_strtok_r(char *str, const char *delim, char **saveptr){
    if (str==NULL) str = *saveptr;
    else (*saveptr) = str;

    if (!str) return NULL; /*考虑用户可能调用不规范, 首次调用str填了NULL*/
    
    while (**saveptr){
        if (if_delim(**saveptr, delim)){
            **saveptr = '\0';
            (*saveptr)++;
            return str;
        }
        (*saveptr)++;
    }

    *saveptr = NULL;
    return str;
}


int main(void){
    char a[40] = "hello`str*tok";
    char *save;

    char *test = my_strtok_r(a, "`*", &save);
    printf("%s\n", test);
    test = my_strtok_r(NULL, "`*", &save);
    printf("%s\n", test);
    test = my_strtok_r(NULL, "`*", &save);
    printf("%s\n", test);
}
```

2、解析URL中的路径和查询字符串。动态网页的URL末尾通常带有查询，例如：

```
http://www.google.cn/search?complete=1&hl=zh-CN&ie=GB2312&q=linux&meta=  
http://www.baidu.com/s?wd=linux&cl=3
```

比如上面第一个例子，`http://www.google.cn/search`是路径部分，?号后面的`complete=1&hl=zh-CN&ie=GB2312&q=linux&meta=`是查询字符串，由五个“key=value”形式的键值对（Key-value Pair）组成，以&隔开，有些键对应的值可能是空字符串，比如这个例子中的键`meta`。

现在要求实现一个函数，传入一个带查询字符串的URL，首先检查输入格式的合法性，然后对URL进行切分，将路径部分和各键值对分别传出，请仔细设计函数接口以便传出这些字符串。如果函数中有动态分配内存的操作，还要另外实现一个释放内存的函数。完成之后，为自己设计的函数写一个Man Page。

>答: 代码如下

```c
#include <stdio.h>
#include <string.h>


int if_delim(char c, const char *delim){
    while (*delim){
        if (c == *delim) return 1;
        delim++;
    }
    return 0;
}


char *my_strtok_r(char *str, const char *delim, char **saveptr){
    if (str==NULL) str = *saveptr;
    else (*saveptr) = str;

    if (!str) return NULL; /*考虑用户可能调用不规范, 首次调用str填了NULL*/
    
    while (**saveptr){
        if (if_delim(**saveptr, delim)){
            **saveptr = '\0';
            (*saveptr)++;
            return str;
        }
        (*saveptr)++;
    }

    *saveptr = NULL;
    return str;
}

char *parseURL(char *URL, char **saveptr){
    char *t = my_strtok_r(URL, "?&", saveptr);
    return t;
}

int main(){
    char a[50] = "http://www.baidu.com/s?wd=linux&cl=3";
    char *b;
    char *saveptr;
    b = parseURL(a, &saveptr);
    while (b){
        printf("%s\n", b);
        b = parseURL(NULL, &saveptr);
    }
}
```

>man如下

```
NAME 
	parseURL
SYNOPSIS 
	char *parseURL(char *URL, char **saveptr);
DESCRIPTION
	parseURL() splits a URL string into tokens using the delimiters  
'?' and '&'.The first call should provide the URL string in the url argument.
Subsequent calls should pass NULL as url while preserving the
saveptr value between calls.

The input string is modified in place. Delimiter characters are
replaced with '\0' terminators.
```

---
### 标准IO库函数

文件分为文本文件和二进制文件, 文本文件的内容遵循某种文本编码, 这容易理解

>用Vi编辑文本文件, 最后会留一个换行符. 比如你输入1234, 长度会是5.

然后看od命令和各个参数: 

```shell
$ od -tx1 -tc -Ax textfile 
000000 35 36 37 38 0a
	    5  6  7  8 \n
000005
```

`-txl`: 将内容以16进制的形式列出来. 
`-tc`: 以ASCII码表示
`-Ax`: 以16进制显示地址

在Linux中一切皆文件, 设备同样作为文件进行管理, 这在我们写printf函数的时候就应当知道了, 毕竟参数里要跟上"stdout", 这也相当于是文件. 

`errno`的作用可直接从man读得: 

```
       For some system calls and library functions (e.g., getpriority(2)), -1 is a valid return on success.  In such cases, a successful return can be distinguished from an error
       return by setting errno to zero before the call, and then, if the call returns a status that indicates that an error may have occurred, checking to  see  if  errno has a nonzero value.
       errno is defined by the ISO C standard to be a modifiable lvalue of type int, and must not be explicitly declared; errno may be a macro.  errno is thread-local; setting it in one thread does not affect its value in any other thread.
```

当你的函数-1属于正常的返回值, 那把-1作为异常返回值就不行了. 这个时候就需要errno变量. errno变量你首先自行置零, 等到清楚出现错误你就将其赋值-1, 由于是全局变量所以你在其他地方也可以做这个读取. 

但是注意最后一段说明`errno`是线程隔离的全局变量, 意味着在每个线程中, `errno`是独立可用的.

`perror`用于打印错误, 本质上就是查找error的值作为index, 然后去某个表里找出来, 再和参数`const char *s`拼接. 

#### 习题

1、在系统头文件中找到各种错误码的宏定义。

```
/usr/include/asm-generic/errno-base.h
```

> 这是根据vsc的查询, 一步步找到的宏定义文件路径


2、做几个小练习，看看`fopen`出错有哪些常见的原因。

```
No such file or directory - 无文件
Permission denied - 无权限
Is a directory - 非文件
Text file busy - 权限冲突
```

---

#### 习题

1、编写一个简单的文件复制程序。

```c
#include <stdio.h>
#include <stdlib.h>

void copyfile(char *file_A, char *file_B){
    FILE *fp1;
    FILE *fp2;
    int ch;
    if ((fp1 = fopen(file_A, "r")) == NULL){
        perror("open file fp1 error");
        exit(1);
    }
    if ((fp2 = fopen(file_B, "w")) == NULL){
        perror("open file fp2 error");
        exit(1);
    }
    while ((ch = fgetc(fp1)) != EOF)
    {
        fputc(ch, fp2);
    }
    fclose(fp1);
    fclose(fp2);
}

int main(){
    copyfile("file_a", "file_b");
}
```

2、虽然我说`getchar`要读到换行符才返回，但上面的程序并没有提供证据支持我的说法，如果看成每敲一个键`getchar`就返回一次，也能解释程序的运行结果。请写一个小程序证明`getchar`确实是读到换行符才返回的。

```c
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
	FILE *fp;
	int ch;

	if ( (fp = fopen("file2", "w+")) == NULL) {
		perror("Open file file2\n");
		exit(1);
	}
	while ( (ch = getchar()) != EOF){
		fputc(ch, fp);
        rewind(fp);
        while ( (ch = fgetc(fp)) != EOF)
		    putchar(ch);
    }
	fclose(fp);
	return 0;
}
```

结果: 

```
abcd
aababcabcdabcd
```

这段代码在运行过程中验证了换行符才返回. 因为如果不换行就会被输入, 那么应当在你输入`abcd`过程中, 后续就应当直接运行保存和打印程序, 但事实上是换行之后, 终端字符才被打印getchar一点一点读取搬运. 打印出来`aababcabcdabcd`, 最后接了一个`\n`
#### 习题

1、用`fgets`/`fputs`写一个拷贝文件的程序，根据本节对`fgets`函数的分析，应该只能拷贝文本文件，试试用它拷贝二进制文件会出什么问题。

```c
#include <stdio.h>
#include <stdlib.h>

int my_copy_made_by_fgets(char *file_src, char *file_dest){
    FILE *fp1;
    FILE *fp2;
    char *buffer = malloc(10);
    
    if ((fp1 = fopen(file_src, "r")) == NULL){
        perror("open file src");
        exit(1);
    }

    if ((fp2 = fopen(file_dest, "w")) == NULL){
        perror("open file dest");
        exit(1);
    }

    while (fgets(buffer, 10, fp1) != NULL)
    {
        fputs(buffer, fp2);
    }
    
    free(buffer);
    fclose(fp1);
    fclose(fp2);

    return 0;
}

int main(){
    my_copy_made_by_fgets("file_a", "file_b");
}
```

`fputs`会在遇到字符串结尾`\0`时停止写文件, 只适合文本文件. 可以考虑用`fwrite`. 

---

`printf`和`scanf`也不多提了. 重点看一下缓冲. 

全缓冲

如果缓冲区写满了就写回内核。常规文件通常是全缓冲的。

行缓冲

如果用户程序写的数据中有换行符就把这一行写回内核，或者如果缓冲区写满了就写回内核。标准输入和标准输出对应终端设备时通常是行缓冲的。

无缓冲

用户程序每次调库函数做写操作都要通过系统调用写回内核。标准错误输出通常是无缓冲的，这样用户程序产生的错误信息可以尽快输出到设备。

> 这个缓冲区究竟是什么? 我们在之前提到过，一个进程建立的时候，系统会给它分一块虚拟内存，其中就包含.data, heap, stack等部分 [[ysyx - E1 - 24#^ceda97| -> 详情查看E1 - 24]]. 
> 而缓冲区buffer其实就是个char数组, 它被libc在程序启动时建立. 在实现的时候，可以放到堆heap或者静态区.bss之类的。但总之，这是一个相对于虚拟内存来说更抽象一层的东西, 要求是这样一个要求，实现的话，你可以自行去放在哪都行，满足要求就可以。甚至使用`setvbuf`函数可以自己设置buffer. 

本节结尾, 这一节学习了很多IO相关的函数, 整理一下: 

rewind : 读写位置回到开头
fseek : 读写位置移动特定偏移
ftell : 回到当前读写位置

fgetc : 从指定文件读一个字节, getchar相当于fgetc(stdin)
fputc : 给指定文件写入一个字节， putchar相当于fputc(c, stdout)

fgets : 从指定文件读取一行到缓冲区, 或者达到满缓冲. 
fputs : 给指定文件写入字符串, 注意fgets是按行读, 但fputs不是按行写的

fprintf : 按格式打印到指定文件
fscanf : 从指定文件按格式读取

前缀带f : 处理文件
前缀带s : 使用人工buffer
前缀带n : 限制目标长度
前缀带v : 使用va_list

#### 2.11. 本节综合练习

1、编程读写一个文件`test.txt`，每隔1秒向文件中写入一行记录

> 代码如下. 其实到这里, 比如time(2)这样的函数我不是很清楚, 自然就去查man了, 也算是养成习惯了.

```c
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <stdlib.h>

#define start_year 1900

int write_time(){
    time_t time_now;
    struct tm *t;
    FILE *fp;
    
    if ((fp = fopen("test.txt", "a+")) == NULL){
        perror("open file src");
        exit(1);
    }

    while(1){
        time_now = time(NULL);
        t = localtime(&time_now);
        fprintf(fp, "%d-%.2d-%.2d %.2d:%.2d:%.2d\n", t->tm_year+start_year, t->tm_mon+1, t->tm_mday, t->tm_hour, t->tm_min, t->tm_sec);
        fflush(fp);
        sleep(1);
    }
}

int main(int argc, char *argv[]){
    write_time();
}
```

2、现在要求编程把INI文件转换成XML文件。

>代码如下. 值得注意的是, 容易想到这种字符串解析需要考虑安全问题, 一些异常的字符串注入可能导致解析结果出现问题. 但这里感觉暂时还不用考虑. 
>这里主要是要对标识符的开始条件和结束条件进行分析. 注意这里是有优先级的, 也就是说位于下侧的判断, 自带一个额外的要求, 那就是不满足前方判断的条件.
>
>注释语句的开始条件是在行开头检测到符号`;`, 结束条件是达到本行末尾. 
>Section的开始条件是在句首检测到`[`, 结束条件是空行或者文件结尾. 
>键值对的开始条件是出现`=`, 于是将前面切分为键, 后方切分为值.

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*将INI文件转换为XML文件*/
int INI2XML(FILE *src, FILE *dst){
    FILE *fp1 = src;
    FILE *fp2 = dst;
    char buffer[256];
    char key_str [256];
    char section[256];
    char *key_value_flag;

    while(fgets(buffer, sizeof(buffer), fp1) != NULL){
        if(strchr(buffer,'\n') || feof(fp1)){
            if (buffer[0] == ';'){
                sscanf(buffer, ";%[^\n]", key_str);
                fprintf(fp2, "<!-- %s -->\n", key_str);
            }
            else if (buffer[0] == '['){
                strncpy(key_str, buffer+1, strlen(buffer)-3);  // 截断']', '\n', '\0'
                key_str[strlen(buffer)-3] = '\0';
                fprintf(fp2, "<%s>\n", key_str);
                strcpy(section, key_str);
            }
            else if (key_value_flag = strchr(buffer, '='))
            {
                buffer[strlen(buffer)-1] = '\0';
                strncpy(key_str, buffer, key_value_flag - buffer);
                key_str[key_value_flag - buffer] = '\0';
                fprintf(fp2, "\t<%s>%s</%s>\n", key_str, key_value_flag+1, key_str);
            }
            else if (buffer[0] == '\n'){
                fprintf(fp2, "</%s>\n", section);
                fprintf(fp2, "\n");
            }
        }
        else{
            perror("单行字符数量超出可用范围");
            exit(1);
        }
    }
    fprintf(fp2, "</%s>\n", section);
}


int main(char argc, char *argv[]){
    FILE *fp1;
    FILE *fp2;
    
    if ((fp1 = fopen("test.ini", "r"))==NULL){
        perror("open ini error");
        exit(1);
    }


    if ((fp2 = fopen("test.xml", "w"))==NULL){
        perror("open xml error");
        exit(1);
    }

    INI2XML(fp1, fp2);
}
```

3、实现类似`gcc`的`-M`选项的功能，给定一个`.c`文件，列出它直接和间接包含的所有头文件.如果有的头文件找不到，就像上面例子那样打印`/home/akaedu/stack.h: cannot find`。本题目不必考虑`-I`选项指定的目录，只在`.c`文件所在的目录以及系统目录`/usr/include`中查找。

> 代码如下. 这两天作息调整了, 也算是码力恢复一些, 起码拆得动函数了.

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

int the_lib_is_sys(char *include_str){
    if (include_str[9] == '<') return 1;
    else if (include_str[9] == '"') return 0;
    else {
        perror("the lib name is invalid, please verify");
        return -1;
    }
}

void add_visit(char *include_str,char visit[][256]){
    int count = 0;
    while (visit[count][0])
        count++;
    strcpy(visit[count], include_str);
}


int file_visited(char *file_path, char visit[][256]){
    int count = 0;
    while (visit[count][0]){
        if (strcmp(visit[count], file_path) == 0) return 1;
        count++;
    }
    return 0;
}


void dfs_file(char *include_str, char visit[][256]){
    char buffer[100];
    char file_name[100];
    char file_path[100];
    FILE *fp;

    if (the_lib_is_sys(include_str)) sscanf(include_str, "#include <%[^>]>", file_name);
    else sscanf(include_str, "#include \"%[^\"]\"", file_name);

    strcpy(file_path, "/usr/include/");
    strcat(file_path, file_name);

    if (file_visited(file_path, visit)) return;
    add_visit(file_path, visit);

    if ((fp = fopen(file_path, "r")) == NULL){
        fprintf(stderr, "Failed to open '%s': %s\n", file_path, strerror(errno));
        return;
    }

    while (fgets(buffer, sizeof(buffer), fp) != NULL){
        if (strncmp(buffer, "#include", 8) == 0)
            dfs_file(buffer, visit);
    }
}


int get_file_dependencies(char *c_filename, char *output_file_name){
    FILE *fp1;
    FILE *fp2;
    char buffer[256];
    char visit[256][256] = {0};

    if ((fp1 = fopen(c_filename, "r")) == NULL){
        perror("open src file error");
        exit(1);
    }
    if ((fp2 = fopen(output_file_name, "w")) == NULL){
        perror("open output file error");
        exit(1);
    }

    while (fgets(buffer, sizeof(buffer), fp1) != NULL)
    {
       if (strncmp(buffer, "#include", 8) == 0)
            dfs_file(buffer, visit);
    }

    int count = 0;
    while (visit[count][0]){
        fputs(visit[count], fp2);
        fputs("\n", fp2);
        count++;
    }
}


int main(int argc, char *argv[]){
    get_file_dependencies("parseURL.c", "parseURL_libs.txt");
}
```

