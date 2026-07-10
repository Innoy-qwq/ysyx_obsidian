#include <stdio.h>

int main(int argc,char *argv[]){
    unsigned int size = 0;
    while (1){
        malloc(100000000);
        size+=100000000;
        printf("%d\n", size);
    }
}