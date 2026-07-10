#include <stdio.h>
#include <stdlib.h>

typedef struct node *link;
struct node {
	unsigned char item;
	link next;
};

static link head = NULL;

link make_node(unsigned char item)
{
	link p = malloc(sizeof *p);
	p->item = item;
	p->next = NULL;
	return p;
}


void insert(link p)
{
	p->next = head;
	head = p;
}


void delete(link p)
{
	link pre = p;
	while (pre->next != p)
    {
        pre = pre->next;   
    }
    pre->next = p->next;
    free(p);
}

int node_left_two(link p){
    if (p == p->next->next) return 1;
    else return 0;
}


void print_game(int M, link p){
    link q;
    int count = 1;
    while (!node_left_two(p)){
        if (count == M){
            q = p;
            p = p->next;
            count = 1;

            printf("%d号被杀死\n", q->item);
            delete(q);
        }
        else{
            p = p->next;
            count++;
        }
    }
    printf("生还者: %d号\n", p->item);
    printf("生还者: %d号\n", p->next->item);
}


int main(int argc, char *argv[])
{
    int N = atoi(argv[1]);
    int M = atoi(argv[2]);

    for (int i = N; i>0; i--){
        insert(make_node(i));
    }
    
    /* 构造环形链表*/
    link last = head;
    while (last -> next){
        last  = last -> next;
    }
    last->next = head;

    print_game(M, head);

   return 0;
}