#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct time_log_node* time_link;

struct time_log_node{
    unsigned int date;
    unsigned int time;
    time_link next;
};

time_link make_node(const unsigned int date, const unsigned int time){
    time_link p = malloc(sizeof *p);
    p->date = date;
    p->time = time;
    p->next = NULL;

    return p;
}


time_link insert(time_link head, time_link node){
    if (head == NULL){
        head = node;
        return head;
    }

    time_link p = head;
    while (p->next){
        p = p->next;   
    }
    p->next = node;
    return head;
}


time_link timelog2linkedlist(FILE* timelog_file){
    time_link head = NULL;
    int buffer[6];
    unsigned int date;
    unsigned int time;
    unsigned int linenum;
    while (fscanf(timelog_file, "%d %d-%d-%d %d:%d:%d", &linenum, &buffer[0], &buffer[1],  &buffer[2], &buffer[3], &buffer[4], &buffer[5]) == 7)
    {   
        date = buffer[0] * 10000 + buffer[1] * 100 + buffer[2];
        time = buffer[3] * 10000 + buffer[4] * 100 + buffer[5];
        head = insert(head, make_node(date, time));
    }
    return head;
}


time_link insert_in_sort(time_link head, time_link p, time_link p_pre){
    time_link temp = head;

    if(p->time < head->time){
        p_pre->next = p->next;
        p->next = head;
        head = p;
        return head;
    }

    while (p->time > temp->next->time){
        temp = temp->next;
    }

    p_pre->next = p->next;
    p->next = temp->next;
    temp->next = p;
    return head;
}


time_link time_resort(time_link head){
    time_link p = head;
    time_link q = p->next;

    if (q == NULL) return head;

    while (q)
    {
        if (p->time <= q->time){
            q = q->next;
            p = p->next;
        }
        else{
            head = insert_in_sort(head, q, p);
            q = p->next;
        }   
    }
    return head;

}

void linklist2timelog(time_link head, FILE *timelog_out){
    time_link p = head;
    unsigned int year;
    unsigned int month;
    unsigned int day;
    unsigned int hour;
    unsigned int min;
    unsigned int sec; 
    unsigned int linenum = 1; 

    while (p)
    {
        /*p->date and p->time used to print*/
        year = p->date / 10000;
        month = (p->date / 100) % 100;
        day = p->date % 100;
        hour = p->time / 10000;
        min = (p->time / 100) % 100;
        sec = p->time % 100;
        fprintf(timelog_out, "%d %d-%.2d-%.2d %.2d:%.2d:%.2d\n", linenum, year, month, day, hour, min, sec);
        linenum++;
        p = p->next;
    }
    
}


int main(int argc, char *argv[]){
    time_link head = NULL;
    FILE *p_read;
    FILE *p_out;

    if ((p_read = fopen(argv[1], "r")) == NULL){
        perror("open file error");
        exit(1);
    }
    if ((p_out = fopen(argv[2], "w")) == NULL){
        perror("open file error");
        exit(1);
    }

    head = timelog2linkedlist(p_read);
    head = time_resort(head);
    linklist2timelog(head, p_out);

    fclose(p_read);
    fclose(p_out);
}