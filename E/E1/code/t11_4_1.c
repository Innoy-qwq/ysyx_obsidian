#include <stdio.h>

int a[] = {3, 6, 8, 10, 1, 2, 1};

void swap(int i, int j)
{
	int temp = a[i];
	a[i] = a[j];
	a[j] = temp;
}
int partition(int start, int end)
{
	int i = start, j = start - 1;
	int pivot = end; 

	// i作为遍历，j作为比a[pivot]大或者小的分界, pivot指代要选取的值的位置
	while (i <= end){
		// 遇到比pivot小的数，就把数扔到左边，然后j往前推进一格。j保证了一个锁定功能,确保了j自身以及前面的绝对是小于a[pivot]的
		if (a[i] < a[pivot]){
			j++;
			swap(i, j);
		} 
		i++;
	}
	swap(pivot, j+1);
	return j+1;
}

void quicksort(int start, int end)
{
	int mid;
	if (end > start) {
		mid = partition(start, end);
		quicksort(start, mid-1);
		quicksort(mid+1, end);
	}
}

int main()
{
    int n = sizeof(a) / sizeof(a[0]);
    quicksort(0, n-1);
	for (int i = 0; i < n; i++){
		printf("%d ", a[i]);
	}
    return 0;
}