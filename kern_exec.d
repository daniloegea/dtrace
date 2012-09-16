#!/usr/sbin/dtrace -s

fbt:kernel:sys_execve:entry {
    t1 = (struct thread *) arg0;
    p1 = (struct proc *) t1->td_proc;
    execve_args = (struct execve_args *) arg1;
    printf("%d (%s) -> %d (%s)", p1->p_pid, p1->p_comm, p1->p_pid, copyinstr((uintptr_t)execve_args->fname));
}
