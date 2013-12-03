/*Program to test rlimit. This program tests the failure of setrlimit only.
 * This is enough since it holds good for other resources too. Set AS_MAX to a
 * value higher than what you have set. If you need to test with other
 * resources change the argument to setrlimit sys call accordingly.
*/
#include<stdio.h>
#include<sys/resource.h>
#define AS_MAX 1000000
int main()
{
	struct rlimit lim;
	lim.rlim_max=AS_MAX;
	if(setrlimit(RLIMIT_AS,&lim)<0)
		perror
}
