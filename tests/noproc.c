//Test c program to test log noproc.Compile it and run it.
#include<stdio.h>
int main()
{
	int i=0;
	for(i=0;i<25;i++){
		if(fork()<0)
			perror("fork");
	}
}
