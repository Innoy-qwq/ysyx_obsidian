#include <stdio.h>
#include <math.h>

/*  这里只给最朴素的实现, 其他实现见笔记部分*/
double myround(double x){
	if(x>=0)
		if ((int)(x*10)%10>=5) 
			return ceil(x);
		else 
			return floor(x);
	else
		if ((int)(x*10)%10>=-5) 
			return ceil(x);
		else 
			return floor(x);
}

int main(void){
	printf("%.0f\n", myround(-3.6));
} 