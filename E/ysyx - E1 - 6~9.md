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
int printStruct(struct complex_struct z){ // 复数运算层

    if(z.x&&z.y) printf("%.2f+%.2fi", real_part(z), img_part(z));

    else if (z.x) printf("%.2f", real_part(z));

    else if (z.y) printf("%.2fi", img_part(z));

    else printf("0");

}
```

2、实现一个用分子分母的格式来表示有理数的结构体`rational`以及相关的函数，`rational`结构体之间可以做加减乘除运算，运算的结果仍然是`rational`。注意要约分为最简分数，例如1/8和-1/8相减的打印结果应该是1/4而不是2/8，可以利用[第 3 节 “递归”](https://akaedu.github.io/book/ch05s03.html#func2.recursion)练习题中的Euclid算法来约分。在动手编程之前先思考一下这个问题实现了什么样的数据抽象，抽象层应该由哪些函数组成。

答：代码见文件struct_qe2.c![[struct_qe2.c]]

### 数据类型标志

这里主要是提到了枚举类型(enum)，值得注意的是enum的成员名和变量名是在同一命名空间的。

#### 习题：

1、本节只给出了`make_from_real_img`和`make_from_mag_ang`函数的实现，请读者自己实现`real_part`、`img_part`、`magnitude`、`angle`这些函数。

答：代码如下：
```c
double real_part(struct complex_struct x)
{
    if (x.t == RECTANGULAR)
        return x.a;
    else
        return x.a*cos(x.b);
}

double img_part(struct complex_struct x)
{
    if (x.t == RECTANGULAR)
        return x.b;
    else
        return x.a * sin(x.b);
}

double magnitude(struct complex_struct x)
{
    if (x.t == POLAR)
        return x.a;
    else
        return sqrt(x.a * x.a + x.b * x.b);
}

double angle(struct complex_struct x)
{
    if (x.t == POLAR)
        return x.b;
    else
        return atan2(x.b, x.a);
}
```


2、编译运行下面这段程序：

```c
#include <stdio.h>

enum coordinate_type { RECTANGULAR = 1, POLAR };

int main(void)
{
	int RECTANGULAR;
	printf("%d %d\n", RECTANGULAR, POLAR);
	return 0;
}
```

结果是什么？并解释一下为什么是这样的结果。

答：结果是`0 2`, 由于`RECTANGULAR`在变量命名空间内，所以`int RECTANGULAR;` 将值初始化为0了。而POLAR因为编译器的自动幅值，沿着`RECTANGULAR = 1`后续赋值为2。

## 数组

### 基本概念

有几点需要注意的是：

>后缀++的优先级最高，因为它要++的对象需要在刚开始就确定。但side effect却是语句结束前发生的，也就是说side effect和优先级是两码事。这也可知后缀++的左值是不变的。

>数组访问越界发生在运行时，而且也不一定立即发生错误。这一点导致的现象我们是清楚的：指针访问可以越界意味着如果我们对内存的地址排布非常清楚，是可以做一些取巧的操作（尽管并不推荐这样做，而且地址是可以被操作系统切碎的）

>从可变数组看待c语言中的动态、静态：所谓静态和动态，大概是编译和运行时的区别，比如可变数组是运行时所以就是动态，它的大小可以不在写代码时就确定。虽然按照直觉感觉还是VUE的响应式编程更“动态”。

还有几种比较奇特的数组的初始化语法：

```c
int count[4] = { 3, 2, };

int count[] = { 3, 2, 1, };

int count[4] = { [2] = 3 };
```

但注意数组不能相互赋值、初始化，这一点结构体是可以做到的。

>既然不能相互幅值，初始化，那么数组实际上也不能作为函数的返回值和参数。但是特殊的语法规则规定：数组类型作为参数/返回值时，构造的是指向首字母的指针类型。

#### 习题：

1、编写一个程序，定义两个类型和长度都相同的数组，将其中一个数组的所有元素拷贝给另一个。既然数组不能直接赋值，想想应该怎么实现。

```c
int a[4] = {1,2,3,4};
int b[4];

int main(void)
{
	int i = 0;
	for(i; i<4; i++)
	{
		b[i] = a[i];
		printf("%d\n", b[i]);
	}
}
```

### 宏定义

>值得注意的是，宏定义的内容实际上并不是c语言的关键字，也就是说你是可以把include，define作为变量名使用的，这也是理所当然的，毕竟预处理阶段已经把内容给换了。

#### 习题：

1、用`rand`函数生成[10, 20]之间的随机整数，表达式应该怎么写？
答：rand()%10+10

#### 习题：

1、补完本节直方图程序的`main`函数，以可视化的形式打印直方图。

```c
#define N 20

int a[N];
int i, histogram[10] = {0};

void gen_random(int upper_bound)
{
	int i;
	for (i = 0; i < N; i++)
		a[i] = rand() % upper_bound;
}

void print_random()
{
	int i = 0, j = 0;
	
	for (i = 0; i < 10; i++) //i作为临时变量先打印0~9
		printf("%d ", i);
	printf("\n");

	int max = 0;
	for (i = 0; i < 10; i++) //i作为临时变量找最大值
		if (histogram[i] > max) 
			max = histogram[i]; 

	i = 1;
	while(i<=max) // i作为行数
	{
		for (j = 0; j < 10; j++) //j作为列数 
			if (histogram[j]>=i) printf("* ");
			else printf("  ");
		printf("\n");
		i++;
	}
	
}

int main(void)
{
	gen_random(10);
	for (i = 0; i < N; i++)
		histogram[a[i]]++;
	print_random();
}
```

2、
(1) 定义一个数组，编程打印它的全排列。

答：关键双循环：外部i循环和内部start循环。i循环提供了横向的每一层树的循环，start循环提供了纵向的每条通道的循环。减少i循环相当于删除一侧的通道，让每个节点的子节点减少，或者说使得一部分不参与循环。而减少start循环相当于删除一层深度，或者说减少一轮变换次数。
```c
#define N 4

void print_arr(int a[N])
{
	int i = 0;
	for (i; i < N; i++)
		printf("%d ", a[i]);
	printf("\n");
}

void exchange(int a[N], int p1, int p2)
{
	int t = a[p1];
	a[p1] = a[p2];
	a[p2] = t;
}

void get(int a[N], int start)
{
	if (start == N - 1)
	{
		print_arr(a);
		return;
	}

	int i;
	for (i=start; i < N; i++)
	{
		exchange(a, start, i);
		get(a, start + 1);
		exchange(a, start, i);
	}
}

int main(void)
{
	int a[N] = {1, 2, 3, 4};
	get(a, 0);
}
```

(2) 如果再定义一个常量`M`表示从`N`个数中取几个数做排列（`N == M`时表示全排列），原来的程序应该怎么改？

答：define一个M，将start循环（或者说递归？）的条件改为`start == M-1`，减少一层深度就减少了最后一轮变换，

(3) 如果要求从`N`个数中取`M`个数做组合而不是做排列，就不能用原来的递归过程了，想想组合的递归过程应该怎么描述，编程实现它。

答：