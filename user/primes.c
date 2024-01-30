#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void newNode(int parent_p[])
{
	if(fork() == 0)
	{
		close(parent_p[1]); // no write from parent_p
		int pline[2];
		pipe(pline);
		int p, n, next = 0, test = 4; 
		if(read(parent_p[0], &p, 4) != 4)
		{
			fprintf(2, "Error: failed to read\n");
			exit(1);
		}
		fprintf(1, "prime %d\n", p);
		while(test == 4)
		{
			test = read(parent_p[0], &n, 4);
			if(test != 4 && test != 0)
			{
				fprintf(2, "Error: failed to read\n");
				exit(1);
			}
		    if(n % p != 0)
			{
				// next for check whether child or not
				if(next == 0)
				{
					newNode(pline);
					next = 1;
				}
				if(write(pline[1], &n, 4) != 4)
				{
					fprintf(2, "Error: failed to write %d\n", n);
					exit(1);
				}	
			}
		}	
		close(pline[1]);
		wait(0);
		exit(0);
	}
	else
	{	
		close(parent_p[0]); // close own read or not close is find
		return;
	}
}

int main(int argc, char *argv[])
{
	if(argc > 1)
	{
		fprintf(2, "Usage: primes\n");
		exit(1);
	}
	// first process 
	int pline[2];	
	pipe(pline);
	fprintf(1, "prime 2\n"); 
	int next = 0;
	for(int n = 3; n <= 35; n++)
	{
		if(n % 2 != 0)
		{
			if(next == 0)
			{
				newNode(pline);
				next = 1;
			}		
			if(write(pline[1], &n, 4) != 4)
			{
				fprintf(2, "Error: failed to write %d\n", n);
				exit(1);
			}
		}
	}
	close(pline[1]);
	wait(0);
	exit(0);
}
