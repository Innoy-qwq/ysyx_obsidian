#include <stdio.h>

int Fibonacci(int n){
	int i = 0;
	int temp1 = 1;
	int temp2 = 1;
	while (i <= n - 2){
		temp1 = temp1 + temp2;
		temp2 = temp1 - temp2;
		i++;
	}
	return temp1;
}

int main(void){
	printf("%d", Fibonacci(5));
}