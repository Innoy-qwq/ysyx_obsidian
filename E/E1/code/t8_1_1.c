#include <stdio.h>

int a[4] = {1,2,3,4};
int b[4];

int main(void)
{
	int i = 0;
	for(i; i<4; i++)
	{
		b[i] = a[i];
		printf("%d\n", b[i]);
	}
}