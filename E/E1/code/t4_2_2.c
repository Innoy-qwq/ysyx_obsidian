#include <stdio.h>

int printx(int x){
	printf("%d\n", x%10);
	printf("%d\n", x/10%10);
	return 0;
}
int main(void){
	printx(123);
}