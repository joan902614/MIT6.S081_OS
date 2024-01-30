#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
	if(argc != 2)
	{
		fprintf(2, "Usage: sleep integer...\n");
		exit(1);
	}
	for(int i = 0; i < strlen(argv[1]); i++)
	{
		if(!('0' <= argv[1][i] && argv[1][i] <= '9'))
		{
			fprintf(2, "Usage: sleep integer...\n");
			exit(1);
		}
	}
	int time = atoi(argv[1]);
	sleep(time);
	exit(0);
}
