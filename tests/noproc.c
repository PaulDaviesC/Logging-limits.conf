//Test c program to test log noproc.Compile it and run it.#include<stdio.h>
//Set NOPROC to a value greater than the one in limits.conf. 
#define NOPROC 25
int main()
{
	int i=0;
	for(i=0;i<NOPROC;i++){
		if(fork()<0)
			perror("fork");
	}
}
