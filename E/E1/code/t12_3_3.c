#include <stdio.h>

#define MAX_ROW 5
#define MAX_COL 5

struct point{
	int row, col;
};

int maze[MAX_ROW][MAX_COL] = {
	0,1,0,0,0,
	0,1,0,1,0,
	0,0,0,0,0,
	0,1,1,1,0,
	0,0,0,1,0,
};

void print_maze(void)
{
	int i, j;
	for (i = 0; i < MAX_ROW; i++)
	{
		for (j = 0; j < MAX_COL; j++)
			printf("%d ", maze[i][j]);
		putchar('\n');
	}
	printf("*********\n");
}

int visit(struct point p)
{
	maze[p.row][p.col] = 2;
	if (p.row == MAX_ROW - 1 && p.col == MAX_COL - 1){
		print_maze();
		return 1;
	}

	print_maze();
	struct point next;

	if (p.col + 1 < MAX_COL /* right */
		&& maze[p.row][p.col + 1] == 0){
		next = p;
		next.col++;
		if (visit(next)) return 1;
		}

	if (p.row + 1 < MAX_ROW /* down */
		&& maze[p.row + 1][p.col] == 0){
		next = p;
		next.row++;
		if (visit(next)) return 1;
		}

	if (p.col - 1 >= 0 /* left */
		&& maze[p.row][p.col - 1] == 0){
		next = p;
		next.col--;
		if (visit(next)) return 1;
		}

	if (p.row - 1 >= 0 /* up */
		&& maze[p.row - 1][p.col] == 0){
		next = p;
		next.row--;
		if (visit(next)) return 1;
		}
	return 0;
}

int main(void)
{
	struct point p = {0, 0};
	int ans = visit(p);
	if (ans)
		printf("System Survey Complete.\n");
	else
		printf("Scientific breakthrough impossible: No viable path detected.\n");
	return 0;
}