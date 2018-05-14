// screenshot_path.c
//
// Date: 2018-05-13 12:10:04 +0200
// Author: Felix Naredi
//

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define DEFAULT_PATH "~/"
#define DEFAULT_PREFIX "Screenshot"

static int geturl(
	char *des,
	const char *url,
	const char *prefix
) {
	time_t now;
	struct tm *localnow;
	char buf[128];	

	now = time(NULL);
	localnow = localtime(&now); 

	strftime(buf, sizeof(buf), "%Y-%m-%d_%H-%M-%S", localnow);
	return sprintf(des, "%s%s_%s.jpg", url, prefix, buf);
}

int main(int argc, char *argv[])
{
	char buf[256];
	int n;

	n = sprintf(buf, "import -window root ");
	if(n < 0)
		return -1;	
	if(geturl(&buf[n],
		  argc < 2 ? DEFAULT_PATH : argv[1],
		  argc < 3 ? DEFAULT_PREFIX : argv[2])
	   < 0)
		return -1;
	
	system(buf);
	
	return 0;
}
