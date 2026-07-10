#include <stdio.h>

// 函数原型应当是char *shrink_space(char *dest, const char *src, size_t n);
// 实现的效果是将src的字符串选取n个, 进行空格压缩并填入dest, 若字符串不满n个则后续填\0



char *shrink_space(char *dest, const char *src, size_t n)
{
    char *ret = dest;
    int flag = 0; // 表示是否已经出现空位;
    for (int count = 0; count < n; count++)
    {
        if (*src == ' '  ||
            *src == '\t' ||
            *src == '\n' ||
            *src == '\r'){
            if(!flag){
            *dest = ' ';
            dest++;
            flag = 1;}
            }
        else{
            *dest = *src;
            dest++;
            flag = 0;
            }

        if (*src != '\0')
            src++;
    }
    
    return ret;
}

int main(void)
{
    char a[30];
    printf("%s", shrink_space(a, "Hello \n \t Innoy", 15));
};