#!/usr/sbin/dtrace -s

syscall:freebsd:dup2:entry {
    printf("DUP2: %d (pid) - %d (old fd) -> %d (new fd)", pid, arg0, arg1);
}
