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

```