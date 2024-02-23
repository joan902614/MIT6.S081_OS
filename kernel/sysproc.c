#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "date.h"
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
  return 0;
}

int
sys_pgaccess(void)
{
	struct proc *p = myproc();
	pte_t *pte;
	unsigned int mask = 0;
	
	uint64 va_pg, va_mask;
  int num;
	if(argaddr(0, &va_pg) | argint(1, &num) | argaddr(2, &va_mask))
		return -1;
	// integter at most 32 bit
	// user va at most MAXVA
	if(num < 0 || num > 32 || va_pg > MAXVA)
		return -1;
	// D and A is auto set by hardware 
	for(int i = 0; i < num; i++)
	{
		// find leaf pte for every page
		if((pte = walk(p->pagetable, va_pg + PGSIZE * i, 0)))
		{
			if(*pte & PTE_A)
			{
				mask |= (1 << i);
				*pte &= ~PTE_A;	// set access bit to 0
			}
		}
		else
			return -1;
	}
	// let buffer copy back to user
	if(copyout(p->pagetable, va_mask, (char *)&mask, sizeof(mask)) < 0)
		return -1;
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

