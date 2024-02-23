# Lab3: page tables
## Speed up system calls
Require:
By read-only page at USYSCALL(a VA defined in memlayout.h), add new syscall ugetpid() speed up getpid() 
process memory configuration:

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
