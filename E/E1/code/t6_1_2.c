#include <stdio.h>

int main(void){
	int i = 1;
	int count = 0;
	while (i<=100){
		if (i%10 == 9) count++;
		if ((int)(i/10) == 9) count++;
		i++;
	}
	printf("%d\n", count);
}