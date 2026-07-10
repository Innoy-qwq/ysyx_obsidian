#include <stdio.h>

// 递归版本,至少传3个量，负责计数、算子a，算子b
double mypow(double x, int n, double result)
{

	if ( n&1 ) result *= x; // 判断对应位是不是0，如果是0则跳过，是1则乘上去。
	x *= x; // 每一次升高位，x都变为x的对应位次方
	n >>= 1; //移位

	if (!n) return result;
	mypow(x, n, result);
}

int main(void)
{
	printf("%f\n", mypow(2.8, 3, 1));
	return 0;
}