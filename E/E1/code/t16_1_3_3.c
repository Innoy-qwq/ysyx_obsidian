#include <stdio.h>

unsigned int rotate_right(unsigned int x)
{
	return x >> 1 | x << 31;
};

int main()
{
	printf("%x\n", rotate_right(9));
}