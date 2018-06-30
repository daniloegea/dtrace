#!/bin/sh

dtrace -x aggsortrev -q -n '

sched:::on-cpu
{
	self->ts = timestamp;
}

sched:::off-cpu
/self->ts/ {
	@data[pid, curthread->td_name, execname] = sum(timestamp - self->ts);
}

tick-1sec
{
	printf("\n");
	trunc(@data, 50);
	printa("%@8u\t%d\t\t%s\t\t\t%s\n", @data);
	clear(@data);
}
' | awk '
	BEGIN {
		system("clear");
		printf("%% CPU\t\tPID\t\t\ttd_name\tproc_name\n");
	}
	
	length == 0 {
		system("clear");
		printf("%% CPU\t\tPID\t\t\ttd_name\tproc_name\n");
		next;
	}

	{
		p = $1 * 100 / 1000000000;
	}

	{ 
		printf("%f\t%d\t%20s\t%s\n", p, $2, $3, $4);
	}
	'
