#!/usr/sbin/dtrace -s

syscall:freebsd:thr_new:entry {
    p0 = (struct thr_param *) arg0;
    printf("stack_base: \nstack_size: %d\n", /*p0->stack_base,*/ p0->stack_size);
}
