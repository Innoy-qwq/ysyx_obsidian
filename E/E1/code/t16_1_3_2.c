#include <stdio.h>

unsigned int multiply(unsigned int x, unsigned int y)
{
	int i = 0; //代表位数
	while (y)
	{
		if (y&1) x <<= i;
		y >>= 1;
		i++;
	}
	return x;
}

int main()
{
	printf("%d\n", multiply(7, 8));
}