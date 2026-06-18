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


