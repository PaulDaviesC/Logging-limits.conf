#include<stdio.h>
#include<fcntl.h>
#define NOFILE 30
int main()
{
	int fd,i;
	char filename[20];
	for(i=0;i<NOFILE;i++){
		sprintf(filename,"%d",i);
		umask(0);
		fd=open(filename,O_CREAT,0777);
		if(fd<0)
			perror("open");
		else
			close(fd);
	}
	for(i=0;i<NOFILE;i++){
		sprintf(filename,"%d",i);
		if(open(filename,O_RDONLY)<0)
			perror("open");
	}
	for(i=0;i<NOFILE;i++){
		close(3+i);
		sprintf(filename,"%d",i);
		remove(filename);
	}
}
