#include <stdio.h>
#define N 4

void print_arr(int a[N])
{
	int i = 0;
	for (i; i < N; i++)
		printf("%d ", a[i]);
	printf("\n");
}

void exchange(int a[N], int p1, int p2)
{
	int t = a[p1];
	a[p1] = a[p2];
	a[p2] = t;
}

void get(int a[N], int start)
{
	if (start == N - 1)
	{
		print_arr(a);
		return;
	}

	int i;
	for (i=start; i < N; i++)
	{
		exchange(a, start, i);
		get(a, start + 1);
		exchange(a, start, i);
	}
}

int main(void)
{
	int a[N] = {1, 2, 3, 4};
	get(a, 0);
}