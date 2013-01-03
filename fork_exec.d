#!/usr/sbin/dtrace -s

fbt:kernel:sched_fork:entry {
    t1 = (struct thread *) arg0;
    p1 = (struct proc *) t1->td_proc;
    t2 = (struct thread *) arg1;
    p2 = (struct proc *) t2->td_proc;
    printf("FORK: %d (%s) -> %d (%s)", p1->p_pid, p1->p_comm, p2->p_pid, p2->p_comm);
}

fbt:kernel:sys_execve:entry {
    t1 = (struct thread *) arg0;
    p1 = (struct proc *) t1->td_proc;
    execve_args = (struct execve_args *) arg1;
    printf("EXEC: %d (%s) -> %d (%s)", p1->p_pid, p1->p_comm, p1->p_pid, copyinstr((uintptr_t)execve_args->fname));
}
