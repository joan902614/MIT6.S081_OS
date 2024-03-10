// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

int refs_cnt[PHYSTOP / PGSIZE];
struct spinlock refs_lock;

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

void
kinit()
{
  initlock(&kmem.lock, "kmem");
	initlock(&refs_lock, "cow");
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
	{
		refs_cnt[(uint64)p / PGSIZE] = 1;
    kfree(p);
	}
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;
	int p_refs;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP) // check vaild
    panic("kfree");
	
	// decrease reference
	acquire(&refs_lock);
	p_refs = --refs_cnt[(uint64)pa / PGSIZE];
	release(&refs_lock);
	
	if(!p_refs) // referencr = 0 then release
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

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
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
