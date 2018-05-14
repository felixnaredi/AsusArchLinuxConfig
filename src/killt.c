// killt.c
//
// Author : Felix Naredi
// Date   : 2017-11-22
//
// Killt is a program that kills the process it was called from.
//

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <signal.h>


static int __pidfd(int pid, const char *file)
{
	char buf[128];

	snprintf(buf, sizeof(buf), "/proc/%d/%s", pid, file);
	return open(buf, O_RDONLY);
}

static int __fdstrncpy(int fd, char *buf, int len)
{
	int n;

	n = read(fd, buf, len - 1);
	if (n < 1)
		return -1;

	buf[n] = '\0';

	return n;
}

static char *__sngetline(char *buf, char *line, int len)
{
	int i = 0;

	while(len) {
		if (buf[i] == '\n') {
			line[i] = '\0';
			break;
		}		
		if (buf[i] == EOF) {
			line[i] = '\0';
			return NULL;
		}
		
		line[i] = buf[i];	       
		
		i++;
		len--;
	}

	return &buf[i + 1];
}

static size_t __pidstat(int pid, const char *stat, const char *type, void *des)
{
	char term[32], buf[2048], *bp;
	int fd;

	fd = __pidfd(pid, "status");
	if (fd < 0)
		return -1;

	if (__fdstrncpy(fd, buf, sizeof(buf)) < 0) {
		close(fd);
		return -1;
	}
	close(fd);
	
	snprintf(term, sizeof(term), "%s: %s", stat, type);

	bp = buf;
	do {
		char line[64];
		int n;

		bp = __sngetline(bp, line, sizeof(line));

		n = sscanf(line, term, des);
		if (n > 0)
			return n;
	} while(bp);

	return 0;
}

static int __toppid(int pid)
{
	int ppid;

	__pidstat(pid, "PPid", "%d", &ppid);

	if (ppid > 1)
		return __toppid(ppid);

	return pid;
}

int main(int argc, char *argv[])
{
	char name[32], syscall[64];
	int pid;

	pid = __toppid(getpid());
	kill(pid, SIGTERM);
	
	return 0;
}
