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


void reverse(void){
    link q = head->next;
    link p = head->next->next;

    head->next = NULL;

    while (p->next){    
    q->next = head;
    head = q;
    q = p;
    p = p->next;       
    }
        
    q->next = head;
    p->next = q;
    head = p;
}


int main()
{
    insert(make_node('a'));
    insert(make_node('b'));
    insert(make_node('c'));
    insert(make_node('d'));

    printf("before reverse:\n");

    link p = head;
    while (p)
    {
        printf("%c ", p->item);
        p = p->next;
    }
    printf("\n");


    reverse();


    printf("after reverse:\n");

    p = head;
    while (p)
    {
        printf("%c ", p->item);
        p = p->next;
    }
    printf("\n");

    return 0;
}