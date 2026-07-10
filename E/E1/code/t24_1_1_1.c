#include <stdio.h>

// 函数原型应当是char *strcpy(char *dest，const char *src);
// 实现的效果是将src的字符串填入dest, 并返回dest的指针

char *strcpy(char *dest, const char *src)
{
	char *ret = dest;
	while((*dest++ = *src++) != '\0'); //这里利用了赋值语句作为右值
	return ret; 
} 

int main(void){
	char A[10];
	printf("%s", strcpy(A, "innoy"));
};