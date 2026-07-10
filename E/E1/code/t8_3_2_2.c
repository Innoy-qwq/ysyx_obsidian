#include <stdio.h>
#define N 5
#define M 2

void print_arr(int a[N])
{
    int i = 0;
    for (i; i < N; i++)
        printf("%d ", a[i]);
    printf("\n");
}

void get(int a[N], int start, int c)
{
    if (c == M)
    {
        print_arr(a);
        return;
    }

    int i;
    for (i = start; i < N; i++)
    {
        int p1 = a[i];
        a[i] = 0;
        get(a, i + 1, c + 1);
        a[i] = p1;
    }
}

int main(void)
{
    int a[N] = {1, 2, 3, 4, 5};
    get(a, 0, 0);
}