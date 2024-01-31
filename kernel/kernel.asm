
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	9f013103          	ld	sp,-1552(sp) # 800089f0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	7c2050ef          	jal	ra,800057d8 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	156080e7          	jalr	342(ra) # 8000019e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	178080e7          	jalr	376(ra) # 800061d2 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	218080e7          	jalr	536(ra) # 80006286 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	bfe080e7          	jalr	-1026(ra) # 80005c88 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	04e080e7          	jalr	78(ra) # 80006142 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00026517          	auipc	a0,0x26
    80000104:	14050513          	addi	a0,a0,320 # 80026240 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	0a6080e7          	jalr	166(ra) # 800061d2 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	142080e7          	jalr	322(ra) # 80006286 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	04c080e7          	jalr	76(ra) # 8000019e <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	118080e7          	jalr	280(ra) # 80006286 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <calFreemem>:

void
calFreemem(uint64 *cnt)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
	struct run *r = kmem.freelist;
    8000017e:	00009717          	auipc	a4,0x9
    80000182:	eca73703          	ld	a4,-310(a4) # 80009048 <kmem+0x18>
	*cnt = 0;
    80000186:	00053023          	sd	zero,0(a0)
	while(r)
    8000018a:	c719                	beqz	a4,80000198 <calFreemem+0x20>
	{
		(*cnt) += 4096;
    8000018c:	6685                	lui	a3,0x1
    8000018e:	611c                	ld	a5,0(a0)
    80000190:	97b6                	add	a5,a5,a3
    80000192:	e11c                	sd	a5,0(a0)
		r = r->next;
    80000194:	6318                	ld	a4,0(a4)
	while(r)
    80000196:	ff65                	bnez	a4,8000018e <calFreemem+0x16>
	}
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001a4:	ce09                	beqz	a2,800001be <memset+0x20>
    800001a6:	87aa                	mv	a5,a0
    800001a8:	fff6071b          	addiw	a4,a2,-1
    800001ac:	1702                	slli	a4,a4,0x20
    800001ae:	9301                	srli	a4,a4,0x20
    800001b0:	0705                	addi	a4,a4,1
    800001b2:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800001b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001b8:	0785                	addi	a5,a5,1
    800001ba:	fee79de3          	bne	a5,a4,800001b4 <memset+0x16>
  }
  return dst;
}
    800001be:	6422                	ld	s0,8(sp)
    800001c0:	0141                	addi	sp,sp,16
    800001c2:	8082                	ret

00000000800001c4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001c4:	1141                	addi	sp,sp,-16
    800001c6:	e422                	sd	s0,8(sp)
    800001c8:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ca:	ca05                	beqz	a2,800001fa <memcmp+0x36>
    800001cc:	fff6069b          	addiw	a3,a2,-1
    800001d0:	1682                	slli	a3,a3,0x20
    800001d2:	9281                	srli	a3,a3,0x20
    800001d4:	0685                	addi	a3,a3,1
    800001d6:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001d8:	00054783          	lbu	a5,0(a0)
    800001dc:	0005c703          	lbu	a4,0(a1)
    800001e0:	00e79863          	bne	a5,a4,800001f0 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001e4:	0505                	addi	a0,a0,1
    800001e6:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001e8:	fed518e3          	bne	a0,a3,800001d8 <memcmp+0x14>
  }

  return 0;
    800001ec:	4501                	li	a0,0
    800001ee:	a019                	j	800001f4 <memcmp+0x30>
      return *s1 - *s2;
    800001f0:	40e7853b          	subw	a0,a5,a4
}
    800001f4:	6422                	ld	s0,8(sp)
    800001f6:	0141                	addi	sp,sp,16
    800001f8:	8082                	ret
  return 0;
    800001fa:	4501                	li	a0,0
    800001fc:	bfe5                	j	800001f4 <memcmp+0x30>

00000000800001fe <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001fe:	1141                	addi	sp,sp,-16
    80000200:	e422                	sd	s0,8(sp)
    80000202:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000204:	ca0d                	beqz	a2,80000236 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000206:	00a5f963          	bgeu	a1,a0,80000218 <memmove+0x1a>
    8000020a:	02061693          	slli	a3,a2,0x20
    8000020e:	9281                	srli	a3,a3,0x20
    80000210:	00d58733          	add	a4,a1,a3
    80000214:	02e56463          	bltu	a0,a4,8000023c <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	0785                	addi	a5,a5,1
    80000222:	97ae                	add	a5,a5,a1
    80000224:	872a                	mv	a4,a0
      *d++ = *s++;
    80000226:	0585                	addi	a1,a1,1
    80000228:	0705                	addi	a4,a4,1
    8000022a:	fff5c683          	lbu	a3,-1(a1)
    8000022e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000232:	fef59ae3          	bne	a1,a5,80000226 <memmove+0x28>

  return dst;
}
    80000236:	6422                	ld	s0,8(sp)
    80000238:	0141                	addi	sp,sp,16
    8000023a:	8082                	ret
    d += n;
    8000023c:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000023e:	fff6079b          	addiw	a5,a2,-1
    80000242:	1782                	slli	a5,a5,0x20
    80000244:	9381                	srli	a5,a5,0x20
    80000246:	fff7c793          	not	a5,a5
    8000024a:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000024c:	177d                	addi	a4,a4,-1
    8000024e:	16fd                	addi	a3,a3,-1
    80000250:	00074603          	lbu	a2,0(a4)
    80000254:	00c68023          	sb	a2,0(a3) # 1000 <_entry-0x7ffff000>
    while(n-- > 0)
    80000258:	fef71ae3          	bne	a4,a5,8000024c <memmove+0x4e>
    8000025c:	bfe9                	j	80000236 <memmove+0x38>

000000008000025e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000025e:	1141                	addi	sp,sp,-16
    80000260:	e406                	sd	ra,8(sp)
    80000262:	e022                	sd	s0,0(sp)
    80000264:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000266:	00000097          	auipc	ra,0x0
    8000026a:	f98080e7          	jalr	-104(ra) # 800001fe <memmove>
}
    8000026e:	60a2                	ld	ra,8(sp)
    80000270:	6402                	ld	s0,0(sp)
    80000272:	0141                	addi	sp,sp,16
    80000274:	8082                	ret

0000000080000276 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000276:	1141                	addi	sp,sp,-16
    80000278:	e422                	sd	s0,8(sp)
    8000027a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000027c:	ce11                	beqz	a2,80000298 <strncmp+0x22>
    8000027e:	00054783          	lbu	a5,0(a0)
    80000282:	cf89                	beqz	a5,8000029c <strncmp+0x26>
    80000284:	0005c703          	lbu	a4,0(a1)
    80000288:	00f71a63          	bne	a4,a5,8000029c <strncmp+0x26>
    n--, p++, q++;
    8000028c:	367d                	addiw	a2,a2,-1
    8000028e:	0505                	addi	a0,a0,1
    80000290:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000292:	f675                	bnez	a2,8000027e <strncmp+0x8>
  if(n == 0)
    return 0;
    80000294:	4501                	li	a0,0
    80000296:	a809                	j	800002a8 <strncmp+0x32>
    80000298:	4501                	li	a0,0
    8000029a:	a039                	j	800002a8 <strncmp+0x32>
  if(n == 0)
    8000029c:	ca09                	beqz	a2,800002ae <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    8000029e:	00054503          	lbu	a0,0(a0)
    800002a2:	0005c783          	lbu	a5,0(a1)
    800002a6:	9d1d                	subw	a0,a0,a5
}
    800002a8:	6422                	ld	s0,8(sp)
    800002aa:	0141                	addi	sp,sp,16
    800002ac:	8082                	ret
    return 0;
    800002ae:	4501                	li	a0,0
    800002b0:	bfe5                	j	800002a8 <strncmp+0x32>

00000000800002b2 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002b2:	1141                	addi	sp,sp,-16
    800002b4:	e422                	sd	s0,8(sp)
    800002b6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002b8:	872a                	mv	a4,a0
    800002ba:	8832                	mv	a6,a2
    800002bc:	367d                	addiw	a2,a2,-1
    800002be:	01005963          	blez	a6,800002d0 <strncpy+0x1e>
    800002c2:	0705                	addi	a4,a4,1
    800002c4:	0005c783          	lbu	a5,0(a1)
    800002c8:	fef70fa3          	sb	a5,-1(a4)
    800002cc:	0585                	addi	a1,a1,1
    800002ce:	f7f5                	bnez	a5,800002ba <strncpy+0x8>
    ;
  while(n-- > 0)
    800002d0:	00c05d63          	blez	a2,800002ea <strncpy+0x38>
    800002d4:	86ba                	mv	a3,a4
    *s++ = 0;
    800002d6:	0685                	addi	a3,a3,1
    800002d8:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002dc:	fff6c793          	not	a5,a3
    800002e0:	9fb9                	addw	a5,a5,a4
    800002e2:	010787bb          	addw	a5,a5,a6
    800002e6:	fef048e3          	bgtz	a5,800002d6 <strncpy+0x24>
  return os;
}
    800002ea:	6422                	ld	s0,8(sp)
    800002ec:	0141                	addi	sp,sp,16
    800002ee:	8082                	ret

00000000800002f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002f0:	1141                	addi	sp,sp,-16
    800002f2:	e422                	sd	s0,8(sp)
    800002f4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002f6:	02c05363          	blez	a2,8000031c <safestrcpy+0x2c>
    800002fa:	fff6069b          	addiw	a3,a2,-1
    800002fe:	1682                	slli	a3,a3,0x20
    80000300:	9281                	srli	a3,a3,0x20
    80000302:	96ae                	add	a3,a3,a1
    80000304:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000306:	00d58963          	beq	a1,a3,80000318 <safestrcpy+0x28>
    8000030a:	0585                	addi	a1,a1,1
    8000030c:	0785                	addi	a5,a5,1
    8000030e:	fff5c703          	lbu	a4,-1(a1)
    80000312:	fee78fa3          	sb	a4,-1(a5)
    80000316:	fb65                	bnez	a4,80000306 <safestrcpy+0x16>
    ;
  *s = 0;
    80000318:	00078023          	sb	zero,0(a5)
  return os;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret

0000000080000322 <strlen>:

int
strlen(const char *s)
{
    80000322:	1141                	addi	sp,sp,-16
    80000324:	e422                	sd	s0,8(sp)
    80000326:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000328:	00054783          	lbu	a5,0(a0)
    8000032c:	cf91                	beqz	a5,80000348 <strlen+0x26>
    8000032e:	0505                	addi	a0,a0,1
    80000330:	87aa                	mv	a5,a0
    80000332:	4685                	li	a3,1
    80000334:	9e89                	subw	a3,a3,a0
    80000336:	00f6853b          	addw	a0,a3,a5
    8000033a:	0785                	addi	a5,a5,1
    8000033c:	fff7c703          	lbu	a4,-1(a5)
    80000340:	fb7d                	bnez	a4,80000336 <strlen+0x14>
    ;
  return n;
}
    80000342:	6422                	ld	s0,8(sp)
    80000344:	0141                	addi	sp,sp,16
    80000346:	8082                	ret
  for(n = 0; s[n]; n++)
    80000348:	4501                	li	a0,0
    8000034a:	bfe5                	j	80000342 <strlen+0x20>

000000008000034c <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000034c:	1141                	addi	sp,sp,-16
    8000034e:	e406                	sd	ra,8(sp)
    80000350:	e022                	sd	s0,0(sp)
    80000352:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000354:	00001097          	auipc	ra,0x1
    80000358:	aee080e7          	jalr	-1298(ra) # 80000e42 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000035c:	00009717          	auipc	a4,0x9
    80000360:	ca470713          	addi	a4,a4,-860 # 80009000 <started>
  if(cpuid() == 0){
    80000364:	c139                	beqz	a0,800003aa <main+0x5e>
    while(started == 0)
    80000366:	431c                	lw	a5,0(a4)
    80000368:	2781                	sext.w	a5,a5
    8000036a:	dff5                	beqz	a5,80000366 <main+0x1a>
      ;
    __sync_synchronize();
    8000036c:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000370:	00001097          	auipc	ra,0x1
    80000374:	ad2080e7          	jalr	-1326(ra) # 80000e42 <cpuid>
    80000378:	85aa                	mv	a1,a0
    8000037a:	00008517          	auipc	a0,0x8
    8000037e:	cbe50513          	addi	a0,a0,-834 # 80008038 <etext+0x38>
    80000382:	00006097          	auipc	ra,0x6
    80000386:	950080e7          	jalr	-1712(ra) # 80005cd2 <printf>
    kvminithart();    // turn on paging
    8000038a:	00000097          	auipc	ra,0x0
    8000038e:	0d8080e7          	jalr	216(ra) # 80000462 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000392:	00001097          	auipc	ra,0x1
    80000396:	766080e7          	jalr	1894(ra) # 80001af8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000039a:	00005097          	auipc	ra,0x5
    8000039e:	dc6080e7          	jalr	-570(ra) # 80005160 <plicinithart>
  }

  scheduler();        
    800003a2:	00001097          	auipc	ra,0x1
    800003a6:	014080e7          	jalr	20(ra) # 800013b6 <scheduler>
    consoleinit();
    800003aa:	00005097          	auipc	ra,0x5
    800003ae:	7f0080e7          	jalr	2032(ra) # 80005b9a <consoleinit>
    printfinit();
    800003b2:	00006097          	auipc	ra,0x6
    800003b6:	b06080e7          	jalr	-1274(ra) # 80005eb8 <printfinit>
    printf("\n");
    800003ba:	00008517          	auipc	a0,0x8
    800003be:	c8e50513          	addi	a0,a0,-882 # 80008048 <etext+0x48>
    800003c2:	00006097          	auipc	ra,0x6
    800003c6:	910080e7          	jalr	-1776(ra) # 80005cd2 <printf>
    printf("xv6 kernel is booting\n");
    800003ca:	00008517          	auipc	a0,0x8
    800003ce:	c5650513          	addi	a0,a0,-938 # 80008020 <etext+0x20>
    800003d2:	00006097          	auipc	ra,0x6
    800003d6:	900080e7          	jalr	-1792(ra) # 80005cd2 <printf>
    printf("\n");
    800003da:	00008517          	auipc	a0,0x8
    800003de:	c6e50513          	addi	a0,a0,-914 # 80008048 <etext+0x48>
    800003e2:	00006097          	auipc	ra,0x6
    800003e6:	8f0080e7          	jalr	-1808(ra) # 80005cd2 <printf>
    kinit();         // physical page allocator
    800003ea:	00000097          	auipc	ra,0x0
    800003ee:	cf2080e7          	jalr	-782(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003f2:	00000097          	auipc	ra,0x0
    800003f6:	322080e7          	jalr	802(ra) # 80000714 <kvminit>
    kvminithart();   // turn on paging
    800003fa:	00000097          	auipc	ra,0x0
    800003fe:	068080e7          	jalr	104(ra) # 80000462 <kvminithart>
    procinit();      // process table
    80000402:	00001097          	auipc	ra,0x1
    80000406:	990080e7          	jalr	-1648(ra) # 80000d92 <procinit>
    trapinit();      // trap vectors
    8000040a:	00001097          	auipc	ra,0x1
    8000040e:	6c6080e7          	jalr	1734(ra) # 80001ad0 <trapinit>
    trapinithart();  // install kernel trap vector
    80000412:	00001097          	auipc	ra,0x1
    80000416:	6e6080e7          	jalr	1766(ra) # 80001af8 <trapinithart>
    plicinit();      // set up interrupt controller
    8000041a:	00005097          	auipc	ra,0x5
    8000041e:	d30080e7          	jalr	-720(ra) # 8000514a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000422:	00005097          	auipc	ra,0x5
    80000426:	d3e080e7          	jalr	-706(ra) # 80005160 <plicinithart>
    binit();         // buffer cache
    8000042a:	00002097          	auipc	ra,0x2
    8000042e:	f1a080e7          	jalr	-230(ra) # 80002344 <binit>
    iinit();         // inode table
    80000432:	00002097          	auipc	ra,0x2
    80000436:	5aa080e7          	jalr	1450(ra) # 800029dc <iinit>
    fileinit();      // file table
    8000043a:	00003097          	auipc	ra,0x3
    8000043e:	554080e7          	jalr	1364(ra) # 8000398e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000442:	00005097          	auipc	ra,0x5
    80000446:	e40080e7          	jalr	-448(ra) # 80005282 <virtio_disk_init>
    userinit();      // first user process
    8000044a:	00001097          	auipc	ra,0x1
    8000044e:	d32080e7          	jalr	-718(ra) # 8000117c <userinit>
    __sync_synchronize();
    80000452:	0ff0000f          	fence
    started = 1;
    80000456:	4785                	li	a5,1
    80000458:	00009717          	auipc	a4,0x9
    8000045c:	baf72423          	sw	a5,-1112(a4) # 80009000 <started>
    80000460:	b789                	j	800003a2 <main+0x56>

0000000080000462 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000462:	1141                	addi	sp,sp,-16
    80000464:	e422                	sd	s0,8(sp)
    80000466:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000468:	00009797          	auipc	a5,0x9
    8000046c:	ba07b783          	ld	a5,-1120(a5) # 80009008 <kernel_pagetable>
    80000470:	83b1                	srli	a5,a5,0xc
    80000472:	577d                	li	a4,-1
    80000474:	177e                	slli	a4,a4,0x3f
    80000476:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000478:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000047c:	12000073          	sfence.vma
  sfence_vma();
}
    80000480:	6422                	ld	s0,8(sp)
    80000482:	0141                	addi	sp,sp,16
    80000484:	8082                	ret

0000000080000486 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000486:	7139                	addi	sp,sp,-64
    80000488:	fc06                	sd	ra,56(sp)
    8000048a:	f822                	sd	s0,48(sp)
    8000048c:	f426                	sd	s1,40(sp)
    8000048e:	f04a                	sd	s2,32(sp)
    80000490:	ec4e                	sd	s3,24(sp)
    80000492:	e852                	sd	s4,16(sp)
    80000494:	e456                	sd	s5,8(sp)
    80000496:	e05a                	sd	s6,0(sp)
    80000498:	0080                	addi	s0,sp,64
    8000049a:	84aa                	mv	s1,a0
    8000049c:	89ae                	mv	s3,a1
    8000049e:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004a0:	57fd                	li	a5,-1
    800004a2:	83e9                	srli	a5,a5,0x1a
    800004a4:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004a6:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004a8:	04b7f263          	bgeu	a5,a1,800004ec <walk+0x66>
    panic("walk");
    800004ac:	00008517          	auipc	a0,0x8
    800004b0:	ba450513          	addi	a0,a0,-1116 # 80008050 <etext+0x50>
    800004b4:	00005097          	auipc	ra,0x5
    800004b8:	7d4080e7          	jalr	2004(ra) # 80005c88 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004bc:	060a8663          	beqz	s5,80000528 <walk+0xa2>
    800004c0:	00000097          	auipc	ra,0x0
    800004c4:	c58080e7          	jalr	-936(ra) # 80000118 <kalloc>
    800004c8:	84aa                	mv	s1,a0
    800004ca:	c529                	beqz	a0,80000514 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004cc:	6605                	lui	a2,0x1
    800004ce:	4581                	li	a1,0
    800004d0:	00000097          	auipc	ra,0x0
    800004d4:	cce080e7          	jalr	-818(ra) # 8000019e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004d8:	00c4d793          	srli	a5,s1,0xc
    800004dc:	07aa                	slli	a5,a5,0xa
    800004de:	0017e793          	ori	a5,a5,1
    800004e2:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004e6:	3a5d                	addiw	s4,s4,-9
    800004e8:	036a0063          	beq	s4,s6,80000508 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004ec:	0149d933          	srl	s2,s3,s4
    800004f0:	1ff97913          	andi	s2,s2,511
    800004f4:	090e                	slli	s2,s2,0x3
    800004f6:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004f8:	00093483          	ld	s1,0(s2)
    800004fc:	0014f793          	andi	a5,s1,1
    80000500:	dfd5                	beqz	a5,800004bc <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000502:	80a9                	srli	s1,s1,0xa
    80000504:	04b2                	slli	s1,s1,0xc
    80000506:	b7c5                	j	800004e6 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000508:	00c9d513          	srli	a0,s3,0xc
    8000050c:	1ff57513          	andi	a0,a0,511
    80000510:	050e                	slli	a0,a0,0x3
    80000512:	9526                	add	a0,a0,s1
}
    80000514:	70e2                	ld	ra,56(sp)
    80000516:	7442                	ld	s0,48(sp)
    80000518:	74a2                	ld	s1,40(sp)
    8000051a:	7902                	ld	s2,32(sp)
    8000051c:	69e2                	ld	s3,24(sp)
    8000051e:	6a42                	ld	s4,16(sp)
    80000520:	6aa2                	ld	s5,8(sp)
    80000522:	6b02                	ld	s6,0(sp)
    80000524:	6121                	addi	sp,sp,64
    80000526:	8082                	ret
        return 0;
    80000528:	4501                	li	a0,0
    8000052a:	b7ed                	j	80000514 <walk+0x8e>

000000008000052c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000052c:	57fd                	li	a5,-1
    8000052e:	83e9                	srli	a5,a5,0x1a
    80000530:	00b7f463          	bgeu	a5,a1,80000538 <walkaddr+0xc>
    return 0;
    80000534:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000536:	8082                	ret
{
    80000538:	1141                	addi	sp,sp,-16
    8000053a:	e406                	sd	ra,8(sp)
    8000053c:	e022                	sd	s0,0(sp)
    8000053e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000540:	4601                	li	a2,0
    80000542:	00000097          	auipc	ra,0x0
    80000546:	f44080e7          	jalr	-188(ra) # 80000486 <walk>
  if(pte == 0)
    8000054a:	c105                	beqz	a0,8000056a <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000054c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000054e:	0117f693          	andi	a3,a5,17
    80000552:	4745                	li	a4,17
    return 0;
    80000554:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000556:	00e68663          	beq	a3,a4,80000562 <walkaddr+0x36>
}
    8000055a:	60a2                	ld	ra,8(sp)
    8000055c:	6402                	ld	s0,0(sp)
    8000055e:	0141                	addi	sp,sp,16
    80000560:	8082                	ret
  pa = PTE2PA(*pte);
    80000562:	00a7d513          	srli	a0,a5,0xa
    80000566:	0532                	slli	a0,a0,0xc
  return pa;
    80000568:	bfcd                	j	8000055a <walkaddr+0x2e>
    return 0;
    8000056a:	4501                	li	a0,0
    8000056c:	b7fd                	j	8000055a <walkaddr+0x2e>

000000008000056e <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000056e:	715d                	addi	sp,sp,-80
    80000570:	e486                	sd	ra,72(sp)
    80000572:	e0a2                	sd	s0,64(sp)
    80000574:	fc26                	sd	s1,56(sp)
    80000576:	f84a                	sd	s2,48(sp)
    80000578:	f44e                	sd	s3,40(sp)
    8000057a:	f052                	sd	s4,32(sp)
    8000057c:	ec56                	sd	s5,24(sp)
    8000057e:	e85a                	sd	s6,16(sp)
    80000580:	e45e                	sd	s7,8(sp)
    80000582:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000584:	c205                	beqz	a2,800005a4 <mappages+0x36>
    80000586:	8aaa                	mv	s5,a0
    80000588:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000058a:	77fd                	lui	a5,0xfffff
    8000058c:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000590:	15fd                	addi	a1,a1,-1
    80000592:	00c589b3          	add	s3,a1,a2
    80000596:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    8000059a:	8952                	mv	s2,s4
    8000059c:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005a0:	6b85                	lui	s7,0x1
    800005a2:	a015                	j	800005c6 <mappages+0x58>
    panic("mappages: size");
    800005a4:	00008517          	auipc	a0,0x8
    800005a8:	ab450513          	addi	a0,a0,-1356 # 80008058 <etext+0x58>
    800005ac:	00005097          	auipc	ra,0x5
    800005b0:	6dc080e7          	jalr	1756(ra) # 80005c88 <panic>
      panic("mappages: remap");
    800005b4:	00008517          	auipc	a0,0x8
    800005b8:	ab450513          	addi	a0,a0,-1356 # 80008068 <etext+0x68>
    800005bc:	00005097          	auipc	ra,0x5
    800005c0:	6cc080e7          	jalr	1740(ra) # 80005c88 <panic>
    a += PGSIZE;
    800005c4:	995e                	add	s2,s2,s7
  for(;;){
    800005c6:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005ca:	4605                	li	a2,1
    800005cc:	85ca                	mv	a1,s2
    800005ce:	8556                	mv	a0,s5
    800005d0:	00000097          	auipc	ra,0x0
    800005d4:	eb6080e7          	jalr	-330(ra) # 80000486 <walk>
    800005d8:	cd19                	beqz	a0,800005f6 <mappages+0x88>
    if(*pte & PTE_V)
    800005da:	611c                	ld	a5,0(a0)
    800005dc:	8b85                	andi	a5,a5,1
    800005de:	fbf9                	bnez	a5,800005b4 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005e0:	80b1                	srli	s1,s1,0xc
    800005e2:	04aa                	slli	s1,s1,0xa
    800005e4:	0164e4b3          	or	s1,s1,s6
    800005e8:	0014e493          	ori	s1,s1,1
    800005ec:	e104                	sd	s1,0(a0)
    if(a == last)
    800005ee:	fd391be3          	bne	s2,s3,800005c4 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005f2:	4501                	li	a0,0
    800005f4:	a011                	j	800005f8 <mappages+0x8a>
      return -1;
    800005f6:	557d                	li	a0,-1
}
    800005f8:	60a6                	ld	ra,72(sp)
    800005fa:	6406                	ld	s0,64(sp)
    800005fc:	74e2                	ld	s1,56(sp)
    800005fe:	7942                	ld	s2,48(sp)
    80000600:	79a2                	ld	s3,40(sp)
    80000602:	7a02                	ld	s4,32(sp)
    80000604:	6ae2                	ld	s5,24(sp)
    80000606:	6b42                	ld	s6,16(sp)
    80000608:	6ba2                	ld	s7,8(sp)
    8000060a:	6161                	addi	sp,sp,80
    8000060c:	8082                	ret

000000008000060e <kvmmap>:
{
    8000060e:	1141                	addi	sp,sp,-16
    80000610:	e406                	sd	ra,8(sp)
    80000612:	e022                	sd	s0,0(sp)
    80000614:	0800                	addi	s0,sp,16
    80000616:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000618:	86b2                	mv	a3,a2
    8000061a:	863e                	mv	a2,a5
    8000061c:	00000097          	auipc	ra,0x0
    80000620:	f52080e7          	jalr	-174(ra) # 8000056e <mappages>
    80000624:	e509                	bnez	a0,8000062e <kvmmap+0x20>
}
    80000626:	60a2                	ld	ra,8(sp)
    80000628:	6402                	ld	s0,0(sp)
    8000062a:	0141                	addi	sp,sp,16
    8000062c:	8082                	ret
    panic("kvmmap");
    8000062e:	00008517          	auipc	a0,0x8
    80000632:	a4a50513          	addi	a0,a0,-1462 # 80008078 <etext+0x78>
    80000636:	00005097          	auipc	ra,0x5
    8000063a:	652080e7          	jalr	1618(ra) # 80005c88 <panic>

000000008000063e <kvmmake>:
{
    8000063e:	1101                	addi	sp,sp,-32
    80000640:	ec06                	sd	ra,24(sp)
    80000642:	e822                	sd	s0,16(sp)
    80000644:	e426                	sd	s1,8(sp)
    80000646:	e04a                	sd	s2,0(sp)
    80000648:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000064a:	00000097          	auipc	ra,0x0
    8000064e:	ace080e7          	jalr	-1330(ra) # 80000118 <kalloc>
    80000652:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000654:	6605                	lui	a2,0x1
    80000656:	4581                	li	a1,0
    80000658:	00000097          	auipc	ra,0x0
    8000065c:	b46080e7          	jalr	-1210(ra) # 8000019e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000660:	4719                	li	a4,6
    80000662:	6685                	lui	a3,0x1
    80000664:	10000637          	lui	a2,0x10000
    80000668:	100005b7          	lui	a1,0x10000
    8000066c:	8526                	mv	a0,s1
    8000066e:	00000097          	auipc	ra,0x0
    80000672:	fa0080e7          	jalr	-96(ra) # 8000060e <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000676:	4719                	li	a4,6
    80000678:	6685                	lui	a3,0x1
    8000067a:	10001637          	lui	a2,0x10001
    8000067e:	100015b7          	lui	a1,0x10001
    80000682:	8526                	mv	a0,s1
    80000684:	00000097          	auipc	ra,0x0
    80000688:	f8a080e7          	jalr	-118(ra) # 8000060e <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000068c:	4719                	li	a4,6
    8000068e:	004006b7          	lui	a3,0x400
    80000692:	0c000637          	lui	a2,0xc000
    80000696:	0c0005b7          	lui	a1,0xc000
    8000069a:	8526                	mv	a0,s1
    8000069c:	00000097          	auipc	ra,0x0
    800006a0:	f72080e7          	jalr	-142(ra) # 8000060e <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006a4:	00008917          	auipc	s2,0x8
    800006a8:	95c90913          	addi	s2,s2,-1700 # 80008000 <etext>
    800006ac:	4729                	li	a4,10
    800006ae:	80008697          	auipc	a3,0x80008
    800006b2:	95268693          	addi	a3,a3,-1710 # 8000 <_entry-0x7fff8000>
    800006b6:	4605                	li	a2,1
    800006b8:	067e                	slli	a2,a2,0x1f
    800006ba:	85b2                	mv	a1,a2
    800006bc:	8526                	mv	a0,s1
    800006be:	00000097          	auipc	ra,0x0
    800006c2:	f50080e7          	jalr	-176(ra) # 8000060e <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006c6:	4719                	li	a4,6
    800006c8:	46c5                	li	a3,17
    800006ca:	06ee                	slli	a3,a3,0x1b
    800006cc:	412686b3          	sub	a3,a3,s2
    800006d0:	864a                	mv	a2,s2
    800006d2:	85ca                	mv	a1,s2
    800006d4:	8526                	mv	a0,s1
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	f38080e7          	jalr	-200(ra) # 8000060e <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006de:	4729                	li	a4,10
    800006e0:	6685                	lui	a3,0x1
    800006e2:	00007617          	auipc	a2,0x7
    800006e6:	91e60613          	addi	a2,a2,-1762 # 80007000 <_trampoline>
    800006ea:	040005b7          	lui	a1,0x4000
    800006ee:	15fd                	addi	a1,a1,-1
    800006f0:	05b2                	slli	a1,a1,0xc
    800006f2:	8526                	mv	a0,s1
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	f1a080e7          	jalr	-230(ra) # 8000060e <kvmmap>
  proc_mapstacks(kpgtbl);
    800006fc:	8526                	mv	a0,s1
    800006fe:	00000097          	auipc	ra,0x0
    80000702:	5fe080e7          	jalr	1534(ra) # 80000cfc <proc_mapstacks>
}
    80000706:	8526                	mv	a0,s1
    80000708:	60e2                	ld	ra,24(sp)
    8000070a:	6442                	ld	s0,16(sp)
    8000070c:	64a2                	ld	s1,8(sp)
    8000070e:	6902                	ld	s2,0(sp)
    80000710:	6105                	addi	sp,sp,32
    80000712:	8082                	ret

0000000080000714 <kvminit>:
{
    80000714:	1141                	addi	sp,sp,-16
    80000716:	e406                	sd	ra,8(sp)
    80000718:	e022                	sd	s0,0(sp)
    8000071a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000071c:	00000097          	auipc	ra,0x0
    80000720:	f22080e7          	jalr	-222(ra) # 8000063e <kvmmake>
    80000724:	00009797          	auipc	a5,0x9
    80000728:	8ea7b223          	sd	a0,-1820(a5) # 80009008 <kernel_pagetable>
}
    8000072c:	60a2                	ld	ra,8(sp)
    8000072e:	6402                	ld	s0,0(sp)
    80000730:	0141                	addi	sp,sp,16
    80000732:	8082                	ret

0000000080000734 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000734:	715d                	addi	sp,sp,-80
    80000736:	e486                	sd	ra,72(sp)
    80000738:	e0a2                	sd	s0,64(sp)
    8000073a:	fc26                	sd	s1,56(sp)
    8000073c:	f84a                	sd	s2,48(sp)
    8000073e:	f44e                	sd	s3,40(sp)
    80000740:	f052                	sd	s4,32(sp)
    80000742:	ec56                	sd	s5,24(sp)
    80000744:	e85a                	sd	s6,16(sp)
    80000746:	e45e                	sd	s7,8(sp)
    80000748:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000074a:	03459793          	slli	a5,a1,0x34
    8000074e:	e795                	bnez	a5,8000077a <uvmunmap+0x46>
    80000750:	8a2a                	mv	s4,a0
    80000752:	892e                	mv	s2,a1
    80000754:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000756:	0632                	slli	a2,a2,0xc
    80000758:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000075c:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000075e:	6b05                	lui	s6,0x1
    80000760:	0735e863          	bltu	a1,s3,800007d0 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000764:	60a6                	ld	ra,72(sp)
    80000766:	6406                	ld	s0,64(sp)
    80000768:	74e2                	ld	s1,56(sp)
    8000076a:	7942                	ld	s2,48(sp)
    8000076c:	79a2                	ld	s3,40(sp)
    8000076e:	7a02                	ld	s4,32(sp)
    80000770:	6ae2                	ld	s5,24(sp)
    80000772:	6b42                	ld	s6,16(sp)
    80000774:	6ba2                	ld	s7,8(sp)
    80000776:	6161                	addi	sp,sp,80
    80000778:	8082                	ret
    panic("uvmunmap: not aligned");
    8000077a:	00008517          	auipc	a0,0x8
    8000077e:	90650513          	addi	a0,a0,-1786 # 80008080 <etext+0x80>
    80000782:	00005097          	auipc	ra,0x5
    80000786:	506080e7          	jalr	1286(ra) # 80005c88 <panic>
      panic("uvmunmap: walk");
    8000078a:	00008517          	auipc	a0,0x8
    8000078e:	90e50513          	addi	a0,a0,-1778 # 80008098 <etext+0x98>
    80000792:	00005097          	auipc	ra,0x5
    80000796:	4f6080e7          	jalr	1270(ra) # 80005c88 <panic>
      panic("uvmunmap: not mapped");
    8000079a:	00008517          	auipc	a0,0x8
    8000079e:	90e50513          	addi	a0,a0,-1778 # 800080a8 <etext+0xa8>
    800007a2:	00005097          	auipc	ra,0x5
    800007a6:	4e6080e7          	jalr	1254(ra) # 80005c88 <panic>
      panic("uvmunmap: not a leaf");
    800007aa:	00008517          	auipc	a0,0x8
    800007ae:	91650513          	addi	a0,a0,-1770 # 800080c0 <etext+0xc0>
    800007b2:	00005097          	auipc	ra,0x5
    800007b6:	4d6080e7          	jalr	1238(ra) # 80005c88 <panic>
      uint64 pa = PTE2PA(*pte);
    800007ba:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007bc:	0532                	slli	a0,a0,0xc
    800007be:	00000097          	auipc	ra,0x0
    800007c2:	85e080e7          	jalr	-1954(ra) # 8000001c <kfree>
    *pte = 0;
    800007c6:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ca:	995a                	add	s2,s2,s6
    800007cc:	f9397ce3          	bgeu	s2,s3,80000764 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007d0:	4601                	li	a2,0
    800007d2:	85ca                	mv	a1,s2
    800007d4:	8552                	mv	a0,s4
    800007d6:	00000097          	auipc	ra,0x0
    800007da:	cb0080e7          	jalr	-848(ra) # 80000486 <walk>
    800007de:	84aa                	mv	s1,a0
    800007e0:	d54d                	beqz	a0,8000078a <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007e2:	6108                	ld	a0,0(a0)
    800007e4:	00157793          	andi	a5,a0,1
    800007e8:	dbcd                	beqz	a5,8000079a <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007ea:	3ff57793          	andi	a5,a0,1023
    800007ee:	fb778ee3          	beq	a5,s7,800007aa <uvmunmap+0x76>
    if(do_free){
    800007f2:	fc0a8ae3          	beqz	s5,800007c6 <uvmunmap+0x92>
    800007f6:	b7d1                	j	800007ba <uvmunmap+0x86>

00000000800007f8 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007f8:	1101                	addi	sp,sp,-32
    800007fa:	ec06                	sd	ra,24(sp)
    800007fc:	e822                	sd	s0,16(sp)
    800007fe:	e426                	sd	s1,8(sp)
    80000800:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000802:	00000097          	auipc	ra,0x0
    80000806:	916080e7          	jalr	-1770(ra) # 80000118 <kalloc>
    8000080a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000080c:	c519                	beqz	a0,8000081a <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000080e:	6605                	lui	a2,0x1
    80000810:	4581                	li	a1,0
    80000812:	00000097          	auipc	ra,0x0
    80000816:	98c080e7          	jalr	-1652(ra) # 8000019e <memset>
  return pagetable;
}
    8000081a:	8526                	mv	a0,s1
    8000081c:	60e2                	ld	ra,24(sp)
    8000081e:	6442                	ld	s0,16(sp)
    80000820:	64a2                	ld	s1,8(sp)
    80000822:	6105                	addi	sp,sp,32
    80000824:	8082                	ret

0000000080000826 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000826:	7179                	addi	sp,sp,-48
    80000828:	f406                	sd	ra,40(sp)
    8000082a:	f022                	sd	s0,32(sp)
    8000082c:	ec26                	sd	s1,24(sp)
    8000082e:	e84a                	sd	s2,16(sp)
    80000830:	e44e                	sd	s3,8(sp)
    80000832:	e052                	sd	s4,0(sp)
    80000834:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000836:	6785                	lui	a5,0x1
    80000838:	04f67863          	bgeu	a2,a5,80000888 <uvminit+0x62>
    8000083c:	8a2a                	mv	s4,a0
    8000083e:	89ae                	mv	s3,a1
    80000840:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000842:	00000097          	auipc	ra,0x0
    80000846:	8d6080e7          	jalr	-1834(ra) # 80000118 <kalloc>
    8000084a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000084c:	6605                	lui	a2,0x1
    8000084e:	4581                	li	a1,0
    80000850:	00000097          	auipc	ra,0x0
    80000854:	94e080e7          	jalr	-1714(ra) # 8000019e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000858:	4779                	li	a4,30
    8000085a:	86ca                	mv	a3,s2
    8000085c:	6605                	lui	a2,0x1
    8000085e:	4581                	li	a1,0
    80000860:	8552                	mv	a0,s4
    80000862:	00000097          	auipc	ra,0x0
    80000866:	d0c080e7          	jalr	-756(ra) # 8000056e <mappages>
  memmove(mem, src, sz);
    8000086a:	8626                	mv	a2,s1
    8000086c:	85ce                	mv	a1,s3
    8000086e:	854a                	mv	a0,s2
    80000870:	00000097          	auipc	ra,0x0
    80000874:	98e080e7          	jalr	-1650(ra) # 800001fe <memmove>
}
    80000878:	70a2                	ld	ra,40(sp)
    8000087a:	7402                	ld	s0,32(sp)
    8000087c:	64e2                	ld	s1,24(sp)
    8000087e:	6942                	ld	s2,16(sp)
    80000880:	69a2                	ld	s3,8(sp)
    80000882:	6a02                	ld	s4,0(sp)
    80000884:	6145                	addi	sp,sp,48
    80000886:	8082                	ret
    panic("inituvm: more than a page");
    80000888:	00008517          	auipc	a0,0x8
    8000088c:	85050513          	addi	a0,a0,-1968 # 800080d8 <etext+0xd8>
    80000890:	00005097          	auipc	ra,0x5
    80000894:	3f8080e7          	jalr	1016(ra) # 80005c88 <panic>

0000000080000898 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000898:	1101                	addi	sp,sp,-32
    8000089a:	ec06                	sd	ra,24(sp)
    8000089c:	e822                	sd	s0,16(sp)
    8000089e:	e426                	sd	s1,8(sp)
    800008a0:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008a2:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008a4:	00b67d63          	bgeu	a2,a1,800008be <uvmdealloc+0x26>
    800008a8:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008aa:	6785                	lui	a5,0x1
    800008ac:	17fd                	addi	a5,a5,-1
    800008ae:	00f60733          	add	a4,a2,a5
    800008b2:	767d                	lui	a2,0xfffff
    800008b4:	8f71                	and	a4,a4,a2
    800008b6:	97ae                	add	a5,a5,a1
    800008b8:	8ff1                	and	a5,a5,a2
    800008ba:	00f76863          	bltu	a4,a5,800008ca <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008be:	8526                	mv	a0,s1
    800008c0:	60e2                	ld	ra,24(sp)
    800008c2:	6442                	ld	s0,16(sp)
    800008c4:	64a2                	ld	s1,8(sp)
    800008c6:	6105                	addi	sp,sp,32
    800008c8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008ca:	8f99                	sub	a5,a5,a4
    800008cc:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008ce:	4685                	li	a3,1
    800008d0:	0007861b          	sext.w	a2,a5
    800008d4:	85ba                	mv	a1,a4
    800008d6:	00000097          	auipc	ra,0x0
    800008da:	e5e080e7          	jalr	-418(ra) # 80000734 <uvmunmap>
    800008de:	b7c5                	j	800008be <uvmdealloc+0x26>

00000000800008e0 <uvmalloc>:
  if(newsz < oldsz)
    800008e0:	0ab66163          	bltu	a2,a1,80000982 <uvmalloc+0xa2>
{
    800008e4:	7139                	addi	sp,sp,-64
    800008e6:	fc06                	sd	ra,56(sp)
    800008e8:	f822                	sd	s0,48(sp)
    800008ea:	f426                	sd	s1,40(sp)
    800008ec:	f04a                	sd	s2,32(sp)
    800008ee:	ec4e                	sd	s3,24(sp)
    800008f0:	e852                	sd	s4,16(sp)
    800008f2:	e456                	sd	s5,8(sp)
    800008f4:	0080                	addi	s0,sp,64
    800008f6:	8aaa                	mv	s5,a0
    800008f8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008fa:	6985                	lui	s3,0x1
    800008fc:	19fd                	addi	s3,s3,-1
    800008fe:	95ce                	add	a1,a1,s3
    80000900:	79fd                	lui	s3,0xfffff
    80000902:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000906:	08c9f063          	bgeu	s3,a2,80000986 <uvmalloc+0xa6>
    8000090a:	894e                	mv	s2,s3
    mem = kalloc();
    8000090c:	00000097          	auipc	ra,0x0
    80000910:	80c080e7          	jalr	-2036(ra) # 80000118 <kalloc>
    80000914:	84aa                	mv	s1,a0
    if(mem == 0){
    80000916:	c51d                	beqz	a0,80000944 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000918:	6605                	lui	a2,0x1
    8000091a:	4581                	li	a1,0
    8000091c:	00000097          	auipc	ra,0x0
    80000920:	882080e7          	jalr	-1918(ra) # 8000019e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000924:	4779                	li	a4,30
    80000926:	86a6                	mv	a3,s1
    80000928:	6605                	lui	a2,0x1
    8000092a:	85ca                	mv	a1,s2
    8000092c:	8556                	mv	a0,s5
    8000092e:	00000097          	auipc	ra,0x0
    80000932:	c40080e7          	jalr	-960(ra) # 8000056e <mappages>
    80000936:	e905                	bnez	a0,80000966 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000938:	6785                	lui	a5,0x1
    8000093a:	993e                	add	s2,s2,a5
    8000093c:	fd4968e3          	bltu	s2,s4,8000090c <uvmalloc+0x2c>
  return newsz;
    80000940:	8552                	mv	a0,s4
    80000942:	a809                	j	80000954 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000944:	864e                	mv	a2,s3
    80000946:	85ca                	mv	a1,s2
    80000948:	8556                	mv	a0,s5
    8000094a:	00000097          	auipc	ra,0x0
    8000094e:	f4e080e7          	jalr	-178(ra) # 80000898 <uvmdealloc>
      return 0;
    80000952:	4501                	li	a0,0
}
    80000954:	70e2                	ld	ra,56(sp)
    80000956:	7442                	ld	s0,48(sp)
    80000958:	74a2                	ld	s1,40(sp)
    8000095a:	7902                	ld	s2,32(sp)
    8000095c:	69e2                	ld	s3,24(sp)
    8000095e:	6a42                	ld	s4,16(sp)
    80000960:	6aa2                	ld	s5,8(sp)
    80000962:	6121                	addi	sp,sp,64
    80000964:	8082                	ret
      kfree(mem);
    80000966:	8526                	mv	a0,s1
    80000968:	fffff097          	auipc	ra,0xfffff
    8000096c:	6b4080e7          	jalr	1716(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000970:	864e                	mv	a2,s3
    80000972:	85ca                	mv	a1,s2
    80000974:	8556                	mv	a0,s5
    80000976:	00000097          	auipc	ra,0x0
    8000097a:	f22080e7          	jalr	-222(ra) # 80000898 <uvmdealloc>
      return 0;
    8000097e:	4501                	li	a0,0
    80000980:	bfd1                	j	80000954 <uvmalloc+0x74>
    return oldsz;
    80000982:	852e                	mv	a0,a1
}
    80000984:	8082                	ret
  return newsz;
    80000986:	8532                	mv	a0,a2
    80000988:	b7f1                	j	80000954 <uvmalloc+0x74>

000000008000098a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000098a:	7179                	addi	sp,sp,-48
    8000098c:	f406                	sd	ra,40(sp)
    8000098e:	f022                	sd	s0,32(sp)
    80000990:	ec26                	sd	s1,24(sp)
    80000992:	e84a                	sd	s2,16(sp)
    80000994:	e44e                	sd	s3,8(sp)
    80000996:	e052                	sd	s4,0(sp)
    80000998:	1800                	addi	s0,sp,48
    8000099a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000099c:	84aa                	mv	s1,a0
    8000099e:	6905                	lui	s2,0x1
    800009a0:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a2:	4985                	li	s3,1
    800009a4:	a821                	j	800009bc <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009a6:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009a8:	0532                	slli	a0,a0,0xc
    800009aa:	00000097          	auipc	ra,0x0
    800009ae:	fe0080e7          	jalr	-32(ra) # 8000098a <freewalk>
      pagetable[i] = 0;
    800009b2:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009b6:	04a1                	addi	s1,s1,8
    800009b8:	03248163          	beq	s1,s2,800009da <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009bc:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009be:	00f57793          	andi	a5,a0,15
    800009c2:	ff3782e3          	beq	a5,s3,800009a6 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009c6:	8905                	andi	a0,a0,1
    800009c8:	d57d                	beqz	a0,800009b6 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009ca:	00007517          	auipc	a0,0x7
    800009ce:	72e50513          	addi	a0,a0,1838 # 800080f8 <etext+0xf8>
    800009d2:	00005097          	auipc	ra,0x5
    800009d6:	2b6080e7          	jalr	694(ra) # 80005c88 <panic>
    }
  }
  kfree((void*)pagetable);
    800009da:	8552                	mv	a0,s4
    800009dc:	fffff097          	auipc	ra,0xfffff
    800009e0:	640080e7          	jalr	1600(ra) # 8000001c <kfree>
}
    800009e4:	70a2                	ld	ra,40(sp)
    800009e6:	7402                	ld	s0,32(sp)
    800009e8:	64e2                	ld	s1,24(sp)
    800009ea:	6942                	ld	s2,16(sp)
    800009ec:	69a2                	ld	s3,8(sp)
    800009ee:	6a02                	ld	s4,0(sp)
    800009f0:	6145                	addi	sp,sp,48
    800009f2:	8082                	ret

00000000800009f4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009f4:	1101                	addi	sp,sp,-32
    800009f6:	ec06                	sd	ra,24(sp)
    800009f8:	e822                	sd	s0,16(sp)
    800009fa:	e426                	sd	s1,8(sp)
    800009fc:	1000                	addi	s0,sp,32
    800009fe:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a00:	e999                	bnez	a1,80000a16 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a02:	8526                	mv	a0,s1
    80000a04:	00000097          	auipc	ra,0x0
    80000a08:	f86080e7          	jalr	-122(ra) # 8000098a <freewalk>
}
    80000a0c:	60e2                	ld	ra,24(sp)
    80000a0e:	6442                	ld	s0,16(sp)
    80000a10:	64a2                	ld	s1,8(sp)
    80000a12:	6105                	addi	sp,sp,32
    80000a14:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a16:	6605                	lui	a2,0x1
    80000a18:	167d                	addi	a2,a2,-1
    80000a1a:	962e                	add	a2,a2,a1
    80000a1c:	4685                	li	a3,1
    80000a1e:	8231                	srli	a2,a2,0xc
    80000a20:	4581                	li	a1,0
    80000a22:	00000097          	auipc	ra,0x0
    80000a26:	d12080e7          	jalr	-750(ra) # 80000734 <uvmunmap>
    80000a2a:	bfe1                	j	80000a02 <uvmfree+0xe>

0000000080000a2c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a2c:	c679                	beqz	a2,80000afa <uvmcopy+0xce>
{
    80000a2e:	715d                	addi	sp,sp,-80
    80000a30:	e486                	sd	ra,72(sp)
    80000a32:	e0a2                	sd	s0,64(sp)
    80000a34:	fc26                	sd	s1,56(sp)
    80000a36:	f84a                	sd	s2,48(sp)
    80000a38:	f44e                	sd	s3,40(sp)
    80000a3a:	f052                	sd	s4,32(sp)
    80000a3c:	ec56                	sd	s5,24(sp)
    80000a3e:	e85a                	sd	s6,16(sp)
    80000a40:	e45e                	sd	s7,8(sp)
    80000a42:	0880                	addi	s0,sp,80
    80000a44:	8b2a                	mv	s6,a0
    80000a46:	8aae                	mv	s5,a1
    80000a48:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a4a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a4c:	4601                	li	a2,0
    80000a4e:	85ce                	mv	a1,s3
    80000a50:	855a                	mv	a0,s6
    80000a52:	00000097          	auipc	ra,0x0
    80000a56:	a34080e7          	jalr	-1484(ra) # 80000486 <walk>
    80000a5a:	c531                	beqz	a0,80000aa6 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a5c:	6118                	ld	a4,0(a0)
    80000a5e:	00177793          	andi	a5,a4,1
    80000a62:	cbb1                	beqz	a5,80000ab6 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a64:	00a75593          	srli	a1,a4,0xa
    80000a68:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a6c:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a70:	fffff097          	auipc	ra,0xfffff
    80000a74:	6a8080e7          	jalr	1704(ra) # 80000118 <kalloc>
    80000a78:	892a                	mv	s2,a0
    80000a7a:	c939                	beqz	a0,80000ad0 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a7c:	6605                	lui	a2,0x1
    80000a7e:	85de                	mv	a1,s7
    80000a80:	fffff097          	auipc	ra,0xfffff
    80000a84:	77e080e7          	jalr	1918(ra) # 800001fe <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a88:	8726                	mv	a4,s1
    80000a8a:	86ca                	mv	a3,s2
    80000a8c:	6605                	lui	a2,0x1
    80000a8e:	85ce                	mv	a1,s3
    80000a90:	8556                	mv	a0,s5
    80000a92:	00000097          	auipc	ra,0x0
    80000a96:	adc080e7          	jalr	-1316(ra) # 8000056e <mappages>
    80000a9a:	e515                	bnez	a0,80000ac6 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a9c:	6785                	lui	a5,0x1
    80000a9e:	99be                	add	s3,s3,a5
    80000aa0:	fb49e6e3          	bltu	s3,s4,80000a4c <uvmcopy+0x20>
    80000aa4:	a081                	j	80000ae4 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000aa6:	00007517          	auipc	a0,0x7
    80000aaa:	66250513          	addi	a0,a0,1634 # 80008108 <etext+0x108>
    80000aae:	00005097          	auipc	ra,0x5
    80000ab2:	1da080e7          	jalr	474(ra) # 80005c88 <panic>
      panic("uvmcopy: page not present");
    80000ab6:	00007517          	auipc	a0,0x7
    80000aba:	67250513          	addi	a0,a0,1650 # 80008128 <etext+0x128>
    80000abe:	00005097          	auipc	ra,0x5
    80000ac2:	1ca080e7          	jalr	458(ra) # 80005c88 <panic>
      kfree(mem);
    80000ac6:	854a                	mv	a0,s2
    80000ac8:	fffff097          	auipc	ra,0xfffff
    80000acc:	554080e7          	jalr	1364(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ad0:	4685                	li	a3,1
    80000ad2:	00c9d613          	srli	a2,s3,0xc
    80000ad6:	4581                	li	a1,0
    80000ad8:	8556                	mv	a0,s5
    80000ada:	00000097          	auipc	ra,0x0
    80000ade:	c5a080e7          	jalr	-934(ra) # 80000734 <uvmunmap>
  return -1;
    80000ae2:	557d                	li	a0,-1
}
    80000ae4:	60a6                	ld	ra,72(sp)
    80000ae6:	6406                	ld	s0,64(sp)
    80000ae8:	74e2                	ld	s1,56(sp)
    80000aea:	7942                	ld	s2,48(sp)
    80000aec:	79a2                	ld	s3,40(sp)
    80000aee:	7a02                	ld	s4,32(sp)
    80000af0:	6ae2                	ld	s5,24(sp)
    80000af2:	6b42                	ld	s6,16(sp)
    80000af4:	6ba2                	ld	s7,8(sp)
    80000af6:	6161                	addi	sp,sp,80
    80000af8:	8082                	ret
  return 0;
    80000afa:	4501                	li	a0,0
}
    80000afc:	8082                	ret

0000000080000afe <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000afe:	1141                	addi	sp,sp,-16
    80000b00:	e406                	sd	ra,8(sp)
    80000b02:	e022                	sd	s0,0(sp)
    80000b04:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b06:	4601                	li	a2,0
    80000b08:	00000097          	auipc	ra,0x0
    80000b0c:	97e080e7          	jalr	-1666(ra) # 80000486 <walk>
  if(pte == 0)
    80000b10:	c901                	beqz	a0,80000b20 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b12:	611c                	ld	a5,0(a0)
    80000b14:	9bbd                	andi	a5,a5,-17
    80000b16:	e11c                	sd	a5,0(a0)
}
    80000b18:	60a2                	ld	ra,8(sp)
    80000b1a:	6402                	ld	s0,0(sp)
    80000b1c:	0141                	addi	sp,sp,16
    80000b1e:	8082                	ret
    panic("uvmclear");
    80000b20:	00007517          	auipc	a0,0x7
    80000b24:	62850513          	addi	a0,a0,1576 # 80008148 <etext+0x148>
    80000b28:	00005097          	auipc	ra,0x5
    80000b2c:	160080e7          	jalr	352(ra) # 80005c88 <panic>

0000000080000b30 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b30:	c6bd                	beqz	a3,80000b9e <copyout+0x6e>
{
    80000b32:	715d                	addi	sp,sp,-80
    80000b34:	e486                	sd	ra,72(sp)
    80000b36:	e0a2                	sd	s0,64(sp)
    80000b38:	fc26                	sd	s1,56(sp)
    80000b3a:	f84a                	sd	s2,48(sp)
    80000b3c:	f44e                	sd	s3,40(sp)
    80000b3e:	f052                	sd	s4,32(sp)
    80000b40:	ec56                	sd	s5,24(sp)
    80000b42:	e85a                	sd	s6,16(sp)
    80000b44:	e45e                	sd	s7,8(sp)
    80000b46:	e062                	sd	s8,0(sp)
    80000b48:	0880                	addi	s0,sp,80
    80000b4a:	8b2a                	mv	s6,a0
    80000b4c:	8c2e                	mv	s8,a1
    80000b4e:	8a32                	mv	s4,a2
    80000b50:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b52:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b54:	6a85                	lui	s5,0x1
    80000b56:	a015                	j	80000b7a <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b58:	9562                	add	a0,a0,s8
    80000b5a:	0004861b          	sext.w	a2,s1
    80000b5e:	85d2                	mv	a1,s4
    80000b60:	41250533          	sub	a0,a0,s2
    80000b64:	fffff097          	auipc	ra,0xfffff
    80000b68:	69a080e7          	jalr	1690(ra) # 800001fe <memmove>

    len -= n;
    80000b6c:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b70:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b72:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b76:	02098263          	beqz	s3,80000b9a <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b7a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b7e:	85ca                	mv	a1,s2
    80000b80:	855a                	mv	a0,s6
    80000b82:	00000097          	auipc	ra,0x0
    80000b86:	9aa080e7          	jalr	-1622(ra) # 8000052c <walkaddr>
    if(pa0 == 0)
    80000b8a:	cd01                	beqz	a0,80000ba2 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b8c:	418904b3          	sub	s1,s2,s8
    80000b90:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b92:	fc99f3e3          	bgeu	s3,s1,80000b58 <copyout+0x28>
    80000b96:	84ce                	mv	s1,s3
    80000b98:	b7c1                	j	80000b58 <copyout+0x28>
  }
  return 0;
    80000b9a:	4501                	li	a0,0
    80000b9c:	a021                	j	80000ba4 <copyout+0x74>
    80000b9e:	4501                	li	a0,0
}
    80000ba0:	8082                	ret
      return -1;
    80000ba2:	557d                	li	a0,-1
}
    80000ba4:	60a6                	ld	ra,72(sp)
    80000ba6:	6406                	ld	s0,64(sp)
    80000ba8:	74e2                	ld	s1,56(sp)
    80000baa:	7942                	ld	s2,48(sp)
    80000bac:	79a2                	ld	s3,40(sp)
    80000bae:	7a02                	ld	s4,32(sp)
    80000bb0:	6ae2                	ld	s5,24(sp)
    80000bb2:	6b42                	ld	s6,16(sp)
    80000bb4:	6ba2                	ld	s7,8(sp)
    80000bb6:	6c02                	ld	s8,0(sp)
    80000bb8:	6161                	addi	sp,sp,80
    80000bba:	8082                	ret

0000000080000bbc <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bbc:	c6bd                	beqz	a3,80000c2a <copyin+0x6e>
{
    80000bbe:	715d                	addi	sp,sp,-80
    80000bc0:	e486                	sd	ra,72(sp)
    80000bc2:	e0a2                	sd	s0,64(sp)
    80000bc4:	fc26                	sd	s1,56(sp)
    80000bc6:	f84a                	sd	s2,48(sp)
    80000bc8:	f44e                	sd	s3,40(sp)
    80000bca:	f052                	sd	s4,32(sp)
    80000bcc:	ec56                	sd	s5,24(sp)
    80000bce:	e85a                	sd	s6,16(sp)
    80000bd0:	e45e                	sd	s7,8(sp)
    80000bd2:	e062                	sd	s8,0(sp)
    80000bd4:	0880                	addi	s0,sp,80
    80000bd6:	8b2a                	mv	s6,a0
    80000bd8:	8a2e                	mv	s4,a1
    80000bda:	8c32                	mv	s8,a2
    80000bdc:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bde:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000be0:	6a85                	lui	s5,0x1
    80000be2:	a015                	j	80000c06 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000be4:	9562                	add	a0,a0,s8
    80000be6:	0004861b          	sext.w	a2,s1
    80000bea:	412505b3          	sub	a1,a0,s2
    80000bee:	8552                	mv	a0,s4
    80000bf0:	fffff097          	auipc	ra,0xfffff
    80000bf4:	60e080e7          	jalr	1550(ra) # 800001fe <memmove>

    len -= n;
    80000bf8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bfc:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bfe:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c02:	02098263          	beqz	s3,80000c26 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c06:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c0a:	85ca                	mv	a1,s2
    80000c0c:	855a                	mv	a0,s6
    80000c0e:	00000097          	auipc	ra,0x0
    80000c12:	91e080e7          	jalr	-1762(ra) # 8000052c <walkaddr>
    if(pa0 == 0)
    80000c16:	cd01                	beqz	a0,80000c2e <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c18:	418904b3          	sub	s1,s2,s8
    80000c1c:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c1e:	fc99f3e3          	bgeu	s3,s1,80000be4 <copyin+0x28>
    80000c22:	84ce                	mv	s1,s3
    80000c24:	b7c1                	j	80000be4 <copyin+0x28>
  }
  return 0;
    80000c26:	4501                	li	a0,0
    80000c28:	a021                	j	80000c30 <copyin+0x74>
    80000c2a:	4501                	li	a0,0
}
    80000c2c:	8082                	ret
      return -1;
    80000c2e:	557d                	li	a0,-1
}
    80000c30:	60a6                	ld	ra,72(sp)
    80000c32:	6406                	ld	s0,64(sp)
    80000c34:	74e2                	ld	s1,56(sp)
    80000c36:	7942                	ld	s2,48(sp)
    80000c38:	79a2                	ld	s3,40(sp)
    80000c3a:	7a02                	ld	s4,32(sp)
    80000c3c:	6ae2                	ld	s5,24(sp)
    80000c3e:	6b42                	ld	s6,16(sp)
    80000c40:	6ba2                	ld	s7,8(sp)
    80000c42:	6c02                	ld	s8,0(sp)
    80000c44:	6161                	addi	sp,sp,80
    80000c46:	8082                	ret

0000000080000c48 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c48:	c6c5                	beqz	a3,80000cf0 <copyinstr+0xa8>
{
    80000c4a:	715d                	addi	sp,sp,-80
    80000c4c:	e486                	sd	ra,72(sp)
    80000c4e:	e0a2                	sd	s0,64(sp)
    80000c50:	fc26                	sd	s1,56(sp)
    80000c52:	f84a                	sd	s2,48(sp)
    80000c54:	f44e                	sd	s3,40(sp)
    80000c56:	f052                	sd	s4,32(sp)
    80000c58:	ec56                	sd	s5,24(sp)
    80000c5a:	e85a                	sd	s6,16(sp)
    80000c5c:	e45e                	sd	s7,8(sp)
    80000c5e:	0880                	addi	s0,sp,80
    80000c60:	8a2a                	mv	s4,a0
    80000c62:	8b2e                	mv	s6,a1
    80000c64:	8bb2                	mv	s7,a2
    80000c66:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c68:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c6a:	6985                	lui	s3,0x1
    80000c6c:	a035                	j	80000c98 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c6e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c72:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c74:	0017b793          	seqz	a5,a5
    80000c78:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c7c:	60a6                	ld	ra,72(sp)
    80000c7e:	6406                	ld	s0,64(sp)
    80000c80:	74e2                	ld	s1,56(sp)
    80000c82:	7942                	ld	s2,48(sp)
    80000c84:	79a2                	ld	s3,40(sp)
    80000c86:	7a02                	ld	s4,32(sp)
    80000c88:	6ae2                	ld	s5,24(sp)
    80000c8a:	6b42                	ld	s6,16(sp)
    80000c8c:	6ba2                	ld	s7,8(sp)
    80000c8e:	6161                	addi	sp,sp,80
    80000c90:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c92:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c96:	c8a9                	beqz	s1,80000ce8 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c98:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c9c:	85ca                	mv	a1,s2
    80000c9e:	8552                	mv	a0,s4
    80000ca0:	00000097          	auipc	ra,0x0
    80000ca4:	88c080e7          	jalr	-1908(ra) # 8000052c <walkaddr>
    if(pa0 == 0)
    80000ca8:	c131                	beqz	a0,80000cec <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000caa:	41790833          	sub	a6,s2,s7
    80000cae:	984e                	add	a6,a6,s3
    if(n > max)
    80000cb0:	0104f363          	bgeu	s1,a6,80000cb6 <copyinstr+0x6e>
    80000cb4:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cb6:	955e                	add	a0,a0,s7
    80000cb8:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cbc:	fc080be3          	beqz	a6,80000c92 <copyinstr+0x4a>
    80000cc0:	985a                	add	a6,a6,s6
    80000cc2:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000cc4:	41650633          	sub	a2,a0,s6
    80000cc8:	14fd                	addi	s1,s1,-1
    80000cca:	9b26                	add	s6,s6,s1
    80000ccc:	00f60733          	add	a4,a2,a5
    80000cd0:	00074703          	lbu	a4,0(a4)
    80000cd4:	df49                	beqz	a4,80000c6e <copyinstr+0x26>
        *dst = *p;
    80000cd6:	00e78023          	sb	a4,0(a5)
      --max;
    80000cda:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cde:	0785                	addi	a5,a5,1
    while(n > 0){
    80000ce0:	ff0796e3          	bne	a5,a6,80000ccc <copyinstr+0x84>
      dst++;
    80000ce4:	8b42                	mv	s6,a6
    80000ce6:	b775                	j	80000c92 <copyinstr+0x4a>
    80000ce8:	4781                	li	a5,0
    80000cea:	b769                	j	80000c74 <copyinstr+0x2c>
      return -1;
    80000cec:	557d                	li	a0,-1
    80000cee:	b779                	j	80000c7c <copyinstr+0x34>
  int got_null = 0;
    80000cf0:	4781                	li	a5,0
  if(got_null){
    80000cf2:	0017b793          	seqz	a5,a5
    80000cf6:	40f00533          	neg	a0,a5
}
    80000cfa:	8082                	ret

0000000080000cfc <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cfc:	7139                	addi	sp,sp,-64
    80000cfe:	fc06                	sd	ra,56(sp)
    80000d00:	f822                	sd	s0,48(sp)
    80000d02:	f426                	sd	s1,40(sp)
    80000d04:	f04a                	sd	s2,32(sp)
    80000d06:	ec4e                	sd	s3,24(sp)
    80000d08:	e852                	sd	s4,16(sp)
    80000d0a:	e456                	sd	s5,8(sp)
    80000d0c:	e05a                	sd	s6,0(sp)
    80000d0e:	0080                	addi	s0,sp,64
    80000d10:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d12:	00008497          	auipc	s1,0x8
    80000d16:	76e48493          	addi	s1,s1,1902 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d1a:	8b26                	mv	s6,s1
    80000d1c:	00007a97          	auipc	s5,0x7
    80000d20:	2e4a8a93          	addi	s5,s5,740 # 80008000 <etext>
    80000d24:	04000937          	lui	s2,0x4000
    80000d28:	197d                	addi	s2,s2,-1
    80000d2a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d2c:	0000ea17          	auipc	s4,0xe
    80000d30:	154a0a13          	addi	s4,s4,340 # 8000ee80 <tickslock>
    char *pa = kalloc();
    80000d34:	fffff097          	auipc	ra,0xfffff
    80000d38:	3e4080e7          	jalr	996(ra) # 80000118 <kalloc>
    80000d3c:	862a                	mv	a2,a0
    if(pa == 0)
    80000d3e:	c131                	beqz	a0,80000d82 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d40:	416485b3          	sub	a1,s1,s6
    80000d44:	858d                	srai	a1,a1,0x3
    80000d46:	000ab783          	ld	a5,0(s5)
    80000d4a:	02f585b3          	mul	a1,a1,a5
    80000d4e:	2585                	addiw	a1,a1,1
    80000d50:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d54:	4719                	li	a4,6
    80000d56:	6685                	lui	a3,0x1
    80000d58:	40b905b3          	sub	a1,s2,a1
    80000d5c:	854e                	mv	a0,s3
    80000d5e:	00000097          	auipc	ra,0x0
    80000d62:	8b0080e7          	jalr	-1872(ra) # 8000060e <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d66:	16848493          	addi	s1,s1,360
    80000d6a:	fd4495e3          	bne	s1,s4,80000d34 <proc_mapstacks+0x38>
  }
}
    80000d6e:	70e2                	ld	ra,56(sp)
    80000d70:	7442                	ld	s0,48(sp)
    80000d72:	74a2                	ld	s1,40(sp)
    80000d74:	7902                	ld	s2,32(sp)
    80000d76:	69e2                	ld	s3,24(sp)
    80000d78:	6a42                	ld	s4,16(sp)
    80000d7a:	6aa2                	ld	s5,8(sp)
    80000d7c:	6b02                	ld	s6,0(sp)
    80000d7e:	6121                	addi	sp,sp,64
    80000d80:	8082                	ret
      panic("kalloc");
    80000d82:	00007517          	auipc	a0,0x7
    80000d86:	3d650513          	addi	a0,a0,982 # 80008158 <etext+0x158>
    80000d8a:	00005097          	auipc	ra,0x5
    80000d8e:	efe080e7          	jalr	-258(ra) # 80005c88 <panic>

0000000080000d92 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d92:	7139                	addi	sp,sp,-64
    80000d94:	fc06                	sd	ra,56(sp)
    80000d96:	f822                	sd	s0,48(sp)
    80000d98:	f426                	sd	s1,40(sp)
    80000d9a:	f04a                	sd	s2,32(sp)
    80000d9c:	ec4e                	sd	s3,24(sp)
    80000d9e:	e852                	sd	s4,16(sp)
    80000da0:	e456                	sd	s5,8(sp)
    80000da2:	e05a                	sd	s6,0(sp)
    80000da4:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000da6:	00007597          	auipc	a1,0x7
    80000daa:	3ba58593          	addi	a1,a1,954 # 80008160 <etext+0x160>
    80000dae:	00008517          	auipc	a0,0x8
    80000db2:	2a250513          	addi	a0,a0,674 # 80009050 <pid_lock>
    80000db6:	00005097          	auipc	ra,0x5
    80000dba:	38c080e7          	jalr	908(ra) # 80006142 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dbe:	00007597          	auipc	a1,0x7
    80000dc2:	3aa58593          	addi	a1,a1,938 # 80008168 <etext+0x168>
    80000dc6:	00008517          	auipc	a0,0x8
    80000dca:	2a250513          	addi	a0,a0,674 # 80009068 <wait_lock>
    80000dce:	00005097          	auipc	ra,0x5
    80000dd2:	374080e7          	jalr	884(ra) # 80006142 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd6:	00008497          	auipc	s1,0x8
    80000dda:	6aa48493          	addi	s1,s1,1706 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000dde:	00007b17          	auipc	s6,0x7
    80000de2:	39ab0b13          	addi	s6,s6,922 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000de6:	8aa6                	mv	s5,s1
    80000de8:	00007a17          	auipc	s4,0x7
    80000dec:	218a0a13          	addi	s4,s4,536 # 80008000 <etext>
    80000df0:	04000937          	lui	s2,0x4000
    80000df4:	197d                	addi	s2,s2,-1
    80000df6:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000df8:	0000e997          	auipc	s3,0xe
    80000dfc:	08898993          	addi	s3,s3,136 # 8000ee80 <tickslock>
      initlock(&p->lock, "proc");
    80000e00:	85da                	mv	a1,s6
    80000e02:	8526                	mv	a0,s1
    80000e04:	00005097          	auipc	ra,0x5
    80000e08:	33e080e7          	jalr	830(ra) # 80006142 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e0c:	415487b3          	sub	a5,s1,s5
    80000e10:	878d                	srai	a5,a5,0x3
    80000e12:	000a3703          	ld	a4,0(s4)
    80000e16:	02e787b3          	mul	a5,a5,a4
    80000e1a:	2785                	addiw	a5,a5,1
    80000e1c:	00d7979b          	slliw	a5,a5,0xd
    80000e20:	40f907b3          	sub	a5,s2,a5
    80000e24:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e26:	16848493          	addi	s1,s1,360
    80000e2a:	fd349be3          	bne	s1,s3,80000e00 <procinit+0x6e>
  }
}
    80000e2e:	70e2                	ld	ra,56(sp)
    80000e30:	7442                	ld	s0,48(sp)
    80000e32:	74a2                	ld	s1,40(sp)
    80000e34:	7902                	ld	s2,32(sp)
    80000e36:	69e2                	ld	s3,24(sp)
    80000e38:	6a42                	ld	s4,16(sp)
    80000e3a:	6aa2                	ld	s5,8(sp)
    80000e3c:	6b02                	ld	s6,0(sp)
    80000e3e:	6121                	addi	sp,sp,64
    80000e40:	8082                	ret

0000000080000e42 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e42:	1141                	addi	sp,sp,-16
    80000e44:	e422                	sd	s0,8(sp)
    80000e46:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e48:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e4a:	2501                	sext.w	a0,a0
    80000e4c:	6422                	ld	s0,8(sp)
    80000e4e:	0141                	addi	sp,sp,16
    80000e50:	8082                	ret

0000000080000e52 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e52:	1141                	addi	sp,sp,-16
    80000e54:	e422                	sd	s0,8(sp)
    80000e56:	0800                	addi	s0,sp,16
    80000e58:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e5a:	2781                	sext.w	a5,a5
    80000e5c:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e5e:	00008517          	auipc	a0,0x8
    80000e62:	22250513          	addi	a0,a0,546 # 80009080 <cpus>
    80000e66:	953e                	add	a0,a0,a5
    80000e68:	6422                	ld	s0,8(sp)
    80000e6a:	0141                	addi	sp,sp,16
    80000e6c:	8082                	ret

0000000080000e6e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e6e:	1101                	addi	sp,sp,-32
    80000e70:	ec06                	sd	ra,24(sp)
    80000e72:	e822                	sd	s0,16(sp)
    80000e74:	e426                	sd	s1,8(sp)
    80000e76:	1000                	addi	s0,sp,32
  push_off();
    80000e78:	00005097          	auipc	ra,0x5
    80000e7c:	30e080e7          	jalr	782(ra) # 80006186 <push_off>
    80000e80:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e82:	2781                	sext.w	a5,a5
    80000e84:	079e                	slli	a5,a5,0x7
    80000e86:	00008717          	auipc	a4,0x8
    80000e8a:	1ca70713          	addi	a4,a4,458 # 80009050 <pid_lock>
    80000e8e:	97ba                	add	a5,a5,a4
    80000e90:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e92:	00005097          	auipc	ra,0x5
    80000e96:	394080e7          	jalr	916(ra) # 80006226 <pop_off>
  return p;
}
    80000e9a:	8526                	mv	a0,s1
    80000e9c:	60e2                	ld	ra,24(sp)
    80000e9e:	6442                	ld	s0,16(sp)
    80000ea0:	64a2                	ld	s1,8(sp)
    80000ea2:	6105                	addi	sp,sp,32
    80000ea4:	8082                	ret

0000000080000ea6 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ea6:	1141                	addi	sp,sp,-16
    80000ea8:	e406                	sd	ra,8(sp)
    80000eaa:	e022                	sd	s0,0(sp)
    80000eac:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000eae:	00000097          	auipc	ra,0x0
    80000eb2:	fc0080e7          	jalr	-64(ra) # 80000e6e <myproc>
    80000eb6:	00005097          	auipc	ra,0x5
    80000eba:	3d0080e7          	jalr	976(ra) # 80006286 <release>

  if (first) {
    80000ebe:	00008797          	auipc	a5,0x8
    80000ec2:	ae27a783          	lw	a5,-1310(a5) # 800089a0 <first.1684>
    80000ec6:	eb89                	bnez	a5,80000ed8 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ec8:	00001097          	auipc	ra,0x1
    80000ecc:	c48080e7          	jalr	-952(ra) # 80001b10 <usertrapret>
}
    80000ed0:	60a2                	ld	ra,8(sp)
    80000ed2:	6402                	ld	s0,0(sp)
    80000ed4:	0141                	addi	sp,sp,16
    80000ed6:	8082                	ret
    first = 0;
    80000ed8:	00008797          	auipc	a5,0x8
    80000edc:	ac07a423          	sw	zero,-1336(a5) # 800089a0 <first.1684>
    fsinit(ROOTDEV);
    80000ee0:	4505                	li	a0,1
    80000ee2:	00002097          	auipc	ra,0x2
    80000ee6:	a7a080e7          	jalr	-1414(ra) # 8000295c <fsinit>
    80000eea:	bff9                	j	80000ec8 <forkret+0x22>

0000000080000eec <allocpid>:
allocpid() {
    80000eec:	1101                	addi	sp,sp,-32
    80000eee:	ec06                	sd	ra,24(sp)
    80000ef0:	e822                	sd	s0,16(sp)
    80000ef2:	e426                	sd	s1,8(sp)
    80000ef4:	e04a                	sd	s2,0(sp)
    80000ef6:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ef8:	00008917          	auipc	s2,0x8
    80000efc:	15890913          	addi	s2,s2,344 # 80009050 <pid_lock>
    80000f00:	854a                	mv	a0,s2
    80000f02:	00005097          	auipc	ra,0x5
    80000f06:	2d0080e7          	jalr	720(ra) # 800061d2 <acquire>
  pid = nextpid;
    80000f0a:	00008797          	auipc	a5,0x8
    80000f0e:	a9a78793          	addi	a5,a5,-1382 # 800089a4 <nextpid>
    80000f12:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f14:	0014871b          	addiw	a4,s1,1
    80000f18:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f1a:	854a                	mv	a0,s2
    80000f1c:	00005097          	auipc	ra,0x5
    80000f20:	36a080e7          	jalr	874(ra) # 80006286 <release>
}
    80000f24:	8526                	mv	a0,s1
    80000f26:	60e2                	ld	ra,24(sp)
    80000f28:	6442                	ld	s0,16(sp)
    80000f2a:	64a2                	ld	s1,8(sp)
    80000f2c:	6902                	ld	s2,0(sp)
    80000f2e:	6105                	addi	sp,sp,32
    80000f30:	8082                	ret

0000000080000f32 <calUnproc>:
{
    80000f32:	1141                	addi	sp,sp,-16
    80000f34:	e422                	sd	s0,8(sp)
    80000f36:	0800                	addi	s0,sp,16
	*cnt = 0;
    80000f38:	00053023          	sd	zero,0(a0)
	for(p = proc; p < &proc[NPROC]; p++)
    80000f3c:	00008797          	auipc	a5,0x8
    80000f40:	54478793          	addi	a5,a5,1348 # 80009480 <proc>
    80000f44:	0000e697          	auipc	a3,0xe
    80000f48:	f3c68693          	addi	a3,a3,-196 # 8000ee80 <tickslock>
    80000f4c:	a029                	j	80000f56 <calUnproc+0x24>
    80000f4e:	16878793          	addi	a5,a5,360
    80000f52:	00d78863          	beq	a5,a3,80000f62 <calUnproc+0x30>
		if(p->state != UNUSED)
    80000f56:	4f98                	lw	a4,24(a5)
    80000f58:	db7d                	beqz	a4,80000f4e <calUnproc+0x1c>
			*cnt += 1;
    80000f5a:	6118                	ld	a4,0(a0)
    80000f5c:	0705                	addi	a4,a4,1
    80000f5e:	e118                	sd	a4,0(a0)
    80000f60:	b7fd                	j	80000f4e <calUnproc+0x1c>
}
    80000f62:	6422                	ld	s0,8(sp)
    80000f64:	0141                	addi	sp,sp,16
    80000f66:	8082                	ret

0000000080000f68 <proc_pagetable>:
{
    80000f68:	1101                	addi	sp,sp,-32
    80000f6a:	ec06                	sd	ra,24(sp)
    80000f6c:	e822                	sd	s0,16(sp)
    80000f6e:	e426                	sd	s1,8(sp)
    80000f70:	e04a                	sd	s2,0(sp)
    80000f72:	1000                	addi	s0,sp,32
    80000f74:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f76:	00000097          	auipc	ra,0x0
    80000f7a:	882080e7          	jalr	-1918(ra) # 800007f8 <uvmcreate>
    80000f7e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f80:	c121                	beqz	a0,80000fc0 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f82:	4729                	li	a4,10
    80000f84:	00006697          	auipc	a3,0x6
    80000f88:	07c68693          	addi	a3,a3,124 # 80007000 <_trampoline>
    80000f8c:	6605                	lui	a2,0x1
    80000f8e:	040005b7          	lui	a1,0x4000
    80000f92:	15fd                	addi	a1,a1,-1
    80000f94:	05b2                	slli	a1,a1,0xc
    80000f96:	fffff097          	auipc	ra,0xfffff
    80000f9a:	5d8080e7          	jalr	1496(ra) # 8000056e <mappages>
    80000f9e:	02054863          	bltz	a0,80000fce <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fa2:	4719                	li	a4,6
    80000fa4:	05893683          	ld	a3,88(s2)
    80000fa8:	6605                	lui	a2,0x1
    80000faa:	020005b7          	lui	a1,0x2000
    80000fae:	15fd                	addi	a1,a1,-1
    80000fb0:	05b6                	slli	a1,a1,0xd
    80000fb2:	8526                	mv	a0,s1
    80000fb4:	fffff097          	auipc	ra,0xfffff
    80000fb8:	5ba080e7          	jalr	1466(ra) # 8000056e <mappages>
    80000fbc:	02054163          	bltz	a0,80000fde <proc_pagetable+0x76>
}
    80000fc0:	8526                	mv	a0,s1
    80000fc2:	60e2                	ld	ra,24(sp)
    80000fc4:	6442                	ld	s0,16(sp)
    80000fc6:	64a2                	ld	s1,8(sp)
    80000fc8:	6902                	ld	s2,0(sp)
    80000fca:	6105                	addi	sp,sp,32
    80000fcc:	8082                	ret
    uvmfree(pagetable, 0);
    80000fce:	4581                	li	a1,0
    80000fd0:	8526                	mv	a0,s1
    80000fd2:	00000097          	auipc	ra,0x0
    80000fd6:	a22080e7          	jalr	-1502(ra) # 800009f4 <uvmfree>
    return 0;
    80000fda:	4481                	li	s1,0
    80000fdc:	b7d5                	j	80000fc0 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fde:	4681                	li	a3,0
    80000fe0:	4605                	li	a2,1
    80000fe2:	040005b7          	lui	a1,0x4000
    80000fe6:	15fd                	addi	a1,a1,-1
    80000fe8:	05b2                	slli	a1,a1,0xc
    80000fea:	8526                	mv	a0,s1
    80000fec:	fffff097          	auipc	ra,0xfffff
    80000ff0:	748080e7          	jalr	1864(ra) # 80000734 <uvmunmap>
    uvmfree(pagetable, 0);
    80000ff4:	4581                	li	a1,0
    80000ff6:	8526                	mv	a0,s1
    80000ff8:	00000097          	auipc	ra,0x0
    80000ffc:	9fc080e7          	jalr	-1540(ra) # 800009f4 <uvmfree>
    return 0;
    80001000:	4481                	li	s1,0
    80001002:	bf7d                	j	80000fc0 <proc_pagetable+0x58>

0000000080001004 <proc_freepagetable>:
{
    80001004:	1101                	addi	sp,sp,-32
    80001006:	ec06                	sd	ra,24(sp)
    80001008:	e822                	sd	s0,16(sp)
    8000100a:	e426                	sd	s1,8(sp)
    8000100c:	e04a                	sd	s2,0(sp)
    8000100e:	1000                	addi	s0,sp,32
    80001010:	84aa                	mv	s1,a0
    80001012:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001014:	4681                	li	a3,0
    80001016:	4605                	li	a2,1
    80001018:	040005b7          	lui	a1,0x4000
    8000101c:	15fd                	addi	a1,a1,-1
    8000101e:	05b2                	slli	a1,a1,0xc
    80001020:	fffff097          	auipc	ra,0xfffff
    80001024:	714080e7          	jalr	1812(ra) # 80000734 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001028:	4681                	li	a3,0
    8000102a:	4605                	li	a2,1
    8000102c:	020005b7          	lui	a1,0x2000
    80001030:	15fd                	addi	a1,a1,-1
    80001032:	05b6                	slli	a1,a1,0xd
    80001034:	8526                	mv	a0,s1
    80001036:	fffff097          	auipc	ra,0xfffff
    8000103a:	6fe080e7          	jalr	1790(ra) # 80000734 <uvmunmap>
  uvmfree(pagetable, sz);
    8000103e:	85ca                	mv	a1,s2
    80001040:	8526                	mv	a0,s1
    80001042:	00000097          	auipc	ra,0x0
    80001046:	9b2080e7          	jalr	-1614(ra) # 800009f4 <uvmfree>
}
    8000104a:	60e2                	ld	ra,24(sp)
    8000104c:	6442                	ld	s0,16(sp)
    8000104e:	64a2                	ld	s1,8(sp)
    80001050:	6902                	ld	s2,0(sp)
    80001052:	6105                	addi	sp,sp,32
    80001054:	8082                	ret

0000000080001056 <freeproc>:
{
    80001056:	1101                	addi	sp,sp,-32
    80001058:	ec06                	sd	ra,24(sp)
    8000105a:	e822                	sd	s0,16(sp)
    8000105c:	e426                	sd	s1,8(sp)
    8000105e:	1000                	addi	s0,sp,32
    80001060:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001062:	6d28                	ld	a0,88(a0)
    80001064:	c509                	beqz	a0,8000106e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001066:	fffff097          	auipc	ra,0xfffff
    8000106a:	fb6080e7          	jalr	-74(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000106e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001072:	68a8                	ld	a0,80(s1)
    80001074:	c511                	beqz	a0,80001080 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001076:	64ac                	ld	a1,72(s1)
    80001078:	00000097          	auipc	ra,0x0
    8000107c:	f8c080e7          	jalr	-116(ra) # 80001004 <proc_freepagetable>
  p->pagetable = 0;
    80001080:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001084:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001088:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000108c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001090:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001094:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001098:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000109c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010a0:	0004ac23          	sw	zero,24(s1)
}
    800010a4:	60e2                	ld	ra,24(sp)
    800010a6:	6442                	ld	s0,16(sp)
    800010a8:	64a2                	ld	s1,8(sp)
    800010aa:	6105                	addi	sp,sp,32
    800010ac:	8082                	ret

00000000800010ae <allocproc>:
{
    800010ae:	1101                	addi	sp,sp,-32
    800010b0:	ec06                	sd	ra,24(sp)
    800010b2:	e822                	sd	s0,16(sp)
    800010b4:	e426                	sd	s1,8(sp)
    800010b6:	e04a                	sd	s2,0(sp)
    800010b8:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ba:	00008497          	auipc	s1,0x8
    800010be:	3c648493          	addi	s1,s1,966 # 80009480 <proc>
    800010c2:	0000e917          	auipc	s2,0xe
    800010c6:	dbe90913          	addi	s2,s2,-578 # 8000ee80 <tickslock>
    acquire(&p->lock);
    800010ca:	8526                	mv	a0,s1
    800010cc:	00005097          	auipc	ra,0x5
    800010d0:	106080e7          	jalr	262(ra) # 800061d2 <acquire>
    if(p->state == UNUSED) {
    800010d4:	4c9c                	lw	a5,24(s1)
    800010d6:	cf81                	beqz	a5,800010ee <allocproc+0x40>
      release(&p->lock);
    800010d8:	8526                	mv	a0,s1
    800010da:	00005097          	auipc	ra,0x5
    800010de:	1ac080e7          	jalr	428(ra) # 80006286 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010e2:	16848493          	addi	s1,s1,360
    800010e6:	ff2492e3          	bne	s1,s2,800010ca <allocproc+0x1c>
  return 0;
    800010ea:	4481                	li	s1,0
    800010ec:	a889                	j	8000113e <allocproc+0x90>
  p->pid = allocpid();
    800010ee:	00000097          	auipc	ra,0x0
    800010f2:	dfe080e7          	jalr	-514(ra) # 80000eec <allocpid>
    800010f6:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010f8:	4785                	li	a5,1
    800010fa:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010fc:	fffff097          	auipc	ra,0xfffff
    80001100:	01c080e7          	jalr	28(ra) # 80000118 <kalloc>
    80001104:	892a                	mv	s2,a0
    80001106:	eca8                	sd	a0,88(s1)
    80001108:	c131                	beqz	a0,8000114c <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    8000110a:	8526                	mv	a0,s1
    8000110c:	00000097          	auipc	ra,0x0
    80001110:	e5c080e7          	jalr	-420(ra) # 80000f68 <proc_pagetable>
    80001114:	892a                	mv	s2,a0
    80001116:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001118:	c531                	beqz	a0,80001164 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000111a:	07000613          	li	a2,112
    8000111e:	4581                	li	a1,0
    80001120:	06048513          	addi	a0,s1,96
    80001124:	fffff097          	auipc	ra,0xfffff
    80001128:	07a080e7          	jalr	122(ra) # 8000019e <memset>
  p->context.ra = (uint64)forkret;
    8000112c:	00000797          	auipc	a5,0x0
    80001130:	d7a78793          	addi	a5,a5,-646 # 80000ea6 <forkret>
    80001134:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001136:	60bc                	ld	a5,64(s1)
    80001138:	6705                	lui	a4,0x1
    8000113a:	97ba                	add	a5,a5,a4
    8000113c:	f4bc                	sd	a5,104(s1)
}
    8000113e:	8526                	mv	a0,s1
    80001140:	60e2                	ld	ra,24(sp)
    80001142:	6442                	ld	s0,16(sp)
    80001144:	64a2                	ld	s1,8(sp)
    80001146:	6902                	ld	s2,0(sp)
    80001148:	6105                	addi	sp,sp,32
    8000114a:	8082                	ret
    freeproc(p);
    8000114c:	8526                	mv	a0,s1
    8000114e:	00000097          	auipc	ra,0x0
    80001152:	f08080e7          	jalr	-248(ra) # 80001056 <freeproc>
    release(&p->lock);
    80001156:	8526                	mv	a0,s1
    80001158:	00005097          	auipc	ra,0x5
    8000115c:	12e080e7          	jalr	302(ra) # 80006286 <release>
    return 0;
    80001160:	84ca                	mv	s1,s2
    80001162:	bff1                	j	8000113e <allocproc+0x90>
    freeproc(p);
    80001164:	8526                	mv	a0,s1
    80001166:	00000097          	auipc	ra,0x0
    8000116a:	ef0080e7          	jalr	-272(ra) # 80001056 <freeproc>
    release(&p->lock);
    8000116e:	8526                	mv	a0,s1
    80001170:	00005097          	auipc	ra,0x5
    80001174:	116080e7          	jalr	278(ra) # 80006286 <release>
    return 0;
    80001178:	84ca                	mv	s1,s2
    8000117a:	b7d1                	j	8000113e <allocproc+0x90>

000000008000117c <userinit>:
{
    8000117c:	1101                	addi	sp,sp,-32
    8000117e:	ec06                	sd	ra,24(sp)
    80001180:	e822                	sd	s0,16(sp)
    80001182:	e426                	sd	s1,8(sp)
    80001184:	1000                	addi	s0,sp,32
  p = allocproc();
    80001186:	00000097          	auipc	ra,0x0
    8000118a:	f28080e7          	jalr	-216(ra) # 800010ae <allocproc>
    8000118e:	84aa                	mv	s1,a0
  initproc = p;
    80001190:	00008797          	auipc	a5,0x8
    80001194:	e8a7b023          	sd	a0,-384(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001198:	03400613          	li	a2,52
    8000119c:	00008597          	auipc	a1,0x8
    800011a0:	81458593          	addi	a1,a1,-2028 # 800089b0 <initcode>
    800011a4:	6928                	ld	a0,80(a0)
    800011a6:	fffff097          	auipc	ra,0xfffff
    800011aa:	680080e7          	jalr	1664(ra) # 80000826 <uvminit>
  p->sz = PGSIZE;
    800011ae:	6785                	lui	a5,0x1
    800011b0:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011b2:	6cb8                	ld	a4,88(s1)
    800011b4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011b8:	6cb8                	ld	a4,88(s1)
    800011ba:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011bc:	4641                	li	a2,16
    800011be:	00007597          	auipc	a1,0x7
    800011c2:	fc258593          	addi	a1,a1,-62 # 80008180 <etext+0x180>
    800011c6:	15848513          	addi	a0,s1,344
    800011ca:	fffff097          	auipc	ra,0xfffff
    800011ce:	126080e7          	jalr	294(ra) # 800002f0 <safestrcpy>
  p->cwd = namei("/");
    800011d2:	00007517          	auipc	a0,0x7
    800011d6:	fbe50513          	addi	a0,a0,-66 # 80008190 <etext+0x190>
    800011da:	00002097          	auipc	ra,0x2
    800011de:	1b0080e7          	jalr	432(ra) # 8000338a <namei>
    800011e2:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011e6:	478d                	li	a5,3
    800011e8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011ea:	8526                	mv	a0,s1
    800011ec:	00005097          	auipc	ra,0x5
    800011f0:	09a080e7          	jalr	154(ra) # 80006286 <release>
}
    800011f4:	60e2                	ld	ra,24(sp)
    800011f6:	6442                	ld	s0,16(sp)
    800011f8:	64a2                	ld	s1,8(sp)
    800011fa:	6105                	addi	sp,sp,32
    800011fc:	8082                	ret

00000000800011fe <growproc>:
{
    800011fe:	1101                	addi	sp,sp,-32
    80001200:	ec06                	sd	ra,24(sp)
    80001202:	e822                	sd	s0,16(sp)
    80001204:	e426                	sd	s1,8(sp)
    80001206:	e04a                	sd	s2,0(sp)
    80001208:	1000                	addi	s0,sp,32
    8000120a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000120c:	00000097          	auipc	ra,0x0
    80001210:	c62080e7          	jalr	-926(ra) # 80000e6e <myproc>
    80001214:	892a                	mv	s2,a0
  sz = p->sz;
    80001216:	652c                	ld	a1,72(a0)
    80001218:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000121c:	00904f63          	bgtz	s1,8000123a <growproc+0x3c>
  } else if(n < 0){
    80001220:	0204cc63          	bltz	s1,80001258 <growproc+0x5a>
  p->sz = sz;
    80001224:	1602                	slli	a2,a2,0x20
    80001226:	9201                	srli	a2,a2,0x20
    80001228:	04c93423          	sd	a2,72(s2)
  return 0;
    8000122c:	4501                	li	a0,0
}
    8000122e:	60e2                	ld	ra,24(sp)
    80001230:	6442                	ld	s0,16(sp)
    80001232:	64a2                	ld	s1,8(sp)
    80001234:	6902                	ld	s2,0(sp)
    80001236:	6105                	addi	sp,sp,32
    80001238:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000123a:	9e25                	addw	a2,a2,s1
    8000123c:	1602                	slli	a2,a2,0x20
    8000123e:	9201                	srli	a2,a2,0x20
    80001240:	1582                	slli	a1,a1,0x20
    80001242:	9181                	srli	a1,a1,0x20
    80001244:	6928                	ld	a0,80(a0)
    80001246:	fffff097          	auipc	ra,0xfffff
    8000124a:	69a080e7          	jalr	1690(ra) # 800008e0 <uvmalloc>
    8000124e:	0005061b          	sext.w	a2,a0
    80001252:	fa69                	bnez	a2,80001224 <growproc+0x26>
      return -1;
    80001254:	557d                	li	a0,-1
    80001256:	bfe1                	j	8000122e <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001258:	9e25                	addw	a2,a2,s1
    8000125a:	1602                	slli	a2,a2,0x20
    8000125c:	9201                	srli	a2,a2,0x20
    8000125e:	1582                	slli	a1,a1,0x20
    80001260:	9181                	srli	a1,a1,0x20
    80001262:	6928                	ld	a0,80(a0)
    80001264:	fffff097          	auipc	ra,0xfffff
    80001268:	634080e7          	jalr	1588(ra) # 80000898 <uvmdealloc>
    8000126c:	0005061b          	sext.w	a2,a0
    80001270:	bf55                	j	80001224 <growproc+0x26>

0000000080001272 <fork>:
{
    80001272:	7179                	addi	sp,sp,-48
    80001274:	f406                	sd	ra,40(sp)
    80001276:	f022                	sd	s0,32(sp)
    80001278:	ec26                	sd	s1,24(sp)
    8000127a:	e84a                	sd	s2,16(sp)
    8000127c:	e44e                	sd	s3,8(sp)
    8000127e:	e052                	sd	s4,0(sp)
    80001280:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001282:	00000097          	auipc	ra,0x0
    80001286:	bec080e7          	jalr	-1044(ra) # 80000e6e <myproc>
    8000128a:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000128c:	00000097          	auipc	ra,0x0
    80001290:	e22080e7          	jalr	-478(ra) # 800010ae <allocproc>
    80001294:	10050f63          	beqz	a0,800013b2 <fork+0x140>
    80001298:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000129a:	04893603          	ld	a2,72(s2)
    8000129e:	692c                	ld	a1,80(a0)
    800012a0:	05093503          	ld	a0,80(s2)
    800012a4:	fffff097          	auipc	ra,0xfffff
    800012a8:	788080e7          	jalr	1928(ra) # 80000a2c <uvmcopy>
    800012ac:	04054a63          	bltz	a0,80001300 <fork+0x8e>
  np->sz = p->sz;
    800012b0:	04893783          	ld	a5,72(s2)
    800012b4:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012b8:	05893683          	ld	a3,88(s2)
    800012bc:	87b6                	mv	a5,a3
    800012be:	0589b703          	ld	a4,88(s3)
    800012c2:	12068693          	addi	a3,a3,288
    800012c6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012ca:	6788                	ld	a0,8(a5)
    800012cc:	6b8c                	ld	a1,16(a5)
    800012ce:	6f90                	ld	a2,24(a5)
    800012d0:	01073023          	sd	a6,0(a4)
    800012d4:	e708                	sd	a0,8(a4)
    800012d6:	eb0c                	sd	a1,16(a4)
    800012d8:	ef10                	sd	a2,24(a4)
    800012da:	02078793          	addi	a5,a5,32
    800012de:	02070713          	addi	a4,a4,32
    800012e2:	fed792e3          	bne	a5,a3,800012c6 <fork+0x54>
  np->mask = p->mask;
    800012e6:	03492783          	lw	a5,52(s2)
    800012ea:	02f9aa23          	sw	a5,52(s3)
  np->trapframe->a0 = 0;
    800012ee:	0589b783          	ld	a5,88(s3)
    800012f2:	0607b823          	sd	zero,112(a5)
    800012f6:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800012fa:	15000a13          	li	s4,336
    800012fe:	a03d                	j	8000132c <fork+0xba>
    freeproc(np);
    80001300:	854e                	mv	a0,s3
    80001302:	00000097          	auipc	ra,0x0
    80001306:	d54080e7          	jalr	-684(ra) # 80001056 <freeproc>
    release(&np->lock);
    8000130a:	854e                	mv	a0,s3
    8000130c:	00005097          	auipc	ra,0x5
    80001310:	f7a080e7          	jalr	-134(ra) # 80006286 <release>
    return -1;
    80001314:	5a7d                	li	s4,-1
    80001316:	a069                	j	800013a0 <fork+0x12e>
      np->ofile[i] = filedup(p->ofile[i]);
    80001318:	00002097          	auipc	ra,0x2
    8000131c:	708080e7          	jalr	1800(ra) # 80003a20 <filedup>
    80001320:	009987b3          	add	a5,s3,s1
    80001324:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001326:	04a1                	addi	s1,s1,8
    80001328:	01448763          	beq	s1,s4,80001336 <fork+0xc4>
    if(p->ofile[i])
    8000132c:	009907b3          	add	a5,s2,s1
    80001330:	6388                	ld	a0,0(a5)
    80001332:	f17d                	bnez	a0,80001318 <fork+0xa6>
    80001334:	bfcd                	j	80001326 <fork+0xb4>
  np->cwd = idup(p->cwd);
    80001336:	15093503          	ld	a0,336(s2)
    8000133a:	00002097          	auipc	ra,0x2
    8000133e:	85c080e7          	jalr	-1956(ra) # 80002b96 <idup>
    80001342:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001346:	4641                	li	a2,16
    80001348:	15890593          	addi	a1,s2,344
    8000134c:	15898513          	addi	a0,s3,344
    80001350:	fffff097          	auipc	ra,0xfffff
    80001354:	fa0080e7          	jalr	-96(ra) # 800002f0 <safestrcpy>
  pid = np->pid;
    80001358:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    8000135c:	854e                	mv	a0,s3
    8000135e:	00005097          	auipc	ra,0x5
    80001362:	f28080e7          	jalr	-216(ra) # 80006286 <release>
  acquire(&wait_lock);
    80001366:	00008497          	auipc	s1,0x8
    8000136a:	d0248493          	addi	s1,s1,-766 # 80009068 <wait_lock>
    8000136e:	8526                	mv	a0,s1
    80001370:	00005097          	auipc	ra,0x5
    80001374:	e62080e7          	jalr	-414(ra) # 800061d2 <acquire>
  np->parent = p;
    80001378:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    8000137c:	8526                	mv	a0,s1
    8000137e:	00005097          	auipc	ra,0x5
    80001382:	f08080e7          	jalr	-248(ra) # 80006286 <release>
  acquire(&np->lock);
    80001386:	854e                	mv	a0,s3
    80001388:	00005097          	auipc	ra,0x5
    8000138c:	e4a080e7          	jalr	-438(ra) # 800061d2 <acquire>
  np->state = RUNNABLE;
    80001390:	478d                	li	a5,3
    80001392:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001396:	854e                	mv	a0,s3
    80001398:	00005097          	auipc	ra,0x5
    8000139c:	eee080e7          	jalr	-274(ra) # 80006286 <release>
}
    800013a0:	8552                	mv	a0,s4
    800013a2:	70a2                	ld	ra,40(sp)
    800013a4:	7402                	ld	s0,32(sp)
    800013a6:	64e2                	ld	s1,24(sp)
    800013a8:	6942                	ld	s2,16(sp)
    800013aa:	69a2                	ld	s3,8(sp)
    800013ac:	6a02                	ld	s4,0(sp)
    800013ae:	6145                	addi	sp,sp,48
    800013b0:	8082                	ret
    return -1;
    800013b2:	5a7d                	li	s4,-1
    800013b4:	b7f5                	j	800013a0 <fork+0x12e>

00000000800013b6 <scheduler>:
{
    800013b6:	7139                	addi	sp,sp,-64
    800013b8:	fc06                	sd	ra,56(sp)
    800013ba:	f822                	sd	s0,48(sp)
    800013bc:	f426                	sd	s1,40(sp)
    800013be:	f04a                	sd	s2,32(sp)
    800013c0:	ec4e                	sd	s3,24(sp)
    800013c2:	e852                	sd	s4,16(sp)
    800013c4:	e456                	sd	s5,8(sp)
    800013c6:	e05a                	sd	s6,0(sp)
    800013c8:	0080                	addi	s0,sp,64
    800013ca:	8792                	mv	a5,tp
  int id = r_tp();
    800013cc:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013ce:	00779a93          	slli	s5,a5,0x7
    800013d2:	00008717          	auipc	a4,0x8
    800013d6:	c7e70713          	addi	a4,a4,-898 # 80009050 <pid_lock>
    800013da:	9756                	add	a4,a4,s5
    800013dc:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013e0:	00008717          	auipc	a4,0x8
    800013e4:	ca870713          	addi	a4,a4,-856 # 80009088 <cpus+0x8>
    800013e8:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013ea:	498d                	li	s3,3
        p->state = RUNNING;
    800013ec:	4b11                	li	s6,4
        c->proc = p;
    800013ee:	079e                	slli	a5,a5,0x7
    800013f0:	00008a17          	auipc	s4,0x8
    800013f4:	c60a0a13          	addi	s4,s4,-928 # 80009050 <pid_lock>
    800013f8:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013fa:	0000e917          	auipc	s2,0xe
    800013fe:	a8690913          	addi	s2,s2,-1402 # 8000ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001402:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001406:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000140a:	10079073          	csrw	sstatus,a5
    8000140e:	00008497          	auipc	s1,0x8
    80001412:	07248493          	addi	s1,s1,114 # 80009480 <proc>
    80001416:	a03d                	j	80001444 <scheduler+0x8e>
        p->state = RUNNING;
    80001418:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000141c:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001420:	06048593          	addi	a1,s1,96
    80001424:	8556                	mv	a0,s5
    80001426:	00000097          	auipc	ra,0x0
    8000142a:	640080e7          	jalr	1600(ra) # 80001a66 <swtch>
        c->proc = 0;
    8000142e:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001432:	8526                	mv	a0,s1
    80001434:	00005097          	auipc	ra,0x5
    80001438:	e52080e7          	jalr	-430(ra) # 80006286 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000143c:	16848493          	addi	s1,s1,360
    80001440:	fd2481e3          	beq	s1,s2,80001402 <scheduler+0x4c>
      acquire(&p->lock);
    80001444:	8526                	mv	a0,s1
    80001446:	00005097          	auipc	ra,0x5
    8000144a:	d8c080e7          	jalr	-628(ra) # 800061d2 <acquire>
      if(p->state == RUNNABLE) {
    8000144e:	4c9c                	lw	a5,24(s1)
    80001450:	ff3791e3          	bne	a5,s3,80001432 <scheduler+0x7c>
    80001454:	b7d1                	j	80001418 <scheduler+0x62>

0000000080001456 <sched>:
{
    80001456:	7179                	addi	sp,sp,-48
    80001458:	f406                	sd	ra,40(sp)
    8000145a:	f022                	sd	s0,32(sp)
    8000145c:	ec26                	sd	s1,24(sp)
    8000145e:	e84a                	sd	s2,16(sp)
    80001460:	e44e                	sd	s3,8(sp)
    80001462:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001464:	00000097          	auipc	ra,0x0
    80001468:	a0a080e7          	jalr	-1526(ra) # 80000e6e <myproc>
    8000146c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000146e:	00005097          	auipc	ra,0x5
    80001472:	cea080e7          	jalr	-790(ra) # 80006158 <holding>
    80001476:	c93d                	beqz	a0,800014ec <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001478:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000147a:	2781                	sext.w	a5,a5
    8000147c:	079e                	slli	a5,a5,0x7
    8000147e:	00008717          	auipc	a4,0x8
    80001482:	bd270713          	addi	a4,a4,-1070 # 80009050 <pid_lock>
    80001486:	97ba                	add	a5,a5,a4
    80001488:	0a87a703          	lw	a4,168(a5)
    8000148c:	4785                	li	a5,1
    8000148e:	06f71763          	bne	a4,a5,800014fc <sched+0xa6>
  if(p->state == RUNNING)
    80001492:	4c98                	lw	a4,24(s1)
    80001494:	4791                	li	a5,4
    80001496:	06f70b63          	beq	a4,a5,8000150c <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000149a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000149e:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014a0:	efb5                	bnez	a5,8000151c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014a2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014a4:	00008917          	auipc	s2,0x8
    800014a8:	bac90913          	addi	s2,s2,-1108 # 80009050 <pid_lock>
    800014ac:	2781                	sext.w	a5,a5
    800014ae:	079e                	slli	a5,a5,0x7
    800014b0:	97ca                	add	a5,a5,s2
    800014b2:	0ac7a983          	lw	s3,172(a5)
    800014b6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014b8:	2781                	sext.w	a5,a5
    800014ba:	079e                	slli	a5,a5,0x7
    800014bc:	00008597          	auipc	a1,0x8
    800014c0:	bcc58593          	addi	a1,a1,-1076 # 80009088 <cpus+0x8>
    800014c4:	95be                	add	a1,a1,a5
    800014c6:	06048513          	addi	a0,s1,96
    800014ca:	00000097          	auipc	ra,0x0
    800014ce:	59c080e7          	jalr	1436(ra) # 80001a66 <swtch>
    800014d2:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014d4:	2781                	sext.w	a5,a5
    800014d6:	079e                	slli	a5,a5,0x7
    800014d8:	97ca                	add	a5,a5,s2
    800014da:	0b37a623          	sw	s3,172(a5)
}
    800014de:	70a2                	ld	ra,40(sp)
    800014e0:	7402                	ld	s0,32(sp)
    800014e2:	64e2                	ld	s1,24(sp)
    800014e4:	6942                	ld	s2,16(sp)
    800014e6:	69a2                	ld	s3,8(sp)
    800014e8:	6145                	addi	sp,sp,48
    800014ea:	8082                	ret
    panic("sched p->lock");
    800014ec:	00007517          	auipc	a0,0x7
    800014f0:	cac50513          	addi	a0,a0,-852 # 80008198 <etext+0x198>
    800014f4:	00004097          	auipc	ra,0x4
    800014f8:	794080e7          	jalr	1940(ra) # 80005c88 <panic>
    panic("sched locks");
    800014fc:	00007517          	auipc	a0,0x7
    80001500:	cac50513          	addi	a0,a0,-852 # 800081a8 <etext+0x1a8>
    80001504:	00004097          	auipc	ra,0x4
    80001508:	784080e7          	jalr	1924(ra) # 80005c88 <panic>
    panic("sched running");
    8000150c:	00007517          	auipc	a0,0x7
    80001510:	cac50513          	addi	a0,a0,-852 # 800081b8 <etext+0x1b8>
    80001514:	00004097          	auipc	ra,0x4
    80001518:	774080e7          	jalr	1908(ra) # 80005c88 <panic>
    panic("sched interruptible");
    8000151c:	00007517          	auipc	a0,0x7
    80001520:	cac50513          	addi	a0,a0,-852 # 800081c8 <etext+0x1c8>
    80001524:	00004097          	auipc	ra,0x4
    80001528:	764080e7          	jalr	1892(ra) # 80005c88 <panic>

000000008000152c <yield>:
{
    8000152c:	1101                	addi	sp,sp,-32
    8000152e:	ec06                	sd	ra,24(sp)
    80001530:	e822                	sd	s0,16(sp)
    80001532:	e426                	sd	s1,8(sp)
    80001534:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001536:	00000097          	auipc	ra,0x0
    8000153a:	938080e7          	jalr	-1736(ra) # 80000e6e <myproc>
    8000153e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001540:	00005097          	auipc	ra,0x5
    80001544:	c92080e7          	jalr	-878(ra) # 800061d2 <acquire>
  p->state = RUNNABLE;
    80001548:	478d                	li	a5,3
    8000154a:	cc9c                	sw	a5,24(s1)
  sched();
    8000154c:	00000097          	auipc	ra,0x0
    80001550:	f0a080e7          	jalr	-246(ra) # 80001456 <sched>
  release(&p->lock);
    80001554:	8526                	mv	a0,s1
    80001556:	00005097          	auipc	ra,0x5
    8000155a:	d30080e7          	jalr	-720(ra) # 80006286 <release>
}
    8000155e:	60e2                	ld	ra,24(sp)
    80001560:	6442                	ld	s0,16(sp)
    80001562:	64a2                	ld	s1,8(sp)
    80001564:	6105                	addi	sp,sp,32
    80001566:	8082                	ret

0000000080001568 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001568:	7179                	addi	sp,sp,-48
    8000156a:	f406                	sd	ra,40(sp)
    8000156c:	f022                	sd	s0,32(sp)
    8000156e:	ec26                	sd	s1,24(sp)
    80001570:	e84a                	sd	s2,16(sp)
    80001572:	e44e                	sd	s3,8(sp)
    80001574:	1800                	addi	s0,sp,48
    80001576:	89aa                	mv	s3,a0
    80001578:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000157a:	00000097          	auipc	ra,0x0
    8000157e:	8f4080e7          	jalr	-1804(ra) # 80000e6e <myproc>
    80001582:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001584:	00005097          	auipc	ra,0x5
    80001588:	c4e080e7          	jalr	-946(ra) # 800061d2 <acquire>
  release(lk);
    8000158c:	854a                	mv	a0,s2
    8000158e:	00005097          	auipc	ra,0x5
    80001592:	cf8080e7          	jalr	-776(ra) # 80006286 <release>

  // Go to sleep.
  p->chan = chan;
    80001596:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000159a:	4789                	li	a5,2
    8000159c:	cc9c                	sw	a5,24(s1)

  sched();
    8000159e:	00000097          	auipc	ra,0x0
    800015a2:	eb8080e7          	jalr	-328(ra) # 80001456 <sched>

  // Tidy up.
  p->chan = 0;
    800015a6:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015aa:	8526                	mv	a0,s1
    800015ac:	00005097          	auipc	ra,0x5
    800015b0:	cda080e7          	jalr	-806(ra) # 80006286 <release>
  acquire(lk);
    800015b4:	854a                	mv	a0,s2
    800015b6:	00005097          	auipc	ra,0x5
    800015ba:	c1c080e7          	jalr	-996(ra) # 800061d2 <acquire>
}
    800015be:	70a2                	ld	ra,40(sp)
    800015c0:	7402                	ld	s0,32(sp)
    800015c2:	64e2                	ld	s1,24(sp)
    800015c4:	6942                	ld	s2,16(sp)
    800015c6:	69a2                	ld	s3,8(sp)
    800015c8:	6145                	addi	sp,sp,48
    800015ca:	8082                	ret

00000000800015cc <wait>:
{
    800015cc:	715d                	addi	sp,sp,-80
    800015ce:	e486                	sd	ra,72(sp)
    800015d0:	e0a2                	sd	s0,64(sp)
    800015d2:	fc26                	sd	s1,56(sp)
    800015d4:	f84a                	sd	s2,48(sp)
    800015d6:	f44e                	sd	s3,40(sp)
    800015d8:	f052                	sd	s4,32(sp)
    800015da:	ec56                	sd	s5,24(sp)
    800015dc:	e85a                	sd	s6,16(sp)
    800015de:	e45e                	sd	s7,8(sp)
    800015e0:	e062                	sd	s8,0(sp)
    800015e2:	0880                	addi	s0,sp,80
    800015e4:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015e6:	00000097          	auipc	ra,0x0
    800015ea:	888080e7          	jalr	-1912(ra) # 80000e6e <myproc>
    800015ee:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015f0:	00008517          	auipc	a0,0x8
    800015f4:	a7850513          	addi	a0,a0,-1416 # 80009068 <wait_lock>
    800015f8:	00005097          	auipc	ra,0x5
    800015fc:	bda080e7          	jalr	-1062(ra) # 800061d2 <acquire>
    havekids = 0;
    80001600:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001602:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    80001604:	0000e997          	auipc	s3,0xe
    80001608:	87c98993          	addi	s3,s3,-1924 # 8000ee80 <tickslock>
        havekids = 1;
    8000160c:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000160e:	00008c17          	auipc	s8,0x8
    80001612:	a5ac0c13          	addi	s8,s8,-1446 # 80009068 <wait_lock>
    havekids = 0;
    80001616:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001618:	00008497          	auipc	s1,0x8
    8000161c:	e6848493          	addi	s1,s1,-408 # 80009480 <proc>
    80001620:	a0bd                	j	8000168e <wait+0xc2>
          pid = np->pid;
    80001622:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001626:	000b0e63          	beqz	s6,80001642 <wait+0x76>
    8000162a:	4691                	li	a3,4
    8000162c:	02c48613          	addi	a2,s1,44
    80001630:	85da                	mv	a1,s6
    80001632:	05093503          	ld	a0,80(s2)
    80001636:	fffff097          	auipc	ra,0xfffff
    8000163a:	4fa080e7          	jalr	1274(ra) # 80000b30 <copyout>
    8000163e:	02054563          	bltz	a0,80001668 <wait+0x9c>
          freeproc(np);
    80001642:	8526                	mv	a0,s1
    80001644:	00000097          	auipc	ra,0x0
    80001648:	a12080e7          	jalr	-1518(ra) # 80001056 <freeproc>
          release(&np->lock);
    8000164c:	8526                	mv	a0,s1
    8000164e:	00005097          	auipc	ra,0x5
    80001652:	c38080e7          	jalr	-968(ra) # 80006286 <release>
          release(&wait_lock);
    80001656:	00008517          	auipc	a0,0x8
    8000165a:	a1250513          	addi	a0,a0,-1518 # 80009068 <wait_lock>
    8000165e:	00005097          	auipc	ra,0x5
    80001662:	c28080e7          	jalr	-984(ra) # 80006286 <release>
          return pid;
    80001666:	a09d                	j	800016cc <wait+0x100>
            release(&np->lock);
    80001668:	8526                	mv	a0,s1
    8000166a:	00005097          	auipc	ra,0x5
    8000166e:	c1c080e7          	jalr	-996(ra) # 80006286 <release>
            release(&wait_lock);
    80001672:	00008517          	auipc	a0,0x8
    80001676:	9f650513          	addi	a0,a0,-1546 # 80009068 <wait_lock>
    8000167a:	00005097          	auipc	ra,0x5
    8000167e:	c0c080e7          	jalr	-1012(ra) # 80006286 <release>
            return -1;
    80001682:	59fd                	li	s3,-1
    80001684:	a0a1                	j	800016cc <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001686:	16848493          	addi	s1,s1,360
    8000168a:	03348463          	beq	s1,s3,800016b2 <wait+0xe6>
      if(np->parent == p){
    8000168e:	7c9c                	ld	a5,56(s1)
    80001690:	ff279be3          	bne	a5,s2,80001686 <wait+0xba>
        acquire(&np->lock);
    80001694:	8526                	mv	a0,s1
    80001696:	00005097          	auipc	ra,0x5
    8000169a:	b3c080e7          	jalr	-1220(ra) # 800061d2 <acquire>
        if(np->state == ZOMBIE){
    8000169e:	4c9c                	lw	a5,24(s1)
    800016a0:	f94781e3          	beq	a5,s4,80001622 <wait+0x56>
        release(&np->lock);
    800016a4:	8526                	mv	a0,s1
    800016a6:	00005097          	auipc	ra,0x5
    800016aa:	be0080e7          	jalr	-1056(ra) # 80006286 <release>
        havekids = 1;
    800016ae:	8756                	mv	a4,s5
    800016b0:	bfd9                	j	80001686 <wait+0xba>
    if(!havekids || p->killed){
    800016b2:	c701                	beqz	a4,800016ba <wait+0xee>
    800016b4:	02892783          	lw	a5,40(s2)
    800016b8:	c79d                	beqz	a5,800016e6 <wait+0x11a>
      release(&wait_lock);
    800016ba:	00008517          	auipc	a0,0x8
    800016be:	9ae50513          	addi	a0,a0,-1618 # 80009068 <wait_lock>
    800016c2:	00005097          	auipc	ra,0x5
    800016c6:	bc4080e7          	jalr	-1084(ra) # 80006286 <release>
      return -1;
    800016ca:	59fd                	li	s3,-1
}
    800016cc:	854e                	mv	a0,s3
    800016ce:	60a6                	ld	ra,72(sp)
    800016d0:	6406                	ld	s0,64(sp)
    800016d2:	74e2                	ld	s1,56(sp)
    800016d4:	7942                	ld	s2,48(sp)
    800016d6:	79a2                	ld	s3,40(sp)
    800016d8:	7a02                	ld	s4,32(sp)
    800016da:	6ae2                	ld	s5,24(sp)
    800016dc:	6b42                	ld	s6,16(sp)
    800016de:	6ba2                	ld	s7,8(sp)
    800016e0:	6c02                	ld	s8,0(sp)
    800016e2:	6161                	addi	sp,sp,80
    800016e4:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016e6:	85e2                	mv	a1,s8
    800016e8:	854a                	mv	a0,s2
    800016ea:	00000097          	auipc	ra,0x0
    800016ee:	e7e080e7          	jalr	-386(ra) # 80001568 <sleep>
    havekids = 0;
    800016f2:	b715                	j	80001616 <wait+0x4a>

00000000800016f4 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016f4:	7139                	addi	sp,sp,-64
    800016f6:	fc06                	sd	ra,56(sp)
    800016f8:	f822                	sd	s0,48(sp)
    800016fa:	f426                	sd	s1,40(sp)
    800016fc:	f04a                	sd	s2,32(sp)
    800016fe:	ec4e                	sd	s3,24(sp)
    80001700:	e852                	sd	s4,16(sp)
    80001702:	e456                	sd	s5,8(sp)
    80001704:	0080                	addi	s0,sp,64
    80001706:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001708:	00008497          	auipc	s1,0x8
    8000170c:	d7848493          	addi	s1,s1,-648 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001710:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001712:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001714:	0000d917          	auipc	s2,0xd
    80001718:	76c90913          	addi	s2,s2,1900 # 8000ee80 <tickslock>
    8000171c:	a821                	j	80001734 <wakeup+0x40>
        p->state = RUNNABLE;
    8000171e:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001722:	8526                	mv	a0,s1
    80001724:	00005097          	auipc	ra,0x5
    80001728:	b62080e7          	jalr	-1182(ra) # 80006286 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000172c:	16848493          	addi	s1,s1,360
    80001730:	03248463          	beq	s1,s2,80001758 <wakeup+0x64>
    if(p != myproc()){
    80001734:	fffff097          	auipc	ra,0xfffff
    80001738:	73a080e7          	jalr	1850(ra) # 80000e6e <myproc>
    8000173c:	fea488e3          	beq	s1,a0,8000172c <wakeup+0x38>
      acquire(&p->lock);
    80001740:	8526                	mv	a0,s1
    80001742:	00005097          	auipc	ra,0x5
    80001746:	a90080e7          	jalr	-1392(ra) # 800061d2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000174a:	4c9c                	lw	a5,24(s1)
    8000174c:	fd379be3          	bne	a5,s3,80001722 <wakeup+0x2e>
    80001750:	709c                	ld	a5,32(s1)
    80001752:	fd4798e3          	bne	a5,s4,80001722 <wakeup+0x2e>
    80001756:	b7e1                	j	8000171e <wakeup+0x2a>
    }
  }
}
    80001758:	70e2                	ld	ra,56(sp)
    8000175a:	7442                	ld	s0,48(sp)
    8000175c:	74a2                	ld	s1,40(sp)
    8000175e:	7902                	ld	s2,32(sp)
    80001760:	69e2                	ld	s3,24(sp)
    80001762:	6a42                	ld	s4,16(sp)
    80001764:	6aa2                	ld	s5,8(sp)
    80001766:	6121                	addi	sp,sp,64
    80001768:	8082                	ret

000000008000176a <reparent>:
{
    8000176a:	7179                	addi	sp,sp,-48
    8000176c:	f406                	sd	ra,40(sp)
    8000176e:	f022                	sd	s0,32(sp)
    80001770:	ec26                	sd	s1,24(sp)
    80001772:	e84a                	sd	s2,16(sp)
    80001774:	e44e                	sd	s3,8(sp)
    80001776:	e052                	sd	s4,0(sp)
    80001778:	1800                	addi	s0,sp,48
    8000177a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000177c:	00008497          	auipc	s1,0x8
    80001780:	d0448493          	addi	s1,s1,-764 # 80009480 <proc>
      pp->parent = initproc;
    80001784:	00008a17          	auipc	s4,0x8
    80001788:	88ca0a13          	addi	s4,s4,-1908 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000178c:	0000d997          	auipc	s3,0xd
    80001790:	6f498993          	addi	s3,s3,1780 # 8000ee80 <tickslock>
    80001794:	a029                	j	8000179e <reparent+0x34>
    80001796:	16848493          	addi	s1,s1,360
    8000179a:	01348d63          	beq	s1,s3,800017b4 <reparent+0x4a>
    if(pp->parent == p){
    8000179e:	7c9c                	ld	a5,56(s1)
    800017a0:	ff279be3          	bne	a5,s2,80001796 <reparent+0x2c>
      pp->parent = initproc;
    800017a4:	000a3503          	ld	a0,0(s4)
    800017a8:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017aa:	00000097          	auipc	ra,0x0
    800017ae:	f4a080e7          	jalr	-182(ra) # 800016f4 <wakeup>
    800017b2:	b7d5                	j	80001796 <reparent+0x2c>
}
    800017b4:	70a2                	ld	ra,40(sp)
    800017b6:	7402                	ld	s0,32(sp)
    800017b8:	64e2                	ld	s1,24(sp)
    800017ba:	6942                	ld	s2,16(sp)
    800017bc:	69a2                	ld	s3,8(sp)
    800017be:	6a02                	ld	s4,0(sp)
    800017c0:	6145                	addi	sp,sp,48
    800017c2:	8082                	ret

00000000800017c4 <exit>:
{
    800017c4:	7179                	addi	sp,sp,-48
    800017c6:	f406                	sd	ra,40(sp)
    800017c8:	f022                	sd	s0,32(sp)
    800017ca:	ec26                	sd	s1,24(sp)
    800017cc:	e84a                	sd	s2,16(sp)
    800017ce:	e44e                	sd	s3,8(sp)
    800017d0:	e052                	sd	s4,0(sp)
    800017d2:	1800                	addi	s0,sp,48
    800017d4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017d6:	fffff097          	auipc	ra,0xfffff
    800017da:	698080e7          	jalr	1688(ra) # 80000e6e <myproc>
    800017de:	89aa                	mv	s3,a0
  if(p == initproc)
    800017e0:	00008797          	auipc	a5,0x8
    800017e4:	8307b783          	ld	a5,-2000(a5) # 80009010 <initproc>
    800017e8:	0d050493          	addi	s1,a0,208
    800017ec:	15050913          	addi	s2,a0,336
    800017f0:	02a79363          	bne	a5,a0,80001816 <exit+0x52>
    panic("init exiting");
    800017f4:	00007517          	auipc	a0,0x7
    800017f8:	9ec50513          	addi	a0,a0,-1556 # 800081e0 <etext+0x1e0>
    800017fc:	00004097          	auipc	ra,0x4
    80001800:	48c080e7          	jalr	1164(ra) # 80005c88 <panic>
      fileclose(f);
    80001804:	00002097          	auipc	ra,0x2
    80001808:	26e080e7          	jalr	622(ra) # 80003a72 <fileclose>
      p->ofile[fd] = 0;
    8000180c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001810:	04a1                	addi	s1,s1,8
    80001812:	01248563          	beq	s1,s2,8000181c <exit+0x58>
    if(p->ofile[fd]){
    80001816:	6088                	ld	a0,0(s1)
    80001818:	f575                	bnez	a0,80001804 <exit+0x40>
    8000181a:	bfdd                	j	80001810 <exit+0x4c>
  begin_op();
    8000181c:	00002097          	auipc	ra,0x2
    80001820:	d8a080e7          	jalr	-630(ra) # 800035a6 <begin_op>
  iput(p->cwd);
    80001824:	1509b503          	ld	a0,336(s3)
    80001828:	00001097          	auipc	ra,0x1
    8000182c:	566080e7          	jalr	1382(ra) # 80002d8e <iput>
  end_op();
    80001830:	00002097          	auipc	ra,0x2
    80001834:	df6080e7          	jalr	-522(ra) # 80003626 <end_op>
  p->cwd = 0;
    80001838:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000183c:	00008497          	auipc	s1,0x8
    80001840:	82c48493          	addi	s1,s1,-2004 # 80009068 <wait_lock>
    80001844:	8526                	mv	a0,s1
    80001846:	00005097          	auipc	ra,0x5
    8000184a:	98c080e7          	jalr	-1652(ra) # 800061d2 <acquire>
  reparent(p);
    8000184e:	854e                	mv	a0,s3
    80001850:	00000097          	auipc	ra,0x0
    80001854:	f1a080e7          	jalr	-230(ra) # 8000176a <reparent>
  wakeup(p->parent);
    80001858:	0389b503          	ld	a0,56(s3)
    8000185c:	00000097          	auipc	ra,0x0
    80001860:	e98080e7          	jalr	-360(ra) # 800016f4 <wakeup>
  acquire(&p->lock);
    80001864:	854e                	mv	a0,s3
    80001866:	00005097          	auipc	ra,0x5
    8000186a:	96c080e7          	jalr	-1684(ra) # 800061d2 <acquire>
  p->xstate = status;
    8000186e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001872:	4795                	li	a5,5
    80001874:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001878:	8526                	mv	a0,s1
    8000187a:	00005097          	auipc	ra,0x5
    8000187e:	a0c080e7          	jalr	-1524(ra) # 80006286 <release>
  sched();
    80001882:	00000097          	auipc	ra,0x0
    80001886:	bd4080e7          	jalr	-1068(ra) # 80001456 <sched>
  panic("zombie exit");
    8000188a:	00007517          	auipc	a0,0x7
    8000188e:	96650513          	addi	a0,a0,-1690 # 800081f0 <etext+0x1f0>
    80001892:	00004097          	auipc	ra,0x4
    80001896:	3f6080e7          	jalr	1014(ra) # 80005c88 <panic>

000000008000189a <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000189a:	7179                	addi	sp,sp,-48
    8000189c:	f406                	sd	ra,40(sp)
    8000189e:	f022                	sd	s0,32(sp)
    800018a0:	ec26                	sd	s1,24(sp)
    800018a2:	e84a                	sd	s2,16(sp)
    800018a4:	e44e                	sd	s3,8(sp)
    800018a6:	1800                	addi	s0,sp,48
    800018a8:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018aa:	00008497          	auipc	s1,0x8
    800018ae:	bd648493          	addi	s1,s1,-1066 # 80009480 <proc>
    800018b2:	0000d997          	auipc	s3,0xd
    800018b6:	5ce98993          	addi	s3,s3,1486 # 8000ee80 <tickslock>
    acquire(&p->lock);
    800018ba:	8526                	mv	a0,s1
    800018bc:	00005097          	auipc	ra,0x5
    800018c0:	916080e7          	jalr	-1770(ra) # 800061d2 <acquire>
    if(p->pid == pid){
    800018c4:	589c                	lw	a5,48(s1)
    800018c6:	01278d63          	beq	a5,s2,800018e0 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018ca:	8526                	mv	a0,s1
    800018cc:	00005097          	auipc	ra,0x5
    800018d0:	9ba080e7          	jalr	-1606(ra) # 80006286 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018d4:	16848493          	addi	s1,s1,360
    800018d8:	ff3491e3          	bne	s1,s3,800018ba <kill+0x20>
  }
  return -1;
    800018dc:	557d                	li	a0,-1
    800018de:	a829                	j	800018f8 <kill+0x5e>
      p->killed = 1;
    800018e0:	4785                	li	a5,1
    800018e2:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018e4:	4c98                	lw	a4,24(s1)
    800018e6:	4789                	li	a5,2
    800018e8:	00f70f63          	beq	a4,a5,80001906 <kill+0x6c>
      release(&p->lock);
    800018ec:	8526                	mv	a0,s1
    800018ee:	00005097          	auipc	ra,0x5
    800018f2:	998080e7          	jalr	-1640(ra) # 80006286 <release>
      return 0;
    800018f6:	4501                	li	a0,0
}
    800018f8:	70a2                	ld	ra,40(sp)
    800018fa:	7402                	ld	s0,32(sp)
    800018fc:	64e2                	ld	s1,24(sp)
    800018fe:	6942                	ld	s2,16(sp)
    80001900:	69a2                	ld	s3,8(sp)
    80001902:	6145                	addi	sp,sp,48
    80001904:	8082                	ret
        p->state = RUNNABLE;
    80001906:	478d                	li	a5,3
    80001908:	cc9c                	sw	a5,24(s1)
    8000190a:	b7cd                	j	800018ec <kill+0x52>

000000008000190c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000190c:	7179                	addi	sp,sp,-48
    8000190e:	f406                	sd	ra,40(sp)
    80001910:	f022                	sd	s0,32(sp)
    80001912:	ec26                	sd	s1,24(sp)
    80001914:	e84a                	sd	s2,16(sp)
    80001916:	e44e                	sd	s3,8(sp)
    80001918:	e052                	sd	s4,0(sp)
    8000191a:	1800                	addi	s0,sp,48
    8000191c:	84aa                	mv	s1,a0
    8000191e:	892e                	mv	s2,a1
    80001920:	89b2                	mv	s3,a2
    80001922:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001924:	fffff097          	auipc	ra,0xfffff
    80001928:	54a080e7          	jalr	1354(ra) # 80000e6e <myproc>
  if(user_dst){
    8000192c:	c08d                	beqz	s1,8000194e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000192e:	86d2                	mv	a3,s4
    80001930:	864e                	mv	a2,s3
    80001932:	85ca                	mv	a1,s2
    80001934:	6928                	ld	a0,80(a0)
    80001936:	fffff097          	auipc	ra,0xfffff
    8000193a:	1fa080e7          	jalr	506(ra) # 80000b30 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000193e:	70a2                	ld	ra,40(sp)
    80001940:	7402                	ld	s0,32(sp)
    80001942:	64e2                	ld	s1,24(sp)
    80001944:	6942                	ld	s2,16(sp)
    80001946:	69a2                	ld	s3,8(sp)
    80001948:	6a02                	ld	s4,0(sp)
    8000194a:	6145                	addi	sp,sp,48
    8000194c:	8082                	ret
    memmove((char *)dst, src, len);
    8000194e:	000a061b          	sext.w	a2,s4
    80001952:	85ce                	mv	a1,s3
    80001954:	854a                	mv	a0,s2
    80001956:	fffff097          	auipc	ra,0xfffff
    8000195a:	8a8080e7          	jalr	-1880(ra) # 800001fe <memmove>
    return 0;
    8000195e:	8526                	mv	a0,s1
    80001960:	bff9                	j	8000193e <either_copyout+0x32>

0000000080001962 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001962:	7179                	addi	sp,sp,-48
    80001964:	f406                	sd	ra,40(sp)
    80001966:	f022                	sd	s0,32(sp)
    80001968:	ec26                	sd	s1,24(sp)
    8000196a:	e84a                	sd	s2,16(sp)
    8000196c:	e44e                	sd	s3,8(sp)
    8000196e:	e052                	sd	s4,0(sp)
    80001970:	1800                	addi	s0,sp,48
    80001972:	892a                	mv	s2,a0
    80001974:	84ae                	mv	s1,a1
    80001976:	89b2                	mv	s3,a2
    80001978:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000197a:	fffff097          	auipc	ra,0xfffff
    8000197e:	4f4080e7          	jalr	1268(ra) # 80000e6e <myproc>
  if(user_src){
    80001982:	c08d                	beqz	s1,800019a4 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001984:	86d2                	mv	a3,s4
    80001986:	864e                	mv	a2,s3
    80001988:	85ca                	mv	a1,s2
    8000198a:	6928                	ld	a0,80(a0)
    8000198c:	fffff097          	auipc	ra,0xfffff
    80001990:	230080e7          	jalr	560(ra) # 80000bbc <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001994:	70a2                	ld	ra,40(sp)
    80001996:	7402                	ld	s0,32(sp)
    80001998:	64e2                	ld	s1,24(sp)
    8000199a:	6942                	ld	s2,16(sp)
    8000199c:	69a2                	ld	s3,8(sp)
    8000199e:	6a02                	ld	s4,0(sp)
    800019a0:	6145                	addi	sp,sp,48
    800019a2:	8082                	ret
    memmove(dst, (char*)src, len);
    800019a4:	000a061b          	sext.w	a2,s4
    800019a8:	85ce                	mv	a1,s3
    800019aa:	854a                	mv	a0,s2
    800019ac:	fffff097          	auipc	ra,0xfffff
    800019b0:	852080e7          	jalr	-1966(ra) # 800001fe <memmove>
    return 0;
    800019b4:	8526                	mv	a0,s1
    800019b6:	bff9                	j	80001994 <either_copyin+0x32>

00000000800019b8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019b8:	715d                	addi	sp,sp,-80
    800019ba:	e486                	sd	ra,72(sp)
    800019bc:	e0a2                	sd	s0,64(sp)
    800019be:	fc26                	sd	s1,56(sp)
    800019c0:	f84a                	sd	s2,48(sp)
    800019c2:	f44e                	sd	s3,40(sp)
    800019c4:	f052                	sd	s4,32(sp)
    800019c6:	ec56                	sd	s5,24(sp)
    800019c8:	e85a                	sd	s6,16(sp)
    800019ca:	e45e                	sd	s7,8(sp)
    800019cc:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019ce:	00006517          	auipc	a0,0x6
    800019d2:	67a50513          	addi	a0,a0,1658 # 80008048 <etext+0x48>
    800019d6:	00004097          	auipc	ra,0x4
    800019da:	2fc080e7          	jalr	764(ra) # 80005cd2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019de:	00008497          	auipc	s1,0x8
    800019e2:	bfa48493          	addi	s1,s1,-1030 # 800095d8 <proc+0x158>
    800019e6:	0000d917          	auipc	s2,0xd
    800019ea:	5f290913          	addi	s2,s2,1522 # 8000efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019ee:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019f0:	00007997          	auipc	s3,0x7
    800019f4:	81098993          	addi	s3,s3,-2032 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019f8:	00007a97          	auipc	s5,0x7
    800019fc:	810a8a93          	addi	s5,s5,-2032 # 80008208 <etext+0x208>
    printf("\n");
    80001a00:	00006a17          	auipc	s4,0x6
    80001a04:	648a0a13          	addi	s4,s4,1608 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a08:	00007b97          	auipc	s7,0x7
    80001a0c:	838b8b93          	addi	s7,s7,-1992 # 80008240 <states.1721>
    80001a10:	a00d                	j	80001a32 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a12:	ed86a583          	lw	a1,-296(a3)
    80001a16:	8556                	mv	a0,s5
    80001a18:	00004097          	auipc	ra,0x4
    80001a1c:	2ba080e7          	jalr	698(ra) # 80005cd2 <printf>
    printf("\n");
    80001a20:	8552                	mv	a0,s4
    80001a22:	00004097          	auipc	ra,0x4
    80001a26:	2b0080e7          	jalr	688(ra) # 80005cd2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a2a:	16848493          	addi	s1,s1,360
    80001a2e:	03248163          	beq	s1,s2,80001a50 <procdump+0x98>
    if(p->state == UNUSED)
    80001a32:	86a6                	mv	a3,s1
    80001a34:	ec04a783          	lw	a5,-320(s1)
    80001a38:	dbed                	beqz	a5,80001a2a <procdump+0x72>
      state = "???";
    80001a3a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a3c:	fcfb6be3          	bltu	s6,a5,80001a12 <procdump+0x5a>
    80001a40:	1782                	slli	a5,a5,0x20
    80001a42:	9381                	srli	a5,a5,0x20
    80001a44:	078e                	slli	a5,a5,0x3
    80001a46:	97de                	add	a5,a5,s7
    80001a48:	6390                	ld	a2,0(a5)
    80001a4a:	f661                	bnez	a2,80001a12 <procdump+0x5a>
      state = "???";
    80001a4c:	864e                	mv	a2,s3
    80001a4e:	b7d1                	j	80001a12 <procdump+0x5a>
  }
}
    80001a50:	60a6                	ld	ra,72(sp)
    80001a52:	6406                	ld	s0,64(sp)
    80001a54:	74e2                	ld	s1,56(sp)
    80001a56:	7942                	ld	s2,48(sp)
    80001a58:	79a2                	ld	s3,40(sp)
    80001a5a:	7a02                	ld	s4,32(sp)
    80001a5c:	6ae2                	ld	s5,24(sp)
    80001a5e:	6b42                	ld	s6,16(sp)
    80001a60:	6ba2                	ld	s7,8(sp)
    80001a62:	6161                	addi	sp,sp,80
    80001a64:	8082                	ret

0000000080001a66 <swtch>:
    80001a66:	00153023          	sd	ra,0(a0)
    80001a6a:	00253423          	sd	sp,8(a0)
    80001a6e:	e900                	sd	s0,16(a0)
    80001a70:	ed04                	sd	s1,24(a0)
    80001a72:	03253023          	sd	s2,32(a0)
    80001a76:	03353423          	sd	s3,40(a0)
    80001a7a:	03453823          	sd	s4,48(a0)
    80001a7e:	03553c23          	sd	s5,56(a0)
    80001a82:	05653023          	sd	s6,64(a0)
    80001a86:	05753423          	sd	s7,72(a0)
    80001a8a:	05853823          	sd	s8,80(a0)
    80001a8e:	05953c23          	sd	s9,88(a0)
    80001a92:	07a53023          	sd	s10,96(a0)
    80001a96:	07b53423          	sd	s11,104(a0)
    80001a9a:	0005b083          	ld	ra,0(a1)
    80001a9e:	0085b103          	ld	sp,8(a1)
    80001aa2:	6980                	ld	s0,16(a1)
    80001aa4:	6d84                	ld	s1,24(a1)
    80001aa6:	0205b903          	ld	s2,32(a1)
    80001aaa:	0285b983          	ld	s3,40(a1)
    80001aae:	0305ba03          	ld	s4,48(a1)
    80001ab2:	0385ba83          	ld	s5,56(a1)
    80001ab6:	0405bb03          	ld	s6,64(a1)
    80001aba:	0485bb83          	ld	s7,72(a1)
    80001abe:	0505bc03          	ld	s8,80(a1)
    80001ac2:	0585bc83          	ld	s9,88(a1)
    80001ac6:	0605bd03          	ld	s10,96(a1)
    80001aca:	0685bd83          	ld	s11,104(a1)
    80001ace:	8082                	ret

0000000080001ad0 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ad0:	1141                	addi	sp,sp,-16
    80001ad2:	e406                	sd	ra,8(sp)
    80001ad4:	e022                	sd	s0,0(sp)
    80001ad6:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ad8:	00006597          	auipc	a1,0x6
    80001adc:	79858593          	addi	a1,a1,1944 # 80008270 <states.1721+0x30>
    80001ae0:	0000d517          	auipc	a0,0xd
    80001ae4:	3a050513          	addi	a0,a0,928 # 8000ee80 <tickslock>
    80001ae8:	00004097          	auipc	ra,0x4
    80001aec:	65a080e7          	jalr	1626(ra) # 80006142 <initlock>
}
    80001af0:	60a2                	ld	ra,8(sp)
    80001af2:	6402                	ld	s0,0(sp)
    80001af4:	0141                	addi	sp,sp,16
    80001af6:	8082                	ret

0000000080001af8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001af8:	1141                	addi	sp,sp,-16
    80001afa:	e422                	sd	s0,8(sp)
    80001afc:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001afe:	00003797          	auipc	a5,0x3
    80001b02:	59278793          	addi	a5,a5,1426 # 80005090 <kernelvec>
    80001b06:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b0a:	6422                	ld	s0,8(sp)
    80001b0c:	0141                	addi	sp,sp,16
    80001b0e:	8082                	ret

0000000080001b10 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b10:	1141                	addi	sp,sp,-16
    80001b12:	e406                	sd	ra,8(sp)
    80001b14:	e022                	sd	s0,0(sp)
    80001b16:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b18:	fffff097          	auipc	ra,0xfffff
    80001b1c:	356080e7          	jalr	854(ra) # 80000e6e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b20:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b24:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b26:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b2a:	00005617          	auipc	a2,0x5
    80001b2e:	4d660613          	addi	a2,a2,1238 # 80007000 <_trampoline>
    80001b32:	00005697          	auipc	a3,0x5
    80001b36:	4ce68693          	addi	a3,a3,1230 # 80007000 <_trampoline>
    80001b3a:	8e91                	sub	a3,a3,a2
    80001b3c:	040007b7          	lui	a5,0x4000
    80001b40:	17fd                	addi	a5,a5,-1
    80001b42:	07b2                	slli	a5,a5,0xc
    80001b44:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b46:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b4a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b4c:	180026f3          	csrr	a3,satp
    80001b50:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b52:	6d38                	ld	a4,88(a0)
    80001b54:	6134                	ld	a3,64(a0)
    80001b56:	6585                	lui	a1,0x1
    80001b58:	96ae                	add	a3,a3,a1
    80001b5a:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b5c:	6d38                	ld	a4,88(a0)
    80001b5e:	00000697          	auipc	a3,0x0
    80001b62:	13868693          	addi	a3,a3,312 # 80001c96 <usertrap>
    80001b66:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b68:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b6a:	8692                	mv	a3,tp
    80001b6c:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b6e:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b72:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b76:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b7a:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b7e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b80:	6f18                	ld	a4,24(a4)
    80001b82:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b86:	692c                	ld	a1,80(a0)
    80001b88:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b8a:	00005717          	auipc	a4,0x5
    80001b8e:	50670713          	addi	a4,a4,1286 # 80007090 <userret>
    80001b92:	8f11                	sub	a4,a4,a2
    80001b94:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b96:	577d                	li	a4,-1
    80001b98:	177e                	slli	a4,a4,0x3f
    80001b9a:	8dd9                	or	a1,a1,a4
    80001b9c:	02000537          	lui	a0,0x2000
    80001ba0:	157d                	addi	a0,a0,-1
    80001ba2:	0536                	slli	a0,a0,0xd
    80001ba4:	9782                	jalr	a5
}
    80001ba6:	60a2                	ld	ra,8(sp)
    80001ba8:	6402                	ld	s0,0(sp)
    80001baa:	0141                	addi	sp,sp,16
    80001bac:	8082                	ret

0000000080001bae <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bae:	1101                	addi	sp,sp,-32
    80001bb0:	ec06                	sd	ra,24(sp)
    80001bb2:	e822                	sd	s0,16(sp)
    80001bb4:	e426                	sd	s1,8(sp)
    80001bb6:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001bb8:	0000d497          	auipc	s1,0xd
    80001bbc:	2c848493          	addi	s1,s1,712 # 8000ee80 <tickslock>
    80001bc0:	8526                	mv	a0,s1
    80001bc2:	00004097          	auipc	ra,0x4
    80001bc6:	610080e7          	jalr	1552(ra) # 800061d2 <acquire>
  ticks++;
    80001bca:	00007517          	auipc	a0,0x7
    80001bce:	44e50513          	addi	a0,a0,1102 # 80009018 <ticks>
    80001bd2:	411c                	lw	a5,0(a0)
    80001bd4:	2785                	addiw	a5,a5,1
    80001bd6:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bd8:	00000097          	auipc	ra,0x0
    80001bdc:	b1c080e7          	jalr	-1252(ra) # 800016f4 <wakeup>
  release(&tickslock);
    80001be0:	8526                	mv	a0,s1
    80001be2:	00004097          	auipc	ra,0x4
    80001be6:	6a4080e7          	jalr	1700(ra) # 80006286 <release>
}
    80001bea:	60e2                	ld	ra,24(sp)
    80001bec:	6442                	ld	s0,16(sp)
    80001bee:	64a2                	ld	s1,8(sp)
    80001bf0:	6105                	addi	sp,sp,32
    80001bf2:	8082                	ret

0000000080001bf4 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001bf4:	1101                	addi	sp,sp,-32
    80001bf6:	ec06                	sd	ra,24(sp)
    80001bf8:	e822                	sd	s0,16(sp)
    80001bfa:	e426                	sd	s1,8(sp)
    80001bfc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bfe:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c02:	00074d63          	bltz	a4,80001c1c <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c06:	57fd                	li	a5,-1
    80001c08:	17fe                	slli	a5,a5,0x3f
    80001c0a:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c0c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c0e:	06f70363          	beq	a4,a5,80001c74 <devintr+0x80>
  }
}
    80001c12:	60e2                	ld	ra,24(sp)
    80001c14:	6442                	ld	s0,16(sp)
    80001c16:	64a2                	ld	s1,8(sp)
    80001c18:	6105                	addi	sp,sp,32
    80001c1a:	8082                	ret
     (scause & 0xff) == 9){
    80001c1c:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c20:	46a5                	li	a3,9
    80001c22:	fed792e3          	bne	a5,a3,80001c06 <devintr+0x12>
    int irq = plic_claim();
    80001c26:	00003097          	auipc	ra,0x3
    80001c2a:	572080e7          	jalr	1394(ra) # 80005198 <plic_claim>
    80001c2e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c30:	47a9                	li	a5,10
    80001c32:	02f50763          	beq	a0,a5,80001c60 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c36:	4785                	li	a5,1
    80001c38:	02f50963          	beq	a0,a5,80001c6a <devintr+0x76>
    return 1;
    80001c3c:	4505                	li	a0,1
    } else if(irq){
    80001c3e:	d8f1                	beqz	s1,80001c12 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c40:	85a6                	mv	a1,s1
    80001c42:	00006517          	auipc	a0,0x6
    80001c46:	63650513          	addi	a0,a0,1590 # 80008278 <states.1721+0x38>
    80001c4a:	00004097          	auipc	ra,0x4
    80001c4e:	088080e7          	jalr	136(ra) # 80005cd2 <printf>
      plic_complete(irq);
    80001c52:	8526                	mv	a0,s1
    80001c54:	00003097          	auipc	ra,0x3
    80001c58:	568080e7          	jalr	1384(ra) # 800051bc <plic_complete>
    return 1;
    80001c5c:	4505                	li	a0,1
    80001c5e:	bf55                	j	80001c12 <devintr+0x1e>
      uartintr();
    80001c60:	00004097          	auipc	ra,0x4
    80001c64:	492080e7          	jalr	1170(ra) # 800060f2 <uartintr>
    80001c68:	b7ed                	j	80001c52 <devintr+0x5e>
      virtio_disk_intr();
    80001c6a:	00004097          	auipc	ra,0x4
    80001c6e:	a32080e7          	jalr	-1486(ra) # 8000569c <virtio_disk_intr>
    80001c72:	b7c5                	j	80001c52 <devintr+0x5e>
    if(cpuid() == 0){
    80001c74:	fffff097          	auipc	ra,0xfffff
    80001c78:	1ce080e7          	jalr	462(ra) # 80000e42 <cpuid>
    80001c7c:	c901                	beqz	a0,80001c8c <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c7e:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c82:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c84:	14479073          	csrw	sip,a5
    return 2;
    80001c88:	4509                	li	a0,2
    80001c8a:	b761                	j	80001c12 <devintr+0x1e>
      clockintr();
    80001c8c:	00000097          	auipc	ra,0x0
    80001c90:	f22080e7          	jalr	-222(ra) # 80001bae <clockintr>
    80001c94:	b7ed                	j	80001c7e <devintr+0x8a>

0000000080001c96 <usertrap>:
{
    80001c96:	1101                	addi	sp,sp,-32
    80001c98:	ec06                	sd	ra,24(sp)
    80001c9a:	e822                	sd	s0,16(sp)
    80001c9c:	e426                	sd	s1,8(sp)
    80001c9e:	e04a                	sd	s2,0(sp)
    80001ca0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ca2:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ca6:	1007f793          	andi	a5,a5,256
    80001caa:	e3ad                	bnez	a5,80001d0c <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cac:	00003797          	auipc	a5,0x3
    80001cb0:	3e478793          	addi	a5,a5,996 # 80005090 <kernelvec>
    80001cb4:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cb8:	fffff097          	auipc	ra,0xfffff
    80001cbc:	1b6080e7          	jalr	438(ra) # 80000e6e <myproc>
    80001cc0:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cc2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cc4:	14102773          	csrr	a4,sepc
    80001cc8:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cca:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cce:	47a1                	li	a5,8
    80001cd0:	04f71c63          	bne	a4,a5,80001d28 <usertrap+0x92>
    if(p->killed)
    80001cd4:	551c                	lw	a5,40(a0)
    80001cd6:	e3b9                	bnez	a5,80001d1c <usertrap+0x86>
    p->trapframe->epc += 4;
    80001cd8:	6cb8                	ld	a4,88(s1)
    80001cda:	6f1c                	ld	a5,24(a4)
    80001cdc:	0791                	addi	a5,a5,4
    80001cde:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ce0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ce4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ce8:	10079073          	csrw	sstatus,a5
    syscall();
    80001cec:	00000097          	auipc	ra,0x0
    80001cf0:	2e0080e7          	jalr	736(ra) # 80001fcc <syscall>
  if(p->killed)
    80001cf4:	549c                	lw	a5,40(s1)
    80001cf6:	ebc1                	bnez	a5,80001d86 <usertrap+0xf0>
  usertrapret();
    80001cf8:	00000097          	auipc	ra,0x0
    80001cfc:	e18080e7          	jalr	-488(ra) # 80001b10 <usertrapret>
}
    80001d00:	60e2                	ld	ra,24(sp)
    80001d02:	6442                	ld	s0,16(sp)
    80001d04:	64a2                	ld	s1,8(sp)
    80001d06:	6902                	ld	s2,0(sp)
    80001d08:	6105                	addi	sp,sp,32
    80001d0a:	8082                	ret
    panic("usertrap: not from user mode");
    80001d0c:	00006517          	auipc	a0,0x6
    80001d10:	58c50513          	addi	a0,a0,1420 # 80008298 <states.1721+0x58>
    80001d14:	00004097          	auipc	ra,0x4
    80001d18:	f74080e7          	jalr	-140(ra) # 80005c88 <panic>
      exit(-1);
    80001d1c:	557d                	li	a0,-1
    80001d1e:	00000097          	auipc	ra,0x0
    80001d22:	aa6080e7          	jalr	-1370(ra) # 800017c4 <exit>
    80001d26:	bf4d                	j	80001cd8 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d28:	00000097          	auipc	ra,0x0
    80001d2c:	ecc080e7          	jalr	-308(ra) # 80001bf4 <devintr>
    80001d30:	892a                	mv	s2,a0
    80001d32:	c501                	beqz	a0,80001d3a <usertrap+0xa4>
  if(p->killed)
    80001d34:	549c                	lw	a5,40(s1)
    80001d36:	c3a1                	beqz	a5,80001d76 <usertrap+0xe0>
    80001d38:	a815                	j	80001d6c <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d3a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d3e:	5890                	lw	a2,48(s1)
    80001d40:	00006517          	auipc	a0,0x6
    80001d44:	57850513          	addi	a0,a0,1400 # 800082b8 <states.1721+0x78>
    80001d48:	00004097          	auipc	ra,0x4
    80001d4c:	f8a080e7          	jalr	-118(ra) # 80005cd2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d50:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d54:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d58:	00006517          	auipc	a0,0x6
    80001d5c:	59050513          	addi	a0,a0,1424 # 800082e8 <states.1721+0xa8>
    80001d60:	00004097          	auipc	ra,0x4
    80001d64:	f72080e7          	jalr	-142(ra) # 80005cd2 <printf>
    p->killed = 1;
    80001d68:	4785                	li	a5,1
    80001d6a:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d6c:	557d                	li	a0,-1
    80001d6e:	00000097          	auipc	ra,0x0
    80001d72:	a56080e7          	jalr	-1450(ra) # 800017c4 <exit>
  if(which_dev == 2)
    80001d76:	4789                	li	a5,2
    80001d78:	f8f910e3          	bne	s2,a5,80001cf8 <usertrap+0x62>
    yield();
    80001d7c:	fffff097          	auipc	ra,0xfffff
    80001d80:	7b0080e7          	jalr	1968(ra) # 8000152c <yield>
    80001d84:	bf95                	j	80001cf8 <usertrap+0x62>
  int which_dev = 0;
    80001d86:	4901                	li	s2,0
    80001d88:	b7d5                	j	80001d6c <usertrap+0xd6>

0000000080001d8a <kerneltrap>:
{
    80001d8a:	7179                	addi	sp,sp,-48
    80001d8c:	f406                	sd	ra,40(sp)
    80001d8e:	f022                	sd	s0,32(sp)
    80001d90:	ec26                	sd	s1,24(sp)
    80001d92:	e84a                	sd	s2,16(sp)
    80001d94:	e44e                	sd	s3,8(sp)
    80001d96:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d98:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d9c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001da0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001da4:	1004f793          	andi	a5,s1,256
    80001da8:	cb85                	beqz	a5,80001dd8 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001daa:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dae:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001db0:	ef85                	bnez	a5,80001de8 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001db2:	00000097          	auipc	ra,0x0
    80001db6:	e42080e7          	jalr	-446(ra) # 80001bf4 <devintr>
    80001dba:	cd1d                	beqz	a0,80001df8 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dbc:	4789                	li	a5,2
    80001dbe:	06f50a63          	beq	a0,a5,80001e32 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dc2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dc6:	10049073          	csrw	sstatus,s1
}
    80001dca:	70a2                	ld	ra,40(sp)
    80001dcc:	7402                	ld	s0,32(sp)
    80001dce:	64e2                	ld	s1,24(sp)
    80001dd0:	6942                	ld	s2,16(sp)
    80001dd2:	69a2                	ld	s3,8(sp)
    80001dd4:	6145                	addi	sp,sp,48
    80001dd6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001dd8:	00006517          	auipc	a0,0x6
    80001ddc:	53050513          	addi	a0,a0,1328 # 80008308 <states.1721+0xc8>
    80001de0:	00004097          	auipc	ra,0x4
    80001de4:	ea8080e7          	jalr	-344(ra) # 80005c88 <panic>
    panic("kerneltrap: interrupts enabled");
    80001de8:	00006517          	auipc	a0,0x6
    80001dec:	54850513          	addi	a0,a0,1352 # 80008330 <states.1721+0xf0>
    80001df0:	00004097          	auipc	ra,0x4
    80001df4:	e98080e7          	jalr	-360(ra) # 80005c88 <panic>
    printf("scause %p\n", scause);
    80001df8:	85ce                	mv	a1,s3
    80001dfa:	00006517          	auipc	a0,0x6
    80001dfe:	55650513          	addi	a0,a0,1366 # 80008350 <states.1721+0x110>
    80001e02:	00004097          	auipc	ra,0x4
    80001e06:	ed0080e7          	jalr	-304(ra) # 80005cd2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e0a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e0e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e12:	00006517          	auipc	a0,0x6
    80001e16:	54e50513          	addi	a0,a0,1358 # 80008360 <states.1721+0x120>
    80001e1a:	00004097          	auipc	ra,0x4
    80001e1e:	eb8080e7          	jalr	-328(ra) # 80005cd2 <printf>
    panic("kerneltrap");
    80001e22:	00006517          	auipc	a0,0x6
    80001e26:	55650513          	addi	a0,a0,1366 # 80008378 <states.1721+0x138>
    80001e2a:	00004097          	auipc	ra,0x4
    80001e2e:	e5e080e7          	jalr	-418(ra) # 80005c88 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e32:	fffff097          	auipc	ra,0xfffff
    80001e36:	03c080e7          	jalr	60(ra) # 80000e6e <myproc>
    80001e3a:	d541                	beqz	a0,80001dc2 <kerneltrap+0x38>
    80001e3c:	fffff097          	auipc	ra,0xfffff
    80001e40:	032080e7          	jalr	50(ra) # 80000e6e <myproc>
    80001e44:	4d18                	lw	a4,24(a0)
    80001e46:	4791                	li	a5,4
    80001e48:	f6f71de3          	bne	a4,a5,80001dc2 <kerneltrap+0x38>
    yield();
    80001e4c:	fffff097          	auipc	ra,0xfffff
    80001e50:	6e0080e7          	jalr	1760(ra) # 8000152c <yield>
    80001e54:	b7bd                	j	80001dc2 <kerneltrap+0x38>

0000000080001e56 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e56:	1101                	addi	sp,sp,-32
    80001e58:	ec06                	sd	ra,24(sp)
    80001e5a:	e822                	sd	s0,16(sp)
    80001e5c:	e426                	sd	s1,8(sp)
    80001e5e:	1000                	addi	s0,sp,32
    80001e60:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e62:	fffff097          	auipc	ra,0xfffff
    80001e66:	00c080e7          	jalr	12(ra) # 80000e6e <myproc>
  switch (n) {
    80001e6a:	4795                	li	a5,5
    80001e6c:	0497e163          	bltu	a5,s1,80001eae <argraw+0x58>
    80001e70:	048a                	slli	s1,s1,0x2
    80001e72:	00006717          	auipc	a4,0x6
    80001e76:	60e70713          	addi	a4,a4,1550 # 80008480 <states.1721+0x240>
    80001e7a:	94ba                	add	s1,s1,a4
    80001e7c:	409c                	lw	a5,0(s1)
    80001e7e:	97ba                	add	a5,a5,a4
    80001e80:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e82:	6d3c                	ld	a5,88(a0)
    80001e84:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e86:	60e2                	ld	ra,24(sp)
    80001e88:	6442                	ld	s0,16(sp)
    80001e8a:	64a2                	ld	s1,8(sp)
    80001e8c:	6105                	addi	sp,sp,32
    80001e8e:	8082                	ret
    return p->trapframe->a1;
    80001e90:	6d3c                	ld	a5,88(a0)
    80001e92:	7fa8                	ld	a0,120(a5)
    80001e94:	bfcd                	j	80001e86 <argraw+0x30>
    return p->trapframe->a2;
    80001e96:	6d3c                	ld	a5,88(a0)
    80001e98:	63c8                	ld	a0,128(a5)
    80001e9a:	b7f5                	j	80001e86 <argraw+0x30>
    return p->trapframe->a3;
    80001e9c:	6d3c                	ld	a5,88(a0)
    80001e9e:	67c8                	ld	a0,136(a5)
    80001ea0:	b7dd                	j	80001e86 <argraw+0x30>
    return p->trapframe->a4;
    80001ea2:	6d3c                	ld	a5,88(a0)
    80001ea4:	6bc8                	ld	a0,144(a5)
    80001ea6:	b7c5                	j	80001e86 <argraw+0x30>
    return p->trapframe->a5;
    80001ea8:	6d3c                	ld	a5,88(a0)
    80001eaa:	6fc8                	ld	a0,152(a5)
    80001eac:	bfe9                	j	80001e86 <argraw+0x30>
  panic("argraw");
    80001eae:	00006517          	auipc	a0,0x6
    80001eb2:	59250513          	addi	a0,a0,1426 # 80008440 <states.1721+0x200>
    80001eb6:	00004097          	auipc	ra,0x4
    80001eba:	dd2080e7          	jalr	-558(ra) # 80005c88 <panic>

0000000080001ebe <fetchaddr>:
{
    80001ebe:	1101                	addi	sp,sp,-32
    80001ec0:	ec06                	sd	ra,24(sp)
    80001ec2:	e822                	sd	s0,16(sp)
    80001ec4:	e426                	sd	s1,8(sp)
    80001ec6:	e04a                	sd	s2,0(sp)
    80001ec8:	1000                	addi	s0,sp,32
    80001eca:	84aa                	mv	s1,a0
    80001ecc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ece:	fffff097          	auipc	ra,0xfffff
    80001ed2:	fa0080e7          	jalr	-96(ra) # 80000e6e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001ed6:	653c                	ld	a5,72(a0)
    80001ed8:	02f4f863          	bgeu	s1,a5,80001f08 <fetchaddr+0x4a>
    80001edc:	00848713          	addi	a4,s1,8
    80001ee0:	02e7e663          	bltu	a5,a4,80001f0c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ee4:	46a1                	li	a3,8
    80001ee6:	8626                	mv	a2,s1
    80001ee8:	85ca                	mv	a1,s2
    80001eea:	6928                	ld	a0,80(a0)
    80001eec:	fffff097          	auipc	ra,0xfffff
    80001ef0:	cd0080e7          	jalr	-816(ra) # 80000bbc <copyin>
    80001ef4:	00a03533          	snez	a0,a0
    80001ef8:	40a00533          	neg	a0,a0
}
    80001efc:	60e2                	ld	ra,24(sp)
    80001efe:	6442                	ld	s0,16(sp)
    80001f00:	64a2                	ld	s1,8(sp)
    80001f02:	6902                	ld	s2,0(sp)
    80001f04:	6105                	addi	sp,sp,32
    80001f06:	8082                	ret
    return -1;
    80001f08:	557d                	li	a0,-1
    80001f0a:	bfcd                	j	80001efc <fetchaddr+0x3e>
    80001f0c:	557d                	li	a0,-1
    80001f0e:	b7fd                	j	80001efc <fetchaddr+0x3e>

0000000080001f10 <fetchstr>:
{
    80001f10:	7179                	addi	sp,sp,-48
    80001f12:	f406                	sd	ra,40(sp)
    80001f14:	f022                	sd	s0,32(sp)
    80001f16:	ec26                	sd	s1,24(sp)
    80001f18:	e84a                	sd	s2,16(sp)
    80001f1a:	e44e                	sd	s3,8(sp)
    80001f1c:	1800                	addi	s0,sp,48
    80001f1e:	892a                	mv	s2,a0
    80001f20:	84ae                	mv	s1,a1
    80001f22:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f24:	fffff097          	auipc	ra,0xfffff
    80001f28:	f4a080e7          	jalr	-182(ra) # 80000e6e <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f2c:	86ce                	mv	a3,s3
    80001f2e:	864a                	mv	a2,s2
    80001f30:	85a6                	mv	a1,s1
    80001f32:	6928                	ld	a0,80(a0)
    80001f34:	fffff097          	auipc	ra,0xfffff
    80001f38:	d14080e7          	jalr	-748(ra) # 80000c48 <copyinstr>
  if(err < 0)
    80001f3c:	00054763          	bltz	a0,80001f4a <fetchstr+0x3a>
  return strlen(buf);
    80001f40:	8526                	mv	a0,s1
    80001f42:	ffffe097          	auipc	ra,0xffffe
    80001f46:	3e0080e7          	jalr	992(ra) # 80000322 <strlen>
}
    80001f4a:	70a2                	ld	ra,40(sp)
    80001f4c:	7402                	ld	s0,32(sp)
    80001f4e:	64e2                	ld	s1,24(sp)
    80001f50:	6942                	ld	s2,16(sp)
    80001f52:	69a2                	ld	s3,8(sp)
    80001f54:	6145                	addi	sp,sp,48
    80001f56:	8082                	ret

0000000080001f58 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f58:	1101                	addi	sp,sp,-32
    80001f5a:	ec06                	sd	ra,24(sp)
    80001f5c:	e822                	sd	s0,16(sp)
    80001f5e:	e426                	sd	s1,8(sp)
    80001f60:	1000                	addi	s0,sp,32
    80001f62:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f64:	00000097          	auipc	ra,0x0
    80001f68:	ef2080e7          	jalr	-270(ra) # 80001e56 <argraw>
    80001f6c:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f6e:	4501                	li	a0,0
    80001f70:	60e2                	ld	ra,24(sp)
    80001f72:	6442                	ld	s0,16(sp)
    80001f74:	64a2                	ld	s1,8(sp)
    80001f76:	6105                	addi	sp,sp,32
    80001f78:	8082                	ret

0000000080001f7a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f7a:	1101                	addi	sp,sp,-32
    80001f7c:	ec06                	sd	ra,24(sp)
    80001f7e:	e822                	sd	s0,16(sp)
    80001f80:	e426                	sd	s1,8(sp)
    80001f82:	1000                	addi	s0,sp,32
    80001f84:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f86:	00000097          	auipc	ra,0x0
    80001f8a:	ed0080e7          	jalr	-304(ra) # 80001e56 <argraw>
    80001f8e:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f90:	4501                	li	a0,0
    80001f92:	60e2                	ld	ra,24(sp)
    80001f94:	6442                	ld	s0,16(sp)
    80001f96:	64a2                	ld	s1,8(sp)
    80001f98:	6105                	addi	sp,sp,32
    80001f9a:	8082                	ret

0000000080001f9c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f9c:	1101                	addi	sp,sp,-32
    80001f9e:	ec06                	sd	ra,24(sp)
    80001fa0:	e822                	sd	s0,16(sp)
    80001fa2:	e426                	sd	s1,8(sp)
    80001fa4:	e04a                	sd	s2,0(sp)
    80001fa6:	1000                	addi	s0,sp,32
    80001fa8:	84ae                	mv	s1,a1
    80001faa:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fac:	00000097          	auipc	ra,0x0
    80001fb0:	eaa080e7          	jalr	-342(ra) # 80001e56 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fb4:	864a                	mv	a2,s2
    80001fb6:	85a6                	mv	a1,s1
    80001fb8:	00000097          	auipc	ra,0x0
    80001fbc:	f58080e7          	jalr	-168(ra) # 80001f10 <fetchstr>
}
    80001fc0:	60e2                	ld	ra,24(sp)
    80001fc2:	6442                	ld	s0,16(sp)
    80001fc4:	64a2                	ld	s1,8(sp)
    80001fc6:	6902                	ld	s2,0(sp)
    80001fc8:	6105                	addi	sp,sp,32
    80001fca:	8082                	ret

0000000080001fcc <syscall>:
[SYS_sysinfo] sys_sysinfo,
};

void
syscall(void)
{
    80001fcc:	7151                	addi	sp,sp,-240
    80001fce:	f586                	sd	ra,232(sp)
    80001fd0:	f1a2                	sd	s0,224(sp)
    80001fd2:	eda6                	sd	s1,216(sp)
    80001fd4:	e9ca                	sd	s2,208(sp)
    80001fd6:	e5ce                	sd	s3,200(sp)
    80001fd8:	1980                	addi	s0,sp,240
  char *sys_call_name[] = {"fork", "exit", "wait", "pipe", "read", "kill", "exec", "fstat", "chdir", "dup", "getpid", "sbrk", "sleep", "uptime", "open", "write", "mknod", "unlink", "link", "mkdir", "close", "trace", "sys_sysinfo"};
    80001fda:	00006797          	auipc	a5,0x6
    80001fde:	4be78793          	addi	a5,a5,1214 # 80008498 <states.1721+0x258>
    80001fe2:	f1840713          	addi	a4,s0,-232
    80001fe6:	00006697          	auipc	a3,0x6
    80001fea:	55268693          	addi	a3,a3,1362 # 80008538 <states.1721+0x2f8>
    80001fee:	0007b803          	ld	a6,0(a5)
    80001ff2:	6788                	ld	a0,8(a5)
    80001ff4:	6b8c                	ld	a1,16(a5)
    80001ff6:	6f90                	ld	a2,24(a5)
    80001ff8:	01073023          	sd	a6,0(a4)
    80001ffc:	e708                	sd	a0,8(a4)
    80001ffe:	eb0c                	sd	a1,16(a4)
    80002000:	ef10                	sd	a2,24(a4)
    80002002:	02078793          	addi	a5,a5,32
    80002006:	02070713          	addi	a4,a4,32
    8000200a:	fed792e3          	bne	a5,a3,80001fee <syscall+0x22>
    8000200e:	6390                	ld	a2,0(a5)
    80002010:	6794                	ld	a3,8(a5)
    80002012:	6b9c                	ld	a5,16(a5)
    80002014:	e310                	sd	a2,0(a4)
    80002016:	e714                	sd	a3,8(a4)
    80002018:	eb1c                	sd	a5,16(a4)
  
  int num;
  struct proc *p = myproc();
    8000201a:	fffff097          	auipc	ra,0xfffff
    8000201e:	e54080e7          	jalr	-428(ra) # 80000e6e <myproc>
    80002022:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002024:	05853903          	ld	s2,88(a0)
    80002028:	0a893783          	ld	a5,168(s2)
    8000202c:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002030:	37fd                	addiw	a5,a5,-1
    80002032:	4759                	li	a4,22
    80002034:	04f76663          	bltu	a4,a5,80002080 <syscall+0xb4>
    80002038:	00399713          	slli	a4,s3,0x3
    8000203c:	00006797          	auipc	a5,0x6
    80002040:	45c78793          	addi	a5,a5,1116 # 80008498 <states.1721+0x258>
    80002044:	97ba                	add	a5,a5,a4
    80002046:	7fdc                	ld	a5,184(a5)
    80002048:	cf85                	beqz	a5,80002080 <syscall+0xb4>
    p->trapframe->a0 = syscalls[num]();
    8000204a:	9782                	jalr	a5
    8000204c:	06a93823          	sd	a0,112(s2)
	if(p->mask & (1 << num))
    80002050:	58dc                	lw	a5,52(s1)
    80002052:	4137d7bb          	sraw	a5,a5,s3
    80002056:	8b85                	andi	a5,a5,1
    80002058:	c3b9                	beqz	a5,8000209e <syscall+0xd2>
		printf("%d: syscall %s -> %d\n", p->pid, sys_call_name[num - 1], p->trapframe->a0);
    8000205a:	6cbc                	ld	a5,88(s1)
    8000205c:	39fd                	addiw	s3,s3,-1
    8000205e:	098e                	slli	s3,s3,0x3
    80002060:	fd040713          	addi	a4,s0,-48
    80002064:	99ba                	add	s3,s3,a4
    80002066:	7bb4                	ld	a3,112(a5)
    80002068:	f489b603          	ld	a2,-184(s3)
    8000206c:	588c                	lw	a1,48(s1)
    8000206e:	00006517          	auipc	a0,0x6
    80002072:	3da50513          	addi	a0,a0,986 # 80008448 <states.1721+0x208>
    80002076:	00004097          	auipc	ra,0x4
    8000207a:	c5c080e7          	jalr	-932(ra) # 80005cd2 <printf>
    8000207e:	a005                	j	8000209e <syscall+0xd2>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002080:	86ce                	mv	a3,s3
    80002082:	15848613          	addi	a2,s1,344
    80002086:	588c                	lw	a1,48(s1)
    80002088:	00006517          	auipc	a0,0x6
    8000208c:	3d850513          	addi	a0,a0,984 # 80008460 <states.1721+0x220>
    80002090:	00004097          	auipc	ra,0x4
    80002094:	c42080e7          	jalr	-958(ra) # 80005cd2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002098:	6cbc                	ld	a5,88(s1)
    8000209a:	577d                	li	a4,-1
    8000209c:	fbb8                	sd	a4,112(a5)
  }
}
    8000209e:	70ae                	ld	ra,232(sp)
    800020a0:	740e                	ld	s0,224(sp)
    800020a2:	64ee                	ld	s1,216(sp)
    800020a4:	694e                	ld	s2,208(sp)
    800020a6:	69ae                	ld	s3,200(sp)
    800020a8:	616d                	addi	sp,sp,240
    800020aa:	8082                	ret

00000000800020ac <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    800020ac:	1101                	addi	sp,sp,-32
    800020ae:	ec06                	sd	ra,24(sp)
    800020b0:	e822                	sd	s0,16(sp)
    800020b2:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020b4:	fec40593          	addi	a1,s0,-20
    800020b8:	4501                	li	a0,0
    800020ba:	00000097          	auipc	ra,0x0
    800020be:	e9e080e7          	jalr	-354(ra) # 80001f58 <argint>
    return -1;
    800020c2:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020c4:	00054963          	bltz	a0,800020d6 <sys_exit+0x2a>
  exit(n);
    800020c8:	fec42503          	lw	a0,-20(s0)
    800020cc:	fffff097          	auipc	ra,0xfffff
    800020d0:	6f8080e7          	jalr	1784(ra) # 800017c4 <exit>
  return 0;  // not reached
    800020d4:	4781                	li	a5,0
}
    800020d6:	853e                	mv	a0,a5
    800020d8:	60e2                	ld	ra,24(sp)
    800020da:	6442                	ld	s0,16(sp)
    800020dc:	6105                	addi	sp,sp,32
    800020de:	8082                	ret

00000000800020e0 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020e0:	1141                	addi	sp,sp,-16
    800020e2:	e406                	sd	ra,8(sp)
    800020e4:	e022                	sd	s0,0(sp)
    800020e6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020e8:	fffff097          	auipc	ra,0xfffff
    800020ec:	d86080e7          	jalr	-634(ra) # 80000e6e <myproc>
}
    800020f0:	5908                	lw	a0,48(a0)
    800020f2:	60a2                	ld	ra,8(sp)
    800020f4:	6402                	ld	s0,0(sp)
    800020f6:	0141                	addi	sp,sp,16
    800020f8:	8082                	ret

00000000800020fa <sys_fork>:

uint64
sys_fork(void)
{
    800020fa:	1141                	addi	sp,sp,-16
    800020fc:	e406                	sd	ra,8(sp)
    800020fe:	e022                	sd	s0,0(sp)
    80002100:	0800                	addi	s0,sp,16
  return fork();
    80002102:	fffff097          	auipc	ra,0xfffff
    80002106:	170080e7          	jalr	368(ra) # 80001272 <fork>
}
    8000210a:	60a2                	ld	ra,8(sp)
    8000210c:	6402                	ld	s0,0(sp)
    8000210e:	0141                	addi	sp,sp,16
    80002110:	8082                	ret

0000000080002112 <sys_wait>:

uint64
sys_wait(void)
{
    80002112:	1101                	addi	sp,sp,-32
    80002114:	ec06                	sd	ra,24(sp)
    80002116:	e822                	sd	s0,16(sp)
    80002118:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000211a:	fe840593          	addi	a1,s0,-24
    8000211e:	4501                	li	a0,0
    80002120:	00000097          	auipc	ra,0x0
    80002124:	e5a080e7          	jalr	-422(ra) # 80001f7a <argaddr>
    80002128:	87aa                	mv	a5,a0
    return -1;
    8000212a:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000212c:	0007c863          	bltz	a5,8000213c <sys_wait+0x2a>
  return wait(p);
    80002130:	fe843503          	ld	a0,-24(s0)
    80002134:	fffff097          	auipc	ra,0xfffff
    80002138:	498080e7          	jalr	1176(ra) # 800015cc <wait>
}
    8000213c:	60e2                	ld	ra,24(sp)
    8000213e:	6442                	ld	s0,16(sp)
    80002140:	6105                	addi	sp,sp,32
    80002142:	8082                	ret

0000000080002144 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002144:	7179                	addi	sp,sp,-48
    80002146:	f406                	sd	ra,40(sp)
    80002148:	f022                	sd	s0,32(sp)
    8000214a:	ec26                	sd	s1,24(sp)
    8000214c:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000214e:	fdc40593          	addi	a1,s0,-36
    80002152:	4501                	li	a0,0
    80002154:	00000097          	auipc	ra,0x0
    80002158:	e04080e7          	jalr	-508(ra) # 80001f58 <argint>
    8000215c:	87aa                	mv	a5,a0
    return -1;
    8000215e:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002160:	0207c063          	bltz	a5,80002180 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002164:	fffff097          	auipc	ra,0xfffff
    80002168:	d0a080e7          	jalr	-758(ra) # 80000e6e <myproc>
    8000216c:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000216e:	fdc42503          	lw	a0,-36(s0)
    80002172:	fffff097          	auipc	ra,0xfffff
    80002176:	08c080e7          	jalr	140(ra) # 800011fe <growproc>
    8000217a:	00054863          	bltz	a0,8000218a <sys_sbrk+0x46>
    return -1;
  return addr;
    8000217e:	8526                	mv	a0,s1
}
    80002180:	70a2                	ld	ra,40(sp)
    80002182:	7402                	ld	s0,32(sp)
    80002184:	64e2                	ld	s1,24(sp)
    80002186:	6145                	addi	sp,sp,48
    80002188:	8082                	ret
    return -1;
    8000218a:	557d                	li	a0,-1
    8000218c:	bfd5                	j	80002180 <sys_sbrk+0x3c>

000000008000218e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000218e:	7139                	addi	sp,sp,-64
    80002190:	fc06                	sd	ra,56(sp)
    80002192:	f822                	sd	s0,48(sp)
    80002194:	f426                	sd	s1,40(sp)
    80002196:	f04a                	sd	s2,32(sp)
    80002198:	ec4e                	sd	s3,24(sp)
    8000219a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000219c:	fcc40593          	addi	a1,s0,-52
    800021a0:	4501                	li	a0,0
    800021a2:	00000097          	auipc	ra,0x0
    800021a6:	db6080e7          	jalr	-586(ra) # 80001f58 <argint>
    return -1;
    800021aa:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021ac:	06054563          	bltz	a0,80002216 <sys_sleep+0x88>
  acquire(&tickslock);
    800021b0:	0000d517          	auipc	a0,0xd
    800021b4:	cd050513          	addi	a0,a0,-816 # 8000ee80 <tickslock>
    800021b8:	00004097          	auipc	ra,0x4
    800021bc:	01a080e7          	jalr	26(ra) # 800061d2 <acquire>
  ticks0 = ticks;
    800021c0:	00007917          	auipc	s2,0x7
    800021c4:	e5892903          	lw	s2,-424(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021c8:	fcc42783          	lw	a5,-52(s0)
    800021cc:	cf85                	beqz	a5,80002204 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021ce:	0000d997          	auipc	s3,0xd
    800021d2:	cb298993          	addi	s3,s3,-846 # 8000ee80 <tickslock>
    800021d6:	00007497          	auipc	s1,0x7
    800021da:	e4248493          	addi	s1,s1,-446 # 80009018 <ticks>
    if(myproc()->killed){
    800021de:	fffff097          	auipc	ra,0xfffff
    800021e2:	c90080e7          	jalr	-880(ra) # 80000e6e <myproc>
    800021e6:	551c                	lw	a5,40(a0)
    800021e8:	ef9d                	bnez	a5,80002226 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021ea:	85ce                	mv	a1,s3
    800021ec:	8526                	mv	a0,s1
    800021ee:	fffff097          	auipc	ra,0xfffff
    800021f2:	37a080e7          	jalr	890(ra) # 80001568 <sleep>
  while(ticks - ticks0 < n){
    800021f6:	409c                	lw	a5,0(s1)
    800021f8:	412787bb          	subw	a5,a5,s2
    800021fc:	fcc42703          	lw	a4,-52(s0)
    80002200:	fce7efe3          	bltu	a5,a4,800021de <sys_sleep+0x50>
  }
  release(&tickslock);
    80002204:	0000d517          	auipc	a0,0xd
    80002208:	c7c50513          	addi	a0,a0,-900 # 8000ee80 <tickslock>
    8000220c:	00004097          	auipc	ra,0x4
    80002210:	07a080e7          	jalr	122(ra) # 80006286 <release>
  return 0;
    80002214:	4781                	li	a5,0
}
    80002216:	853e                	mv	a0,a5
    80002218:	70e2                	ld	ra,56(sp)
    8000221a:	7442                	ld	s0,48(sp)
    8000221c:	74a2                	ld	s1,40(sp)
    8000221e:	7902                	ld	s2,32(sp)
    80002220:	69e2                	ld	s3,24(sp)
    80002222:	6121                	addi	sp,sp,64
    80002224:	8082                	ret
      release(&tickslock);
    80002226:	0000d517          	auipc	a0,0xd
    8000222a:	c5a50513          	addi	a0,a0,-934 # 8000ee80 <tickslock>
    8000222e:	00004097          	auipc	ra,0x4
    80002232:	058080e7          	jalr	88(ra) # 80006286 <release>
      return -1;
    80002236:	57fd                	li	a5,-1
    80002238:	bff9                	j	80002216 <sys_sleep+0x88>

000000008000223a <sys_kill>:

uint64
sys_kill(void)
{
    8000223a:	1101                	addi	sp,sp,-32
    8000223c:	ec06                	sd	ra,24(sp)
    8000223e:	e822                	sd	s0,16(sp)
    80002240:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002242:	fec40593          	addi	a1,s0,-20
    80002246:	4501                	li	a0,0
    80002248:	00000097          	auipc	ra,0x0
    8000224c:	d10080e7          	jalr	-752(ra) # 80001f58 <argint>
    80002250:	87aa                	mv	a5,a0
    return -1;
    80002252:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002254:	0007c863          	bltz	a5,80002264 <sys_kill+0x2a>
  return kill(pid);
    80002258:	fec42503          	lw	a0,-20(s0)
    8000225c:	fffff097          	auipc	ra,0xfffff
    80002260:	63e080e7          	jalr	1598(ra) # 8000189a <kill>
}
    80002264:	60e2                	ld	ra,24(sp)
    80002266:	6442                	ld	s0,16(sp)
    80002268:	6105                	addi	sp,sp,32
    8000226a:	8082                	ret

000000008000226c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000226c:	1101                	addi	sp,sp,-32
    8000226e:	ec06                	sd	ra,24(sp)
    80002270:	e822                	sd	s0,16(sp)
    80002272:	e426                	sd	s1,8(sp)
    80002274:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002276:	0000d517          	auipc	a0,0xd
    8000227a:	c0a50513          	addi	a0,a0,-1014 # 8000ee80 <tickslock>
    8000227e:	00004097          	auipc	ra,0x4
    80002282:	f54080e7          	jalr	-172(ra) # 800061d2 <acquire>
  xticks = ticks;
    80002286:	00007497          	auipc	s1,0x7
    8000228a:	d924a483          	lw	s1,-622(s1) # 80009018 <ticks>
  release(&tickslock);
    8000228e:	0000d517          	auipc	a0,0xd
    80002292:	bf250513          	addi	a0,a0,-1038 # 8000ee80 <tickslock>
    80002296:	00004097          	auipc	ra,0x4
    8000229a:	ff0080e7          	jalr	-16(ra) # 80006286 <release>
  return xticks;
}
    8000229e:	02049513          	slli	a0,s1,0x20
    800022a2:	9101                	srli	a0,a0,0x20
    800022a4:	60e2                	ld	ra,24(sp)
    800022a6:	6442                	ld	s0,16(sp)
    800022a8:	64a2                	ld	s1,8(sp)
    800022aa:	6105                	addi	sp,sp,32
    800022ac:	8082                	ret

00000000800022ae <sys_trace>:

uint64
sys_trace(void)
{
    800022ae:	1101                	addi	sp,sp,-32
    800022b0:	ec06                	sd	ra,24(sp)
    800022b2:	e822                	sd	s0,16(sp)
    800022b4:	1000                	addi	s0,sp,32
	int mask;
	// argument from user store in a0
	if(argint(0, &mask) < 0)
    800022b6:	fec40593          	addi	a1,s0,-20
    800022ba:	4501                	li	a0,0
    800022bc:	00000097          	auipc	ra,0x0
    800022c0:	c9c080e7          	jalr	-868(ra) # 80001f58 <argint>
		return -1;
    800022c4:	57fd                	li	a5,-1
	if(argint(0, &mask) < 0)
    800022c6:	00054a63          	bltz	a0,800022da <sys_trace+0x2c>
	myproc()->mask = mask;
    800022ca:	fffff097          	auipc	ra,0xfffff
    800022ce:	ba4080e7          	jalr	-1116(ra) # 80000e6e <myproc>
    800022d2:	fec42783          	lw	a5,-20(s0)
    800022d6:	d95c                	sw	a5,52(a0)
	return 0;
    800022d8:	4781                	li	a5,0
}
    800022da:	853e                	mv	a0,a5
    800022dc:	60e2                	ld	ra,24(sp)
    800022de:	6442                	ld	s0,16(sp)
    800022e0:	6105                	addi	sp,sp,32
    800022e2:	8082                	ret

00000000800022e4 <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    800022e4:	7139                	addi	sp,sp,-64
    800022e6:	fc06                	sd	ra,56(sp)
    800022e8:	f822                	sd	s0,48(sp)
    800022ea:	f426                	sd	s1,40(sp)
    800022ec:	0080                	addi	s0,sp,64
	struct proc *p = myproc();
    800022ee:	fffff097          	auipc	ra,0xfffff
    800022f2:	b80080e7          	jalr	-1152(ra) # 80000e6e <myproc>
    800022f6:	84aa                	mv	s1,a0
	uint64 addr;
	if(argaddr(0, &addr) < 0)
    800022f8:	fd840593          	addi	a1,s0,-40
    800022fc:	4501                	li	a0,0
    800022fe:	00000097          	auipc	ra,0x0
    80002302:	c7c080e7          	jalr	-900(ra) # 80001f7a <argaddr>
    80002306:	87aa                	mv	a5,a0
		return -1;
    80002308:	557d                	li	a0,-1
	if(argaddr(0, &addr) < 0)
    8000230a:	0207c863          	bltz	a5,8000233a <sys_sysinfo+0x56>
	struct sysinfo info;
	calFreemem(&(info.freemem));
    8000230e:	fc840513          	addi	a0,s0,-56
    80002312:	ffffe097          	auipc	ra,0xffffe
    80002316:	e66080e7          	jalr	-410(ra) # 80000178 <calFreemem>
	calUnproc(&(info.nproc));
    8000231a:	fd040513          	addi	a0,s0,-48
    8000231e:	fffff097          	auipc	ra,0xfffff
    80002322:	c14080e7          	jalr	-1004(ra) # 80000f32 <calUnproc>
	return copyout(p->pagetable, addr, (char *)&info, sizeof(info));
    80002326:	46c1                	li	a3,16
    80002328:	fc840613          	addi	a2,s0,-56
    8000232c:	fd843583          	ld	a1,-40(s0)
    80002330:	68a8                	ld	a0,80(s1)
    80002332:	ffffe097          	auipc	ra,0xffffe
    80002336:	7fe080e7          	jalr	2046(ra) # 80000b30 <copyout>
}	
    8000233a:	70e2                	ld	ra,56(sp)
    8000233c:	7442                	ld	s0,48(sp)
    8000233e:	74a2                	ld	s1,40(sp)
    80002340:	6121                	addi	sp,sp,64
    80002342:	8082                	ret

0000000080002344 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002344:	7179                	addi	sp,sp,-48
    80002346:	f406                	sd	ra,40(sp)
    80002348:	f022                	sd	s0,32(sp)
    8000234a:	ec26                	sd	s1,24(sp)
    8000234c:	e84a                	sd	s2,16(sp)
    8000234e:	e44e                	sd	s3,8(sp)
    80002350:	e052                	sd	s4,0(sp)
    80002352:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002354:	00006597          	auipc	a1,0x6
    80002358:	2bc58593          	addi	a1,a1,700 # 80008610 <syscalls+0xc0>
    8000235c:	0000d517          	auipc	a0,0xd
    80002360:	b3c50513          	addi	a0,a0,-1220 # 8000ee98 <bcache>
    80002364:	00004097          	auipc	ra,0x4
    80002368:	dde080e7          	jalr	-546(ra) # 80006142 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000236c:	00015797          	auipc	a5,0x15
    80002370:	b2c78793          	addi	a5,a5,-1236 # 80016e98 <bcache+0x8000>
    80002374:	00015717          	auipc	a4,0x15
    80002378:	d8c70713          	addi	a4,a4,-628 # 80017100 <bcache+0x8268>
    8000237c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002380:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002384:	0000d497          	auipc	s1,0xd
    80002388:	b2c48493          	addi	s1,s1,-1236 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    8000238c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000238e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002390:	00006a17          	auipc	s4,0x6
    80002394:	288a0a13          	addi	s4,s4,648 # 80008618 <syscalls+0xc8>
    b->next = bcache.head.next;
    80002398:	2b893783          	ld	a5,696(s2)
    8000239c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000239e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023a2:	85d2                	mv	a1,s4
    800023a4:	01048513          	addi	a0,s1,16
    800023a8:	00001097          	auipc	ra,0x1
    800023ac:	4bc080e7          	jalr	1212(ra) # 80003864 <initsleeplock>
    bcache.head.next->prev = b;
    800023b0:	2b893783          	ld	a5,696(s2)
    800023b4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023b6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023ba:	45848493          	addi	s1,s1,1112
    800023be:	fd349de3          	bne	s1,s3,80002398 <binit+0x54>
  }
}
    800023c2:	70a2                	ld	ra,40(sp)
    800023c4:	7402                	ld	s0,32(sp)
    800023c6:	64e2                	ld	s1,24(sp)
    800023c8:	6942                	ld	s2,16(sp)
    800023ca:	69a2                	ld	s3,8(sp)
    800023cc:	6a02                	ld	s4,0(sp)
    800023ce:	6145                	addi	sp,sp,48
    800023d0:	8082                	ret

00000000800023d2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023d2:	7179                	addi	sp,sp,-48
    800023d4:	f406                	sd	ra,40(sp)
    800023d6:	f022                	sd	s0,32(sp)
    800023d8:	ec26                	sd	s1,24(sp)
    800023da:	e84a                	sd	s2,16(sp)
    800023dc:	e44e                	sd	s3,8(sp)
    800023de:	1800                	addi	s0,sp,48
    800023e0:	89aa                	mv	s3,a0
    800023e2:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800023e4:	0000d517          	auipc	a0,0xd
    800023e8:	ab450513          	addi	a0,a0,-1356 # 8000ee98 <bcache>
    800023ec:	00004097          	auipc	ra,0x4
    800023f0:	de6080e7          	jalr	-538(ra) # 800061d2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023f4:	00015497          	auipc	s1,0x15
    800023f8:	d5c4b483          	ld	s1,-676(s1) # 80017150 <bcache+0x82b8>
    800023fc:	00015797          	auipc	a5,0x15
    80002400:	d0478793          	addi	a5,a5,-764 # 80017100 <bcache+0x8268>
    80002404:	02f48f63          	beq	s1,a5,80002442 <bread+0x70>
    80002408:	873e                	mv	a4,a5
    8000240a:	a021                	j	80002412 <bread+0x40>
    8000240c:	68a4                	ld	s1,80(s1)
    8000240e:	02e48a63          	beq	s1,a4,80002442 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002412:	449c                	lw	a5,8(s1)
    80002414:	ff379ce3          	bne	a5,s3,8000240c <bread+0x3a>
    80002418:	44dc                	lw	a5,12(s1)
    8000241a:	ff2799e3          	bne	a5,s2,8000240c <bread+0x3a>
      b->refcnt++;
    8000241e:	40bc                	lw	a5,64(s1)
    80002420:	2785                	addiw	a5,a5,1
    80002422:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002424:	0000d517          	auipc	a0,0xd
    80002428:	a7450513          	addi	a0,a0,-1420 # 8000ee98 <bcache>
    8000242c:	00004097          	auipc	ra,0x4
    80002430:	e5a080e7          	jalr	-422(ra) # 80006286 <release>
      acquiresleep(&b->lock);
    80002434:	01048513          	addi	a0,s1,16
    80002438:	00001097          	auipc	ra,0x1
    8000243c:	466080e7          	jalr	1126(ra) # 8000389e <acquiresleep>
      return b;
    80002440:	a8b9                	j	8000249e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002442:	00015497          	auipc	s1,0x15
    80002446:	d064b483          	ld	s1,-762(s1) # 80017148 <bcache+0x82b0>
    8000244a:	00015797          	auipc	a5,0x15
    8000244e:	cb678793          	addi	a5,a5,-842 # 80017100 <bcache+0x8268>
    80002452:	00f48863          	beq	s1,a5,80002462 <bread+0x90>
    80002456:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002458:	40bc                	lw	a5,64(s1)
    8000245a:	cf81                	beqz	a5,80002472 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000245c:	64a4                	ld	s1,72(s1)
    8000245e:	fee49de3          	bne	s1,a4,80002458 <bread+0x86>
  panic("bget: no buffers");
    80002462:	00006517          	auipc	a0,0x6
    80002466:	1be50513          	addi	a0,a0,446 # 80008620 <syscalls+0xd0>
    8000246a:	00004097          	auipc	ra,0x4
    8000246e:	81e080e7          	jalr	-2018(ra) # 80005c88 <panic>
      b->dev = dev;
    80002472:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002476:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000247a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000247e:	4785                	li	a5,1
    80002480:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002482:	0000d517          	auipc	a0,0xd
    80002486:	a1650513          	addi	a0,a0,-1514 # 8000ee98 <bcache>
    8000248a:	00004097          	auipc	ra,0x4
    8000248e:	dfc080e7          	jalr	-516(ra) # 80006286 <release>
      acquiresleep(&b->lock);
    80002492:	01048513          	addi	a0,s1,16
    80002496:	00001097          	auipc	ra,0x1
    8000249a:	408080e7          	jalr	1032(ra) # 8000389e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000249e:	409c                	lw	a5,0(s1)
    800024a0:	cb89                	beqz	a5,800024b2 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024a2:	8526                	mv	a0,s1
    800024a4:	70a2                	ld	ra,40(sp)
    800024a6:	7402                	ld	s0,32(sp)
    800024a8:	64e2                	ld	s1,24(sp)
    800024aa:	6942                	ld	s2,16(sp)
    800024ac:	69a2                	ld	s3,8(sp)
    800024ae:	6145                	addi	sp,sp,48
    800024b0:	8082                	ret
    virtio_disk_rw(b, 0);
    800024b2:	4581                	li	a1,0
    800024b4:	8526                	mv	a0,s1
    800024b6:	00003097          	auipc	ra,0x3
    800024ba:	f10080e7          	jalr	-240(ra) # 800053c6 <virtio_disk_rw>
    b->valid = 1;
    800024be:	4785                	li	a5,1
    800024c0:	c09c                	sw	a5,0(s1)
  return b;
    800024c2:	b7c5                	j	800024a2 <bread+0xd0>

00000000800024c4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024c4:	1101                	addi	sp,sp,-32
    800024c6:	ec06                	sd	ra,24(sp)
    800024c8:	e822                	sd	s0,16(sp)
    800024ca:	e426                	sd	s1,8(sp)
    800024cc:	1000                	addi	s0,sp,32
    800024ce:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024d0:	0541                	addi	a0,a0,16
    800024d2:	00001097          	auipc	ra,0x1
    800024d6:	466080e7          	jalr	1126(ra) # 80003938 <holdingsleep>
    800024da:	cd01                	beqz	a0,800024f2 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024dc:	4585                	li	a1,1
    800024de:	8526                	mv	a0,s1
    800024e0:	00003097          	auipc	ra,0x3
    800024e4:	ee6080e7          	jalr	-282(ra) # 800053c6 <virtio_disk_rw>
}
    800024e8:	60e2                	ld	ra,24(sp)
    800024ea:	6442                	ld	s0,16(sp)
    800024ec:	64a2                	ld	s1,8(sp)
    800024ee:	6105                	addi	sp,sp,32
    800024f0:	8082                	ret
    panic("bwrite");
    800024f2:	00006517          	auipc	a0,0x6
    800024f6:	14650513          	addi	a0,a0,326 # 80008638 <syscalls+0xe8>
    800024fa:	00003097          	auipc	ra,0x3
    800024fe:	78e080e7          	jalr	1934(ra) # 80005c88 <panic>

0000000080002502 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002502:	1101                	addi	sp,sp,-32
    80002504:	ec06                	sd	ra,24(sp)
    80002506:	e822                	sd	s0,16(sp)
    80002508:	e426                	sd	s1,8(sp)
    8000250a:	e04a                	sd	s2,0(sp)
    8000250c:	1000                	addi	s0,sp,32
    8000250e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002510:	01050913          	addi	s2,a0,16
    80002514:	854a                	mv	a0,s2
    80002516:	00001097          	auipc	ra,0x1
    8000251a:	422080e7          	jalr	1058(ra) # 80003938 <holdingsleep>
    8000251e:	c92d                	beqz	a0,80002590 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002520:	854a                	mv	a0,s2
    80002522:	00001097          	auipc	ra,0x1
    80002526:	3d2080e7          	jalr	978(ra) # 800038f4 <releasesleep>

  acquire(&bcache.lock);
    8000252a:	0000d517          	auipc	a0,0xd
    8000252e:	96e50513          	addi	a0,a0,-1682 # 8000ee98 <bcache>
    80002532:	00004097          	auipc	ra,0x4
    80002536:	ca0080e7          	jalr	-864(ra) # 800061d2 <acquire>
  b->refcnt--;
    8000253a:	40bc                	lw	a5,64(s1)
    8000253c:	37fd                	addiw	a5,a5,-1
    8000253e:	0007871b          	sext.w	a4,a5
    80002542:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002544:	eb05                	bnez	a4,80002574 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002546:	68bc                	ld	a5,80(s1)
    80002548:	64b8                	ld	a4,72(s1)
    8000254a:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000254c:	64bc                	ld	a5,72(s1)
    8000254e:	68b8                	ld	a4,80(s1)
    80002550:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002552:	00015797          	auipc	a5,0x15
    80002556:	94678793          	addi	a5,a5,-1722 # 80016e98 <bcache+0x8000>
    8000255a:	2b87b703          	ld	a4,696(a5)
    8000255e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002560:	00015717          	auipc	a4,0x15
    80002564:	ba070713          	addi	a4,a4,-1120 # 80017100 <bcache+0x8268>
    80002568:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000256a:	2b87b703          	ld	a4,696(a5)
    8000256e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002570:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002574:	0000d517          	auipc	a0,0xd
    80002578:	92450513          	addi	a0,a0,-1756 # 8000ee98 <bcache>
    8000257c:	00004097          	auipc	ra,0x4
    80002580:	d0a080e7          	jalr	-758(ra) # 80006286 <release>
}
    80002584:	60e2                	ld	ra,24(sp)
    80002586:	6442                	ld	s0,16(sp)
    80002588:	64a2                	ld	s1,8(sp)
    8000258a:	6902                	ld	s2,0(sp)
    8000258c:	6105                	addi	sp,sp,32
    8000258e:	8082                	ret
    panic("brelse");
    80002590:	00006517          	auipc	a0,0x6
    80002594:	0b050513          	addi	a0,a0,176 # 80008640 <syscalls+0xf0>
    80002598:	00003097          	auipc	ra,0x3
    8000259c:	6f0080e7          	jalr	1776(ra) # 80005c88 <panic>

00000000800025a0 <bpin>:

void
bpin(struct buf *b) {
    800025a0:	1101                	addi	sp,sp,-32
    800025a2:	ec06                	sd	ra,24(sp)
    800025a4:	e822                	sd	s0,16(sp)
    800025a6:	e426                	sd	s1,8(sp)
    800025a8:	1000                	addi	s0,sp,32
    800025aa:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025ac:	0000d517          	auipc	a0,0xd
    800025b0:	8ec50513          	addi	a0,a0,-1812 # 8000ee98 <bcache>
    800025b4:	00004097          	auipc	ra,0x4
    800025b8:	c1e080e7          	jalr	-994(ra) # 800061d2 <acquire>
  b->refcnt++;
    800025bc:	40bc                	lw	a5,64(s1)
    800025be:	2785                	addiw	a5,a5,1
    800025c0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025c2:	0000d517          	auipc	a0,0xd
    800025c6:	8d650513          	addi	a0,a0,-1834 # 8000ee98 <bcache>
    800025ca:	00004097          	auipc	ra,0x4
    800025ce:	cbc080e7          	jalr	-836(ra) # 80006286 <release>
}
    800025d2:	60e2                	ld	ra,24(sp)
    800025d4:	6442                	ld	s0,16(sp)
    800025d6:	64a2                	ld	s1,8(sp)
    800025d8:	6105                	addi	sp,sp,32
    800025da:	8082                	ret

00000000800025dc <bunpin>:

void
bunpin(struct buf *b) {
    800025dc:	1101                	addi	sp,sp,-32
    800025de:	ec06                	sd	ra,24(sp)
    800025e0:	e822                	sd	s0,16(sp)
    800025e2:	e426                	sd	s1,8(sp)
    800025e4:	1000                	addi	s0,sp,32
    800025e6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025e8:	0000d517          	auipc	a0,0xd
    800025ec:	8b050513          	addi	a0,a0,-1872 # 8000ee98 <bcache>
    800025f0:	00004097          	auipc	ra,0x4
    800025f4:	be2080e7          	jalr	-1054(ra) # 800061d2 <acquire>
  b->refcnt--;
    800025f8:	40bc                	lw	a5,64(s1)
    800025fa:	37fd                	addiw	a5,a5,-1
    800025fc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025fe:	0000d517          	auipc	a0,0xd
    80002602:	89a50513          	addi	a0,a0,-1894 # 8000ee98 <bcache>
    80002606:	00004097          	auipc	ra,0x4
    8000260a:	c80080e7          	jalr	-896(ra) # 80006286 <release>
}
    8000260e:	60e2                	ld	ra,24(sp)
    80002610:	6442                	ld	s0,16(sp)
    80002612:	64a2                	ld	s1,8(sp)
    80002614:	6105                	addi	sp,sp,32
    80002616:	8082                	ret

0000000080002618 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002618:	1101                	addi	sp,sp,-32
    8000261a:	ec06                	sd	ra,24(sp)
    8000261c:	e822                	sd	s0,16(sp)
    8000261e:	e426                	sd	s1,8(sp)
    80002620:	e04a                	sd	s2,0(sp)
    80002622:	1000                	addi	s0,sp,32
    80002624:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002626:	00d5d59b          	srliw	a1,a1,0xd
    8000262a:	00015797          	auipc	a5,0x15
    8000262e:	f4a7a783          	lw	a5,-182(a5) # 80017574 <sb+0x1c>
    80002632:	9dbd                	addw	a1,a1,a5
    80002634:	00000097          	auipc	ra,0x0
    80002638:	d9e080e7          	jalr	-610(ra) # 800023d2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000263c:	0074f713          	andi	a4,s1,7
    80002640:	4785                	li	a5,1
    80002642:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002646:	14ce                	slli	s1,s1,0x33
    80002648:	90d9                	srli	s1,s1,0x36
    8000264a:	00950733          	add	a4,a0,s1
    8000264e:	05874703          	lbu	a4,88(a4)
    80002652:	00e7f6b3          	and	a3,a5,a4
    80002656:	c69d                	beqz	a3,80002684 <bfree+0x6c>
    80002658:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000265a:	94aa                	add	s1,s1,a0
    8000265c:	fff7c793          	not	a5,a5
    80002660:	8ff9                	and	a5,a5,a4
    80002662:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002666:	00001097          	auipc	ra,0x1
    8000266a:	118080e7          	jalr	280(ra) # 8000377e <log_write>
  brelse(bp);
    8000266e:	854a                	mv	a0,s2
    80002670:	00000097          	auipc	ra,0x0
    80002674:	e92080e7          	jalr	-366(ra) # 80002502 <brelse>
}
    80002678:	60e2                	ld	ra,24(sp)
    8000267a:	6442                	ld	s0,16(sp)
    8000267c:	64a2                	ld	s1,8(sp)
    8000267e:	6902                	ld	s2,0(sp)
    80002680:	6105                	addi	sp,sp,32
    80002682:	8082                	ret
    panic("freeing free block");
    80002684:	00006517          	auipc	a0,0x6
    80002688:	fc450513          	addi	a0,a0,-60 # 80008648 <syscalls+0xf8>
    8000268c:	00003097          	auipc	ra,0x3
    80002690:	5fc080e7          	jalr	1532(ra) # 80005c88 <panic>

0000000080002694 <balloc>:
{
    80002694:	711d                	addi	sp,sp,-96
    80002696:	ec86                	sd	ra,88(sp)
    80002698:	e8a2                	sd	s0,80(sp)
    8000269a:	e4a6                	sd	s1,72(sp)
    8000269c:	e0ca                	sd	s2,64(sp)
    8000269e:	fc4e                	sd	s3,56(sp)
    800026a0:	f852                	sd	s4,48(sp)
    800026a2:	f456                	sd	s5,40(sp)
    800026a4:	f05a                	sd	s6,32(sp)
    800026a6:	ec5e                	sd	s7,24(sp)
    800026a8:	e862                	sd	s8,16(sp)
    800026aa:	e466                	sd	s9,8(sp)
    800026ac:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026ae:	00015797          	auipc	a5,0x15
    800026b2:	eae7a783          	lw	a5,-338(a5) # 8001755c <sb+0x4>
    800026b6:	cbd1                	beqz	a5,8000274a <balloc+0xb6>
    800026b8:	8baa                	mv	s7,a0
    800026ba:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026bc:	00015b17          	auipc	s6,0x15
    800026c0:	e9cb0b13          	addi	s6,s6,-356 # 80017558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026c4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026c6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026c8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026ca:	6c89                	lui	s9,0x2
    800026cc:	a831                	j	800026e8 <balloc+0x54>
    brelse(bp);
    800026ce:	854a                	mv	a0,s2
    800026d0:	00000097          	auipc	ra,0x0
    800026d4:	e32080e7          	jalr	-462(ra) # 80002502 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026d8:	015c87bb          	addw	a5,s9,s5
    800026dc:	00078a9b          	sext.w	s5,a5
    800026e0:	004b2703          	lw	a4,4(s6)
    800026e4:	06eaf363          	bgeu	s5,a4,8000274a <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800026e8:	41fad79b          	sraiw	a5,s5,0x1f
    800026ec:	0137d79b          	srliw	a5,a5,0x13
    800026f0:	015787bb          	addw	a5,a5,s5
    800026f4:	40d7d79b          	sraiw	a5,a5,0xd
    800026f8:	01cb2583          	lw	a1,28(s6)
    800026fc:	9dbd                	addw	a1,a1,a5
    800026fe:	855e                	mv	a0,s7
    80002700:	00000097          	auipc	ra,0x0
    80002704:	cd2080e7          	jalr	-814(ra) # 800023d2 <bread>
    80002708:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000270a:	004b2503          	lw	a0,4(s6)
    8000270e:	000a849b          	sext.w	s1,s5
    80002712:	8662                	mv	a2,s8
    80002714:	faa4fde3          	bgeu	s1,a0,800026ce <balloc+0x3a>
      m = 1 << (bi % 8);
    80002718:	41f6579b          	sraiw	a5,a2,0x1f
    8000271c:	01d7d69b          	srliw	a3,a5,0x1d
    80002720:	00c6873b          	addw	a4,a3,a2
    80002724:	00777793          	andi	a5,a4,7
    80002728:	9f95                	subw	a5,a5,a3
    8000272a:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000272e:	4037571b          	sraiw	a4,a4,0x3
    80002732:	00e906b3          	add	a3,s2,a4
    80002736:	0586c683          	lbu	a3,88(a3)
    8000273a:	00d7f5b3          	and	a1,a5,a3
    8000273e:	cd91                	beqz	a1,8000275a <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002740:	2605                	addiw	a2,a2,1
    80002742:	2485                	addiw	s1,s1,1
    80002744:	fd4618e3          	bne	a2,s4,80002714 <balloc+0x80>
    80002748:	b759                	j	800026ce <balloc+0x3a>
  panic("balloc: out of blocks");
    8000274a:	00006517          	auipc	a0,0x6
    8000274e:	f1650513          	addi	a0,a0,-234 # 80008660 <syscalls+0x110>
    80002752:	00003097          	auipc	ra,0x3
    80002756:	536080e7          	jalr	1334(ra) # 80005c88 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000275a:	974a                	add	a4,a4,s2
    8000275c:	8fd5                	or	a5,a5,a3
    8000275e:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002762:	854a                	mv	a0,s2
    80002764:	00001097          	auipc	ra,0x1
    80002768:	01a080e7          	jalr	26(ra) # 8000377e <log_write>
        brelse(bp);
    8000276c:	854a                	mv	a0,s2
    8000276e:	00000097          	auipc	ra,0x0
    80002772:	d94080e7          	jalr	-620(ra) # 80002502 <brelse>
  bp = bread(dev, bno);
    80002776:	85a6                	mv	a1,s1
    80002778:	855e                	mv	a0,s7
    8000277a:	00000097          	auipc	ra,0x0
    8000277e:	c58080e7          	jalr	-936(ra) # 800023d2 <bread>
    80002782:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002784:	40000613          	li	a2,1024
    80002788:	4581                	li	a1,0
    8000278a:	05850513          	addi	a0,a0,88
    8000278e:	ffffe097          	auipc	ra,0xffffe
    80002792:	a10080e7          	jalr	-1520(ra) # 8000019e <memset>
  log_write(bp);
    80002796:	854a                	mv	a0,s2
    80002798:	00001097          	auipc	ra,0x1
    8000279c:	fe6080e7          	jalr	-26(ra) # 8000377e <log_write>
  brelse(bp);
    800027a0:	854a                	mv	a0,s2
    800027a2:	00000097          	auipc	ra,0x0
    800027a6:	d60080e7          	jalr	-672(ra) # 80002502 <brelse>
}
    800027aa:	8526                	mv	a0,s1
    800027ac:	60e6                	ld	ra,88(sp)
    800027ae:	6446                	ld	s0,80(sp)
    800027b0:	64a6                	ld	s1,72(sp)
    800027b2:	6906                	ld	s2,64(sp)
    800027b4:	79e2                	ld	s3,56(sp)
    800027b6:	7a42                	ld	s4,48(sp)
    800027b8:	7aa2                	ld	s5,40(sp)
    800027ba:	7b02                	ld	s6,32(sp)
    800027bc:	6be2                	ld	s7,24(sp)
    800027be:	6c42                	ld	s8,16(sp)
    800027c0:	6ca2                	ld	s9,8(sp)
    800027c2:	6125                	addi	sp,sp,96
    800027c4:	8082                	ret

00000000800027c6 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027c6:	7179                	addi	sp,sp,-48
    800027c8:	f406                	sd	ra,40(sp)
    800027ca:	f022                	sd	s0,32(sp)
    800027cc:	ec26                	sd	s1,24(sp)
    800027ce:	e84a                	sd	s2,16(sp)
    800027d0:	e44e                	sd	s3,8(sp)
    800027d2:	e052                	sd	s4,0(sp)
    800027d4:	1800                	addi	s0,sp,48
    800027d6:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027d8:	47ad                	li	a5,11
    800027da:	04b7fe63          	bgeu	a5,a1,80002836 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027de:	ff45849b          	addiw	s1,a1,-12
    800027e2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027e6:	0ff00793          	li	a5,255
    800027ea:	0ae7e363          	bltu	a5,a4,80002890 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027ee:	08052583          	lw	a1,128(a0)
    800027f2:	c5ad                	beqz	a1,8000285c <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800027f4:	00092503          	lw	a0,0(s2)
    800027f8:	00000097          	auipc	ra,0x0
    800027fc:	bda080e7          	jalr	-1062(ra) # 800023d2 <bread>
    80002800:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002802:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002806:	02049593          	slli	a1,s1,0x20
    8000280a:	9181                	srli	a1,a1,0x20
    8000280c:	058a                	slli	a1,a1,0x2
    8000280e:	00b784b3          	add	s1,a5,a1
    80002812:	0004a983          	lw	s3,0(s1)
    80002816:	04098d63          	beqz	s3,80002870 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000281a:	8552                	mv	a0,s4
    8000281c:	00000097          	auipc	ra,0x0
    80002820:	ce6080e7          	jalr	-794(ra) # 80002502 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002824:	854e                	mv	a0,s3
    80002826:	70a2                	ld	ra,40(sp)
    80002828:	7402                	ld	s0,32(sp)
    8000282a:	64e2                	ld	s1,24(sp)
    8000282c:	6942                	ld	s2,16(sp)
    8000282e:	69a2                	ld	s3,8(sp)
    80002830:	6a02                	ld	s4,0(sp)
    80002832:	6145                	addi	sp,sp,48
    80002834:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002836:	02059493          	slli	s1,a1,0x20
    8000283a:	9081                	srli	s1,s1,0x20
    8000283c:	048a                	slli	s1,s1,0x2
    8000283e:	94aa                	add	s1,s1,a0
    80002840:	0504a983          	lw	s3,80(s1)
    80002844:	fe0990e3          	bnez	s3,80002824 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002848:	4108                	lw	a0,0(a0)
    8000284a:	00000097          	auipc	ra,0x0
    8000284e:	e4a080e7          	jalr	-438(ra) # 80002694 <balloc>
    80002852:	0005099b          	sext.w	s3,a0
    80002856:	0534a823          	sw	s3,80(s1)
    8000285a:	b7e9                	j	80002824 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000285c:	4108                	lw	a0,0(a0)
    8000285e:	00000097          	auipc	ra,0x0
    80002862:	e36080e7          	jalr	-458(ra) # 80002694 <balloc>
    80002866:	0005059b          	sext.w	a1,a0
    8000286a:	08b92023          	sw	a1,128(s2)
    8000286e:	b759                	j	800027f4 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002870:	00092503          	lw	a0,0(s2)
    80002874:	00000097          	auipc	ra,0x0
    80002878:	e20080e7          	jalr	-480(ra) # 80002694 <balloc>
    8000287c:	0005099b          	sext.w	s3,a0
    80002880:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002884:	8552                	mv	a0,s4
    80002886:	00001097          	auipc	ra,0x1
    8000288a:	ef8080e7          	jalr	-264(ra) # 8000377e <log_write>
    8000288e:	b771                	j	8000281a <bmap+0x54>
  panic("bmap: out of range");
    80002890:	00006517          	auipc	a0,0x6
    80002894:	de850513          	addi	a0,a0,-536 # 80008678 <syscalls+0x128>
    80002898:	00003097          	auipc	ra,0x3
    8000289c:	3f0080e7          	jalr	1008(ra) # 80005c88 <panic>

00000000800028a0 <iget>:
{
    800028a0:	7179                	addi	sp,sp,-48
    800028a2:	f406                	sd	ra,40(sp)
    800028a4:	f022                	sd	s0,32(sp)
    800028a6:	ec26                	sd	s1,24(sp)
    800028a8:	e84a                	sd	s2,16(sp)
    800028aa:	e44e                	sd	s3,8(sp)
    800028ac:	e052                	sd	s4,0(sp)
    800028ae:	1800                	addi	s0,sp,48
    800028b0:	89aa                	mv	s3,a0
    800028b2:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028b4:	00015517          	auipc	a0,0x15
    800028b8:	cc450513          	addi	a0,a0,-828 # 80017578 <itable>
    800028bc:	00004097          	auipc	ra,0x4
    800028c0:	916080e7          	jalr	-1770(ra) # 800061d2 <acquire>
  empty = 0;
    800028c4:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028c6:	00015497          	auipc	s1,0x15
    800028ca:	cca48493          	addi	s1,s1,-822 # 80017590 <itable+0x18>
    800028ce:	00016697          	auipc	a3,0x16
    800028d2:	75268693          	addi	a3,a3,1874 # 80019020 <log>
    800028d6:	a039                	j	800028e4 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028d8:	02090b63          	beqz	s2,8000290e <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028dc:	08848493          	addi	s1,s1,136
    800028e0:	02d48a63          	beq	s1,a3,80002914 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028e4:	449c                	lw	a5,8(s1)
    800028e6:	fef059e3          	blez	a5,800028d8 <iget+0x38>
    800028ea:	4098                	lw	a4,0(s1)
    800028ec:	ff3716e3          	bne	a4,s3,800028d8 <iget+0x38>
    800028f0:	40d8                	lw	a4,4(s1)
    800028f2:	ff4713e3          	bne	a4,s4,800028d8 <iget+0x38>
      ip->ref++;
    800028f6:	2785                	addiw	a5,a5,1
    800028f8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028fa:	00015517          	auipc	a0,0x15
    800028fe:	c7e50513          	addi	a0,a0,-898 # 80017578 <itable>
    80002902:	00004097          	auipc	ra,0x4
    80002906:	984080e7          	jalr	-1660(ra) # 80006286 <release>
      return ip;
    8000290a:	8926                	mv	s2,s1
    8000290c:	a03d                	j	8000293a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000290e:	f7f9                	bnez	a5,800028dc <iget+0x3c>
    80002910:	8926                	mv	s2,s1
    80002912:	b7e9                	j	800028dc <iget+0x3c>
  if(empty == 0)
    80002914:	02090c63          	beqz	s2,8000294c <iget+0xac>
  ip->dev = dev;
    80002918:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000291c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002920:	4785                	li	a5,1
    80002922:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002926:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000292a:	00015517          	auipc	a0,0x15
    8000292e:	c4e50513          	addi	a0,a0,-946 # 80017578 <itable>
    80002932:	00004097          	auipc	ra,0x4
    80002936:	954080e7          	jalr	-1708(ra) # 80006286 <release>
}
    8000293a:	854a                	mv	a0,s2
    8000293c:	70a2                	ld	ra,40(sp)
    8000293e:	7402                	ld	s0,32(sp)
    80002940:	64e2                	ld	s1,24(sp)
    80002942:	6942                	ld	s2,16(sp)
    80002944:	69a2                	ld	s3,8(sp)
    80002946:	6a02                	ld	s4,0(sp)
    80002948:	6145                	addi	sp,sp,48
    8000294a:	8082                	ret
    panic("iget: no inodes");
    8000294c:	00006517          	auipc	a0,0x6
    80002950:	d4450513          	addi	a0,a0,-700 # 80008690 <syscalls+0x140>
    80002954:	00003097          	auipc	ra,0x3
    80002958:	334080e7          	jalr	820(ra) # 80005c88 <panic>

000000008000295c <fsinit>:
fsinit(int dev) {
    8000295c:	7179                	addi	sp,sp,-48
    8000295e:	f406                	sd	ra,40(sp)
    80002960:	f022                	sd	s0,32(sp)
    80002962:	ec26                	sd	s1,24(sp)
    80002964:	e84a                	sd	s2,16(sp)
    80002966:	e44e                	sd	s3,8(sp)
    80002968:	1800                	addi	s0,sp,48
    8000296a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000296c:	4585                	li	a1,1
    8000296e:	00000097          	auipc	ra,0x0
    80002972:	a64080e7          	jalr	-1436(ra) # 800023d2 <bread>
    80002976:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002978:	00015997          	auipc	s3,0x15
    8000297c:	be098993          	addi	s3,s3,-1056 # 80017558 <sb>
    80002980:	02000613          	li	a2,32
    80002984:	05850593          	addi	a1,a0,88
    80002988:	854e                	mv	a0,s3
    8000298a:	ffffe097          	auipc	ra,0xffffe
    8000298e:	874080e7          	jalr	-1932(ra) # 800001fe <memmove>
  brelse(bp);
    80002992:	8526                	mv	a0,s1
    80002994:	00000097          	auipc	ra,0x0
    80002998:	b6e080e7          	jalr	-1170(ra) # 80002502 <brelse>
  if(sb.magic != FSMAGIC)
    8000299c:	0009a703          	lw	a4,0(s3)
    800029a0:	102037b7          	lui	a5,0x10203
    800029a4:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029a8:	02f71263          	bne	a4,a5,800029cc <fsinit+0x70>
  initlog(dev, &sb);
    800029ac:	00015597          	auipc	a1,0x15
    800029b0:	bac58593          	addi	a1,a1,-1108 # 80017558 <sb>
    800029b4:	854a                	mv	a0,s2
    800029b6:	00001097          	auipc	ra,0x1
    800029ba:	b4c080e7          	jalr	-1204(ra) # 80003502 <initlog>
}
    800029be:	70a2                	ld	ra,40(sp)
    800029c0:	7402                	ld	s0,32(sp)
    800029c2:	64e2                	ld	s1,24(sp)
    800029c4:	6942                	ld	s2,16(sp)
    800029c6:	69a2                	ld	s3,8(sp)
    800029c8:	6145                	addi	sp,sp,48
    800029ca:	8082                	ret
    panic("invalid file system");
    800029cc:	00006517          	auipc	a0,0x6
    800029d0:	cd450513          	addi	a0,a0,-812 # 800086a0 <syscalls+0x150>
    800029d4:	00003097          	auipc	ra,0x3
    800029d8:	2b4080e7          	jalr	692(ra) # 80005c88 <panic>

00000000800029dc <iinit>:
{
    800029dc:	7179                	addi	sp,sp,-48
    800029de:	f406                	sd	ra,40(sp)
    800029e0:	f022                	sd	s0,32(sp)
    800029e2:	ec26                	sd	s1,24(sp)
    800029e4:	e84a                	sd	s2,16(sp)
    800029e6:	e44e                	sd	s3,8(sp)
    800029e8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029ea:	00006597          	auipc	a1,0x6
    800029ee:	cce58593          	addi	a1,a1,-818 # 800086b8 <syscalls+0x168>
    800029f2:	00015517          	auipc	a0,0x15
    800029f6:	b8650513          	addi	a0,a0,-1146 # 80017578 <itable>
    800029fa:	00003097          	auipc	ra,0x3
    800029fe:	748080e7          	jalr	1864(ra) # 80006142 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a02:	00015497          	auipc	s1,0x15
    80002a06:	b9e48493          	addi	s1,s1,-1122 # 800175a0 <itable+0x28>
    80002a0a:	00016997          	auipc	s3,0x16
    80002a0e:	62698993          	addi	s3,s3,1574 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a12:	00006917          	auipc	s2,0x6
    80002a16:	cae90913          	addi	s2,s2,-850 # 800086c0 <syscalls+0x170>
    80002a1a:	85ca                	mv	a1,s2
    80002a1c:	8526                	mv	a0,s1
    80002a1e:	00001097          	auipc	ra,0x1
    80002a22:	e46080e7          	jalr	-442(ra) # 80003864 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a26:	08848493          	addi	s1,s1,136
    80002a2a:	ff3498e3          	bne	s1,s3,80002a1a <iinit+0x3e>
}
    80002a2e:	70a2                	ld	ra,40(sp)
    80002a30:	7402                	ld	s0,32(sp)
    80002a32:	64e2                	ld	s1,24(sp)
    80002a34:	6942                	ld	s2,16(sp)
    80002a36:	69a2                	ld	s3,8(sp)
    80002a38:	6145                	addi	sp,sp,48
    80002a3a:	8082                	ret

0000000080002a3c <ialloc>:
{
    80002a3c:	715d                	addi	sp,sp,-80
    80002a3e:	e486                	sd	ra,72(sp)
    80002a40:	e0a2                	sd	s0,64(sp)
    80002a42:	fc26                	sd	s1,56(sp)
    80002a44:	f84a                	sd	s2,48(sp)
    80002a46:	f44e                	sd	s3,40(sp)
    80002a48:	f052                	sd	s4,32(sp)
    80002a4a:	ec56                	sd	s5,24(sp)
    80002a4c:	e85a                	sd	s6,16(sp)
    80002a4e:	e45e                	sd	s7,8(sp)
    80002a50:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a52:	00015717          	auipc	a4,0x15
    80002a56:	b1272703          	lw	a4,-1262(a4) # 80017564 <sb+0xc>
    80002a5a:	4785                	li	a5,1
    80002a5c:	04e7fa63          	bgeu	a5,a4,80002ab0 <ialloc+0x74>
    80002a60:	8aaa                	mv	s5,a0
    80002a62:	8bae                	mv	s7,a1
    80002a64:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a66:	00015a17          	auipc	s4,0x15
    80002a6a:	af2a0a13          	addi	s4,s4,-1294 # 80017558 <sb>
    80002a6e:	00048b1b          	sext.w	s6,s1
    80002a72:	0044d593          	srli	a1,s1,0x4
    80002a76:	018a2783          	lw	a5,24(s4)
    80002a7a:	9dbd                	addw	a1,a1,a5
    80002a7c:	8556                	mv	a0,s5
    80002a7e:	00000097          	auipc	ra,0x0
    80002a82:	954080e7          	jalr	-1708(ra) # 800023d2 <bread>
    80002a86:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a88:	05850993          	addi	s3,a0,88
    80002a8c:	00f4f793          	andi	a5,s1,15
    80002a90:	079a                	slli	a5,a5,0x6
    80002a92:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a94:	00099783          	lh	a5,0(s3)
    80002a98:	c785                	beqz	a5,80002ac0 <ialloc+0x84>
    brelse(bp);
    80002a9a:	00000097          	auipc	ra,0x0
    80002a9e:	a68080e7          	jalr	-1432(ra) # 80002502 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002aa2:	0485                	addi	s1,s1,1
    80002aa4:	00ca2703          	lw	a4,12(s4)
    80002aa8:	0004879b          	sext.w	a5,s1
    80002aac:	fce7e1e3          	bltu	a5,a4,80002a6e <ialloc+0x32>
  panic("ialloc: no inodes");
    80002ab0:	00006517          	auipc	a0,0x6
    80002ab4:	c1850513          	addi	a0,a0,-1000 # 800086c8 <syscalls+0x178>
    80002ab8:	00003097          	auipc	ra,0x3
    80002abc:	1d0080e7          	jalr	464(ra) # 80005c88 <panic>
      memset(dip, 0, sizeof(*dip));
    80002ac0:	04000613          	li	a2,64
    80002ac4:	4581                	li	a1,0
    80002ac6:	854e                	mv	a0,s3
    80002ac8:	ffffd097          	auipc	ra,0xffffd
    80002acc:	6d6080e7          	jalr	1750(ra) # 8000019e <memset>
      dip->type = type;
    80002ad0:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ad4:	854a                	mv	a0,s2
    80002ad6:	00001097          	auipc	ra,0x1
    80002ada:	ca8080e7          	jalr	-856(ra) # 8000377e <log_write>
      brelse(bp);
    80002ade:	854a                	mv	a0,s2
    80002ae0:	00000097          	auipc	ra,0x0
    80002ae4:	a22080e7          	jalr	-1502(ra) # 80002502 <brelse>
      return iget(dev, inum);
    80002ae8:	85da                	mv	a1,s6
    80002aea:	8556                	mv	a0,s5
    80002aec:	00000097          	auipc	ra,0x0
    80002af0:	db4080e7          	jalr	-588(ra) # 800028a0 <iget>
}
    80002af4:	60a6                	ld	ra,72(sp)
    80002af6:	6406                	ld	s0,64(sp)
    80002af8:	74e2                	ld	s1,56(sp)
    80002afa:	7942                	ld	s2,48(sp)
    80002afc:	79a2                	ld	s3,40(sp)
    80002afe:	7a02                	ld	s4,32(sp)
    80002b00:	6ae2                	ld	s5,24(sp)
    80002b02:	6b42                	ld	s6,16(sp)
    80002b04:	6ba2                	ld	s7,8(sp)
    80002b06:	6161                	addi	sp,sp,80
    80002b08:	8082                	ret

0000000080002b0a <iupdate>:
{
    80002b0a:	1101                	addi	sp,sp,-32
    80002b0c:	ec06                	sd	ra,24(sp)
    80002b0e:	e822                	sd	s0,16(sp)
    80002b10:	e426                	sd	s1,8(sp)
    80002b12:	e04a                	sd	s2,0(sp)
    80002b14:	1000                	addi	s0,sp,32
    80002b16:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b18:	415c                	lw	a5,4(a0)
    80002b1a:	0047d79b          	srliw	a5,a5,0x4
    80002b1e:	00015597          	auipc	a1,0x15
    80002b22:	a525a583          	lw	a1,-1454(a1) # 80017570 <sb+0x18>
    80002b26:	9dbd                	addw	a1,a1,a5
    80002b28:	4108                	lw	a0,0(a0)
    80002b2a:	00000097          	auipc	ra,0x0
    80002b2e:	8a8080e7          	jalr	-1880(ra) # 800023d2 <bread>
    80002b32:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b34:	05850793          	addi	a5,a0,88
    80002b38:	40c8                	lw	a0,4(s1)
    80002b3a:	893d                	andi	a0,a0,15
    80002b3c:	051a                	slli	a0,a0,0x6
    80002b3e:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b40:	04449703          	lh	a4,68(s1)
    80002b44:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b48:	04649703          	lh	a4,70(s1)
    80002b4c:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b50:	04849703          	lh	a4,72(s1)
    80002b54:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b58:	04a49703          	lh	a4,74(s1)
    80002b5c:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b60:	44f8                	lw	a4,76(s1)
    80002b62:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b64:	03400613          	li	a2,52
    80002b68:	05048593          	addi	a1,s1,80
    80002b6c:	0531                	addi	a0,a0,12
    80002b6e:	ffffd097          	auipc	ra,0xffffd
    80002b72:	690080e7          	jalr	1680(ra) # 800001fe <memmove>
  log_write(bp);
    80002b76:	854a                	mv	a0,s2
    80002b78:	00001097          	auipc	ra,0x1
    80002b7c:	c06080e7          	jalr	-1018(ra) # 8000377e <log_write>
  brelse(bp);
    80002b80:	854a                	mv	a0,s2
    80002b82:	00000097          	auipc	ra,0x0
    80002b86:	980080e7          	jalr	-1664(ra) # 80002502 <brelse>
}
    80002b8a:	60e2                	ld	ra,24(sp)
    80002b8c:	6442                	ld	s0,16(sp)
    80002b8e:	64a2                	ld	s1,8(sp)
    80002b90:	6902                	ld	s2,0(sp)
    80002b92:	6105                	addi	sp,sp,32
    80002b94:	8082                	ret

0000000080002b96 <idup>:
{
    80002b96:	1101                	addi	sp,sp,-32
    80002b98:	ec06                	sd	ra,24(sp)
    80002b9a:	e822                	sd	s0,16(sp)
    80002b9c:	e426                	sd	s1,8(sp)
    80002b9e:	1000                	addi	s0,sp,32
    80002ba0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ba2:	00015517          	auipc	a0,0x15
    80002ba6:	9d650513          	addi	a0,a0,-1578 # 80017578 <itable>
    80002baa:	00003097          	auipc	ra,0x3
    80002bae:	628080e7          	jalr	1576(ra) # 800061d2 <acquire>
  ip->ref++;
    80002bb2:	449c                	lw	a5,8(s1)
    80002bb4:	2785                	addiw	a5,a5,1
    80002bb6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bb8:	00015517          	auipc	a0,0x15
    80002bbc:	9c050513          	addi	a0,a0,-1600 # 80017578 <itable>
    80002bc0:	00003097          	auipc	ra,0x3
    80002bc4:	6c6080e7          	jalr	1734(ra) # 80006286 <release>
}
    80002bc8:	8526                	mv	a0,s1
    80002bca:	60e2                	ld	ra,24(sp)
    80002bcc:	6442                	ld	s0,16(sp)
    80002bce:	64a2                	ld	s1,8(sp)
    80002bd0:	6105                	addi	sp,sp,32
    80002bd2:	8082                	ret

0000000080002bd4 <ilock>:
{
    80002bd4:	1101                	addi	sp,sp,-32
    80002bd6:	ec06                	sd	ra,24(sp)
    80002bd8:	e822                	sd	s0,16(sp)
    80002bda:	e426                	sd	s1,8(sp)
    80002bdc:	e04a                	sd	s2,0(sp)
    80002bde:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002be0:	c115                	beqz	a0,80002c04 <ilock+0x30>
    80002be2:	84aa                	mv	s1,a0
    80002be4:	451c                	lw	a5,8(a0)
    80002be6:	00f05f63          	blez	a5,80002c04 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bea:	0541                	addi	a0,a0,16
    80002bec:	00001097          	auipc	ra,0x1
    80002bf0:	cb2080e7          	jalr	-846(ra) # 8000389e <acquiresleep>
  if(ip->valid == 0){
    80002bf4:	40bc                	lw	a5,64(s1)
    80002bf6:	cf99                	beqz	a5,80002c14 <ilock+0x40>
}
    80002bf8:	60e2                	ld	ra,24(sp)
    80002bfa:	6442                	ld	s0,16(sp)
    80002bfc:	64a2                	ld	s1,8(sp)
    80002bfe:	6902                	ld	s2,0(sp)
    80002c00:	6105                	addi	sp,sp,32
    80002c02:	8082                	ret
    panic("ilock");
    80002c04:	00006517          	auipc	a0,0x6
    80002c08:	adc50513          	addi	a0,a0,-1316 # 800086e0 <syscalls+0x190>
    80002c0c:	00003097          	auipc	ra,0x3
    80002c10:	07c080e7          	jalr	124(ra) # 80005c88 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c14:	40dc                	lw	a5,4(s1)
    80002c16:	0047d79b          	srliw	a5,a5,0x4
    80002c1a:	00015597          	auipc	a1,0x15
    80002c1e:	9565a583          	lw	a1,-1706(a1) # 80017570 <sb+0x18>
    80002c22:	9dbd                	addw	a1,a1,a5
    80002c24:	4088                	lw	a0,0(s1)
    80002c26:	fffff097          	auipc	ra,0xfffff
    80002c2a:	7ac080e7          	jalr	1964(ra) # 800023d2 <bread>
    80002c2e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c30:	05850593          	addi	a1,a0,88
    80002c34:	40dc                	lw	a5,4(s1)
    80002c36:	8bbd                	andi	a5,a5,15
    80002c38:	079a                	slli	a5,a5,0x6
    80002c3a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c3c:	00059783          	lh	a5,0(a1)
    80002c40:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c44:	00259783          	lh	a5,2(a1)
    80002c48:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c4c:	00459783          	lh	a5,4(a1)
    80002c50:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c54:	00659783          	lh	a5,6(a1)
    80002c58:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c5c:	459c                	lw	a5,8(a1)
    80002c5e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c60:	03400613          	li	a2,52
    80002c64:	05b1                	addi	a1,a1,12
    80002c66:	05048513          	addi	a0,s1,80
    80002c6a:	ffffd097          	auipc	ra,0xffffd
    80002c6e:	594080e7          	jalr	1428(ra) # 800001fe <memmove>
    brelse(bp);
    80002c72:	854a                	mv	a0,s2
    80002c74:	00000097          	auipc	ra,0x0
    80002c78:	88e080e7          	jalr	-1906(ra) # 80002502 <brelse>
    ip->valid = 1;
    80002c7c:	4785                	li	a5,1
    80002c7e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c80:	04449783          	lh	a5,68(s1)
    80002c84:	fbb5                	bnez	a5,80002bf8 <ilock+0x24>
      panic("ilock: no type");
    80002c86:	00006517          	auipc	a0,0x6
    80002c8a:	a6250513          	addi	a0,a0,-1438 # 800086e8 <syscalls+0x198>
    80002c8e:	00003097          	auipc	ra,0x3
    80002c92:	ffa080e7          	jalr	-6(ra) # 80005c88 <panic>

0000000080002c96 <iunlock>:
{
    80002c96:	1101                	addi	sp,sp,-32
    80002c98:	ec06                	sd	ra,24(sp)
    80002c9a:	e822                	sd	s0,16(sp)
    80002c9c:	e426                	sd	s1,8(sp)
    80002c9e:	e04a                	sd	s2,0(sp)
    80002ca0:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002ca2:	c905                	beqz	a0,80002cd2 <iunlock+0x3c>
    80002ca4:	84aa                	mv	s1,a0
    80002ca6:	01050913          	addi	s2,a0,16
    80002caa:	854a                	mv	a0,s2
    80002cac:	00001097          	auipc	ra,0x1
    80002cb0:	c8c080e7          	jalr	-884(ra) # 80003938 <holdingsleep>
    80002cb4:	cd19                	beqz	a0,80002cd2 <iunlock+0x3c>
    80002cb6:	449c                	lw	a5,8(s1)
    80002cb8:	00f05d63          	blez	a5,80002cd2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cbc:	854a                	mv	a0,s2
    80002cbe:	00001097          	auipc	ra,0x1
    80002cc2:	c36080e7          	jalr	-970(ra) # 800038f4 <releasesleep>
}
    80002cc6:	60e2                	ld	ra,24(sp)
    80002cc8:	6442                	ld	s0,16(sp)
    80002cca:	64a2                	ld	s1,8(sp)
    80002ccc:	6902                	ld	s2,0(sp)
    80002cce:	6105                	addi	sp,sp,32
    80002cd0:	8082                	ret
    panic("iunlock");
    80002cd2:	00006517          	auipc	a0,0x6
    80002cd6:	a2650513          	addi	a0,a0,-1498 # 800086f8 <syscalls+0x1a8>
    80002cda:	00003097          	auipc	ra,0x3
    80002cde:	fae080e7          	jalr	-82(ra) # 80005c88 <panic>

0000000080002ce2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002ce2:	7179                	addi	sp,sp,-48
    80002ce4:	f406                	sd	ra,40(sp)
    80002ce6:	f022                	sd	s0,32(sp)
    80002ce8:	ec26                	sd	s1,24(sp)
    80002cea:	e84a                	sd	s2,16(sp)
    80002cec:	e44e                	sd	s3,8(sp)
    80002cee:	e052                	sd	s4,0(sp)
    80002cf0:	1800                	addi	s0,sp,48
    80002cf2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cf4:	05050493          	addi	s1,a0,80
    80002cf8:	08050913          	addi	s2,a0,128
    80002cfc:	a021                	j	80002d04 <itrunc+0x22>
    80002cfe:	0491                	addi	s1,s1,4
    80002d00:	01248d63          	beq	s1,s2,80002d1a <itrunc+0x38>
    if(ip->addrs[i]){
    80002d04:	408c                	lw	a1,0(s1)
    80002d06:	dde5                	beqz	a1,80002cfe <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d08:	0009a503          	lw	a0,0(s3)
    80002d0c:	00000097          	auipc	ra,0x0
    80002d10:	90c080e7          	jalr	-1780(ra) # 80002618 <bfree>
      ip->addrs[i] = 0;
    80002d14:	0004a023          	sw	zero,0(s1)
    80002d18:	b7dd                	j	80002cfe <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d1a:	0809a583          	lw	a1,128(s3)
    80002d1e:	e185                	bnez	a1,80002d3e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d20:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d24:	854e                	mv	a0,s3
    80002d26:	00000097          	auipc	ra,0x0
    80002d2a:	de4080e7          	jalr	-540(ra) # 80002b0a <iupdate>
}
    80002d2e:	70a2                	ld	ra,40(sp)
    80002d30:	7402                	ld	s0,32(sp)
    80002d32:	64e2                	ld	s1,24(sp)
    80002d34:	6942                	ld	s2,16(sp)
    80002d36:	69a2                	ld	s3,8(sp)
    80002d38:	6a02                	ld	s4,0(sp)
    80002d3a:	6145                	addi	sp,sp,48
    80002d3c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d3e:	0009a503          	lw	a0,0(s3)
    80002d42:	fffff097          	auipc	ra,0xfffff
    80002d46:	690080e7          	jalr	1680(ra) # 800023d2 <bread>
    80002d4a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d4c:	05850493          	addi	s1,a0,88
    80002d50:	45850913          	addi	s2,a0,1112
    80002d54:	a811                	j	80002d68 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d56:	0009a503          	lw	a0,0(s3)
    80002d5a:	00000097          	auipc	ra,0x0
    80002d5e:	8be080e7          	jalr	-1858(ra) # 80002618 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d62:	0491                	addi	s1,s1,4
    80002d64:	01248563          	beq	s1,s2,80002d6e <itrunc+0x8c>
      if(a[j])
    80002d68:	408c                	lw	a1,0(s1)
    80002d6a:	dde5                	beqz	a1,80002d62 <itrunc+0x80>
    80002d6c:	b7ed                	j	80002d56 <itrunc+0x74>
    brelse(bp);
    80002d6e:	8552                	mv	a0,s4
    80002d70:	fffff097          	auipc	ra,0xfffff
    80002d74:	792080e7          	jalr	1938(ra) # 80002502 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d78:	0809a583          	lw	a1,128(s3)
    80002d7c:	0009a503          	lw	a0,0(s3)
    80002d80:	00000097          	auipc	ra,0x0
    80002d84:	898080e7          	jalr	-1896(ra) # 80002618 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d88:	0809a023          	sw	zero,128(s3)
    80002d8c:	bf51                	j	80002d20 <itrunc+0x3e>

0000000080002d8e <iput>:
{
    80002d8e:	1101                	addi	sp,sp,-32
    80002d90:	ec06                	sd	ra,24(sp)
    80002d92:	e822                	sd	s0,16(sp)
    80002d94:	e426                	sd	s1,8(sp)
    80002d96:	e04a                	sd	s2,0(sp)
    80002d98:	1000                	addi	s0,sp,32
    80002d9a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d9c:	00014517          	auipc	a0,0x14
    80002da0:	7dc50513          	addi	a0,a0,2012 # 80017578 <itable>
    80002da4:	00003097          	auipc	ra,0x3
    80002da8:	42e080e7          	jalr	1070(ra) # 800061d2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dac:	4498                	lw	a4,8(s1)
    80002dae:	4785                	li	a5,1
    80002db0:	02f70363          	beq	a4,a5,80002dd6 <iput+0x48>
  ip->ref--;
    80002db4:	449c                	lw	a5,8(s1)
    80002db6:	37fd                	addiw	a5,a5,-1
    80002db8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dba:	00014517          	auipc	a0,0x14
    80002dbe:	7be50513          	addi	a0,a0,1982 # 80017578 <itable>
    80002dc2:	00003097          	auipc	ra,0x3
    80002dc6:	4c4080e7          	jalr	1220(ra) # 80006286 <release>
}
    80002dca:	60e2                	ld	ra,24(sp)
    80002dcc:	6442                	ld	s0,16(sp)
    80002dce:	64a2                	ld	s1,8(sp)
    80002dd0:	6902                	ld	s2,0(sp)
    80002dd2:	6105                	addi	sp,sp,32
    80002dd4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dd6:	40bc                	lw	a5,64(s1)
    80002dd8:	dff1                	beqz	a5,80002db4 <iput+0x26>
    80002dda:	04a49783          	lh	a5,74(s1)
    80002dde:	fbf9                	bnez	a5,80002db4 <iput+0x26>
    acquiresleep(&ip->lock);
    80002de0:	01048913          	addi	s2,s1,16
    80002de4:	854a                	mv	a0,s2
    80002de6:	00001097          	auipc	ra,0x1
    80002dea:	ab8080e7          	jalr	-1352(ra) # 8000389e <acquiresleep>
    release(&itable.lock);
    80002dee:	00014517          	auipc	a0,0x14
    80002df2:	78a50513          	addi	a0,a0,1930 # 80017578 <itable>
    80002df6:	00003097          	auipc	ra,0x3
    80002dfa:	490080e7          	jalr	1168(ra) # 80006286 <release>
    itrunc(ip);
    80002dfe:	8526                	mv	a0,s1
    80002e00:	00000097          	auipc	ra,0x0
    80002e04:	ee2080e7          	jalr	-286(ra) # 80002ce2 <itrunc>
    ip->type = 0;
    80002e08:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e0c:	8526                	mv	a0,s1
    80002e0e:	00000097          	auipc	ra,0x0
    80002e12:	cfc080e7          	jalr	-772(ra) # 80002b0a <iupdate>
    ip->valid = 0;
    80002e16:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e1a:	854a                	mv	a0,s2
    80002e1c:	00001097          	auipc	ra,0x1
    80002e20:	ad8080e7          	jalr	-1320(ra) # 800038f4 <releasesleep>
    acquire(&itable.lock);
    80002e24:	00014517          	auipc	a0,0x14
    80002e28:	75450513          	addi	a0,a0,1876 # 80017578 <itable>
    80002e2c:	00003097          	auipc	ra,0x3
    80002e30:	3a6080e7          	jalr	934(ra) # 800061d2 <acquire>
    80002e34:	b741                	j	80002db4 <iput+0x26>

0000000080002e36 <iunlockput>:
{
    80002e36:	1101                	addi	sp,sp,-32
    80002e38:	ec06                	sd	ra,24(sp)
    80002e3a:	e822                	sd	s0,16(sp)
    80002e3c:	e426                	sd	s1,8(sp)
    80002e3e:	1000                	addi	s0,sp,32
    80002e40:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e42:	00000097          	auipc	ra,0x0
    80002e46:	e54080e7          	jalr	-428(ra) # 80002c96 <iunlock>
  iput(ip);
    80002e4a:	8526                	mv	a0,s1
    80002e4c:	00000097          	auipc	ra,0x0
    80002e50:	f42080e7          	jalr	-190(ra) # 80002d8e <iput>
}
    80002e54:	60e2                	ld	ra,24(sp)
    80002e56:	6442                	ld	s0,16(sp)
    80002e58:	64a2                	ld	s1,8(sp)
    80002e5a:	6105                	addi	sp,sp,32
    80002e5c:	8082                	ret

0000000080002e5e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e5e:	1141                	addi	sp,sp,-16
    80002e60:	e422                	sd	s0,8(sp)
    80002e62:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e64:	411c                	lw	a5,0(a0)
    80002e66:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e68:	415c                	lw	a5,4(a0)
    80002e6a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e6c:	04451783          	lh	a5,68(a0)
    80002e70:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e74:	04a51783          	lh	a5,74(a0)
    80002e78:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e7c:	04c56783          	lwu	a5,76(a0)
    80002e80:	e99c                	sd	a5,16(a1)
}
    80002e82:	6422                	ld	s0,8(sp)
    80002e84:	0141                	addi	sp,sp,16
    80002e86:	8082                	ret

0000000080002e88 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e88:	457c                	lw	a5,76(a0)
    80002e8a:	0ed7e963          	bltu	a5,a3,80002f7c <readi+0xf4>
{
    80002e8e:	7159                	addi	sp,sp,-112
    80002e90:	f486                	sd	ra,104(sp)
    80002e92:	f0a2                	sd	s0,96(sp)
    80002e94:	eca6                	sd	s1,88(sp)
    80002e96:	e8ca                	sd	s2,80(sp)
    80002e98:	e4ce                	sd	s3,72(sp)
    80002e9a:	e0d2                	sd	s4,64(sp)
    80002e9c:	fc56                	sd	s5,56(sp)
    80002e9e:	f85a                	sd	s6,48(sp)
    80002ea0:	f45e                	sd	s7,40(sp)
    80002ea2:	f062                	sd	s8,32(sp)
    80002ea4:	ec66                	sd	s9,24(sp)
    80002ea6:	e86a                	sd	s10,16(sp)
    80002ea8:	e46e                	sd	s11,8(sp)
    80002eaa:	1880                	addi	s0,sp,112
    80002eac:	8baa                	mv	s7,a0
    80002eae:	8c2e                	mv	s8,a1
    80002eb0:	8ab2                	mv	s5,a2
    80002eb2:	84b6                	mv	s1,a3
    80002eb4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002eb6:	9f35                	addw	a4,a4,a3
    return 0;
    80002eb8:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002eba:	0ad76063          	bltu	a4,a3,80002f5a <readi+0xd2>
  if(off + n > ip->size)
    80002ebe:	00e7f463          	bgeu	a5,a4,80002ec6 <readi+0x3e>
    n = ip->size - off;
    80002ec2:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ec6:	0a0b0963          	beqz	s6,80002f78 <readi+0xf0>
    80002eca:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ecc:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ed0:	5cfd                	li	s9,-1
    80002ed2:	a82d                	j	80002f0c <readi+0x84>
    80002ed4:	020a1d93          	slli	s11,s4,0x20
    80002ed8:	020ddd93          	srli	s11,s11,0x20
    80002edc:	05890613          	addi	a2,s2,88
    80002ee0:	86ee                	mv	a3,s11
    80002ee2:	963a                	add	a2,a2,a4
    80002ee4:	85d6                	mv	a1,s5
    80002ee6:	8562                	mv	a0,s8
    80002ee8:	fffff097          	auipc	ra,0xfffff
    80002eec:	a24080e7          	jalr	-1500(ra) # 8000190c <either_copyout>
    80002ef0:	05950d63          	beq	a0,s9,80002f4a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ef4:	854a                	mv	a0,s2
    80002ef6:	fffff097          	auipc	ra,0xfffff
    80002efa:	60c080e7          	jalr	1548(ra) # 80002502 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002efe:	013a09bb          	addw	s3,s4,s3
    80002f02:	009a04bb          	addw	s1,s4,s1
    80002f06:	9aee                	add	s5,s5,s11
    80002f08:	0569f763          	bgeu	s3,s6,80002f56 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f0c:	000ba903          	lw	s2,0(s7)
    80002f10:	00a4d59b          	srliw	a1,s1,0xa
    80002f14:	855e                	mv	a0,s7
    80002f16:	00000097          	auipc	ra,0x0
    80002f1a:	8b0080e7          	jalr	-1872(ra) # 800027c6 <bmap>
    80002f1e:	0005059b          	sext.w	a1,a0
    80002f22:	854a                	mv	a0,s2
    80002f24:	fffff097          	auipc	ra,0xfffff
    80002f28:	4ae080e7          	jalr	1198(ra) # 800023d2 <bread>
    80002f2c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f2e:	3ff4f713          	andi	a4,s1,1023
    80002f32:	40ed07bb          	subw	a5,s10,a4
    80002f36:	413b06bb          	subw	a3,s6,s3
    80002f3a:	8a3e                	mv	s4,a5
    80002f3c:	2781                	sext.w	a5,a5
    80002f3e:	0006861b          	sext.w	a2,a3
    80002f42:	f8f679e3          	bgeu	a2,a5,80002ed4 <readi+0x4c>
    80002f46:	8a36                	mv	s4,a3
    80002f48:	b771                	j	80002ed4 <readi+0x4c>
      brelse(bp);
    80002f4a:	854a                	mv	a0,s2
    80002f4c:	fffff097          	auipc	ra,0xfffff
    80002f50:	5b6080e7          	jalr	1462(ra) # 80002502 <brelse>
      tot = -1;
    80002f54:	59fd                	li	s3,-1
  }
  return tot;
    80002f56:	0009851b          	sext.w	a0,s3
}
    80002f5a:	70a6                	ld	ra,104(sp)
    80002f5c:	7406                	ld	s0,96(sp)
    80002f5e:	64e6                	ld	s1,88(sp)
    80002f60:	6946                	ld	s2,80(sp)
    80002f62:	69a6                	ld	s3,72(sp)
    80002f64:	6a06                	ld	s4,64(sp)
    80002f66:	7ae2                	ld	s5,56(sp)
    80002f68:	7b42                	ld	s6,48(sp)
    80002f6a:	7ba2                	ld	s7,40(sp)
    80002f6c:	7c02                	ld	s8,32(sp)
    80002f6e:	6ce2                	ld	s9,24(sp)
    80002f70:	6d42                	ld	s10,16(sp)
    80002f72:	6da2                	ld	s11,8(sp)
    80002f74:	6165                	addi	sp,sp,112
    80002f76:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f78:	89da                	mv	s3,s6
    80002f7a:	bff1                	j	80002f56 <readi+0xce>
    return 0;
    80002f7c:	4501                	li	a0,0
}
    80002f7e:	8082                	ret

0000000080002f80 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f80:	457c                	lw	a5,76(a0)
    80002f82:	10d7e863          	bltu	a5,a3,80003092 <writei+0x112>
{
    80002f86:	7159                	addi	sp,sp,-112
    80002f88:	f486                	sd	ra,104(sp)
    80002f8a:	f0a2                	sd	s0,96(sp)
    80002f8c:	eca6                	sd	s1,88(sp)
    80002f8e:	e8ca                	sd	s2,80(sp)
    80002f90:	e4ce                	sd	s3,72(sp)
    80002f92:	e0d2                	sd	s4,64(sp)
    80002f94:	fc56                	sd	s5,56(sp)
    80002f96:	f85a                	sd	s6,48(sp)
    80002f98:	f45e                	sd	s7,40(sp)
    80002f9a:	f062                	sd	s8,32(sp)
    80002f9c:	ec66                	sd	s9,24(sp)
    80002f9e:	e86a                	sd	s10,16(sp)
    80002fa0:	e46e                	sd	s11,8(sp)
    80002fa2:	1880                	addi	s0,sp,112
    80002fa4:	8b2a                	mv	s6,a0
    80002fa6:	8c2e                	mv	s8,a1
    80002fa8:	8ab2                	mv	s5,a2
    80002faa:	8936                	mv	s2,a3
    80002fac:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002fae:	00e687bb          	addw	a5,a3,a4
    80002fb2:	0ed7e263          	bltu	a5,a3,80003096 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fb6:	00043737          	lui	a4,0x43
    80002fba:	0ef76063          	bltu	a4,a5,8000309a <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fbe:	0c0b8863          	beqz	s7,8000308e <writei+0x10e>
    80002fc2:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fc4:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fc8:	5cfd                	li	s9,-1
    80002fca:	a091                	j	8000300e <writei+0x8e>
    80002fcc:	02099d93          	slli	s11,s3,0x20
    80002fd0:	020ddd93          	srli	s11,s11,0x20
    80002fd4:	05848513          	addi	a0,s1,88
    80002fd8:	86ee                	mv	a3,s11
    80002fda:	8656                	mv	a2,s5
    80002fdc:	85e2                	mv	a1,s8
    80002fde:	953a                	add	a0,a0,a4
    80002fe0:	fffff097          	auipc	ra,0xfffff
    80002fe4:	982080e7          	jalr	-1662(ra) # 80001962 <either_copyin>
    80002fe8:	07950263          	beq	a0,s9,8000304c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fec:	8526                	mv	a0,s1
    80002fee:	00000097          	auipc	ra,0x0
    80002ff2:	790080e7          	jalr	1936(ra) # 8000377e <log_write>
    brelse(bp);
    80002ff6:	8526                	mv	a0,s1
    80002ff8:	fffff097          	auipc	ra,0xfffff
    80002ffc:	50a080e7          	jalr	1290(ra) # 80002502 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003000:	01498a3b          	addw	s4,s3,s4
    80003004:	0129893b          	addw	s2,s3,s2
    80003008:	9aee                	add	s5,s5,s11
    8000300a:	057a7663          	bgeu	s4,s7,80003056 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000300e:	000b2483          	lw	s1,0(s6)
    80003012:	00a9559b          	srliw	a1,s2,0xa
    80003016:	855a                	mv	a0,s6
    80003018:	fffff097          	auipc	ra,0xfffff
    8000301c:	7ae080e7          	jalr	1966(ra) # 800027c6 <bmap>
    80003020:	0005059b          	sext.w	a1,a0
    80003024:	8526                	mv	a0,s1
    80003026:	fffff097          	auipc	ra,0xfffff
    8000302a:	3ac080e7          	jalr	940(ra) # 800023d2 <bread>
    8000302e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003030:	3ff97713          	andi	a4,s2,1023
    80003034:	40ed07bb          	subw	a5,s10,a4
    80003038:	414b86bb          	subw	a3,s7,s4
    8000303c:	89be                	mv	s3,a5
    8000303e:	2781                	sext.w	a5,a5
    80003040:	0006861b          	sext.w	a2,a3
    80003044:	f8f674e3          	bgeu	a2,a5,80002fcc <writei+0x4c>
    80003048:	89b6                	mv	s3,a3
    8000304a:	b749                	j	80002fcc <writei+0x4c>
      brelse(bp);
    8000304c:	8526                	mv	a0,s1
    8000304e:	fffff097          	auipc	ra,0xfffff
    80003052:	4b4080e7          	jalr	1204(ra) # 80002502 <brelse>
  }

  if(off > ip->size)
    80003056:	04cb2783          	lw	a5,76(s6)
    8000305a:	0127f463          	bgeu	a5,s2,80003062 <writei+0xe2>
    ip->size = off;
    8000305e:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003062:	855a                	mv	a0,s6
    80003064:	00000097          	auipc	ra,0x0
    80003068:	aa6080e7          	jalr	-1370(ra) # 80002b0a <iupdate>

  return tot;
    8000306c:	000a051b          	sext.w	a0,s4
}
    80003070:	70a6                	ld	ra,104(sp)
    80003072:	7406                	ld	s0,96(sp)
    80003074:	64e6                	ld	s1,88(sp)
    80003076:	6946                	ld	s2,80(sp)
    80003078:	69a6                	ld	s3,72(sp)
    8000307a:	6a06                	ld	s4,64(sp)
    8000307c:	7ae2                	ld	s5,56(sp)
    8000307e:	7b42                	ld	s6,48(sp)
    80003080:	7ba2                	ld	s7,40(sp)
    80003082:	7c02                	ld	s8,32(sp)
    80003084:	6ce2                	ld	s9,24(sp)
    80003086:	6d42                	ld	s10,16(sp)
    80003088:	6da2                	ld	s11,8(sp)
    8000308a:	6165                	addi	sp,sp,112
    8000308c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000308e:	8a5e                	mv	s4,s7
    80003090:	bfc9                	j	80003062 <writei+0xe2>
    return -1;
    80003092:	557d                	li	a0,-1
}
    80003094:	8082                	ret
    return -1;
    80003096:	557d                	li	a0,-1
    80003098:	bfe1                	j	80003070 <writei+0xf0>
    return -1;
    8000309a:	557d                	li	a0,-1
    8000309c:	bfd1                	j	80003070 <writei+0xf0>

000000008000309e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000309e:	1141                	addi	sp,sp,-16
    800030a0:	e406                	sd	ra,8(sp)
    800030a2:	e022                	sd	s0,0(sp)
    800030a4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030a6:	4639                	li	a2,14
    800030a8:	ffffd097          	auipc	ra,0xffffd
    800030ac:	1ce080e7          	jalr	462(ra) # 80000276 <strncmp>
}
    800030b0:	60a2                	ld	ra,8(sp)
    800030b2:	6402                	ld	s0,0(sp)
    800030b4:	0141                	addi	sp,sp,16
    800030b6:	8082                	ret

00000000800030b8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030b8:	7139                	addi	sp,sp,-64
    800030ba:	fc06                	sd	ra,56(sp)
    800030bc:	f822                	sd	s0,48(sp)
    800030be:	f426                	sd	s1,40(sp)
    800030c0:	f04a                	sd	s2,32(sp)
    800030c2:	ec4e                	sd	s3,24(sp)
    800030c4:	e852                	sd	s4,16(sp)
    800030c6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030c8:	04451703          	lh	a4,68(a0)
    800030cc:	4785                	li	a5,1
    800030ce:	00f71a63          	bne	a4,a5,800030e2 <dirlookup+0x2a>
    800030d2:	892a                	mv	s2,a0
    800030d4:	89ae                	mv	s3,a1
    800030d6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030d8:	457c                	lw	a5,76(a0)
    800030da:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030dc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030de:	e79d                	bnez	a5,8000310c <dirlookup+0x54>
    800030e0:	a8a5                	j	80003158 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030e2:	00005517          	auipc	a0,0x5
    800030e6:	61e50513          	addi	a0,a0,1566 # 80008700 <syscalls+0x1b0>
    800030ea:	00003097          	auipc	ra,0x3
    800030ee:	b9e080e7          	jalr	-1122(ra) # 80005c88 <panic>
      panic("dirlookup read");
    800030f2:	00005517          	auipc	a0,0x5
    800030f6:	62650513          	addi	a0,a0,1574 # 80008718 <syscalls+0x1c8>
    800030fa:	00003097          	auipc	ra,0x3
    800030fe:	b8e080e7          	jalr	-1138(ra) # 80005c88 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003102:	24c1                	addiw	s1,s1,16
    80003104:	04c92783          	lw	a5,76(s2)
    80003108:	04f4f763          	bgeu	s1,a5,80003156 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000310c:	4741                	li	a4,16
    8000310e:	86a6                	mv	a3,s1
    80003110:	fc040613          	addi	a2,s0,-64
    80003114:	4581                	li	a1,0
    80003116:	854a                	mv	a0,s2
    80003118:	00000097          	auipc	ra,0x0
    8000311c:	d70080e7          	jalr	-656(ra) # 80002e88 <readi>
    80003120:	47c1                	li	a5,16
    80003122:	fcf518e3          	bne	a0,a5,800030f2 <dirlookup+0x3a>
    if(de.inum == 0)
    80003126:	fc045783          	lhu	a5,-64(s0)
    8000312a:	dfe1                	beqz	a5,80003102 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000312c:	fc240593          	addi	a1,s0,-62
    80003130:	854e                	mv	a0,s3
    80003132:	00000097          	auipc	ra,0x0
    80003136:	f6c080e7          	jalr	-148(ra) # 8000309e <namecmp>
    8000313a:	f561                	bnez	a0,80003102 <dirlookup+0x4a>
      if(poff)
    8000313c:	000a0463          	beqz	s4,80003144 <dirlookup+0x8c>
        *poff = off;
    80003140:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003144:	fc045583          	lhu	a1,-64(s0)
    80003148:	00092503          	lw	a0,0(s2)
    8000314c:	fffff097          	auipc	ra,0xfffff
    80003150:	754080e7          	jalr	1876(ra) # 800028a0 <iget>
    80003154:	a011                	j	80003158 <dirlookup+0xa0>
  return 0;
    80003156:	4501                	li	a0,0
}
    80003158:	70e2                	ld	ra,56(sp)
    8000315a:	7442                	ld	s0,48(sp)
    8000315c:	74a2                	ld	s1,40(sp)
    8000315e:	7902                	ld	s2,32(sp)
    80003160:	69e2                	ld	s3,24(sp)
    80003162:	6a42                	ld	s4,16(sp)
    80003164:	6121                	addi	sp,sp,64
    80003166:	8082                	ret

0000000080003168 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003168:	711d                	addi	sp,sp,-96
    8000316a:	ec86                	sd	ra,88(sp)
    8000316c:	e8a2                	sd	s0,80(sp)
    8000316e:	e4a6                	sd	s1,72(sp)
    80003170:	e0ca                	sd	s2,64(sp)
    80003172:	fc4e                	sd	s3,56(sp)
    80003174:	f852                	sd	s4,48(sp)
    80003176:	f456                	sd	s5,40(sp)
    80003178:	f05a                	sd	s6,32(sp)
    8000317a:	ec5e                	sd	s7,24(sp)
    8000317c:	e862                	sd	s8,16(sp)
    8000317e:	e466                	sd	s9,8(sp)
    80003180:	1080                	addi	s0,sp,96
    80003182:	84aa                	mv	s1,a0
    80003184:	8b2e                	mv	s6,a1
    80003186:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003188:	00054703          	lbu	a4,0(a0)
    8000318c:	02f00793          	li	a5,47
    80003190:	02f70363          	beq	a4,a5,800031b6 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003194:	ffffe097          	auipc	ra,0xffffe
    80003198:	cda080e7          	jalr	-806(ra) # 80000e6e <myproc>
    8000319c:	15053503          	ld	a0,336(a0)
    800031a0:	00000097          	auipc	ra,0x0
    800031a4:	9f6080e7          	jalr	-1546(ra) # 80002b96 <idup>
    800031a8:	89aa                	mv	s3,a0
  while(*path == '/')
    800031aa:	02f00913          	li	s2,47
  len = path - s;
    800031ae:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800031b0:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031b2:	4c05                	li	s8,1
    800031b4:	a865                	j	8000326c <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800031b6:	4585                	li	a1,1
    800031b8:	4505                	li	a0,1
    800031ba:	fffff097          	auipc	ra,0xfffff
    800031be:	6e6080e7          	jalr	1766(ra) # 800028a0 <iget>
    800031c2:	89aa                	mv	s3,a0
    800031c4:	b7dd                	j	800031aa <namex+0x42>
      iunlockput(ip);
    800031c6:	854e                	mv	a0,s3
    800031c8:	00000097          	auipc	ra,0x0
    800031cc:	c6e080e7          	jalr	-914(ra) # 80002e36 <iunlockput>
      return 0;
    800031d0:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031d2:	854e                	mv	a0,s3
    800031d4:	60e6                	ld	ra,88(sp)
    800031d6:	6446                	ld	s0,80(sp)
    800031d8:	64a6                	ld	s1,72(sp)
    800031da:	6906                	ld	s2,64(sp)
    800031dc:	79e2                	ld	s3,56(sp)
    800031de:	7a42                	ld	s4,48(sp)
    800031e0:	7aa2                	ld	s5,40(sp)
    800031e2:	7b02                	ld	s6,32(sp)
    800031e4:	6be2                	ld	s7,24(sp)
    800031e6:	6c42                	ld	s8,16(sp)
    800031e8:	6ca2                	ld	s9,8(sp)
    800031ea:	6125                	addi	sp,sp,96
    800031ec:	8082                	ret
      iunlock(ip);
    800031ee:	854e                	mv	a0,s3
    800031f0:	00000097          	auipc	ra,0x0
    800031f4:	aa6080e7          	jalr	-1370(ra) # 80002c96 <iunlock>
      return ip;
    800031f8:	bfe9                	j	800031d2 <namex+0x6a>
      iunlockput(ip);
    800031fa:	854e                	mv	a0,s3
    800031fc:	00000097          	auipc	ra,0x0
    80003200:	c3a080e7          	jalr	-966(ra) # 80002e36 <iunlockput>
      return 0;
    80003204:	89d2                	mv	s3,s4
    80003206:	b7f1                	j	800031d2 <namex+0x6a>
  len = path - s;
    80003208:	40b48633          	sub	a2,s1,a1
    8000320c:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003210:	094cd463          	bge	s9,s4,80003298 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003214:	4639                	li	a2,14
    80003216:	8556                	mv	a0,s5
    80003218:	ffffd097          	auipc	ra,0xffffd
    8000321c:	fe6080e7          	jalr	-26(ra) # 800001fe <memmove>
  while(*path == '/')
    80003220:	0004c783          	lbu	a5,0(s1)
    80003224:	01279763          	bne	a5,s2,80003232 <namex+0xca>
    path++;
    80003228:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000322a:	0004c783          	lbu	a5,0(s1)
    8000322e:	ff278de3          	beq	a5,s2,80003228 <namex+0xc0>
    ilock(ip);
    80003232:	854e                	mv	a0,s3
    80003234:	00000097          	auipc	ra,0x0
    80003238:	9a0080e7          	jalr	-1632(ra) # 80002bd4 <ilock>
    if(ip->type != T_DIR){
    8000323c:	04499783          	lh	a5,68(s3)
    80003240:	f98793e3          	bne	a5,s8,800031c6 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003244:	000b0563          	beqz	s6,8000324e <namex+0xe6>
    80003248:	0004c783          	lbu	a5,0(s1)
    8000324c:	d3cd                	beqz	a5,800031ee <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000324e:	865e                	mv	a2,s7
    80003250:	85d6                	mv	a1,s5
    80003252:	854e                	mv	a0,s3
    80003254:	00000097          	auipc	ra,0x0
    80003258:	e64080e7          	jalr	-412(ra) # 800030b8 <dirlookup>
    8000325c:	8a2a                	mv	s4,a0
    8000325e:	dd51                	beqz	a0,800031fa <namex+0x92>
    iunlockput(ip);
    80003260:	854e                	mv	a0,s3
    80003262:	00000097          	auipc	ra,0x0
    80003266:	bd4080e7          	jalr	-1068(ra) # 80002e36 <iunlockput>
    ip = next;
    8000326a:	89d2                	mv	s3,s4
  while(*path == '/')
    8000326c:	0004c783          	lbu	a5,0(s1)
    80003270:	05279763          	bne	a5,s2,800032be <namex+0x156>
    path++;
    80003274:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003276:	0004c783          	lbu	a5,0(s1)
    8000327a:	ff278de3          	beq	a5,s2,80003274 <namex+0x10c>
  if(*path == 0)
    8000327e:	c79d                	beqz	a5,800032ac <namex+0x144>
    path++;
    80003280:	85a6                	mv	a1,s1
  len = path - s;
    80003282:	8a5e                	mv	s4,s7
    80003284:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003286:	01278963          	beq	a5,s2,80003298 <namex+0x130>
    8000328a:	dfbd                	beqz	a5,80003208 <namex+0xa0>
    path++;
    8000328c:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000328e:	0004c783          	lbu	a5,0(s1)
    80003292:	ff279ce3          	bne	a5,s2,8000328a <namex+0x122>
    80003296:	bf8d                	j	80003208 <namex+0xa0>
    memmove(name, s, len);
    80003298:	2601                	sext.w	a2,a2
    8000329a:	8556                	mv	a0,s5
    8000329c:	ffffd097          	auipc	ra,0xffffd
    800032a0:	f62080e7          	jalr	-158(ra) # 800001fe <memmove>
    name[len] = 0;
    800032a4:	9a56                	add	s4,s4,s5
    800032a6:	000a0023          	sb	zero,0(s4)
    800032aa:	bf9d                	j	80003220 <namex+0xb8>
  if(nameiparent){
    800032ac:	f20b03e3          	beqz	s6,800031d2 <namex+0x6a>
    iput(ip);
    800032b0:	854e                	mv	a0,s3
    800032b2:	00000097          	auipc	ra,0x0
    800032b6:	adc080e7          	jalr	-1316(ra) # 80002d8e <iput>
    return 0;
    800032ba:	4981                	li	s3,0
    800032bc:	bf19                	j	800031d2 <namex+0x6a>
  if(*path == 0)
    800032be:	d7fd                	beqz	a5,800032ac <namex+0x144>
  while(*path != '/' && *path != 0)
    800032c0:	0004c783          	lbu	a5,0(s1)
    800032c4:	85a6                	mv	a1,s1
    800032c6:	b7d1                	j	8000328a <namex+0x122>

00000000800032c8 <dirlink>:
{
    800032c8:	7139                	addi	sp,sp,-64
    800032ca:	fc06                	sd	ra,56(sp)
    800032cc:	f822                	sd	s0,48(sp)
    800032ce:	f426                	sd	s1,40(sp)
    800032d0:	f04a                	sd	s2,32(sp)
    800032d2:	ec4e                	sd	s3,24(sp)
    800032d4:	e852                	sd	s4,16(sp)
    800032d6:	0080                	addi	s0,sp,64
    800032d8:	892a                	mv	s2,a0
    800032da:	8a2e                	mv	s4,a1
    800032dc:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032de:	4601                	li	a2,0
    800032e0:	00000097          	auipc	ra,0x0
    800032e4:	dd8080e7          	jalr	-552(ra) # 800030b8 <dirlookup>
    800032e8:	e93d                	bnez	a0,8000335e <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032ea:	04c92483          	lw	s1,76(s2)
    800032ee:	c49d                	beqz	s1,8000331c <dirlink+0x54>
    800032f0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032f2:	4741                	li	a4,16
    800032f4:	86a6                	mv	a3,s1
    800032f6:	fc040613          	addi	a2,s0,-64
    800032fa:	4581                	li	a1,0
    800032fc:	854a                	mv	a0,s2
    800032fe:	00000097          	auipc	ra,0x0
    80003302:	b8a080e7          	jalr	-1142(ra) # 80002e88 <readi>
    80003306:	47c1                	li	a5,16
    80003308:	06f51163          	bne	a0,a5,8000336a <dirlink+0xa2>
    if(de.inum == 0)
    8000330c:	fc045783          	lhu	a5,-64(s0)
    80003310:	c791                	beqz	a5,8000331c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003312:	24c1                	addiw	s1,s1,16
    80003314:	04c92783          	lw	a5,76(s2)
    80003318:	fcf4ede3          	bltu	s1,a5,800032f2 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000331c:	4639                	li	a2,14
    8000331e:	85d2                	mv	a1,s4
    80003320:	fc240513          	addi	a0,s0,-62
    80003324:	ffffd097          	auipc	ra,0xffffd
    80003328:	f8e080e7          	jalr	-114(ra) # 800002b2 <strncpy>
  de.inum = inum;
    8000332c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003330:	4741                	li	a4,16
    80003332:	86a6                	mv	a3,s1
    80003334:	fc040613          	addi	a2,s0,-64
    80003338:	4581                	li	a1,0
    8000333a:	854a                	mv	a0,s2
    8000333c:	00000097          	auipc	ra,0x0
    80003340:	c44080e7          	jalr	-956(ra) # 80002f80 <writei>
    80003344:	872a                	mv	a4,a0
    80003346:	47c1                	li	a5,16
  return 0;
    80003348:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000334a:	02f71863          	bne	a4,a5,8000337a <dirlink+0xb2>
}
    8000334e:	70e2                	ld	ra,56(sp)
    80003350:	7442                	ld	s0,48(sp)
    80003352:	74a2                	ld	s1,40(sp)
    80003354:	7902                	ld	s2,32(sp)
    80003356:	69e2                	ld	s3,24(sp)
    80003358:	6a42                	ld	s4,16(sp)
    8000335a:	6121                	addi	sp,sp,64
    8000335c:	8082                	ret
    iput(ip);
    8000335e:	00000097          	auipc	ra,0x0
    80003362:	a30080e7          	jalr	-1488(ra) # 80002d8e <iput>
    return -1;
    80003366:	557d                	li	a0,-1
    80003368:	b7dd                	j	8000334e <dirlink+0x86>
      panic("dirlink read");
    8000336a:	00005517          	auipc	a0,0x5
    8000336e:	3be50513          	addi	a0,a0,958 # 80008728 <syscalls+0x1d8>
    80003372:	00003097          	auipc	ra,0x3
    80003376:	916080e7          	jalr	-1770(ra) # 80005c88 <panic>
    panic("dirlink");
    8000337a:	00005517          	auipc	a0,0x5
    8000337e:	4b650513          	addi	a0,a0,1206 # 80008830 <syscalls+0x2e0>
    80003382:	00003097          	auipc	ra,0x3
    80003386:	906080e7          	jalr	-1786(ra) # 80005c88 <panic>

000000008000338a <namei>:

struct inode*
namei(char *path)
{
    8000338a:	1101                	addi	sp,sp,-32
    8000338c:	ec06                	sd	ra,24(sp)
    8000338e:	e822                	sd	s0,16(sp)
    80003390:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003392:	fe040613          	addi	a2,s0,-32
    80003396:	4581                	li	a1,0
    80003398:	00000097          	auipc	ra,0x0
    8000339c:	dd0080e7          	jalr	-560(ra) # 80003168 <namex>
}
    800033a0:	60e2                	ld	ra,24(sp)
    800033a2:	6442                	ld	s0,16(sp)
    800033a4:	6105                	addi	sp,sp,32
    800033a6:	8082                	ret

00000000800033a8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033a8:	1141                	addi	sp,sp,-16
    800033aa:	e406                	sd	ra,8(sp)
    800033ac:	e022                	sd	s0,0(sp)
    800033ae:	0800                	addi	s0,sp,16
    800033b0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033b2:	4585                	li	a1,1
    800033b4:	00000097          	auipc	ra,0x0
    800033b8:	db4080e7          	jalr	-588(ra) # 80003168 <namex>
}
    800033bc:	60a2                	ld	ra,8(sp)
    800033be:	6402                	ld	s0,0(sp)
    800033c0:	0141                	addi	sp,sp,16
    800033c2:	8082                	ret

00000000800033c4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033c4:	1101                	addi	sp,sp,-32
    800033c6:	ec06                	sd	ra,24(sp)
    800033c8:	e822                	sd	s0,16(sp)
    800033ca:	e426                	sd	s1,8(sp)
    800033cc:	e04a                	sd	s2,0(sp)
    800033ce:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033d0:	00016917          	auipc	s2,0x16
    800033d4:	c5090913          	addi	s2,s2,-944 # 80019020 <log>
    800033d8:	01892583          	lw	a1,24(s2)
    800033dc:	02892503          	lw	a0,40(s2)
    800033e0:	fffff097          	auipc	ra,0xfffff
    800033e4:	ff2080e7          	jalr	-14(ra) # 800023d2 <bread>
    800033e8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033ea:	02c92683          	lw	a3,44(s2)
    800033ee:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033f0:	02d05763          	blez	a3,8000341e <write_head+0x5a>
    800033f4:	00016797          	auipc	a5,0x16
    800033f8:	c5c78793          	addi	a5,a5,-932 # 80019050 <log+0x30>
    800033fc:	05c50713          	addi	a4,a0,92
    80003400:	36fd                	addiw	a3,a3,-1
    80003402:	1682                	slli	a3,a3,0x20
    80003404:	9281                	srli	a3,a3,0x20
    80003406:	068a                	slli	a3,a3,0x2
    80003408:	00016617          	auipc	a2,0x16
    8000340c:	c4c60613          	addi	a2,a2,-948 # 80019054 <log+0x34>
    80003410:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003412:	4390                	lw	a2,0(a5)
    80003414:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003416:	0791                	addi	a5,a5,4
    80003418:	0711                	addi	a4,a4,4
    8000341a:	fed79ce3          	bne	a5,a3,80003412 <write_head+0x4e>
  }
  bwrite(buf);
    8000341e:	8526                	mv	a0,s1
    80003420:	fffff097          	auipc	ra,0xfffff
    80003424:	0a4080e7          	jalr	164(ra) # 800024c4 <bwrite>
  brelse(buf);
    80003428:	8526                	mv	a0,s1
    8000342a:	fffff097          	auipc	ra,0xfffff
    8000342e:	0d8080e7          	jalr	216(ra) # 80002502 <brelse>
}
    80003432:	60e2                	ld	ra,24(sp)
    80003434:	6442                	ld	s0,16(sp)
    80003436:	64a2                	ld	s1,8(sp)
    80003438:	6902                	ld	s2,0(sp)
    8000343a:	6105                	addi	sp,sp,32
    8000343c:	8082                	ret

000000008000343e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000343e:	00016797          	auipc	a5,0x16
    80003442:	c0e7a783          	lw	a5,-1010(a5) # 8001904c <log+0x2c>
    80003446:	0af05d63          	blez	a5,80003500 <install_trans+0xc2>
{
    8000344a:	7139                	addi	sp,sp,-64
    8000344c:	fc06                	sd	ra,56(sp)
    8000344e:	f822                	sd	s0,48(sp)
    80003450:	f426                	sd	s1,40(sp)
    80003452:	f04a                	sd	s2,32(sp)
    80003454:	ec4e                	sd	s3,24(sp)
    80003456:	e852                	sd	s4,16(sp)
    80003458:	e456                	sd	s5,8(sp)
    8000345a:	e05a                	sd	s6,0(sp)
    8000345c:	0080                	addi	s0,sp,64
    8000345e:	8b2a                	mv	s6,a0
    80003460:	00016a97          	auipc	s5,0x16
    80003464:	bf0a8a93          	addi	s5,s5,-1040 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003468:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000346a:	00016997          	auipc	s3,0x16
    8000346e:	bb698993          	addi	s3,s3,-1098 # 80019020 <log>
    80003472:	a035                	j	8000349e <install_trans+0x60>
      bunpin(dbuf);
    80003474:	8526                	mv	a0,s1
    80003476:	fffff097          	auipc	ra,0xfffff
    8000347a:	166080e7          	jalr	358(ra) # 800025dc <bunpin>
    brelse(lbuf);
    8000347e:	854a                	mv	a0,s2
    80003480:	fffff097          	auipc	ra,0xfffff
    80003484:	082080e7          	jalr	130(ra) # 80002502 <brelse>
    brelse(dbuf);
    80003488:	8526                	mv	a0,s1
    8000348a:	fffff097          	auipc	ra,0xfffff
    8000348e:	078080e7          	jalr	120(ra) # 80002502 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003492:	2a05                	addiw	s4,s4,1
    80003494:	0a91                	addi	s5,s5,4
    80003496:	02c9a783          	lw	a5,44(s3)
    8000349a:	04fa5963          	bge	s4,a5,800034ec <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000349e:	0189a583          	lw	a1,24(s3)
    800034a2:	014585bb          	addw	a1,a1,s4
    800034a6:	2585                	addiw	a1,a1,1
    800034a8:	0289a503          	lw	a0,40(s3)
    800034ac:	fffff097          	auipc	ra,0xfffff
    800034b0:	f26080e7          	jalr	-218(ra) # 800023d2 <bread>
    800034b4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034b6:	000aa583          	lw	a1,0(s5)
    800034ba:	0289a503          	lw	a0,40(s3)
    800034be:	fffff097          	auipc	ra,0xfffff
    800034c2:	f14080e7          	jalr	-236(ra) # 800023d2 <bread>
    800034c6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034c8:	40000613          	li	a2,1024
    800034cc:	05890593          	addi	a1,s2,88
    800034d0:	05850513          	addi	a0,a0,88
    800034d4:	ffffd097          	auipc	ra,0xffffd
    800034d8:	d2a080e7          	jalr	-726(ra) # 800001fe <memmove>
    bwrite(dbuf);  // write dst to disk
    800034dc:	8526                	mv	a0,s1
    800034de:	fffff097          	auipc	ra,0xfffff
    800034e2:	fe6080e7          	jalr	-26(ra) # 800024c4 <bwrite>
    if(recovering == 0)
    800034e6:	f80b1ce3          	bnez	s6,8000347e <install_trans+0x40>
    800034ea:	b769                	j	80003474 <install_trans+0x36>
}
    800034ec:	70e2                	ld	ra,56(sp)
    800034ee:	7442                	ld	s0,48(sp)
    800034f0:	74a2                	ld	s1,40(sp)
    800034f2:	7902                	ld	s2,32(sp)
    800034f4:	69e2                	ld	s3,24(sp)
    800034f6:	6a42                	ld	s4,16(sp)
    800034f8:	6aa2                	ld	s5,8(sp)
    800034fa:	6b02                	ld	s6,0(sp)
    800034fc:	6121                	addi	sp,sp,64
    800034fe:	8082                	ret
    80003500:	8082                	ret

0000000080003502 <initlog>:
{
    80003502:	7179                	addi	sp,sp,-48
    80003504:	f406                	sd	ra,40(sp)
    80003506:	f022                	sd	s0,32(sp)
    80003508:	ec26                	sd	s1,24(sp)
    8000350a:	e84a                	sd	s2,16(sp)
    8000350c:	e44e                	sd	s3,8(sp)
    8000350e:	1800                	addi	s0,sp,48
    80003510:	892a                	mv	s2,a0
    80003512:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003514:	00016497          	auipc	s1,0x16
    80003518:	b0c48493          	addi	s1,s1,-1268 # 80019020 <log>
    8000351c:	00005597          	auipc	a1,0x5
    80003520:	21c58593          	addi	a1,a1,540 # 80008738 <syscalls+0x1e8>
    80003524:	8526                	mv	a0,s1
    80003526:	00003097          	auipc	ra,0x3
    8000352a:	c1c080e7          	jalr	-996(ra) # 80006142 <initlock>
  log.start = sb->logstart;
    8000352e:	0149a583          	lw	a1,20(s3)
    80003532:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003534:	0109a783          	lw	a5,16(s3)
    80003538:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000353a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000353e:	854a                	mv	a0,s2
    80003540:	fffff097          	auipc	ra,0xfffff
    80003544:	e92080e7          	jalr	-366(ra) # 800023d2 <bread>
  log.lh.n = lh->n;
    80003548:	4d3c                	lw	a5,88(a0)
    8000354a:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000354c:	02f05563          	blez	a5,80003576 <initlog+0x74>
    80003550:	05c50713          	addi	a4,a0,92
    80003554:	00016697          	auipc	a3,0x16
    80003558:	afc68693          	addi	a3,a3,-1284 # 80019050 <log+0x30>
    8000355c:	37fd                	addiw	a5,a5,-1
    8000355e:	1782                	slli	a5,a5,0x20
    80003560:	9381                	srli	a5,a5,0x20
    80003562:	078a                	slli	a5,a5,0x2
    80003564:	06050613          	addi	a2,a0,96
    80003568:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000356a:	4310                	lw	a2,0(a4)
    8000356c:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000356e:	0711                	addi	a4,a4,4
    80003570:	0691                	addi	a3,a3,4
    80003572:	fef71ce3          	bne	a4,a5,8000356a <initlog+0x68>
  brelse(buf);
    80003576:	fffff097          	auipc	ra,0xfffff
    8000357a:	f8c080e7          	jalr	-116(ra) # 80002502 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000357e:	4505                	li	a0,1
    80003580:	00000097          	auipc	ra,0x0
    80003584:	ebe080e7          	jalr	-322(ra) # 8000343e <install_trans>
  log.lh.n = 0;
    80003588:	00016797          	auipc	a5,0x16
    8000358c:	ac07a223          	sw	zero,-1340(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    80003590:	00000097          	auipc	ra,0x0
    80003594:	e34080e7          	jalr	-460(ra) # 800033c4 <write_head>
}
    80003598:	70a2                	ld	ra,40(sp)
    8000359a:	7402                	ld	s0,32(sp)
    8000359c:	64e2                	ld	s1,24(sp)
    8000359e:	6942                	ld	s2,16(sp)
    800035a0:	69a2                	ld	s3,8(sp)
    800035a2:	6145                	addi	sp,sp,48
    800035a4:	8082                	ret

00000000800035a6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035a6:	1101                	addi	sp,sp,-32
    800035a8:	ec06                	sd	ra,24(sp)
    800035aa:	e822                	sd	s0,16(sp)
    800035ac:	e426                	sd	s1,8(sp)
    800035ae:	e04a                	sd	s2,0(sp)
    800035b0:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035b2:	00016517          	auipc	a0,0x16
    800035b6:	a6e50513          	addi	a0,a0,-1426 # 80019020 <log>
    800035ba:	00003097          	auipc	ra,0x3
    800035be:	c18080e7          	jalr	-1000(ra) # 800061d2 <acquire>
  while(1){
    if(log.committing){
    800035c2:	00016497          	auipc	s1,0x16
    800035c6:	a5e48493          	addi	s1,s1,-1442 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035ca:	4979                	li	s2,30
    800035cc:	a039                	j	800035da <begin_op+0x34>
      sleep(&log, &log.lock);
    800035ce:	85a6                	mv	a1,s1
    800035d0:	8526                	mv	a0,s1
    800035d2:	ffffe097          	auipc	ra,0xffffe
    800035d6:	f96080e7          	jalr	-106(ra) # 80001568 <sleep>
    if(log.committing){
    800035da:	50dc                	lw	a5,36(s1)
    800035dc:	fbed                	bnez	a5,800035ce <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035de:	509c                	lw	a5,32(s1)
    800035e0:	0017871b          	addiw	a4,a5,1
    800035e4:	0007069b          	sext.w	a3,a4
    800035e8:	0027179b          	slliw	a5,a4,0x2
    800035ec:	9fb9                	addw	a5,a5,a4
    800035ee:	0017979b          	slliw	a5,a5,0x1
    800035f2:	54d8                	lw	a4,44(s1)
    800035f4:	9fb9                	addw	a5,a5,a4
    800035f6:	00f95963          	bge	s2,a5,80003608 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035fa:	85a6                	mv	a1,s1
    800035fc:	8526                	mv	a0,s1
    800035fe:	ffffe097          	auipc	ra,0xffffe
    80003602:	f6a080e7          	jalr	-150(ra) # 80001568 <sleep>
    80003606:	bfd1                	j	800035da <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003608:	00016517          	auipc	a0,0x16
    8000360c:	a1850513          	addi	a0,a0,-1512 # 80019020 <log>
    80003610:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003612:	00003097          	auipc	ra,0x3
    80003616:	c74080e7          	jalr	-908(ra) # 80006286 <release>
      break;
    }
  }
}
    8000361a:	60e2                	ld	ra,24(sp)
    8000361c:	6442                	ld	s0,16(sp)
    8000361e:	64a2                	ld	s1,8(sp)
    80003620:	6902                	ld	s2,0(sp)
    80003622:	6105                	addi	sp,sp,32
    80003624:	8082                	ret

0000000080003626 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003626:	7139                	addi	sp,sp,-64
    80003628:	fc06                	sd	ra,56(sp)
    8000362a:	f822                	sd	s0,48(sp)
    8000362c:	f426                	sd	s1,40(sp)
    8000362e:	f04a                	sd	s2,32(sp)
    80003630:	ec4e                	sd	s3,24(sp)
    80003632:	e852                	sd	s4,16(sp)
    80003634:	e456                	sd	s5,8(sp)
    80003636:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003638:	00016497          	auipc	s1,0x16
    8000363c:	9e848493          	addi	s1,s1,-1560 # 80019020 <log>
    80003640:	8526                	mv	a0,s1
    80003642:	00003097          	auipc	ra,0x3
    80003646:	b90080e7          	jalr	-1136(ra) # 800061d2 <acquire>
  log.outstanding -= 1;
    8000364a:	509c                	lw	a5,32(s1)
    8000364c:	37fd                	addiw	a5,a5,-1
    8000364e:	0007891b          	sext.w	s2,a5
    80003652:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003654:	50dc                	lw	a5,36(s1)
    80003656:	efb9                	bnez	a5,800036b4 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003658:	06091663          	bnez	s2,800036c4 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000365c:	00016497          	auipc	s1,0x16
    80003660:	9c448493          	addi	s1,s1,-1596 # 80019020 <log>
    80003664:	4785                	li	a5,1
    80003666:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003668:	8526                	mv	a0,s1
    8000366a:	00003097          	auipc	ra,0x3
    8000366e:	c1c080e7          	jalr	-996(ra) # 80006286 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003672:	54dc                	lw	a5,44(s1)
    80003674:	06f04763          	bgtz	a5,800036e2 <end_op+0xbc>
    acquire(&log.lock);
    80003678:	00016497          	auipc	s1,0x16
    8000367c:	9a848493          	addi	s1,s1,-1624 # 80019020 <log>
    80003680:	8526                	mv	a0,s1
    80003682:	00003097          	auipc	ra,0x3
    80003686:	b50080e7          	jalr	-1200(ra) # 800061d2 <acquire>
    log.committing = 0;
    8000368a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000368e:	8526                	mv	a0,s1
    80003690:	ffffe097          	auipc	ra,0xffffe
    80003694:	064080e7          	jalr	100(ra) # 800016f4 <wakeup>
    release(&log.lock);
    80003698:	8526                	mv	a0,s1
    8000369a:	00003097          	auipc	ra,0x3
    8000369e:	bec080e7          	jalr	-1044(ra) # 80006286 <release>
}
    800036a2:	70e2                	ld	ra,56(sp)
    800036a4:	7442                	ld	s0,48(sp)
    800036a6:	74a2                	ld	s1,40(sp)
    800036a8:	7902                	ld	s2,32(sp)
    800036aa:	69e2                	ld	s3,24(sp)
    800036ac:	6a42                	ld	s4,16(sp)
    800036ae:	6aa2                	ld	s5,8(sp)
    800036b0:	6121                	addi	sp,sp,64
    800036b2:	8082                	ret
    panic("log.committing");
    800036b4:	00005517          	auipc	a0,0x5
    800036b8:	08c50513          	addi	a0,a0,140 # 80008740 <syscalls+0x1f0>
    800036bc:	00002097          	auipc	ra,0x2
    800036c0:	5cc080e7          	jalr	1484(ra) # 80005c88 <panic>
    wakeup(&log);
    800036c4:	00016497          	auipc	s1,0x16
    800036c8:	95c48493          	addi	s1,s1,-1700 # 80019020 <log>
    800036cc:	8526                	mv	a0,s1
    800036ce:	ffffe097          	auipc	ra,0xffffe
    800036d2:	026080e7          	jalr	38(ra) # 800016f4 <wakeup>
  release(&log.lock);
    800036d6:	8526                	mv	a0,s1
    800036d8:	00003097          	auipc	ra,0x3
    800036dc:	bae080e7          	jalr	-1106(ra) # 80006286 <release>
  if(do_commit){
    800036e0:	b7c9                	j	800036a2 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036e2:	00016a97          	auipc	s5,0x16
    800036e6:	96ea8a93          	addi	s5,s5,-1682 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036ea:	00016a17          	auipc	s4,0x16
    800036ee:	936a0a13          	addi	s4,s4,-1738 # 80019020 <log>
    800036f2:	018a2583          	lw	a1,24(s4)
    800036f6:	012585bb          	addw	a1,a1,s2
    800036fa:	2585                	addiw	a1,a1,1
    800036fc:	028a2503          	lw	a0,40(s4)
    80003700:	fffff097          	auipc	ra,0xfffff
    80003704:	cd2080e7          	jalr	-814(ra) # 800023d2 <bread>
    80003708:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000370a:	000aa583          	lw	a1,0(s5)
    8000370e:	028a2503          	lw	a0,40(s4)
    80003712:	fffff097          	auipc	ra,0xfffff
    80003716:	cc0080e7          	jalr	-832(ra) # 800023d2 <bread>
    8000371a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000371c:	40000613          	li	a2,1024
    80003720:	05850593          	addi	a1,a0,88
    80003724:	05848513          	addi	a0,s1,88
    80003728:	ffffd097          	auipc	ra,0xffffd
    8000372c:	ad6080e7          	jalr	-1322(ra) # 800001fe <memmove>
    bwrite(to);  // write the log
    80003730:	8526                	mv	a0,s1
    80003732:	fffff097          	auipc	ra,0xfffff
    80003736:	d92080e7          	jalr	-622(ra) # 800024c4 <bwrite>
    brelse(from);
    8000373a:	854e                	mv	a0,s3
    8000373c:	fffff097          	auipc	ra,0xfffff
    80003740:	dc6080e7          	jalr	-570(ra) # 80002502 <brelse>
    brelse(to);
    80003744:	8526                	mv	a0,s1
    80003746:	fffff097          	auipc	ra,0xfffff
    8000374a:	dbc080e7          	jalr	-580(ra) # 80002502 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000374e:	2905                	addiw	s2,s2,1
    80003750:	0a91                	addi	s5,s5,4
    80003752:	02ca2783          	lw	a5,44(s4)
    80003756:	f8f94ee3          	blt	s2,a5,800036f2 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000375a:	00000097          	auipc	ra,0x0
    8000375e:	c6a080e7          	jalr	-918(ra) # 800033c4 <write_head>
    install_trans(0); // Now install writes to home locations
    80003762:	4501                	li	a0,0
    80003764:	00000097          	auipc	ra,0x0
    80003768:	cda080e7          	jalr	-806(ra) # 8000343e <install_trans>
    log.lh.n = 0;
    8000376c:	00016797          	auipc	a5,0x16
    80003770:	8e07a023          	sw	zero,-1824(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003774:	00000097          	auipc	ra,0x0
    80003778:	c50080e7          	jalr	-944(ra) # 800033c4 <write_head>
    8000377c:	bdf5                	j	80003678 <end_op+0x52>

000000008000377e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000377e:	1101                	addi	sp,sp,-32
    80003780:	ec06                	sd	ra,24(sp)
    80003782:	e822                	sd	s0,16(sp)
    80003784:	e426                	sd	s1,8(sp)
    80003786:	e04a                	sd	s2,0(sp)
    80003788:	1000                	addi	s0,sp,32
    8000378a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000378c:	00016917          	auipc	s2,0x16
    80003790:	89490913          	addi	s2,s2,-1900 # 80019020 <log>
    80003794:	854a                	mv	a0,s2
    80003796:	00003097          	auipc	ra,0x3
    8000379a:	a3c080e7          	jalr	-1476(ra) # 800061d2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000379e:	02c92603          	lw	a2,44(s2)
    800037a2:	47f5                	li	a5,29
    800037a4:	06c7c563          	blt	a5,a2,8000380e <log_write+0x90>
    800037a8:	00016797          	auipc	a5,0x16
    800037ac:	8947a783          	lw	a5,-1900(a5) # 8001903c <log+0x1c>
    800037b0:	37fd                	addiw	a5,a5,-1
    800037b2:	04f65e63          	bge	a2,a5,8000380e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037b6:	00016797          	auipc	a5,0x16
    800037ba:	88a7a783          	lw	a5,-1910(a5) # 80019040 <log+0x20>
    800037be:	06f05063          	blez	a5,8000381e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037c2:	4781                	li	a5,0
    800037c4:	06c05563          	blez	a2,8000382e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037c8:	44cc                	lw	a1,12(s1)
    800037ca:	00016717          	auipc	a4,0x16
    800037ce:	88670713          	addi	a4,a4,-1914 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037d2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037d4:	4314                	lw	a3,0(a4)
    800037d6:	04b68c63          	beq	a3,a1,8000382e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037da:	2785                	addiw	a5,a5,1
    800037dc:	0711                	addi	a4,a4,4
    800037de:	fef61be3          	bne	a2,a5,800037d4 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037e2:	0621                	addi	a2,a2,8
    800037e4:	060a                	slli	a2,a2,0x2
    800037e6:	00016797          	auipc	a5,0x16
    800037ea:	83a78793          	addi	a5,a5,-1990 # 80019020 <log>
    800037ee:	963e                	add	a2,a2,a5
    800037f0:	44dc                	lw	a5,12(s1)
    800037f2:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037f4:	8526                	mv	a0,s1
    800037f6:	fffff097          	auipc	ra,0xfffff
    800037fa:	daa080e7          	jalr	-598(ra) # 800025a0 <bpin>
    log.lh.n++;
    800037fe:	00016717          	auipc	a4,0x16
    80003802:	82270713          	addi	a4,a4,-2014 # 80019020 <log>
    80003806:	575c                	lw	a5,44(a4)
    80003808:	2785                	addiw	a5,a5,1
    8000380a:	d75c                	sw	a5,44(a4)
    8000380c:	a835                	j	80003848 <log_write+0xca>
    panic("too big a transaction");
    8000380e:	00005517          	auipc	a0,0x5
    80003812:	f4250513          	addi	a0,a0,-190 # 80008750 <syscalls+0x200>
    80003816:	00002097          	auipc	ra,0x2
    8000381a:	472080e7          	jalr	1138(ra) # 80005c88 <panic>
    panic("log_write outside of trans");
    8000381e:	00005517          	auipc	a0,0x5
    80003822:	f4a50513          	addi	a0,a0,-182 # 80008768 <syscalls+0x218>
    80003826:	00002097          	auipc	ra,0x2
    8000382a:	462080e7          	jalr	1122(ra) # 80005c88 <panic>
  log.lh.block[i] = b->blockno;
    8000382e:	00878713          	addi	a4,a5,8
    80003832:	00271693          	slli	a3,a4,0x2
    80003836:	00015717          	auipc	a4,0x15
    8000383a:	7ea70713          	addi	a4,a4,2026 # 80019020 <log>
    8000383e:	9736                	add	a4,a4,a3
    80003840:	44d4                	lw	a3,12(s1)
    80003842:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003844:	faf608e3          	beq	a2,a5,800037f4 <log_write+0x76>
  }
  release(&log.lock);
    80003848:	00015517          	auipc	a0,0x15
    8000384c:	7d850513          	addi	a0,a0,2008 # 80019020 <log>
    80003850:	00003097          	auipc	ra,0x3
    80003854:	a36080e7          	jalr	-1482(ra) # 80006286 <release>
}
    80003858:	60e2                	ld	ra,24(sp)
    8000385a:	6442                	ld	s0,16(sp)
    8000385c:	64a2                	ld	s1,8(sp)
    8000385e:	6902                	ld	s2,0(sp)
    80003860:	6105                	addi	sp,sp,32
    80003862:	8082                	ret

0000000080003864 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003864:	1101                	addi	sp,sp,-32
    80003866:	ec06                	sd	ra,24(sp)
    80003868:	e822                	sd	s0,16(sp)
    8000386a:	e426                	sd	s1,8(sp)
    8000386c:	e04a                	sd	s2,0(sp)
    8000386e:	1000                	addi	s0,sp,32
    80003870:	84aa                	mv	s1,a0
    80003872:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003874:	00005597          	auipc	a1,0x5
    80003878:	f1458593          	addi	a1,a1,-236 # 80008788 <syscalls+0x238>
    8000387c:	0521                	addi	a0,a0,8
    8000387e:	00003097          	auipc	ra,0x3
    80003882:	8c4080e7          	jalr	-1852(ra) # 80006142 <initlock>
  lk->name = name;
    80003886:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000388a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000388e:	0204a423          	sw	zero,40(s1)
}
    80003892:	60e2                	ld	ra,24(sp)
    80003894:	6442                	ld	s0,16(sp)
    80003896:	64a2                	ld	s1,8(sp)
    80003898:	6902                	ld	s2,0(sp)
    8000389a:	6105                	addi	sp,sp,32
    8000389c:	8082                	ret

000000008000389e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000389e:	1101                	addi	sp,sp,-32
    800038a0:	ec06                	sd	ra,24(sp)
    800038a2:	e822                	sd	s0,16(sp)
    800038a4:	e426                	sd	s1,8(sp)
    800038a6:	e04a                	sd	s2,0(sp)
    800038a8:	1000                	addi	s0,sp,32
    800038aa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038ac:	00850913          	addi	s2,a0,8
    800038b0:	854a                	mv	a0,s2
    800038b2:	00003097          	auipc	ra,0x3
    800038b6:	920080e7          	jalr	-1760(ra) # 800061d2 <acquire>
  while (lk->locked) {
    800038ba:	409c                	lw	a5,0(s1)
    800038bc:	cb89                	beqz	a5,800038ce <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038be:	85ca                	mv	a1,s2
    800038c0:	8526                	mv	a0,s1
    800038c2:	ffffe097          	auipc	ra,0xffffe
    800038c6:	ca6080e7          	jalr	-858(ra) # 80001568 <sleep>
  while (lk->locked) {
    800038ca:	409c                	lw	a5,0(s1)
    800038cc:	fbed                	bnez	a5,800038be <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038ce:	4785                	li	a5,1
    800038d0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038d2:	ffffd097          	auipc	ra,0xffffd
    800038d6:	59c080e7          	jalr	1436(ra) # 80000e6e <myproc>
    800038da:	591c                	lw	a5,48(a0)
    800038dc:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038de:	854a                	mv	a0,s2
    800038e0:	00003097          	auipc	ra,0x3
    800038e4:	9a6080e7          	jalr	-1626(ra) # 80006286 <release>
}
    800038e8:	60e2                	ld	ra,24(sp)
    800038ea:	6442                	ld	s0,16(sp)
    800038ec:	64a2                	ld	s1,8(sp)
    800038ee:	6902                	ld	s2,0(sp)
    800038f0:	6105                	addi	sp,sp,32
    800038f2:	8082                	ret

00000000800038f4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038f4:	1101                	addi	sp,sp,-32
    800038f6:	ec06                	sd	ra,24(sp)
    800038f8:	e822                	sd	s0,16(sp)
    800038fa:	e426                	sd	s1,8(sp)
    800038fc:	e04a                	sd	s2,0(sp)
    800038fe:	1000                	addi	s0,sp,32
    80003900:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003902:	00850913          	addi	s2,a0,8
    80003906:	854a                	mv	a0,s2
    80003908:	00003097          	auipc	ra,0x3
    8000390c:	8ca080e7          	jalr	-1846(ra) # 800061d2 <acquire>
  lk->locked = 0;
    80003910:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003914:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003918:	8526                	mv	a0,s1
    8000391a:	ffffe097          	auipc	ra,0xffffe
    8000391e:	dda080e7          	jalr	-550(ra) # 800016f4 <wakeup>
  release(&lk->lk);
    80003922:	854a                	mv	a0,s2
    80003924:	00003097          	auipc	ra,0x3
    80003928:	962080e7          	jalr	-1694(ra) # 80006286 <release>
}
    8000392c:	60e2                	ld	ra,24(sp)
    8000392e:	6442                	ld	s0,16(sp)
    80003930:	64a2                	ld	s1,8(sp)
    80003932:	6902                	ld	s2,0(sp)
    80003934:	6105                	addi	sp,sp,32
    80003936:	8082                	ret

0000000080003938 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003938:	7179                	addi	sp,sp,-48
    8000393a:	f406                	sd	ra,40(sp)
    8000393c:	f022                	sd	s0,32(sp)
    8000393e:	ec26                	sd	s1,24(sp)
    80003940:	e84a                	sd	s2,16(sp)
    80003942:	e44e                	sd	s3,8(sp)
    80003944:	1800                	addi	s0,sp,48
    80003946:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003948:	00850913          	addi	s2,a0,8
    8000394c:	854a                	mv	a0,s2
    8000394e:	00003097          	auipc	ra,0x3
    80003952:	884080e7          	jalr	-1916(ra) # 800061d2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003956:	409c                	lw	a5,0(s1)
    80003958:	ef99                	bnez	a5,80003976 <holdingsleep+0x3e>
    8000395a:	4481                	li	s1,0
  release(&lk->lk);
    8000395c:	854a                	mv	a0,s2
    8000395e:	00003097          	auipc	ra,0x3
    80003962:	928080e7          	jalr	-1752(ra) # 80006286 <release>
  return r;
}
    80003966:	8526                	mv	a0,s1
    80003968:	70a2                	ld	ra,40(sp)
    8000396a:	7402                	ld	s0,32(sp)
    8000396c:	64e2                	ld	s1,24(sp)
    8000396e:	6942                	ld	s2,16(sp)
    80003970:	69a2                	ld	s3,8(sp)
    80003972:	6145                	addi	sp,sp,48
    80003974:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003976:	0284a983          	lw	s3,40(s1)
    8000397a:	ffffd097          	auipc	ra,0xffffd
    8000397e:	4f4080e7          	jalr	1268(ra) # 80000e6e <myproc>
    80003982:	5904                	lw	s1,48(a0)
    80003984:	413484b3          	sub	s1,s1,s3
    80003988:	0014b493          	seqz	s1,s1
    8000398c:	bfc1                	j	8000395c <holdingsleep+0x24>

000000008000398e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000398e:	1141                	addi	sp,sp,-16
    80003990:	e406                	sd	ra,8(sp)
    80003992:	e022                	sd	s0,0(sp)
    80003994:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003996:	00005597          	auipc	a1,0x5
    8000399a:	e0258593          	addi	a1,a1,-510 # 80008798 <syscalls+0x248>
    8000399e:	00015517          	auipc	a0,0x15
    800039a2:	7ca50513          	addi	a0,a0,1994 # 80019168 <ftable>
    800039a6:	00002097          	auipc	ra,0x2
    800039aa:	79c080e7          	jalr	1948(ra) # 80006142 <initlock>
}
    800039ae:	60a2                	ld	ra,8(sp)
    800039b0:	6402                	ld	s0,0(sp)
    800039b2:	0141                	addi	sp,sp,16
    800039b4:	8082                	ret

00000000800039b6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039b6:	1101                	addi	sp,sp,-32
    800039b8:	ec06                	sd	ra,24(sp)
    800039ba:	e822                	sd	s0,16(sp)
    800039bc:	e426                	sd	s1,8(sp)
    800039be:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039c0:	00015517          	auipc	a0,0x15
    800039c4:	7a850513          	addi	a0,a0,1960 # 80019168 <ftable>
    800039c8:	00003097          	auipc	ra,0x3
    800039cc:	80a080e7          	jalr	-2038(ra) # 800061d2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039d0:	00015497          	auipc	s1,0x15
    800039d4:	7b048493          	addi	s1,s1,1968 # 80019180 <ftable+0x18>
    800039d8:	00016717          	auipc	a4,0x16
    800039dc:	74870713          	addi	a4,a4,1864 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    800039e0:	40dc                	lw	a5,4(s1)
    800039e2:	cf99                	beqz	a5,80003a00 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039e4:	02848493          	addi	s1,s1,40
    800039e8:	fee49ce3          	bne	s1,a4,800039e0 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039ec:	00015517          	auipc	a0,0x15
    800039f0:	77c50513          	addi	a0,a0,1916 # 80019168 <ftable>
    800039f4:	00003097          	auipc	ra,0x3
    800039f8:	892080e7          	jalr	-1902(ra) # 80006286 <release>
  return 0;
    800039fc:	4481                	li	s1,0
    800039fe:	a819                	j	80003a14 <filealloc+0x5e>
      f->ref = 1;
    80003a00:	4785                	li	a5,1
    80003a02:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a04:	00015517          	auipc	a0,0x15
    80003a08:	76450513          	addi	a0,a0,1892 # 80019168 <ftable>
    80003a0c:	00003097          	auipc	ra,0x3
    80003a10:	87a080e7          	jalr	-1926(ra) # 80006286 <release>
}
    80003a14:	8526                	mv	a0,s1
    80003a16:	60e2                	ld	ra,24(sp)
    80003a18:	6442                	ld	s0,16(sp)
    80003a1a:	64a2                	ld	s1,8(sp)
    80003a1c:	6105                	addi	sp,sp,32
    80003a1e:	8082                	ret

0000000080003a20 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a20:	1101                	addi	sp,sp,-32
    80003a22:	ec06                	sd	ra,24(sp)
    80003a24:	e822                	sd	s0,16(sp)
    80003a26:	e426                	sd	s1,8(sp)
    80003a28:	1000                	addi	s0,sp,32
    80003a2a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a2c:	00015517          	auipc	a0,0x15
    80003a30:	73c50513          	addi	a0,a0,1852 # 80019168 <ftable>
    80003a34:	00002097          	auipc	ra,0x2
    80003a38:	79e080e7          	jalr	1950(ra) # 800061d2 <acquire>
  if(f->ref < 1)
    80003a3c:	40dc                	lw	a5,4(s1)
    80003a3e:	02f05263          	blez	a5,80003a62 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a42:	2785                	addiw	a5,a5,1
    80003a44:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a46:	00015517          	auipc	a0,0x15
    80003a4a:	72250513          	addi	a0,a0,1826 # 80019168 <ftable>
    80003a4e:	00003097          	auipc	ra,0x3
    80003a52:	838080e7          	jalr	-1992(ra) # 80006286 <release>
  return f;
}
    80003a56:	8526                	mv	a0,s1
    80003a58:	60e2                	ld	ra,24(sp)
    80003a5a:	6442                	ld	s0,16(sp)
    80003a5c:	64a2                	ld	s1,8(sp)
    80003a5e:	6105                	addi	sp,sp,32
    80003a60:	8082                	ret
    panic("filedup");
    80003a62:	00005517          	auipc	a0,0x5
    80003a66:	d3e50513          	addi	a0,a0,-706 # 800087a0 <syscalls+0x250>
    80003a6a:	00002097          	auipc	ra,0x2
    80003a6e:	21e080e7          	jalr	542(ra) # 80005c88 <panic>

0000000080003a72 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a72:	7139                	addi	sp,sp,-64
    80003a74:	fc06                	sd	ra,56(sp)
    80003a76:	f822                	sd	s0,48(sp)
    80003a78:	f426                	sd	s1,40(sp)
    80003a7a:	f04a                	sd	s2,32(sp)
    80003a7c:	ec4e                	sd	s3,24(sp)
    80003a7e:	e852                	sd	s4,16(sp)
    80003a80:	e456                	sd	s5,8(sp)
    80003a82:	0080                	addi	s0,sp,64
    80003a84:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a86:	00015517          	auipc	a0,0x15
    80003a8a:	6e250513          	addi	a0,a0,1762 # 80019168 <ftable>
    80003a8e:	00002097          	auipc	ra,0x2
    80003a92:	744080e7          	jalr	1860(ra) # 800061d2 <acquire>
  if(f->ref < 1)
    80003a96:	40dc                	lw	a5,4(s1)
    80003a98:	06f05163          	blez	a5,80003afa <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a9c:	37fd                	addiw	a5,a5,-1
    80003a9e:	0007871b          	sext.w	a4,a5
    80003aa2:	c0dc                	sw	a5,4(s1)
    80003aa4:	06e04363          	bgtz	a4,80003b0a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003aa8:	0004a903          	lw	s2,0(s1)
    80003aac:	0094ca83          	lbu	s5,9(s1)
    80003ab0:	0104ba03          	ld	s4,16(s1)
    80003ab4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ab8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003abc:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ac0:	00015517          	auipc	a0,0x15
    80003ac4:	6a850513          	addi	a0,a0,1704 # 80019168 <ftable>
    80003ac8:	00002097          	auipc	ra,0x2
    80003acc:	7be080e7          	jalr	1982(ra) # 80006286 <release>

  if(ff.type == FD_PIPE){
    80003ad0:	4785                	li	a5,1
    80003ad2:	04f90d63          	beq	s2,a5,80003b2c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ad6:	3979                	addiw	s2,s2,-2
    80003ad8:	4785                	li	a5,1
    80003ada:	0527e063          	bltu	a5,s2,80003b1a <fileclose+0xa8>
    begin_op();
    80003ade:	00000097          	auipc	ra,0x0
    80003ae2:	ac8080e7          	jalr	-1336(ra) # 800035a6 <begin_op>
    iput(ff.ip);
    80003ae6:	854e                	mv	a0,s3
    80003ae8:	fffff097          	auipc	ra,0xfffff
    80003aec:	2a6080e7          	jalr	678(ra) # 80002d8e <iput>
    end_op();
    80003af0:	00000097          	auipc	ra,0x0
    80003af4:	b36080e7          	jalr	-1226(ra) # 80003626 <end_op>
    80003af8:	a00d                	j	80003b1a <fileclose+0xa8>
    panic("fileclose");
    80003afa:	00005517          	auipc	a0,0x5
    80003afe:	cae50513          	addi	a0,a0,-850 # 800087a8 <syscalls+0x258>
    80003b02:	00002097          	auipc	ra,0x2
    80003b06:	186080e7          	jalr	390(ra) # 80005c88 <panic>
    release(&ftable.lock);
    80003b0a:	00015517          	auipc	a0,0x15
    80003b0e:	65e50513          	addi	a0,a0,1630 # 80019168 <ftable>
    80003b12:	00002097          	auipc	ra,0x2
    80003b16:	774080e7          	jalr	1908(ra) # 80006286 <release>
  }
}
    80003b1a:	70e2                	ld	ra,56(sp)
    80003b1c:	7442                	ld	s0,48(sp)
    80003b1e:	74a2                	ld	s1,40(sp)
    80003b20:	7902                	ld	s2,32(sp)
    80003b22:	69e2                	ld	s3,24(sp)
    80003b24:	6a42                	ld	s4,16(sp)
    80003b26:	6aa2                	ld	s5,8(sp)
    80003b28:	6121                	addi	sp,sp,64
    80003b2a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b2c:	85d6                	mv	a1,s5
    80003b2e:	8552                	mv	a0,s4
    80003b30:	00000097          	auipc	ra,0x0
    80003b34:	34c080e7          	jalr	844(ra) # 80003e7c <pipeclose>
    80003b38:	b7cd                	j	80003b1a <fileclose+0xa8>

0000000080003b3a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b3a:	715d                	addi	sp,sp,-80
    80003b3c:	e486                	sd	ra,72(sp)
    80003b3e:	e0a2                	sd	s0,64(sp)
    80003b40:	fc26                	sd	s1,56(sp)
    80003b42:	f84a                	sd	s2,48(sp)
    80003b44:	f44e                	sd	s3,40(sp)
    80003b46:	0880                	addi	s0,sp,80
    80003b48:	84aa                	mv	s1,a0
    80003b4a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b4c:	ffffd097          	auipc	ra,0xffffd
    80003b50:	322080e7          	jalr	802(ra) # 80000e6e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b54:	409c                	lw	a5,0(s1)
    80003b56:	37f9                	addiw	a5,a5,-2
    80003b58:	4705                	li	a4,1
    80003b5a:	04f76763          	bltu	a4,a5,80003ba8 <filestat+0x6e>
    80003b5e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b60:	6c88                	ld	a0,24(s1)
    80003b62:	fffff097          	auipc	ra,0xfffff
    80003b66:	072080e7          	jalr	114(ra) # 80002bd4 <ilock>
    stati(f->ip, &st);
    80003b6a:	fb840593          	addi	a1,s0,-72
    80003b6e:	6c88                	ld	a0,24(s1)
    80003b70:	fffff097          	auipc	ra,0xfffff
    80003b74:	2ee080e7          	jalr	750(ra) # 80002e5e <stati>
    iunlock(f->ip);
    80003b78:	6c88                	ld	a0,24(s1)
    80003b7a:	fffff097          	auipc	ra,0xfffff
    80003b7e:	11c080e7          	jalr	284(ra) # 80002c96 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b82:	46e1                	li	a3,24
    80003b84:	fb840613          	addi	a2,s0,-72
    80003b88:	85ce                	mv	a1,s3
    80003b8a:	05093503          	ld	a0,80(s2)
    80003b8e:	ffffd097          	auipc	ra,0xffffd
    80003b92:	fa2080e7          	jalr	-94(ra) # 80000b30 <copyout>
    80003b96:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b9a:	60a6                	ld	ra,72(sp)
    80003b9c:	6406                	ld	s0,64(sp)
    80003b9e:	74e2                	ld	s1,56(sp)
    80003ba0:	7942                	ld	s2,48(sp)
    80003ba2:	79a2                	ld	s3,40(sp)
    80003ba4:	6161                	addi	sp,sp,80
    80003ba6:	8082                	ret
  return -1;
    80003ba8:	557d                	li	a0,-1
    80003baa:	bfc5                	j	80003b9a <filestat+0x60>

0000000080003bac <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bac:	7179                	addi	sp,sp,-48
    80003bae:	f406                	sd	ra,40(sp)
    80003bb0:	f022                	sd	s0,32(sp)
    80003bb2:	ec26                	sd	s1,24(sp)
    80003bb4:	e84a                	sd	s2,16(sp)
    80003bb6:	e44e                	sd	s3,8(sp)
    80003bb8:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bba:	00854783          	lbu	a5,8(a0)
    80003bbe:	c3d5                	beqz	a5,80003c62 <fileread+0xb6>
    80003bc0:	84aa                	mv	s1,a0
    80003bc2:	89ae                	mv	s3,a1
    80003bc4:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bc6:	411c                	lw	a5,0(a0)
    80003bc8:	4705                	li	a4,1
    80003bca:	04e78963          	beq	a5,a4,80003c1c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bce:	470d                	li	a4,3
    80003bd0:	04e78d63          	beq	a5,a4,80003c2a <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bd4:	4709                	li	a4,2
    80003bd6:	06e79e63          	bne	a5,a4,80003c52 <fileread+0xa6>
    ilock(f->ip);
    80003bda:	6d08                	ld	a0,24(a0)
    80003bdc:	fffff097          	auipc	ra,0xfffff
    80003be0:	ff8080e7          	jalr	-8(ra) # 80002bd4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003be4:	874a                	mv	a4,s2
    80003be6:	5094                	lw	a3,32(s1)
    80003be8:	864e                	mv	a2,s3
    80003bea:	4585                	li	a1,1
    80003bec:	6c88                	ld	a0,24(s1)
    80003bee:	fffff097          	auipc	ra,0xfffff
    80003bf2:	29a080e7          	jalr	666(ra) # 80002e88 <readi>
    80003bf6:	892a                	mv	s2,a0
    80003bf8:	00a05563          	blez	a0,80003c02 <fileread+0x56>
      f->off += r;
    80003bfc:	509c                	lw	a5,32(s1)
    80003bfe:	9fa9                	addw	a5,a5,a0
    80003c00:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c02:	6c88                	ld	a0,24(s1)
    80003c04:	fffff097          	auipc	ra,0xfffff
    80003c08:	092080e7          	jalr	146(ra) # 80002c96 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c0c:	854a                	mv	a0,s2
    80003c0e:	70a2                	ld	ra,40(sp)
    80003c10:	7402                	ld	s0,32(sp)
    80003c12:	64e2                	ld	s1,24(sp)
    80003c14:	6942                	ld	s2,16(sp)
    80003c16:	69a2                	ld	s3,8(sp)
    80003c18:	6145                	addi	sp,sp,48
    80003c1a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c1c:	6908                	ld	a0,16(a0)
    80003c1e:	00000097          	auipc	ra,0x0
    80003c22:	3c8080e7          	jalr	968(ra) # 80003fe6 <piperead>
    80003c26:	892a                	mv	s2,a0
    80003c28:	b7d5                	j	80003c0c <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c2a:	02451783          	lh	a5,36(a0)
    80003c2e:	03079693          	slli	a3,a5,0x30
    80003c32:	92c1                	srli	a3,a3,0x30
    80003c34:	4725                	li	a4,9
    80003c36:	02d76863          	bltu	a4,a3,80003c66 <fileread+0xba>
    80003c3a:	0792                	slli	a5,a5,0x4
    80003c3c:	00015717          	auipc	a4,0x15
    80003c40:	48c70713          	addi	a4,a4,1164 # 800190c8 <devsw>
    80003c44:	97ba                	add	a5,a5,a4
    80003c46:	639c                	ld	a5,0(a5)
    80003c48:	c38d                	beqz	a5,80003c6a <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c4a:	4505                	li	a0,1
    80003c4c:	9782                	jalr	a5
    80003c4e:	892a                	mv	s2,a0
    80003c50:	bf75                	j	80003c0c <fileread+0x60>
    panic("fileread");
    80003c52:	00005517          	auipc	a0,0x5
    80003c56:	b6650513          	addi	a0,a0,-1178 # 800087b8 <syscalls+0x268>
    80003c5a:	00002097          	auipc	ra,0x2
    80003c5e:	02e080e7          	jalr	46(ra) # 80005c88 <panic>
    return -1;
    80003c62:	597d                	li	s2,-1
    80003c64:	b765                	j	80003c0c <fileread+0x60>
      return -1;
    80003c66:	597d                	li	s2,-1
    80003c68:	b755                	j	80003c0c <fileread+0x60>
    80003c6a:	597d                	li	s2,-1
    80003c6c:	b745                	j	80003c0c <fileread+0x60>

0000000080003c6e <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c6e:	715d                	addi	sp,sp,-80
    80003c70:	e486                	sd	ra,72(sp)
    80003c72:	e0a2                	sd	s0,64(sp)
    80003c74:	fc26                	sd	s1,56(sp)
    80003c76:	f84a                	sd	s2,48(sp)
    80003c78:	f44e                	sd	s3,40(sp)
    80003c7a:	f052                	sd	s4,32(sp)
    80003c7c:	ec56                	sd	s5,24(sp)
    80003c7e:	e85a                	sd	s6,16(sp)
    80003c80:	e45e                	sd	s7,8(sp)
    80003c82:	e062                	sd	s8,0(sp)
    80003c84:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c86:	00954783          	lbu	a5,9(a0)
    80003c8a:	10078663          	beqz	a5,80003d96 <filewrite+0x128>
    80003c8e:	892a                	mv	s2,a0
    80003c90:	8aae                	mv	s5,a1
    80003c92:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c94:	411c                	lw	a5,0(a0)
    80003c96:	4705                	li	a4,1
    80003c98:	02e78263          	beq	a5,a4,80003cbc <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c9c:	470d                	li	a4,3
    80003c9e:	02e78663          	beq	a5,a4,80003cca <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ca2:	4709                	li	a4,2
    80003ca4:	0ee79163          	bne	a5,a4,80003d86 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003ca8:	0ac05d63          	blez	a2,80003d62 <filewrite+0xf4>
    int i = 0;
    80003cac:	4981                	li	s3,0
    80003cae:	6b05                	lui	s6,0x1
    80003cb0:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003cb4:	6b85                	lui	s7,0x1
    80003cb6:	c00b8b9b          	addiw	s7,s7,-1024
    80003cba:	a861                	j	80003d52 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003cbc:	6908                	ld	a0,16(a0)
    80003cbe:	00000097          	auipc	ra,0x0
    80003cc2:	22e080e7          	jalr	558(ra) # 80003eec <pipewrite>
    80003cc6:	8a2a                	mv	s4,a0
    80003cc8:	a045                	j	80003d68 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cca:	02451783          	lh	a5,36(a0)
    80003cce:	03079693          	slli	a3,a5,0x30
    80003cd2:	92c1                	srli	a3,a3,0x30
    80003cd4:	4725                	li	a4,9
    80003cd6:	0cd76263          	bltu	a4,a3,80003d9a <filewrite+0x12c>
    80003cda:	0792                	slli	a5,a5,0x4
    80003cdc:	00015717          	auipc	a4,0x15
    80003ce0:	3ec70713          	addi	a4,a4,1004 # 800190c8 <devsw>
    80003ce4:	97ba                	add	a5,a5,a4
    80003ce6:	679c                	ld	a5,8(a5)
    80003ce8:	cbdd                	beqz	a5,80003d9e <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cea:	4505                	li	a0,1
    80003cec:	9782                	jalr	a5
    80003cee:	8a2a                	mv	s4,a0
    80003cf0:	a8a5                	j	80003d68 <filewrite+0xfa>
    80003cf2:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003cf6:	00000097          	auipc	ra,0x0
    80003cfa:	8b0080e7          	jalr	-1872(ra) # 800035a6 <begin_op>
      ilock(f->ip);
    80003cfe:	01893503          	ld	a0,24(s2)
    80003d02:	fffff097          	auipc	ra,0xfffff
    80003d06:	ed2080e7          	jalr	-302(ra) # 80002bd4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d0a:	8762                	mv	a4,s8
    80003d0c:	02092683          	lw	a3,32(s2)
    80003d10:	01598633          	add	a2,s3,s5
    80003d14:	4585                	li	a1,1
    80003d16:	01893503          	ld	a0,24(s2)
    80003d1a:	fffff097          	auipc	ra,0xfffff
    80003d1e:	266080e7          	jalr	614(ra) # 80002f80 <writei>
    80003d22:	84aa                	mv	s1,a0
    80003d24:	00a05763          	blez	a0,80003d32 <filewrite+0xc4>
        f->off += r;
    80003d28:	02092783          	lw	a5,32(s2)
    80003d2c:	9fa9                	addw	a5,a5,a0
    80003d2e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d32:	01893503          	ld	a0,24(s2)
    80003d36:	fffff097          	auipc	ra,0xfffff
    80003d3a:	f60080e7          	jalr	-160(ra) # 80002c96 <iunlock>
      end_op();
    80003d3e:	00000097          	auipc	ra,0x0
    80003d42:	8e8080e7          	jalr	-1816(ra) # 80003626 <end_op>

      if(r != n1){
    80003d46:	009c1f63          	bne	s8,s1,80003d64 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d4a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d4e:	0149db63          	bge	s3,s4,80003d64 <filewrite+0xf6>
      int n1 = n - i;
    80003d52:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d56:	84be                	mv	s1,a5
    80003d58:	2781                	sext.w	a5,a5
    80003d5a:	f8fb5ce3          	bge	s6,a5,80003cf2 <filewrite+0x84>
    80003d5e:	84de                	mv	s1,s7
    80003d60:	bf49                	j	80003cf2 <filewrite+0x84>
    int i = 0;
    80003d62:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d64:	013a1f63          	bne	s4,s3,80003d82 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d68:	8552                	mv	a0,s4
    80003d6a:	60a6                	ld	ra,72(sp)
    80003d6c:	6406                	ld	s0,64(sp)
    80003d6e:	74e2                	ld	s1,56(sp)
    80003d70:	7942                	ld	s2,48(sp)
    80003d72:	79a2                	ld	s3,40(sp)
    80003d74:	7a02                	ld	s4,32(sp)
    80003d76:	6ae2                	ld	s5,24(sp)
    80003d78:	6b42                	ld	s6,16(sp)
    80003d7a:	6ba2                	ld	s7,8(sp)
    80003d7c:	6c02                	ld	s8,0(sp)
    80003d7e:	6161                	addi	sp,sp,80
    80003d80:	8082                	ret
    ret = (i == n ? n : -1);
    80003d82:	5a7d                	li	s4,-1
    80003d84:	b7d5                	j	80003d68 <filewrite+0xfa>
    panic("filewrite");
    80003d86:	00005517          	auipc	a0,0x5
    80003d8a:	a4250513          	addi	a0,a0,-1470 # 800087c8 <syscalls+0x278>
    80003d8e:	00002097          	auipc	ra,0x2
    80003d92:	efa080e7          	jalr	-262(ra) # 80005c88 <panic>
    return -1;
    80003d96:	5a7d                	li	s4,-1
    80003d98:	bfc1                	j	80003d68 <filewrite+0xfa>
      return -1;
    80003d9a:	5a7d                	li	s4,-1
    80003d9c:	b7f1                	j	80003d68 <filewrite+0xfa>
    80003d9e:	5a7d                	li	s4,-1
    80003da0:	b7e1                	j	80003d68 <filewrite+0xfa>

0000000080003da2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003da2:	7179                	addi	sp,sp,-48
    80003da4:	f406                	sd	ra,40(sp)
    80003da6:	f022                	sd	s0,32(sp)
    80003da8:	ec26                	sd	s1,24(sp)
    80003daa:	e84a                	sd	s2,16(sp)
    80003dac:	e44e                	sd	s3,8(sp)
    80003dae:	e052                	sd	s4,0(sp)
    80003db0:	1800                	addi	s0,sp,48
    80003db2:	84aa                	mv	s1,a0
    80003db4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003db6:	0005b023          	sd	zero,0(a1)
    80003dba:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dbe:	00000097          	auipc	ra,0x0
    80003dc2:	bf8080e7          	jalr	-1032(ra) # 800039b6 <filealloc>
    80003dc6:	e088                	sd	a0,0(s1)
    80003dc8:	c551                	beqz	a0,80003e54 <pipealloc+0xb2>
    80003dca:	00000097          	auipc	ra,0x0
    80003dce:	bec080e7          	jalr	-1044(ra) # 800039b6 <filealloc>
    80003dd2:	00aa3023          	sd	a0,0(s4)
    80003dd6:	c92d                	beqz	a0,80003e48 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dd8:	ffffc097          	auipc	ra,0xffffc
    80003ddc:	340080e7          	jalr	832(ra) # 80000118 <kalloc>
    80003de0:	892a                	mv	s2,a0
    80003de2:	c125                	beqz	a0,80003e42 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003de4:	4985                	li	s3,1
    80003de6:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dea:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dee:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003df2:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003df6:	00004597          	auipc	a1,0x4
    80003dfa:	5aa58593          	addi	a1,a1,1450 # 800083a0 <states.1721+0x160>
    80003dfe:	00002097          	auipc	ra,0x2
    80003e02:	344080e7          	jalr	836(ra) # 80006142 <initlock>
  (*f0)->type = FD_PIPE;
    80003e06:	609c                	ld	a5,0(s1)
    80003e08:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e0c:	609c                	ld	a5,0(s1)
    80003e0e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e12:	609c                	ld	a5,0(s1)
    80003e14:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e18:	609c                	ld	a5,0(s1)
    80003e1a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e1e:	000a3783          	ld	a5,0(s4)
    80003e22:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e26:	000a3783          	ld	a5,0(s4)
    80003e2a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e2e:	000a3783          	ld	a5,0(s4)
    80003e32:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e36:	000a3783          	ld	a5,0(s4)
    80003e3a:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e3e:	4501                	li	a0,0
    80003e40:	a025                	j	80003e68 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e42:	6088                	ld	a0,0(s1)
    80003e44:	e501                	bnez	a0,80003e4c <pipealloc+0xaa>
    80003e46:	a039                	j	80003e54 <pipealloc+0xb2>
    80003e48:	6088                	ld	a0,0(s1)
    80003e4a:	c51d                	beqz	a0,80003e78 <pipealloc+0xd6>
    fileclose(*f0);
    80003e4c:	00000097          	auipc	ra,0x0
    80003e50:	c26080e7          	jalr	-986(ra) # 80003a72 <fileclose>
  if(*f1)
    80003e54:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e58:	557d                	li	a0,-1
  if(*f1)
    80003e5a:	c799                	beqz	a5,80003e68 <pipealloc+0xc6>
    fileclose(*f1);
    80003e5c:	853e                	mv	a0,a5
    80003e5e:	00000097          	auipc	ra,0x0
    80003e62:	c14080e7          	jalr	-1004(ra) # 80003a72 <fileclose>
  return -1;
    80003e66:	557d                	li	a0,-1
}
    80003e68:	70a2                	ld	ra,40(sp)
    80003e6a:	7402                	ld	s0,32(sp)
    80003e6c:	64e2                	ld	s1,24(sp)
    80003e6e:	6942                	ld	s2,16(sp)
    80003e70:	69a2                	ld	s3,8(sp)
    80003e72:	6a02                	ld	s4,0(sp)
    80003e74:	6145                	addi	sp,sp,48
    80003e76:	8082                	ret
  return -1;
    80003e78:	557d                	li	a0,-1
    80003e7a:	b7fd                	j	80003e68 <pipealloc+0xc6>

0000000080003e7c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e7c:	1101                	addi	sp,sp,-32
    80003e7e:	ec06                	sd	ra,24(sp)
    80003e80:	e822                	sd	s0,16(sp)
    80003e82:	e426                	sd	s1,8(sp)
    80003e84:	e04a                	sd	s2,0(sp)
    80003e86:	1000                	addi	s0,sp,32
    80003e88:	84aa                	mv	s1,a0
    80003e8a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e8c:	00002097          	auipc	ra,0x2
    80003e90:	346080e7          	jalr	838(ra) # 800061d2 <acquire>
  if(writable){
    80003e94:	02090d63          	beqz	s2,80003ece <pipeclose+0x52>
    pi->writeopen = 0;
    80003e98:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e9c:	21848513          	addi	a0,s1,536
    80003ea0:	ffffe097          	auipc	ra,0xffffe
    80003ea4:	854080e7          	jalr	-1964(ra) # 800016f4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ea8:	2204b783          	ld	a5,544(s1)
    80003eac:	eb95                	bnez	a5,80003ee0 <pipeclose+0x64>
    release(&pi->lock);
    80003eae:	8526                	mv	a0,s1
    80003eb0:	00002097          	auipc	ra,0x2
    80003eb4:	3d6080e7          	jalr	982(ra) # 80006286 <release>
    kfree((char*)pi);
    80003eb8:	8526                	mv	a0,s1
    80003eba:	ffffc097          	auipc	ra,0xffffc
    80003ebe:	162080e7          	jalr	354(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ec2:	60e2                	ld	ra,24(sp)
    80003ec4:	6442                	ld	s0,16(sp)
    80003ec6:	64a2                	ld	s1,8(sp)
    80003ec8:	6902                	ld	s2,0(sp)
    80003eca:	6105                	addi	sp,sp,32
    80003ecc:	8082                	ret
    pi->readopen = 0;
    80003ece:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ed2:	21c48513          	addi	a0,s1,540
    80003ed6:	ffffe097          	auipc	ra,0xffffe
    80003eda:	81e080e7          	jalr	-2018(ra) # 800016f4 <wakeup>
    80003ede:	b7e9                	j	80003ea8 <pipeclose+0x2c>
    release(&pi->lock);
    80003ee0:	8526                	mv	a0,s1
    80003ee2:	00002097          	auipc	ra,0x2
    80003ee6:	3a4080e7          	jalr	932(ra) # 80006286 <release>
}
    80003eea:	bfe1                	j	80003ec2 <pipeclose+0x46>

0000000080003eec <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003eec:	7159                	addi	sp,sp,-112
    80003eee:	f486                	sd	ra,104(sp)
    80003ef0:	f0a2                	sd	s0,96(sp)
    80003ef2:	eca6                	sd	s1,88(sp)
    80003ef4:	e8ca                	sd	s2,80(sp)
    80003ef6:	e4ce                	sd	s3,72(sp)
    80003ef8:	e0d2                	sd	s4,64(sp)
    80003efa:	fc56                	sd	s5,56(sp)
    80003efc:	f85a                	sd	s6,48(sp)
    80003efe:	f45e                	sd	s7,40(sp)
    80003f00:	f062                	sd	s8,32(sp)
    80003f02:	ec66                	sd	s9,24(sp)
    80003f04:	1880                	addi	s0,sp,112
    80003f06:	84aa                	mv	s1,a0
    80003f08:	8aae                	mv	s5,a1
    80003f0a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f0c:	ffffd097          	auipc	ra,0xffffd
    80003f10:	f62080e7          	jalr	-158(ra) # 80000e6e <myproc>
    80003f14:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f16:	8526                	mv	a0,s1
    80003f18:	00002097          	auipc	ra,0x2
    80003f1c:	2ba080e7          	jalr	698(ra) # 800061d2 <acquire>
  while(i < n){
    80003f20:	0d405163          	blez	s4,80003fe2 <pipewrite+0xf6>
    80003f24:	8ba6                	mv	s7,s1
  int i = 0;
    80003f26:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f28:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f2a:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f2e:	21c48c13          	addi	s8,s1,540
    80003f32:	a08d                	j	80003f94 <pipewrite+0xa8>
      release(&pi->lock);
    80003f34:	8526                	mv	a0,s1
    80003f36:	00002097          	auipc	ra,0x2
    80003f3a:	350080e7          	jalr	848(ra) # 80006286 <release>
      return -1;
    80003f3e:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f40:	854a                	mv	a0,s2
    80003f42:	70a6                	ld	ra,104(sp)
    80003f44:	7406                	ld	s0,96(sp)
    80003f46:	64e6                	ld	s1,88(sp)
    80003f48:	6946                	ld	s2,80(sp)
    80003f4a:	69a6                	ld	s3,72(sp)
    80003f4c:	6a06                	ld	s4,64(sp)
    80003f4e:	7ae2                	ld	s5,56(sp)
    80003f50:	7b42                	ld	s6,48(sp)
    80003f52:	7ba2                	ld	s7,40(sp)
    80003f54:	7c02                	ld	s8,32(sp)
    80003f56:	6ce2                	ld	s9,24(sp)
    80003f58:	6165                	addi	sp,sp,112
    80003f5a:	8082                	ret
      wakeup(&pi->nread);
    80003f5c:	8566                	mv	a0,s9
    80003f5e:	ffffd097          	auipc	ra,0xffffd
    80003f62:	796080e7          	jalr	1942(ra) # 800016f4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f66:	85de                	mv	a1,s7
    80003f68:	8562                	mv	a0,s8
    80003f6a:	ffffd097          	auipc	ra,0xffffd
    80003f6e:	5fe080e7          	jalr	1534(ra) # 80001568 <sleep>
    80003f72:	a839                	j	80003f90 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f74:	21c4a783          	lw	a5,540(s1)
    80003f78:	0017871b          	addiw	a4,a5,1
    80003f7c:	20e4ae23          	sw	a4,540(s1)
    80003f80:	1ff7f793          	andi	a5,a5,511
    80003f84:	97a6                	add	a5,a5,s1
    80003f86:	f9f44703          	lbu	a4,-97(s0)
    80003f8a:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f8e:	2905                	addiw	s2,s2,1
  while(i < n){
    80003f90:	03495d63          	bge	s2,s4,80003fca <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003f94:	2204a783          	lw	a5,544(s1)
    80003f98:	dfd1                	beqz	a5,80003f34 <pipewrite+0x48>
    80003f9a:	0289a783          	lw	a5,40(s3)
    80003f9e:	fbd9                	bnez	a5,80003f34 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fa0:	2184a783          	lw	a5,536(s1)
    80003fa4:	21c4a703          	lw	a4,540(s1)
    80003fa8:	2007879b          	addiw	a5,a5,512
    80003fac:	faf708e3          	beq	a4,a5,80003f5c <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fb0:	4685                	li	a3,1
    80003fb2:	01590633          	add	a2,s2,s5
    80003fb6:	f9f40593          	addi	a1,s0,-97
    80003fba:	0509b503          	ld	a0,80(s3)
    80003fbe:	ffffd097          	auipc	ra,0xffffd
    80003fc2:	bfe080e7          	jalr	-1026(ra) # 80000bbc <copyin>
    80003fc6:	fb6517e3          	bne	a0,s6,80003f74 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003fca:	21848513          	addi	a0,s1,536
    80003fce:	ffffd097          	auipc	ra,0xffffd
    80003fd2:	726080e7          	jalr	1830(ra) # 800016f4 <wakeup>
  release(&pi->lock);
    80003fd6:	8526                	mv	a0,s1
    80003fd8:	00002097          	auipc	ra,0x2
    80003fdc:	2ae080e7          	jalr	686(ra) # 80006286 <release>
  return i;
    80003fe0:	b785                	j	80003f40 <pipewrite+0x54>
  int i = 0;
    80003fe2:	4901                	li	s2,0
    80003fe4:	b7dd                	j	80003fca <pipewrite+0xde>

0000000080003fe6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fe6:	715d                	addi	sp,sp,-80
    80003fe8:	e486                	sd	ra,72(sp)
    80003fea:	e0a2                	sd	s0,64(sp)
    80003fec:	fc26                	sd	s1,56(sp)
    80003fee:	f84a                	sd	s2,48(sp)
    80003ff0:	f44e                	sd	s3,40(sp)
    80003ff2:	f052                	sd	s4,32(sp)
    80003ff4:	ec56                	sd	s5,24(sp)
    80003ff6:	e85a                	sd	s6,16(sp)
    80003ff8:	0880                	addi	s0,sp,80
    80003ffa:	84aa                	mv	s1,a0
    80003ffc:	892e                	mv	s2,a1
    80003ffe:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004000:	ffffd097          	auipc	ra,0xffffd
    80004004:	e6e080e7          	jalr	-402(ra) # 80000e6e <myproc>
    80004008:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000400a:	8b26                	mv	s6,s1
    8000400c:	8526                	mv	a0,s1
    8000400e:	00002097          	auipc	ra,0x2
    80004012:	1c4080e7          	jalr	452(ra) # 800061d2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004016:	2184a703          	lw	a4,536(s1)
    8000401a:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000401e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004022:	02f71463          	bne	a4,a5,8000404a <piperead+0x64>
    80004026:	2244a783          	lw	a5,548(s1)
    8000402a:	c385                	beqz	a5,8000404a <piperead+0x64>
    if(pr->killed){
    8000402c:	028a2783          	lw	a5,40(s4)
    80004030:	ebc1                	bnez	a5,800040c0 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004032:	85da                	mv	a1,s6
    80004034:	854e                	mv	a0,s3
    80004036:	ffffd097          	auipc	ra,0xffffd
    8000403a:	532080e7          	jalr	1330(ra) # 80001568 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000403e:	2184a703          	lw	a4,536(s1)
    80004042:	21c4a783          	lw	a5,540(s1)
    80004046:	fef700e3          	beq	a4,a5,80004026 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000404a:	09505263          	blez	s5,800040ce <piperead+0xe8>
    8000404e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004050:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004052:	2184a783          	lw	a5,536(s1)
    80004056:	21c4a703          	lw	a4,540(s1)
    8000405a:	02f70d63          	beq	a4,a5,80004094 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000405e:	0017871b          	addiw	a4,a5,1
    80004062:	20e4ac23          	sw	a4,536(s1)
    80004066:	1ff7f793          	andi	a5,a5,511
    8000406a:	97a6                	add	a5,a5,s1
    8000406c:	0187c783          	lbu	a5,24(a5)
    80004070:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004074:	4685                	li	a3,1
    80004076:	fbf40613          	addi	a2,s0,-65
    8000407a:	85ca                	mv	a1,s2
    8000407c:	050a3503          	ld	a0,80(s4)
    80004080:	ffffd097          	auipc	ra,0xffffd
    80004084:	ab0080e7          	jalr	-1360(ra) # 80000b30 <copyout>
    80004088:	01650663          	beq	a0,s6,80004094 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000408c:	2985                	addiw	s3,s3,1
    8000408e:	0905                	addi	s2,s2,1
    80004090:	fd3a91e3          	bne	s5,s3,80004052 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004094:	21c48513          	addi	a0,s1,540
    80004098:	ffffd097          	auipc	ra,0xffffd
    8000409c:	65c080e7          	jalr	1628(ra) # 800016f4 <wakeup>
  release(&pi->lock);
    800040a0:	8526                	mv	a0,s1
    800040a2:	00002097          	auipc	ra,0x2
    800040a6:	1e4080e7          	jalr	484(ra) # 80006286 <release>
  return i;
}
    800040aa:	854e                	mv	a0,s3
    800040ac:	60a6                	ld	ra,72(sp)
    800040ae:	6406                	ld	s0,64(sp)
    800040b0:	74e2                	ld	s1,56(sp)
    800040b2:	7942                	ld	s2,48(sp)
    800040b4:	79a2                	ld	s3,40(sp)
    800040b6:	7a02                	ld	s4,32(sp)
    800040b8:	6ae2                	ld	s5,24(sp)
    800040ba:	6b42                	ld	s6,16(sp)
    800040bc:	6161                	addi	sp,sp,80
    800040be:	8082                	ret
      release(&pi->lock);
    800040c0:	8526                	mv	a0,s1
    800040c2:	00002097          	auipc	ra,0x2
    800040c6:	1c4080e7          	jalr	452(ra) # 80006286 <release>
      return -1;
    800040ca:	59fd                	li	s3,-1
    800040cc:	bff9                	j	800040aa <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ce:	4981                	li	s3,0
    800040d0:	b7d1                	j	80004094 <piperead+0xae>

00000000800040d2 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040d2:	df010113          	addi	sp,sp,-528
    800040d6:	20113423          	sd	ra,520(sp)
    800040da:	20813023          	sd	s0,512(sp)
    800040de:	ffa6                	sd	s1,504(sp)
    800040e0:	fbca                	sd	s2,496(sp)
    800040e2:	f7ce                	sd	s3,488(sp)
    800040e4:	f3d2                	sd	s4,480(sp)
    800040e6:	efd6                	sd	s5,472(sp)
    800040e8:	ebda                	sd	s6,464(sp)
    800040ea:	e7de                	sd	s7,456(sp)
    800040ec:	e3e2                	sd	s8,448(sp)
    800040ee:	ff66                	sd	s9,440(sp)
    800040f0:	fb6a                	sd	s10,432(sp)
    800040f2:	f76e                	sd	s11,424(sp)
    800040f4:	0c00                	addi	s0,sp,528
    800040f6:	84aa                	mv	s1,a0
    800040f8:	dea43c23          	sd	a0,-520(s0)
    800040fc:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004100:	ffffd097          	auipc	ra,0xffffd
    80004104:	d6e080e7          	jalr	-658(ra) # 80000e6e <myproc>
    80004108:	892a                	mv	s2,a0

  begin_op();
    8000410a:	fffff097          	auipc	ra,0xfffff
    8000410e:	49c080e7          	jalr	1180(ra) # 800035a6 <begin_op>

  if((ip = namei(path)) == 0){
    80004112:	8526                	mv	a0,s1
    80004114:	fffff097          	auipc	ra,0xfffff
    80004118:	276080e7          	jalr	630(ra) # 8000338a <namei>
    8000411c:	c92d                	beqz	a0,8000418e <exec+0xbc>
    8000411e:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004120:	fffff097          	auipc	ra,0xfffff
    80004124:	ab4080e7          	jalr	-1356(ra) # 80002bd4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004128:	04000713          	li	a4,64
    8000412c:	4681                	li	a3,0
    8000412e:	e5040613          	addi	a2,s0,-432
    80004132:	4581                	li	a1,0
    80004134:	8526                	mv	a0,s1
    80004136:	fffff097          	auipc	ra,0xfffff
    8000413a:	d52080e7          	jalr	-686(ra) # 80002e88 <readi>
    8000413e:	04000793          	li	a5,64
    80004142:	00f51a63          	bne	a0,a5,80004156 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004146:	e5042703          	lw	a4,-432(s0)
    8000414a:	464c47b7          	lui	a5,0x464c4
    8000414e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004152:	04f70463          	beq	a4,a5,8000419a <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004156:	8526                	mv	a0,s1
    80004158:	fffff097          	auipc	ra,0xfffff
    8000415c:	cde080e7          	jalr	-802(ra) # 80002e36 <iunlockput>
    end_op();
    80004160:	fffff097          	auipc	ra,0xfffff
    80004164:	4c6080e7          	jalr	1222(ra) # 80003626 <end_op>
  }
  return -1;
    80004168:	557d                	li	a0,-1
}
    8000416a:	20813083          	ld	ra,520(sp)
    8000416e:	20013403          	ld	s0,512(sp)
    80004172:	74fe                	ld	s1,504(sp)
    80004174:	795e                	ld	s2,496(sp)
    80004176:	79be                	ld	s3,488(sp)
    80004178:	7a1e                	ld	s4,480(sp)
    8000417a:	6afe                	ld	s5,472(sp)
    8000417c:	6b5e                	ld	s6,464(sp)
    8000417e:	6bbe                	ld	s7,456(sp)
    80004180:	6c1e                	ld	s8,448(sp)
    80004182:	7cfa                	ld	s9,440(sp)
    80004184:	7d5a                	ld	s10,432(sp)
    80004186:	7dba                	ld	s11,424(sp)
    80004188:	21010113          	addi	sp,sp,528
    8000418c:	8082                	ret
    end_op();
    8000418e:	fffff097          	auipc	ra,0xfffff
    80004192:	498080e7          	jalr	1176(ra) # 80003626 <end_op>
    return -1;
    80004196:	557d                	li	a0,-1
    80004198:	bfc9                	j	8000416a <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000419a:	854a                	mv	a0,s2
    8000419c:	ffffd097          	auipc	ra,0xffffd
    800041a0:	dcc080e7          	jalr	-564(ra) # 80000f68 <proc_pagetable>
    800041a4:	8baa                	mv	s7,a0
    800041a6:	d945                	beqz	a0,80004156 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041a8:	e7042983          	lw	s3,-400(s0)
    800041ac:	e8845783          	lhu	a5,-376(s0)
    800041b0:	c7ad                	beqz	a5,8000421a <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041b2:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041b4:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800041b6:	6c85                	lui	s9,0x1
    800041b8:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041bc:	def43823          	sd	a5,-528(s0)
    800041c0:	a42d                	j	800043ea <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041c2:	00004517          	auipc	a0,0x4
    800041c6:	61650513          	addi	a0,a0,1558 # 800087d8 <syscalls+0x288>
    800041ca:	00002097          	auipc	ra,0x2
    800041ce:	abe080e7          	jalr	-1346(ra) # 80005c88 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041d2:	8756                	mv	a4,s5
    800041d4:	012d86bb          	addw	a3,s11,s2
    800041d8:	4581                	li	a1,0
    800041da:	8526                	mv	a0,s1
    800041dc:	fffff097          	auipc	ra,0xfffff
    800041e0:	cac080e7          	jalr	-852(ra) # 80002e88 <readi>
    800041e4:	2501                	sext.w	a0,a0
    800041e6:	1aaa9963          	bne	s5,a0,80004398 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800041ea:	6785                	lui	a5,0x1
    800041ec:	0127893b          	addw	s2,a5,s2
    800041f0:	77fd                	lui	a5,0xfffff
    800041f2:	01478a3b          	addw	s4,a5,s4
    800041f6:	1f897163          	bgeu	s2,s8,800043d8 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800041fa:	02091593          	slli	a1,s2,0x20
    800041fe:	9181                	srli	a1,a1,0x20
    80004200:	95ea                	add	a1,a1,s10
    80004202:	855e                	mv	a0,s7
    80004204:	ffffc097          	auipc	ra,0xffffc
    80004208:	328080e7          	jalr	808(ra) # 8000052c <walkaddr>
    8000420c:	862a                	mv	a2,a0
    if(pa == 0)
    8000420e:	d955                	beqz	a0,800041c2 <exec+0xf0>
      n = PGSIZE;
    80004210:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004212:	fd9a70e3          	bgeu	s4,s9,800041d2 <exec+0x100>
      n = sz - i;
    80004216:	8ad2                	mv	s5,s4
    80004218:	bf6d                	j	800041d2 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000421a:	4901                	li	s2,0
  iunlockput(ip);
    8000421c:	8526                	mv	a0,s1
    8000421e:	fffff097          	auipc	ra,0xfffff
    80004222:	c18080e7          	jalr	-1000(ra) # 80002e36 <iunlockput>
  end_op();
    80004226:	fffff097          	auipc	ra,0xfffff
    8000422a:	400080e7          	jalr	1024(ra) # 80003626 <end_op>
  p = myproc();
    8000422e:	ffffd097          	auipc	ra,0xffffd
    80004232:	c40080e7          	jalr	-960(ra) # 80000e6e <myproc>
    80004236:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004238:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000423c:	6785                	lui	a5,0x1
    8000423e:	17fd                	addi	a5,a5,-1
    80004240:	993e                	add	s2,s2,a5
    80004242:	757d                	lui	a0,0xfffff
    80004244:	00a977b3          	and	a5,s2,a0
    80004248:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000424c:	6609                	lui	a2,0x2
    8000424e:	963e                	add	a2,a2,a5
    80004250:	85be                	mv	a1,a5
    80004252:	855e                	mv	a0,s7
    80004254:	ffffc097          	auipc	ra,0xffffc
    80004258:	68c080e7          	jalr	1676(ra) # 800008e0 <uvmalloc>
    8000425c:	8b2a                	mv	s6,a0
  ip = 0;
    8000425e:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004260:	12050c63          	beqz	a0,80004398 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004264:	75f9                	lui	a1,0xffffe
    80004266:	95aa                	add	a1,a1,a0
    80004268:	855e                	mv	a0,s7
    8000426a:	ffffd097          	auipc	ra,0xffffd
    8000426e:	894080e7          	jalr	-1900(ra) # 80000afe <uvmclear>
  stackbase = sp - PGSIZE;
    80004272:	7c7d                	lui	s8,0xfffff
    80004274:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004276:	e0043783          	ld	a5,-512(s0)
    8000427a:	6388                	ld	a0,0(a5)
    8000427c:	c535                	beqz	a0,800042e8 <exec+0x216>
    8000427e:	e9040993          	addi	s3,s0,-368
    80004282:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004286:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004288:	ffffc097          	auipc	ra,0xffffc
    8000428c:	09a080e7          	jalr	154(ra) # 80000322 <strlen>
    80004290:	2505                	addiw	a0,a0,1
    80004292:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004296:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000429a:	13896363          	bltu	s2,s8,800043c0 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000429e:	e0043d83          	ld	s11,-512(s0)
    800042a2:	000dba03          	ld	s4,0(s11)
    800042a6:	8552                	mv	a0,s4
    800042a8:	ffffc097          	auipc	ra,0xffffc
    800042ac:	07a080e7          	jalr	122(ra) # 80000322 <strlen>
    800042b0:	0015069b          	addiw	a3,a0,1
    800042b4:	8652                	mv	a2,s4
    800042b6:	85ca                	mv	a1,s2
    800042b8:	855e                	mv	a0,s7
    800042ba:	ffffd097          	auipc	ra,0xffffd
    800042be:	876080e7          	jalr	-1930(ra) # 80000b30 <copyout>
    800042c2:	10054363          	bltz	a0,800043c8 <exec+0x2f6>
    ustack[argc] = sp;
    800042c6:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042ca:	0485                	addi	s1,s1,1
    800042cc:	008d8793          	addi	a5,s11,8
    800042d0:	e0f43023          	sd	a5,-512(s0)
    800042d4:	008db503          	ld	a0,8(s11)
    800042d8:	c911                	beqz	a0,800042ec <exec+0x21a>
    if(argc >= MAXARG)
    800042da:	09a1                	addi	s3,s3,8
    800042dc:	fb3c96e3          	bne	s9,s3,80004288 <exec+0x1b6>
  sz = sz1;
    800042e0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042e4:	4481                	li	s1,0
    800042e6:	a84d                	j	80004398 <exec+0x2c6>
  sp = sz;
    800042e8:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800042ea:	4481                	li	s1,0
  ustack[argc] = 0;
    800042ec:	00349793          	slli	a5,s1,0x3
    800042f0:	f9040713          	addi	a4,s0,-112
    800042f4:	97ba                	add	a5,a5,a4
    800042f6:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800042fa:	00148693          	addi	a3,s1,1
    800042fe:	068e                	slli	a3,a3,0x3
    80004300:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004304:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004308:	01897663          	bgeu	s2,s8,80004314 <exec+0x242>
  sz = sz1;
    8000430c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004310:	4481                	li	s1,0
    80004312:	a059                	j	80004398 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004314:	e9040613          	addi	a2,s0,-368
    80004318:	85ca                	mv	a1,s2
    8000431a:	855e                	mv	a0,s7
    8000431c:	ffffd097          	auipc	ra,0xffffd
    80004320:	814080e7          	jalr	-2028(ra) # 80000b30 <copyout>
    80004324:	0a054663          	bltz	a0,800043d0 <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004328:	058ab783          	ld	a5,88(s5)
    8000432c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004330:	df843783          	ld	a5,-520(s0)
    80004334:	0007c703          	lbu	a4,0(a5)
    80004338:	cf11                	beqz	a4,80004354 <exec+0x282>
    8000433a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000433c:	02f00693          	li	a3,47
    80004340:	a039                	j	8000434e <exec+0x27c>
      last = s+1;
    80004342:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004346:	0785                	addi	a5,a5,1
    80004348:	fff7c703          	lbu	a4,-1(a5)
    8000434c:	c701                	beqz	a4,80004354 <exec+0x282>
    if(*s == '/')
    8000434e:	fed71ce3          	bne	a4,a3,80004346 <exec+0x274>
    80004352:	bfc5                	j	80004342 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004354:	4641                	li	a2,16
    80004356:	df843583          	ld	a1,-520(s0)
    8000435a:	158a8513          	addi	a0,s5,344
    8000435e:	ffffc097          	auipc	ra,0xffffc
    80004362:	f92080e7          	jalr	-110(ra) # 800002f0 <safestrcpy>
  oldpagetable = p->pagetable;
    80004366:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000436a:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    8000436e:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004372:	058ab783          	ld	a5,88(s5)
    80004376:	e6843703          	ld	a4,-408(s0)
    8000437a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000437c:	058ab783          	ld	a5,88(s5)
    80004380:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004384:	85ea                	mv	a1,s10
    80004386:	ffffd097          	auipc	ra,0xffffd
    8000438a:	c7e080e7          	jalr	-898(ra) # 80001004 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000438e:	0004851b          	sext.w	a0,s1
    80004392:	bbe1                	j	8000416a <exec+0x98>
    80004394:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004398:	e0843583          	ld	a1,-504(s0)
    8000439c:	855e                	mv	a0,s7
    8000439e:	ffffd097          	auipc	ra,0xffffd
    800043a2:	c66080e7          	jalr	-922(ra) # 80001004 <proc_freepagetable>
  if(ip){
    800043a6:	da0498e3          	bnez	s1,80004156 <exec+0x84>
  return -1;
    800043aa:	557d                	li	a0,-1
    800043ac:	bb7d                	j	8000416a <exec+0x98>
    800043ae:	e1243423          	sd	s2,-504(s0)
    800043b2:	b7dd                	j	80004398 <exec+0x2c6>
    800043b4:	e1243423          	sd	s2,-504(s0)
    800043b8:	b7c5                	j	80004398 <exec+0x2c6>
    800043ba:	e1243423          	sd	s2,-504(s0)
    800043be:	bfe9                	j	80004398 <exec+0x2c6>
  sz = sz1;
    800043c0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043c4:	4481                	li	s1,0
    800043c6:	bfc9                	j	80004398 <exec+0x2c6>
  sz = sz1;
    800043c8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043cc:	4481                	li	s1,0
    800043ce:	b7e9                	j	80004398 <exec+0x2c6>
  sz = sz1;
    800043d0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043d4:	4481                	li	s1,0
    800043d6:	b7c9                	j	80004398 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043d8:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043dc:	2b05                	addiw	s6,s6,1
    800043de:	0389899b          	addiw	s3,s3,56
    800043e2:	e8845783          	lhu	a5,-376(s0)
    800043e6:	e2fb5be3          	bge	s6,a5,8000421c <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043ea:	2981                	sext.w	s3,s3
    800043ec:	03800713          	li	a4,56
    800043f0:	86ce                	mv	a3,s3
    800043f2:	e1840613          	addi	a2,s0,-488
    800043f6:	4581                	li	a1,0
    800043f8:	8526                	mv	a0,s1
    800043fa:	fffff097          	auipc	ra,0xfffff
    800043fe:	a8e080e7          	jalr	-1394(ra) # 80002e88 <readi>
    80004402:	03800793          	li	a5,56
    80004406:	f8f517e3          	bne	a0,a5,80004394 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    8000440a:	e1842783          	lw	a5,-488(s0)
    8000440e:	4705                	li	a4,1
    80004410:	fce796e3          	bne	a5,a4,800043dc <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004414:	e4043603          	ld	a2,-448(s0)
    80004418:	e3843783          	ld	a5,-456(s0)
    8000441c:	f8f669e3          	bltu	a2,a5,800043ae <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004420:	e2843783          	ld	a5,-472(s0)
    80004424:	963e                	add	a2,a2,a5
    80004426:	f8f667e3          	bltu	a2,a5,800043b4 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000442a:	85ca                	mv	a1,s2
    8000442c:	855e                	mv	a0,s7
    8000442e:	ffffc097          	auipc	ra,0xffffc
    80004432:	4b2080e7          	jalr	1202(ra) # 800008e0 <uvmalloc>
    80004436:	e0a43423          	sd	a0,-504(s0)
    8000443a:	d141                	beqz	a0,800043ba <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    8000443c:	e2843d03          	ld	s10,-472(s0)
    80004440:	df043783          	ld	a5,-528(s0)
    80004444:	00fd77b3          	and	a5,s10,a5
    80004448:	fba1                	bnez	a5,80004398 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000444a:	e2042d83          	lw	s11,-480(s0)
    8000444e:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004452:	f80c03e3          	beqz	s8,800043d8 <exec+0x306>
    80004456:	8a62                	mv	s4,s8
    80004458:	4901                	li	s2,0
    8000445a:	b345                	j	800041fa <exec+0x128>

000000008000445c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000445c:	7179                	addi	sp,sp,-48
    8000445e:	f406                	sd	ra,40(sp)
    80004460:	f022                	sd	s0,32(sp)
    80004462:	ec26                	sd	s1,24(sp)
    80004464:	e84a                	sd	s2,16(sp)
    80004466:	1800                	addi	s0,sp,48
    80004468:	892e                	mv	s2,a1
    8000446a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000446c:	fdc40593          	addi	a1,s0,-36
    80004470:	ffffe097          	auipc	ra,0xffffe
    80004474:	ae8080e7          	jalr	-1304(ra) # 80001f58 <argint>
    80004478:	04054063          	bltz	a0,800044b8 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000447c:	fdc42703          	lw	a4,-36(s0)
    80004480:	47bd                	li	a5,15
    80004482:	02e7ed63          	bltu	a5,a4,800044bc <argfd+0x60>
    80004486:	ffffd097          	auipc	ra,0xffffd
    8000448a:	9e8080e7          	jalr	-1560(ra) # 80000e6e <myproc>
    8000448e:	fdc42703          	lw	a4,-36(s0)
    80004492:	01a70793          	addi	a5,a4,26
    80004496:	078e                	slli	a5,a5,0x3
    80004498:	953e                	add	a0,a0,a5
    8000449a:	611c                	ld	a5,0(a0)
    8000449c:	c395                	beqz	a5,800044c0 <argfd+0x64>
    return -1;
  if(pfd)
    8000449e:	00090463          	beqz	s2,800044a6 <argfd+0x4a>
    *pfd = fd;
    800044a2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044a6:	4501                	li	a0,0
  if(pf)
    800044a8:	c091                	beqz	s1,800044ac <argfd+0x50>
    *pf = f;
    800044aa:	e09c                	sd	a5,0(s1)
}
    800044ac:	70a2                	ld	ra,40(sp)
    800044ae:	7402                	ld	s0,32(sp)
    800044b0:	64e2                	ld	s1,24(sp)
    800044b2:	6942                	ld	s2,16(sp)
    800044b4:	6145                	addi	sp,sp,48
    800044b6:	8082                	ret
    return -1;
    800044b8:	557d                	li	a0,-1
    800044ba:	bfcd                	j	800044ac <argfd+0x50>
    return -1;
    800044bc:	557d                	li	a0,-1
    800044be:	b7fd                	j	800044ac <argfd+0x50>
    800044c0:	557d                	li	a0,-1
    800044c2:	b7ed                	j	800044ac <argfd+0x50>

00000000800044c4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044c4:	1101                	addi	sp,sp,-32
    800044c6:	ec06                	sd	ra,24(sp)
    800044c8:	e822                	sd	s0,16(sp)
    800044ca:	e426                	sd	s1,8(sp)
    800044cc:	1000                	addi	s0,sp,32
    800044ce:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044d0:	ffffd097          	auipc	ra,0xffffd
    800044d4:	99e080e7          	jalr	-1634(ra) # 80000e6e <myproc>
    800044d8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044da:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    800044de:	4501                	li	a0,0
    800044e0:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044e2:	6398                	ld	a4,0(a5)
    800044e4:	cb19                	beqz	a4,800044fa <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044e6:	2505                	addiw	a0,a0,1
    800044e8:	07a1                	addi	a5,a5,8
    800044ea:	fed51ce3          	bne	a0,a3,800044e2 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044ee:	557d                	li	a0,-1
}
    800044f0:	60e2                	ld	ra,24(sp)
    800044f2:	6442                	ld	s0,16(sp)
    800044f4:	64a2                	ld	s1,8(sp)
    800044f6:	6105                	addi	sp,sp,32
    800044f8:	8082                	ret
      p->ofile[fd] = f;
    800044fa:	01a50793          	addi	a5,a0,26
    800044fe:	078e                	slli	a5,a5,0x3
    80004500:	963e                	add	a2,a2,a5
    80004502:	e204                	sd	s1,0(a2)
      return fd;
    80004504:	b7f5                	j	800044f0 <fdalloc+0x2c>

0000000080004506 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004506:	715d                	addi	sp,sp,-80
    80004508:	e486                	sd	ra,72(sp)
    8000450a:	e0a2                	sd	s0,64(sp)
    8000450c:	fc26                	sd	s1,56(sp)
    8000450e:	f84a                	sd	s2,48(sp)
    80004510:	f44e                	sd	s3,40(sp)
    80004512:	f052                	sd	s4,32(sp)
    80004514:	ec56                	sd	s5,24(sp)
    80004516:	0880                	addi	s0,sp,80
    80004518:	89ae                	mv	s3,a1
    8000451a:	8ab2                	mv	s5,a2
    8000451c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000451e:	fb040593          	addi	a1,s0,-80
    80004522:	fffff097          	auipc	ra,0xfffff
    80004526:	e86080e7          	jalr	-378(ra) # 800033a8 <nameiparent>
    8000452a:	892a                	mv	s2,a0
    8000452c:	12050f63          	beqz	a0,8000466a <create+0x164>
    return 0;

  ilock(dp);
    80004530:	ffffe097          	auipc	ra,0xffffe
    80004534:	6a4080e7          	jalr	1700(ra) # 80002bd4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004538:	4601                	li	a2,0
    8000453a:	fb040593          	addi	a1,s0,-80
    8000453e:	854a                	mv	a0,s2
    80004540:	fffff097          	auipc	ra,0xfffff
    80004544:	b78080e7          	jalr	-1160(ra) # 800030b8 <dirlookup>
    80004548:	84aa                	mv	s1,a0
    8000454a:	c921                	beqz	a0,8000459a <create+0x94>
    iunlockput(dp);
    8000454c:	854a                	mv	a0,s2
    8000454e:	fffff097          	auipc	ra,0xfffff
    80004552:	8e8080e7          	jalr	-1816(ra) # 80002e36 <iunlockput>
    ilock(ip);
    80004556:	8526                	mv	a0,s1
    80004558:	ffffe097          	auipc	ra,0xffffe
    8000455c:	67c080e7          	jalr	1660(ra) # 80002bd4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004560:	2981                	sext.w	s3,s3
    80004562:	4789                	li	a5,2
    80004564:	02f99463          	bne	s3,a5,8000458c <create+0x86>
    80004568:	0444d783          	lhu	a5,68(s1)
    8000456c:	37f9                	addiw	a5,a5,-2
    8000456e:	17c2                	slli	a5,a5,0x30
    80004570:	93c1                	srli	a5,a5,0x30
    80004572:	4705                	li	a4,1
    80004574:	00f76c63          	bltu	a4,a5,8000458c <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004578:	8526                	mv	a0,s1
    8000457a:	60a6                	ld	ra,72(sp)
    8000457c:	6406                	ld	s0,64(sp)
    8000457e:	74e2                	ld	s1,56(sp)
    80004580:	7942                	ld	s2,48(sp)
    80004582:	79a2                	ld	s3,40(sp)
    80004584:	7a02                	ld	s4,32(sp)
    80004586:	6ae2                	ld	s5,24(sp)
    80004588:	6161                	addi	sp,sp,80
    8000458a:	8082                	ret
    iunlockput(ip);
    8000458c:	8526                	mv	a0,s1
    8000458e:	fffff097          	auipc	ra,0xfffff
    80004592:	8a8080e7          	jalr	-1880(ra) # 80002e36 <iunlockput>
    return 0;
    80004596:	4481                	li	s1,0
    80004598:	b7c5                	j	80004578 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000459a:	85ce                	mv	a1,s3
    8000459c:	00092503          	lw	a0,0(s2)
    800045a0:	ffffe097          	auipc	ra,0xffffe
    800045a4:	49c080e7          	jalr	1180(ra) # 80002a3c <ialloc>
    800045a8:	84aa                	mv	s1,a0
    800045aa:	c529                	beqz	a0,800045f4 <create+0xee>
  ilock(ip);
    800045ac:	ffffe097          	auipc	ra,0xffffe
    800045b0:	628080e7          	jalr	1576(ra) # 80002bd4 <ilock>
  ip->major = major;
    800045b4:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800045b8:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800045bc:	4785                	li	a5,1
    800045be:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800045c2:	8526                	mv	a0,s1
    800045c4:	ffffe097          	auipc	ra,0xffffe
    800045c8:	546080e7          	jalr	1350(ra) # 80002b0a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045cc:	2981                	sext.w	s3,s3
    800045ce:	4785                	li	a5,1
    800045d0:	02f98a63          	beq	s3,a5,80004604 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800045d4:	40d0                	lw	a2,4(s1)
    800045d6:	fb040593          	addi	a1,s0,-80
    800045da:	854a                	mv	a0,s2
    800045dc:	fffff097          	auipc	ra,0xfffff
    800045e0:	cec080e7          	jalr	-788(ra) # 800032c8 <dirlink>
    800045e4:	06054b63          	bltz	a0,8000465a <create+0x154>
  iunlockput(dp);
    800045e8:	854a                	mv	a0,s2
    800045ea:	fffff097          	auipc	ra,0xfffff
    800045ee:	84c080e7          	jalr	-1972(ra) # 80002e36 <iunlockput>
  return ip;
    800045f2:	b759                	j	80004578 <create+0x72>
    panic("create: ialloc");
    800045f4:	00004517          	auipc	a0,0x4
    800045f8:	20450513          	addi	a0,a0,516 # 800087f8 <syscalls+0x2a8>
    800045fc:	00001097          	auipc	ra,0x1
    80004600:	68c080e7          	jalr	1676(ra) # 80005c88 <panic>
    dp->nlink++;  // for ".."
    80004604:	04a95783          	lhu	a5,74(s2)
    80004608:	2785                	addiw	a5,a5,1
    8000460a:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000460e:	854a                	mv	a0,s2
    80004610:	ffffe097          	auipc	ra,0xffffe
    80004614:	4fa080e7          	jalr	1274(ra) # 80002b0a <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004618:	40d0                	lw	a2,4(s1)
    8000461a:	00004597          	auipc	a1,0x4
    8000461e:	1ee58593          	addi	a1,a1,494 # 80008808 <syscalls+0x2b8>
    80004622:	8526                	mv	a0,s1
    80004624:	fffff097          	auipc	ra,0xfffff
    80004628:	ca4080e7          	jalr	-860(ra) # 800032c8 <dirlink>
    8000462c:	00054f63          	bltz	a0,8000464a <create+0x144>
    80004630:	00492603          	lw	a2,4(s2)
    80004634:	00004597          	auipc	a1,0x4
    80004638:	1dc58593          	addi	a1,a1,476 # 80008810 <syscalls+0x2c0>
    8000463c:	8526                	mv	a0,s1
    8000463e:	fffff097          	auipc	ra,0xfffff
    80004642:	c8a080e7          	jalr	-886(ra) # 800032c8 <dirlink>
    80004646:	f80557e3          	bgez	a0,800045d4 <create+0xce>
      panic("create dots");
    8000464a:	00004517          	auipc	a0,0x4
    8000464e:	1ce50513          	addi	a0,a0,462 # 80008818 <syscalls+0x2c8>
    80004652:	00001097          	auipc	ra,0x1
    80004656:	636080e7          	jalr	1590(ra) # 80005c88 <panic>
    panic("create: dirlink");
    8000465a:	00004517          	auipc	a0,0x4
    8000465e:	1ce50513          	addi	a0,a0,462 # 80008828 <syscalls+0x2d8>
    80004662:	00001097          	auipc	ra,0x1
    80004666:	626080e7          	jalr	1574(ra) # 80005c88 <panic>
    return 0;
    8000466a:	84aa                	mv	s1,a0
    8000466c:	b731                	j	80004578 <create+0x72>

000000008000466e <sys_dup>:
{
    8000466e:	7179                	addi	sp,sp,-48
    80004670:	f406                	sd	ra,40(sp)
    80004672:	f022                	sd	s0,32(sp)
    80004674:	ec26                	sd	s1,24(sp)
    80004676:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004678:	fd840613          	addi	a2,s0,-40
    8000467c:	4581                	li	a1,0
    8000467e:	4501                	li	a0,0
    80004680:	00000097          	auipc	ra,0x0
    80004684:	ddc080e7          	jalr	-548(ra) # 8000445c <argfd>
    return -1;
    80004688:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000468a:	02054363          	bltz	a0,800046b0 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000468e:	fd843503          	ld	a0,-40(s0)
    80004692:	00000097          	auipc	ra,0x0
    80004696:	e32080e7          	jalr	-462(ra) # 800044c4 <fdalloc>
    8000469a:	84aa                	mv	s1,a0
    return -1;
    8000469c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000469e:	00054963          	bltz	a0,800046b0 <sys_dup+0x42>
  filedup(f);
    800046a2:	fd843503          	ld	a0,-40(s0)
    800046a6:	fffff097          	auipc	ra,0xfffff
    800046aa:	37a080e7          	jalr	890(ra) # 80003a20 <filedup>
  return fd;
    800046ae:	87a6                	mv	a5,s1
}
    800046b0:	853e                	mv	a0,a5
    800046b2:	70a2                	ld	ra,40(sp)
    800046b4:	7402                	ld	s0,32(sp)
    800046b6:	64e2                	ld	s1,24(sp)
    800046b8:	6145                	addi	sp,sp,48
    800046ba:	8082                	ret

00000000800046bc <sys_read>:
{
    800046bc:	7179                	addi	sp,sp,-48
    800046be:	f406                	sd	ra,40(sp)
    800046c0:	f022                	sd	s0,32(sp)
    800046c2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046c4:	fe840613          	addi	a2,s0,-24
    800046c8:	4581                	li	a1,0
    800046ca:	4501                	li	a0,0
    800046cc:	00000097          	auipc	ra,0x0
    800046d0:	d90080e7          	jalr	-624(ra) # 8000445c <argfd>
    return -1;
    800046d4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046d6:	04054163          	bltz	a0,80004718 <sys_read+0x5c>
    800046da:	fe440593          	addi	a1,s0,-28
    800046de:	4509                	li	a0,2
    800046e0:	ffffe097          	auipc	ra,0xffffe
    800046e4:	878080e7          	jalr	-1928(ra) # 80001f58 <argint>
    return -1;
    800046e8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ea:	02054763          	bltz	a0,80004718 <sys_read+0x5c>
    800046ee:	fd840593          	addi	a1,s0,-40
    800046f2:	4505                	li	a0,1
    800046f4:	ffffe097          	auipc	ra,0xffffe
    800046f8:	886080e7          	jalr	-1914(ra) # 80001f7a <argaddr>
    return -1;
    800046fc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046fe:	00054d63          	bltz	a0,80004718 <sys_read+0x5c>
  return fileread(f, p, n);
    80004702:	fe442603          	lw	a2,-28(s0)
    80004706:	fd843583          	ld	a1,-40(s0)
    8000470a:	fe843503          	ld	a0,-24(s0)
    8000470e:	fffff097          	auipc	ra,0xfffff
    80004712:	49e080e7          	jalr	1182(ra) # 80003bac <fileread>
    80004716:	87aa                	mv	a5,a0
}
    80004718:	853e                	mv	a0,a5
    8000471a:	70a2                	ld	ra,40(sp)
    8000471c:	7402                	ld	s0,32(sp)
    8000471e:	6145                	addi	sp,sp,48
    80004720:	8082                	ret

0000000080004722 <sys_write>:
{
    80004722:	7179                	addi	sp,sp,-48
    80004724:	f406                	sd	ra,40(sp)
    80004726:	f022                	sd	s0,32(sp)
    80004728:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000472a:	fe840613          	addi	a2,s0,-24
    8000472e:	4581                	li	a1,0
    80004730:	4501                	li	a0,0
    80004732:	00000097          	auipc	ra,0x0
    80004736:	d2a080e7          	jalr	-726(ra) # 8000445c <argfd>
    return -1;
    8000473a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000473c:	04054163          	bltz	a0,8000477e <sys_write+0x5c>
    80004740:	fe440593          	addi	a1,s0,-28
    80004744:	4509                	li	a0,2
    80004746:	ffffe097          	auipc	ra,0xffffe
    8000474a:	812080e7          	jalr	-2030(ra) # 80001f58 <argint>
    return -1;
    8000474e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004750:	02054763          	bltz	a0,8000477e <sys_write+0x5c>
    80004754:	fd840593          	addi	a1,s0,-40
    80004758:	4505                	li	a0,1
    8000475a:	ffffe097          	auipc	ra,0xffffe
    8000475e:	820080e7          	jalr	-2016(ra) # 80001f7a <argaddr>
    return -1;
    80004762:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004764:	00054d63          	bltz	a0,8000477e <sys_write+0x5c>
  return filewrite(f, p, n);
    80004768:	fe442603          	lw	a2,-28(s0)
    8000476c:	fd843583          	ld	a1,-40(s0)
    80004770:	fe843503          	ld	a0,-24(s0)
    80004774:	fffff097          	auipc	ra,0xfffff
    80004778:	4fa080e7          	jalr	1274(ra) # 80003c6e <filewrite>
    8000477c:	87aa                	mv	a5,a0
}
    8000477e:	853e                	mv	a0,a5
    80004780:	70a2                	ld	ra,40(sp)
    80004782:	7402                	ld	s0,32(sp)
    80004784:	6145                	addi	sp,sp,48
    80004786:	8082                	ret

0000000080004788 <sys_close>:
{
    80004788:	1101                	addi	sp,sp,-32
    8000478a:	ec06                	sd	ra,24(sp)
    8000478c:	e822                	sd	s0,16(sp)
    8000478e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004790:	fe040613          	addi	a2,s0,-32
    80004794:	fec40593          	addi	a1,s0,-20
    80004798:	4501                	li	a0,0
    8000479a:	00000097          	auipc	ra,0x0
    8000479e:	cc2080e7          	jalr	-830(ra) # 8000445c <argfd>
    return -1;
    800047a2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047a4:	02054463          	bltz	a0,800047cc <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047a8:	ffffc097          	auipc	ra,0xffffc
    800047ac:	6c6080e7          	jalr	1734(ra) # 80000e6e <myproc>
    800047b0:	fec42783          	lw	a5,-20(s0)
    800047b4:	07e9                	addi	a5,a5,26
    800047b6:	078e                	slli	a5,a5,0x3
    800047b8:	97aa                	add	a5,a5,a0
    800047ba:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800047be:	fe043503          	ld	a0,-32(s0)
    800047c2:	fffff097          	auipc	ra,0xfffff
    800047c6:	2b0080e7          	jalr	688(ra) # 80003a72 <fileclose>
  return 0;
    800047ca:	4781                	li	a5,0
}
    800047cc:	853e                	mv	a0,a5
    800047ce:	60e2                	ld	ra,24(sp)
    800047d0:	6442                	ld	s0,16(sp)
    800047d2:	6105                	addi	sp,sp,32
    800047d4:	8082                	ret

00000000800047d6 <sys_fstat>:
{
    800047d6:	1101                	addi	sp,sp,-32
    800047d8:	ec06                	sd	ra,24(sp)
    800047da:	e822                	sd	s0,16(sp)
    800047dc:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047de:	fe840613          	addi	a2,s0,-24
    800047e2:	4581                	li	a1,0
    800047e4:	4501                	li	a0,0
    800047e6:	00000097          	auipc	ra,0x0
    800047ea:	c76080e7          	jalr	-906(ra) # 8000445c <argfd>
    return -1;
    800047ee:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047f0:	02054563          	bltz	a0,8000481a <sys_fstat+0x44>
    800047f4:	fe040593          	addi	a1,s0,-32
    800047f8:	4505                	li	a0,1
    800047fa:	ffffd097          	auipc	ra,0xffffd
    800047fe:	780080e7          	jalr	1920(ra) # 80001f7a <argaddr>
    return -1;
    80004802:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004804:	00054b63          	bltz	a0,8000481a <sys_fstat+0x44>
  return filestat(f, st);
    80004808:	fe043583          	ld	a1,-32(s0)
    8000480c:	fe843503          	ld	a0,-24(s0)
    80004810:	fffff097          	auipc	ra,0xfffff
    80004814:	32a080e7          	jalr	810(ra) # 80003b3a <filestat>
    80004818:	87aa                	mv	a5,a0
}
    8000481a:	853e                	mv	a0,a5
    8000481c:	60e2                	ld	ra,24(sp)
    8000481e:	6442                	ld	s0,16(sp)
    80004820:	6105                	addi	sp,sp,32
    80004822:	8082                	ret

0000000080004824 <sys_link>:
{
    80004824:	7169                	addi	sp,sp,-304
    80004826:	f606                	sd	ra,296(sp)
    80004828:	f222                	sd	s0,288(sp)
    8000482a:	ee26                	sd	s1,280(sp)
    8000482c:	ea4a                	sd	s2,272(sp)
    8000482e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004830:	08000613          	li	a2,128
    80004834:	ed040593          	addi	a1,s0,-304
    80004838:	4501                	li	a0,0
    8000483a:	ffffd097          	auipc	ra,0xffffd
    8000483e:	762080e7          	jalr	1890(ra) # 80001f9c <argstr>
    return -1;
    80004842:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004844:	10054e63          	bltz	a0,80004960 <sys_link+0x13c>
    80004848:	08000613          	li	a2,128
    8000484c:	f5040593          	addi	a1,s0,-176
    80004850:	4505                	li	a0,1
    80004852:	ffffd097          	auipc	ra,0xffffd
    80004856:	74a080e7          	jalr	1866(ra) # 80001f9c <argstr>
    return -1;
    8000485a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000485c:	10054263          	bltz	a0,80004960 <sys_link+0x13c>
  begin_op();
    80004860:	fffff097          	auipc	ra,0xfffff
    80004864:	d46080e7          	jalr	-698(ra) # 800035a6 <begin_op>
  if((ip = namei(old)) == 0){
    80004868:	ed040513          	addi	a0,s0,-304
    8000486c:	fffff097          	auipc	ra,0xfffff
    80004870:	b1e080e7          	jalr	-1250(ra) # 8000338a <namei>
    80004874:	84aa                	mv	s1,a0
    80004876:	c551                	beqz	a0,80004902 <sys_link+0xde>
  ilock(ip);
    80004878:	ffffe097          	auipc	ra,0xffffe
    8000487c:	35c080e7          	jalr	860(ra) # 80002bd4 <ilock>
  if(ip->type == T_DIR){
    80004880:	04449703          	lh	a4,68(s1)
    80004884:	4785                	li	a5,1
    80004886:	08f70463          	beq	a4,a5,8000490e <sys_link+0xea>
  ip->nlink++;
    8000488a:	04a4d783          	lhu	a5,74(s1)
    8000488e:	2785                	addiw	a5,a5,1
    80004890:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004894:	8526                	mv	a0,s1
    80004896:	ffffe097          	auipc	ra,0xffffe
    8000489a:	274080e7          	jalr	628(ra) # 80002b0a <iupdate>
  iunlock(ip);
    8000489e:	8526                	mv	a0,s1
    800048a0:	ffffe097          	auipc	ra,0xffffe
    800048a4:	3f6080e7          	jalr	1014(ra) # 80002c96 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048a8:	fd040593          	addi	a1,s0,-48
    800048ac:	f5040513          	addi	a0,s0,-176
    800048b0:	fffff097          	auipc	ra,0xfffff
    800048b4:	af8080e7          	jalr	-1288(ra) # 800033a8 <nameiparent>
    800048b8:	892a                	mv	s2,a0
    800048ba:	c935                	beqz	a0,8000492e <sys_link+0x10a>
  ilock(dp);
    800048bc:	ffffe097          	auipc	ra,0xffffe
    800048c0:	318080e7          	jalr	792(ra) # 80002bd4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048c4:	00092703          	lw	a4,0(s2)
    800048c8:	409c                	lw	a5,0(s1)
    800048ca:	04f71d63          	bne	a4,a5,80004924 <sys_link+0x100>
    800048ce:	40d0                	lw	a2,4(s1)
    800048d0:	fd040593          	addi	a1,s0,-48
    800048d4:	854a                	mv	a0,s2
    800048d6:	fffff097          	auipc	ra,0xfffff
    800048da:	9f2080e7          	jalr	-1550(ra) # 800032c8 <dirlink>
    800048de:	04054363          	bltz	a0,80004924 <sys_link+0x100>
  iunlockput(dp);
    800048e2:	854a                	mv	a0,s2
    800048e4:	ffffe097          	auipc	ra,0xffffe
    800048e8:	552080e7          	jalr	1362(ra) # 80002e36 <iunlockput>
  iput(ip);
    800048ec:	8526                	mv	a0,s1
    800048ee:	ffffe097          	auipc	ra,0xffffe
    800048f2:	4a0080e7          	jalr	1184(ra) # 80002d8e <iput>
  end_op();
    800048f6:	fffff097          	auipc	ra,0xfffff
    800048fa:	d30080e7          	jalr	-720(ra) # 80003626 <end_op>
  return 0;
    800048fe:	4781                	li	a5,0
    80004900:	a085                	j	80004960 <sys_link+0x13c>
    end_op();
    80004902:	fffff097          	auipc	ra,0xfffff
    80004906:	d24080e7          	jalr	-732(ra) # 80003626 <end_op>
    return -1;
    8000490a:	57fd                	li	a5,-1
    8000490c:	a891                	j	80004960 <sys_link+0x13c>
    iunlockput(ip);
    8000490e:	8526                	mv	a0,s1
    80004910:	ffffe097          	auipc	ra,0xffffe
    80004914:	526080e7          	jalr	1318(ra) # 80002e36 <iunlockput>
    end_op();
    80004918:	fffff097          	auipc	ra,0xfffff
    8000491c:	d0e080e7          	jalr	-754(ra) # 80003626 <end_op>
    return -1;
    80004920:	57fd                	li	a5,-1
    80004922:	a83d                	j	80004960 <sys_link+0x13c>
    iunlockput(dp);
    80004924:	854a                	mv	a0,s2
    80004926:	ffffe097          	auipc	ra,0xffffe
    8000492a:	510080e7          	jalr	1296(ra) # 80002e36 <iunlockput>
  ilock(ip);
    8000492e:	8526                	mv	a0,s1
    80004930:	ffffe097          	auipc	ra,0xffffe
    80004934:	2a4080e7          	jalr	676(ra) # 80002bd4 <ilock>
  ip->nlink--;
    80004938:	04a4d783          	lhu	a5,74(s1)
    8000493c:	37fd                	addiw	a5,a5,-1
    8000493e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004942:	8526                	mv	a0,s1
    80004944:	ffffe097          	auipc	ra,0xffffe
    80004948:	1c6080e7          	jalr	454(ra) # 80002b0a <iupdate>
  iunlockput(ip);
    8000494c:	8526                	mv	a0,s1
    8000494e:	ffffe097          	auipc	ra,0xffffe
    80004952:	4e8080e7          	jalr	1256(ra) # 80002e36 <iunlockput>
  end_op();
    80004956:	fffff097          	auipc	ra,0xfffff
    8000495a:	cd0080e7          	jalr	-816(ra) # 80003626 <end_op>
  return -1;
    8000495e:	57fd                	li	a5,-1
}
    80004960:	853e                	mv	a0,a5
    80004962:	70b2                	ld	ra,296(sp)
    80004964:	7412                	ld	s0,288(sp)
    80004966:	64f2                	ld	s1,280(sp)
    80004968:	6952                	ld	s2,272(sp)
    8000496a:	6155                	addi	sp,sp,304
    8000496c:	8082                	ret

000000008000496e <sys_unlink>:
{
    8000496e:	7151                	addi	sp,sp,-240
    80004970:	f586                	sd	ra,232(sp)
    80004972:	f1a2                	sd	s0,224(sp)
    80004974:	eda6                	sd	s1,216(sp)
    80004976:	e9ca                	sd	s2,208(sp)
    80004978:	e5ce                	sd	s3,200(sp)
    8000497a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000497c:	08000613          	li	a2,128
    80004980:	f3040593          	addi	a1,s0,-208
    80004984:	4501                	li	a0,0
    80004986:	ffffd097          	auipc	ra,0xffffd
    8000498a:	616080e7          	jalr	1558(ra) # 80001f9c <argstr>
    8000498e:	18054163          	bltz	a0,80004b10 <sys_unlink+0x1a2>
  begin_op();
    80004992:	fffff097          	auipc	ra,0xfffff
    80004996:	c14080e7          	jalr	-1004(ra) # 800035a6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000499a:	fb040593          	addi	a1,s0,-80
    8000499e:	f3040513          	addi	a0,s0,-208
    800049a2:	fffff097          	auipc	ra,0xfffff
    800049a6:	a06080e7          	jalr	-1530(ra) # 800033a8 <nameiparent>
    800049aa:	84aa                	mv	s1,a0
    800049ac:	c979                	beqz	a0,80004a82 <sys_unlink+0x114>
  ilock(dp);
    800049ae:	ffffe097          	auipc	ra,0xffffe
    800049b2:	226080e7          	jalr	550(ra) # 80002bd4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049b6:	00004597          	auipc	a1,0x4
    800049ba:	e5258593          	addi	a1,a1,-430 # 80008808 <syscalls+0x2b8>
    800049be:	fb040513          	addi	a0,s0,-80
    800049c2:	ffffe097          	auipc	ra,0xffffe
    800049c6:	6dc080e7          	jalr	1756(ra) # 8000309e <namecmp>
    800049ca:	14050a63          	beqz	a0,80004b1e <sys_unlink+0x1b0>
    800049ce:	00004597          	auipc	a1,0x4
    800049d2:	e4258593          	addi	a1,a1,-446 # 80008810 <syscalls+0x2c0>
    800049d6:	fb040513          	addi	a0,s0,-80
    800049da:	ffffe097          	auipc	ra,0xffffe
    800049de:	6c4080e7          	jalr	1732(ra) # 8000309e <namecmp>
    800049e2:	12050e63          	beqz	a0,80004b1e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049e6:	f2c40613          	addi	a2,s0,-212
    800049ea:	fb040593          	addi	a1,s0,-80
    800049ee:	8526                	mv	a0,s1
    800049f0:	ffffe097          	auipc	ra,0xffffe
    800049f4:	6c8080e7          	jalr	1736(ra) # 800030b8 <dirlookup>
    800049f8:	892a                	mv	s2,a0
    800049fa:	12050263          	beqz	a0,80004b1e <sys_unlink+0x1b0>
  ilock(ip);
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	1d6080e7          	jalr	470(ra) # 80002bd4 <ilock>
  if(ip->nlink < 1)
    80004a06:	04a91783          	lh	a5,74(s2)
    80004a0a:	08f05263          	blez	a5,80004a8e <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a0e:	04491703          	lh	a4,68(s2)
    80004a12:	4785                	li	a5,1
    80004a14:	08f70563          	beq	a4,a5,80004a9e <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a18:	4641                	li	a2,16
    80004a1a:	4581                	li	a1,0
    80004a1c:	fc040513          	addi	a0,s0,-64
    80004a20:	ffffb097          	auipc	ra,0xffffb
    80004a24:	77e080e7          	jalr	1918(ra) # 8000019e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a28:	4741                	li	a4,16
    80004a2a:	f2c42683          	lw	a3,-212(s0)
    80004a2e:	fc040613          	addi	a2,s0,-64
    80004a32:	4581                	li	a1,0
    80004a34:	8526                	mv	a0,s1
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	54a080e7          	jalr	1354(ra) # 80002f80 <writei>
    80004a3e:	47c1                	li	a5,16
    80004a40:	0af51563          	bne	a0,a5,80004aea <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a44:	04491703          	lh	a4,68(s2)
    80004a48:	4785                	li	a5,1
    80004a4a:	0af70863          	beq	a4,a5,80004afa <sys_unlink+0x18c>
  iunlockput(dp);
    80004a4e:	8526                	mv	a0,s1
    80004a50:	ffffe097          	auipc	ra,0xffffe
    80004a54:	3e6080e7          	jalr	998(ra) # 80002e36 <iunlockput>
  ip->nlink--;
    80004a58:	04a95783          	lhu	a5,74(s2)
    80004a5c:	37fd                	addiw	a5,a5,-1
    80004a5e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a62:	854a                	mv	a0,s2
    80004a64:	ffffe097          	auipc	ra,0xffffe
    80004a68:	0a6080e7          	jalr	166(ra) # 80002b0a <iupdate>
  iunlockput(ip);
    80004a6c:	854a                	mv	a0,s2
    80004a6e:	ffffe097          	auipc	ra,0xffffe
    80004a72:	3c8080e7          	jalr	968(ra) # 80002e36 <iunlockput>
  end_op();
    80004a76:	fffff097          	auipc	ra,0xfffff
    80004a7a:	bb0080e7          	jalr	-1104(ra) # 80003626 <end_op>
  return 0;
    80004a7e:	4501                	li	a0,0
    80004a80:	a84d                	j	80004b32 <sys_unlink+0x1c4>
    end_op();
    80004a82:	fffff097          	auipc	ra,0xfffff
    80004a86:	ba4080e7          	jalr	-1116(ra) # 80003626 <end_op>
    return -1;
    80004a8a:	557d                	li	a0,-1
    80004a8c:	a05d                	j	80004b32 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a8e:	00004517          	auipc	a0,0x4
    80004a92:	daa50513          	addi	a0,a0,-598 # 80008838 <syscalls+0x2e8>
    80004a96:	00001097          	auipc	ra,0x1
    80004a9a:	1f2080e7          	jalr	498(ra) # 80005c88 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a9e:	04c92703          	lw	a4,76(s2)
    80004aa2:	02000793          	li	a5,32
    80004aa6:	f6e7f9e3          	bgeu	a5,a4,80004a18 <sys_unlink+0xaa>
    80004aaa:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004aae:	4741                	li	a4,16
    80004ab0:	86ce                	mv	a3,s3
    80004ab2:	f1840613          	addi	a2,s0,-232
    80004ab6:	4581                	li	a1,0
    80004ab8:	854a                	mv	a0,s2
    80004aba:	ffffe097          	auipc	ra,0xffffe
    80004abe:	3ce080e7          	jalr	974(ra) # 80002e88 <readi>
    80004ac2:	47c1                	li	a5,16
    80004ac4:	00f51b63          	bne	a0,a5,80004ada <sys_unlink+0x16c>
    if(de.inum != 0)
    80004ac8:	f1845783          	lhu	a5,-232(s0)
    80004acc:	e7a1                	bnez	a5,80004b14 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ace:	29c1                	addiw	s3,s3,16
    80004ad0:	04c92783          	lw	a5,76(s2)
    80004ad4:	fcf9ede3          	bltu	s3,a5,80004aae <sys_unlink+0x140>
    80004ad8:	b781                	j	80004a18 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ada:	00004517          	auipc	a0,0x4
    80004ade:	d7650513          	addi	a0,a0,-650 # 80008850 <syscalls+0x300>
    80004ae2:	00001097          	auipc	ra,0x1
    80004ae6:	1a6080e7          	jalr	422(ra) # 80005c88 <panic>
    panic("unlink: writei");
    80004aea:	00004517          	auipc	a0,0x4
    80004aee:	d7e50513          	addi	a0,a0,-642 # 80008868 <syscalls+0x318>
    80004af2:	00001097          	auipc	ra,0x1
    80004af6:	196080e7          	jalr	406(ra) # 80005c88 <panic>
    dp->nlink--;
    80004afa:	04a4d783          	lhu	a5,74(s1)
    80004afe:	37fd                	addiw	a5,a5,-1
    80004b00:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b04:	8526                	mv	a0,s1
    80004b06:	ffffe097          	auipc	ra,0xffffe
    80004b0a:	004080e7          	jalr	4(ra) # 80002b0a <iupdate>
    80004b0e:	b781                	j	80004a4e <sys_unlink+0xe0>
    return -1;
    80004b10:	557d                	li	a0,-1
    80004b12:	a005                	j	80004b32 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b14:	854a                	mv	a0,s2
    80004b16:	ffffe097          	auipc	ra,0xffffe
    80004b1a:	320080e7          	jalr	800(ra) # 80002e36 <iunlockput>
  iunlockput(dp);
    80004b1e:	8526                	mv	a0,s1
    80004b20:	ffffe097          	auipc	ra,0xffffe
    80004b24:	316080e7          	jalr	790(ra) # 80002e36 <iunlockput>
  end_op();
    80004b28:	fffff097          	auipc	ra,0xfffff
    80004b2c:	afe080e7          	jalr	-1282(ra) # 80003626 <end_op>
  return -1;
    80004b30:	557d                	li	a0,-1
}
    80004b32:	70ae                	ld	ra,232(sp)
    80004b34:	740e                	ld	s0,224(sp)
    80004b36:	64ee                	ld	s1,216(sp)
    80004b38:	694e                	ld	s2,208(sp)
    80004b3a:	69ae                	ld	s3,200(sp)
    80004b3c:	616d                	addi	sp,sp,240
    80004b3e:	8082                	ret

0000000080004b40 <sys_open>:

uint64
sys_open(void)
{
    80004b40:	7131                	addi	sp,sp,-192
    80004b42:	fd06                	sd	ra,184(sp)
    80004b44:	f922                	sd	s0,176(sp)
    80004b46:	f526                	sd	s1,168(sp)
    80004b48:	f14a                	sd	s2,160(sp)
    80004b4a:	ed4e                	sd	s3,152(sp)
    80004b4c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b4e:	08000613          	li	a2,128
    80004b52:	f5040593          	addi	a1,s0,-176
    80004b56:	4501                	li	a0,0
    80004b58:	ffffd097          	auipc	ra,0xffffd
    80004b5c:	444080e7          	jalr	1092(ra) # 80001f9c <argstr>
    return -1;
    80004b60:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b62:	0c054163          	bltz	a0,80004c24 <sys_open+0xe4>
    80004b66:	f4c40593          	addi	a1,s0,-180
    80004b6a:	4505                	li	a0,1
    80004b6c:	ffffd097          	auipc	ra,0xffffd
    80004b70:	3ec080e7          	jalr	1004(ra) # 80001f58 <argint>
    80004b74:	0a054863          	bltz	a0,80004c24 <sys_open+0xe4>

  begin_op();
    80004b78:	fffff097          	auipc	ra,0xfffff
    80004b7c:	a2e080e7          	jalr	-1490(ra) # 800035a6 <begin_op>

  if(omode & O_CREATE){
    80004b80:	f4c42783          	lw	a5,-180(s0)
    80004b84:	2007f793          	andi	a5,a5,512
    80004b88:	cbdd                	beqz	a5,80004c3e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b8a:	4681                	li	a3,0
    80004b8c:	4601                	li	a2,0
    80004b8e:	4589                	li	a1,2
    80004b90:	f5040513          	addi	a0,s0,-176
    80004b94:	00000097          	auipc	ra,0x0
    80004b98:	972080e7          	jalr	-1678(ra) # 80004506 <create>
    80004b9c:	892a                	mv	s2,a0
    if(ip == 0){
    80004b9e:	c959                	beqz	a0,80004c34 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ba0:	04491703          	lh	a4,68(s2)
    80004ba4:	478d                	li	a5,3
    80004ba6:	00f71763          	bne	a4,a5,80004bb4 <sys_open+0x74>
    80004baa:	04695703          	lhu	a4,70(s2)
    80004bae:	47a5                	li	a5,9
    80004bb0:	0ce7ec63          	bltu	a5,a4,80004c88 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bb4:	fffff097          	auipc	ra,0xfffff
    80004bb8:	e02080e7          	jalr	-510(ra) # 800039b6 <filealloc>
    80004bbc:	89aa                	mv	s3,a0
    80004bbe:	10050263          	beqz	a0,80004cc2 <sys_open+0x182>
    80004bc2:	00000097          	auipc	ra,0x0
    80004bc6:	902080e7          	jalr	-1790(ra) # 800044c4 <fdalloc>
    80004bca:	84aa                	mv	s1,a0
    80004bcc:	0e054663          	bltz	a0,80004cb8 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004bd0:	04491703          	lh	a4,68(s2)
    80004bd4:	478d                	li	a5,3
    80004bd6:	0cf70463          	beq	a4,a5,80004c9e <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bda:	4789                	li	a5,2
    80004bdc:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004be0:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004be4:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004be8:	f4c42783          	lw	a5,-180(s0)
    80004bec:	0017c713          	xori	a4,a5,1
    80004bf0:	8b05                	andi	a4,a4,1
    80004bf2:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bf6:	0037f713          	andi	a4,a5,3
    80004bfa:	00e03733          	snez	a4,a4
    80004bfe:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c02:	4007f793          	andi	a5,a5,1024
    80004c06:	c791                	beqz	a5,80004c12 <sys_open+0xd2>
    80004c08:	04491703          	lh	a4,68(s2)
    80004c0c:	4789                	li	a5,2
    80004c0e:	08f70f63          	beq	a4,a5,80004cac <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c12:	854a                	mv	a0,s2
    80004c14:	ffffe097          	auipc	ra,0xffffe
    80004c18:	082080e7          	jalr	130(ra) # 80002c96 <iunlock>
  end_op();
    80004c1c:	fffff097          	auipc	ra,0xfffff
    80004c20:	a0a080e7          	jalr	-1526(ra) # 80003626 <end_op>

  return fd;
}
    80004c24:	8526                	mv	a0,s1
    80004c26:	70ea                	ld	ra,184(sp)
    80004c28:	744a                	ld	s0,176(sp)
    80004c2a:	74aa                	ld	s1,168(sp)
    80004c2c:	790a                	ld	s2,160(sp)
    80004c2e:	69ea                	ld	s3,152(sp)
    80004c30:	6129                	addi	sp,sp,192
    80004c32:	8082                	ret
      end_op();
    80004c34:	fffff097          	auipc	ra,0xfffff
    80004c38:	9f2080e7          	jalr	-1550(ra) # 80003626 <end_op>
      return -1;
    80004c3c:	b7e5                	j	80004c24 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c3e:	f5040513          	addi	a0,s0,-176
    80004c42:	ffffe097          	auipc	ra,0xffffe
    80004c46:	748080e7          	jalr	1864(ra) # 8000338a <namei>
    80004c4a:	892a                	mv	s2,a0
    80004c4c:	c905                	beqz	a0,80004c7c <sys_open+0x13c>
    ilock(ip);
    80004c4e:	ffffe097          	auipc	ra,0xffffe
    80004c52:	f86080e7          	jalr	-122(ra) # 80002bd4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c56:	04491703          	lh	a4,68(s2)
    80004c5a:	4785                	li	a5,1
    80004c5c:	f4f712e3          	bne	a4,a5,80004ba0 <sys_open+0x60>
    80004c60:	f4c42783          	lw	a5,-180(s0)
    80004c64:	dba1                	beqz	a5,80004bb4 <sys_open+0x74>
      iunlockput(ip);
    80004c66:	854a                	mv	a0,s2
    80004c68:	ffffe097          	auipc	ra,0xffffe
    80004c6c:	1ce080e7          	jalr	462(ra) # 80002e36 <iunlockput>
      end_op();
    80004c70:	fffff097          	auipc	ra,0xfffff
    80004c74:	9b6080e7          	jalr	-1610(ra) # 80003626 <end_op>
      return -1;
    80004c78:	54fd                	li	s1,-1
    80004c7a:	b76d                	j	80004c24 <sys_open+0xe4>
      end_op();
    80004c7c:	fffff097          	auipc	ra,0xfffff
    80004c80:	9aa080e7          	jalr	-1622(ra) # 80003626 <end_op>
      return -1;
    80004c84:	54fd                	li	s1,-1
    80004c86:	bf79                	j	80004c24 <sys_open+0xe4>
    iunlockput(ip);
    80004c88:	854a                	mv	a0,s2
    80004c8a:	ffffe097          	auipc	ra,0xffffe
    80004c8e:	1ac080e7          	jalr	428(ra) # 80002e36 <iunlockput>
    end_op();
    80004c92:	fffff097          	auipc	ra,0xfffff
    80004c96:	994080e7          	jalr	-1644(ra) # 80003626 <end_op>
    return -1;
    80004c9a:	54fd                	li	s1,-1
    80004c9c:	b761                	j	80004c24 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c9e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004ca2:	04691783          	lh	a5,70(s2)
    80004ca6:	02f99223          	sh	a5,36(s3)
    80004caa:	bf2d                	j	80004be4 <sys_open+0xa4>
    itrunc(ip);
    80004cac:	854a                	mv	a0,s2
    80004cae:	ffffe097          	auipc	ra,0xffffe
    80004cb2:	034080e7          	jalr	52(ra) # 80002ce2 <itrunc>
    80004cb6:	bfb1                	j	80004c12 <sys_open+0xd2>
      fileclose(f);
    80004cb8:	854e                	mv	a0,s3
    80004cba:	fffff097          	auipc	ra,0xfffff
    80004cbe:	db8080e7          	jalr	-584(ra) # 80003a72 <fileclose>
    iunlockput(ip);
    80004cc2:	854a                	mv	a0,s2
    80004cc4:	ffffe097          	auipc	ra,0xffffe
    80004cc8:	172080e7          	jalr	370(ra) # 80002e36 <iunlockput>
    end_op();
    80004ccc:	fffff097          	auipc	ra,0xfffff
    80004cd0:	95a080e7          	jalr	-1702(ra) # 80003626 <end_op>
    return -1;
    80004cd4:	54fd                	li	s1,-1
    80004cd6:	b7b9                	j	80004c24 <sys_open+0xe4>

0000000080004cd8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cd8:	7175                	addi	sp,sp,-144
    80004cda:	e506                	sd	ra,136(sp)
    80004cdc:	e122                	sd	s0,128(sp)
    80004cde:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004ce0:	fffff097          	auipc	ra,0xfffff
    80004ce4:	8c6080e7          	jalr	-1850(ra) # 800035a6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004ce8:	08000613          	li	a2,128
    80004cec:	f7040593          	addi	a1,s0,-144
    80004cf0:	4501                	li	a0,0
    80004cf2:	ffffd097          	auipc	ra,0xffffd
    80004cf6:	2aa080e7          	jalr	682(ra) # 80001f9c <argstr>
    80004cfa:	02054963          	bltz	a0,80004d2c <sys_mkdir+0x54>
    80004cfe:	4681                	li	a3,0
    80004d00:	4601                	li	a2,0
    80004d02:	4585                	li	a1,1
    80004d04:	f7040513          	addi	a0,s0,-144
    80004d08:	fffff097          	auipc	ra,0xfffff
    80004d0c:	7fe080e7          	jalr	2046(ra) # 80004506 <create>
    80004d10:	cd11                	beqz	a0,80004d2c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d12:	ffffe097          	auipc	ra,0xffffe
    80004d16:	124080e7          	jalr	292(ra) # 80002e36 <iunlockput>
  end_op();
    80004d1a:	fffff097          	auipc	ra,0xfffff
    80004d1e:	90c080e7          	jalr	-1780(ra) # 80003626 <end_op>
  return 0;
    80004d22:	4501                	li	a0,0
}
    80004d24:	60aa                	ld	ra,136(sp)
    80004d26:	640a                	ld	s0,128(sp)
    80004d28:	6149                	addi	sp,sp,144
    80004d2a:	8082                	ret
    end_op();
    80004d2c:	fffff097          	auipc	ra,0xfffff
    80004d30:	8fa080e7          	jalr	-1798(ra) # 80003626 <end_op>
    return -1;
    80004d34:	557d                	li	a0,-1
    80004d36:	b7fd                	j	80004d24 <sys_mkdir+0x4c>

0000000080004d38 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d38:	7135                	addi	sp,sp,-160
    80004d3a:	ed06                	sd	ra,152(sp)
    80004d3c:	e922                	sd	s0,144(sp)
    80004d3e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d40:	fffff097          	auipc	ra,0xfffff
    80004d44:	866080e7          	jalr	-1946(ra) # 800035a6 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d48:	08000613          	li	a2,128
    80004d4c:	f7040593          	addi	a1,s0,-144
    80004d50:	4501                	li	a0,0
    80004d52:	ffffd097          	auipc	ra,0xffffd
    80004d56:	24a080e7          	jalr	586(ra) # 80001f9c <argstr>
    80004d5a:	04054a63          	bltz	a0,80004dae <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d5e:	f6c40593          	addi	a1,s0,-148
    80004d62:	4505                	li	a0,1
    80004d64:	ffffd097          	auipc	ra,0xffffd
    80004d68:	1f4080e7          	jalr	500(ra) # 80001f58 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d6c:	04054163          	bltz	a0,80004dae <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d70:	f6840593          	addi	a1,s0,-152
    80004d74:	4509                	li	a0,2
    80004d76:	ffffd097          	auipc	ra,0xffffd
    80004d7a:	1e2080e7          	jalr	482(ra) # 80001f58 <argint>
     argint(1, &major) < 0 ||
    80004d7e:	02054863          	bltz	a0,80004dae <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d82:	f6841683          	lh	a3,-152(s0)
    80004d86:	f6c41603          	lh	a2,-148(s0)
    80004d8a:	458d                	li	a1,3
    80004d8c:	f7040513          	addi	a0,s0,-144
    80004d90:	fffff097          	auipc	ra,0xfffff
    80004d94:	776080e7          	jalr	1910(ra) # 80004506 <create>
     argint(2, &minor) < 0 ||
    80004d98:	c919                	beqz	a0,80004dae <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d9a:	ffffe097          	auipc	ra,0xffffe
    80004d9e:	09c080e7          	jalr	156(ra) # 80002e36 <iunlockput>
  end_op();
    80004da2:	fffff097          	auipc	ra,0xfffff
    80004da6:	884080e7          	jalr	-1916(ra) # 80003626 <end_op>
  return 0;
    80004daa:	4501                	li	a0,0
    80004dac:	a031                	j	80004db8 <sys_mknod+0x80>
    end_op();
    80004dae:	fffff097          	auipc	ra,0xfffff
    80004db2:	878080e7          	jalr	-1928(ra) # 80003626 <end_op>
    return -1;
    80004db6:	557d                	li	a0,-1
}
    80004db8:	60ea                	ld	ra,152(sp)
    80004dba:	644a                	ld	s0,144(sp)
    80004dbc:	610d                	addi	sp,sp,160
    80004dbe:	8082                	ret

0000000080004dc0 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004dc0:	7135                	addi	sp,sp,-160
    80004dc2:	ed06                	sd	ra,152(sp)
    80004dc4:	e922                	sd	s0,144(sp)
    80004dc6:	e526                	sd	s1,136(sp)
    80004dc8:	e14a                	sd	s2,128(sp)
    80004dca:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004dcc:	ffffc097          	auipc	ra,0xffffc
    80004dd0:	0a2080e7          	jalr	162(ra) # 80000e6e <myproc>
    80004dd4:	892a                	mv	s2,a0
  
  begin_op();
    80004dd6:	ffffe097          	auipc	ra,0xffffe
    80004dda:	7d0080e7          	jalr	2000(ra) # 800035a6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004dde:	08000613          	li	a2,128
    80004de2:	f6040593          	addi	a1,s0,-160
    80004de6:	4501                	li	a0,0
    80004de8:	ffffd097          	auipc	ra,0xffffd
    80004dec:	1b4080e7          	jalr	436(ra) # 80001f9c <argstr>
    80004df0:	04054b63          	bltz	a0,80004e46 <sys_chdir+0x86>
    80004df4:	f6040513          	addi	a0,s0,-160
    80004df8:	ffffe097          	auipc	ra,0xffffe
    80004dfc:	592080e7          	jalr	1426(ra) # 8000338a <namei>
    80004e00:	84aa                	mv	s1,a0
    80004e02:	c131                	beqz	a0,80004e46 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e04:	ffffe097          	auipc	ra,0xffffe
    80004e08:	dd0080e7          	jalr	-560(ra) # 80002bd4 <ilock>
  if(ip->type != T_DIR){
    80004e0c:	04449703          	lh	a4,68(s1)
    80004e10:	4785                	li	a5,1
    80004e12:	04f71063          	bne	a4,a5,80004e52 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e16:	8526                	mv	a0,s1
    80004e18:	ffffe097          	auipc	ra,0xffffe
    80004e1c:	e7e080e7          	jalr	-386(ra) # 80002c96 <iunlock>
  iput(p->cwd);
    80004e20:	15093503          	ld	a0,336(s2)
    80004e24:	ffffe097          	auipc	ra,0xffffe
    80004e28:	f6a080e7          	jalr	-150(ra) # 80002d8e <iput>
  end_op();
    80004e2c:	ffffe097          	auipc	ra,0xffffe
    80004e30:	7fa080e7          	jalr	2042(ra) # 80003626 <end_op>
  p->cwd = ip;
    80004e34:	14993823          	sd	s1,336(s2)
  return 0;
    80004e38:	4501                	li	a0,0
}
    80004e3a:	60ea                	ld	ra,152(sp)
    80004e3c:	644a                	ld	s0,144(sp)
    80004e3e:	64aa                	ld	s1,136(sp)
    80004e40:	690a                	ld	s2,128(sp)
    80004e42:	610d                	addi	sp,sp,160
    80004e44:	8082                	ret
    end_op();
    80004e46:	ffffe097          	auipc	ra,0xffffe
    80004e4a:	7e0080e7          	jalr	2016(ra) # 80003626 <end_op>
    return -1;
    80004e4e:	557d                	li	a0,-1
    80004e50:	b7ed                	j	80004e3a <sys_chdir+0x7a>
    iunlockput(ip);
    80004e52:	8526                	mv	a0,s1
    80004e54:	ffffe097          	auipc	ra,0xffffe
    80004e58:	fe2080e7          	jalr	-30(ra) # 80002e36 <iunlockput>
    end_op();
    80004e5c:	ffffe097          	auipc	ra,0xffffe
    80004e60:	7ca080e7          	jalr	1994(ra) # 80003626 <end_op>
    return -1;
    80004e64:	557d                	li	a0,-1
    80004e66:	bfd1                	j	80004e3a <sys_chdir+0x7a>

0000000080004e68 <sys_exec>:

uint64
sys_exec(void)
{
    80004e68:	7145                	addi	sp,sp,-464
    80004e6a:	e786                	sd	ra,456(sp)
    80004e6c:	e3a2                	sd	s0,448(sp)
    80004e6e:	ff26                	sd	s1,440(sp)
    80004e70:	fb4a                	sd	s2,432(sp)
    80004e72:	f74e                	sd	s3,424(sp)
    80004e74:	f352                	sd	s4,416(sp)
    80004e76:	ef56                	sd	s5,408(sp)
    80004e78:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e7a:	08000613          	li	a2,128
    80004e7e:	f4040593          	addi	a1,s0,-192
    80004e82:	4501                	li	a0,0
    80004e84:	ffffd097          	auipc	ra,0xffffd
    80004e88:	118080e7          	jalr	280(ra) # 80001f9c <argstr>
    return -1;
    80004e8c:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e8e:	0c054a63          	bltz	a0,80004f62 <sys_exec+0xfa>
    80004e92:	e3840593          	addi	a1,s0,-456
    80004e96:	4505                	li	a0,1
    80004e98:	ffffd097          	auipc	ra,0xffffd
    80004e9c:	0e2080e7          	jalr	226(ra) # 80001f7a <argaddr>
    80004ea0:	0c054163          	bltz	a0,80004f62 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004ea4:	10000613          	li	a2,256
    80004ea8:	4581                	li	a1,0
    80004eaa:	e4040513          	addi	a0,s0,-448
    80004eae:	ffffb097          	auipc	ra,0xffffb
    80004eb2:	2f0080e7          	jalr	752(ra) # 8000019e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004eb6:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004eba:	89a6                	mv	s3,s1
    80004ebc:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ebe:	02000a13          	li	s4,32
    80004ec2:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ec6:	00391513          	slli	a0,s2,0x3
    80004eca:	e3040593          	addi	a1,s0,-464
    80004ece:	e3843783          	ld	a5,-456(s0)
    80004ed2:	953e                	add	a0,a0,a5
    80004ed4:	ffffd097          	auipc	ra,0xffffd
    80004ed8:	fea080e7          	jalr	-22(ra) # 80001ebe <fetchaddr>
    80004edc:	02054a63          	bltz	a0,80004f10 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004ee0:	e3043783          	ld	a5,-464(s0)
    80004ee4:	c3b9                	beqz	a5,80004f2a <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ee6:	ffffb097          	auipc	ra,0xffffb
    80004eea:	232080e7          	jalr	562(ra) # 80000118 <kalloc>
    80004eee:	85aa                	mv	a1,a0
    80004ef0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ef4:	cd11                	beqz	a0,80004f10 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ef6:	6605                	lui	a2,0x1
    80004ef8:	e3043503          	ld	a0,-464(s0)
    80004efc:	ffffd097          	auipc	ra,0xffffd
    80004f00:	014080e7          	jalr	20(ra) # 80001f10 <fetchstr>
    80004f04:	00054663          	bltz	a0,80004f10 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004f08:	0905                	addi	s2,s2,1
    80004f0a:	09a1                	addi	s3,s3,8
    80004f0c:	fb491be3          	bne	s2,s4,80004ec2 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f10:	10048913          	addi	s2,s1,256
    80004f14:	6088                	ld	a0,0(s1)
    80004f16:	c529                	beqz	a0,80004f60 <sys_exec+0xf8>
    kfree(argv[i]);
    80004f18:	ffffb097          	auipc	ra,0xffffb
    80004f1c:	104080e7          	jalr	260(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f20:	04a1                	addi	s1,s1,8
    80004f22:	ff2499e3          	bne	s1,s2,80004f14 <sys_exec+0xac>
  return -1;
    80004f26:	597d                	li	s2,-1
    80004f28:	a82d                	j	80004f62 <sys_exec+0xfa>
      argv[i] = 0;
    80004f2a:	0a8e                	slli	s5,s5,0x3
    80004f2c:	fc040793          	addi	a5,s0,-64
    80004f30:	9abe                	add	s5,s5,a5
    80004f32:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f36:	e4040593          	addi	a1,s0,-448
    80004f3a:	f4040513          	addi	a0,s0,-192
    80004f3e:	fffff097          	auipc	ra,0xfffff
    80004f42:	194080e7          	jalr	404(ra) # 800040d2 <exec>
    80004f46:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f48:	10048993          	addi	s3,s1,256
    80004f4c:	6088                	ld	a0,0(s1)
    80004f4e:	c911                	beqz	a0,80004f62 <sys_exec+0xfa>
    kfree(argv[i]);
    80004f50:	ffffb097          	auipc	ra,0xffffb
    80004f54:	0cc080e7          	jalr	204(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f58:	04a1                	addi	s1,s1,8
    80004f5a:	ff3499e3          	bne	s1,s3,80004f4c <sys_exec+0xe4>
    80004f5e:	a011                	j	80004f62 <sys_exec+0xfa>
  return -1;
    80004f60:	597d                	li	s2,-1
}
    80004f62:	854a                	mv	a0,s2
    80004f64:	60be                	ld	ra,456(sp)
    80004f66:	641e                	ld	s0,448(sp)
    80004f68:	74fa                	ld	s1,440(sp)
    80004f6a:	795a                	ld	s2,432(sp)
    80004f6c:	79ba                	ld	s3,424(sp)
    80004f6e:	7a1a                	ld	s4,416(sp)
    80004f70:	6afa                	ld	s5,408(sp)
    80004f72:	6179                	addi	sp,sp,464
    80004f74:	8082                	ret

0000000080004f76 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f76:	7139                	addi	sp,sp,-64
    80004f78:	fc06                	sd	ra,56(sp)
    80004f7a:	f822                	sd	s0,48(sp)
    80004f7c:	f426                	sd	s1,40(sp)
    80004f7e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f80:	ffffc097          	auipc	ra,0xffffc
    80004f84:	eee080e7          	jalr	-274(ra) # 80000e6e <myproc>
    80004f88:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f8a:	fd840593          	addi	a1,s0,-40
    80004f8e:	4501                	li	a0,0
    80004f90:	ffffd097          	auipc	ra,0xffffd
    80004f94:	fea080e7          	jalr	-22(ra) # 80001f7a <argaddr>
    return -1;
    80004f98:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f9a:	0e054063          	bltz	a0,8000507a <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f9e:	fc840593          	addi	a1,s0,-56
    80004fa2:	fd040513          	addi	a0,s0,-48
    80004fa6:	fffff097          	auipc	ra,0xfffff
    80004faa:	dfc080e7          	jalr	-516(ra) # 80003da2 <pipealloc>
    return -1;
    80004fae:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fb0:	0c054563          	bltz	a0,8000507a <sys_pipe+0x104>
  fd0 = -1;
    80004fb4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fb8:	fd043503          	ld	a0,-48(s0)
    80004fbc:	fffff097          	auipc	ra,0xfffff
    80004fc0:	508080e7          	jalr	1288(ra) # 800044c4 <fdalloc>
    80004fc4:	fca42223          	sw	a0,-60(s0)
    80004fc8:	08054c63          	bltz	a0,80005060 <sys_pipe+0xea>
    80004fcc:	fc843503          	ld	a0,-56(s0)
    80004fd0:	fffff097          	auipc	ra,0xfffff
    80004fd4:	4f4080e7          	jalr	1268(ra) # 800044c4 <fdalloc>
    80004fd8:	fca42023          	sw	a0,-64(s0)
    80004fdc:	06054863          	bltz	a0,8000504c <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fe0:	4691                	li	a3,4
    80004fe2:	fc440613          	addi	a2,s0,-60
    80004fe6:	fd843583          	ld	a1,-40(s0)
    80004fea:	68a8                	ld	a0,80(s1)
    80004fec:	ffffc097          	auipc	ra,0xffffc
    80004ff0:	b44080e7          	jalr	-1212(ra) # 80000b30 <copyout>
    80004ff4:	02054063          	bltz	a0,80005014 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004ff8:	4691                	li	a3,4
    80004ffa:	fc040613          	addi	a2,s0,-64
    80004ffe:	fd843583          	ld	a1,-40(s0)
    80005002:	0591                	addi	a1,a1,4
    80005004:	68a8                	ld	a0,80(s1)
    80005006:	ffffc097          	auipc	ra,0xffffc
    8000500a:	b2a080e7          	jalr	-1238(ra) # 80000b30 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000500e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005010:	06055563          	bgez	a0,8000507a <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005014:	fc442783          	lw	a5,-60(s0)
    80005018:	07e9                	addi	a5,a5,26
    8000501a:	078e                	slli	a5,a5,0x3
    8000501c:	97a6                	add	a5,a5,s1
    8000501e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005022:	fc042503          	lw	a0,-64(s0)
    80005026:	0569                	addi	a0,a0,26
    80005028:	050e                	slli	a0,a0,0x3
    8000502a:	9526                	add	a0,a0,s1
    8000502c:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005030:	fd043503          	ld	a0,-48(s0)
    80005034:	fffff097          	auipc	ra,0xfffff
    80005038:	a3e080e7          	jalr	-1474(ra) # 80003a72 <fileclose>
    fileclose(wf);
    8000503c:	fc843503          	ld	a0,-56(s0)
    80005040:	fffff097          	auipc	ra,0xfffff
    80005044:	a32080e7          	jalr	-1486(ra) # 80003a72 <fileclose>
    return -1;
    80005048:	57fd                	li	a5,-1
    8000504a:	a805                	j	8000507a <sys_pipe+0x104>
    if(fd0 >= 0)
    8000504c:	fc442783          	lw	a5,-60(s0)
    80005050:	0007c863          	bltz	a5,80005060 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005054:	01a78513          	addi	a0,a5,26
    80005058:	050e                	slli	a0,a0,0x3
    8000505a:	9526                	add	a0,a0,s1
    8000505c:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005060:	fd043503          	ld	a0,-48(s0)
    80005064:	fffff097          	auipc	ra,0xfffff
    80005068:	a0e080e7          	jalr	-1522(ra) # 80003a72 <fileclose>
    fileclose(wf);
    8000506c:	fc843503          	ld	a0,-56(s0)
    80005070:	fffff097          	auipc	ra,0xfffff
    80005074:	a02080e7          	jalr	-1534(ra) # 80003a72 <fileclose>
    return -1;
    80005078:	57fd                	li	a5,-1
}
    8000507a:	853e                	mv	a0,a5
    8000507c:	70e2                	ld	ra,56(sp)
    8000507e:	7442                	ld	s0,48(sp)
    80005080:	74a2                	ld	s1,40(sp)
    80005082:	6121                	addi	sp,sp,64
    80005084:	8082                	ret
	...

0000000080005090 <kernelvec>:
    80005090:	7111                	addi	sp,sp,-256
    80005092:	e006                	sd	ra,0(sp)
    80005094:	e40a                	sd	sp,8(sp)
    80005096:	e80e                	sd	gp,16(sp)
    80005098:	ec12                	sd	tp,24(sp)
    8000509a:	f016                	sd	t0,32(sp)
    8000509c:	f41a                	sd	t1,40(sp)
    8000509e:	f81e                	sd	t2,48(sp)
    800050a0:	fc22                	sd	s0,56(sp)
    800050a2:	e0a6                	sd	s1,64(sp)
    800050a4:	e4aa                	sd	a0,72(sp)
    800050a6:	e8ae                	sd	a1,80(sp)
    800050a8:	ecb2                	sd	a2,88(sp)
    800050aa:	f0b6                	sd	a3,96(sp)
    800050ac:	f4ba                	sd	a4,104(sp)
    800050ae:	f8be                	sd	a5,112(sp)
    800050b0:	fcc2                	sd	a6,120(sp)
    800050b2:	e146                	sd	a7,128(sp)
    800050b4:	e54a                	sd	s2,136(sp)
    800050b6:	e94e                	sd	s3,144(sp)
    800050b8:	ed52                	sd	s4,152(sp)
    800050ba:	f156                	sd	s5,160(sp)
    800050bc:	f55a                	sd	s6,168(sp)
    800050be:	f95e                	sd	s7,176(sp)
    800050c0:	fd62                	sd	s8,184(sp)
    800050c2:	e1e6                	sd	s9,192(sp)
    800050c4:	e5ea                	sd	s10,200(sp)
    800050c6:	e9ee                	sd	s11,208(sp)
    800050c8:	edf2                	sd	t3,216(sp)
    800050ca:	f1f6                	sd	t4,224(sp)
    800050cc:	f5fa                	sd	t5,232(sp)
    800050ce:	f9fe                	sd	t6,240(sp)
    800050d0:	cbbfc0ef          	jal	ra,80001d8a <kerneltrap>
    800050d4:	6082                	ld	ra,0(sp)
    800050d6:	6122                	ld	sp,8(sp)
    800050d8:	61c2                	ld	gp,16(sp)
    800050da:	7282                	ld	t0,32(sp)
    800050dc:	7322                	ld	t1,40(sp)
    800050de:	73c2                	ld	t2,48(sp)
    800050e0:	7462                	ld	s0,56(sp)
    800050e2:	6486                	ld	s1,64(sp)
    800050e4:	6526                	ld	a0,72(sp)
    800050e6:	65c6                	ld	a1,80(sp)
    800050e8:	6666                	ld	a2,88(sp)
    800050ea:	7686                	ld	a3,96(sp)
    800050ec:	7726                	ld	a4,104(sp)
    800050ee:	77c6                	ld	a5,112(sp)
    800050f0:	7866                	ld	a6,120(sp)
    800050f2:	688a                	ld	a7,128(sp)
    800050f4:	692a                	ld	s2,136(sp)
    800050f6:	69ca                	ld	s3,144(sp)
    800050f8:	6a6a                	ld	s4,152(sp)
    800050fa:	7a8a                	ld	s5,160(sp)
    800050fc:	7b2a                	ld	s6,168(sp)
    800050fe:	7bca                	ld	s7,176(sp)
    80005100:	7c6a                	ld	s8,184(sp)
    80005102:	6c8e                	ld	s9,192(sp)
    80005104:	6d2e                	ld	s10,200(sp)
    80005106:	6dce                	ld	s11,208(sp)
    80005108:	6e6e                	ld	t3,216(sp)
    8000510a:	7e8e                	ld	t4,224(sp)
    8000510c:	7f2e                	ld	t5,232(sp)
    8000510e:	7fce                	ld	t6,240(sp)
    80005110:	6111                	addi	sp,sp,256
    80005112:	10200073          	sret
    80005116:	00000013          	nop
    8000511a:	00000013          	nop
    8000511e:	0001                	nop

0000000080005120 <timervec>:
    80005120:	34051573          	csrrw	a0,mscratch,a0
    80005124:	e10c                	sd	a1,0(a0)
    80005126:	e510                	sd	a2,8(a0)
    80005128:	e914                	sd	a3,16(a0)
    8000512a:	6d0c                	ld	a1,24(a0)
    8000512c:	7110                	ld	a2,32(a0)
    8000512e:	6194                	ld	a3,0(a1)
    80005130:	96b2                	add	a3,a3,a2
    80005132:	e194                	sd	a3,0(a1)
    80005134:	4589                	li	a1,2
    80005136:	14459073          	csrw	sip,a1
    8000513a:	6914                	ld	a3,16(a0)
    8000513c:	6510                	ld	a2,8(a0)
    8000513e:	610c                	ld	a1,0(a0)
    80005140:	34051573          	csrrw	a0,mscratch,a0
    80005144:	30200073          	mret
	...

000000008000514a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000514a:	1141                	addi	sp,sp,-16
    8000514c:	e422                	sd	s0,8(sp)
    8000514e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005150:	0c0007b7          	lui	a5,0xc000
    80005154:	4705                	li	a4,1
    80005156:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005158:	c3d8                	sw	a4,4(a5)
}
    8000515a:	6422                	ld	s0,8(sp)
    8000515c:	0141                	addi	sp,sp,16
    8000515e:	8082                	ret

0000000080005160 <plicinithart>:

void
plicinithart(void)
{
    80005160:	1141                	addi	sp,sp,-16
    80005162:	e406                	sd	ra,8(sp)
    80005164:	e022                	sd	s0,0(sp)
    80005166:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005168:	ffffc097          	auipc	ra,0xffffc
    8000516c:	cda080e7          	jalr	-806(ra) # 80000e42 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005170:	0085171b          	slliw	a4,a0,0x8
    80005174:	0c0027b7          	lui	a5,0xc002
    80005178:	97ba                	add	a5,a5,a4
    8000517a:	40200713          	li	a4,1026
    8000517e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005182:	00d5151b          	slliw	a0,a0,0xd
    80005186:	0c2017b7          	lui	a5,0xc201
    8000518a:	953e                	add	a0,a0,a5
    8000518c:	00052023          	sw	zero,0(a0)
}
    80005190:	60a2                	ld	ra,8(sp)
    80005192:	6402                	ld	s0,0(sp)
    80005194:	0141                	addi	sp,sp,16
    80005196:	8082                	ret

0000000080005198 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005198:	1141                	addi	sp,sp,-16
    8000519a:	e406                	sd	ra,8(sp)
    8000519c:	e022                	sd	s0,0(sp)
    8000519e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051a0:	ffffc097          	auipc	ra,0xffffc
    800051a4:	ca2080e7          	jalr	-862(ra) # 80000e42 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051a8:	00d5179b          	slliw	a5,a0,0xd
    800051ac:	0c201537          	lui	a0,0xc201
    800051b0:	953e                	add	a0,a0,a5
  return irq;
}
    800051b2:	4148                	lw	a0,4(a0)
    800051b4:	60a2                	ld	ra,8(sp)
    800051b6:	6402                	ld	s0,0(sp)
    800051b8:	0141                	addi	sp,sp,16
    800051ba:	8082                	ret

00000000800051bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051bc:	1101                	addi	sp,sp,-32
    800051be:	ec06                	sd	ra,24(sp)
    800051c0:	e822                	sd	s0,16(sp)
    800051c2:	e426                	sd	s1,8(sp)
    800051c4:	1000                	addi	s0,sp,32
    800051c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051c8:	ffffc097          	auipc	ra,0xffffc
    800051cc:	c7a080e7          	jalr	-902(ra) # 80000e42 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051d0:	00d5151b          	slliw	a0,a0,0xd
    800051d4:	0c2017b7          	lui	a5,0xc201
    800051d8:	97aa                	add	a5,a5,a0
    800051da:	c3c4                	sw	s1,4(a5)
}
    800051dc:	60e2                	ld	ra,24(sp)
    800051de:	6442                	ld	s0,16(sp)
    800051e0:	64a2                	ld	s1,8(sp)
    800051e2:	6105                	addi	sp,sp,32
    800051e4:	8082                	ret

00000000800051e6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051e6:	1141                	addi	sp,sp,-16
    800051e8:	e406                	sd	ra,8(sp)
    800051ea:	e022                	sd	s0,0(sp)
    800051ec:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051ee:	479d                	li	a5,7
    800051f0:	06a7c963          	blt	a5,a0,80005262 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800051f4:	00016797          	auipc	a5,0x16
    800051f8:	e0c78793          	addi	a5,a5,-500 # 8001b000 <disk>
    800051fc:	00a78733          	add	a4,a5,a0
    80005200:	6789                	lui	a5,0x2
    80005202:	97ba                	add	a5,a5,a4
    80005204:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005208:	e7ad                	bnez	a5,80005272 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000520a:	00451793          	slli	a5,a0,0x4
    8000520e:	00018717          	auipc	a4,0x18
    80005212:	df270713          	addi	a4,a4,-526 # 8001d000 <disk+0x2000>
    80005216:	6314                	ld	a3,0(a4)
    80005218:	96be                	add	a3,a3,a5
    8000521a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000521e:	6314                	ld	a3,0(a4)
    80005220:	96be                	add	a3,a3,a5
    80005222:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005226:	6314                	ld	a3,0(a4)
    80005228:	96be                	add	a3,a3,a5
    8000522a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000522e:	6318                	ld	a4,0(a4)
    80005230:	97ba                	add	a5,a5,a4
    80005232:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005236:	00016797          	auipc	a5,0x16
    8000523a:	dca78793          	addi	a5,a5,-566 # 8001b000 <disk>
    8000523e:	97aa                	add	a5,a5,a0
    80005240:	6509                	lui	a0,0x2
    80005242:	953e                	add	a0,a0,a5
    80005244:	4785                	li	a5,1
    80005246:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000524a:	00018517          	auipc	a0,0x18
    8000524e:	dce50513          	addi	a0,a0,-562 # 8001d018 <disk+0x2018>
    80005252:	ffffc097          	auipc	ra,0xffffc
    80005256:	4a2080e7          	jalr	1186(ra) # 800016f4 <wakeup>
}
    8000525a:	60a2                	ld	ra,8(sp)
    8000525c:	6402                	ld	s0,0(sp)
    8000525e:	0141                	addi	sp,sp,16
    80005260:	8082                	ret
    panic("free_desc 1");
    80005262:	00003517          	auipc	a0,0x3
    80005266:	61650513          	addi	a0,a0,1558 # 80008878 <syscalls+0x328>
    8000526a:	00001097          	auipc	ra,0x1
    8000526e:	a1e080e7          	jalr	-1506(ra) # 80005c88 <panic>
    panic("free_desc 2");
    80005272:	00003517          	auipc	a0,0x3
    80005276:	61650513          	addi	a0,a0,1558 # 80008888 <syscalls+0x338>
    8000527a:	00001097          	auipc	ra,0x1
    8000527e:	a0e080e7          	jalr	-1522(ra) # 80005c88 <panic>

0000000080005282 <virtio_disk_init>:
{
    80005282:	1101                	addi	sp,sp,-32
    80005284:	ec06                	sd	ra,24(sp)
    80005286:	e822                	sd	s0,16(sp)
    80005288:	e426                	sd	s1,8(sp)
    8000528a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000528c:	00003597          	auipc	a1,0x3
    80005290:	60c58593          	addi	a1,a1,1548 # 80008898 <syscalls+0x348>
    80005294:	00018517          	auipc	a0,0x18
    80005298:	e9450513          	addi	a0,a0,-364 # 8001d128 <disk+0x2128>
    8000529c:	00001097          	auipc	ra,0x1
    800052a0:	ea6080e7          	jalr	-346(ra) # 80006142 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052a4:	100017b7          	lui	a5,0x10001
    800052a8:	4398                	lw	a4,0(a5)
    800052aa:	2701                	sext.w	a4,a4
    800052ac:	747277b7          	lui	a5,0x74727
    800052b0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052b4:	0ef71163          	bne	a4,a5,80005396 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052b8:	100017b7          	lui	a5,0x10001
    800052bc:	43dc                	lw	a5,4(a5)
    800052be:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052c0:	4705                	li	a4,1
    800052c2:	0ce79a63          	bne	a5,a4,80005396 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052c6:	100017b7          	lui	a5,0x10001
    800052ca:	479c                	lw	a5,8(a5)
    800052cc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052ce:	4709                	li	a4,2
    800052d0:	0ce79363          	bne	a5,a4,80005396 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052d4:	100017b7          	lui	a5,0x10001
    800052d8:	47d8                	lw	a4,12(a5)
    800052da:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052dc:	554d47b7          	lui	a5,0x554d4
    800052e0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052e4:	0af71963          	bne	a4,a5,80005396 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052e8:	100017b7          	lui	a5,0x10001
    800052ec:	4705                	li	a4,1
    800052ee:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052f0:	470d                	li	a4,3
    800052f2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052f4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800052f6:	c7ffe737          	lui	a4,0xc7ffe
    800052fa:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    800052fe:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005300:	2701                	sext.w	a4,a4
    80005302:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005304:	472d                	li	a4,11
    80005306:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005308:	473d                	li	a4,15
    8000530a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000530c:	6705                	lui	a4,0x1
    8000530e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005310:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005314:	5bdc                	lw	a5,52(a5)
    80005316:	2781                	sext.w	a5,a5
  if(max == 0)
    80005318:	c7d9                	beqz	a5,800053a6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000531a:	471d                	li	a4,7
    8000531c:	08f77d63          	bgeu	a4,a5,800053b6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005320:	100014b7          	lui	s1,0x10001
    80005324:	47a1                	li	a5,8
    80005326:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005328:	6609                	lui	a2,0x2
    8000532a:	4581                	li	a1,0
    8000532c:	00016517          	auipc	a0,0x16
    80005330:	cd450513          	addi	a0,a0,-812 # 8001b000 <disk>
    80005334:	ffffb097          	auipc	ra,0xffffb
    80005338:	e6a080e7          	jalr	-406(ra) # 8000019e <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000533c:	00016717          	auipc	a4,0x16
    80005340:	cc470713          	addi	a4,a4,-828 # 8001b000 <disk>
    80005344:	00c75793          	srli	a5,a4,0xc
    80005348:	2781                	sext.w	a5,a5
    8000534a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000534c:	00018797          	auipc	a5,0x18
    80005350:	cb478793          	addi	a5,a5,-844 # 8001d000 <disk+0x2000>
    80005354:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005356:	00016717          	auipc	a4,0x16
    8000535a:	d2a70713          	addi	a4,a4,-726 # 8001b080 <disk+0x80>
    8000535e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005360:	00017717          	auipc	a4,0x17
    80005364:	ca070713          	addi	a4,a4,-864 # 8001c000 <disk+0x1000>
    80005368:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000536a:	4705                	li	a4,1
    8000536c:	00e78c23          	sb	a4,24(a5)
    80005370:	00e78ca3          	sb	a4,25(a5)
    80005374:	00e78d23          	sb	a4,26(a5)
    80005378:	00e78da3          	sb	a4,27(a5)
    8000537c:	00e78e23          	sb	a4,28(a5)
    80005380:	00e78ea3          	sb	a4,29(a5)
    80005384:	00e78f23          	sb	a4,30(a5)
    80005388:	00e78fa3          	sb	a4,31(a5)
}
    8000538c:	60e2                	ld	ra,24(sp)
    8000538e:	6442                	ld	s0,16(sp)
    80005390:	64a2                	ld	s1,8(sp)
    80005392:	6105                	addi	sp,sp,32
    80005394:	8082                	ret
    panic("could not find virtio disk");
    80005396:	00003517          	auipc	a0,0x3
    8000539a:	51250513          	addi	a0,a0,1298 # 800088a8 <syscalls+0x358>
    8000539e:	00001097          	auipc	ra,0x1
    800053a2:	8ea080e7          	jalr	-1814(ra) # 80005c88 <panic>
    panic("virtio disk has no queue 0");
    800053a6:	00003517          	auipc	a0,0x3
    800053aa:	52250513          	addi	a0,a0,1314 # 800088c8 <syscalls+0x378>
    800053ae:	00001097          	auipc	ra,0x1
    800053b2:	8da080e7          	jalr	-1830(ra) # 80005c88 <panic>
    panic("virtio disk max queue too short");
    800053b6:	00003517          	auipc	a0,0x3
    800053ba:	53250513          	addi	a0,a0,1330 # 800088e8 <syscalls+0x398>
    800053be:	00001097          	auipc	ra,0x1
    800053c2:	8ca080e7          	jalr	-1846(ra) # 80005c88 <panic>

00000000800053c6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053c6:	7159                	addi	sp,sp,-112
    800053c8:	f486                	sd	ra,104(sp)
    800053ca:	f0a2                	sd	s0,96(sp)
    800053cc:	eca6                	sd	s1,88(sp)
    800053ce:	e8ca                	sd	s2,80(sp)
    800053d0:	e4ce                	sd	s3,72(sp)
    800053d2:	e0d2                	sd	s4,64(sp)
    800053d4:	fc56                	sd	s5,56(sp)
    800053d6:	f85a                	sd	s6,48(sp)
    800053d8:	f45e                	sd	s7,40(sp)
    800053da:	f062                	sd	s8,32(sp)
    800053dc:	ec66                	sd	s9,24(sp)
    800053de:	e86a                	sd	s10,16(sp)
    800053e0:	1880                	addi	s0,sp,112
    800053e2:	892a                	mv	s2,a0
    800053e4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053e6:	00c52c83          	lw	s9,12(a0)
    800053ea:	001c9c9b          	slliw	s9,s9,0x1
    800053ee:	1c82                	slli	s9,s9,0x20
    800053f0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053f4:	00018517          	auipc	a0,0x18
    800053f8:	d3450513          	addi	a0,a0,-716 # 8001d128 <disk+0x2128>
    800053fc:	00001097          	auipc	ra,0x1
    80005400:	dd6080e7          	jalr	-554(ra) # 800061d2 <acquire>
  for(int i = 0; i < 3; i++){
    80005404:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005406:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005408:	00016b97          	auipc	s7,0x16
    8000540c:	bf8b8b93          	addi	s7,s7,-1032 # 8001b000 <disk>
    80005410:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005412:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005414:	8a4e                	mv	s4,s3
    80005416:	a051                	j	8000549a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005418:	00fb86b3          	add	a3,s7,a5
    8000541c:	96da                	add	a3,a3,s6
    8000541e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005422:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005424:	0207c563          	bltz	a5,8000544e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005428:	2485                	addiw	s1,s1,1
    8000542a:	0711                	addi	a4,a4,4
    8000542c:	25548063          	beq	s1,s5,8000566c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005430:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005432:	00018697          	auipc	a3,0x18
    80005436:	be668693          	addi	a3,a3,-1050 # 8001d018 <disk+0x2018>
    8000543a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000543c:	0006c583          	lbu	a1,0(a3)
    80005440:	fde1                	bnez	a1,80005418 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005442:	2785                	addiw	a5,a5,1
    80005444:	0685                	addi	a3,a3,1
    80005446:	ff879be3          	bne	a5,s8,8000543c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000544a:	57fd                	li	a5,-1
    8000544c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000544e:	02905a63          	blez	s1,80005482 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005452:	f9042503          	lw	a0,-112(s0)
    80005456:	00000097          	auipc	ra,0x0
    8000545a:	d90080e7          	jalr	-624(ra) # 800051e6 <free_desc>
      for(int j = 0; j < i; j++)
    8000545e:	4785                	li	a5,1
    80005460:	0297d163          	bge	a5,s1,80005482 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005464:	f9442503          	lw	a0,-108(s0)
    80005468:	00000097          	auipc	ra,0x0
    8000546c:	d7e080e7          	jalr	-642(ra) # 800051e6 <free_desc>
      for(int j = 0; j < i; j++)
    80005470:	4789                	li	a5,2
    80005472:	0097d863          	bge	a5,s1,80005482 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005476:	f9842503          	lw	a0,-104(s0)
    8000547a:	00000097          	auipc	ra,0x0
    8000547e:	d6c080e7          	jalr	-660(ra) # 800051e6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005482:	00018597          	auipc	a1,0x18
    80005486:	ca658593          	addi	a1,a1,-858 # 8001d128 <disk+0x2128>
    8000548a:	00018517          	auipc	a0,0x18
    8000548e:	b8e50513          	addi	a0,a0,-1138 # 8001d018 <disk+0x2018>
    80005492:	ffffc097          	auipc	ra,0xffffc
    80005496:	0d6080e7          	jalr	214(ra) # 80001568 <sleep>
  for(int i = 0; i < 3; i++){
    8000549a:	f9040713          	addi	a4,s0,-112
    8000549e:	84ce                	mv	s1,s3
    800054a0:	bf41                	j	80005430 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800054a2:	20058713          	addi	a4,a1,512
    800054a6:	00471693          	slli	a3,a4,0x4
    800054aa:	00016717          	auipc	a4,0x16
    800054ae:	b5670713          	addi	a4,a4,-1194 # 8001b000 <disk>
    800054b2:	9736                	add	a4,a4,a3
    800054b4:	4685                	li	a3,1
    800054b6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800054ba:	20058713          	addi	a4,a1,512
    800054be:	00471693          	slli	a3,a4,0x4
    800054c2:	00016717          	auipc	a4,0x16
    800054c6:	b3e70713          	addi	a4,a4,-1218 # 8001b000 <disk>
    800054ca:	9736                	add	a4,a4,a3
    800054cc:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800054d0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800054d4:	7679                	lui	a2,0xffffe
    800054d6:	963e                	add	a2,a2,a5
    800054d8:	00018697          	auipc	a3,0x18
    800054dc:	b2868693          	addi	a3,a3,-1240 # 8001d000 <disk+0x2000>
    800054e0:	6298                	ld	a4,0(a3)
    800054e2:	9732                	add	a4,a4,a2
    800054e4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054e6:	6298                	ld	a4,0(a3)
    800054e8:	9732                	add	a4,a4,a2
    800054ea:	4541                	li	a0,16
    800054ec:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800054ee:	6298                	ld	a4,0(a3)
    800054f0:	9732                	add	a4,a4,a2
    800054f2:	4505                	li	a0,1
    800054f4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800054f8:	f9442703          	lw	a4,-108(s0)
    800054fc:	6288                	ld	a0,0(a3)
    800054fe:	962a                	add	a2,a2,a0
    80005500:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005504:	0712                	slli	a4,a4,0x4
    80005506:	6290                	ld	a2,0(a3)
    80005508:	963a                	add	a2,a2,a4
    8000550a:	05890513          	addi	a0,s2,88
    8000550e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005510:	6294                	ld	a3,0(a3)
    80005512:	96ba                	add	a3,a3,a4
    80005514:	40000613          	li	a2,1024
    80005518:	c690                	sw	a2,8(a3)
  if(write)
    8000551a:	140d0063          	beqz	s10,8000565a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000551e:	00018697          	auipc	a3,0x18
    80005522:	ae26b683          	ld	a3,-1310(a3) # 8001d000 <disk+0x2000>
    80005526:	96ba                	add	a3,a3,a4
    80005528:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000552c:	00016817          	auipc	a6,0x16
    80005530:	ad480813          	addi	a6,a6,-1324 # 8001b000 <disk>
    80005534:	00018517          	auipc	a0,0x18
    80005538:	acc50513          	addi	a0,a0,-1332 # 8001d000 <disk+0x2000>
    8000553c:	6114                	ld	a3,0(a0)
    8000553e:	96ba                	add	a3,a3,a4
    80005540:	00c6d603          	lhu	a2,12(a3)
    80005544:	00166613          	ori	a2,a2,1
    80005548:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000554c:	f9842683          	lw	a3,-104(s0)
    80005550:	6110                	ld	a2,0(a0)
    80005552:	9732                	add	a4,a4,a2
    80005554:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005558:	20058613          	addi	a2,a1,512
    8000555c:	0612                	slli	a2,a2,0x4
    8000555e:	9642                	add	a2,a2,a6
    80005560:	577d                	li	a4,-1
    80005562:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005566:	00469713          	slli	a4,a3,0x4
    8000556a:	6114                	ld	a3,0(a0)
    8000556c:	96ba                	add	a3,a3,a4
    8000556e:	03078793          	addi	a5,a5,48
    80005572:	97c2                	add	a5,a5,a6
    80005574:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005576:	611c                	ld	a5,0(a0)
    80005578:	97ba                	add	a5,a5,a4
    8000557a:	4685                	li	a3,1
    8000557c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000557e:	611c                	ld	a5,0(a0)
    80005580:	97ba                	add	a5,a5,a4
    80005582:	4809                	li	a6,2
    80005584:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005588:	611c                	ld	a5,0(a0)
    8000558a:	973e                	add	a4,a4,a5
    8000558c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005590:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005594:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005598:	6518                	ld	a4,8(a0)
    8000559a:	00275783          	lhu	a5,2(a4)
    8000559e:	8b9d                	andi	a5,a5,7
    800055a0:	0786                	slli	a5,a5,0x1
    800055a2:	97ba                	add	a5,a5,a4
    800055a4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800055a8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800055ac:	6518                	ld	a4,8(a0)
    800055ae:	00275783          	lhu	a5,2(a4)
    800055b2:	2785                	addiw	a5,a5,1
    800055b4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055b8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800055bc:	100017b7          	lui	a5,0x10001
    800055c0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800055c4:	00492703          	lw	a4,4(s2)
    800055c8:	4785                	li	a5,1
    800055ca:	02f71163          	bne	a4,a5,800055ec <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800055ce:	00018997          	auipc	s3,0x18
    800055d2:	b5a98993          	addi	s3,s3,-1190 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800055d6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800055d8:	85ce                	mv	a1,s3
    800055da:	854a                	mv	a0,s2
    800055dc:	ffffc097          	auipc	ra,0xffffc
    800055e0:	f8c080e7          	jalr	-116(ra) # 80001568 <sleep>
  while(b->disk == 1) {
    800055e4:	00492783          	lw	a5,4(s2)
    800055e8:	fe9788e3          	beq	a5,s1,800055d8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800055ec:	f9042903          	lw	s2,-112(s0)
    800055f0:	20090793          	addi	a5,s2,512
    800055f4:	00479713          	slli	a4,a5,0x4
    800055f8:	00016797          	auipc	a5,0x16
    800055fc:	a0878793          	addi	a5,a5,-1528 # 8001b000 <disk>
    80005600:	97ba                	add	a5,a5,a4
    80005602:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005606:	00018997          	auipc	s3,0x18
    8000560a:	9fa98993          	addi	s3,s3,-1542 # 8001d000 <disk+0x2000>
    8000560e:	00491713          	slli	a4,s2,0x4
    80005612:	0009b783          	ld	a5,0(s3)
    80005616:	97ba                	add	a5,a5,a4
    80005618:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000561c:	854a                	mv	a0,s2
    8000561e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005622:	00000097          	auipc	ra,0x0
    80005626:	bc4080e7          	jalr	-1084(ra) # 800051e6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000562a:	8885                	andi	s1,s1,1
    8000562c:	f0ed                	bnez	s1,8000560e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000562e:	00018517          	auipc	a0,0x18
    80005632:	afa50513          	addi	a0,a0,-1286 # 8001d128 <disk+0x2128>
    80005636:	00001097          	auipc	ra,0x1
    8000563a:	c50080e7          	jalr	-944(ra) # 80006286 <release>
}
    8000563e:	70a6                	ld	ra,104(sp)
    80005640:	7406                	ld	s0,96(sp)
    80005642:	64e6                	ld	s1,88(sp)
    80005644:	6946                	ld	s2,80(sp)
    80005646:	69a6                	ld	s3,72(sp)
    80005648:	6a06                	ld	s4,64(sp)
    8000564a:	7ae2                	ld	s5,56(sp)
    8000564c:	7b42                	ld	s6,48(sp)
    8000564e:	7ba2                	ld	s7,40(sp)
    80005650:	7c02                	ld	s8,32(sp)
    80005652:	6ce2                	ld	s9,24(sp)
    80005654:	6d42                	ld	s10,16(sp)
    80005656:	6165                	addi	sp,sp,112
    80005658:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000565a:	00018697          	auipc	a3,0x18
    8000565e:	9a66b683          	ld	a3,-1626(a3) # 8001d000 <disk+0x2000>
    80005662:	96ba                	add	a3,a3,a4
    80005664:	4609                	li	a2,2
    80005666:	00c69623          	sh	a2,12(a3)
    8000566a:	b5c9                	j	8000552c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000566c:	f9042583          	lw	a1,-112(s0)
    80005670:	20058793          	addi	a5,a1,512
    80005674:	0792                	slli	a5,a5,0x4
    80005676:	00016517          	auipc	a0,0x16
    8000567a:	a3250513          	addi	a0,a0,-1486 # 8001b0a8 <disk+0xa8>
    8000567e:	953e                	add	a0,a0,a5
  if(write)
    80005680:	e20d11e3          	bnez	s10,800054a2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005684:	20058713          	addi	a4,a1,512
    80005688:	00471693          	slli	a3,a4,0x4
    8000568c:	00016717          	auipc	a4,0x16
    80005690:	97470713          	addi	a4,a4,-1676 # 8001b000 <disk>
    80005694:	9736                	add	a4,a4,a3
    80005696:	0a072423          	sw	zero,168(a4)
    8000569a:	b505                	j	800054ba <virtio_disk_rw+0xf4>

000000008000569c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000569c:	1101                	addi	sp,sp,-32
    8000569e:	ec06                	sd	ra,24(sp)
    800056a0:	e822                	sd	s0,16(sp)
    800056a2:	e426                	sd	s1,8(sp)
    800056a4:	e04a                	sd	s2,0(sp)
    800056a6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800056a8:	00018517          	auipc	a0,0x18
    800056ac:	a8050513          	addi	a0,a0,-1408 # 8001d128 <disk+0x2128>
    800056b0:	00001097          	auipc	ra,0x1
    800056b4:	b22080e7          	jalr	-1246(ra) # 800061d2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056b8:	10001737          	lui	a4,0x10001
    800056bc:	533c                	lw	a5,96(a4)
    800056be:	8b8d                	andi	a5,a5,3
    800056c0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056c2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056c6:	00018797          	auipc	a5,0x18
    800056ca:	93a78793          	addi	a5,a5,-1734 # 8001d000 <disk+0x2000>
    800056ce:	6b94                	ld	a3,16(a5)
    800056d0:	0207d703          	lhu	a4,32(a5)
    800056d4:	0026d783          	lhu	a5,2(a3)
    800056d8:	06f70163          	beq	a4,a5,8000573a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056dc:	00016917          	auipc	s2,0x16
    800056e0:	92490913          	addi	s2,s2,-1756 # 8001b000 <disk>
    800056e4:	00018497          	auipc	s1,0x18
    800056e8:	91c48493          	addi	s1,s1,-1764 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800056ec:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056f0:	6898                	ld	a4,16(s1)
    800056f2:	0204d783          	lhu	a5,32(s1)
    800056f6:	8b9d                	andi	a5,a5,7
    800056f8:	078e                	slli	a5,a5,0x3
    800056fa:	97ba                	add	a5,a5,a4
    800056fc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056fe:	20078713          	addi	a4,a5,512
    80005702:	0712                	slli	a4,a4,0x4
    80005704:	974a                	add	a4,a4,s2
    80005706:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000570a:	e731                	bnez	a4,80005756 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000570c:	20078793          	addi	a5,a5,512
    80005710:	0792                	slli	a5,a5,0x4
    80005712:	97ca                	add	a5,a5,s2
    80005714:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005716:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000571a:	ffffc097          	auipc	ra,0xffffc
    8000571e:	fda080e7          	jalr	-38(ra) # 800016f4 <wakeup>

    disk.used_idx += 1;
    80005722:	0204d783          	lhu	a5,32(s1)
    80005726:	2785                	addiw	a5,a5,1
    80005728:	17c2                	slli	a5,a5,0x30
    8000572a:	93c1                	srli	a5,a5,0x30
    8000572c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005730:	6898                	ld	a4,16(s1)
    80005732:	00275703          	lhu	a4,2(a4)
    80005736:	faf71be3          	bne	a4,a5,800056ec <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000573a:	00018517          	auipc	a0,0x18
    8000573e:	9ee50513          	addi	a0,a0,-1554 # 8001d128 <disk+0x2128>
    80005742:	00001097          	auipc	ra,0x1
    80005746:	b44080e7          	jalr	-1212(ra) # 80006286 <release>
}
    8000574a:	60e2                	ld	ra,24(sp)
    8000574c:	6442                	ld	s0,16(sp)
    8000574e:	64a2                	ld	s1,8(sp)
    80005750:	6902                	ld	s2,0(sp)
    80005752:	6105                	addi	sp,sp,32
    80005754:	8082                	ret
      panic("virtio_disk_intr status");
    80005756:	00003517          	auipc	a0,0x3
    8000575a:	1b250513          	addi	a0,a0,434 # 80008908 <syscalls+0x3b8>
    8000575e:	00000097          	auipc	ra,0x0
    80005762:	52a080e7          	jalr	1322(ra) # 80005c88 <panic>

0000000080005766 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005766:	1141                	addi	sp,sp,-16
    80005768:	e422                	sd	s0,8(sp)
    8000576a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000576c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005770:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005774:	0037979b          	slliw	a5,a5,0x3
    80005778:	02004737          	lui	a4,0x2004
    8000577c:	97ba                	add	a5,a5,a4
    8000577e:	0200c737          	lui	a4,0x200c
    80005782:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005786:	000f4637          	lui	a2,0xf4
    8000578a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000578e:	95b2                	add	a1,a1,a2
    80005790:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005792:	00269713          	slli	a4,a3,0x2
    80005796:	9736                	add	a4,a4,a3
    80005798:	00371693          	slli	a3,a4,0x3
    8000579c:	00019717          	auipc	a4,0x19
    800057a0:	86470713          	addi	a4,a4,-1948 # 8001e000 <timer_scratch>
    800057a4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800057a6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800057a8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800057aa:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800057ae:	00000797          	auipc	a5,0x0
    800057b2:	97278793          	addi	a5,a5,-1678 # 80005120 <timervec>
    800057b6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057ba:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800057be:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057c2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800057c6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057ca:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057ce:	30479073          	csrw	mie,a5
}
    800057d2:	6422                	ld	s0,8(sp)
    800057d4:	0141                	addi	sp,sp,16
    800057d6:	8082                	ret

00000000800057d8 <start>:
{
    800057d8:	1141                	addi	sp,sp,-16
    800057da:	e406                	sd	ra,8(sp)
    800057dc:	e022                	sd	s0,0(sp)
    800057de:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057e0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057e4:	7779                	lui	a4,0xffffe
    800057e6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800057ea:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057ec:	6705                	lui	a4,0x1
    800057ee:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057f2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057f4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057f8:	ffffb797          	auipc	a5,0xffffb
    800057fc:	b5478793          	addi	a5,a5,-1196 # 8000034c <main>
    80005800:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005804:	4781                	li	a5,0
    80005806:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000580a:	67c1                	lui	a5,0x10
    8000580c:	17fd                	addi	a5,a5,-1
    8000580e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005812:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005816:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000581a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000581e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005822:	57fd                	li	a5,-1
    80005824:	83a9                	srli	a5,a5,0xa
    80005826:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000582a:	47bd                	li	a5,15
    8000582c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005830:	00000097          	auipc	ra,0x0
    80005834:	f36080e7          	jalr	-202(ra) # 80005766 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005838:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000583c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000583e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005840:	30200073          	mret
}
    80005844:	60a2                	ld	ra,8(sp)
    80005846:	6402                	ld	s0,0(sp)
    80005848:	0141                	addi	sp,sp,16
    8000584a:	8082                	ret

000000008000584c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000584c:	715d                	addi	sp,sp,-80
    8000584e:	e486                	sd	ra,72(sp)
    80005850:	e0a2                	sd	s0,64(sp)
    80005852:	fc26                	sd	s1,56(sp)
    80005854:	f84a                	sd	s2,48(sp)
    80005856:	f44e                	sd	s3,40(sp)
    80005858:	f052                	sd	s4,32(sp)
    8000585a:	ec56                	sd	s5,24(sp)
    8000585c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000585e:	04c05663          	blez	a2,800058aa <consolewrite+0x5e>
    80005862:	8a2a                	mv	s4,a0
    80005864:	84ae                	mv	s1,a1
    80005866:	89b2                	mv	s3,a2
    80005868:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000586a:	5afd                	li	s5,-1
    8000586c:	4685                	li	a3,1
    8000586e:	8626                	mv	a2,s1
    80005870:	85d2                	mv	a1,s4
    80005872:	fbf40513          	addi	a0,s0,-65
    80005876:	ffffc097          	auipc	ra,0xffffc
    8000587a:	0ec080e7          	jalr	236(ra) # 80001962 <either_copyin>
    8000587e:	01550c63          	beq	a0,s5,80005896 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005882:	fbf44503          	lbu	a0,-65(s0)
    80005886:	00000097          	auipc	ra,0x0
    8000588a:	78e080e7          	jalr	1934(ra) # 80006014 <uartputc>
  for(i = 0; i < n; i++){
    8000588e:	2905                	addiw	s2,s2,1
    80005890:	0485                	addi	s1,s1,1
    80005892:	fd299de3          	bne	s3,s2,8000586c <consolewrite+0x20>
  }

  return i;
}
    80005896:	854a                	mv	a0,s2
    80005898:	60a6                	ld	ra,72(sp)
    8000589a:	6406                	ld	s0,64(sp)
    8000589c:	74e2                	ld	s1,56(sp)
    8000589e:	7942                	ld	s2,48(sp)
    800058a0:	79a2                	ld	s3,40(sp)
    800058a2:	7a02                	ld	s4,32(sp)
    800058a4:	6ae2                	ld	s5,24(sp)
    800058a6:	6161                	addi	sp,sp,80
    800058a8:	8082                	ret
  for(i = 0; i < n; i++){
    800058aa:	4901                	li	s2,0
    800058ac:	b7ed                	j	80005896 <consolewrite+0x4a>

00000000800058ae <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800058ae:	7119                	addi	sp,sp,-128
    800058b0:	fc86                	sd	ra,120(sp)
    800058b2:	f8a2                	sd	s0,112(sp)
    800058b4:	f4a6                	sd	s1,104(sp)
    800058b6:	f0ca                	sd	s2,96(sp)
    800058b8:	ecce                	sd	s3,88(sp)
    800058ba:	e8d2                	sd	s4,80(sp)
    800058bc:	e4d6                	sd	s5,72(sp)
    800058be:	e0da                	sd	s6,64(sp)
    800058c0:	fc5e                	sd	s7,56(sp)
    800058c2:	f862                	sd	s8,48(sp)
    800058c4:	f466                	sd	s9,40(sp)
    800058c6:	f06a                	sd	s10,32(sp)
    800058c8:	ec6e                	sd	s11,24(sp)
    800058ca:	0100                	addi	s0,sp,128
    800058cc:	8b2a                	mv	s6,a0
    800058ce:	8aae                	mv	s5,a1
    800058d0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058d2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800058d6:	00021517          	auipc	a0,0x21
    800058da:	86a50513          	addi	a0,a0,-1942 # 80026140 <cons>
    800058de:	00001097          	auipc	ra,0x1
    800058e2:	8f4080e7          	jalr	-1804(ra) # 800061d2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058e6:	00021497          	auipc	s1,0x21
    800058ea:	85a48493          	addi	s1,s1,-1958 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058ee:	89a6                	mv	s3,s1
    800058f0:	00021917          	auipc	s2,0x21
    800058f4:	8e890913          	addi	s2,s2,-1816 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800058f8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058fa:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800058fc:	4da9                	li	s11,10
  while(n > 0){
    800058fe:	07405863          	blez	s4,8000596e <consoleread+0xc0>
    while(cons.r == cons.w){
    80005902:	0984a783          	lw	a5,152(s1)
    80005906:	09c4a703          	lw	a4,156(s1)
    8000590a:	02f71463          	bne	a4,a5,80005932 <consoleread+0x84>
      if(myproc()->killed){
    8000590e:	ffffb097          	auipc	ra,0xffffb
    80005912:	560080e7          	jalr	1376(ra) # 80000e6e <myproc>
    80005916:	551c                	lw	a5,40(a0)
    80005918:	e7b5                	bnez	a5,80005984 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    8000591a:	85ce                	mv	a1,s3
    8000591c:	854a                	mv	a0,s2
    8000591e:	ffffc097          	auipc	ra,0xffffc
    80005922:	c4a080e7          	jalr	-950(ra) # 80001568 <sleep>
    while(cons.r == cons.w){
    80005926:	0984a783          	lw	a5,152(s1)
    8000592a:	09c4a703          	lw	a4,156(s1)
    8000592e:	fef700e3          	beq	a4,a5,8000590e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005932:	0017871b          	addiw	a4,a5,1
    80005936:	08e4ac23          	sw	a4,152(s1)
    8000593a:	07f7f713          	andi	a4,a5,127
    8000593e:	9726                	add	a4,a4,s1
    80005940:	01874703          	lbu	a4,24(a4)
    80005944:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005948:	079c0663          	beq	s8,s9,800059b4 <consoleread+0x106>
    cbuf = c;
    8000594c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005950:	4685                	li	a3,1
    80005952:	f8f40613          	addi	a2,s0,-113
    80005956:	85d6                	mv	a1,s5
    80005958:	855a                	mv	a0,s6
    8000595a:	ffffc097          	auipc	ra,0xffffc
    8000595e:	fb2080e7          	jalr	-78(ra) # 8000190c <either_copyout>
    80005962:	01a50663          	beq	a0,s10,8000596e <consoleread+0xc0>
    dst++;
    80005966:	0a85                	addi	s5,s5,1
    --n;
    80005968:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000596a:	f9bc1ae3          	bne	s8,s11,800058fe <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000596e:	00020517          	auipc	a0,0x20
    80005972:	7d250513          	addi	a0,a0,2002 # 80026140 <cons>
    80005976:	00001097          	auipc	ra,0x1
    8000597a:	910080e7          	jalr	-1776(ra) # 80006286 <release>

  return target - n;
    8000597e:	414b853b          	subw	a0,s7,s4
    80005982:	a811                	j	80005996 <consoleread+0xe8>
        release(&cons.lock);
    80005984:	00020517          	auipc	a0,0x20
    80005988:	7bc50513          	addi	a0,a0,1980 # 80026140 <cons>
    8000598c:	00001097          	auipc	ra,0x1
    80005990:	8fa080e7          	jalr	-1798(ra) # 80006286 <release>
        return -1;
    80005994:	557d                	li	a0,-1
}
    80005996:	70e6                	ld	ra,120(sp)
    80005998:	7446                	ld	s0,112(sp)
    8000599a:	74a6                	ld	s1,104(sp)
    8000599c:	7906                	ld	s2,96(sp)
    8000599e:	69e6                	ld	s3,88(sp)
    800059a0:	6a46                	ld	s4,80(sp)
    800059a2:	6aa6                	ld	s5,72(sp)
    800059a4:	6b06                	ld	s6,64(sp)
    800059a6:	7be2                	ld	s7,56(sp)
    800059a8:	7c42                	ld	s8,48(sp)
    800059aa:	7ca2                	ld	s9,40(sp)
    800059ac:	7d02                	ld	s10,32(sp)
    800059ae:	6de2                	ld	s11,24(sp)
    800059b0:	6109                	addi	sp,sp,128
    800059b2:	8082                	ret
      if(n < target){
    800059b4:	000a071b          	sext.w	a4,s4
    800059b8:	fb777be3          	bgeu	a4,s7,8000596e <consoleread+0xc0>
        cons.r--;
    800059bc:	00021717          	auipc	a4,0x21
    800059c0:	80f72e23          	sw	a5,-2020(a4) # 800261d8 <cons+0x98>
    800059c4:	b76d                	j	8000596e <consoleread+0xc0>

00000000800059c6 <consputc>:
{
    800059c6:	1141                	addi	sp,sp,-16
    800059c8:	e406                	sd	ra,8(sp)
    800059ca:	e022                	sd	s0,0(sp)
    800059cc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059ce:	10000793          	li	a5,256
    800059d2:	00f50a63          	beq	a0,a5,800059e6 <consputc+0x20>
    uartputc_sync(c);
    800059d6:	00000097          	auipc	ra,0x0
    800059da:	564080e7          	jalr	1380(ra) # 80005f3a <uartputc_sync>
}
    800059de:	60a2                	ld	ra,8(sp)
    800059e0:	6402                	ld	s0,0(sp)
    800059e2:	0141                	addi	sp,sp,16
    800059e4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059e6:	4521                	li	a0,8
    800059e8:	00000097          	auipc	ra,0x0
    800059ec:	552080e7          	jalr	1362(ra) # 80005f3a <uartputc_sync>
    800059f0:	02000513          	li	a0,32
    800059f4:	00000097          	auipc	ra,0x0
    800059f8:	546080e7          	jalr	1350(ra) # 80005f3a <uartputc_sync>
    800059fc:	4521                	li	a0,8
    800059fe:	00000097          	auipc	ra,0x0
    80005a02:	53c080e7          	jalr	1340(ra) # 80005f3a <uartputc_sync>
    80005a06:	bfe1                	j	800059de <consputc+0x18>

0000000080005a08 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a08:	1101                	addi	sp,sp,-32
    80005a0a:	ec06                	sd	ra,24(sp)
    80005a0c:	e822                	sd	s0,16(sp)
    80005a0e:	e426                	sd	s1,8(sp)
    80005a10:	e04a                	sd	s2,0(sp)
    80005a12:	1000                	addi	s0,sp,32
    80005a14:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a16:	00020517          	auipc	a0,0x20
    80005a1a:	72a50513          	addi	a0,a0,1834 # 80026140 <cons>
    80005a1e:	00000097          	auipc	ra,0x0
    80005a22:	7b4080e7          	jalr	1972(ra) # 800061d2 <acquire>

  switch(c){
    80005a26:	47d5                	li	a5,21
    80005a28:	0af48663          	beq	s1,a5,80005ad4 <consoleintr+0xcc>
    80005a2c:	0297ca63          	blt	a5,s1,80005a60 <consoleintr+0x58>
    80005a30:	47a1                	li	a5,8
    80005a32:	0ef48763          	beq	s1,a5,80005b20 <consoleintr+0x118>
    80005a36:	47c1                	li	a5,16
    80005a38:	10f49a63          	bne	s1,a5,80005b4c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a3c:	ffffc097          	auipc	ra,0xffffc
    80005a40:	f7c080e7          	jalr	-132(ra) # 800019b8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a44:	00020517          	auipc	a0,0x20
    80005a48:	6fc50513          	addi	a0,a0,1788 # 80026140 <cons>
    80005a4c:	00001097          	auipc	ra,0x1
    80005a50:	83a080e7          	jalr	-1990(ra) # 80006286 <release>
}
    80005a54:	60e2                	ld	ra,24(sp)
    80005a56:	6442                	ld	s0,16(sp)
    80005a58:	64a2                	ld	s1,8(sp)
    80005a5a:	6902                	ld	s2,0(sp)
    80005a5c:	6105                	addi	sp,sp,32
    80005a5e:	8082                	ret
  switch(c){
    80005a60:	07f00793          	li	a5,127
    80005a64:	0af48e63          	beq	s1,a5,80005b20 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a68:	00020717          	auipc	a4,0x20
    80005a6c:	6d870713          	addi	a4,a4,1752 # 80026140 <cons>
    80005a70:	0a072783          	lw	a5,160(a4)
    80005a74:	09872703          	lw	a4,152(a4)
    80005a78:	9f99                	subw	a5,a5,a4
    80005a7a:	07f00713          	li	a4,127
    80005a7e:	fcf763e3          	bltu	a4,a5,80005a44 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a82:	47b5                	li	a5,13
    80005a84:	0cf48763          	beq	s1,a5,80005b52 <consoleintr+0x14a>
      consputc(c);
    80005a88:	8526                	mv	a0,s1
    80005a8a:	00000097          	auipc	ra,0x0
    80005a8e:	f3c080e7          	jalr	-196(ra) # 800059c6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a92:	00020797          	auipc	a5,0x20
    80005a96:	6ae78793          	addi	a5,a5,1710 # 80026140 <cons>
    80005a9a:	0a07a703          	lw	a4,160(a5)
    80005a9e:	0017069b          	addiw	a3,a4,1
    80005aa2:	0006861b          	sext.w	a2,a3
    80005aa6:	0ad7a023          	sw	a3,160(a5)
    80005aaa:	07f77713          	andi	a4,a4,127
    80005aae:	97ba                	add	a5,a5,a4
    80005ab0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005ab4:	47a9                	li	a5,10
    80005ab6:	0cf48563          	beq	s1,a5,80005b80 <consoleintr+0x178>
    80005aba:	4791                	li	a5,4
    80005abc:	0cf48263          	beq	s1,a5,80005b80 <consoleintr+0x178>
    80005ac0:	00020797          	auipc	a5,0x20
    80005ac4:	7187a783          	lw	a5,1816(a5) # 800261d8 <cons+0x98>
    80005ac8:	0807879b          	addiw	a5,a5,128
    80005acc:	f6f61ce3          	bne	a2,a5,80005a44 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005ad0:	863e                	mv	a2,a5
    80005ad2:	a07d                	j	80005b80 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005ad4:	00020717          	auipc	a4,0x20
    80005ad8:	66c70713          	addi	a4,a4,1644 # 80026140 <cons>
    80005adc:	0a072783          	lw	a5,160(a4)
    80005ae0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ae4:	00020497          	auipc	s1,0x20
    80005ae8:	65c48493          	addi	s1,s1,1628 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005aec:	4929                	li	s2,10
    80005aee:	f4f70be3          	beq	a4,a5,80005a44 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005af2:	37fd                	addiw	a5,a5,-1
    80005af4:	07f7f713          	andi	a4,a5,127
    80005af8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005afa:	01874703          	lbu	a4,24(a4)
    80005afe:	f52703e3          	beq	a4,s2,80005a44 <consoleintr+0x3c>
      cons.e--;
    80005b02:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b06:	10000513          	li	a0,256
    80005b0a:	00000097          	auipc	ra,0x0
    80005b0e:	ebc080e7          	jalr	-324(ra) # 800059c6 <consputc>
    while(cons.e != cons.w &&
    80005b12:	0a04a783          	lw	a5,160(s1)
    80005b16:	09c4a703          	lw	a4,156(s1)
    80005b1a:	fcf71ce3          	bne	a4,a5,80005af2 <consoleintr+0xea>
    80005b1e:	b71d                	j	80005a44 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b20:	00020717          	auipc	a4,0x20
    80005b24:	62070713          	addi	a4,a4,1568 # 80026140 <cons>
    80005b28:	0a072783          	lw	a5,160(a4)
    80005b2c:	09c72703          	lw	a4,156(a4)
    80005b30:	f0f70ae3          	beq	a4,a5,80005a44 <consoleintr+0x3c>
      cons.e--;
    80005b34:	37fd                	addiw	a5,a5,-1
    80005b36:	00020717          	auipc	a4,0x20
    80005b3a:	6af72523          	sw	a5,1706(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b3e:	10000513          	li	a0,256
    80005b42:	00000097          	auipc	ra,0x0
    80005b46:	e84080e7          	jalr	-380(ra) # 800059c6 <consputc>
    80005b4a:	bded                	j	80005a44 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b4c:	ee048ce3          	beqz	s1,80005a44 <consoleintr+0x3c>
    80005b50:	bf21                	j	80005a68 <consoleintr+0x60>
      consputc(c);
    80005b52:	4529                	li	a0,10
    80005b54:	00000097          	auipc	ra,0x0
    80005b58:	e72080e7          	jalr	-398(ra) # 800059c6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b5c:	00020797          	auipc	a5,0x20
    80005b60:	5e478793          	addi	a5,a5,1508 # 80026140 <cons>
    80005b64:	0a07a703          	lw	a4,160(a5)
    80005b68:	0017069b          	addiw	a3,a4,1
    80005b6c:	0006861b          	sext.w	a2,a3
    80005b70:	0ad7a023          	sw	a3,160(a5)
    80005b74:	07f77713          	andi	a4,a4,127
    80005b78:	97ba                	add	a5,a5,a4
    80005b7a:	4729                	li	a4,10
    80005b7c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b80:	00020797          	auipc	a5,0x20
    80005b84:	64c7ae23          	sw	a2,1628(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b88:	00020517          	auipc	a0,0x20
    80005b8c:	65050513          	addi	a0,a0,1616 # 800261d8 <cons+0x98>
    80005b90:	ffffc097          	auipc	ra,0xffffc
    80005b94:	b64080e7          	jalr	-1180(ra) # 800016f4 <wakeup>
    80005b98:	b575                	j	80005a44 <consoleintr+0x3c>

0000000080005b9a <consoleinit>:

void
consoleinit(void)
{
    80005b9a:	1141                	addi	sp,sp,-16
    80005b9c:	e406                	sd	ra,8(sp)
    80005b9e:	e022                	sd	s0,0(sp)
    80005ba0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005ba2:	00003597          	auipc	a1,0x3
    80005ba6:	d7e58593          	addi	a1,a1,-642 # 80008920 <syscalls+0x3d0>
    80005baa:	00020517          	auipc	a0,0x20
    80005bae:	59650513          	addi	a0,a0,1430 # 80026140 <cons>
    80005bb2:	00000097          	auipc	ra,0x0
    80005bb6:	590080e7          	jalr	1424(ra) # 80006142 <initlock>

  uartinit();
    80005bba:	00000097          	auipc	ra,0x0
    80005bbe:	330080e7          	jalr	816(ra) # 80005eea <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005bc2:	00013797          	auipc	a5,0x13
    80005bc6:	50678793          	addi	a5,a5,1286 # 800190c8 <devsw>
    80005bca:	00000717          	auipc	a4,0x0
    80005bce:	ce470713          	addi	a4,a4,-796 # 800058ae <consoleread>
    80005bd2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005bd4:	00000717          	auipc	a4,0x0
    80005bd8:	c7870713          	addi	a4,a4,-904 # 8000584c <consolewrite>
    80005bdc:	ef98                	sd	a4,24(a5)
}
    80005bde:	60a2                	ld	ra,8(sp)
    80005be0:	6402                	ld	s0,0(sp)
    80005be2:	0141                	addi	sp,sp,16
    80005be4:	8082                	ret

0000000080005be6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005be6:	7179                	addi	sp,sp,-48
    80005be8:	f406                	sd	ra,40(sp)
    80005bea:	f022                	sd	s0,32(sp)
    80005bec:	ec26                	sd	s1,24(sp)
    80005bee:	e84a                	sd	s2,16(sp)
    80005bf0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005bf2:	c219                	beqz	a2,80005bf8 <printint+0x12>
    80005bf4:	08054663          	bltz	a0,80005c80 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005bf8:	2501                	sext.w	a0,a0
    80005bfa:	4881                	li	a7,0
    80005bfc:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c00:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c02:	2581                	sext.w	a1,a1
    80005c04:	00003617          	auipc	a2,0x3
    80005c08:	d4c60613          	addi	a2,a2,-692 # 80008950 <digits>
    80005c0c:	883a                	mv	a6,a4
    80005c0e:	2705                	addiw	a4,a4,1
    80005c10:	02b577bb          	remuw	a5,a0,a1
    80005c14:	1782                	slli	a5,a5,0x20
    80005c16:	9381                	srli	a5,a5,0x20
    80005c18:	97b2                	add	a5,a5,a2
    80005c1a:	0007c783          	lbu	a5,0(a5)
    80005c1e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c22:	0005079b          	sext.w	a5,a0
    80005c26:	02b5553b          	divuw	a0,a0,a1
    80005c2a:	0685                	addi	a3,a3,1
    80005c2c:	feb7f0e3          	bgeu	a5,a1,80005c0c <printint+0x26>

  if(sign)
    80005c30:	00088b63          	beqz	a7,80005c46 <printint+0x60>
    buf[i++] = '-';
    80005c34:	fe040793          	addi	a5,s0,-32
    80005c38:	973e                	add	a4,a4,a5
    80005c3a:	02d00793          	li	a5,45
    80005c3e:	fef70823          	sb	a5,-16(a4)
    80005c42:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c46:	02e05763          	blez	a4,80005c74 <printint+0x8e>
    80005c4a:	fd040793          	addi	a5,s0,-48
    80005c4e:	00e784b3          	add	s1,a5,a4
    80005c52:	fff78913          	addi	s2,a5,-1
    80005c56:	993a                	add	s2,s2,a4
    80005c58:	377d                	addiw	a4,a4,-1
    80005c5a:	1702                	slli	a4,a4,0x20
    80005c5c:	9301                	srli	a4,a4,0x20
    80005c5e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c62:	fff4c503          	lbu	a0,-1(s1)
    80005c66:	00000097          	auipc	ra,0x0
    80005c6a:	d60080e7          	jalr	-672(ra) # 800059c6 <consputc>
  while(--i >= 0)
    80005c6e:	14fd                	addi	s1,s1,-1
    80005c70:	ff2499e3          	bne	s1,s2,80005c62 <printint+0x7c>
}
    80005c74:	70a2                	ld	ra,40(sp)
    80005c76:	7402                	ld	s0,32(sp)
    80005c78:	64e2                	ld	s1,24(sp)
    80005c7a:	6942                	ld	s2,16(sp)
    80005c7c:	6145                	addi	sp,sp,48
    80005c7e:	8082                	ret
    x = -xx;
    80005c80:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c84:	4885                	li	a7,1
    x = -xx;
    80005c86:	bf9d                	j	80005bfc <printint+0x16>

0000000080005c88 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c88:	1101                	addi	sp,sp,-32
    80005c8a:	ec06                	sd	ra,24(sp)
    80005c8c:	e822                	sd	s0,16(sp)
    80005c8e:	e426                	sd	s1,8(sp)
    80005c90:	1000                	addi	s0,sp,32
    80005c92:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c94:	00020797          	auipc	a5,0x20
    80005c98:	5607a623          	sw	zero,1388(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005c9c:	00003517          	auipc	a0,0x3
    80005ca0:	c8c50513          	addi	a0,a0,-884 # 80008928 <syscalls+0x3d8>
    80005ca4:	00000097          	auipc	ra,0x0
    80005ca8:	02e080e7          	jalr	46(ra) # 80005cd2 <printf>
  printf(s);
    80005cac:	8526                	mv	a0,s1
    80005cae:	00000097          	auipc	ra,0x0
    80005cb2:	024080e7          	jalr	36(ra) # 80005cd2 <printf>
  printf("\n");
    80005cb6:	00002517          	auipc	a0,0x2
    80005cba:	39250513          	addi	a0,a0,914 # 80008048 <etext+0x48>
    80005cbe:	00000097          	auipc	ra,0x0
    80005cc2:	014080e7          	jalr	20(ra) # 80005cd2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005cc6:	4785                	li	a5,1
    80005cc8:	00003717          	auipc	a4,0x3
    80005ccc:	34f72a23          	sw	a5,852(a4) # 8000901c <panicked>
  for(;;)
    80005cd0:	a001                	j	80005cd0 <panic+0x48>

0000000080005cd2 <printf>:
{
    80005cd2:	7131                	addi	sp,sp,-192
    80005cd4:	fc86                	sd	ra,120(sp)
    80005cd6:	f8a2                	sd	s0,112(sp)
    80005cd8:	f4a6                	sd	s1,104(sp)
    80005cda:	f0ca                	sd	s2,96(sp)
    80005cdc:	ecce                	sd	s3,88(sp)
    80005cde:	e8d2                	sd	s4,80(sp)
    80005ce0:	e4d6                	sd	s5,72(sp)
    80005ce2:	e0da                	sd	s6,64(sp)
    80005ce4:	fc5e                	sd	s7,56(sp)
    80005ce6:	f862                	sd	s8,48(sp)
    80005ce8:	f466                	sd	s9,40(sp)
    80005cea:	f06a                	sd	s10,32(sp)
    80005cec:	ec6e                	sd	s11,24(sp)
    80005cee:	0100                	addi	s0,sp,128
    80005cf0:	8a2a                	mv	s4,a0
    80005cf2:	e40c                	sd	a1,8(s0)
    80005cf4:	e810                	sd	a2,16(s0)
    80005cf6:	ec14                	sd	a3,24(s0)
    80005cf8:	f018                	sd	a4,32(s0)
    80005cfa:	f41c                	sd	a5,40(s0)
    80005cfc:	03043823          	sd	a6,48(s0)
    80005d00:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d04:	00020d97          	auipc	s11,0x20
    80005d08:	4fcdad83          	lw	s11,1276(s11) # 80026200 <pr+0x18>
  if(locking)
    80005d0c:	020d9b63          	bnez	s11,80005d42 <printf+0x70>
  if (fmt == 0)
    80005d10:	040a0263          	beqz	s4,80005d54 <printf+0x82>
  va_start(ap, fmt);
    80005d14:	00840793          	addi	a5,s0,8
    80005d18:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d1c:	000a4503          	lbu	a0,0(s4)
    80005d20:	16050263          	beqz	a0,80005e84 <printf+0x1b2>
    80005d24:	4481                	li	s1,0
    if(c != '%'){
    80005d26:	02500a93          	li	s5,37
    switch(c){
    80005d2a:	07000b13          	li	s6,112
  consputc('x');
    80005d2e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d30:	00003b97          	auipc	s7,0x3
    80005d34:	c20b8b93          	addi	s7,s7,-992 # 80008950 <digits>
    switch(c){
    80005d38:	07300c93          	li	s9,115
    80005d3c:	06400c13          	li	s8,100
    80005d40:	a82d                	j	80005d7a <printf+0xa8>
    acquire(&pr.lock);
    80005d42:	00020517          	auipc	a0,0x20
    80005d46:	4a650513          	addi	a0,a0,1190 # 800261e8 <pr>
    80005d4a:	00000097          	auipc	ra,0x0
    80005d4e:	488080e7          	jalr	1160(ra) # 800061d2 <acquire>
    80005d52:	bf7d                	j	80005d10 <printf+0x3e>
    panic("null fmt");
    80005d54:	00003517          	auipc	a0,0x3
    80005d58:	be450513          	addi	a0,a0,-1052 # 80008938 <syscalls+0x3e8>
    80005d5c:	00000097          	auipc	ra,0x0
    80005d60:	f2c080e7          	jalr	-212(ra) # 80005c88 <panic>
      consputc(c);
    80005d64:	00000097          	auipc	ra,0x0
    80005d68:	c62080e7          	jalr	-926(ra) # 800059c6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d6c:	2485                	addiw	s1,s1,1
    80005d6e:	009a07b3          	add	a5,s4,s1
    80005d72:	0007c503          	lbu	a0,0(a5)
    80005d76:	10050763          	beqz	a0,80005e84 <printf+0x1b2>
    if(c != '%'){
    80005d7a:	ff5515e3          	bne	a0,s5,80005d64 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d7e:	2485                	addiw	s1,s1,1
    80005d80:	009a07b3          	add	a5,s4,s1
    80005d84:	0007c783          	lbu	a5,0(a5)
    80005d88:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005d8c:	cfe5                	beqz	a5,80005e84 <printf+0x1b2>
    switch(c){
    80005d8e:	05678a63          	beq	a5,s6,80005de2 <printf+0x110>
    80005d92:	02fb7663          	bgeu	s6,a5,80005dbe <printf+0xec>
    80005d96:	09978963          	beq	a5,s9,80005e28 <printf+0x156>
    80005d9a:	07800713          	li	a4,120
    80005d9e:	0ce79863          	bne	a5,a4,80005e6e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005da2:	f8843783          	ld	a5,-120(s0)
    80005da6:	00878713          	addi	a4,a5,8
    80005daa:	f8e43423          	sd	a4,-120(s0)
    80005dae:	4605                	li	a2,1
    80005db0:	85ea                	mv	a1,s10
    80005db2:	4388                	lw	a0,0(a5)
    80005db4:	00000097          	auipc	ra,0x0
    80005db8:	e32080e7          	jalr	-462(ra) # 80005be6 <printint>
      break;
    80005dbc:	bf45                	j	80005d6c <printf+0x9a>
    switch(c){
    80005dbe:	0b578263          	beq	a5,s5,80005e62 <printf+0x190>
    80005dc2:	0b879663          	bne	a5,s8,80005e6e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005dc6:	f8843783          	ld	a5,-120(s0)
    80005dca:	00878713          	addi	a4,a5,8
    80005dce:	f8e43423          	sd	a4,-120(s0)
    80005dd2:	4605                	li	a2,1
    80005dd4:	45a9                	li	a1,10
    80005dd6:	4388                	lw	a0,0(a5)
    80005dd8:	00000097          	auipc	ra,0x0
    80005ddc:	e0e080e7          	jalr	-498(ra) # 80005be6 <printint>
      break;
    80005de0:	b771                	j	80005d6c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005de2:	f8843783          	ld	a5,-120(s0)
    80005de6:	00878713          	addi	a4,a5,8
    80005dea:	f8e43423          	sd	a4,-120(s0)
    80005dee:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005df2:	03000513          	li	a0,48
    80005df6:	00000097          	auipc	ra,0x0
    80005dfa:	bd0080e7          	jalr	-1072(ra) # 800059c6 <consputc>
  consputc('x');
    80005dfe:	07800513          	li	a0,120
    80005e02:	00000097          	auipc	ra,0x0
    80005e06:	bc4080e7          	jalr	-1084(ra) # 800059c6 <consputc>
    80005e0a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e0c:	03c9d793          	srli	a5,s3,0x3c
    80005e10:	97de                	add	a5,a5,s7
    80005e12:	0007c503          	lbu	a0,0(a5)
    80005e16:	00000097          	auipc	ra,0x0
    80005e1a:	bb0080e7          	jalr	-1104(ra) # 800059c6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e1e:	0992                	slli	s3,s3,0x4
    80005e20:	397d                	addiw	s2,s2,-1
    80005e22:	fe0915e3          	bnez	s2,80005e0c <printf+0x13a>
    80005e26:	b799                	j	80005d6c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e28:	f8843783          	ld	a5,-120(s0)
    80005e2c:	00878713          	addi	a4,a5,8
    80005e30:	f8e43423          	sd	a4,-120(s0)
    80005e34:	0007b903          	ld	s2,0(a5)
    80005e38:	00090e63          	beqz	s2,80005e54 <printf+0x182>
      for(; *s; s++)
    80005e3c:	00094503          	lbu	a0,0(s2)
    80005e40:	d515                	beqz	a0,80005d6c <printf+0x9a>
        consputc(*s);
    80005e42:	00000097          	auipc	ra,0x0
    80005e46:	b84080e7          	jalr	-1148(ra) # 800059c6 <consputc>
      for(; *s; s++)
    80005e4a:	0905                	addi	s2,s2,1
    80005e4c:	00094503          	lbu	a0,0(s2)
    80005e50:	f96d                	bnez	a0,80005e42 <printf+0x170>
    80005e52:	bf29                	j	80005d6c <printf+0x9a>
        s = "(null)";
    80005e54:	00003917          	auipc	s2,0x3
    80005e58:	adc90913          	addi	s2,s2,-1316 # 80008930 <syscalls+0x3e0>
      for(; *s; s++)
    80005e5c:	02800513          	li	a0,40
    80005e60:	b7cd                	j	80005e42 <printf+0x170>
      consputc('%');
    80005e62:	8556                	mv	a0,s5
    80005e64:	00000097          	auipc	ra,0x0
    80005e68:	b62080e7          	jalr	-1182(ra) # 800059c6 <consputc>
      break;
    80005e6c:	b701                	j	80005d6c <printf+0x9a>
      consputc('%');
    80005e6e:	8556                	mv	a0,s5
    80005e70:	00000097          	auipc	ra,0x0
    80005e74:	b56080e7          	jalr	-1194(ra) # 800059c6 <consputc>
      consputc(c);
    80005e78:	854a                	mv	a0,s2
    80005e7a:	00000097          	auipc	ra,0x0
    80005e7e:	b4c080e7          	jalr	-1204(ra) # 800059c6 <consputc>
      break;
    80005e82:	b5ed                	j	80005d6c <printf+0x9a>
  if(locking)
    80005e84:	020d9163          	bnez	s11,80005ea6 <printf+0x1d4>
}
    80005e88:	70e6                	ld	ra,120(sp)
    80005e8a:	7446                	ld	s0,112(sp)
    80005e8c:	74a6                	ld	s1,104(sp)
    80005e8e:	7906                	ld	s2,96(sp)
    80005e90:	69e6                	ld	s3,88(sp)
    80005e92:	6a46                	ld	s4,80(sp)
    80005e94:	6aa6                	ld	s5,72(sp)
    80005e96:	6b06                	ld	s6,64(sp)
    80005e98:	7be2                	ld	s7,56(sp)
    80005e9a:	7c42                	ld	s8,48(sp)
    80005e9c:	7ca2                	ld	s9,40(sp)
    80005e9e:	7d02                	ld	s10,32(sp)
    80005ea0:	6de2                	ld	s11,24(sp)
    80005ea2:	6129                	addi	sp,sp,192
    80005ea4:	8082                	ret
    release(&pr.lock);
    80005ea6:	00020517          	auipc	a0,0x20
    80005eaa:	34250513          	addi	a0,a0,834 # 800261e8 <pr>
    80005eae:	00000097          	auipc	ra,0x0
    80005eb2:	3d8080e7          	jalr	984(ra) # 80006286 <release>
}
    80005eb6:	bfc9                	j	80005e88 <printf+0x1b6>

0000000080005eb8 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005eb8:	1101                	addi	sp,sp,-32
    80005eba:	ec06                	sd	ra,24(sp)
    80005ebc:	e822                	sd	s0,16(sp)
    80005ebe:	e426                	sd	s1,8(sp)
    80005ec0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005ec2:	00020497          	auipc	s1,0x20
    80005ec6:	32648493          	addi	s1,s1,806 # 800261e8 <pr>
    80005eca:	00003597          	auipc	a1,0x3
    80005ece:	a7e58593          	addi	a1,a1,-1410 # 80008948 <syscalls+0x3f8>
    80005ed2:	8526                	mv	a0,s1
    80005ed4:	00000097          	auipc	ra,0x0
    80005ed8:	26e080e7          	jalr	622(ra) # 80006142 <initlock>
  pr.locking = 1;
    80005edc:	4785                	li	a5,1
    80005ede:	cc9c                	sw	a5,24(s1)
}
    80005ee0:	60e2                	ld	ra,24(sp)
    80005ee2:	6442                	ld	s0,16(sp)
    80005ee4:	64a2                	ld	s1,8(sp)
    80005ee6:	6105                	addi	sp,sp,32
    80005ee8:	8082                	ret

0000000080005eea <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005eea:	1141                	addi	sp,sp,-16
    80005eec:	e406                	sd	ra,8(sp)
    80005eee:	e022                	sd	s0,0(sp)
    80005ef0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ef2:	100007b7          	lui	a5,0x10000
    80005ef6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005efa:	f8000713          	li	a4,-128
    80005efe:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f02:	470d                	li	a4,3
    80005f04:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f08:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f0c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f10:	469d                	li	a3,7
    80005f12:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f16:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f1a:	00003597          	auipc	a1,0x3
    80005f1e:	a4e58593          	addi	a1,a1,-1458 # 80008968 <digits+0x18>
    80005f22:	00020517          	auipc	a0,0x20
    80005f26:	2e650513          	addi	a0,a0,742 # 80026208 <uart_tx_lock>
    80005f2a:	00000097          	auipc	ra,0x0
    80005f2e:	218080e7          	jalr	536(ra) # 80006142 <initlock>
}
    80005f32:	60a2                	ld	ra,8(sp)
    80005f34:	6402                	ld	s0,0(sp)
    80005f36:	0141                	addi	sp,sp,16
    80005f38:	8082                	ret

0000000080005f3a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f3a:	1101                	addi	sp,sp,-32
    80005f3c:	ec06                	sd	ra,24(sp)
    80005f3e:	e822                	sd	s0,16(sp)
    80005f40:	e426                	sd	s1,8(sp)
    80005f42:	1000                	addi	s0,sp,32
    80005f44:	84aa                	mv	s1,a0
  push_off();
    80005f46:	00000097          	auipc	ra,0x0
    80005f4a:	240080e7          	jalr	576(ra) # 80006186 <push_off>

  if(panicked){
    80005f4e:	00003797          	auipc	a5,0x3
    80005f52:	0ce7a783          	lw	a5,206(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f56:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f5a:	c391                	beqz	a5,80005f5e <uartputc_sync+0x24>
    for(;;)
    80005f5c:	a001                	j	80005f5c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f5e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f62:	0ff7f793          	andi	a5,a5,255
    80005f66:	0207f793          	andi	a5,a5,32
    80005f6a:	dbf5                	beqz	a5,80005f5e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f6c:	0ff4f793          	andi	a5,s1,255
    80005f70:	10000737          	lui	a4,0x10000
    80005f74:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f78:	00000097          	auipc	ra,0x0
    80005f7c:	2ae080e7          	jalr	686(ra) # 80006226 <pop_off>
}
    80005f80:	60e2                	ld	ra,24(sp)
    80005f82:	6442                	ld	s0,16(sp)
    80005f84:	64a2                	ld	s1,8(sp)
    80005f86:	6105                	addi	sp,sp,32
    80005f88:	8082                	ret

0000000080005f8a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f8a:	00003717          	auipc	a4,0x3
    80005f8e:	09673703          	ld	a4,150(a4) # 80009020 <uart_tx_r>
    80005f92:	00003797          	auipc	a5,0x3
    80005f96:	0967b783          	ld	a5,150(a5) # 80009028 <uart_tx_w>
    80005f9a:	06e78c63          	beq	a5,a4,80006012 <uartstart+0x88>
{
    80005f9e:	7139                	addi	sp,sp,-64
    80005fa0:	fc06                	sd	ra,56(sp)
    80005fa2:	f822                	sd	s0,48(sp)
    80005fa4:	f426                	sd	s1,40(sp)
    80005fa6:	f04a                	sd	s2,32(sp)
    80005fa8:	ec4e                	sd	s3,24(sp)
    80005faa:	e852                	sd	s4,16(sp)
    80005fac:	e456                	sd	s5,8(sp)
    80005fae:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fb0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fb4:	00020a17          	auipc	s4,0x20
    80005fb8:	254a0a13          	addi	s4,s4,596 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005fbc:	00003497          	auipc	s1,0x3
    80005fc0:	06448493          	addi	s1,s1,100 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005fc4:	00003997          	auipc	s3,0x3
    80005fc8:	06498993          	addi	s3,s3,100 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fcc:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005fd0:	0ff7f793          	andi	a5,a5,255
    80005fd4:	0207f793          	andi	a5,a5,32
    80005fd8:	c785                	beqz	a5,80006000 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fda:	01f77793          	andi	a5,a4,31
    80005fde:	97d2                	add	a5,a5,s4
    80005fe0:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80005fe4:	0705                	addi	a4,a4,1
    80005fe6:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005fe8:	8526                	mv	a0,s1
    80005fea:	ffffb097          	auipc	ra,0xffffb
    80005fee:	70a080e7          	jalr	1802(ra) # 800016f4 <wakeup>
    
    WriteReg(THR, c);
    80005ff2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005ff6:	6098                	ld	a4,0(s1)
    80005ff8:	0009b783          	ld	a5,0(s3)
    80005ffc:	fce798e3          	bne	a5,a4,80005fcc <uartstart+0x42>
  }
}
    80006000:	70e2                	ld	ra,56(sp)
    80006002:	7442                	ld	s0,48(sp)
    80006004:	74a2                	ld	s1,40(sp)
    80006006:	7902                	ld	s2,32(sp)
    80006008:	69e2                	ld	s3,24(sp)
    8000600a:	6a42                	ld	s4,16(sp)
    8000600c:	6aa2                	ld	s5,8(sp)
    8000600e:	6121                	addi	sp,sp,64
    80006010:	8082                	ret
    80006012:	8082                	ret

0000000080006014 <uartputc>:
{
    80006014:	7179                	addi	sp,sp,-48
    80006016:	f406                	sd	ra,40(sp)
    80006018:	f022                	sd	s0,32(sp)
    8000601a:	ec26                	sd	s1,24(sp)
    8000601c:	e84a                	sd	s2,16(sp)
    8000601e:	e44e                	sd	s3,8(sp)
    80006020:	e052                	sd	s4,0(sp)
    80006022:	1800                	addi	s0,sp,48
    80006024:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006026:	00020517          	auipc	a0,0x20
    8000602a:	1e250513          	addi	a0,a0,482 # 80026208 <uart_tx_lock>
    8000602e:	00000097          	auipc	ra,0x0
    80006032:	1a4080e7          	jalr	420(ra) # 800061d2 <acquire>
  if(panicked){
    80006036:	00003797          	auipc	a5,0x3
    8000603a:	fe67a783          	lw	a5,-26(a5) # 8000901c <panicked>
    8000603e:	c391                	beqz	a5,80006042 <uartputc+0x2e>
    for(;;)
    80006040:	a001                	j	80006040 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006042:	00003797          	auipc	a5,0x3
    80006046:	fe67b783          	ld	a5,-26(a5) # 80009028 <uart_tx_w>
    8000604a:	00003717          	auipc	a4,0x3
    8000604e:	fd673703          	ld	a4,-42(a4) # 80009020 <uart_tx_r>
    80006052:	02070713          	addi	a4,a4,32
    80006056:	02f71b63          	bne	a4,a5,8000608c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000605a:	00020a17          	auipc	s4,0x20
    8000605e:	1aea0a13          	addi	s4,s4,430 # 80026208 <uart_tx_lock>
    80006062:	00003497          	auipc	s1,0x3
    80006066:	fbe48493          	addi	s1,s1,-66 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000606a:	00003917          	auipc	s2,0x3
    8000606e:	fbe90913          	addi	s2,s2,-66 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006072:	85d2                	mv	a1,s4
    80006074:	8526                	mv	a0,s1
    80006076:	ffffb097          	auipc	ra,0xffffb
    8000607a:	4f2080e7          	jalr	1266(ra) # 80001568 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000607e:	00093783          	ld	a5,0(s2)
    80006082:	6098                	ld	a4,0(s1)
    80006084:	02070713          	addi	a4,a4,32
    80006088:	fef705e3          	beq	a4,a5,80006072 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000608c:	00020497          	auipc	s1,0x20
    80006090:	17c48493          	addi	s1,s1,380 # 80026208 <uart_tx_lock>
    80006094:	01f7f713          	andi	a4,a5,31
    80006098:	9726                	add	a4,a4,s1
    8000609a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000609e:	0785                	addi	a5,a5,1
    800060a0:	00003717          	auipc	a4,0x3
    800060a4:	f8f73423          	sd	a5,-120(a4) # 80009028 <uart_tx_w>
      uartstart();
    800060a8:	00000097          	auipc	ra,0x0
    800060ac:	ee2080e7          	jalr	-286(ra) # 80005f8a <uartstart>
      release(&uart_tx_lock);
    800060b0:	8526                	mv	a0,s1
    800060b2:	00000097          	auipc	ra,0x0
    800060b6:	1d4080e7          	jalr	468(ra) # 80006286 <release>
}
    800060ba:	70a2                	ld	ra,40(sp)
    800060bc:	7402                	ld	s0,32(sp)
    800060be:	64e2                	ld	s1,24(sp)
    800060c0:	6942                	ld	s2,16(sp)
    800060c2:	69a2                	ld	s3,8(sp)
    800060c4:	6a02                	ld	s4,0(sp)
    800060c6:	6145                	addi	sp,sp,48
    800060c8:	8082                	ret

00000000800060ca <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060ca:	1141                	addi	sp,sp,-16
    800060cc:	e422                	sd	s0,8(sp)
    800060ce:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060d0:	100007b7          	lui	a5,0x10000
    800060d4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060d8:	8b85                	andi	a5,a5,1
    800060da:	cb91                	beqz	a5,800060ee <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800060dc:	100007b7          	lui	a5,0x10000
    800060e0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800060e4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800060e8:	6422                	ld	s0,8(sp)
    800060ea:	0141                	addi	sp,sp,16
    800060ec:	8082                	ret
    return -1;
    800060ee:	557d                	li	a0,-1
    800060f0:	bfe5                	j	800060e8 <uartgetc+0x1e>

00000000800060f2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800060f2:	1101                	addi	sp,sp,-32
    800060f4:	ec06                	sd	ra,24(sp)
    800060f6:	e822                	sd	s0,16(sp)
    800060f8:	e426                	sd	s1,8(sp)
    800060fa:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060fc:	54fd                	li	s1,-1
    int c = uartgetc();
    800060fe:	00000097          	auipc	ra,0x0
    80006102:	fcc080e7          	jalr	-52(ra) # 800060ca <uartgetc>
    if(c == -1)
    80006106:	00950763          	beq	a0,s1,80006114 <uartintr+0x22>
      break;
    consoleintr(c);
    8000610a:	00000097          	auipc	ra,0x0
    8000610e:	8fe080e7          	jalr	-1794(ra) # 80005a08 <consoleintr>
  while(1){
    80006112:	b7f5                	j	800060fe <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006114:	00020497          	auipc	s1,0x20
    80006118:	0f448493          	addi	s1,s1,244 # 80026208 <uart_tx_lock>
    8000611c:	8526                	mv	a0,s1
    8000611e:	00000097          	auipc	ra,0x0
    80006122:	0b4080e7          	jalr	180(ra) # 800061d2 <acquire>
  uartstart();
    80006126:	00000097          	auipc	ra,0x0
    8000612a:	e64080e7          	jalr	-412(ra) # 80005f8a <uartstart>
  release(&uart_tx_lock);
    8000612e:	8526                	mv	a0,s1
    80006130:	00000097          	auipc	ra,0x0
    80006134:	156080e7          	jalr	342(ra) # 80006286 <release>
}
    80006138:	60e2                	ld	ra,24(sp)
    8000613a:	6442                	ld	s0,16(sp)
    8000613c:	64a2                	ld	s1,8(sp)
    8000613e:	6105                	addi	sp,sp,32
    80006140:	8082                	ret

0000000080006142 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006142:	1141                	addi	sp,sp,-16
    80006144:	e422                	sd	s0,8(sp)
    80006146:	0800                	addi	s0,sp,16
  lk->name = name;
    80006148:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000614a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000614e:	00053823          	sd	zero,16(a0)
}
    80006152:	6422                	ld	s0,8(sp)
    80006154:	0141                	addi	sp,sp,16
    80006156:	8082                	ret

0000000080006158 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006158:	411c                	lw	a5,0(a0)
    8000615a:	e399                	bnez	a5,80006160 <holding+0x8>
    8000615c:	4501                	li	a0,0
  return r;
}
    8000615e:	8082                	ret
{
    80006160:	1101                	addi	sp,sp,-32
    80006162:	ec06                	sd	ra,24(sp)
    80006164:	e822                	sd	s0,16(sp)
    80006166:	e426                	sd	s1,8(sp)
    80006168:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000616a:	6904                	ld	s1,16(a0)
    8000616c:	ffffb097          	auipc	ra,0xffffb
    80006170:	ce6080e7          	jalr	-794(ra) # 80000e52 <mycpu>
    80006174:	40a48533          	sub	a0,s1,a0
    80006178:	00153513          	seqz	a0,a0
}
    8000617c:	60e2                	ld	ra,24(sp)
    8000617e:	6442                	ld	s0,16(sp)
    80006180:	64a2                	ld	s1,8(sp)
    80006182:	6105                	addi	sp,sp,32
    80006184:	8082                	ret

0000000080006186 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006186:	1101                	addi	sp,sp,-32
    80006188:	ec06                	sd	ra,24(sp)
    8000618a:	e822                	sd	s0,16(sp)
    8000618c:	e426                	sd	s1,8(sp)
    8000618e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006190:	100024f3          	csrr	s1,sstatus
    80006194:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006198:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000619a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000619e:	ffffb097          	auipc	ra,0xffffb
    800061a2:	cb4080e7          	jalr	-844(ra) # 80000e52 <mycpu>
    800061a6:	5d3c                	lw	a5,120(a0)
    800061a8:	cf89                	beqz	a5,800061c2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800061aa:	ffffb097          	auipc	ra,0xffffb
    800061ae:	ca8080e7          	jalr	-856(ra) # 80000e52 <mycpu>
    800061b2:	5d3c                	lw	a5,120(a0)
    800061b4:	2785                	addiw	a5,a5,1
    800061b6:	dd3c                	sw	a5,120(a0)
}
    800061b8:	60e2                	ld	ra,24(sp)
    800061ba:	6442                	ld	s0,16(sp)
    800061bc:	64a2                	ld	s1,8(sp)
    800061be:	6105                	addi	sp,sp,32
    800061c0:	8082                	ret
    mycpu()->intena = old;
    800061c2:	ffffb097          	auipc	ra,0xffffb
    800061c6:	c90080e7          	jalr	-880(ra) # 80000e52 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061ca:	8085                	srli	s1,s1,0x1
    800061cc:	8885                	andi	s1,s1,1
    800061ce:	dd64                	sw	s1,124(a0)
    800061d0:	bfe9                	j	800061aa <push_off+0x24>

00000000800061d2 <acquire>:
{
    800061d2:	1101                	addi	sp,sp,-32
    800061d4:	ec06                	sd	ra,24(sp)
    800061d6:	e822                	sd	s0,16(sp)
    800061d8:	e426                	sd	s1,8(sp)
    800061da:	1000                	addi	s0,sp,32
    800061dc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061de:	00000097          	auipc	ra,0x0
    800061e2:	fa8080e7          	jalr	-88(ra) # 80006186 <push_off>
  if(holding(lk))
    800061e6:	8526                	mv	a0,s1
    800061e8:	00000097          	auipc	ra,0x0
    800061ec:	f70080e7          	jalr	-144(ra) # 80006158 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061f0:	4705                	li	a4,1
  if(holding(lk))
    800061f2:	e115                	bnez	a0,80006216 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061f4:	87ba                	mv	a5,a4
    800061f6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061fa:	2781                	sext.w	a5,a5
    800061fc:	ffe5                	bnez	a5,800061f4 <acquire+0x22>
  __sync_synchronize();
    800061fe:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006202:	ffffb097          	auipc	ra,0xffffb
    80006206:	c50080e7          	jalr	-944(ra) # 80000e52 <mycpu>
    8000620a:	e888                	sd	a0,16(s1)
}
    8000620c:	60e2                	ld	ra,24(sp)
    8000620e:	6442                	ld	s0,16(sp)
    80006210:	64a2                	ld	s1,8(sp)
    80006212:	6105                	addi	sp,sp,32
    80006214:	8082                	ret
    panic("acquire");
    80006216:	00002517          	auipc	a0,0x2
    8000621a:	75a50513          	addi	a0,a0,1882 # 80008970 <digits+0x20>
    8000621e:	00000097          	auipc	ra,0x0
    80006222:	a6a080e7          	jalr	-1430(ra) # 80005c88 <panic>

0000000080006226 <pop_off>:

void
pop_off(void)
{
    80006226:	1141                	addi	sp,sp,-16
    80006228:	e406                	sd	ra,8(sp)
    8000622a:	e022                	sd	s0,0(sp)
    8000622c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000622e:	ffffb097          	auipc	ra,0xffffb
    80006232:	c24080e7          	jalr	-988(ra) # 80000e52 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006236:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000623a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000623c:	e78d                	bnez	a5,80006266 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000623e:	5d3c                	lw	a5,120(a0)
    80006240:	02f05b63          	blez	a5,80006276 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006244:	37fd                	addiw	a5,a5,-1
    80006246:	0007871b          	sext.w	a4,a5
    8000624a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000624c:	eb09                	bnez	a4,8000625e <pop_off+0x38>
    8000624e:	5d7c                	lw	a5,124(a0)
    80006250:	c799                	beqz	a5,8000625e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006252:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006256:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000625a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000625e:	60a2                	ld	ra,8(sp)
    80006260:	6402                	ld	s0,0(sp)
    80006262:	0141                	addi	sp,sp,16
    80006264:	8082                	ret
    panic("pop_off - interruptible");
    80006266:	00002517          	auipc	a0,0x2
    8000626a:	71250513          	addi	a0,a0,1810 # 80008978 <digits+0x28>
    8000626e:	00000097          	auipc	ra,0x0
    80006272:	a1a080e7          	jalr	-1510(ra) # 80005c88 <panic>
    panic("pop_off");
    80006276:	00002517          	auipc	a0,0x2
    8000627a:	71a50513          	addi	a0,a0,1818 # 80008990 <digits+0x40>
    8000627e:	00000097          	auipc	ra,0x0
    80006282:	a0a080e7          	jalr	-1526(ra) # 80005c88 <panic>

0000000080006286 <release>:
{
    80006286:	1101                	addi	sp,sp,-32
    80006288:	ec06                	sd	ra,24(sp)
    8000628a:	e822                	sd	s0,16(sp)
    8000628c:	e426                	sd	s1,8(sp)
    8000628e:	1000                	addi	s0,sp,32
    80006290:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006292:	00000097          	auipc	ra,0x0
    80006296:	ec6080e7          	jalr	-314(ra) # 80006158 <holding>
    8000629a:	c115                	beqz	a0,800062be <release+0x38>
  lk->cpu = 0;
    8000629c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062a0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062a4:	0f50000f          	fence	iorw,ow
    800062a8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800062ac:	00000097          	auipc	ra,0x0
    800062b0:	f7a080e7          	jalr	-134(ra) # 80006226 <pop_off>
}
    800062b4:	60e2                	ld	ra,24(sp)
    800062b6:	6442                	ld	s0,16(sp)
    800062b8:	64a2                	ld	s1,8(sp)
    800062ba:	6105                	addi	sp,sp,32
    800062bc:	8082                	ret
    panic("release");
    800062be:	00002517          	auipc	a0,0x2
    800062c2:	6da50513          	addi	a0,a0,1754 # 80008998 <digits+0x48>
    800062c6:	00000097          	auipc	ra,0x0
    800062ca:	9c2080e7          	jalr	-1598(ra) # 80005c88 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
