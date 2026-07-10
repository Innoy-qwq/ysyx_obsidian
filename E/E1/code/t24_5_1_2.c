#include <stdio.h>
#include <string.h>

int cmp(const void *a, const void *b){
    return strcmp((const char *)a, (const char *)b);
}


/*尝试使用泛型的二分查找, 这里求助了AI作为参考, 返回这里返回了字符串的地址, 修改前面的cmp可以变成查找int, 返回int的地址, 总之返回的是数组中的地址位置*/
void *binary_search(
    void *base,
    size_t n,
    size_t size,
    void *key,
    int (*cmp)(const void *, const void *))
{
    char *arr = base;
    size_t left = 0, right = n;

    while (left < right)
    {
        size_t mid = (left + right) / 2;
        void *elem = arr + mid * size;

        int c = cmp(key, elem);

        if (c == 0)
            return elem;
        else if (c < 0)
            right = mid;
        else
            left = mid + 1;
    }

    return NULL;
}

int main(){
    char exp[5][8] = {
        "inooy",
        "abc",
        "that's",
        "bbbbb",
        "aocccc"};
    printf("%s\n", (char *) binary_search(exp, 5, 8, "abc", cmp));
}