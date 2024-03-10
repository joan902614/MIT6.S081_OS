# Lab2 syscall: System calls
## step:
* user/user.h
```c
struct sysinfo;
int trace(int);
int sysinfo(struct sysinfo *);
```
* user/usys.pl
```c
entry("trace");
entry("sysinfo");  
```
* kernel/syscall.h
```c
#define SYS_trace  22
#define SYS_sysinfo 23
```
* kernel/sysproc.c

## system call trace
### require:
By using argument mask, using trace system call to print corresponding system call when it is invoked.
```
$ trace 32 grep hello README
3: syscall read -> 1023
3: syscall read -> 966
3: syscall read -> 70
3: syscall read -> 0
$ trace 2147483647 grep hello README
4: syscall trace -> 0
4: syscall exec -> 3
4: syscall open -> 3
4: syscall read -> 1023
4: syscall read -> 966
4: syscall read -> 70
4: syscall read -> 0
4: syscall close -> 0
```
In the first example above, trace invokes grep tracing just the read system call. The 32 is 1<<SYS_read. In the second example, trace runs grep while tracing all system calls; the 2147483647 has all 31 low bits set.
### code:
kernel/sysproc.c
```c
uint64
sys_trace(void)
{
        int mask;
        // argument from user store in a0
        if(argint(0, &mask) < 0)
                return -1;
        myproc()->mask = mask;
        return 0;
}
```
kernel/proc.c
```c
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *p = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy user memory from parent to child.
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    freeproc(np);
    release(&np->lock);
    return -1;
  }
  np->sz = p->sz;

  // copy saved user registers.
  *(np->trapframe) = *(p->trapframe);

  // copy trace mask
  np->mask = p->mask;

  // Cause fork to return 0 in the child.
  np->trapframe->a0 = 0;

  // increment reference counts on open file descriptors.
  for(i = 0; i < NOFILE; i++)
    if(p->ofile[i])
      np->ofile[i] = filedup(p->ofile[i]);
  np->cwd = idup(p->cwd);

  safestrcpy(np->name, p->name, sizeof(p->name));

  pid = np->pid;

  release(&np->lock);

  acquire(&wait_lock);
  np->parent = p;
  release(&wait_lock);

  acquire(&np->lock);
  np->state = RUNNABLE;
  release(&np->lock);

  return pid;
}
```
kernel/syscall.c
```c
void
syscall(void)
{
  char *sys_call_name[] = {"fork", "exit", "wait", "pipe", "read", "kill", "exec", "fstat", "chdir", "dup", "getpid", "sbrk", "sleep", "uptime", "open", "write", "mknod", "unlink", "link", "mkdir", "close", "trace", "sys_sysinfo"};

  int num;
  struct proc *p = myproc();

  num = p->trapframe->a7;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    p->trapframe->a0 = syscalls[num]();
        // trace
        if(p->mask & (1 << num)) // not equal or not all-syscall will get 0
                printf("%d: syscall %s -> %d\n", p->pid, sys_call_name[num - 1], p->trapframe->a0);
  } else {
    printf("%d %s: unknown sys call %d\n",
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
  }
}
```
## system call sysinfo
### require:
The system call takes one argument: a pointer to a struct sysinfo (see kernel/sysinfo.h). The kernel should fill out the fields of this struct: the freemem field should be set to the number of bytes of free memory, and the nproc field should be set to the number of processes whose state is not UNUSED.
```
$ sysinfotest
sysinfotest: start
sysinfotest: OK
```
### code:
kernel/kalloc.c
```c
void
calFreemem(uint64 *cnt)
{
        struct run *r = kmem.freelist;
        *cnt = 0;
        // empty will be not NULL because it will fill with junk
        while(r)
        {
                (*cnt) += 4096;
                r = r->next;
        }
}
```
kernel/proc.c
```c
void
calUnproc(uint64 *cnt)
{
        struct proc *p;
        *cnt = 0;
        for(p = proc; p < &proc[NPROC]; p++)
        {
                if(p->state != UNUSED)
                {
                        *cnt += 1;
                }
        }
}
```
kernel/sysproc.c
```c
#include "sysinfo.h"

uint64
sys_sysinfo(void)
{
        struct proc *p = myproc();
        uint64 addr;
        // get address stored in info parameter(pointor to sysinfo)
        if(argaddr(0, &addr) < 0)
                return -1;
        struct sysinfo info;
        calFreemem(&(info.freemem));
        calUnproc(&(info.nproc));
        // copy kernal varible vaule to user space
        return copyout(p->pagetable, addr, (char *)&info, sizeof(info));
}
```
