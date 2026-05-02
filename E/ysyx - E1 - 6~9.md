#c
由于内容比较多所以分开了几个部分，今天我们继续复健一下c。

---
## 循环语句

>for 循环中加入变量初始化是C99加入的特性，其中的初始化变量属于局部变量，可以节省一点空间，但考虑到兼容性不建议使用此语法。

这一部分没有什么要特别注意的冷知识，直接进入习题吧。
#### 习题：
1、编写循环函数求两个正整数`a`和`b`的最大公约数（GCD，Greatest Common Divisor），使用Euclid算法：如果`a`除以`b`能整除，则最大公约数是`b`。否则，最大公约数等于`b`和`a%b`的最大公约数。

>代码如下
```c
int Euclid_while(a, b){
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

```

2、编写递归函数求Fibonacci数列的第`n`项，这个数列是这样定义的：
fib(0)=1  
fib(1)=1  
fib(n)=fib(n-1)+fib(n-2)

>代码如下
```c
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
```

3、编写程序数一下1到100的所有整数中出现多少次数字9。

>代码如下。
```c
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
```

#### 习题：
1、求素数这个程序只是为了说明`break`和`continue`的用法才这么写的，其实完全可以不用`break`和`continue`，请读者修改一下控制流程，去掉`break`和`continue`而保持功能不变。

>代码如下
```c
int is_prime(int n)
{
	int i;
	for (i = 2; i < n; i++)
		if (n % i == 0)
		if (i == n)
			return 1;
		else
			return 0;
}

int main(void)
{
	int i;
	for (i = 1; i <= 100; i++) {
		if (is_prime(i)) printf("%d\n", i);
	}
	return 0;
}
```

2、上一节讲过怎样把`for`循环改写成等价的`while`循环，但也提到如果循环体中有`continue`语句这两种形式就不等价了，想一想为什么不等价了？

>答：while循环中的步进在循环体内完成，而for循环在循环体外完成，若有continue则for循环会先步进再判断，而while循环会先进入循环再步进。

#### 习题：
1、打印小九九

>代码如下
```c
int main(void){
	int i, j;
		for (i=1; i<=9; i++) {
			for (j=1; j<=9; j++)
				if (i<j) continue;
				else printf("%d  ", i*j);
			printf("\n");
		}
		return 0;
}
```

2、编写函数`diamond`打印一个菱形。如果调用`diamond(3, '*')`则打印A。如果调用`diamond(5, '+')`则打印B，如果用偶数做参数则打印错误提示。AB图形见讲义。

>代码如下
```c
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
```

## 结构体

这一部分可能要注意的是：
1. {}不能用于结构体的赋值，因为它不属于表达式。一般应该也不会有人这样做。
2. Designated Initializer在C99被引入，其初始化可以这样：`{struct A z1 = .y = 4.0 }`
3. 结构体之间可以相互初始化和赋值，想一想这一点是理所应当的，毕竟函数返回需要建立一个临时变量，如果结构体不能直接用于初始化，就不能当返回值使用了。


进入习题吧。
#### 习题：
1、在本节的基础上实现一个打印复数的函数，打印的格式是x+yi，如果实部或虚部为0则省略，例如：1.0、-2.0i、-1.0+2.0i、1.0-2.0i。最后编写一个`main`函数测试本节的所有代码。想一想这个打印函数应该属于上图中的哪一层？

```c


```