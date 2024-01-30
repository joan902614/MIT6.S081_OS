#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char const *argv[])
{
	if(argc > 1)
	{
		fprintf(2, "Usage: pingpong\n");
		exit(1);
	}
	int pid;
	int p[2];
	pipe(p);
	char buf[2] = "p";

	if(fork() == 0) 
	{
		pid = getpid();
		// child read
		if(read(p[0], buf, 1) != 1)
		{
			fprintf(2, "Error: failed to read in child\n");
			exit(1);
		}
		close(p[0]);
		fprintf(1, "%d: received ping\n", pid);
		// child write
		if(write(p[1], buf, 1) != 1)
		{
			fprintf(2, "Error: failed to write in child\n");
			exit(1);
		}
		close(p[1]);
		exit(0);
	}
	else
	{
		pid = getpid();
		// parent read
		if (write(p[1], buf, 1) != 1)
		{
			fprintf(2, "Error: failed to write in parent\n");
			exit(1);
		}
		close(p[1]);
		wait(0); // must wait because parent read after write
		// parent write
		if(read(p[0], buf, 1) != 1)
		{
			fprintf(2, "Error: failed to read in parent\n");
			exit(1);
		}
		fprintf(1, "%d: received pong\n", pid);
		close(p[0]);
		exit(0);
	}
}
