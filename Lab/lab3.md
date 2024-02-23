# Lab3: page tables
## Speed up system calls
Require:
By read-only page at USYSCALL(a VA defined in memlayout.h), add new syscall ugetpid() speed up getpid() 
| process memory configuration |
|:---------:|
| trampoline |
| trapframe |
| usyscall |
| heap |
| stack |
| guard |
| data |
| text |  

Step:
1. syscall in user space

    Because it change getpid to operate in user, it wouldn't have code in general syscall file in kernal
  
    **user.h**  
    ```c
    // usyscall region
    int ugetpid(void);
    ```

2. add pid page and struct
   
    **memlayout.h**
    ```c
    #define USYSCALL (TRAPFRAME - PGSIZE)
    struct usyscall
    {
      int pid;  // Process ID
    };
    ```
3. allocate USYSCALL page to process

    **vm.c**
    ```c
    static struct proc*
    allocproc(void)
    {
       ...
    found:
       ...
       // Allocate a USYSCALL page (pa)
       if((p->upid = (struct usyscall *)kalloc()) == 0)
       {
            freeproc(p);
            release(&p->lock);
            return 0;
       }
       p->upid->pid = p->pid;
       ...
    }
    
    pagetable_t
    proc_pagetable(struct proc *p)
    {
        ...
        // map the usyscall below TRAPFRAME
        /* because this function is create pagetable, if error, it need to clear page table. pa don't do anything here*/ 
        if(mappages(pagetable, USYSCALL, PGSIZE, (uint64)(p->upid), PTE_R | PTE_U) < 0)
        {
            uvmunmap(pagetable, TRAMPOLINE, 1, 0);    // trampoline pa no need to free
            uvmunmap(pagetable, TRAPFRAME, 1, 0);     // trapframe pa will be free later 
            uvmfree(pagetable, 0);                    // other page below usycall in not set yet, so it can free pagetbel here
            return 0;
        }
        ...
    
    }
    ```

4. free proc (pa)/(va) if error

    **vm.c**
    ```c
    static void
    freeproc(struct proc *p)
    {
        ...
        // free usyscall pa
        if(p->upid)
            kfree((void *)p->upid);
        p->upid = 0;
        ...
    }

    // free page table (umap and pagetable pa and pa for data)
    void
    proc_freepagetable(pagetable_t pagetable, uint64 sz)
    {
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
        uvmunmap(pagetable, TRAPFRAME, 1, 0);
        uvmunmap(pagetable, USYSCALL, 1, 0);
        uvmfree(pagetable, sz);
    }
    ```
    
## Print a page table
Require:
Visualize RISC-V page table
finished exec() init:
```
page table 0x0000000087f6e000
 ..0: pte 0x0000000021fda801 pa 0x0000000087f6a000
 .. ..0: pte 0x0000000021fda401 pa 0x0000000087f69000
 .. .. ..0: pte 0x0000000021fdac1f pa 0x0000000087f6b000
 .. .. ..1: pte 0x0000000021fda00f pa 0x0000000087f68000
 .. .. ..2: pte 0x0000000021fd9c1f pa 0x0000000087f67000
 ..255: pte 0x0000000021fdb401 pa 0x0000000087f6d000
 .. ..511: pte 0x0000000021fdb001 pa 0x0000000087f6c000
 .. .. ..509: pte 0x0000000021fdd813 pa 0x0000000087f76000
 .. .. ..510: pte 0x0000000021fddc07 pa 0x0000000087f77000
 .. .. ..511: pte 0x0000000020001c0b pa 0x0000000080007000
```
Step:
1. call the function

    **exec.c**
    ```c
    int
    exec(char *path, char **argv)
    {
        ...
        // print page table
        if(p->pid == 1)
            vmprint(pagetable);

        return argc;
        ...
    }
    ```
2. function

    ```c
    // print a page table
    void
    vmprintLevel(pagetable_t pagetable, int level)
    {
        char *level_point[3] = {"..", ".. ..", ".. .. .."};
        for(int i = 0; i < 512; i++)
        {
            // page table entry
            pte_t pte = pagetable[i];
            if(pte & PTE_V)
            {
                // next level pagetable must be physical adress
                uint64 child = PTE2PA(pte);
                printf("%s%d: pte %p pa %p\n", level_point[level], i, pte, child);
                // if it is not leaf page
                if((pte & (PTE_R | PTE_W | PTE_X)) == 0)
                // child is adress, so need to change to pointer
                    vmprintLevel((pagetable_t)child, level + 1);
            }
        }
    }
    void
    vmprint(pagetable_t pagetable)
    {
        printf("page table %p\n", pagetable);
        vmprintLevel(pagetable, 0);
    }
    ```

3. add function to groble function table (file)
    
    **defs.h**
    ```c
    void    vmprint(pagetable_t);
    ```

## Detecting which pages have been accessed
Require:
By access bit, implement pgaccess(), a system call that reports which pages have been accessed
Note:
Access bit and Dirty bit will be automatic set by hardware
Step:
1. add syscall

    **user.h**
    ```c
    int pgaccess(void *base, int len, void *mask);
    ```
    **usys.pl**
    ```c
    entry("pgaccess");
    ```
    **syscall.h**
    ```c
    #define SYS_pgaccess  30
    ```
    **syscall.c**
    ```c
    extern uint64 sys_pgaccess(void);
    
    static uint64 (*syscalls[])(void) = {
    ...
    [SYS_pgaccess] sys_pgaccess,
    };

2. add access bit

    **riscv.h**
    ```c
    #define PTE_A (1L << 6) // access
    ```
    
3. 宣告walk
    **defs.h**
    ```c
    pte_t *    walk(pagetable_t, uint64, int);
    ```

4. function

    **sysproc.c**
    ```c
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
                    *pte &= ~PTE_A;    // set access bit to 0
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
    ```

## answers-pgtbl.txt
1. Q.  
   Which other xv6 system call(s) could be made faster using this shared page? Explain how.  
   A.  
   all syscall need to be copyout from kernel
3. Q.  
   Explain the output of vmprint in terms of Fig 3-4 from the text. What does page 0 contain? What is in page 2? When running in user mode, could the process read/write the memory mapped by page 1? What does the third to last page contain?  
   A.  
   page 0: data, text  
   page 1: guard page, can't be used  
   page 2: stack 
