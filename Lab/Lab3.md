# Lab3: page tables
## Speed up system calls
Require:
By read-only page at USYSCALL(a VA defined in memlayout.h), add new syscall ugetpid() speed up getpid() 
process memory configuration will be like:  
| Tables        | Are           | Cool  |
| ------------- |:-------------:| -----:|
| col 3 is      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |
<table>
  <tr>
     <td>trampoline</td>
  </tr>
  <tr>
     <td>trapframe</td>
  </tr>
  <tr>
     <td>usyscall</td>
  </tr>
  <tr>
     <td>heap
     </td>
  </tr>
  <tr>
     <td>stack</td>
  </tr>
  <tr>
     <td>guard</td>
  </tr>
  <tr>
     <td>data</td>
  </tr>
  <tr>
     <td>text</td>
  </tr>
</table>  
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
