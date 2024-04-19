# Lab: Copy-on-Write Fork for xv6
## Implement copy-on write
* Requirement:
  * implement copy-on-write fork in the xv6 kernel
    ```c
    $ cowtest
    simple: ok
    simple: ok
    three: zombie!
    ok
    three: zombie!
    ok
    three: zombie!
    ok
    file: ok
    ALL COW TESTS PASSED
    $ usertests
    ...
    ALL TESTS PASSED
    $
    ```
* Tips:
  * need to check vaild and only kill when memory lack
* Step:
  1. kalloc.c
     * create reference for every pa page and lock
       ```c
       int refs_cnt[PHYSTOP / PGSIZE];
       struct spinlock refs_lock;
       ```
  2. kree(void *pa) in kalloc.c
     * check vaild
     * reference - 1
     * if reference == 0 then real delete free
     ```c
     void
     kfree(void *pa)
     {
       struct run *r;
       int p_refs;
     
       if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)  // check vaild
         panic("kfree");
     
        // decrease reference
        acquire(&refs_lock);
        p_refs = --refs_cnt[(uint64)pa / PGSIZE];
        release(&refs_lock);

        if(!p_refs)  // referencr = 0 then release
        {
                // Fill with junk to catch dangling refs.
                memset(pa, 1, PGSIZE);

        r = (struct run*)pa;

        acquire(&kmem.lock);
        r->next = kmem.freelist;
        kmem.freelist = r;
                release(&kmem.lock);
        }
     }
     ```
  3. kree() in kalloc.c
     * create new pa page
     * set reference to 1
     ```c
     void *
     kalloc(void)
     {
       struct run *r;
    
       acquire(&kmem.lock);
       r = kmem.freelist;
       if(r)
       {
         kmem.freelist = r->next;
         // reference set to 1
         acquire(&refs_lock);
         refs_cnt[(uint64)r / PGSIZE] = 1;
         release(&refs_lock);
       }
       release(&kmem.lock);
    
       if(r)
         memset((char*)r, 5, PGSIZE); // fill with junk
       return (void*)r;
     }
     ```
  4. uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) in vm.c
     * 判斷是否為W page，若不是則不做更動，是則更改flag to cow page
     * 將新的child pagetable entry map to parent physical memory instead of create new pa memory
     * add pa page reference
     ```c
     int
     uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
     {
       pte_t *pte;
       uint64 pa, i;
       //uint flags;
       //char *mem;

       for(i = 0; i < sz; i += PGSIZE)
       {
         ...
         if(*pte & PTE_W)        // if is for other case no need to become cow
         {
           *pte = (*pte & (~PTE_W)) | PTE_COW;
         }
         /*
         if((mem = kalloc()) == 0)
           goto err;
         memmove(mem, (char*)pa, PGSIZE);
         if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0)
         */
         if(mappages(new, i, PGSIZE, pa, PTE_FLAGS(*pte)) != 0)  // map child page entry to parent pa
           goto err;
         acquire(&refs_lock);
         refs_cnt[pa / PGSIZE]++;        // add pa page entry
         release(&refs_lock);
       }
       return 0;
     err:
       uvmunmap(new, 0, i / PGSIZE, 1);
       return -1;
     }
     ```
  5. writevaildAndCowhandler(pagetable_t pagetable, uint64 va) in vm.c
     * check vaild
     * align va because use it in page table
     * create new pa memory and copy
     * free old pa
     * change pte
     ```c
     int writevaildAndCowhandler(pagetable_t pagetable, uint64 va)
     {
       pte_t *pte;
       char *mem;
       uint64 pa;

       if(va >= MAXVA) // check va of process vaild
         return -1;
       if((pte = walk(pagetable, va, 0)) == 0) // check pte vaild
         return -1;
       if(((*pte & PTE_V) == 0) || ((*pte & PTE_U) == 0)) // check flag vaild
         return -1;
       if((*pte & PTE_COW) && ((*pte & PTE_W) == 0)) // check COW
       {
         pa = PTE2PA(*pte);
         va = PGROUNDDOWN(va); // related to pgtable need to align
     
         // alloc new pa area if error then kill
         if((mem = kalloc()) == 0)
           exit(-1);

         // copy
         memmove(mem, (char *)pa, PGSIZE);
         // dereference old pa
         kfree((char *)pa);
     
         // update pte
         *pte = PA2PTE(mem) | PTE_FLAGS(*pte);
         *pte |= PTE_W;
         *pte &= ~PTE_COW;
        }
        else if((*pte & PTE_W) == 0)    // check other write invaild
          return -1;
        return 0;
     }
     ```
  6. usertrap() in trap.c
     * trap cause add with store page
     * if error kill process
     ```c
     void
     usertrap(void)
     {
       ...
       if(r_scause() == 8){
       // system call
       ...
     }
     else if(r_scause() == 15) // store page fault
     {
       if(writevaildAndCowhandler(p->pagetable, r_stval()) < 0)
       {
         printf("usertrap: store page fault error\n");
         p->killed = 1;
       }
     }
     else if((which_dev = devintr()) != 0){
      // ok
     } else {
       printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
       printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
       p->killed = 1;
     } 
  
     if(p->killed)
     exit(-1);
     ...
     }
     ```
  7. copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) in vm.c
     * because it use memove directly but not through pgtable, need to deal with cow page problem
     * deal with cow page
     * get pa with new pte
     ```c
     int
     copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
     {
       uint64 n, va0, pa0;
       while(len > 0){
         if(writevaildAndCowhandler(pagetable, dstva) < 0) // cow
           return -1;
      
         va0 = PGROUNDDOWN(dstva);
         pa0 = walkaddr(pagetable, va0); //new pa
         ...
        return 0;
     }
     ```
## result
![cow](https://github.com/joan902614/MIT6.S081_OS/assets/132533584/b528a13e-f783-4664-b5dd-d7cf721d1d45)
