//Test c program to test log noproc.Compile it and run it.This program assumes that noproc <25.
#include<stdio.h>
#define NOPROC
int main()
{
	int i=0;
	for(i=0;i<NOPROC;i++){
		if(fork()<0)
			perror("fork");
	}
}
