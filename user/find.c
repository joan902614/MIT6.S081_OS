#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

void find(char *path, char *name)
{
	int fd;
	char *p, buf[512];
	struct stat st;
	struct dirent de;
	if((fd = open(path, 0)) < 0)
	{
		fprintf(2, "Error: can't open %s\n", path);
		exit(1);
	}
	if(fstat(fd, &st) < 0)
	{
		fprintf(2, "Error: can't state %s\n", path);
		exit(1);
	}
	switch(st.type)
	{
		case T_FILE:
			// find filename
			for(p = path + strlen(path) - 1; p >= path && *p != '/'; p--);
			p++;	
			if(strcmp(p, name) == 0)
			{
				fprintf(1, "%s\n", path);
			}
		break;
		case T_DIR:
			// find directory name
			for(p = path + strlen(path) - 1; p >= path && *p != '/'; p--);
			p++;	
			if(strcmp(p, name) == 0)
			{
				fprintf(1, "%s\n", path);
			}
			if(strlen(path) + 1 + DIRSIZ + 1 > sizeof(buf))
			{
      			printf("Error: path too long\n");
      			break;
   			}
			/* dirent pointer to files in directory
			   dirent.inum -> inode number
			   dirent.name -> file name*/
			while(read(fd, &de, sizeof(de)) == sizeof(de))
			{
				if(de.inum == 0)
					continue;
				if(strcmp(de.name, ".") != 0 && strcmp(de.name, "..") != 0)
				{
					// update path
					strcpy(buf, path);
					p = buf + strlen(buf);
					*p = '/';
					p++;
					memmove(p, de.name, DIRSIZ);
					p = buf + strlen(buf);
					*p = '/';
					*(p++) = '\0';
					find(buf, name);	
				}
			}
		break;
	}
	close(fd);
	return;	
}


int main(int argc, char *argv[])
{
	if(argc != 3)
	{
		fprintf(2, "Usage: find [path] [pattern]\n");
		exit(1);
	}
	for(int i = 2; i < argc; i++)
		find(argv[1], argv[2]);
	exit(0);
}
