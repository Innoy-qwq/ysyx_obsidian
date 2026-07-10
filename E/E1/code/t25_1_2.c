#include <stdio.h>
#include <string.h>
#include <errno.h>

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