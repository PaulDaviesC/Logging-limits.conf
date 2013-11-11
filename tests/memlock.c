#include<stdio.h>
#include<sys/mman.h>
#define MEMLOCK 65 //A value greater than MEMLOCK limit in the KB
int main()
{
	int *a=(int *)malloc(sizeof(int)*MEMLOCK*1000);
	if(mlockall(MCL_CURRENT|MCL_FUTURE)<0)
		perror("mlocakall");
}
