// fbat.c
//
// Date   : 2018-04-18
// Author : Felix Naredi
//


#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>


#define FBAT_DIR "/sys/class/power_supply/BAT0"

#define FBAT_ALARM_INDEX 0
#define FBAT_NOW_INDEX   1

#define FBAT_INDEX_COUNT 2


static int __fbat_valid_content(const char *buf, int len)
{
	const char valid_chars[] = {
		'0', '1', '2', '3', '4',
		'5', '6', '7', '8', '9',
	};
	int i = 0;
	
	while (i < len &&
	       buf[i] != '\0' &&
	       buf[i] != '\n')	       
	{
		int j, b = 0;

		for (j = 0; j < sizeof(valid_chars); j++)
			b |= buf[i] == valid_chars[j];

		if (!b)
			return 0;

		i++;
	}

	return i;
}
		

static int __fbat_alarm()
{
	char bufs[FBAT_INDEX_COUNT][32];
	int fd, i;

	for(i = FBAT_ALARM_INDEX; i < FBAT_INDEX_COUNT; i++) {
		int len, vlen;
		char *buf = bufs[i];

		switch (i) {
		case FBAT_ALARM_INDEX:
			fd = open(FBAT_DIR "/alarm", O_RDONLY);
			break;
		case FBAT_NOW_INDEX:
			fd = open(FBAT_DIR "/energy_now", O_RDONLY);
			break;
		default:
			return 0;
		}

		len = read(fd, buf, sizeof(bufs[i]));
		vlen = __fbat_valid_content(buf, len);
			
		if (!vlen) {
			printf("WARING: failed reading alarm status\n");
			close(fd);
			return 0;
		}

		close(fd);
	}

	return strtol(bufs[FBAT_ALARM_INDEX], NULL, 10) >=
		strtol(bufs[FBAT_NOW_INDEX], NULL, 10);
}

int
main(int argc, char *argv[])
{
	char buf[32];
	int fd, len;

	fd = open(FBAT_DIR "/capacity", O_RDONLY);
	len = read(fd, buf, sizeof(buf));

	if (!__fbat_valid_content(buf, len)) {
		printf("ERROR: failure accured when reading battery capacity\n");
		close(fd);
		return 1;
	}
	close(fd);

	if (buf[len - 1] == '\n')
		buf[len - 1] = '\0';

	printf("%s%%%s\n", buf, __fbat_alarm() ? " - (!)" : "");

	return 0;
}
