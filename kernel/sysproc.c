#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  if(argint(0, &n) < 0)
    return -1;
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  if(argaddr(0, &p) < 0)
    return -1;
  return wait(p);
}

uint64
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
	backtrace();
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64
sys_sigalarm(void)
{	
	// add proc struct
	// inital now_tick
	// syscall
	// store argument to process struct
	// timer interr += 1 nowtick
	// when ariived change spec to pred fun
			
	struct proc *p = myproc();
	if(argint(0, &p->ticks) || argaddr(1, &p->handler))
		return -1;
	return 0;
}

uint64
sys_sigreturn(void)
{
	// system call inital tick
	// interrupt
	// store origin register then jump to handler
	// trap by system call restore register
	struct proc *p = myproc();
	p->trapframe->epc = p->ogf.epc;
	p->trapframe->ra = p->ogf.ra;	
	p->trapframe->sp = p->ogf.sp;	
	p->trapframe->gp = p->ogf.gp;	
	p->trapframe->tp = p->ogf.tp;	
	p->trapframe->t0 = p->ogf.t0;	
	p->trapframe->t1 = p->ogf.t1;	
	p->trapframe->t2 = p->ogf.t2;	
	p->trapframe->s0 = p->ogf.s0;	
	p->trapframe->s1 = p->ogf.s1;	
	p->trapframe->a0 = p->ogf.a0;	
	p->trapframe->a1 = p->ogf.a1;	
	p->trapframe->a2 = p->ogf.a2;	
	p->trapframe->a3 = p->ogf.a3;	
	p->trapframe->a4 = p->ogf.a4;	
	p->trapframe->a5 = p->ogf.a5;	
	p->trapframe->a6 = p->ogf.a6;	
	p->trapframe->a7 = p->ogf.a7;	
	p->trapframe->s2 = p->ogf.s2;	
	p->trapframe->s3 = p->ogf.s3;	
	p->trapframe->s4 = p->ogf.s4;	
	p->trapframe->s5 = p->ogf.s5;	
	p->trapframe->s6 = p->ogf.s6;	
	p->trapframe->s7 = p->ogf.s7;	
	p->trapframe->s8 = p->ogf.s8;	
	p->trapframe->s9 = p->ogf.s9;	
	p->trapframe->s10 = p->ogf.s10;	
	p->trapframe->s11 = p->ogf.s11;	
	p->trapframe->t3 = p->ogf.t3;	
	p->trapframe->t4 = p->ogf.t4;	
	p->trapframe->t5 = p->ogf.t5;	
	p->trapframe->t6 = p->ogf.t6;
	p->now_ticks = 0;	
	return 0;
}
