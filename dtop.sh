#!/bin/sh

dtrace -x aggsortrev -q -n '

#pragma D option dynvarsize=128m
#pragma D option aggsize=16m

sched:::on-cpu
{
	self->ts = timestamp;
}

sched:::off-cpu
/self->ts/ {
	@data[pid, tid, cpu, curthread->td_name, execname] = sum(timestamp - self->ts);
}

tick-2sec
{
	printf("\n");
	trunc(@data, 50);
	printa("%@8u\t%d\t%d\t%d\t%s\t%s\n", @data);
	clear(@data);
}
' | awk -F'\t' -v dead=$1 '
	BEGIN {
		system("clear");
		printf("%-6s %12s %7s %7s %15s %21s\n", "% CPU", "PID", "TID", "CPU", "thread_name", "proc_name");
	}
	
	length == 0 {
		system("clear");
		printf("%-6s %12s %7s %7s %15s %21s\n", "% CPU", "PID", "TID", "CPU", "thread_name", "proc_name");
		next;
	}

	{
		p = $1 * 100 / 2000000000;
	}

	{
		state = 0;
	}

	length != 0 && $2 > 100 && dead {
		state = system("procstat " $2 " >/dev/null 2>&1");
	}

	{ 
		if(state != 0) {
			printf("%f\t%d\t%d\t%d\t%-20s\t%s (dead)\n", p, $2, $3, $4, $5, $6);
		}
		else {
			printf("%f\t%d\t%d\t%d\t%-20s\t%s\n", p, $2, $3, $4, $5, $6);
		}
	}
	'
