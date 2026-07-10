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