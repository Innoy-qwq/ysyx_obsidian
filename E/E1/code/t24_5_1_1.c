// 说实话我看了代码, 用的不是泛型. 但我照着做了. 这里的核心其实是swap和strcmp, 换个函数的话就能比对其他数据结构了.
#include <stdio.h>
#define n 5

#include <stdio.h>
#include <string.h>
#define n 5

void swap_char(char *exp[], int a, int b){
    char *temp = exp[a];
    exp[a] = exp[b];
    exp[b] = temp;
}

/* 可以比对str类型的插入排序*/
void insertion_sort(char *v[], int left, int right){
    for (int i = left; i < right; i++){
        for (int j = i; j > left; j--){
            if (strcmp(v[j-1], v[j]) > 0){
                swap_char(v, j, j-1);
            }        
        }
    }
}

int main(int argc, char *argv[]){
    char a[] = "inooy";
    char b[] = "abc";
    char c[] = "that's ok";
    char d[] = "bbbbb";
    char *exp[n] = {a, b, c, d, "aocccc"};
    
    insertion_sort(exp, 0, n);
    for (int i=0; i<n; i++){
        printf("%s \n", exp[i]);
    }
}