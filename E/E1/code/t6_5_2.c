#include <stdio.h>
#include <stdlib.h>

int diamond(int size, char sign){
	if (!size%2) printf("请输入奇数");
	else{
		int i, j;
		for (i=1; i<=size; i++){
			for (j=1; j<=size; j++)
				if (j<=abs((size+1)/2-i) || j>size-abs((size+1)/2-i)) printf(" ");
				else printf("%c", sign);
			printf("\n");
			}
	}
	return 0;
}

int main(void)
{
	diamond(5, '+');
	return 0;
}