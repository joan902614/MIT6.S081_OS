#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"

void addArgv(char *new_argv[], int *argc)
{
	char buf[512];
	int c = 0; 
	while(read(0, buf + c, 1) != 0)
	{
		if(c > 512)
		{
			fprintf(2, "Error: addition argument too long\n");
			exit(1);
		}
		// put buf into argv and initalize buf 
		if(*(buf + c) == ' ' || *(buf + c) == '\n')
		{
			*(buf + c) = '\0';
			(*argc)++; 
			new_argv[*argc - 1] = malloc(sizeof(strlen(buf) + 1));
			strcpy(new_argv[*argc - 1], buf);
			memset(buf, '\0', c);
			c = 0;
		}
		else
			c++;
	}
	return;
}

int main(int argc, char *argv[])
{
	if(argc <= 1)
	{
		fprintf(2, "Usage: xargs [command]\n");
		exit(1);
	}
	char *new_argv[MAXARG];
	int new_argc = argc - 1;
	for(int i = 1; i < argc; i++)
	{
		new_argv[i - 1] = malloc(sizeof(strlen(argv[i]) + 1));
		strcpy(new_argv[i - 1], argv[i]);
	}
	addArgv(new_argv, &new_argc);
	if(fork() == 0)
	{
		exec(new_argv[0], new_argv);
		fprintf(2, "Error: failed to exec\n");
		exit(1);
	}
	else
	{
		wait(0);
	}
	exit(0);
}
