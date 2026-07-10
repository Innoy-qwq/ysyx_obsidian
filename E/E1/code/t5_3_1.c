#include <stdio.h>
#include <stdlib.h>
int Euclid(int a,int b){

	if (!(a%b)) return b;
	else Euclid(b, a%b);
}

int main(void){
	int a = 24;
	int b = 15;
	a = abs(a);
	b = abs(b);
	printf("%d", Euclid(a, b));
}