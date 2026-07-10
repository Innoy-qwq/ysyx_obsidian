#include <stdio.h>
#include <string.h>
#include "mystrtok.h"

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