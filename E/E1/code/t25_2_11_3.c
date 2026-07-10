#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

int the_lib_is_sys(char *include_str){
    if (include_str[9] == '<') return 1;
    else if (include_str[9] == '"') return 0;
    else {
        perror("the lib name is invalid, please verify");
        return -1;
    }
}

void add_visit(char *include_str,char visit[][256]){
    int count = 0;
    while (visit[count][0])
        count++;
    strcpy(visit[count], include_str);
}


int file_visited(char *file_path, char visit[][256]){
    int count = 0;
    while (visit[count][0]){
        if (strcmp(visit[count], file_path) == 0) return 1;
        count++;
    }
    return 0;
}


void dfs_file(char *include_str, char visit[][256]){
    char buffer[100];
    char file_name[100];
    char file_path[100];
    FILE *fp;

    if (the_lib_is_sys(include_str)) sscanf(include_str, "#include <%[^>]>", file_name);
    else sscanf(include_str, "#include \"%[^\"]\"", file_name);

    strcpy(file_path, "/usr/include/");
    strcat(file_path, file_name);

    if (file_visited(file_path, visit)) return;
    add_visit(file_path, visit);

    if ((fp = fopen(file_path, "r")) == NULL){
        fprintf(stderr, "Failed to open '%s': %s\n", file_path, strerror(errno));
        return;
    }

    while (fgets(buffer, sizeof(buffer), fp) != NULL){
        if (strncmp(buffer, "#include", 8) == 0)
            dfs_file(buffer, visit);
    }
}


int get_file_dependencies(char *c_filename, char *output_file_name){
    FILE *fp1;
    FILE *fp2;
    char buffer[256];
    char visit[256][256] = {0};

    if ((fp1 = fopen(c_filename, "r")) == NULL){
        perror("open src file error");
        exit(1);
    }
    if ((fp2 = fopen(output_file_name, "w")) == NULL){
        perror("open output file error");
        exit(1);
    }

    while (fgets(buffer, sizeof(buffer), fp1) != NULL)
    {
       if (strncmp(buffer, "#include", 8) == 0)
            dfs_file(buffer, visit);
    }

    int count = 0;
    while (visit[count][0]){
        fputs(visit[count], fp2);
        fputs("\n", fp2);
        count++;
    }
}


int main(int argc, char *argv[]){
    get_file_dependencies("parseURL.c", "parseURL_libs.txt");
}