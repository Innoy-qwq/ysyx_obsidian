#include <stdio.h>
#include <stdlib.h>

int my_copy_made_by_fgets(char *file_src, char *file_dest){
    FILE *fp1;
    FILE *fp2;
    char *buffer = malloc(10);
    
    if ((fp1 = fopen(file_src, "r")) == NULL){
        perror("open file src");
        exit(1);
    }

    if ((fp2 = fopen(file_dest, "w")) == NULL){
        perror("open file dest");
        exit(1);
    }

    while (fgets(buffer, 10, fp1) != NULL)
    {
        fputs(buffer, fp2);
    }
    
    free(buffer);
    fclose(fp1);
    fclose(fp2);

    return 0;
}

int main(){
    my_copy_made_by_fgets("file_a", "file_b");
}