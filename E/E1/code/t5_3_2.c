#include <stdio.h>

int Fibonacci(int n){
if (n<=1) return 1;
else return Fibonacci(n-1)+Fibonacci(n-2);
}

int main(void){
	printf("%d", Fibonacci(5));
}