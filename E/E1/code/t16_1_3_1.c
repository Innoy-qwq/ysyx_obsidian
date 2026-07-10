#include <stdio.h>

// 实际上我们在11章已经用过类似的位运算函数了
int countbit(unsigned int x)
{
	int count = 0;
	while(x){		
		if (x&1) count++;
		x >>= 1;
	}
	return count;
};

int main()
{
	printf("%d\n", countbit(7));
}