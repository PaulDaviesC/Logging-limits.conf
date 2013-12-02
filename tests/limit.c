/* Program to test the setrlimit. This program tests the the setrlimit. In
 * this case we just test by setting the RLIMIT_AS higher than the limit that
 * we have set. So set the AS_MAX macro to a value higher than what you have
 * capped.
*/
#include<stdio.h>
#include<sys/resource.h>
#define AS_MAX 900000000
int main()
{
	struct rlimit lim;
	lim.rlim_cur=AS_MAX;
	lim.rlim_max=AS_MAX;
	if(setrlimit(RLIMIT_AS,&lim)<0)
		perror("setrlimit");
}
