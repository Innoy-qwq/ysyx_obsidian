#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <stdlib.h>

#define start_year 1900

int write_time(){
    time_t time_now;
    struct tm *t;
    FILE *fp;
    
    if ((fp = fopen("test.txt", "a+")) == NULL){
        perror("open file src");
        exit(1);
    }

    while(1){
        time_now = time(NULL);
        t = localtime(&time_now);
        fprintf(fp, "%d-%.2d-%.2d %.2d:%.2d:%.2d\n", t->tm_year+start_year, t->tm_mon+1, t->tm_mday, t->tm_hour, t->tm_min, t->tm_sec);
        fflush(fp);
        sleep(1);
    }
}

int main(int argc, char *argv[]){
    write_time();
}