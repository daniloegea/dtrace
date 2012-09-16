#!/usr/sbin/dtrace -s

fbt:kernel:sched_fork:entry {
    t1 = (struct thread *) arg0;
    p1 = (struct proc *) t1->td_proc;
    t2 = (struct thread *) arg1;
    p2 = (struct proc *) t2->td_proc;
    printf("%d (%s) -> %d (%s)", p1->p_pid, p1->p_comm, p2->p_pid, p2->p_comm);
}
