# Lab4: traps
## RISC-V assembly
Require:
question about user/call.asm
1.  
Q. Which registers contain arguments to functions? For example, which register holds 13 in main's call to printf?
A. a0-a7, a2
2.  
Q. Where is the call to function f in the assembly code for main? Where is the call to g? (Hint: the compiler may inline functions.)
A. no, because inline function
3.  
Q. At what address is the function printf located?
A. 640
4.  
Q. What value is in the register ra just after the jalr to printf in main?
A. 38
5.  
Q. ```unsigned int i = 0x00646c72;
	    printf("H%x Wo%s", 57616, &i);```
  What is the output?  
  The output depends on that fact that the RISC-V is little-endian. If the RISC-V were instead big-endian what would you set i to in order to yield the same output? Would you need to change 57616 to a different value?
A. He110 World
   0x726c6400
   no change
6.  
Q. In the following code, what is going to be printed after 'y='? (note: the answer is not a specific value.) Why does this happen?
  ```printf("x=%d y=%d", 3);```
A. value in a2

## Backtrace
Require:
backtrace: a list of the all the function calls on the stack above the point at which the error occurred
Implement a backtrace() function in kernel/printf.c. Insert a call to this function in sys_sleep, and then run bttest, which calls sys_sleep
```
backtrace:
0x0000000080002cda
0x0000000080002bb6
0x0000000080002898
```
Step:
1. add backtrace funtion  

    **printf.c**
    ```c
    backtrace(void)
    {
        uint64 fp = r_fp(); // fp is the address bounded by stack
        printf("backtrace:\n");
        // stack is one page
        while(PGROUNDDOWN(fp) <= fp && fp < PGROUNDUP(fp))
        {
            printf("%p\n", *(uint64 *)(fp - 8)); // ra
            fp = *(uint64 *)(fp - 16);           // fp
        }
    }
    ```
2. add read fp

    **riscv.h
    ```c
    r_fp(void)
    {
        uint64 x;
        asm volatile("mv %0, s0" : "=r" (x) );
        return x;
    }
    ```
    
3. add backtrace to function 宣告

    **defs.h**
    ```c
    void    backtrace(void);
    ```
4. add backtrace to sys_sleep

    **sysproc.c**
    ```c
    uint64
    sys_sleep(void)
    {
        ...
        backtrace();
      return 0;
    }
    ```

## Alarm
Require:
add a feature to xv6 that periodically alerts a process as it uses CPU time.  
If an application calls sigalarm(n, fn), then after every n "ticks" of CPU time that the program consumes, the kernel should cause application function fn to be called.   
If an application calls sigalarm(0, 0), the kernel should stop generating periodic alarm calls.  
```
test0 start
........alarm!
test0 passed
test1 start
...alarm!
..alarm!
...alarm!
..alarm!
...alarm!
..alarm!
...alarm!
..alarm!
...alarm!
..alarm!
test1 passed
test2 start
................alarm!
test2 passed
```
Step:
system call inital alarm
start calculate tick
interrupt every CPU time
when arrived wanted tick and store origin register
jump to handler
handler finish then trap by sys_sigreturn restore register
jump origin code execute place
1. add syscall

    **user.h**
    ```c
    int sigalarm(int, void (*)());
    int sigreturn(void);
    ```
    **usy.pl**
    ```c
    entry("sigalarm");
    entry("sigreturn");
    ```
    **syscall.h**
    ```c
    #define SYS_sigalarm 22
    #define SYS_sigreturn 23
    ```
    **syscall.c**
    ```c
    extern uint64 sys_sigalarm(void);
    extern uint64 sys_sigreturn(void);
    static uint64 (*syscalls[])(void) = {
    ...
    [SYS_sigalarm] sys_sigalarm,
    [SYS_sigreturn] sys_sigreturn
    };
    ```

2. add data in pcb and initalize

    **proc.h**
    ```c
    struct proc {
    ...
    int ticks;                 // sysalarm arg
    uint64 handler;            // sysalarm arg
    int now_ticks;             // record number of tick since last call
    struct trapframe ogf;      // origin trapframe not handler
    };
    ```
    **proc.c**(need to change to allocate page)
    ```c
    static struct proc*
    allocproc(void)
    {
        ...
    found:
         p->now_ticks = 0;
        ...
    }
    
3. syscall sys_sigalarm

    **sysproc.c**
    ```c
    uint64
    sys_sigalarm(void)
    {
        // timer interr += 1 nowtick
        // when ariived change spec to pred fun
        struct proc *p = myproc();
        // store alarm arg to proc
        if(argint(0, &p->ticks) || argaddr(1, &p->handler))
                return -1;
        return 0;
    }
    ```
    
4. when arrived wanted tick and store origin register

    **trap.c**
    ```c
    void
    usertrap(void)
    {
        ...
        if(which_dev == 2)
        {
            p->now_ticks += 1;
            if(p->now_ticks == p->ticks)
            {
                // store register before jump to handler
                p->ogf.epc = p->trapframe->epc;
                p->ogf.ra = p->trapframe->ra;
                p->ogf.sp = p->trapframe->sp;
                p->ogf.gp = p->trapframe->gp;
                p->ogf.tp = p->trapframe->tp;
                p->ogf.t0 = p->trapframe->t0;
                p->ogf.t1 = p->trapframe->t1;
                p->ogf.t2 = p->trapframe->t2;
                p->ogf.s0 = p->trapframe->s0;
                p->ogf.s1 = p->trapframe->s1;
                p->ogf.a0 = p->trapframe->a0;
                p->ogf.a1 = p->trapframe->a1;
                p->ogf.a2 = p->trapframe->a2;
                p->ogf.a3 = p->trapframe->a3;
                p->ogf.a4 = p->trapframe->a4;
                p->ogf.a5 = p->trapframe->a5;
                p->ogf.a6 = p->trapframe->a6;
                p->ogf.a7 = p->trapframe->a7;
                p->ogf.s2 = p->trapframe->s2;
                p->ogf.s3 = p->trapframe->s3;
                p->ogf.s4 = p->trapframe->s4;
                p->ogf.s5 = p->trapframe->s5;
                p->ogf.s6 = p->trapframe->s6;
                p->ogf.s7 = p->trapframe->s7;
                p->ogf.s8 = p->trapframe->s8;
                p->ogf.s9 = p->trapframe->s9;
                p->ogf.s10 = p->trapframe->s10;
                p->ogf.s11 = p->trapframe->s11;
                p->ogf.t3 = p->trapframe->t3;
                p->ogf.t4 = p->trapframe->t4;
                p->ogf.t5 = p->trapframe->t5;
                p->ogf.t6 = p->trapframe->t6;
                // set pc to handler
                p->trapframe->epc = p->handler;
            }
            yield();
        }
        usertrapret();
    }
    ```
5. recover status of code execute

    **sysproc.c**
    ```c
    uint64
    sys_sigreturn(void)
    {
        struct proc *p = myproc();
        // restore register 
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
        // start calculate tick again
        p->now_ticks = 0;
        return 0;
    }
    ```
## result
![trap](https://github.com/joan902614/MIT6.S081_OS/assets/132533584/9c162129-ae16-482d-8777-28d5fc925b81)
