#include <stdio.h>
#include <stdlib.h>

int Euclid_while(int a,int b){
	while (a%b){
		a = a + b;
		b = a - b;
		a = a - b;
		b = b%a;
	}
	return b;
}


int main(void){
	int a = 24;
	int b = 15;
	a = abs(a);
	b = abs(b);
	printf("%d", Euclid_while(a, b));
}