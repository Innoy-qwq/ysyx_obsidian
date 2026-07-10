#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*将INI文件转换为XML文件*/
int INI2XML(FILE *src, FILE *dst){
    FILE *fp1 = src;
    FILE *fp2 = dst;
    char buffer[256];
    char key_str [256];
    char section[256];
    char *key_value_flag;

    while(fgets(buffer, sizeof(buffer), fp1) != NULL){
        if(strchr(buffer,'\n') || feof(fp1)){
            if (buffer[0] == ';'){
                sscanf(buffer, ";%[^\n]", key_str);
                fprintf(fp2, "<!-- %s -->\n", key_str);
            }
            else if (buffer[0] == '['){
                strncpy(key_str, buffer+1, strlen(buffer)-3);  // 截断']', '\n', '\0'
                key_str[strlen(buffer)-3] = '\0';
                fprintf(fp2, "<%s>\n", key_str);
                strcpy(section, key_str);
            }
            else if (key_value_flag = strchr(buffer, '='))
            {
                buffer[strlen(buffer)-1] = '\0';
                strncpy(key_str, buffer, key_value_flag - buffer);
                key_str[key_value_flag - buffer] = '\0';
                fprintf(fp2, "\t<%s>%s</%s>\n", key_str, key_value_flag+1, key_str);
            }
            else if (buffer[0] == '\n'){
                fprintf(fp2, "</%s>\n", section);
                fprintf(fp2, "\n");
            }
        }
        else{
            perror("单行字符数量超出可用范围");
            exit(1);
        }
    }
    fprintf(fp2, "</%s>\n", section);
}


int main(char argc, char *argv[]){
    FILE *fp1;
    FILE *fp2;
    
    if ((fp1 = fopen("test.ini", "r"))==NULL){
        perror("open ini error");
        exit(1);
    }


    if ((fp2 = fopen("test.xml", "w"))==NULL){
        perror("open xml error");
        exit(1);
    }

    INI2XML(fp1, fp2);
}

