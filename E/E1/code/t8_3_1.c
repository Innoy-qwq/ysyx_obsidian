#include <stdio.h>
#include <stdlib.h>
#define N 20

int a[N];
int i, histogram[10] = {0};

void gen_random(int upper_bound)
{
	int i;
	for (i = 0; i < N; i++)
		a[i] = rand() % upper_bound;
}

void print_random()
{
	int i = 0, j = 0;
	
	for (i = 0; i < 10; i++) //i作为临时变量先打印0~9
		printf("%d ", i);
	printf("\n");

	int max = 0;
	for (i = 0; i < 10; i++) //i作为临时变量找最大值
		if (histogram[i] > max) 
			max = histogram[i]; 

	i = 1;
	while(i<=max) // i作为行数
	{
		for (j = 0; j < 10; j++) //j作为列数 
			if (histogram[j]>=i) printf("* ");
			else printf("  ");
		printf("\n");
		i++;
	}
	
}

int main(void)
{
	gen_random(10);
	for (i = 0; i < N; i++)
		histogram[a[i]]++;
	print_random();
}