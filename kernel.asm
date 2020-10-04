
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 b0 2e 10 80       	mov    $0x80102eb0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 72 10 80       	push   $0x801072c0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 55 44 00 00       	call   801044b0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 72 10 80       	push   $0x801072c7
80100097:	50                   	push   %eax
80100098:	e8 e3 42 00 00       	call   80104380 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 07 45 00 00       	call   801045f0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 49 45 00 00       	call   801046b0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 42 00 00       	call   801043c0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 ad 1f 00 00       	call   80102130 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ce 72 10 80       	push   $0x801072ce
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 ad 42 00 00       	call   80104460 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 67 1f 00 00       	jmp    80102130 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 df 72 10 80       	push   $0x801072df
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 6c 42 00 00       	call   80104460 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 1c 42 00 00       	call   80104420 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 e0 43 00 00       	call   801045f0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 4f 44 00 00       	jmp    801046b0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 72 10 80       	push   $0x801072e6
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 eb 14 00 00       	call   80101770 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 5f 43 00 00       	call   801045f0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002a7:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002c5:	e8 26 3b 00 00       	call   80103df0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 20 35 00 00       	call   80103800 <myproc>
801002e0:	8b 40 28             	mov    0x28(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 bc 43 00 00       	call   801046b0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 94 13 00 00       	call   80101690 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 5e 43 00 00       	call   801046b0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 36 13 00 00       	call   80101690 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 92 23 00 00       	call   80102740 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ed 72 10 80       	push   $0x801072ed
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 53 7d 10 80 	movl   $0x80107d53,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 f3 40 00 00       	call   801044d0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 01 73 10 80       	push   $0x80107301
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 81 5a 00 00       	call   80105ec0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 cf 59 00 00       	call   80105ec0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 c3 59 00 00       	call   80105ec0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 b7 59 00 00       	call   80105ec0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 87 42 00 00       	call   801047b0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 ba 41 00 00       	call   80104700 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 05 73 10 80       	push   $0x80107305
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 30 73 10 80 	movzbl -0x7fef8cd0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 5c 11 00 00       	call   80101770 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 d0 3f 00 00       	call   801045f0 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 64 40 00 00       	call   801046b0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 3b 10 00 00       	call   80101690 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 8c 3f 00 00       	call   801046b0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 18 73 10 80       	mov    $0x80107318,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 fb 3d 00 00       	call   801045f0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 1f 73 10 80       	push   $0x8010731f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 c8 3d 00 00       	call   801045f0 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100856:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 a5 10 80       	push   $0x8010a520
80100888:	e8 23 3e 00 00       	call   801046b0 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100911:	68 a0 ff 10 80       	push   $0x8010ffa0
80100916:	e8 95 36 00 00       	call   80103fb0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010093d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100964:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 f4 36 00 00       	jmp    80104090 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 28 73 10 80       	push   $0x80107328
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 db 3a 00 00       	call   801044b0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 e2 18 00 00       	call   801022e0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 df 2d 00 00       	call   80103800 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 84 21 00 00       	call   80102bb0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 b9 14 00 00       	call   80101ef0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 43 0c 00 00       	call   80101690 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 12 0f 00 00       	call   80101970 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 b1 0e 00 00       	call   80101920 <iunlockput>
    end_op();
80100a6f:	e8 ac 21 00 00       	call   80102c20 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 77 65 00 00       	call   80107010 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 96 02 00 00    	je     80100d55 <exec+0x345>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 35 63 00 00       	call   80106e30 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 43 62 00 00       	call   80106d70 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 13 0e 00 00       	call   80101970 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 19 64 00 00       	call   80106f90 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 86 0d 00 00       	call   80101920 <iunlockput>
  end_op();
80100b9a:	e8 81 20 00 00       	call   80102c20 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 81 62 00 00       	call   80106e30 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 ca 63 00 00       	call   80106f90 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 48 20 00 00       	call   80102c20 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 41 73 10 80       	push   $0x80107341
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 a5 64 00 00       	call   801070b0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 e2 3c 00 00       	call   80104920 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 cf 3c 00 00       	call   80104920 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 ae 65 00 00       	call   80107210 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 44 65 00 00       	call   80107210 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 70             	add    $0x70,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 d1 3b 00 00       	call   801048e0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  curproc->priority=3;
80100d31:	c7 81 80 00 00 00 03 	movl   $0x3,0x80(%ecx)
80100d38:	00 00 00 
  switchuvm(curproc);
80100d3b:	89 0c 24             	mov    %ecx,(%esp)
80100d3e:	e8 9d 5e 00 00       	call   80106be0 <switchuvm>
  freevm(oldpgdir);
80100d43:	89 3c 24             	mov    %edi,(%esp)
80100d46:	e8 45 62 00 00       	call   80106f90 <freevm>
  return 0;
80100d4b:	83 c4 10             	add    $0x10,%esp
80100d4e:	31 c0                	xor    %eax,%eax
80100d50:	e9 27 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d55:	be 00 20 00 00       	mov    $0x2000,%esi
80100d5a:	e9 32 fe ff ff       	jmp    80100b91 <exec+0x181>
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 4d 73 10 80       	push   $0x8010734d
80100d6b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d70:	e8 3b 37 00 00       	call   801044b0 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d91:	e8 5a 38 00 00       	call   801045f0 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dc1:	e8 ea 38 00 00       	call   801046b0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dda:	e8 d1 38 00 00       	call   801046b0 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dff:	e8 ec 37 00 00       	call   801045f0 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e1c:	e8 8f 38 00 00       	call   801046b0 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 54 73 10 80       	push   $0x80107354
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e51:	e8 9a 37 00 00       	call   801045f0 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 2f 38 00 00       	jmp    801046b0 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 03 38 00 00       	call   801046b0 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 8a 24 00 00       	call   80103360 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 cb 1c 00 00       	call   80102bb0 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 d0 08 00 00       	call   801017c0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 21 1d 00 00       	jmp    80102c20 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 5c 73 10 80       	push   $0x8010735c
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 66 07 00 00       	call   80101690 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 09 0a 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 30 08 00 00       	call   80101770 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 01 07 00 00       	call   80101690 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 d4 09 00 00       	call   80101970 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 bd 07 00 00       	call   80101770 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 3e 25 00 00       	jmp    80103510 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 66 73 10 80       	push   $0x80107366
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 27 07 00 00       	call   80101770 <iunlock>
      end_op();
80101049:	e8 d2 1b 00 00       	call   80102c20 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 35 1b 00 00       	call   80102bb0 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 0a 06 00 00       	call   80101690 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 d8 09 00 00       	call   80101a70 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 c3 06 00 00       	call   80101770 <iunlock>
      end_op();
801010ad:	e8 6e 1b 00 00       	call   80102c20 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 0e 23 00 00       	jmp    80103400 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 6f 73 10 80       	push   $0x8010736f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 75 73 10 80       	push   $0x80107375
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101119:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010111f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101122:	85 c9                	test   %ecx,%ecx
80101124:	0f 84 87 00 00 00    	je     801011b1 <balloc+0xa1>
8010112a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101131:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101134:	83 ec 08             	sub    $0x8,%esp
80101137:	89 f0                	mov    %esi,%eax
80101139:	c1 f8 0c             	sar    $0xc,%eax
8010113c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101142:	50                   	push   %eax
80101143:	ff 75 d8             	pushl  -0x28(%ebp)
80101146:	e8 85 ef ff ff       	call   801000d0 <bread>
8010114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101153:	83 c4 10             	add    $0x10,%esp
80101156:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101159:	31 c0                	xor    %eax,%eax
8010115b:	eb 2f                	jmp    8010118c <balloc+0x7c>
8010115d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101160:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101162:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101165:	bb 01 00 00 00       	mov    $0x1,%ebx
8010116a:	83 e1 07             	and    $0x7,%ecx
8010116d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116f:	89 c1                	mov    %eax,%ecx
80101171:	c1 f9 03             	sar    $0x3,%ecx
80101174:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101179:	85 df                	test   %ebx,%edi
8010117b:	89 fa                	mov    %edi,%edx
8010117d:	74 41                	je     801011c0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010117f:	83 c0 01             	add    $0x1,%eax
80101182:	83 c6 01             	add    $0x1,%esi
80101185:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010118a:	74 05                	je     80101191 <balloc+0x81>
8010118c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010118f:	77 cf                	ja     80101160 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101191:	83 ec 0c             	sub    $0xc,%esp
80101194:	ff 75 e4             	pushl  -0x1c(%ebp)
80101197:	e8 44 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010119c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011a3:	83 c4 10             	add    $0x10,%esp
801011a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a9:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
801011af:	77 80                	ja     80101131 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011b1:	83 ec 0c             	sub    $0xc,%esp
801011b4:	68 7f 73 10 80       	push   $0x8010737f
801011b9:	e8 d2 f1 ff ff       	call   80100390 <panic>
801011be:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011c3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011c6:	09 da                	or     %ebx,%edx
801011c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011cc:	57                   	push   %edi
801011cd:	e8 ae 1b 00 00       	call   80102d80 <log_write>
        brelse(bp);
801011d2:	89 3c 24             	mov    %edi,(%esp)
801011d5:	e8 06 f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011da:	58                   	pop    %eax
801011db:	5a                   	pop    %edx
801011dc:	56                   	push   %esi
801011dd:	ff 75 d8             	pushl  -0x28(%ebp)
801011e0:	e8 eb ee ff ff       	call   801000d0 <bread>
801011e5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ea:	83 c4 0c             	add    $0xc,%esp
801011ed:	68 00 02 00 00       	push   $0x200
801011f2:	6a 00                	push   $0x0
801011f4:	50                   	push   %eax
801011f5:	e8 06 35 00 00       	call   80104700 <memset>
  log_write(bp);
801011fa:	89 1c 24             	mov    %ebx,(%esp)
801011fd:	e8 7e 1b 00 00       	call   80102d80 <log_write>
  brelse(bp);
80101202:	89 1c 24             	mov    %ebx,(%esp)
80101205:	e8 d6 ef ff ff       	call   801001e0 <brelse>
}
8010120a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120d:	89 f0                	mov    %esi,%eax
8010120f:	5b                   	pop    %ebx
80101210:	5e                   	pop    %esi
80101211:	5f                   	pop    %edi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
80101214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010121a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	56                   	push   %esi
80101225:	53                   	push   %ebx
80101226:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101228:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010122f:	83 ec 28             	sub    $0x28,%esp
80101232:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101235:	68 e0 09 11 80       	push   $0x801109e0
8010123a:	e8 b1 33 00 00       	call   801045f0 <acquire>
8010123f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101245:	eb 17                	jmp    8010125e <iget+0x3e>
80101247:	89 f6                	mov    %esi,%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101250:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101256:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010125c:	73 22                	jae    80101280 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101261:	85 c9                	test   %ecx,%ecx
80101263:	7e 04                	jle    80101269 <iget+0x49>
80101265:	39 3b                	cmp    %edi,(%ebx)
80101267:	74 4f                	je     801012b8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101269:	85 f6                	test   %esi,%esi
8010126b:	75 e3                	jne    80101250 <iget+0x30>
8010126d:	85 c9                	test   %ecx,%ecx
8010126f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101272:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101278:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010127e:	72 de                	jb     8010125e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 5b                	je     801012df <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101284:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101287:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101289:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010128c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101293:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010129a:	68 e0 09 11 80       	push   $0x801109e0
8010129f:	e8 0c 34 00 00       	call   801046b0 <release>

  return ip;
801012a4:	83 c4 10             	add    $0x10,%esp
}
801012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012aa:	89 f0                	mov    %esi,%eax
801012ac:	5b                   	pop    %ebx
801012ad:	5e                   	pop    %esi
801012ae:	5f                   	pop    %edi
801012af:	5d                   	pop    %ebp
801012b0:	c3                   	ret    
801012b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012b8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012bb:	75 ac                	jne    80101269 <iget+0x49>
      release(&icache.lock);
801012bd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801012c0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012c3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012c5:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
801012ca:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012cd:	e8 de 33 00 00       	call   801046b0 <release>
      return ip;
801012d2:	83 c4 10             	add    $0x10,%esp
}
801012d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d8:	89 f0                	mov    %esi,%eax
801012da:	5b                   	pop    %ebx
801012db:	5e                   	pop    %esi
801012dc:	5f                   	pop    %edi
801012dd:	5d                   	pop    %ebp
801012de:	c3                   	ret    
    panic("iget: no inodes");
801012df:	83 ec 0c             	sub    $0xc,%esp
801012e2:	68 95 73 10 80       	push   $0x80107395
801012e7:	e8 a4 f0 ff ff       	call   80100390 <panic>
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	89 c6                	mov    %eax,%esi
801012f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012fb:	83 fa 0b             	cmp    $0xb,%edx
801012fe:	77 18                	ja     80101318 <bmap+0x28>
80101300:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101303:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101306:	85 db                	test   %ebx,%ebx
80101308:	74 76                	je     80101380 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130d:	89 d8                	mov    %ebx,%eax
8010130f:	5b                   	pop    %ebx
80101310:	5e                   	pop    %esi
80101311:	5f                   	pop    %edi
80101312:	5d                   	pop    %ebp
80101313:	c3                   	ret    
80101314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101318:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010131b:	83 fb 7f             	cmp    $0x7f,%ebx
8010131e:	0f 87 90 00 00 00    	ja     801013b4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101324:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010132a:	8b 00                	mov    (%eax),%eax
8010132c:	85 d2                	test   %edx,%edx
8010132e:	74 70                	je     801013a0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101330:	83 ec 08             	sub    $0x8,%esp
80101333:	52                   	push   %edx
80101334:	50                   	push   %eax
80101335:	e8 96 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010133a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010133e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101341:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101343:	8b 1a                	mov    (%edx),%ebx
80101345:	85 db                	test   %ebx,%ebx
80101347:	75 1d                	jne    80101366 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101349:	8b 06                	mov    (%esi),%eax
8010134b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010134e:	e8 bd fd ff ff       	call   80101110 <balloc>
80101353:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101356:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101359:	89 c3                	mov    %eax,%ebx
8010135b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010135d:	57                   	push   %edi
8010135e:	e8 1d 1a 00 00       	call   80102d80 <log_write>
80101363:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101366:	83 ec 0c             	sub    $0xc,%esp
80101369:	57                   	push   %edi
8010136a:	e8 71 ee ff ff       	call   801001e0 <brelse>
8010136f:	83 c4 10             	add    $0x10,%esp
}
80101372:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101375:	89 d8                	mov    %ebx,%eax
80101377:	5b                   	pop    %ebx
80101378:	5e                   	pop    %esi
80101379:	5f                   	pop    %edi
8010137a:	5d                   	pop    %ebp
8010137b:	c3                   	ret    
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101380:	8b 00                	mov    (%eax),%eax
80101382:	e8 89 fd ff ff       	call   80101110 <balloc>
80101387:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010138d:	89 c3                	mov    %eax,%ebx
}
8010138f:	89 d8                	mov    %ebx,%eax
80101391:	5b                   	pop    %ebx
80101392:	5e                   	pop    %esi
80101393:	5f                   	pop    %edi
80101394:	5d                   	pop    %ebp
80101395:	c3                   	ret    
80101396:	8d 76 00             	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013a0:	e8 6b fd ff ff       	call   80101110 <balloc>
801013a5:	89 c2                	mov    %eax,%edx
801013a7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013ad:	8b 06                	mov    (%esi),%eax
801013af:	e9 7c ff ff ff       	jmp    80101330 <bmap+0x40>
  panic("bmap: out of range");
801013b4:	83 ec 0c             	sub    $0xc,%esp
801013b7:	68 a5 73 10 80       	push   $0x801073a5
801013bc:	e8 cf ef ff ff       	call   80100390 <panic>
801013c1:	eb 0d                	jmp    801013d0 <readsb>
801013c3:	90                   	nop
801013c4:	90                   	nop
801013c5:	90                   	nop
801013c6:	90                   	nop
801013c7:	90                   	nop
801013c8:	90                   	nop
801013c9:	90                   	nop
801013ca:	90                   	nop
801013cb:	90                   	nop
801013cc:	90                   	nop
801013cd:	90                   	nop
801013ce:	90                   	nop
801013cf:	90                   	nop

801013d0 <readsb>:
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	56                   	push   %esi
801013d4:	53                   	push   %ebx
801013d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013d8:	83 ec 08             	sub    $0x8,%esp
801013db:	6a 01                	push   $0x1
801013dd:	ff 75 08             	pushl  0x8(%ebp)
801013e0:	e8 eb ec ff ff       	call   801000d0 <bread>
801013e5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ea:	83 c4 0c             	add    $0xc,%esp
801013ed:	6a 1c                	push   $0x1c
801013ef:	50                   	push   %eax
801013f0:	56                   	push   %esi
801013f1:	e8 ba 33 00 00       	call   801047b0 <memmove>
  brelse(bp);
801013f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013f9:	83 c4 10             	add    $0x10,%esp
}
801013fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013ff:	5b                   	pop    %ebx
80101400:	5e                   	pop    %esi
80101401:	5d                   	pop    %ebp
  brelse(bp);
80101402:	e9 d9 ed ff ff       	jmp    801001e0 <brelse>
80101407:	89 f6                	mov    %esi,%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101410 <bfree>:
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	56                   	push   %esi
80101414:	53                   	push   %ebx
80101415:	89 d3                	mov    %edx,%ebx
80101417:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101419:	83 ec 08             	sub    $0x8,%esp
8010141c:	68 c0 09 11 80       	push   $0x801109c0
80101421:	50                   	push   %eax
80101422:	e8 a9 ff ff ff       	call   801013d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101427:	58                   	pop    %eax
80101428:	5a                   	pop    %edx
80101429:	89 da                	mov    %ebx,%edx
8010142b:	c1 ea 0c             	shr    $0xc,%edx
8010142e:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101434:	52                   	push   %edx
80101435:	56                   	push   %esi
80101436:	e8 95 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010143b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010143d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101440:	ba 01 00 00 00       	mov    $0x1,%edx
80101445:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101448:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010144e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101451:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101453:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101458:	85 d1                	test   %edx,%ecx
8010145a:	74 25                	je     80101481 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010145c:	f7 d2                	not    %edx
8010145e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101460:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101463:	21 ca                	and    %ecx,%edx
80101465:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101469:	56                   	push   %esi
8010146a:	e8 11 19 00 00       	call   80102d80 <log_write>
  brelse(bp);
8010146f:	89 34 24             	mov    %esi,(%esp)
80101472:	e8 69 ed ff ff       	call   801001e0 <brelse>
}
80101477:	83 c4 10             	add    $0x10,%esp
8010147a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010147d:	5b                   	pop    %ebx
8010147e:	5e                   	pop    %esi
8010147f:	5d                   	pop    %ebp
80101480:	c3                   	ret    
    panic("freeing free block");
80101481:	83 ec 0c             	sub    $0xc,%esp
80101484:	68 b8 73 10 80       	push   $0x801073b8
80101489:	e8 02 ef ff ff       	call   80100390 <panic>
8010148e:	66 90                	xchg   %ax,%ax

80101490 <iinit>:
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
80101494:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101499:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010149c:	68 cb 73 10 80       	push   $0x801073cb
801014a1:	68 e0 09 11 80       	push   $0x801109e0
801014a6:	e8 05 30 00 00       	call   801044b0 <initlock>
801014ab:	83 c4 10             	add    $0x10,%esp
801014ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014b0:	83 ec 08             	sub    $0x8,%esp
801014b3:	68 d2 73 10 80       	push   $0x801073d2
801014b8:	53                   	push   %ebx
801014b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014bf:	e8 bc 2e 00 00       	call   80104380 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014c4:	83 c4 10             	add    $0x10,%esp
801014c7:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014cd:	75 e1                	jne    801014b0 <iinit+0x20>
  readsb(dev, &sb);
801014cf:	83 ec 08             	sub    $0x8,%esp
801014d2:	68 c0 09 11 80       	push   $0x801109c0
801014d7:	ff 75 08             	pushl  0x8(%ebp)
801014da:	e8 f1 fe ff ff       	call   801013d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014df:	ff 35 d8 09 11 80    	pushl  0x801109d8
801014e5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801014eb:	ff 35 d0 09 11 80    	pushl  0x801109d0
801014f1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801014f7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801014fd:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101503:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101509:	68 38 74 10 80       	push   $0x80107438
8010150e:	e8 4d f1 ff ff       	call   80100660 <cprintf>
}
80101513:	83 c4 30             	add    $0x30,%esp
80101516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101519:	c9                   	leave  
8010151a:	c3                   	ret    
8010151b:	90                   	nop
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101520 <ialloc>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101530:	8b 45 0c             	mov    0xc(%ebp),%eax
80101533:	8b 75 08             	mov    0x8(%ebp),%esi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 91 00 00 00    	jbe    801015d0 <ialloc+0xb0>
8010153f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101544:	eb 21                	jmp    80101567 <ialloc+0x47>
80101546:	8d 76 00             	lea    0x0(%esi),%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101550:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101556:	57                   	push   %edi
80101557:	e8 84 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010155c:	83 c4 10             	add    $0x10,%esp
8010155f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101565:	76 69                	jbe    801015d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101567:	89 d8                	mov    %ebx,%eax
80101569:	83 ec 08             	sub    $0x8,%esp
8010156c:	c1 e8 03             	shr    $0x3,%eax
8010156f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101575:	50                   	push   %eax
80101576:	56                   	push   %esi
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101580:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101583:	83 e0 07             	and    $0x7,%eax
80101586:	c1 e0 06             	shl    $0x6,%eax
80101589:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101591:	75 bd                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101593:	83 ec 04             	sub    $0x4,%esp
80101596:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101599:	6a 40                	push   $0x40
8010159b:	6a 00                	push   $0x0
8010159d:	51                   	push   %ecx
8010159e:	e8 5d 31 00 00       	call   80104700 <memset>
      dip->type = type;
801015a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ad:	89 3c 24             	mov    %edi,(%esp)
801015b0:	e8 cb 17 00 00       	call   80102d80 <log_write>
      brelse(bp);
801015b5:	89 3c 24             	mov    %edi,(%esp)
801015b8:	e8 23 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015bd:	83 c4 10             	add    $0x10,%esp
}
801015c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015c3:	89 da                	mov    %ebx,%edx
801015c5:	89 f0                	mov    %esi,%eax
}
801015c7:	5b                   	pop    %ebx
801015c8:	5e                   	pop    %esi
801015c9:	5f                   	pop    %edi
801015ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801015cb:	e9 50 fc ff ff       	jmp    80101220 <iget>
  panic("ialloc: no inodes");
801015d0:	83 ec 0c             	sub    $0xc,%esp
801015d3:	68 d8 73 10 80       	push   $0x801073d8
801015d8:	e8 b3 ed ff ff       	call   80100390 <panic>
801015dd:	8d 76 00             	lea    0x0(%esi),%esi

801015e0 <iupdate>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	56                   	push   %esi
801015e4:	53                   	push   %ebx
801015e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e8:	83 ec 08             	sub    $0x8,%esp
801015eb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ee:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f1:	c1 e8 03             	shr    $0x3,%eax
801015f4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015fa:	50                   	push   %eax
801015fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015fe:	e8 cd ea ff ff       	call   801000d0 <bread>
80101603:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101605:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101608:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010160f:	83 e0 07             	and    $0x7,%eax
80101612:	c1 e0 06             	shl    $0x6,%eax
80101615:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101619:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010161c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101620:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101623:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101627:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010162b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010162f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101633:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101637:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010163a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163d:	6a 34                	push   $0x34
8010163f:	53                   	push   %ebx
80101640:	50                   	push   %eax
80101641:	e8 6a 31 00 00       	call   801047b0 <memmove>
  log_write(bp);
80101646:	89 34 24             	mov    %esi,(%esp)
80101649:	e8 32 17 00 00       	call   80102d80 <log_write>
  brelse(bp);
8010164e:	89 75 08             	mov    %esi,0x8(%ebp)
80101651:	83 c4 10             	add    $0x10,%esp
}
80101654:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101657:	5b                   	pop    %ebx
80101658:	5e                   	pop    %esi
80101659:	5d                   	pop    %ebp
  brelse(bp);
8010165a:	e9 81 eb ff ff       	jmp    801001e0 <brelse>
8010165f:	90                   	nop

80101660 <idup>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	53                   	push   %ebx
80101664:	83 ec 10             	sub    $0x10,%esp
80101667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010166a:	68 e0 09 11 80       	push   $0x801109e0
8010166f:	e8 7c 2f 00 00       	call   801045f0 <acquire>
  ip->ref++;
80101674:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101678:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010167f:	e8 2c 30 00 00       	call   801046b0 <release>
}
80101684:	89 d8                	mov    %ebx,%eax
80101686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101689:	c9                   	leave  
8010168a:	c3                   	ret    
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <ilock>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	56                   	push   %esi
80101694:	53                   	push   %ebx
80101695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101698:	85 db                	test   %ebx,%ebx
8010169a:	0f 84 b7 00 00 00    	je     80101757 <ilock+0xc7>
801016a0:	8b 53 08             	mov    0x8(%ebx),%edx
801016a3:	85 d2                	test   %edx,%edx
801016a5:	0f 8e ac 00 00 00    	jle    80101757 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016ab:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ae:	83 ec 0c             	sub    $0xc,%esp
801016b1:	50                   	push   %eax
801016b2:	e8 09 2d 00 00       	call   801043c0 <acquiresleep>
  if(ip->valid == 0){
801016b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ba:	83 c4 10             	add    $0x10,%esp
801016bd:	85 c0                	test   %eax,%eax
801016bf:	74 0f                	je     801016d0 <ilock+0x40>
}
801016c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c4:	5b                   	pop    %ebx
801016c5:	5e                   	pop    %esi
801016c6:	5d                   	pop    %ebp
801016c7:	c3                   	ret    
801016c8:	90                   	nop
801016c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d0:	8b 43 04             	mov    0x4(%ebx),%eax
801016d3:	83 ec 08             	sub    $0x8,%esp
801016d6:	c1 e8 03             	shr    $0x3,%eax
801016d9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016df:	50                   	push   %eax
801016e0:	ff 33                	pushl  (%ebx)
801016e2:	e8 e9 e9 ff ff       	call   801000d0 <bread>
801016e7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ef:	83 e0 07             	and    $0x7,%eax
801016f2:	c1 e0 06             	shl    $0x6,%eax
801016f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101703:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101707:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010170b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010170f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101713:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101717:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010171b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010171e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101721:	6a 34                	push   $0x34
80101723:	50                   	push   %eax
80101724:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101727:	50                   	push   %eax
80101728:	e8 83 30 00 00       	call   801047b0 <memmove>
    brelse(bp);
8010172d:	89 34 24             	mov    %esi,(%esp)
80101730:	e8 ab ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101735:	83 c4 10             	add    $0x10,%esp
80101738:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010173d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101744:	0f 85 77 ff ff ff    	jne    801016c1 <ilock+0x31>
      panic("ilock: no type");
8010174a:	83 ec 0c             	sub    $0xc,%esp
8010174d:	68 f0 73 10 80       	push   $0x801073f0
80101752:	e8 39 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 ea 73 10 80       	push   $0x801073ea
8010175f:	e8 2c ec ff ff       	call   80100390 <panic>
80101764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010176a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101770 <iunlock>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	56                   	push   %esi
80101774:	53                   	push   %ebx
80101775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101778:	85 db                	test   %ebx,%ebx
8010177a:	74 28                	je     801017a4 <iunlock+0x34>
8010177c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	56                   	push   %esi
80101783:	e8 d8 2c 00 00       	call   80104460 <holdingsleep>
80101788:	83 c4 10             	add    $0x10,%esp
8010178b:	85 c0                	test   %eax,%eax
8010178d:	74 15                	je     801017a4 <iunlock+0x34>
8010178f:	8b 43 08             	mov    0x8(%ebx),%eax
80101792:	85 c0                	test   %eax,%eax
80101794:	7e 0e                	jle    801017a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101796:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101799:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010179c:	5b                   	pop    %ebx
8010179d:	5e                   	pop    %esi
8010179e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010179f:	e9 7c 2c 00 00       	jmp    80104420 <releasesleep>
    panic("iunlock");
801017a4:	83 ec 0c             	sub    $0xc,%esp
801017a7:	68 ff 73 10 80       	push   $0x801073ff
801017ac:	e8 df eb ff ff       	call   80100390 <panic>
801017b1:	eb 0d                	jmp    801017c0 <iput>
801017b3:	90                   	nop
801017b4:	90                   	nop
801017b5:	90                   	nop
801017b6:	90                   	nop
801017b7:	90                   	nop
801017b8:	90                   	nop
801017b9:	90                   	nop
801017ba:	90                   	nop
801017bb:	90                   	nop
801017bc:	90                   	nop
801017bd:	90                   	nop
801017be:	90                   	nop
801017bf:	90                   	nop

801017c0 <iput>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 28             	sub    $0x28,%esp
801017c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017cf:	57                   	push   %edi
801017d0:	e8 eb 2b 00 00       	call   801043c0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017d8:	83 c4 10             	add    $0x10,%esp
801017db:	85 d2                	test   %edx,%edx
801017dd:	74 07                	je     801017e6 <iput+0x26>
801017df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017e4:	74 32                	je     80101818 <iput+0x58>
  releasesleep(&ip->lock);
801017e6:	83 ec 0c             	sub    $0xc,%esp
801017e9:	57                   	push   %edi
801017ea:	e8 31 2c 00 00       	call   80104420 <releasesleep>
  acquire(&icache.lock);
801017ef:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017f6:	e8 f5 2d 00 00       	call   801045f0 <acquire>
  ip->ref--;
801017fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ff:	83 c4 10             	add    $0x10,%esp
80101802:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101809:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010180c:	5b                   	pop    %ebx
8010180d:	5e                   	pop    %esi
8010180e:	5f                   	pop    %edi
8010180f:	5d                   	pop    %ebp
  release(&icache.lock);
80101810:	e9 9b 2e 00 00       	jmp    801046b0 <release>
80101815:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	68 e0 09 11 80       	push   $0x801109e0
80101820:	e8 cb 2d 00 00       	call   801045f0 <acquire>
    int r = ip->ref;
80101825:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101828:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010182f:	e8 7c 2e 00 00       	call   801046b0 <release>
    if(r == 1){
80101834:	83 c4 10             	add    $0x10,%esp
80101837:	83 fe 01             	cmp    $0x1,%esi
8010183a:	75 aa                	jne    801017e6 <iput+0x26>
8010183c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101842:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101845:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x97>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101853:	39 fe                	cmp    %edi,%esi
80101855:	74 19                	je     80101870 <iput+0xb0>
    if(ip->addrs[i]){
80101857:	8b 16                	mov    (%esi),%edx
80101859:	85 d2                	test   %edx,%edx
8010185b:	74 f3                	je     80101850 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010185d:	8b 03                	mov    (%ebx),%eax
8010185f:	e8 ac fb ff ff       	call   80101410 <bfree>
      ip->addrs[i] = 0;
80101864:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010186a:	eb e4                	jmp    80101850 <iput+0x90>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101870:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 33                	jne    801018b0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010187d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101880:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101887:	53                   	push   %ebx
80101888:	e8 53 fd ff ff       	call   801015e0 <iupdate>
      ip->type = 0;
8010188d:	31 c0                	xor    %eax,%eax
8010188f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101893:	89 1c 24             	mov    %ebx,(%esp)
80101896:	e8 45 fd ff ff       	call   801015e0 <iupdate>
      ip->valid = 0;
8010189b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018a2:	83 c4 10             	add    $0x10,%esp
801018a5:	e9 3c ff ff ff       	jmp    801017e6 <iput+0x26>
801018aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	83 ec 08             	sub    $0x8,%esp
801018b3:	50                   	push   %eax
801018b4:	ff 33                	pushl  (%ebx)
801018b6:	e8 15 e8 ff ff       	call   801000d0 <bread>
801018bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018c1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018c7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ca:	83 c4 10             	add    $0x10,%esp
801018cd:	89 cf                	mov    %ecx,%edi
801018cf:	eb 0e                	jmp    801018df <iput+0x11f>
801018d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018d8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018db:	39 fe                	cmp    %edi,%esi
801018dd:	74 0f                	je     801018ee <iput+0x12e>
      if(a[j])
801018df:	8b 16                	mov    (%esi),%edx
801018e1:	85 d2                	test   %edx,%edx
801018e3:	74 f3                	je     801018d8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018e5:	8b 03                	mov    (%ebx),%eax
801018e7:	e8 24 fb ff ff       	call   80101410 <bfree>
801018ec:	eb ea                	jmp    801018d8 <iput+0x118>
    brelse(bp);
801018ee:	83 ec 0c             	sub    $0xc,%esp
801018f1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018f7:	e8 e4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018fc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101902:	8b 03                	mov    (%ebx),%eax
80101904:	e8 07 fb ff ff       	call   80101410 <bfree>
    ip->addrs[NDIRECT] = 0;
80101909:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101910:	00 00 00 
80101913:	83 c4 10             	add    $0x10,%esp
80101916:	e9 62 ff ff ff       	jmp    8010187d <iput+0xbd>
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <iunlockput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 10             	sub    $0x10,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010192a:	53                   	push   %ebx
8010192b:	e8 40 fe ff ff       	call   80101770 <iunlock>
  iput(ip);
80101930:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101933:	83 c4 10             	add    $0x10,%esp
}
80101936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101939:	c9                   	leave  
  iput(ip);
8010193a:	e9 81 fe ff ff       	jmp    801017c0 <iput>
8010193f:	90                   	nop

80101940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
}
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 1c             	sub    $0x1c,%esp
80101979:	8b 45 08             	mov    0x8(%ebp),%eax
8010197c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010197f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101982:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101987:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010198a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010198d:	8b 75 10             	mov    0x10(%ebp),%esi
80101990:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101993:	0f 84 a7 00 00 00    	je     80101a40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101999:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010199c:	8b 40 58             	mov    0x58(%eax),%eax
8010199f:	39 c6                	cmp    %eax,%esi
801019a1:	0f 87 ba 00 00 00    	ja     80101a61 <readi+0xf1>
801019a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019aa:	89 f9                	mov    %edi,%ecx
801019ac:	01 f1                	add    %esi,%ecx
801019ae:	0f 82 ad 00 00 00    	jb     80101a61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019b4:	89 c2                	mov    %eax,%edx
801019b6:	29 f2                	sub    %esi,%edx
801019b8:	39 c8                	cmp    %ecx,%eax
801019ba:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019bd:	31 ff                	xor    %edi,%edi
801019bf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c4:	74 6c                	je     80101a32 <readi+0xc2>
801019c6:	8d 76 00             	lea    0x0(%esi),%esi
801019c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019d3:	89 f2                	mov    %esi,%edx
801019d5:	c1 ea 09             	shr    $0x9,%edx
801019d8:	89 d8                	mov    %ebx,%eax
801019da:	e8 11 f9 ff ff       	call   801012f0 <bmap>
801019df:	83 ec 08             	sub    $0x8,%esp
801019e2:	50                   	push   %eax
801019e3:	ff 33                	pushl  (%ebx)
801019e5:	e8 e6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ed:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019ef:	89 f0                	mov    %esi,%eax
801019f1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019f6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019fb:	83 c4 0c             	add    $0xc,%esp
801019fe:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a00:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a04:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a07:	29 fb                	sub    %edi,%ebx
80101a09:	39 d9                	cmp    %ebx,%ecx
80101a0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0e:	53                   	push   %ebx
80101a0f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a10:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a12:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a15:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a17:	e8 94 2d 00 00       	call   801047b0 <memmove>
    brelse(bp);
80101a1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a1f:	89 14 24             	mov    %edx,(%esp)
80101a22:	e8 b9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a2a:	83 c4 10             	add    $0x10,%esp
80101a2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a30:	77 9e                	ja     801019d0 <readi+0x60>
  }
  return n;
80101a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a38:	5b                   	pop    %ebx
80101a39:	5e                   	pop    %esi
80101a3a:	5f                   	pop    %edi
80101a3b:	5d                   	pop    %ebp
80101a3c:	c3                   	ret    
80101a3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a44:	66 83 f8 09          	cmp    $0x9,%ax
80101a48:	77 17                	ja     80101a61 <readi+0xf1>
80101a4a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a51:	85 c0                	test   %eax,%eax
80101a53:	74 0c                	je     80101a61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a5b:	5b                   	pop    %ebx
80101a5c:	5e                   	pop    %esi
80101a5d:	5f                   	pop    %edi
80101a5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a5f:	ff e0                	jmp    *%eax
      return -1;
80101a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a66:	eb cd                	jmp    80101a35 <readi+0xc5>
80101a68:	90                   	nop
80101a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 1c             	sub    $0x1c,%esp
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a8d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a90:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a93:	0f 84 b7 00 00 00    	je     80101b50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a9f:	0f 82 eb 00 00 00    	jb     80101b90 <writei+0x120>
80101aa5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101aa8:	31 d2                	xor    %edx,%edx
80101aaa:	89 f8                	mov    %edi,%eax
80101aac:	01 f0                	add    %esi,%eax
80101aae:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ab1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ab6:	0f 87 d4 00 00 00    	ja     80101b90 <writei+0x120>
80101abc:	85 d2                	test   %edx,%edx
80101abe:	0f 85 cc 00 00 00    	jne    80101b90 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ac4:	85 ff                	test   %edi,%edi
80101ac6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101acd:	74 72                	je     80101b41 <writei+0xd1>
80101acf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 f8                	mov    %edi,%eax
80101ada:	e8 11 f8 ff ff       	call   801012f0 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 37                	pushl  (%edi)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101aed:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101af2:	89 f0                	mov    %esi,%eax
80101af4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af9:	83 c4 0c             	add    $0xc,%esp
80101afc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b07:	39 d9                	cmp    %ebx,%ecx
80101b09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b0c:	53                   	push   %ebx
80101b0d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b10:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b12:	50                   	push   %eax
80101b13:	e8 98 2c 00 00       	call   801047b0 <memmove>
    log_write(bp);
80101b18:	89 3c 24             	mov    %edi,(%esp)
80101b1b:	e8 60 12 00 00       	call   80102d80 <log_write>
    brelse(bp);
80101b20:	89 3c 24             	mov    %edi,(%esp)
80101b23:	e8 b8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b2b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b2e:	83 c4 10             	add    $0x10,%esp
80101b31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b37:	77 97                	ja     80101ad0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b3f:	77 37                	ja     80101b78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b47:	5b                   	pop    %ebx
80101b48:	5e                   	pop    %esi
80101b49:	5f                   	pop    %edi
80101b4a:	5d                   	pop    %ebp
80101b4b:	c3                   	ret    
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 36                	ja     80101b90 <writei+0x120>
80101b5a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 2b                	je     80101b90 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b6f:	ff e0                	jmp    *%eax
80101b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b81:	50                   	push   %eax
80101b82:	e8 59 fa ff ff       	call   801015e0 <iupdate>
80101b87:	83 c4 10             	add    $0x10,%esp
80101b8a:	eb b5                	jmp    80101b41 <writei+0xd1>
80101b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b95:	eb ad                	jmp    80101b44 <writei+0xd4>
80101b97:	89 f6                	mov    %esi,%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ba6:	6a 0e                	push   $0xe
80101ba8:	ff 75 0c             	pushl  0xc(%ebp)
80101bab:	ff 75 08             	pushl  0x8(%ebp)
80101bae:	e8 6d 2c 00 00       	call   80104820 <strncmp>
}
80101bb3:	c9                   	leave  
80101bb4:	c3                   	ret    
80101bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 1c             	sub    $0x1c,%esp
80101bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bd1:	0f 85 85 00 00 00    	jne    80101c5c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bda:	31 ff                	xor    %edi,%edi
80101bdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bdf:	85 d2                	test   %edx,%edx
80101be1:	74 3e                	je     80101c21 <dirlookup+0x61>
80101be3:	90                   	nop
80101be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101be8:	6a 10                	push   $0x10
80101bea:	57                   	push   %edi
80101beb:	56                   	push   %esi
80101bec:	53                   	push   %ebx
80101bed:	e8 7e fd ff ff       	call   80101970 <readi>
80101bf2:	83 c4 10             	add    $0x10,%esp
80101bf5:	83 f8 10             	cmp    $0x10,%eax
80101bf8:	75 55                	jne    80101c4f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bfa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bff:	74 18                	je     80101c19 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c01:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c04:	83 ec 04             	sub    $0x4,%esp
80101c07:	6a 0e                	push   $0xe
80101c09:	50                   	push   %eax
80101c0a:	ff 75 0c             	pushl  0xc(%ebp)
80101c0d:	e8 0e 2c 00 00       	call   80104820 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c12:	83 c4 10             	add    $0x10,%esp
80101c15:	85 c0                	test   %eax,%eax
80101c17:	74 17                	je     80101c30 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c19:	83 c7 10             	add    $0x10,%edi
80101c1c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c1f:	72 c7                	jb     80101be8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c24:	31 c0                	xor    %eax,%eax
}
80101c26:	5b                   	pop    %ebx
80101c27:	5e                   	pop    %esi
80101c28:	5f                   	pop    %edi
80101c29:	5d                   	pop    %ebp
80101c2a:	c3                   	ret    
80101c2b:	90                   	nop
80101c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c30:	8b 45 10             	mov    0x10(%ebp),%eax
80101c33:	85 c0                	test   %eax,%eax
80101c35:	74 05                	je     80101c3c <dirlookup+0x7c>
        *poff = off;
80101c37:	8b 45 10             	mov    0x10(%ebp),%eax
80101c3a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c3c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c40:	8b 03                	mov    (%ebx),%eax
80101c42:	e8 d9 f5 ff ff       	call   80101220 <iget>
}
80101c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c4a:	5b                   	pop    %ebx
80101c4b:	5e                   	pop    %esi
80101c4c:	5f                   	pop    %edi
80101c4d:	5d                   	pop    %ebp
80101c4e:	c3                   	ret    
      panic("dirlookup read");
80101c4f:	83 ec 0c             	sub    $0xc,%esp
80101c52:	68 19 74 10 80       	push   $0x80107419
80101c57:	e8 34 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c5c:	83 ec 0c             	sub    $0xc,%esp
80101c5f:	68 07 74 10 80       	push   $0x80107407
80101c64:	e8 27 e7 ff ff       	call   80100390 <panic>
80101c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	56                   	push   %esi
80101c75:	53                   	push   %ebx
80101c76:	89 cf                	mov    %ecx,%edi
80101c78:	89 c3                	mov    %eax,%ebx
80101c7a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c7d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c80:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c83:	0f 84 67 01 00 00    	je     80101df0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c89:	e8 72 1b 00 00       	call   80103800 <myproc>
  acquire(&icache.lock);
80101c8e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c91:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101c94:	68 e0 09 11 80       	push   $0x801109e0
80101c99:	e8 52 29 00 00       	call   801045f0 <acquire>
  ip->ref++;
80101c9e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ca2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101ca9:	e8 02 2a 00 00       	call   801046b0 <release>
80101cae:	83 c4 10             	add    $0x10,%esp
80101cb1:	eb 08                	jmp    80101cbb <namex+0x4b>
80101cb3:	90                   	nop
80101cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101cb8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cbb:	0f b6 03             	movzbl (%ebx),%eax
80101cbe:	3c 2f                	cmp    $0x2f,%al
80101cc0:	74 f6                	je     80101cb8 <namex+0x48>
  if(*path == 0)
80101cc2:	84 c0                	test   %al,%al
80101cc4:	0f 84 ee 00 00 00    	je     80101db8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cca:	0f b6 03             	movzbl (%ebx),%eax
80101ccd:	3c 2f                	cmp    $0x2f,%al
80101ccf:	0f 84 b3 00 00 00    	je     80101d88 <namex+0x118>
80101cd5:	84 c0                	test   %al,%al
80101cd7:	89 da                	mov    %ebx,%edx
80101cd9:	75 09                	jne    80101ce4 <namex+0x74>
80101cdb:	e9 a8 00 00 00       	jmp    80101d88 <namex+0x118>
80101ce0:	84 c0                	test   %al,%al
80101ce2:	74 0a                	je     80101cee <namex+0x7e>
    path++;
80101ce4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101ce7:	0f b6 02             	movzbl (%edx),%eax
80101cea:	3c 2f                	cmp    $0x2f,%al
80101cec:	75 f2                	jne    80101ce0 <namex+0x70>
80101cee:	89 d1                	mov    %edx,%ecx
80101cf0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101cf2:	83 f9 0d             	cmp    $0xd,%ecx
80101cf5:	0f 8e 91 00 00 00    	jle    80101d8c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101cfb:	83 ec 04             	sub    $0x4,%esp
80101cfe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d01:	6a 0e                	push   $0xe
80101d03:	53                   	push   %ebx
80101d04:	57                   	push   %edi
80101d05:	e8 a6 2a 00 00       	call   801047b0 <memmove>
    path++;
80101d0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d0d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d10:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d12:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d15:	75 11                	jne    80101d28 <namex+0xb8>
80101d17:	89 f6                	mov    %esi,%esi
80101d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d20:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d23:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d26:	74 f8                	je     80101d20 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d28:	83 ec 0c             	sub    $0xc,%esp
80101d2b:	56                   	push   %esi
80101d2c:	e8 5f f9 ff ff       	call   80101690 <ilock>
    if(ip->type != T_DIR){
80101d31:	83 c4 10             	add    $0x10,%esp
80101d34:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d39:	0f 85 91 00 00 00    	jne    80101dd0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d42:	85 d2                	test   %edx,%edx
80101d44:	74 09                	je     80101d4f <namex+0xdf>
80101d46:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d49:	0f 84 b7 00 00 00    	je     80101e06 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d4f:	83 ec 04             	sub    $0x4,%esp
80101d52:	6a 00                	push   $0x0
80101d54:	57                   	push   %edi
80101d55:	56                   	push   %esi
80101d56:	e8 65 fe ff ff       	call   80101bc0 <dirlookup>
80101d5b:	83 c4 10             	add    $0x10,%esp
80101d5e:	85 c0                	test   %eax,%eax
80101d60:	74 6e                	je     80101dd0 <namex+0x160>
  iunlock(ip);
80101d62:	83 ec 0c             	sub    $0xc,%esp
80101d65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d68:	56                   	push   %esi
80101d69:	e8 02 fa ff ff       	call   80101770 <iunlock>
  iput(ip);
80101d6e:	89 34 24             	mov    %esi,(%esp)
80101d71:	e8 4a fa ff ff       	call   801017c0 <iput>
80101d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d79:	83 c4 10             	add    $0x10,%esp
80101d7c:	89 c6                	mov    %eax,%esi
80101d7e:	e9 38 ff ff ff       	jmp    80101cbb <namex+0x4b>
80101d83:	90                   	nop
80101d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d88:	89 da                	mov    %ebx,%edx
80101d8a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d8c:	83 ec 04             	sub    $0x4,%esp
80101d8f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d92:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d95:	51                   	push   %ecx
80101d96:	53                   	push   %ebx
80101d97:	57                   	push   %edi
80101d98:	e8 13 2a 00 00       	call   801047b0 <memmove>
    name[len] = 0;
80101d9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101da0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101da3:	83 c4 10             	add    $0x10,%esp
80101da6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101daa:	89 d3                	mov    %edx,%ebx
80101dac:	e9 61 ff ff ff       	jmp    80101d12 <namex+0xa2>
80101db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dbb:	85 c0                	test   %eax,%eax
80101dbd:	75 5d                	jne    80101e1c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101dbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dc2:	89 f0                	mov    %esi,%eax
80101dc4:	5b                   	pop    %ebx
80101dc5:	5e                   	pop    %esi
80101dc6:	5f                   	pop    %edi
80101dc7:	5d                   	pop    %ebp
80101dc8:	c3                   	ret    
80101dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dd0:	83 ec 0c             	sub    $0xc,%esp
80101dd3:	56                   	push   %esi
80101dd4:	e8 97 f9 ff ff       	call   80101770 <iunlock>
  iput(ip);
80101dd9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ddc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dde:	e8 dd f9 ff ff       	call   801017c0 <iput>
      return 0;
80101de3:	83 c4 10             	add    $0x10,%esp
}
80101de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de9:	89 f0                	mov    %esi,%eax
80101deb:	5b                   	pop    %ebx
80101dec:	5e                   	pop    %esi
80101ded:	5f                   	pop    %edi
80101dee:	5d                   	pop    %ebp
80101def:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101df0:	ba 01 00 00 00       	mov    $0x1,%edx
80101df5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dfa:	e8 21 f4 ff ff       	call   80101220 <iget>
80101dff:	89 c6                	mov    %eax,%esi
80101e01:	e9 b5 fe ff ff       	jmp    80101cbb <namex+0x4b>
      iunlock(ip);
80101e06:	83 ec 0c             	sub    $0xc,%esp
80101e09:	56                   	push   %esi
80101e0a:	e8 61 f9 ff ff       	call   80101770 <iunlock>
      return ip;
80101e0f:	83 c4 10             	add    $0x10,%esp
}
80101e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e15:	89 f0                	mov    %esi,%eax
80101e17:	5b                   	pop    %ebx
80101e18:	5e                   	pop    %esi
80101e19:	5f                   	pop    %edi
80101e1a:	5d                   	pop    %ebp
80101e1b:	c3                   	ret    
    iput(ip);
80101e1c:	83 ec 0c             	sub    $0xc,%esp
80101e1f:	56                   	push   %esi
    return 0;
80101e20:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e22:	e8 99 f9 ff ff       	call   801017c0 <iput>
    return 0;
80101e27:	83 c4 10             	add    $0x10,%esp
80101e2a:	eb 93                	jmp    80101dbf <namex+0x14f>
80101e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e30 <dirlink>:
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 20             	sub    $0x20,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e3c:	6a 00                	push   $0x0
80101e3e:	ff 75 0c             	pushl  0xc(%ebp)
80101e41:	53                   	push   %ebx
80101e42:	e8 79 fd ff ff       	call   80101bc0 <dirlookup>
80101e47:	83 c4 10             	add    $0x10,%esp
80101e4a:	85 c0                	test   %eax,%eax
80101e4c:	75 67                	jne    80101eb5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e4e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e51:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e54:	85 ff                	test   %edi,%edi
80101e56:	74 29                	je     80101e81 <dirlink+0x51>
80101e58:	31 ff                	xor    %edi,%edi
80101e5a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e5d:	eb 09                	jmp    80101e68 <dirlink+0x38>
80101e5f:	90                   	nop
80101e60:	83 c7 10             	add    $0x10,%edi
80101e63:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e66:	73 19                	jae    80101e81 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e68:	6a 10                	push   $0x10
80101e6a:	57                   	push   %edi
80101e6b:	56                   	push   %esi
80101e6c:	53                   	push   %ebx
80101e6d:	e8 fe fa ff ff       	call   80101970 <readi>
80101e72:	83 c4 10             	add    $0x10,%esp
80101e75:	83 f8 10             	cmp    $0x10,%eax
80101e78:	75 4e                	jne    80101ec8 <dirlink+0x98>
    if(de.inum == 0)
80101e7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e7f:	75 df                	jne    80101e60 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e81:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e84:	83 ec 04             	sub    $0x4,%esp
80101e87:	6a 0e                	push   $0xe
80101e89:	ff 75 0c             	pushl  0xc(%ebp)
80101e8c:	50                   	push   %eax
80101e8d:	e8 ee 29 00 00       	call   80104880 <strncpy>
  de.inum = inum;
80101e92:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e95:	6a 10                	push   $0x10
80101e97:	57                   	push   %edi
80101e98:	56                   	push   %esi
80101e99:	53                   	push   %ebx
  de.inum = inum;
80101e9a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e9e:	e8 cd fb ff ff       	call   80101a70 <writei>
80101ea3:	83 c4 20             	add    $0x20,%esp
80101ea6:	83 f8 10             	cmp    $0x10,%eax
80101ea9:	75 2a                	jne    80101ed5 <dirlink+0xa5>
  return 0;
80101eab:	31 c0                	xor    %eax,%eax
}
80101ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eb0:	5b                   	pop    %ebx
80101eb1:	5e                   	pop    %esi
80101eb2:	5f                   	pop    %edi
80101eb3:	5d                   	pop    %ebp
80101eb4:	c3                   	ret    
    iput(ip);
80101eb5:	83 ec 0c             	sub    $0xc,%esp
80101eb8:	50                   	push   %eax
80101eb9:	e8 02 f9 ff ff       	call   801017c0 <iput>
    return -1;
80101ebe:	83 c4 10             	add    $0x10,%esp
80101ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec6:	eb e5                	jmp    80101ead <dirlink+0x7d>
      panic("dirlink read");
80101ec8:	83 ec 0c             	sub    $0xc,%esp
80101ecb:	68 28 74 10 80       	push   $0x80107428
80101ed0:	e8 bb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	68 ba 7a 10 80       	push   $0x80107aba
80101edd:	e8 ae e4 ff ff       	call   80100390 <panic>
80101ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ef0 <namei>:

struct inode*
namei(char *path)
{
80101ef0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ef1:	31 d2                	xor    %edx,%edx
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80101efb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101efe:	e8 6d fd ff ff       	call   80101c70 <namex>
}
80101f03:	c9                   	leave  
80101f04:	c3                   	ret    
80101f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f10:	55                   	push   %ebp
  return namex(path, 1, name);
80101f11:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f16:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f1e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f1f:	e9 4c fd ff ff       	jmp    80101c70 <namex>
80101f24:	66 90                	xchg   %ax,%ax
80101f26:	66 90                	xchg   %ax,%ax
80101f28:	66 90                	xchg   %ax,%ax
80101f2a:	66 90                	xchg   %ax,%ax
80101f2c:	66 90                	xchg   %ax,%ax
80101f2e:	66 90                	xchg   %ax,%ax

80101f30 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	57                   	push   %edi
80101f34:	56                   	push   %esi
80101f35:	53                   	push   %ebx
80101f36:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f39:	85 c0                	test   %eax,%eax
80101f3b:	0f 84 b4 00 00 00    	je     80101ff5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f41:	8b 58 08             	mov    0x8(%eax),%ebx
80101f44:	89 c6                	mov    %eax,%esi
80101f46:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f4c:	0f 87 96 00 00 00    	ja     80101fe8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f52:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f57:	89 f6                	mov    %esi,%esi
80101f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f60:	89 ca                	mov    %ecx,%edx
80101f62:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f63:	83 e0 c0             	and    $0xffffffc0,%eax
80101f66:	3c 40                	cmp    $0x40,%al
80101f68:	75 f6                	jne    80101f60 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f6a:	31 ff                	xor    %edi,%edi
80101f6c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f71:	89 f8                	mov    %edi,%eax
80101f73:	ee                   	out    %al,(%dx)
80101f74:	b8 01 00 00 00       	mov    $0x1,%eax
80101f79:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f7e:	ee                   	out    %al,(%dx)
80101f7f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f84:	89 d8                	mov    %ebx,%eax
80101f86:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f87:	89 d8                	mov    %ebx,%eax
80101f89:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f8e:	c1 f8 08             	sar    $0x8,%eax
80101f91:	ee                   	out    %al,(%dx)
80101f92:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f97:	89 f8                	mov    %edi,%eax
80101f99:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f9a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f9e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fa3:	c1 e0 04             	shl    $0x4,%eax
80101fa6:	83 e0 10             	and    $0x10,%eax
80101fa9:	83 c8 e0             	or     $0xffffffe0,%eax
80101fac:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fad:	f6 06 04             	testb  $0x4,(%esi)
80101fb0:	75 16                	jne    80101fc8 <idestart+0x98>
80101fb2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fb7:	89 ca                	mov    %ecx,%edx
80101fb9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fbd:	5b                   	pop    %ebx
80101fbe:	5e                   	pop    %esi
80101fbf:	5f                   	pop    %edi
80101fc0:	5d                   	pop    %ebp
80101fc1:	c3                   	ret    
80101fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fc8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fcd:	89 ca                	mov    %ecx,%edx
80101fcf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fd0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fd5:	83 c6 5c             	add    $0x5c,%esi
80101fd8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fdd:	fc                   	cld    
80101fde:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fe3:	5b                   	pop    %ebx
80101fe4:	5e                   	pop    %esi
80101fe5:	5f                   	pop    %edi
80101fe6:	5d                   	pop    %ebp
80101fe7:	c3                   	ret    
    panic("incorrect blockno");
80101fe8:	83 ec 0c             	sub    $0xc,%esp
80101feb:	68 94 74 10 80       	push   $0x80107494
80101ff0:	e8 9b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101ff5:	83 ec 0c             	sub    $0xc,%esp
80101ff8:	68 8b 74 10 80       	push   $0x8010748b
80101ffd:	e8 8e e3 ff ff       	call   80100390 <panic>
80102002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102010 <ideinit>:
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102016:	68 a6 74 10 80       	push   $0x801074a6
8010201b:	68 80 a5 10 80       	push   $0x8010a580
80102020:	e8 8b 24 00 00       	call   801044b0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102025:	58                   	pop    %eax
80102026:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010202b:	5a                   	pop    %edx
8010202c:	83 e8 01             	sub    $0x1,%eax
8010202f:	50                   	push   %eax
80102030:	6a 0e                	push   $0xe
80102032:	e8 a9 02 00 00       	call   801022e0 <ioapicenable>
80102037:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010203a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010203f:	90                   	nop
80102040:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102041:	83 e0 c0             	and    $0xffffffc0,%eax
80102044:	3c 40                	cmp    $0x40,%al
80102046:	75 f8                	jne    80102040 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102048:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010204d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102052:	ee                   	out    %al,(%dx)
80102053:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102058:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010205d:	eb 06                	jmp    80102065 <ideinit+0x55>
8010205f:	90                   	nop
  for(i=0; i<1000; i++){
80102060:	83 e9 01             	sub    $0x1,%ecx
80102063:	74 0f                	je     80102074 <ideinit+0x64>
80102065:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102066:	84 c0                	test   %al,%al
80102068:	74 f6                	je     80102060 <ideinit+0x50>
      havedisk1 = 1;
8010206a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102071:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102074:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102079:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010207e:	ee                   	out    %al,(%dx)
}
8010207f:	c9                   	leave  
80102080:	c3                   	ret    
80102081:	eb 0d                	jmp    80102090 <ideintr>
80102083:	90                   	nop
80102084:	90                   	nop
80102085:	90                   	nop
80102086:	90                   	nop
80102087:	90                   	nop
80102088:	90                   	nop
80102089:	90                   	nop
8010208a:	90                   	nop
8010208b:	90                   	nop
8010208c:	90                   	nop
8010208d:	90                   	nop
8010208e:	90                   	nop
8010208f:	90                   	nop

80102090 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102099:	68 80 a5 10 80       	push   $0x8010a580
8010209e:	e8 4d 25 00 00       	call   801045f0 <acquire>

  if((b = idequeue) == 0){
801020a3:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020a9:	83 c4 10             	add    $0x10,%esp
801020ac:	85 db                	test   %ebx,%ebx
801020ae:	74 67                	je     80102117 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020b0:	8b 43 58             	mov    0x58(%ebx),%eax
801020b3:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020b8:	8b 3b                	mov    (%ebx),%edi
801020ba:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020c0:	75 31                	jne    801020f3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020c2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020c7:	89 f6                	mov    %esi,%esi
801020c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020d0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020d1:	89 c6                	mov    %eax,%esi
801020d3:	83 e6 c0             	and    $0xffffffc0,%esi
801020d6:	89 f1                	mov    %esi,%ecx
801020d8:	80 f9 40             	cmp    $0x40,%cl
801020db:	75 f3                	jne    801020d0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020dd:	a8 21                	test   $0x21,%al
801020df:	75 12                	jne    801020f3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020e1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020e4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020e9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020ee:	fc                   	cld    
801020ef:	f3 6d                	rep insl (%dx),%es:(%edi)
801020f1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020f3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801020f6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801020f9:	89 f9                	mov    %edi,%ecx
801020fb:	83 c9 02             	or     $0x2,%ecx
801020fe:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102100:	53                   	push   %ebx
80102101:	e8 aa 1e 00 00       	call   80103fb0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102106:	a1 64 a5 10 80       	mov    0x8010a564,%eax
8010210b:	83 c4 10             	add    $0x10,%esp
8010210e:	85 c0                	test   %eax,%eax
80102110:	74 05                	je     80102117 <ideintr+0x87>
    idestart(idequeue);
80102112:	e8 19 fe ff ff       	call   80101f30 <idestart>
    release(&idelock);
80102117:	83 ec 0c             	sub    $0xc,%esp
8010211a:	68 80 a5 10 80       	push   $0x8010a580
8010211f:	e8 8c 25 00 00       	call   801046b0 <release>

  release(&idelock);
}
80102124:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102127:	5b                   	pop    %ebx
80102128:	5e                   	pop    %esi
80102129:	5f                   	pop    %edi
8010212a:	5d                   	pop    %ebp
8010212b:	c3                   	ret    
8010212c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102130 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	53                   	push   %ebx
80102134:	83 ec 10             	sub    $0x10,%esp
80102137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010213a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010213d:	50                   	push   %eax
8010213e:	e8 1d 23 00 00       	call   80104460 <holdingsleep>
80102143:	83 c4 10             	add    $0x10,%esp
80102146:	85 c0                	test   %eax,%eax
80102148:	0f 84 c6 00 00 00    	je     80102214 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010214e:	8b 03                	mov    (%ebx),%eax
80102150:	83 e0 06             	and    $0x6,%eax
80102153:	83 f8 02             	cmp    $0x2,%eax
80102156:	0f 84 ab 00 00 00    	je     80102207 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010215c:	8b 53 04             	mov    0x4(%ebx),%edx
8010215f:	85 d2                	test   %edx,%edx
80102161:	74 0d                	je     80102170 <iderw+0x40>
80102163:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102168:	85 c0                	test   %eax,%eax
8010216a:	0f 84 b1 00 00 00    	je     80102221 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102170:	83 ec 0c             	sub    $0xc,%esp
80102173:	68 80 a5 10 80       	push   $0x8010a580
80102178:	e8 73 24 00 00       	call   801045f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102183:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102186:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010218d:	85 d2                	test   %edx,%edx
8010218f:	75 09                	jne    8010219a <iderw+0x6a>
80102191:	eb 6d                	jmp    80102200 <iderw+0xd0>
80102193:	90                   	nop
80102194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102198:	89 c2                	mov    %eax,%edx
8010219a:	8b 42 58             	mov    0x58(%edx),%eax
8010219d:	85 c0                	test   %eax,%eax
8010219f:	75 f7                	jne    80102198 <iderw+0x68>
801021a1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801021a4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801021a6:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021ac:	74 42                	je     801021f0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ae:	8b 03                	mov    (%ebx),%eax
801021b0:	83 e0 06             	and    $0x6,%eax
801021b3:	83 f8 02             	cmp    $0x2,%eax
801021b6:	74 23                	je     801021db <iderw+0xab>
801021b8:	90                   	nop
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021c0:	83 ec 08             	sub    $0x8,%esp
801021c3:	68 80 a5 10 80       	push   $0x8010a580
801021c8:	53                   	push   %ebx
801021c9:	e8 22 1c 00 00       	call   80103df0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ce:	8b 03                	mov    (%ebx),%eax
801021d0:	83 c4 10             	add    $0x10,%esp
801021d3:	83 e0 06             	and    $0x6,%eax
801021d6:	83 f8 02             	cmp    $0x2,%eax
801021d9:	75 e5                	jne    801021c0 <iderw+0x90>
  }


  release(&idelock);
801021db:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021e5:	c9                   	leave  
  release(&idelock);
801021e6:	e9 c5 24 00 00       	jmp    801046b0 <release>
801021eb:	90                   	nop
801021ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021f0:	89 d8                	mov    %ebx,%eax
801021f2:	e8 39 fd ff ff       	call   80101f30 <idestart>
801021f7:	eb b5                	jmp    801021ae <iderw+0x7e>
801021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102200:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102205:	eb 9d                	jmp    801021a4 <iderw+0x74>
    panic("iderw: nothing to do");
80102207:	83 ec 0c             	sub    $0xc,%esp
8010220a:	68 c0 74 10 80       	push   $0x801074c0
8010220f:	e8 7c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102214:	83 ec 0c             	sub    $0xc,%esp
80102217:	68 aa 74 10 80       	push   $0x801074aa
8010221c:	e8 6f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102221:	83 ec 0c             	sub    $0xc,%esp
80102224:	68 d5 74 10 80       	push   $0x801074d5
80102229:	e8 62 e1 ff ff       	call   80100390 <panic>
8010222e:	66 90                	xchg   %ax,%ax

80102230 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102230:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102231:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102238:	00 c0 fe 
{
8010223b:	89 e5                	mov    %esp,%ebp
8010223d:	56                   	push   %esi
8010223e:	53                   	push   %ebx
  ioapic->reg = reg;
8010223f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102246:	00 00 00 
  return ioapic->data;
80102249:	a1 34 26 11 80       	mov    0x80112634,%eax
8010224e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102251:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102257:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010225d:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102264:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102267:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010226a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010226d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102270:	39 c2                	cmp    %eax,%edx
80102272:	74 16                	je     8010228a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102274:	83 ec 0c             	sub    $0xc,%esp
80102277:	68 f4 74 10 80       	push   $0x801074f4
8010227c:	e8 df e3 ff ff       	call   80100660 <cprintf>
80102281:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102287:	83 c4 10             	add    $0x10,%esp
8010228a:	83 c3 21             	add    $0x21,%ebx
{
8010228d:	ba 10 00 00 00       	mov    $0x10,%edx
80102292:	b8 20 00 00 00       	mov    $0x20,%eax
80102297:	89 f6                	mov    %esi,%esi
80102299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801022a0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801022a2:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022a8:	89 c6                	mov    %eax,%esi
801022aa:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022b0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022b3:	89 71 10             	mov    %esi,0x10(%ecx)
801022b6:	8d 72 01             	lea    0x1(%edx),%esi
801022b9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022bc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022be:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022c0:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801022c6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022cd:	75 d1                	jne    801022a0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022d2:	5b                   	pop    %ebx
801022d3:	5e                   	pop    %esi
801022d4:	5d                   	pop    %ebp
801022d5:	c3                   	ret    
801022d6:	8d 76 00             	lea    0x0(%esi),%esi
801022d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022e0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022e0:	55                   	push   %ebp
  ioapic->reg = reg;
801022e1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801022e7:	89 e5                	mov    %esp,%ebp
801022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ec:	8d 50 20             	lea    0x20(%eax),%edx
801022ef:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022f3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022fb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022fe:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102301:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102304:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102306:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010230b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010230e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102311:	5d                   	pop    %ebp
80102312:	c3                   	ret    
80102313:	66 90                	xchg   %ax,%ax
80102315:	66 90                	xchg   %ax,%ax
80102317:	66 90                	xchg   %ax,%ax
80102319:	66 90                	xchg   %ax,%ax
8010231b:	66 90                	xchg   %ax,%ax
8010231d:	66 90                	xchg   %ax,%ax
8010231f:	90                   	nop

80102320 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	53                   	push   %ebx
80102324:	83 ec 04             	sub    $0x4,%esp
80102327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010232a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102330:	75 70                	jne    801023a2 <kfree+0x82>
80102332:	81 fb a8 5b 11 80    	cmp    $0x80115ba8,%ebx
80102338:	72 68                	jb     801023a2 <kfree+0x82>
8010233a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102340:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102345:	77 5b                	ja     801023a2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102347:	83 ec 04             	sub    $0x4,%esp
8010234a:	68 00 10 00 00       	push   $0x1000
8010234f:	6a 01                	push   $0x1
80102351:	53                   	push   %ebx
80102352:	e8 a9 23 00 00       	call   80104700 <memset>

  if(kmem.use_lock)
80102357:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010235d:	83 c4 10             	add    $0x10,%esp
80102360:	85 d2                	test   %edx,%edx
80102362:	75 2c                	jne    80102390 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102364:	a1 78 26 11 80       	mov    0x80112678,%eax
80102369:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010236b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102370:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102376:	85 c0                	test   %eax,%eax
80102378:	75 06                	jne    80102380 <kfree+0x60>
    release(&kmem.lock);
}
8010237a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237d:	c9                   	leave  
8010237e:	c3                   	ret    
8010237f:	90                   	nop
    release(&kmem.lock);
80102380:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102387:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010238a:	c9                   	leave  
    release(&kmem.lock);
8010238b:	e9 20 23 00 00       	jmp    801046b0 <release>
    acquire(&kmem.lock);
80102390:	83 ec 0c             	sub    $0xc,%esp
80102393:	68 40 26 11 80       	push   $0x80112640
80102398:	e8 53 22 00 00       	call   801045f0 <acquire>
8010239d:	83 c4 10             	add    $0x10,%esp
801023a0:	eb c2                	jmp    80102364 <kfree+0x44>
    panic("kfree");
801023a2:	83 ec 0c             	sub    $0xc,%esp
801023a5:	68 26 75 10 80       	push   $0x80107526
801023aa:	e8 e1 df ff ff       	call   80100390 <panic>
801023af:	90                   	nop

801023b0 <freerange>:
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	56                   	push   %esi
801023b4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023b5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023cd:	39 de                	cmp    %ebx,%esi
801023cf:	72 23                	jb     801023f4 <freerange+0x44>
801023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023d8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023de:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023e7:	50                   	push   %eax
801023e8:	e8 33 ff ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ed:	83 c4 10             	add    $0x10,%esp
801023f0:	39 f3                	cmp    %esi,%ebx
801023f2:	76 e4                	jbe    801023d8 <freerange+0x28>
}
801023f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023f7:	5b                   	pop    %ebx
801023f8:	5e                   	pop    %esi
801023f9:	5d                   	pop    %ebp
801023fa:	c3                   	ret    
801023fb:	90                   	nop
801023fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102400 <kinit1>:
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	56                   	push   %esi
80102404:	53                   	push   %ebx
80102405:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102408:	83 ec 08             	sub    $0x8,%esp
8010240b:	68 2c 75 10 80       	push   $0x8010752c
80102410:	68 40 26 11 80       	push   $0x80112640
80102415:	e8 96 20 00 00       	call   801044b0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010241a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010241d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102420:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102427:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010242a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102430:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102436:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010243c:	39 de                	cmp    %ebx,%esi
8010243e:	72 1c                	jb     8010245c <kinit1+0x5c>
    kfree(p);
80102440:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102446:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102449:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010244f:	50                   	push   %eax
80102450:	e8 cb fe ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102455:	83 c4 10             	add    $0x10,%esp
80102458:	39 de                	cmp    %ebx,%esi
8010245a:	73 e4                	jae    80102440 <kinit1+0x40>
}
8010245c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010245f:	5b                   	pop    %ebx
80102460:	5e                   	pop    %esi
80102461:	5d                   	pop    %ebp
80102462:	c3                   	ret    
80102463:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102470 <kinit2>:
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	56                   	push   %esi
80102474:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102475:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102478:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010247b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102481:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102487:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010248d:	39 de                	cmp    %ebx,%esi
8010248f:	72 23                	jb     801024b4 <kinit2+0x44>
80102491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102498:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010249e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024a7:	50                   	push   %eax
801024a8:	e8 73 fe ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024ad:	83 c4 10             	add    $0x10,%esp
801024b0:	39 de                	cmp    %ebx,%esi
801024b2:	73 e4                	jae    80102498 <kinit2+0x28>
  kmem.use_lock = 1;
801024b4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024bb:	00 00 00 
}
801024be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024c1:	5b                   	pop    %ebx
801024c2:	5e                   	pop    %esi
801024c3:	5d                   	pop    %ebp
801024c4:	c3                   	ret    
801024c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024d0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024d0:	a1 74 26 11 80       	mov    0x80112674,%eax
801024d5:	85 c0                	test   %eax,%eax
801024d7:	75 1f                	jne    801024f8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024d9:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
801024de:	85 c0                	test   %eax,%eax
801024e0:	74 0e                	je     801024f0 <kalloc+0x20>
    kmem.freelist = r->next;
801024e2:	8b 10                	mov    (%eax),%edx
801024e4:	89 15 78 26 11 80    	mov    %edx,0x80112678
801024ea:	c3                   	ret    
801024eb:	90                   	nop
801024ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801024f0:	f3 c3                	repz ret 
801024f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801024f8:	55                   	push   %ebp
801024f9:	89 e5                	mov    %esp,%ebp
801024fb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801024fe:	68 40 26 11 80       	push   $0x80112640
80102503:	e8 e8 20 00 00       	call   801045f0 <acquire>
  r = kmem.freelist;
80102508:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102516:	85 c0                	test   %eax,%eax
80102518:	74 08                	je     80102522 <kalloc+0x52>
    kmem.freelist = r->next;
8010251a:	8b 08                	mov    (%eax),%ecx
8010251c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102522:	85 d2                	test   %edx,%edx
80102524:	74 16                	je     8010253c <kalloc+0x6c>
    release(&kmem.lock);
80102526:	83 ec 0c             	sub    $0xc,%esp
80102529:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010252c:	68 40 26 11 80       	push   $0x80112640
80102531:	e8 7a 21 00 00       	call   801046b0 <release>
  return (char*)r;
80102536:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102539:	83 c4 10             	add    $0x10,%esp
}
8010253c:	c9                   	leave  
8010253d:	c3                   	ret    
8010253e:	66 90                	xchg   %ax,%ax

80102540 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102540:	ba 64 00 00 00       	mov    $0x64,%edx
80102545:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102546:	a8 01                	test   $0x1,%al
80102548:	0f 84 c2 00 00 00    	je     80102610 <kbdgetc+0xd0>
8010254e:	ba 60 00 00 00       	mov    $0x60,%edx
80102553:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102554:	0f b6 d0             	movzbl %al,%edx
80102557:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
8010255d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102563:	0f 84 7f 00 00 00    	je     801025e8 <kbdgetc+0xa8>
{
80102569:	55                   	push   %ebp
8010256a:	89 e5                	mov    %esp,%ebp
8010256c:	53                   	push   %ebx
8010256d:	89 cb                	mov    %ecx,%ebx
8010256f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102572:	84 c0                	test   %al,%al
80102574:	78 4a                	js     801025c0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102576:	85 db                	test   %ebx,%ebx
80102578:	74 09                	je     80102583 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010257a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010257d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102580:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102583:	0f b6 82 60 76 10 80 	movzbl -0x7fef89a0(%edx),%eax
8010258a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010258c:	0f b6 82 60 75 10 80 	movzbl -0x7fef8aa0(%edx),%eax
80102593:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102595:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102597:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010259d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801025a0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025a3:	8b 04 85 40 75 10 80 	mov    -0x7fef8ac0(,%eax,4),%eax
801025aa:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801025ae:	74 31                	je     801025e1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025b0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025b3:	83 fa 19             	cmp    $0x19,%edx
801025b6:	77 40                	ja     801025f8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025b8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025bb:	5b                   	pop    %ebx
801025bc:	5d                   	pop    %ebp
801025bd:	c3                   	ret    
801025be:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025c0:	83 e0 7f             	and    $0x7f,%eax
801025c3:	85 db                	test   %ebx,%ebx
801025c5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025c8:	0f b6 82 60 76 10 80 	movzbl -0x7fef89a0(%edx),%eax
801025cf:	83 c8 40             	or     $0x40,%eax
801025d2:	0f b6 c0             	movzbl %al,%eax
801025d5:	f7 d0                	not    %eax
801025d7:	21 c1                	and    %eax,%ecx
    return 0;
801025d9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025db:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
801025e1:	5b                   	pop    %ebx
801025e2:	5d                   	pop    %ebp
801025e3:	c3                   	ret    
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025e8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801025eb:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801025ed:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
801025f3:	c3                   	ret    
801025f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801025f8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025fb:	8d 50 20             	lea    0x20(%eax),%edx
}
801025fe:	5b                   	pop    %ebx
      c += 'a' - 'A';
801025ff:	83 f9 1a             	cmp    $0x1a,%ecx
80102602:	0f 42 c2             	cmovb  %edx,%eax
}
80102605:	5d                   	pop    %ebp
80102606:	c3                   	ret    
80102607:	89 f6                	mov    %esi,%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102610:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102615:	c3                   	ret    
80102616:	8d 76 00             	lea    0x0(%esi),%esi
80102619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102620 <kbdintr>:

void
kbdintr(void)
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102626:	68 40 25 10 80       	push   $0x80102540
8010262b:	e8 e0 e1 ff ff       	call   80100810 <consoleintr>
}
80102630:	83 c4 10             	add    $0x10,%esp
80102633:	c9                   	leave  
80102634:	c3                   	ret    
80102635:	66 90                	xchg   %ax,%ax
80102637:	66 90                	xchg   %ax,%ax
80102639:	66 90                	xchg   %ax,%ax
8010263b:	66 90                	xchg   %ax,%ax
8010263d:	66 90                	xchg   %ax,%ax
8010263f:	90                   	nop

80102640 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102640:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102645:	55                   	push   %ebp
80102646:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102648:	85 c0                	test   %eax,%eax
8010264a:	0f 84 c8 00 00 00    	je     80102718 <lapicinit+0xd8>
  lapic[index] = value;
80102650:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102657:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010265a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010265d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102664:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102667:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010266a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102671:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102674:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102677:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010267e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102681:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102684:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010268b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010268e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102691:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102698:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010269b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010269e:	8b 50 30             	mov    0x30(%eax),%edx
801026a1:	c1 ea 10             	shr    $0x10,%edx
801026a4:	80 fa 03             	cmp    $0x3,%dl
801026a7:	77 77                	ja     80102720 <lapicinit+0xe0>
  lapic[index] = value;
801026a9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026b0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026bd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ca:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026cd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026d7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026da:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026dd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ea:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026f1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026f4:	8b 50 20             	mov    0x20(%eax),%edx
801026f7:	89 f6                	mov    %esi,%esi
801026f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102700:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102706:	80 e6 10             	and    $0x10,%dh
80102709:	75 f5                	jne    80102700 <lapicinit+0xc0>
  lapic[index] = value;
8010270b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102712:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102715:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102718:	5d                   	pop    %ebp
80102719:	c3                   	ret    
8010271a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102720:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102727:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010272a:	8b 50 20             	mov    0x20(%eax),%edx
8010272d:	e9 77 ff ff ff       	jmp    801026a9 <lapicinit+0x69>
80102732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102740 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102740:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
{
80102746:	55                   	push   %ebp
80102747:	31 c0                	xor    %eax,%eax
80102749:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010274b:	85 d2                	test   %edx,%edx
8010274d:	74 06                	je     80102755 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010274f:	8b 42 20             	mov    0x20(%edx),%eax
80102752:	c1 e8 18             	shr    $0x18,%eax
}
80102755:	5d                   	pop    %ebp
80102756:	c3                   	ret    
80102757:	89 f6                	mov    %esi,%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102760 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102760:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102765:	55                   	push   %ebp
80102766:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102768:	85 c0                	test   %eax,%eax
8010276a:	74 0d                	je     80102779 <lapiceoi+0x19>
  lapic[index] = value;
8010276c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102773:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102776:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102779:	5d                   	pop    %ebp
8010277a:	c3                   	ret    
8010277b:	90                   	nop
8010277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102780 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102780:	55                   	push   %ebp
80102781:	89 e5                	mov    %esp,%ebp
}
80102783:	5d                   	pop    %ebp
80102784:	c3                   	ret    
80102785:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102790:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102791:	b8 0f 00 00 00       	mov    $0xf,%eax
80102796:	ba 70 00 00 00       	mov    $0x70,%edx
8010279b:	89 e5                	mov    %esp,%ebp
8010279d:	53                   	push   %ebx
8010279e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027a4:	ee                   	out    %al,(%dx)
801027a5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027aa:	ba 71 00 00 00       	mov    $0x71,%edx
801027af:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027b0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027b2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027b5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027bb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027bd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027c0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027c3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027c5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027c8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027ce:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801027d3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027d9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027dc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027e3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027e9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027f0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027f6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027fc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027ff:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102805:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102808:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010280e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102811:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102817:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010281a:	5b                   	pop    %ebx
8010281b:	5d                   	pop    %ebp
8010281c:	c3                   	ret    
8010281d:	8d 76 00             	lea    0x0(%esi),%esi

80102820 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102820:	55                   	push   %ebp
80102821:	b8 0b 00 00 00       	mov    $0xb,%eax
80102826:	ba 70 00 00 00       	mov    $0x70,%edx
8010282b:	89 e5                	mov    %esp,%ebp
8010282d:	57                   	push   %edi
8010282e:	56                   	push   %esi
8010282f:	53                   	push   %ebx
80102830:	83 ec 4c             	sub    $0x4c,%esp
80102833:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102834:	ba 71 00 00 00       	mov    $0x71,%edx
80102839:	ec                   	in     (%dx),%al
8010283a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010283d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102842:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102845:	8d 76 00             	lea    0x0(%esi),%esi
80102848:	31 c0                	xor    %eax,%eax
8010284a:	89 da                	mov    %ebx,%edx
8010284c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010284d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102852:	89 ca                	mov    %ecx,%edx
80102854:	ec                   	in     (%dx),%al
80102855:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102858:	89 da                	mov    %ebx,%edx
8010285a:	b8 02 00 00 00       	mov    $0x2,%eax
8010285f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102860:	89 ca                	mov    %ecx,%edx
80102862:	ec                   	in     (%dx),%al
80102863:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102866:	89 da                	mov    %ebx,%edx
80102868:	b8 04 00 00 00       	mov    $0x4,%eax
8010286d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286e:	89 ca                	mov    %ecx,%edx
80102870:	ec                   	in     (%dx),%al
80102871:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102874:	89 da                	mov    %ebx,%edx
80102876:	b8 07 00 00 00       	mov    $0x7,%eax
8010287b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287c:	89 ca                	mov    %ecx,%edx
8010287e:	ec                   	in     (%dx),%al
8010287f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102882:	89 da                	mov    %ebx,%edx
80102884:	b8 08 00 00 00       	mov    $0x8,%eax
80102889:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288a:	89 ca                	mov    %ecx,%edx
8010288c:	ec                   	in     (%dx),%al
8010288d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010288f:	89 da                	mov    %ebx,%edx
80102891:	b8 09 00 00 00       	mov    $0x9,%eax
80102896:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102897:	89 ca                	mov    %ecx,%edx
80102899:	ec                   	in     (%dx),%al
8010289a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010289c:	89 da                	mov    %ebx,%edx
8010289e:	b8 0a 00 00 00       	mov    $0xa,%eax
801028a3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a4:	89 ca                	mov    %ecx,%edx
801028a6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028a7:	84 c0                	test   %al,%al
801028a9:	78 9d                	js     80102848 <cmostime+0x28>
  return inb(CMOS_RETURN);
801028ab:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801028af:	89 fa                	mov    %edi,%edx
801028b1:	0f b6 fa             	movzbl %dl,%edi
801028b4:	89 f2                	mov    %esi,%edx
801028b6:	0f b6 f2             	movzbl %dl,%esi
801028b9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028bc:	89 da                	mov    %ebx,%edx
801028be:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028c1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028c4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028c8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028cb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028cf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028d2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028d9:	31 c0                	xor    %eax,%eax
801028db:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dc:	89 ca                	mov    %ecx,%edx
801028de:	ec                   	in     (%dx),%al
801028df:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e2:	89 da                	mov    %ebx,%edx
801028e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028e7:	b8 02 00 00 00       	mov    $0x2,%eax
801028ec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ed:	89 ca                	mov    %ecx,%edx
801028ef:	ec                   	in     (%dx),%al
801028f0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f3:	89 da                	mov    %ebx,%edx
801028f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028f8:	b8 04 00 00 00       	mov    $0x4,%eax
801028fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fe:	89 ca                	mov    %ecx,%edx
80102900:	ec                   	in     (%dx),%al
80102901:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102904:	89 da                	mov    %ebx,%edx
80102906:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102909:	b8 07 00 00 00       	mov    $0x7,%eax
8010290e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290f:	89 ca                	mov    %ecx,%edx
80102911:	ec                   	in     (%dx),%al
80102912:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102915:	89 da                	mov    %ebx,%edx
80102917:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010291a:	b8 08 00 00 00       	mov    $0x8,%eax
8010291f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102920:	89 ca                	mov    %ecx,%edx
80102922:	ec                   	in     (%dx),%al
80102923:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102926:	89 da                	mov    %ebx,%edx
80102928:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010292b:	b8 09 00 00 00       	mov    $0x9,%eax
80102930:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102931:	89 ca                	mov    %ecx,%edx
80102933:	ec                   	in     (%dx),%al
80102934:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102937:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010293a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010293d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102940:	6a 18                	push   $0x18
80102942:	50                   	push   %eax
80102943:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102946:	50                   	push   %eax
80102947:	e8 04 1e 00 00       	call   80104750 <memcmp>
8010294c:	83 c4 10             	add    $0x10,%esp
8010294f:	85 c0                	test   %eax,%eax
80102951:	0f 85 f1 fe ff ff    	jne    80102848 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102957:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010295b:	75 78                	jne    801029d5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010295d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102960:	89 c2                	mov    %eax,%edx
80102962:	83 e0 0f             	and    $0xf,%eax
80102965:	c1 ea 04             	shr    $0x4,%edx
80102968:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010296e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102971:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102974:	89 c2                	mov    %eax,%edx
80102976:	83 e0 0f             	and    $0xf,%eax
80102979:	c1 ea 04             	shr    $0x4,%edx
8010297c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010297f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102982:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102985:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102988:	89 c2                	mov    %eax,%edx
8010298a:	83 e0 0f             	and    $0xf,%eax
8010298d:	c1 ea 04             	shr    $0x4,%edx
80102990:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102993:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102996:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102999:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010299c:	89 c2                	mov    %eax,%edx
8010299e:	83 e0 0f             	and    $0xf,%eax
801029a1:	c1 ea 04             	shr    $0x4,%edx
801029a4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029a7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029aa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029b0:	89 c2                	mov    %eax,%edx
801029b2:	83 e0 0f             	and    $0xf,%eax
801029b5:	c1 ea 04             	shr    $0x4,%edx
801029b8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029bb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029be:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029c4:	89 c2                	mov    %eax,%edx
801029c6:	83 e0 0f             	and    $0xf,%eax
801029c9:	c1 ea 04             	shr    $0x4,%edx
801029cc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029cf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029d2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029d5:	8b 75 08             	mov    0x8(%ebp),%esi
801029d8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029db:	89 06                	mov    %eax,(%esi)
801029dd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029e0:	89 46 04             	mov    %eax,0x4(%esi)
801029e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029e6:	89 46 08             	mov    %eax,0x8(%esi)
801029e9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029ec:	89 46 0c             	mov    %eax,0xc(%esi)
801029ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029f2:	89 46 10             	mov    %eax,0x10(%esi)
801029f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029f8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029fb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a05:	5b                   	pop    %ebx
80102a06:	5e                   	pop    %esi
80102a07:	5f                   	pop    %edi
80102a08:	5d                   	pop    %ebp
80102a09:	c3                   	ret    
80102a0a:	66 90                	xchg   %ax,%ax
80102a0c:	66 90                	xchg   %ax,%ax
80102a0e:	66 90                	xchg   %ax,%ax

80102a10 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a10:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102a16:	85 c9                	test   %ecx,%ecx
80102a18:	0f 8e 8a 00 00 00    	jle    80102aa8 <install_trans+0x98>
{
80102a1e:	55                   	push   %ebp
80102a1f:	89 e5                	mov    %esp,%ebp
80102a21:	57                   	push   %edi
80102a22:	56                   	push   %esi
80102a23:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a24:	31 db                	xor    %ebx,%ebx
{
80102a26:	83 ec 0c             	sub    $0xc,%esp
80102a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a30:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a35:	83 ec 08             	sub    $0x8,%esp
80102a38:	01 d8                	add    %ebx,%eax
80102a3a:	83 c0 01             	add    $0x1,%eax
80102a3d:	50                   	push   %eax
80102a3e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102a44:	e8 87 d6 ff ff       	call   801000d0 <bread>
80102a49:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a4b:	58                   	pop    %eax
80102a4c:	5a                   	pop    %edx
80102a4d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102a54:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102a5a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a5d:	e8 6e d6 ff ff       	call   801000d0 <bread>
80102a62:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a64:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a67:	83 c4 0c             	add    $0xc,%esp
80102a6a:	68 00 02 00 00       	push   $0x200
80102a6f:	50                   	push   %eax
80102a70:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a73:	50                   	push   %eax
80102a74:	e8 37 1d 00 00       	call   801047b0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 1f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a81:	89 3c 24             	mov    %edi,(%esp)
80102a84:	e8 57 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a89:	89 34 24             	mov    %esi,(%esp)
80102a8c:	e8 4f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a91:	83 c4 10             	add    $0x10,%esp
80102a94:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102a9a:	7f 94                	jg     80102a30 <install_trans+0x20>
  }
}
80102a9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a9f:	5b                   	pop    %ebx
80102aa0:	5e                   	pop    %esi
80102aa1:	5f                   	pop    %edi
80102aa2:	5d                   	pop    %ebp
80102aa3:	c3                   	ret    
80102aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102aa8:	f3 c3                	repz ret 
80102aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ab0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ab0:	55                   	push   %ebp
80102ab1:	89 e5                	mov    %esp,%ebp
80102ab3:	56                   	push   %esi
80102ab4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ab5:	83 ec 08             	sub    $0x8,%esp
80102ab8:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102abe:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102ac4:	e8 07 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ac9:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102acf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ad2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ad4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ad6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ad9:	7e 16                	jle    80102af1 <write_head+0x41>
80102adb:	c1 e3 02             	shl    $0x2,%ebx
80102ade:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ae0:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102ae6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102aea:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102aed:	39 da                	cmp    %ebx,%edx
80102aef:	75 ef                	jne    80102ae0 <write_head+0x30>
  }
  bwrite(buf);
80102af1:	83 ec 0c             	sub    $0xc,%esp
80102af4:	56                   	push   %esi
80102af5:	e8 a6 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102afa:	89 34 24             	mov    %esi,(%esp)
80102afd:	e8 de d6 ff ff       	call   801001e0 <brelse>
}
80102b02:	83 c4 10             	add    $0x10,%esp
80102b05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b08:	5b                   	pop    %ebx
80102b09:	5e                   	pop    %esi
80102b0a:	5d                   	pop    %ebp
80102b0b:	c3                   	ret    
80102b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b10 <initlog>:
{
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
80102b13:	53                   	push   %ebx
80102b14:	83 ec 2c             	sub    $0x2c,%esp
80102b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b1a:	68 60 77 10 80       	push   $0x80107760
80102b1f:	68 80 26 11 80       	push   $0x80112680
80102b24:	e8 87 19 00 00       	call   801044b0 <initlock>
  readsb(dev, &sb);
80102b29:	58                   	pop    %eax
80102b2a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b2d:	5a                   	pop    %edx
80102b2e:	50                   	push   %eax
80102b2f:	53                   	push   %ebx
80102b30:	e8 9b e8 ff ff       	call   801013d0 <readsb>
  log.size = sb.nlog;
80102b35:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b3b:	59                   	pop    %ecx
  log.dev = dev;
80102b3c:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102b42:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102b48:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102b4d:	5a                   	pop    %edx
80102b4e:	50                   	push   %eax
80102b4f:	53                   	push   %ebx
80102b50:	e8 7b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b55:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b58:	83 c4 10             	add    $0x10,%esp
80102b5b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b5d:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102b63:	7e 1c                	jle    80102b81 <initlog+0x71>
80102b65:	c1 e3 02             	shl    $0x2,%ebx
80102b68:	31 d2                	xor    %edx,%edx
80102b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b70:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b74:	83 c2 04             	add    $0x4,%edx
80102b77:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b7d:	39 d3                	cmp    %edx,%ebx
80102b7f:	75 ef                	jne    80102b70 <initlog+0x60>
  brelse(buf);
80102b81:	83 ec 0c             	sub    $0xc,%esp
80102b84:	50                   	push   %eax
80102b85:	e8 56 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b8a:	e8 81 fe ff ff       	call   80102a10 <install_trans>
  log.lh.n = 0;
80102b8f:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b96:	00 00 00 
  write_head(); // clear the log
80102b99:	e8 12 ff ff ff       	call   80102ab0 <write_head>
}
80102b9e:	83 c4 10             	add    $0x10,%esp
80102ba1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ba4:	c9                   	leave  
80102ba5:	c3                   	ret    
80102ba6:	8d 76 00             	lea    0x0(%esi),%esi
80102ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bb0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102bb0:	55                   	push   %ebp
80102bb1:	89 e5                	mov    %esp,%ebp
80102bb3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102bb6:	68 80 26 11 80       	push   $0x80112680
80102bbb:	e8 30 1a 00 00       	call   801045f0 <acquire>
80102bc0:	83 c4 10             	add    $0x10,%esp
80102bc3:	eb 18                	jmp    80102bdd <begin_op+0x2d>
80102bc5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bc8:	83 ec 08             	sub    $0x8,%esp
80102bcb:	68 80 26 11 80       	push   $0x80112680
80102bd0:	68 80 26 11 80       	push   $0x80112680
80102bd5:	e8 16 12 00 00       	call   80103df0 <sleep>
80102bda:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bdd:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102be2:	85 c0                	test   %eax,%eax
80102be4:	75 e2                	jne    80102bc8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102be6:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102beb:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102bf1:	83 c0 01             	add    $0x1,%eax
80102bf4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102bf7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bfa:	83 fa 1e             	cmp    $0x1e,%edx
80102bfd:	7f c9                	jg     80102bc8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bff:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c02:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102c07:	68 80 26 11 80       	push   $0x80112680
80102c0c:	e8 9f 1a 00 00       	call   801046b0 <release>
      break;
    }
  }
}
80102c11:	83 c4 10             	add    $0x10,%esp
80102c14:	c9                   	leave  
80102c15:	c3                   	ret    
80102c16:	8d 76 00             	lea    0x0(%esi),%esi
80102c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c20 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	57                   	push   %edi
80102c24:	56                   	push   %esi
80102c25:	53                   	push   %ebx
80102c26:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c29:	68 80 26 11 80       	push   $0x80112680
80102c2e:	e8 bd 19 00 00       	call   801045f0 <acquire>
  log.outstanding -= 1;
80102c33:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102c38:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102c3e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c41:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c44:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c46:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102c4c:	0f 85 1a 01 00 00    	jne    80102d6c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c52:	85 db                	test   %ebx,%ebx
80102c54:	0f 85 ee 00 00 00    	jne    80102d48 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c5a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c5d:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102c64:	00 00 00 
  release(&log.lock);
80102c67:	68 80 26 11 80       	push   $0x80112680
80102c6c:	e8 3f 1a 00 00       	call   801046b0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c71:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102c77:	83 c4 10             	add    $0x10,%esp
80102c7a:	85 c9                	test   %ecx,%ecx
80102c7c:	0f 8e 85 00 00 00    	jle    80102d07 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c82:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c87:	83 ec 08             	sub    $0x8,%esp
80102c8a:	01 d8                	add    %ebx,%eax
80102c8c:	83 c0 01             	add    $0x1,%eax
80102c8f:	50                   	push   %eax
80102c90:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c96:	e8 35 d4 ff ff       	call   801000d0 <bread>
80102c9b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c9d:	58                   	pop    %eax
80102c9e:	5a                   	pop    %edx
80102c9f:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102ca6:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cac:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102caf:	e8 1c d4 ff ff       	call   801000d0 <bread>
80102cb4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102cb6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102cb9:	83 c4 0c             	add    $0xc,%esp
80102cbc:	68 00 02 00 00       	push   $0x200
80102cc1:	50                   	push   %eax
80102cc2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cc5:	50                   	push   %eax
80102cc6:	e8 e5 1a 00 00       	call   801047b0 <memmove>
    bwrite(to);  // write the log
80102ccb:	89 34 24             	mov    %esi,(%esp)
80102cce:	e8 cd d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cd3:	89 3c 24             	mov    %edi,(%esp)
80102cd6:	e8 05 d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102cdb:	89 34 24             	mov    %esi,(%esp)
80102cde:	e8 fd d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ce3:	83 c4 10             	add    $0x10,%esp
80102ce6:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102cec:	7c 94                	jl     80102c82 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cee:	e8 bd fd ff ff       	call   80102ab0 <write_head>
    install_trans(); // Now install writes to home locations
80102cf3:	e8 18 fd ff ff       	call   80102a10 <install_trans>
    log.lh.n = 0;
80102cf8:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102cff:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d02:	e8 a9 fd ff ff       	call   80102ab0 <write_head>
    acquire(&log.lock);
80102d07:	83 ec 0c             	sub    $0xc,%esp
80102d0a:	68 80 26 11 80       	push   $0x80112680
80102d0f:	e8 dc 18 00 00       	call   801045f0 <acquire>
    wakeup(&log);
80102d14:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102d1b:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d22:	00 00 00 
    wakeup(&log);
80102d25:	e8 86 12 00 00       	call   80103fb0 <wakeup>
    release(&log.lock);
80102d2a:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d31:	e8 7a 19 00 00       	call   801046b0 <release>
80102d36:	83 c4 10             	add    $0x10,%esp
}
80102d39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d3c:	5b                   	pop    %ebx
80102d3d:	5e                   	pop    %esi
80102d3e:	5f                   	pop    %edi
80102d3f:	5d                   	pop    %ebp
80102d40:	c3                   	ret    
80102d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d48:	83 ec 0c             	sub    $0xc,%esp
80102d4b:	68 80 26 11 80       	push   $0x80112680
80102d50:	e8 5b 12 00 00       	call   80103fb0 <wakeup>
  release(&log.lock);
80102d55:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d5c:	e8 4f 19 00 00       	call   801046b0 <release>
80102d61:	83 c4 10             	add    $0x10,%esp
}
80102d64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d67:	5b                   	pop    %ebx
80102d68:	5e                   	pop    %esi
80102d69:	5f                   	pop    %edi
80102d6a:	5d                   	pop    %ebp
80102d6b:	c3                   	ret    
    panic("log.committing");
80102d6c:	83 ec 0c             	sub    $0xc,%esp
80102d6f:	68 64 77 10 80       	push   $0x80107764
80102d74:	e8 17 d6 ff ff       	call   80100390 <panic>
80102d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d80 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	53                   	push   %ebx
80102d84:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d87:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102d8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d90:	83 fa 1d             	cmp    $0x1d,%edx
80102d93:	0f 8f 9d 00 00 00    	jg     80102e36 <log_write+0xb6>
80102d99:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102d9e:	83 e8 01             	sub    $0x1,%eax
80102da1:	39 c2                	cmp    %eax,%edx
80102da3:	0f 8d 8d 00 00 00    	jge    80102e36 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102da9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102dae:	85 c0                	test   %eax,%eax
80102db0:	0f 8e 8d 00 00 00    	jle    80102e43 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102db6:	83 ec 0c             	sub    $0xc,%esp
80102db9:	68 80 26 11 80       	push   $0x80112680
80102dbe:	e8 2d 18 00 00       	call   801045f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102dc3:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102dc9:	83 c4 10             	add    $0x10,%esp
80102dcc:	83 f9 00             	cmp    $0x0,%ecx
80102dcf:	7e 57                	jle    80102e28 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dd1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102dd4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dd6:	3b 15 cc 26 11 80    	cmp    0x801126cc,%edx
80102ddc:	75 0b                	jne    80102de9 <log_write+0x69>
80102dde:	eb 38                	jmp    80102e18 <log_write+0x98>
80102de0:	39 14 85 cc 26 11 80 	cmp    %edx,-0x7feed934(,%eax,4)
80102de7:	74 2f                	je     80102e18 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102de9:	83 c0 01             	add    $0x1,%eax
80102dec:	39 c1                	cmp    %eax,%ecx
80102dee:	75 f0                	jne    80102de0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102df0:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102df7:	83 c0 01             	add    $0x1,%eax
80102dfa:	a3 c8 26 11 80       	mov    %eax,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102dff:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e02:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102e09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e0c:	c9                   	leave  
  release(&log.lock);
80102e0d:	e9 9e 18 00 00       	jmp    801046b0 <release>
80102e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e18:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
80102e1f:	eb de                	jmp    80102dff <log_write+0x7f>
80102e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e28:	8b 43 08             	mov    0x8(%ebx),%eax
80102e2b:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102e30:	75 cd                	jne    80102dff <log_write+0x7f>
80102e32:	31 c0                	xor    %eax,%eax
80102e34:	eb c1                	jmp    80102df7 <log_write+0x77>
    panic("too big a transaction");
80102e36:	83 ec 0c             	sub    $0xc,%esp
80102e39:	68 73 77 10 80       	push   $0x80107773
80102e3e:	e8 4d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e43:	83 ec 0c             	sub    $0xc,%esp
80102e46:	68 89 77 10 80       	push   $0x80107789
80102e4b:	e8 40 d5 ff ff       	call   80100390 <panic>

80102e50 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	53                   	push   %ebx
80102e54:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e57:	e8 84 09 00 00       	call   801037e0 <cpuid>
80102e5c:	89 c3                	mov    %eax,%ebx
80102e5e:	e8 7d 09 00 00       	call   801037e0 <cpuid>
80102e63:	83 ec 04             	sub    $0x4,%esp
80102e66:	53                   	push   %ebx
80102e67:	50                   	push   %eax
80102e68:	68 a4 77 10 80       	push   $0x801077a4
80102e6d:	e8 ee d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e72:	e8 29 2c 00 00       	call   80105aa0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e77:	e8 e4 08 00 00       	call   80103760 <mycpu>
80102e7c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e7e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e83:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e8a:	e8 31 0c 00 00       	call   80103ac0 <scheduler>
80102e8f:	90                   	nop

80102e90 <mpenter>:
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e96:	e8 25 3d 00 00       	call   80106bc0 <switchkvm>
  seginit();
80102e9b:	e8 90 3c 00 00       	call   80106b30 <seginit>
  lapicinit();
80102ea0:	e8 9b f7 ff ff       	call   80102640 <lapicinit>
  mpmain();
80102ea5:	e8 a6 ff ff ff       	call   80102e50 <mpmain>
80102eaa:	66 90                	xchg   %ax,%ax
80102eac:	66 90                	xchg   %ax,%ax
80102eae:	66 90                	xchg   %ax,%ax

80102eb0 <main>:
{
80102eb0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102eb4:	83 e4 f0             	and    $0xfffffff0,%esp
80102eb7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eba:	55                   	push   %ebp
80102ebb:	89 e5                	mov    %esp,%ebp
80102ebd:	53                   	push   %ebx
80102ebe:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102ebf:	83 ec 08             	sub    $0x8,%esp
80102ec2:	68 00 00 40 80       	push   $0x80400000
80102ec7:	68 a8 5b 11 80       	push   $0x80115ba8
80102ecc:	e8 2f f5 ff ff       	call   80102400 <kinit1>
  kvmalloc();      // kernel page table
80102ed1:	e8 ba 41 00 00       	call   80107090 <kvmalloc>
  mpinit();        // detect other processors
80102ed6:	e8 75 01 00 00       	call   80103050 <mpinit>
  lapicinit();     // interrupt controller
80102edb:	e8 60 f7 ff ff       	call   80102640 <lapicinit>
  seginit();       // segment descriptors
80102ee0:	e8 4b 3c 00 00       	call   80106b30 <seginit>
  picinit();       // disable pic
80102ee5:	e8 46 03 00 00       	call   80103230 <picinit>
  ioapicinit();    // another interrupt controller
80102eea:	e8 41 f3 ff ff       	call   80102230 <ioapicinit>
  consoleinit();   // console hardware
80102eef:	e8 cc da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102ef4:	e8 07 2f 00 00       	call   80105e00 <uartinit>
  pinit();         // process table
80102ef9:	e8 42 08 00 00       	call   80103740 <pinit>
  tvinit();        // trap vectors
80102efe:	e8 1d 2b 00 00       	call   80105a20 <tvinit>
  binit();         // buffer cache
80102f03:	e8 38 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f08:	e8 53 de ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102f0d:	e8 fe f0 ff ff       	call   80102010 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f12:	83 c4 0c             	add    $0xc,%esp
80102f15:	68 8a 00 00 00       	push   $0x8a
80102f1a:	68 8c a4 10 80       	push   $0x8010a48c
80102f1f:	68 00 70 00 80       	push   $0x80007000
80102f24:	e8 87 18 00 00       	call   801047b0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f29:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f30:	00 00 00 
80102f33:	83 c4 10             	add    $0x10,%esp
80102f36:	05 80 27 11 80       	add    $0x80112780,%eax
80102f3b:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80102f40:	76 71                	jbe    80102fb3 <main+0x103>
80102f42:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80102f47:	89 f6                	mov    %esi,%esi
80102f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f50:	e8 0b 08 00 00       	call   80103760 <mycpu>
80102f55:	39 d8                	cmp    %ebx,%eax
80102f57:	74 41                	je     80102f9a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f59:	e8 72 f5 ff ff       	call   801024d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f5e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f63:	c7 05 f8 6f 00 80 90 	movl   $0x80102e90,0x80006ff8
80102f6a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f6d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f74:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f77:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f7c:	0f b6 03             	movzbl (%ebx),%eax
80102f7f:	83 ec 08             	sub    $0x8,%esp
80102f82:	68 00 70 00 00       	push   $0x7000
80102f87:	50                   	push   %eax
80102f88:	e8 03 f8 ff ff       	call   80102790 <lapicstartap>
80102f8d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f90:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f96:	85 c0                	test   %eax,%eax
80102f98:	74 f6                	je     80102f90 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f9a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102fa1:	00 00 00 
80102fa4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102faa:	05 80 27 11 80       	add    $0x80112780,%eax
80102faf:	39 c3                	cmp    %eax,%ebx
80102fb1:	72 9d                	jb     80102f50 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fb3:	83 ec 08             	sub    $0x8,%esp
80102fb6:	68 00 00 00 8e       	push   $0x8e000000
80102fbb:	68 00 00 40 80       	push   $0x80400000
80102fc0:	e8 ab f4 ff ff       	call   80102470 <kinit2>
  userinit();      // first user process
80102fc5:	e8 66 08 00 00       	call   80103830 <userinit>
  mpmain();        // finish this processor's setup
80102fca:	e8 81 fe ff ff       	call   80102e50 <mpmain>
80102fcf:	90                   	nop

80102fd0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	57                   	push   %edi
80102fd4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fd5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102fdb:	53                   	push   %ebx
  e = addr+len;
80102fdc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fdf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102fe2:	39 de                	cmp    %ebx,%esi
80102fe4:	72 10                	jb     80102ff6 <mpsearch1+0x26>
80102fe6:	eb 50                	jmp    80103038 <mpsearch1+0x68>
80102fe8:	90                   	nop
80102fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ff0:	39 fb                	cmp    %edi,%ebx
80102ff2:	89 fe                	mov    %edi,%esi
80102ff4:	76 42                	jbe    80103038 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102ff6:	83 ec 04             	sub    $0x4,%esp
80102ff9:	8d 7e 10             	lea    0x10(%esi),%edi
80102ffc:	6a 04                	push   $0x4
80102ffe:	68 b8 77 10 80       	push   $0x801077b8
80103003:	56                   	push   %esi
80103004:	e8 47 17 00 00       	call   80104750 <memcmp>
80103009:	83 c4 10             	add    $0x10,%esp
8010300c:	85 c0                	test   %eax,%eax
8010300e:	75 e0                	jne    80102ff0 <mpsearch1+0x20>
80103010:	89 f1                	mov    %esi,%ecx
80103012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103018:	0f b6 11             	movzbl (%ecx),%edx
8010301b:	83 c1 01             	add    $0x1,%ecx
8010301e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103020:	39 f9                	cmp    %edi,%ecx
80103022:	75 f4                	jne    80103018 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103024:	84 c0                	test   %al,%al
80103026:	75 c8                	jne    80102ff0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103028:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010302b:	89 f0                	mov    %esi,%eax
8010302d:	5b                   	pop    %ebx
8010302e:	5e                   	pop    %esi
8010302f:	5f                   	pop    %edi
80103030:	5d                   	pop    %ebp
80103031:	c3                   	ret    
80103032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103038:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010303b:	31 f6                	xor    %esi,%esi
}
8010303d:	89 f0                	mov    %esi,%eax
8010303f:	5b                   	pop    %ebx
80103040:	5e                   	pop    %esi
80103041:	5f                   	pop    %edi
80103042:	5d                   	pop    %ebp
80103043:	c3                   	ret    
80103044:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010304a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103050 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	57                   	push   %edi
80103054:	56                   	push   %esi
80103055:	53                   	push   %ebx
80103056:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103059:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103060:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103067:	c1 e0 08             	shl    $0x8,%eax
8010306a:	09 d0                	or     %edx,%eax
8010306c:	c1 e0 04             	shl    $0x4,%eax
8010306f:	85 c0                	test   %eax,%eax
80103071:	75 1b                	jne    8010308e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103073:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010307a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103081:	c1 e0 08             	shl    $0x8,%eax
80103084:	09 d0                	or     %edx,%eax
80103086:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103089:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010308e:	ba 00 04 00 00       	mov    $0x400,%edx
80103093:	e8 38 ff ff ff       	call   80102fd0 <mpsearch1>
80103098:	85 c0                	test   %eax,%eax
8010309a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010309d:	0f 84 3d 01 00 00    	je     801031e0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030a6:	8b 58 04             	mov    0x4(%eax),%ebx
801030a9:	85 db                	test   %ebx,%ebx
801030ab:	0f 84 4f 01 00 00    	je     80103200 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030b1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030b7:	83 ec 04             	sub    $0x4,%esp
801030ba:	6a 04                	push   $0x4
801030bc:	68 d5 77 10 80       	push   $0x801077d5
801030c1:	56                   	push   %esi
801030c2:	e8 89 16 00 00       	call   80104750 <memcmp>
801030c7:	83 c4 10             	add    $0x10,%esp
801030ca:	85 c0                	test   %eax,%eax
801030cc:	0f 85 2e 01 00 00    	jne    80103200 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801030d2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030d9:	3c 01                	cmp    $0x1,%al
801030db:	0f 95 c2             	setne  %dl
801030de:	3c 04                	cmp    $0x4,%al
801030e0:	0f 95 c0             	setne  %al
801030e3:	20 c2                	and    %al,%dl
801030e5:	0f 85 15 01 00 00    	jne    80103200 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801030eb:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801030f2:	66 85 ff             	test   %di,%di
801030f5:	74 1a                	je     80103111 <mpinit+0xc1>
801030f7:	89 f0                	mov    %esi,%eax
801030f9:	01 f7                	add    %esi,%edi
  sum = 0;
801030fb:	31 d2                	xor    %edx,%edx
801030fd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103100:	0f b6 08             	movzbl (%eax),%ecx
80103103:	83 c0 01             	add    $0x1,%eax
80103106:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103108:	39 c7                	cmp    %eax,%edi
8010310a:	75 f4                	jne    80103100 <mpinit+0xb0>
8010310c:	84 d2                	test   %dl,%dl
8010310e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103111:	85 f6                	test   %esi,%esi
80103113:	0f 84 e7 00 00 00    	je     80103200 <mpinit+0x1b0>
80103119:	84 d2                	test   %dl,%dl
8010311b:	0f 85 df 00 00 00    	jne    80103200 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103121:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103127:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010312c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103133:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103139:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010313e:	01 d6                	add    %edx,%esi
80103140:	39 c6                	cmp    %eax,%esi
80103142:	76 23                	jbe    80103167 <mpinit+0x117>
    switch(*p){
80103144:	0f b6 10             	movzbl (%eax),%edx
80103147:	80 fa 04             	cmp    $0x4,%dl
8010314a:	0f 87 ca 00 00 00    	ja     8010321a <mpinit+0x1ca>
80103150:	ff 24 95 fc 77 10 80 	jmp    *-0x7fef8804(,%edx,4)
80103157:	89 f6                	mov    %esi,%esi
80103159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103160:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103163:	39 c6                	cmp    %eax,%esi
80103165:	77 dd                	ja     80103144 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103167:	85 db                	test   %ebx,%ebx
80103169:	0f 84 9e 00 00 00    	je     8010320d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010316f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103172:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103176:	74 15                	je     8010318d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103178:	b8 70 00 00 00       	mov    $0x70,%eax
8010317d:	ba 22 00 00 00       	mov    $0x22,%edx
80103182:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103183:	ba 23 00 00 00       	mov    $0x23,%edx
80103188:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103189:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010318c:	ee                   	out    %al,(%dx)
  }
}
8010318d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103190:	5b                   	pop    %ebx
80103191:	5e                   	pop    %esi
80103192:	5f                   	pop    %edi
80103193:	5d                   	pop    %ebp
80103194:	c3                   	ret    
80103195:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103198:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
8010319e:	83 f9 07             	cmp    $0x7,%ecx
801031a1:	7f 19                	jg     801031bc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031a3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031a7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801031ad:	83 c1 01             	add    $0x1,%ecx
801031b0:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031b6:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
801031bc:	83 c0 14             	add    $0x14,%eax
      continue;
801031bf:	e9 7c ff ff ff       	jmp    80103140 <mpinit+0xf0>
801031c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031c8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031cc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031cf:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
801031d5:	e9 66 ff ff ff       	jmp    80103140 <mpinit+0xf0>
801031da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801031e0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031e5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031ea:	e8 e1 fd ff ff       	call   80102fd0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031ef:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801031f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031f4:	0f 85 a9 fe ff ff    	jne    801030a3 <mpinit+0x53>
801031fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103200:	83 ec 0c             	sub    $0xc,%esp
80103203:	68 bd 77 10 80       	push   $0x801077bd
80103208:	e8 83 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010320d:	83 ec 0c             	sub    $0xc,%esp
80103210:	68 dc 77 10 80       	push   $0x801077dc
80103215:	e8 76 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010321a:	31 db                	xor    %ebx,%ebx
8010321c:	e9 26 ff ff ff       	jmp    80103147 <mpinit+0xf7>
80103221:	66 90                	xchg   %ax,%ax
80103223:	66 90                	xchg   %ax,%ax
80103225:	66 90                	xchg   %ax,%ax
80103227:	66 90                	xchg   %ax,%ax
80103229:	66 90                	xchg   %ax,%ax
8010322b:	66 90                	xchg   %ax,%ax
8010322d:	66 90                	xchg   %ax,%ax
8010322f:	90                   	nop

80103230 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103230:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103231:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103236:	ba 21 00 00 00       	mov    $0x21,%edx
8010323b:	89 e5                	mov    %esp,%ebp
8010323d:	ee                   	out    %al,(%dx)
8010323e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103243:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103244:	5d                   	pop    %ebp
80103245:	c3                   	ret    
80103246:	66 90                	xchg   %ax,%ax
80103248:	66 90                	xchg   %ax,%ax
8010324a:	66 90                	xchg   %ax,%ax
8010324c:	66 90                	xchg   %ax,%ax
8010324e:	66 90                	xchg   %ax,%ax

80103250 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	57                   	push   %edi
80103254:	56                   	push   %esi
80103255:	53                   	push   %ebx
80103256:	83 ec 0c             	sub    $0xc,%esp
80103259:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010325c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010325f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103265:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010326b:	e8 10 db ff ff       	call   80100d80 <filealloc>
80103270:	85 c0                	test   %eax,%eax
80103272:	89 03                	mov    %eax,(%ebx)
80103274:	74 22                	je     80103298 <pipealloc+0x48>
80103276:	e8 05 db ff ff       	call   80100d80 <filealloc>
8010327b:	85 c0                	test   %eax,%eax
8010327d:	89 06                	mov    %eax,(%esi)
8010327f:	74 3f                	je     801032c0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103281:	e8 4a f2 ff ff       	call   801024d0 <kalloc>
80103286:	85 c0                	test   %eax,%eax
80103288:	89 c7                	mov    %eax,%edi
8010328a:	75 54                	jne    801032e0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010328c:	8b 03                	mov    (%ebx),%eax
8010328e:	85 c0                	test   %eax,%eax
80103290:	75 34                	jne    801032c6 <pipealloc+0x76>
80103292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103298:	8b 06                	mov    (%esi),%eax
8010329a:	85 c0                	test   %eax,%eax
8010329c:	74 0c                	je     801032aa <pipealloc+0x5a>
    fileclose(*f1);
8010329e:	83 ec 0c             	sub    $0xc,%esp
801032a1:	50                   	push   %eax
801032a2:	e8 99 db ff ff       	call   80100e40 <fileclose>
801032a7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801032ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032b2:	5b                   	pop    %ebx
801032b3:	5e                   	pop    %esi
801032b4:	5f                   	pop    %edi
801032b5:	5d                   	pop    %ebp
801032b6:	c3                   	ret    
801032b7:	89 f6                	mov    %esi,%esi
801032b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032c0:	8b 03                	mov    (%ebx),%eax
801032c2:	85 c0                	test   %eax,%eax
801032c4:	74 e4                	je     801032aa <pipealloc+0x5a>
    fileclose(*f0);
801032c6:	83 ec 0c             	sub    $0xc,%esp
801032c9:	50                   	push   %eax
801032ca:	e8 71 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
801032cf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801032d1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032d4:	85 c0                	test   %eax,%eax
801032d6:	75 c6                	jne    8010329e <pipealloc+0x4e>
801032d8:	eb d0                	jmp    801032aa <pipealloc+0x5a>
801032da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801032e0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801032e3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032ea:	00 00 00 
  p->writeopen = 1;
801032ed:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801032f4:	00 00 00 
  p->nwrite = 0;
801032f7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801032fe:	00 00 00 
  p->nread = 0;
80103301:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103308:	00 00 00 
  initlock(&p->lock, "pipe");
8010330b:	68 10 78 10 80       	push   $0x80107810
80103310:	50                   	push   %eax
80103311:	e8 9a 11 00 00       	call   801044b0 <initlock>
  (*f0)->type = FD_PIPE;
80103316:	8b 03                	mov    (%ebx),%eax
  return 0;
80103318:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010331b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103321:	8b 03                	mov    (%ebx),%eax
80103323:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103327:	8b 03                	mov    (%ebx),%eax
80103329:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010332d:	8b 03                	mov    (%ebx),%eax
8010332f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103332:	8b 06                	mov    (%esi),%eax
80103334:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010333a:	8b 06                	mov    (%esi),%eax
8010333c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103340:	8b 06                	mov    (%esi),%eax
80103342:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103346:	8b 06                	mov    (%esi),%eax
80103348:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010334b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010334e:	31 c0                	xor    %eax,%eax
}
80103350:	5b                   	pop    %ebx
80103351:	5e                   	pop    %esi
80103352:	5f                   	pop    %edi
80103353:	5d                   	pop    %ebp
80103354:	c3                   	ret    
80103355:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103360 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	56                   	push   %esi
80103364:	53                   	push   %ebx
80103365:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103368:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010336b:	83 ec 0c             	sub    $0xc,%esp
8010336e:	53                   	push   %ebx
8010336f:	e8 7c 12 00 00       	call   801045f0 <acquire>
  if(writable){
80103374:	83 c4 10             	add    $0x10,%esp
80103377:	85 f6                	test   %esi,%esi
80103379:	74 45                	je     801033c0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010337b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103381:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103384:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010338b:	00 00 00 
    wakeup(&p->nread);
8010338e:	50                   	push   %eax
8010338f:	e8 1c 0c 00 00       	call   80103fb0 <wakeup>
80103394:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103397:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010339d:	85 d2                	test   %edx,%edx
8010339f:	75 0a                	jne    801033ab <pipeclose+0x4b>
801033a1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033a7:	85 c0                	test   %eax,%eax
801033a9:	74 35                	je     801033e0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033b1:	5b                   	pop    %ebx
801033b2:	5e                   	pop    %esi
801033b3:	5d                   	pop    %ebp
    release(&p->lock);
801033b4:	e9 f7 12 00 00       	jmp    801046b0 <release>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033c0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033c6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033d0:	00 00 00 
    wakeup(&p->nwrite);
801033d3:	50                   	push   %eax
801033d4:	e8 d7 0b 00 00       	call   80103fb0 <wakeup>
801033d9:	83 c4 10             	add    $0x10,%esp
801033dc:	eb b9                	jmp    80103397 <pipeclose+0x37>
801033de:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801033e0:	83 ec 0c             	sub    $0xc,%esp
801033e3:	53                   	push   %ebx
801033e4:	e8 c7 12 00 00       	call   801046b0 <release>
    kfree((char*)p);
801033e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033ec:	83 c4 10             	add    $0x10,%esp
}
801033ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033f2:	5b                   	pop    %ebx
801033f3:	5e                   	pop    %esi
801033f4:	5d                   	pop    %ebp
    kfree((char*)p);
801033f5:	e9 26 ef ff ff       	jmp    80102320 <kfree>
801033fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103400 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	57                   	push   %edi
80103404:	56                   	push   %esi
80103405:	53                   	push   %ebx
80103406:	83 ec 28             	sub    $0x28,%esp
80103409:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010340c:	53                   	push   %ebx
8010340d:	e8 de 11 00 00       	call   801045f0 <acquire>
  for(i = 0; i < n; i++){
80103412:	8b 45 10             	mov    0x10(%ebp),%eax
80103415:	83 c4 10             	add    $0x10,%esp
80103418:	85 c0                	test   %eax,%eax
8010341a:	0f 8e c9 00 00 00    	jle    801034e9 <pipewrite+0xe9>
80103420:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103423:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103429:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010342f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103432:	03 4d 10             	add    0x10(%ebp),%ecx
80103435:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103438:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010343e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103444:	39 d0                	cmp    %edx,%eax
80103446:	75 71                	jne    801034b9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103448:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010344e:	85 c0                	test   %eax,%eax
80103450:	74 4e                	je     801034a0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103452:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103458:	eb 3a                	jmp    80103494 <pipewrite+0x94>
8010345a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103460:	83 ec 0c             	sub    $0xc,%esp
80103463:	57                   	push   %edi
80103464:	e8 47 0b 00 00       	call   80103fb0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103469:	5a                   	pop    %edx
8010346a:	59                   	pop    %ecx
8010346b:	53                   	push   %ebx
8010346c:	56                   	push   %esi
8010346d:	e8 7e 09 00 00       	call   80103df0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103472:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103478:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010347e:	83 c4 10             	add    $0x10,%esp
80103481:	05 00 02 00 00       	add    $0x200,%eax
80103486:	39 c2                	cmp    %eax,%edx
80103488:	75 36                	jne    801034c0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010348a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103490:	85 c0                	test   %eax,%eax
80103492:	74 0c                	je     801034a0 <pipewrite+0xa0>
80103494:	e8 67 03 00 00       	call   80103800 <myproc>
80103499:	8b 40 28             	mov    0x28(%eax),%eax
8010349c:	85 c0                	test   %eax,%eax
8010349e:	74 c0                	je     80103460 <pipewrite+0x60>
        release(&p->lock);
801034a0:	83 ec 0c             	sub    $0xc,%esp
801034a3:	53                   	push   %ebx
801034a4:	e8 07 12 00 00       	call   801046b0 <release>
        return -1;
801034a9:	83 c4 10             	add    $0x10,%esp
801034ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034b4:	5b                   	pop    %ebx
801034b5:	5e                   	pop    %esi
801034b6:	5f                   	pop    %edi
801034b7:	5d                   	pop    %ebp
801034b8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034b9:	89 c2                	mov    %eax,%edx
801034bb:	90                   	nop
801034bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034c0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034c3:	8d 42 01             	lea    0x1(%edx),%eax
801034c6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034cc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034d2:	83 c6 01             	add    $0x1,%esi
801034d5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034d9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034dc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034df:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801034e3:	0f 85 4f ff ff ff    	jne    80103438 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801034e9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034ef:	83 ec 0c             	sub    $0xc,%esp
801034f2:	50                   	push   %eax
801034f3:	e8 b8 0a 00 00       	call   80103fb0 <wakeup>
  release(&p->lock);
801034f8:	89 1c 24             	mov    %ebx,(%esp)
801034fb:	e8 b0 11 00 00       	call   801046b0 <release>
  return n;
80103500:	83 c4 10             	add    $0x10,%esp
80103503:	8b 45 10             	mov    0x10(%ebp),%eax
80103506:	eb a9                	jmp    801034b1 <pipewrite+0xb1>
80103508:	90                   	nop
80103509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103510 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103510:	55                   	push   %ebp
80103511:	89 e5                	mov    %esp,%ebp
80103513:	57                   	push   %edi
80103514:	56                   	push   %esi
80103515:	53                   	push   %ebx
80103516:	83 ec 18             	sub    $0x18,%esp
80103519:	8b 75 08             	mov    0x8(%ebp),%esi
8010351c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010351f:	56                   	push   %esi
80103520:	e8 cb 10 00 00       	call   801045f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103525:	83 c4 10             	add    $0x10,%esp
80103528:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010352e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103534:	75 6a                	jne    801035a0 <piperead+0x90>
80103536:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010353c:	85 db                	test   %ebx,%ebx
8010353e:	0f 84 c4 00 00 00    	je     80103608 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103544:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010354a:	eb 2d                	jmp    80103579 <piperead+0x69>
8010354c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103550:	83 ec 08             	sub    $0x8,%esp
80103553:	56                   	push   %esi
80103554:	53                   	push   %ebx
80103555:	e8 96 08 00 00       	call   80103df0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010355a:	83 c4 10             	add    $0x10,%esp
8010355d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103563:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103569:	75 35                	jne    801035a0 <piperead+0x90>
8010356b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103571:	85 d2                	test   %edx,%edx
80103573:	0f 84 8f 00 00 00    	je     80103608 <piperead+0xf8>
    if(myproc()->killed){
80103579:	e8 82 02 00 00       	call   80103800 <myproc>
8010357e:	8b 48 28             	mov    0x28(%eax),%ecx
80103581:	85 c9                	test   %ecx,%ecx
80103583:	74 cb                	je     80103550 <piperead+0x40>
      release(&p->lock);
80103585:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103588:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010358d:	56                   	push   %esi
8010358e:	e8 1d 11 00 00       	call   801046b0 <release>
      return -1;
80103593:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103596:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103599:	89 d8                	mov    %ebx,%eax
8010359b:	5b                   	pop    %ebx
8010359c:	5e                   	pop    %esi
8010359d:	5f                   	pop    %edi
8010359e:	5d                   	pop    %ebp
8010359f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035a0:	8b 45 10             	mov    0x10(%ebp),%eax
801035a3:	85 c0                	test   %eax,%eax
801035a5:	7e 61                	jle    80103608 <piperead+0xf8>
    if(p->nread == p->nwrite)
801035a7:	31 db                	xor    %ebx,%ebx
801035a9:	eb 13                	jmp    801035be <piperead+0xae>
801035ab:	90                   	nop
801035ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035b0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035b6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035bc:	74 1f                	je     801035dd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035be:	8d 41 01             	lea    0x1(%ecx),%eax
801035c1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035c7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035cd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035d2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035d5:	83 c3 01             	add    $0x1,%ebx
801035d8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035db:	75 d3                	jne    801035b0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035dd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035e3:	83 ec 0c             	sub    $0xc,%esp
801035e6:	50                   	push   %eax
801035e7:	e8 c4 09 00 00       	call   80103fb0 <wakeup>
  release(&p->lock);
801035ec:	89 34 24             	mov    %esi,(%esp)
801035ef:	e8 bc 10 00 00       	call   801046b0 <release>
  return i;
801035f4:	83 c4 10             	add    $0x10,%esp
}
801035f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035fa:	89 d8                	mov    %ebx,%eax
801035fc:	5b                   	pop    %ebx
801035fd:	5e                   	pop    %esi
801035fe:	5f                   	pop    %edi
801035ff:	5d                   	pop    %ebp
80103600:	c3                   	ret    
80103601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103608:	31 db                	xor    %ebx,%ebx
8010360a:	eb d1                	jmp    801035dd <piperead+0xcd>
8010360c:	66 90                	xchg   %ax,%ax
8010360e:	66 90                	xchg   %ax,%ax

80103610 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103614:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103619:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010361c:	68 20 2d 11 80       	push   $0x80112d20
80103621:	e8 ca 0f 00 00       	call   801045f0 <acquire>
80103626:	83 c4 10             	add    $0x10,%esp
80103629:	eb 17                	jmp    80103642 <allocproc+0x32>
8010362b:	90                   	nop
8010362c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103630:	81 c3 98 00 00 00    	add    $0x98,%ebx
80103636:	81 fb 54 53 11 80    	cmp    $0x80115354,%ebx
8010363c:	0f 83 86 00 00 00    	jae    801036c8 <allocproc+0xb8>
    if(p->state == UNUSED)
80103642:	8b 43 0c             	mov    0xc(%ebx),%eax
80103645:	85 c0                	test   %eax,%eax
80103647:	75 e7                	jne    80103630 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103649:	a1 04 a0 10 80       	mov    0x8010a004,%eax
 
//  if(p->init!=1){
 //   p->priority = 10;
     cprintf("hi~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
8010364e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103651:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103658:	8d 50 01             	lea    0x1(%eax),%edx
8010365b:	89 43 10             	mov    %eax,0x10(%ebx)
     cprintf("hi~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
8010365e:	68 18 78 10 80       	push   $0x80107818
  p->pid = nextpid++;
80103663:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
     cprintf("hi~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
80103669:	e8 f2 cf ff ff       	call   80100660 <cprintf>
 // p->init=1;
 // }
 

  release(&ptable.lock);
8010366e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103675:	e8 36 10 00 00       	call   801046b0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010367a:	e8 51 ee ff ff       	call   801024d0 <kalloc>
8010367f:	83 c4 10             	add    $0x10,%esp
80103682:	85 c0                	test   %eax,%eax
80103684:	89 43 08             	mov    %eax,0x8(%ebx)
80103687:	74 58                	je     801036e1 <allocproc+0xd1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103689:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010368f:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103692:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103697:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010369a:	c7 40 14 11 5a 10 80 	movl   $0x80105a11,0x14(%eax)
  p->context = (struct context*)sp;
801036a1:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036a4:	6a 14                	push   $0x14
801036a6:	6a 00                	push   $0x0
801036a8:	50                   	push   %eax
801036a9:	e8 52 10 00 00       	call   80104700 <memset>
  p->context->eip = (uint)forkret;
801036ae:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801036b1:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801036b4:	c7 40 10 f0 36 10 80 	movl   $0x801036f0,0x10(%eax)
}
801036bb:	89 d8                	mov    %ebx,%eax
801036bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036c0:	c9                   	leave  
801036c1:	c3                   	ret    
801036c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801036c8:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801036cb:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801036cd:	68 20 2d 11 80       	push   $0x80112d20
801036d2:	e8 d9 0f 00 00       	call   801046b0 <release>
}
801036d7:	89 d8                	mov    %ebx,%eax
  return 0;
801036d9:	83 c4 10             	add    $0x10,%esp
}
801036dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801036df:	c9                   	leave  
801036e0:	c3                   	ret    
    p->state = UNUSED;
801036e1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801036e8:	31 db                	xor    %ebx,%ebx
801036ea:	eb cf                	jmp    801036bb <allocproc+0xab>
801036ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801036f6:	68 20 2d 11 80       	push   $0x80112d20
801036fb:	e8 b0 0f 00 00       	call   801046b0 <release>

  if (first) {
80103700:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103705:	83 c4 10             	add    $0x10,%esp
80103708:	85 c0                	test   %eax,%eax
8010370a:	75 04                	jne    80103710 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010370c:	c9                   	leave  
8010370d:	c3                   	ret    
8010370e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103710:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103713:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010371a:	00 00 00 
    iinit(ROOTDEV);
8010371d:	6a 01                	push   $0x1
8010371f:	e8 6c dd ff ff       	call   80101490 <iinit>
    initlog(ROOTDEV);
80103724:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010372b:	e8 e0 f3 ff ff       	call   80102b10 <initlog>
80103730:	83 c4 10             	add    $0x10,%esp
}
80103733:	c9                   	leave  
80103734:	c3                   	ret    
80103735:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103740 <pinit>:
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103746:	68 84 78 10 80       	push   $0x80107884
8010374b:	68 20 2d 11 80       	push   $0x80112d20
80103750:	e8 5b 0d 00 00       	call   801044b0 <initlock>
}
80103755:	83 c4 10             	add    $0x10,%esp
80103758:	c9                   	leave  
80103759:	c3                   	ret    
8010375a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103760 <mycpu>:
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	56                   	push   %esi
80103764:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103765:	9c                   	pushf  
80103766:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103767:	f6 c4 02             	test   $0x2,%ah
8010376a:	75 5e                	jne    801037ca <mycpu+0x6a>
  apicid = lapicid();
8010376c:	e8 cf ef ff ff       	call   80102740 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103771:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103777:	85 f6                	test   %esi,%esi
80103779:	7e 42                	jle    801037bd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010377b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103782:	39 d0                	cmp    %edx,%eax
80103784:	74 30                	je     801037b6 <mycpu+0x56>
80103786:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010378b:	31 d2                	xor    %edx,%edx
8010378d:	8d 76 00             	lea    0x0(%esi),%esi
80103790:	83 c2 01             	add    $0x1,%edx
80103793:	39 f2                	cmp    %esi,%edx
80103795:	74 26                	je     801037bd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103797:	0f b6 19             	movzbl (%ecx),%ebx
8010379a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801037a0:	39 c3                	cmp    %eax,%ebx
801037a2:	75 ec                	jne    80103790 <mycpu+0x30>
801037a4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801037aa:	05 80 27 11 80       	add    $0x80112780,%eax
}
801037af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037b2:	5b                   	pop    %ebx
801037b3:	5e                   	pop    %esi
801037b4:	5d                   	pop    %ebp
801037b5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801037b6:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
801037bb:	eb f2                	jmp    801037af <mycpu+0x4f>
  panic("unknown apicid\n");
801037bd:	83 ec 0c             	sub    $0xc,%esp
801037c0:	68 8b 78 10 80       	push   $0x8010788b
801037c5:	e8 c6 cb ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801037ca:	83 ec 0c             	sub    $0xc,%esp
801037cd:	68 3c 78 10 80       	push   $0x8010783c
801037d2:	e8 b9 cb ff ff       	call   80100390 <panic>
801037d7:	89 f6                	mov    %esi,%esi
801037d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037e0 <cpuid>:
cpuid() {
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801037e6:	e8 75 ff ff ff       	call   80103760 <mycpu>
801037eb:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
801037f0:	c9                   	leave  
  return mycpu()-cpus;
801037f1:	c1 f8 04             	sar    $0x4,%eax
801037f4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801037fa:	c3                   	ret    
801037fb:	90                   	nop
801037fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103800 <myproc>:
myproc(void) {
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	53                   	push   %ebx
80103804:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103807:	e8 14 0d 00 00       	call   80104520 <pushcli>
  c = mycpu();
8010380c:	e8 4f ff ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103811:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103817:	e8 44 0d 00 00       	call   80104560 <popcli>
}
8010381c:	83 c4 04             	add    $0x4,%esp
8010381f:	89 d8                	mov    %ebx,%eax
80103821:	5b                   	pop    %ebx
80103822:	5d                   	pop    %ebp
80103823:	c3                   	ret    
80103824:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010382a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103830 <userinit>:
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	53                   	push   %ebx
80103834:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103837:	e8 d4 fd ff ff       	call   80103610 <allocproc>
8010383c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010383e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103843:	e8 c8 37 00 00       	call   80107010 <setupkvm>
80103848:	85 c0                	test   %eax,%eax
8010384a:	89 43 04             	mov    %eax,0x4(%ebx)
8010384d:	0f 84 bd 00 00 00    	je     80103910 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103853:	83 ec 04             	sub    $0x4,%esp
80103856:	68 2c 00 00 00       	push   $0x2c
8010385b:	68 60 a4 10 80       	push   $0x8010a460
80103860:	50                   	push   %eax
80103861:	e8 8a 34 00 00       	call   80106cf0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103866:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103869:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010386f:	6a 4c                	push   $0x4c
80103871:	6a 00                	push   $0x0
80103873:	ff 73 18             	pushl  0x18(%ebx)
80103876:	e8 85 0e 00 00       	call   80104700 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010387b:	8b 43 18             	mov    0x18(%ebx),%eax
8010387e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103883:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103888:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010388b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010388f:	8b 43 18             	mov    0x18(%ebx),%eax
80103892:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103896:	8b 43 18             	mov    0x18(%ebx),%eax
80103899:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010389d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801038a1:	8b 43 18             	mov    0x18(%ebx),%eax
801038a4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038a8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801038ac:	8b 43 18             	mov    0x18(%ebx),%eax
801038af:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801038b6:	8b 43 18             	mov    0x18(%ebx),%eax
801038b9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801038c0:	8b 43 18             	mov    0x18(%ebx),%eax
801038c3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801038ca:	8d 43 70             	lea    0x70(%ebx),%eax
801038cd:	6a 10                	push   $0x10
801038cf:	68 b4 78 10 80       	push   $0x801078b4
801038d4:	50                   	push   %eax
801038d5:	e8 06 10 00 00       	call   801048e0 <safestrcpy>
  p->cwd = namei("/");
801038da:	c7 04 24 bd 78 10 80 	movl   $0x801078bd,(%esp)
801038e1:	e8 0a e6 ff ff       	call   80101ef0 <namei>
801038e6:	89 43 6c             	mov    %eax,0x6c(%ebx)
  acquire(&ptable.lock);
801038e9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801038f0:	e8 fb 0c 00 00       	call   801045f0 <acquire>
  p->state = RUNNABLE;
801038f5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801038fc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103903:	e8 a8 0d 00 00       	call   801046b0 <release>
}
80103908:	83 c4 10             	add    $0x10,%esp
8010390b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010390e:	c9                   	leave  
8010390f:	c3                   	ret    
    panic("userinit: out of memory?");
80103910:	83 ec 0c             	sub    $0xc,%esp
80103913:	68 9b 78 10 80       	push   $0x8010789b
80103918:	e8 73 ca ff ff       	call   80100390 <panic>
8010391d:	8d 76 00             	lea    0x0(%esi),%esi

80103920 <growproc>:
{
80103920:	55                   	push   %ebp
80103921:	89 e5                	mov    %esp,%ebp
80103923:	56                   	push   %esi
80103924:	53                   	push   %ebx
80103925:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103928:	e8 f3 0b 00 00       	call   80104520 <pushcli>
  c = mycpu();
8010392d:	e8 2e fe ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103932:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103938:	e8 23 0c 00 00       	call   80104560 <popcli>
  if(n > 0){
8010393d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103940:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103942:	7f 1c                	jg     80103960 <growproc+0x40>
  } else if(n < 0){
80103944:	75 3a                	jne    80103980 <growproc+0x60>
  switchuvm(curproc);
80103946:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103949:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010394b:	53                   	push   %ebx
8010394c:	e8 8f 32 00 00       	call   80106be0 <switchuvm>
  return 0;
80103951:	83 c4 10             	add    $0x10,%esp
80103954:	31 c0                	xor    %eax,%eax
}
80103956:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103959:	5b                   	pop    %ebx
8010395a:	5e                   	pop    %esi
8010395b:	5d                   	pop    %ebp
8010395c:	c3                   	ret    
8010395d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103960:	83 ec 04             	sub    $0x4,%esp
80103963:	01 c6                	add    %eax,%esi
80103965:	56                   	push   %esi
80103966:	50                   	push   %eax
80103967:	ff 73 04             	pushl  0x4(%ebx)
8010396a:	e8 c1 34 00 00       	call   80106e30 <allocuvm>
8010396f:	83 c4 10             	add    $0x10,%esp
80103972:	85 c0                	test   %eax,%eax
80103974:	75 d0                	jne    80103946 <growproc+0x26>
      return -1;
80103976:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010397b:	eb d9                	jmp    80103956 <growproc+0x36>
8010397d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103980:	83 ec 04             	sub    $0x4,%esp
80103983:	01 c6                	add    %eax,%esi
80103985:	56                   	push   %esi
80103986:	50                   	push   %eax
80103987:	ff 73 04             	pushl  0x4(%ebx)
8010398a:	e8 d1 35 00 00       	call   80106f60 <deallocuvm>
8010398f:	83 c4 10             	add    $0x10,%esp
80103992:	85 c0                	test   %eax,%eax
80103994:	75 b0                	jne    80103946 <growproc+0x26>
80103996:	eb de                	jmp    80103976 <growproc+0x56>
80103998:	90                   	nop
80103999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801039a0 <fork>:
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	57                   	push   %edi
801039a4:	56                   	push   %esi
801039a5:	53                   	push   %ebx
801039a6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801039a9:	e8 72 0b 00 00       	call   80104520 <pushcli>
  c = mycpu();
801039ae:	e8 ad fd ff ff       	call   80103760 <mycpu>
  p = c->proc;
801039b3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039b9:	e8 a2 0b 00 00       	call   80104560 <popcli>
  if((np = allocproc()) == 0){
801039be:	e8 4d fc ff ff       	call   80103610 <allocproc>
801039c3:	85 c0                	test   %eax,%eax
801039c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801039c8:	0f 84 b7 00 00 00    	je     80103a85 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801039ce:	83 ec 08             	sub    $0x8,%esp
801039d1:	ff 33                	pushl  (%ebx)
801039d3:	ff 73 04             	pushl  0x4(%ebx)
801039d6:	89 c7                	mov    %eax,%edi
801039d8:	e8 03 37 00 00       	call   801070e0 <copyuvm>
801039dd:	83 c4 10             	add    $0x10,%esp
801039e0:	85 c0                	test   %eax,%eax
801039e2:	89 47 04             	mov    %eax,0x4(%edi)
801039e5:	0f 84 a1 00 00 00    	je     80103a8c <fork+0xec>
  np->sz = curproc->sz;
801039eb:	8b 03                	mov    (%ebx),%eax
801039ed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801039f0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801039f2:	89 59 14             	mov    %ebx,0x14(%ecx)
801039f5:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
801039f7:	8b 79 18             	mov    0x18(%ecx),%edi
801039fa:	8b 73 18             	mov    0x18(%ebx),%esi
801039fd:	b9 13 00 00 00       	mov    $0x13,%ecx
80103a02:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103a04:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103a06:	8b 40 18             	mov    0x18(%eax),%eax
80103a09:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103a10:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103a14:	85 c0                	test   %eax,%eax
80103a16:	74 13                	je     80103a2b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103a18:	83 ec 0c             	sub    $0xc,%esp
80103a1b:	50                   	push   %eax
80103a1c:	e8 cf d3 ff ff       	call   80100df0 <filedup>
80103a21:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a24:	83 c4 10             	add    $0x10,%esp
80103a27:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103a2b:	83 c6 01             	add    $0x1,%esi
80103a2e:	83 fe 10             	cmp    $0x10,%esi
80103a31:	75 dd                	jne    80103a10 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103a33:	83 ec 0c             	sub    $0xc,%esp
80103a36:	ff 73 6c             	pushl  0x6c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a39:	83 c3 70             	add    $0x70,%ebx
  np->cwd = idup(curproc->cwd);
80103a3c:	e8 1f dc ff ff       	call   80101660 <idup>
80103a41:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a44:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103a47:	89 47 6c             	mov    %eax,0x6c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a4a:	8d 47 70             	lea    0x70(%edi),%eax
80103a4d:	6a 10                	push   $0x10
80103a4f:	53                   	push   %ebx
80103a50:	50                   	push   %eax
80103a51:	e8 8a 0e 00 00       	call   801048e0 <safestrcpy>
  pid = np->pid;
80103a56:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103a59:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a60:	e8 8b 0b 00 00       	call   801045f0 <acquire>
  np->state = RUNNABLE;
80103a65:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103a6c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a73:	e8 38 0c 00 00       	call   801046b0 <release>
  return pid;
80103a78:	83 c4 10             	add    $0x10,%esp
}
80103a7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a7e:	89 d8                	mov    %ebx,%eax
80103a80:	5b                   	pop    %ebx
80103a81:	5e                   	pop    %esi
80103a82:	5f                   	pop    %edi
80103a83:	5d                   	pop    %ebp
80103a84:	c3                   	ret    
    return -1;
80103a85:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103a8a:	eb ef                	jmp    80103a7b <fork+0xdb>
    kfree(np->kstack);
80103a8c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103a8f:	83 ec 0c             	sub    $0xc,%esp
80103a92:	ff 73 08             	pushl  0x8(%ebx)
80103a95:	e8 86 e8 ff ff       	call   80102320 <kfree>
    np->kstack = 0;
80103a9a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103aa1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103aa8:	83 c4 10             	add    $0x10,%esp
80103aab:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ab0:	eb c9                	jmp    80103a7b <fork+0xdb>
80103ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ac0 <scheduler>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	57                   	push   %edi
80103ac4:	56                   	push   %esi
80103ac5:	53                   	push   %ebx
80103ac6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103ac9:	e8 92 fc ff ff       	call   80103760 <mycpu>
80103ace:	8d 70 04             	lea    0x4(%eax),%esi
80103ad1:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
80103ad3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ada:	00 00 00 
  asm volatile("sti");
80103add:	fb                   	sti    
    acquire(&ptable.lock);
80103ade:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ae1:	bf 54 2d 11 80       	mov    $0x80112d54,%edi
    acquire(&ptable.lock);
80103ae6:	68 20 2d 11 80       	push   $0x80112d20
80103aeb:	e8 00 0b 00 00       	call   801045f0 <acquire>
80103af0:	83 c4 10             	add    $0x10,%esp
80103af3:	eb 15                	jmp    80103b0a <scheduler+0x4a>
80103af5:	8d 76 00             	lea    0x0(%esi),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103af8:	81 c7 98 00 00 00    	add    $0x98,%edi
80103afe:	81 ff 54 53 11 80    	cmp    $0x80115354,%edi
80103b04:	0f 83 8c 00 00 00    	jae    80103b96 <scheduler+0xd6>
      if(p->state != RUNNABLE)
80103b0a:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103b0e:	75 e8                	jne    80103af8 <scheduler+0x38>
      for(p2=ptable.proc;p2<&ptable.proc[NPROC];p2++){
80103b10:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103b15:	8d 76 00             	lea    0x0(%esi),%esi
        if(p2->state!=RUNNABLE)
80103b18:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103b1c:	75 17                	jne    80103b35 <scheduler+0x75>
        if(pHigh->priority > p2->priority){//larger value, lower priority
80103b1e:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103b24:	39 97 80 00 00 00    	cmp    %edx,0x80(%edi)
80103b2a:	7e 09                	jle    80103b35 <scheduler+0x75>
          p2->tick++;
80103b2c:	83 80 88 00 00 00 01 	addl   $0x1,0x88(%eax)
80103b33:	89 c7                	mov    %eax,%edi
      for(p2=ptable.proc;p2<&ptable.proc[NPROC];p2++){
80103b35:	05 98 00 00 00       	add    $0x98,%eax
80103b3a:	3d 54 53 11 80       	cmp    $0x80115354,%eax
80103b3f:	72 d7                	jb     80103b18 <scheduler+0x58>
      switchuvm(p);
80103b41:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103b44:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(p);
80103b4a:	57                   	push   %edi
80103b4b:	e8 90 30 00 00       	call   80106be0 <switchuvm>
      p->current_slice = p->tick;
80103b50:	8b 87 88 00 00 00    	mov    0x88(%edi),%eax
      p->state = RUNNING;
80103b56:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      p->current_slice = p->tick;
80103b5d:	89 87 8c 00 00 00    	mov    %eax,0x8c(%edi)
      swtch(&(c->scheduler), p->context);
80103b63:	58                   	pop    %eax
80103b64:	5a                   	pop    %edx
80103b65:	ff 77 1c             	pushl  0x1c(%edi)
80103b68:	56                   	push   %esi
80103b69:	e8 cd 0d 00 00       	call   8010493b <swtch>
     p->csnum++;//1-(5) context switch count 
80103b6e:	83 47 20 01          	addl   $0x1,0x20(%edi)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b72:	81 c7 98 00 00 00    	add    $0x98,%edi
      switchkvm();
80103b78:	e8 43 30 00 00       	call   80106bc0 <switchkvm>
      c->proc = 0;
80103b7d:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b80:	81 ff 54 53 11 80    	cmp    $0x80115354,%edi
      c->proc = 0;
80103b86:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103b8d:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b90:	0f 82 74 ff ff ff    	jb     80103b0a <scheduler+0x4a>
    release(&ptable.lock);
80103b96:	83 ec 0c             	sub    $0xc,%esp
80103b99:	68 20 2d 11 80       	push   $0x80112d20
80103b9e:	e8 0d 0b 00 00       	call   801046b0 <release>
  for(;;){
80103ba3:	83 c4 10             	add    $0x10,%esp
80103ba6:	e9 32 ff ff ff       	jmp    80103add <scheduler+0x1d>
80103bab:	90                   	nop
80103bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103bb0 <sched>:
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	56                   	push   %esi
80103bb4:	53                   	push   %ebx
  pushcli();
80103bb5:	e8 66 09 00 00       	call   80104520 <pushcli>
  c = mycpu();
80103bba:	e8 a1 fb ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103bbf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bc5:	e8 96 09 00 00       	call   80104560 <popcli>
  if(!holding(&ptable.lock))
80103bca:	83 ec 0c             	sub    $0xc,%esp
80103bcd:	68 20 2d 11 80       	push   $0x80112d20
80103bd2:	e8 e9 09 00 00       	call   801045c0 <holding>
80103bd7:	83 c4 10             	add    $0x10,%esp
80103bda:	85 c0                	test   %eax,%eax
80103bdc:	74 4f                	je     80103c2d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103bde:	e8 7d fb ff ff       	call   80103760 <mycpu>
80103be3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103bea:	75 68                	jne    80103c54 <sched+0xa4>
  if(p->state == RUNNING)
80103bec:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103bf0:	74 55                	je     80103c47 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103bf2:	9c                   	pushf  
80103bf3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103bf4:	f6 c4 02             	test   $0x2,%ah
80103bf7:	75 41                	jne    80103c3a <sched+0x8a>
  intena = mycpu()->intena;
80103bf9:	e8 62 fb ff ff       	call   80103760 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103bfe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103c01:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103c07:	e8 54 fb ff ff       	call   80103760 <mycpu>
80103c0c:	83 ec 08             	sub    $0x8,%esp
80103c0f:	ff 70 04             	pushl  0x4(%eax)
80103c12:	53                   	push   %ebx
80103c13:	e8 23 0d 00 00       	call   8010493b <swtch>
  mycpu()->intena = intena;
80103c18:	e8 43 fb ff ff       	call   80103760 <mycpu>
}
80103c1d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103c20:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103c26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c29:	5b                   	pop    %ebx
80103c2a:	5e                   	pop    %esi
80103c2b:	5d                   	pop    %ebp
80103c2c:	c3                   	ret    
    panic("sched ptable.lock");
80103c2d:	83 ec 0c             	sub    $0xc,%esp
80103c30:	68 bf 78 10 80       	push   $0x801078bf
80103c35:	e8 56 c7 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103c3a:	83 ec 0c             	sub    $0xc,%esp
80103c3d:	68 eb 78 10 80       	push   $0x801078eb
80103c42:	e8 49 c7 ff ff       	call   80100390 <panic>
    panic("sched running");
80103c47:	83 ec 0c             	sub    $0xc,%esp
80103c4a:	68 dd 78 10 80       	push   $0x801078dd
80103c4f:	e8 3c c7 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103c54:	83 ec 0c             	sub    $0xc,%esp
80103c57:	68 d1 78 10 80       	push   $0x801078d1
80103c5c:	e8 2f c7 ff ff       	call   80100390 <panic>
80103c61:	eb 0d                	jmp    80103c70 <exit>
80103c63:	90                   	nop
80103c64:	90                   	nop
80103c65:	90                   	nop
80103c66:	90                   	nop
80103c67:	90                   	nop
80103c68:	90                   	nop
80103c69:	90                   	nop
80103c6a:	90                   	nop
80103c6b:	90                   	nop
80103c6c:	90                   	nop
80103c6d:	90                   	nop
80103c6e:	90                   	nop
80103c6f:	90                   	nop

80103c70 <exit>:
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	57                   	push   %edi
80103c74:	56                   	push   %esi
80103c75:	53                   	push   %ebx
80103c76:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103c79:	e8 a2 08 00 00       	call   80104520 <pushcli>
  c = mycpu();
80103c7e:	e8 dd fa ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103c83:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103c89:	e8 d2 08 00 00       	call   80104560 <popcli>
  if(curproc == initproc)
80103c8e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103c94:	8d 5e 2c             	lea    0x2c(%esi),%ebx
80103c97:	8d 7e 6c             	lea    0x6c(%esi),%edi
80103c9a:	0f 84 f1 00 00 00    	je     80103d91 <exit+0x121>
    if(curproc->ofile[fd]){
80103ca0:	8b 03                	mov    (%ebx),%eax
80103ca2:	85 c0                	test   %eax,%eax
80103ca4:	74 12                	je     80103cb8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103ca6:	83 ec 0c             	sub    $0xc,%esp
80103ca9:	50                   	push   %eax
80103caa:	e8 91 d1 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103caf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103cb5:	83 c4 10             	add    $0x10,%esp
80103cb8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103cbb:	39 fb                	cmp    %edi,%ebx
80103cbd:	75 e1                	jne    80103ca0 <exit+0x30>
  begin_op();
80103cbf:	e8 ec ee ff ff       	call   80102bb0 <begin_op>
  iput(curproc->cwd);
80103cc4:	83 ec 0c             	sub    $0xc,%esp
80103cc7:	ff 76 6c             	pushl  0x6c(%esi)
80103cca:	e8 f1 da ff ff       	call   801017c0 <iput>
  end_op();
80103ccf:	e8 4c ef ff ff       	call   80102c20 <end_op>
  curproc->cwd = 0;
80103cd4:	c7 46 6c 00 00 00 00 	movl   $0x0,0x6c(%esi)
  acquire(&ptable.lock);
80103cdb:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ce2:	e8 09 09 00 00       	call   801045f0 <acquire>
  wakeup1(curproc->parent);
80103ce7:	8b 56 14             	mov    0x14(%esi),%edx
80103cea:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ced:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103cf2:	eb 10                	jmp    80103d04 <exit+0x94>
80103cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cf8:	05 98 00 00 00       	add    $0x98,%eax
80103cfd:	3d 54 53 11 80       	cmp    $0x80115354,%eax
80103d02:	73 1e                	jae    80103d22 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80103d04:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d08:	75 ee                	jne    80103cf8 <exit+0x88>
80103d0a:	3b 50 24             	cmp    0x24(%eax),%edx
80103d0d:	75 e9                	jne    80103cf8 <exit+0x88>
      p->state = RUNNABLE;
80103d0f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d16:	05 98 00 00 00       	add    $0x98,%eax
80103d1b:	3d 54 53 11 80       	cmp    $0x80115354,%eax
80103d20:	72 e2                	jb     80103d04 <exit+0x94>
      p->parent = initproc;
80103d22:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d28:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103d2d:	eb 0f                	jmp    80103d3e <exit+0xce>
80103d2f:	90                   	nop
80103d30:	81 c2 98 00 00 00    	add    $0x98,%edx
80103d36:	81 fa 54 53 11 80    	cmp    $0x80115354,%edx
80103d3c:	73 3a                	jae    80103d78 <exit+0x108>
    if(p->parent == curproc){
80103d3e:	39 72 14             	cmp    %esi,0x14(%edx)
80103d41:	75 ed                	jne    80103d30 <exit+0xc0>
      if(p->state == ZOMBIE)
80103d43:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103d47:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103d4a:	75 e4                	jne    80103d30 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d4c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d51:	eb 11                	jmp    80103d64 <exit+0xf4>
80103d53:	90                   	nop
80103d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d58:	05 98 00 00 00       	add    $0x98,%eax
80103d5d:	3d 54 53 11 80       	cmp    $0x80115354,%eax
80103d62:	73 cc                	jae    80103d30 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103d64:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d68:	75 ee                	jne    80103d58 <exit+0xe8>
80103d6a:	3b 48 24             	cmp    0x24(%eax),%ecx
80103d6d:	75 e9                	jne    80103d58 <exit+0xe8>
      p->state = RUNNABLE;
80103d6f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d76:	eb e0                	jmp    80103d58 <exit+0xe8>
  curproc->state = ZOMBIE;
80103d78:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103d7f:	e8 2c fe ff ff       	call   80103bb0 <sched>
  panic("zombie exit");
80103d84:	83 ec 0c             	sub    $0xc,%esp
80103d87:	68 0c 79 10 80       	push   $0x8010790c
80103d8c:	e8 ff c5 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103d91:	83 ec 0c             	sub    $0xc,%esp
80103d94:	68 ff 78 10 80       	push   $0x801078ff
80103d99:	e8 f2 c5 ff ff       	call   80100390 <panic>
80103d9e:	66 90                	xchg   %ax,%ax

80103da0 <yield>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	53                   	push   %ebx
80103da4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103da7:	68 20 2d 11 80       	push   $0x80112d20
80103dac:	e8 3f 08 00 00       	call   801045f0 <acquire>
  pushcli();
80103db1:	e8 6a 07 00 00       	call   80104520 <pushcli>
  c = mycpu();
80103db6:	e8 a5 f9 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103dbb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dc1:	e8 9a 07 00 00       	call   80104560 <popcli>
  myproc()->state = RUNNABLE;
80103dc6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103dcd:	e8 de fd ff ff       	call   80103bb0 <sched>
  release(&ptable.lock);
80103dd2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103dd9:	e8 d2 08 00 00       	call   801046b0 <release>
}
80103dde:	83 c4 10             	add    $0x10,%esp
80103de1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103de4:	c9                   	leave  
80103de5:	c3                   	ret    
80103de6:	8d 76 00             	lea    0x0(%esi),%esi
80103de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103df0 <sleep>:
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	57                   	push   %edi
80103df4:	56                   	push   %esi
80103df5:	53                   	push   %ebx
80103df6:	83 ec 0c             	sub    $0xc,%esp
80103df9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103dfc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103dff:	e8 1c 07 00 00       	call   80104520 <pushcli>
  c = mycpu();
80103e04:	e8 57 f9 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103e09:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e0f:	e8 4c 07 00 00       	call   80104560 <popcli>
  if(p == 0)
80103e14:	85 db                	test   %ebx,%ebx
80103e16:	0f 84 87 00 00 00    	je     80103ea3 <sleep+0xb3>
  if(lk == 0)
80103e1c:	85 f6                	test   %esi,%esi
80103e1e:	74 76                	je     80103e96 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103e20:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103e26:	74 50                	je     80103e78 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103e28:	83 ec 0c             	sub    $0xc,%esp
80103e2b:	68 20 2d 11 80       	push   $0x80112d20
80103e30:	e8 bb 07 00 00       	call   801045f0 <acquire>
    release(lk);
80103e35:	89 34 24             	mov    %esi,(%esp)
80103e38:	e8 73 08 00 00       	call   801046b0 <release>
  p->chan = chan;
80103e3d:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
80103e40:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103e47:	e8 64 fd ff ff       	call   80103bb0 <sched>
  p->chan = 0;
80103e4c:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
80103e53:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e5a:	e8 51 08 00 00       	call   801046b0 <release>
    acquire(lk);
80103e5f:	89 75 08             	mov    %esi,0x8(%ebp)
80103e62:	83 c4 10             	add    $0x10,%esp
}
80103e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e68:	5b                   	pop    %ebx
80103e69:	5e                   	pop    %esi
80103e6a:	5f                   	pop    %edi
80103e6b:	5d                   	pop    %ebp
    acquire(lk);
80103e6c:	e9 7f 07 00 00       	jmp    801045f0 <acquire>
80103e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103e78:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
80103e7b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103e82:	e8 29 fd ff ff       	call   80103bb0 <sched>
  p->chan = 0;
80103e87:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
80103e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e91:	5b                   	pop    %ebx
80103e92:	5e                   	pop    %esi
80103e93:	5f                   	pop    %edi
80103e94:	5d                   	pop    %ebp
80103e95:	c3                   	ret    
    panic("sleep without lk");
80103e96:	83 ec 0c             	sub    $0xc,%esp
80103e99:	68 1e 79 10 80       	push   $0x8010791e
80103e9e:	e8 ed c4 ff ff       	call   80100390 <panic>
    panic("sleep");
80103ea3:	83 ec 0c             	sub    $0xc,%esp
80103ea6:	68 18 79 10 80       	push   $0x80107918
80103eab:	e8 e0 c4 ff ff       	call   80100390 <panic>

80103eb0 <wait>:
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	56                   	push   %esi
80103eb4:	53                   	push   %ebx
  pushcli();
80103eb5:	e8 66 06 00 00       	call   80104520 <pushcli>
  c = mycpu();
80103eba:	e8 a1 f8 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103ebf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ec5:	e8 96 06 00 00       	call   80104560 <popcli>
  acquire(&ptable.lock);
80103eca:	83 ec 0c             	sub    $0xc,%esp
80103ecd:	68 20 2d 11 80       	push   $0x80112d20
80103ed2:	e8 19 07 00 00       	call   801045f0 <acquire>
80103ed7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103eda:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103edc:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103ee1:	eb 13                	jmp    80103ef6 <wait+0x46>
80103ee3:	90                   	nop
80103ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ee8:	81 c3 98 00 00 00    	add    $0x98,%ebx
80103eee:	81 fb 54 53 11 80    	cmp    $0x80115354,%ebx
80103ef4:	73 1e                	jae    80103f14 <wait+0x64>
      if(p->parent != curproc)
80103ef6:	39 73 14             	cmp    %esi,0x14(%ebx)
80103ef9:	75 ed                	jne    80103ee8 <wait+0x38>
      if(p->state == ZOMBIE){
80103efb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103eff:	74 37                	je     80103f38 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f01:	81 c3 98 00 00 00    	add    $0x98,%ebx
      havekids = 1;
80103f07:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f0c:	81 fb 54 53 11 80    	cmp    $0x80115354,%ebx
80103f12:	72 e2                	jb     80103ef6 <wait+0x46>
    if(!havekids || curproc->killed){
80103f14:	85 c0                	test   %eax,%eax
80103f16:	74 76                	je     80103f8e <wait+0xde>
80103f18:	8b 46 28             	mov    0x28(%esi),%eax
80103f1b:	85 c0                	test   %eax,%eax
80103f1d:	75 6f                	jne    80103f8e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103f1f:	83 ec 08             	sub    $0x8,%esp
80103f22:	68 20 2d 11 80       	push   $0x80112d20
80103f27:	56                   	push   %esi
80103f28:	e8 c3 fe ff ff       	call   80103df0 <sleep>
    havekids = 0;
80103f2d:	83 c4 10             	add    $0x10,%esp
80103f30:	eb a8                	jmp    80103eda <wait+0x2a>
80103f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80103f38:	83 ec 0c             	sub    $0xc,%esp
80103f3b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103f3e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f41:	e8 da e3 ff ff       	call   80102320 <kfree>
        freevm(p->pgdir);
80103f46:	5a                   	pop    %edx
80103f47:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103f4a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f51:	e8 3a 30 00 00       	call   80106f90 <freevm>
        release(&ptable.lock);
80103f56:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103f5d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f64:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f6b:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
80103f6f:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
80103f76:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103f7d:	e8 2e 07 00 00       	call   801046b0 <release>
        return pid;
80103f82:	83 c4 10             	add    $0x10,%esp
}
80103f85:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f88:	89 f0                	mov    %esi,%eax
80103f8a:	5b                   	pop    %ebx
80103f8b:	5e                   	pop    %esi
80103f8c:	5d                   	pop    %ebp
80103f8d:	c3                   	ret    
      release(&ptable.lock);
80103f8e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103f91:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103f96:	68 20 2d 11 80       	push   $0x80112d20
80103f9b:	e8 10 07 00 00       	call   801046b0 <release>
      return -1;
80103fa0:	83 c4 10             	add    $0x10,%esp
80103fa3:	eb e0                	jmp    80103f85 <wait+0xd5>
80103fa5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fb0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	53                   	push   %ebx
80103fb4:	83 ec 10             	sub    $0x10,%esp
80103fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103fba:	68 20 2d 11 80       	push   $0x80112d20
80103fbf:	e8 2c 06 00 00       	call   801045f0 <acquire>
80103fc4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fc7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103fcc:	eb 0e                	jmp    80103fdc <wakeup+0x2c>
80103fce:	66 90                	xchg   %ax,%ax
80103fd0:	05 98 00 00 00       	add    $0x98,%eax
80103fd5:	3d 54 53 11 80       	cmp    $0x80115354,%eax
80103fda:	73 1e                	jae    80103ffa <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80103fdc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fe0:	75 ee                	jne    80103fd0 <wakeup+0x20>
80103fe2:	3b 58 24             	cmp    0x24(%eax),%ebx
80103fe5:	75 e9                	jne    80103fd0 <wakeup+0x20>
      p->state = RUNNABLE;
80103fe7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fee:	05 98 00 00 00       	add    $0x98,%eax
80103ff3:	3d 54 53 11 80       	cmp    $0x80115354,%eax
80103ff8:	72 e2                	jb     80103fdc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80103ffa:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104001:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104004:	c9                   	leave  
  release(&ptable.lock);
80104005:	e9 a6 06 00 00       	jmp    801046b0 <release>
8010400a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104010 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	53                   	push   %ebx
80104014:	83 ec 10             	sub    $0x10,%esp
80104017:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010401a:	68 20 2d 11 80       	push   $0x80112d20
8010401f:	e8 cc 05 00 00       	call   801045f0 <acquire>
80104024:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104027:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010402c:	eb 0e                	jmp    8010403c <kill+0x2c>
8010402e:	66 90                	xchg   %ax,%ax
80104030:	05 98 00 00 00       	add    $0x98,%eax
80104035:	3d 54 53 11 80       	cmp    $0x80115354,%eax
8010403a:	73 34                	jae    80104070 <kill+0x60>
    if(p->pid == pid){
8010403c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010403f:	75 ef                	jne    80104030 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104041:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104045:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      if(p->state == SLEEPING)
8010404c:	75 07                	jne    80104055 <kill+0x45>
        p->state = RUNNABLE;
8010404e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104055:	83 ec 0c             	sub    $0xc,%esp
80104058:	68 20 2d 11 80       	push   $0x80112d20
8010405d:	e8 4e 06 00 00       	call   801046b0 <release>
      return 0;
80104062:	83 c4 10             	add    $0x10,%esp
80104065:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104067:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010406a:	c9                   	leave  
8010406b:	c3                   	ret    
8010406c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104070:	83 ec 0c             	sub    $0xc,%esp
80104073:	68 20 2d 11 80       	push   $0x80112d20
80104078:	e8 33 06 00 00       	call   801046b0 <release>
  return -1;
8010407d:	83 c4 10             	add    $0x10,%esp
80104080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104085:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104088:	c9                   	leave  
80104089:	c3                   	ret    
8010408a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104090 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	57                   	push   %edi
80104094:	56                   	push   %esi
80104095:	53                   	push   %ebx
80104096:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104099:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
8010409e:	83 ec 3c             	sub    $0x3c,%esp
801040a1:	eb 27                	jmp    801040ca <procdump+0x3a>
801040a3:	90                   	nop
801040a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801040a8:	83 ec 0c             	sub    $0xc,%esp
801040ab:	68 53 7d 10 80       	push   $0x80107d53
801040b0:	e8 ab c5 ff ff       	call   80100660 <cprintf>
801040b5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040b8:	81 c3 98 00 00 00    	add    $0x98,%ebx
801040be:	81 fb 54 53 11 80    	cmp    $0x80115354,%ebx
801040c4:	0f 83 86 00 00 00    	jae    80104150 <procdump+0xc0>
    if(p->state == UNUSED)
801040ca:	8b 43 0c             	mov    0xc(%ebx),%eax
801040cd:	85 c0                	test   %eax,%eax
801040cf:	74 e7                	je     801040b8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040d1:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801040d4:	ba 2f 79 10 80       	mov    $0x8010792f,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040d9:	77 11                	ja     801040ec <procdump+0x5c>
801040db:	8b 14 85 94 79 10 80 	mov    -0x7fef866c(,%eax,4),%edx
      state = "???";
801040e2:	b8 2f 79 10 80       	mov    $0x8010792f,%eax
801040e7:	85 d2                	test   %edx,%edx
801040e9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801040ec:	8d 43 70             	lea    0x70(%ebx),%eax
801040ef:	50                   	push   %eax
801040f0:	52                   	push   %edx
801040f1:	ff 73 10             	pushl  0x10(%ebx)
801040f4:	68 33 79 10 80       	push   $0x80107933
801040f9:	e8 62 c5 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801040fe:	83 c4 10             	add    $0x10,%esp
80104101:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104105:	75 a1                	jne    801040a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104107:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010410a:	83 ec 08             	sub    $0x8,%esp
8010410d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104110:	50                   	push   %eax
80104111:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104114:	8b 40 0c             	mov    0xc(%eax),%eax
80104117:	83 c0 08             	add    $0x8,%eax
8010411a:	50                   	push   %eax
8010411b:	e8 b0 03 00 00       	call   801044d0 <getcallerpcs>
80104120:	83 c4 10             	add    $0x10,%esp
80104123:	90                   	nop
80104124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104128:	8b 17                	mov    (%edi),%edx
8010412a:	85 d2                	test   %edx,%edx
8010412c:	0f 84 76 ff ff ff    	je     801040a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104132:	83 ec 08             	sub    $0x8,%esp
80104135:	83 c7 04             	add    $0x4,%edi
80104138:	52                   	push   %edx
80104139:	68 01 73 10 80       	push   $0x80107301
8010413e:	e8 1d c5 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104143:	83 c4 10             	add    $0x10,%esp
80104146:	39 fe                	cmp    %edi,%esi
80104148:	75 de                	jne    80104128 <procdump+0x98>
8010414a:	e9 59 ff ff ff       	jmp    801040a8 <procdump+0x18>
8010414f:	90                   	nop
  }
}
80104150:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104153:	5b                   	pop    %ebx
80104154:	5e                   	pop    %esi
80104155:	5f                   	pop    %edi
80104156:	5d                   	pop    %ebp
80104157:	c3                   	ret    
80104158:	90                   	nop
80104159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104160 <getnumproc>:

int
getnumproc(void)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	53                   	push   %ebx
struct proc *p;
int count=0;
80104164:	31 db                	xor    %ebx,%ebx
{
80104166:	83 ec 10             	sub    $0x10,%esp

acquire(&ptable.lock);
80104169:	68 20 2d 11 80       	push   $0x80112d20
8010416e:	e8 7d 04 00 00       	call   801045f0 <acquire>
80104173:	83 c4 10             	add    $0x10,%esp

for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104176:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
8010417b:	90                   	nop
8010417c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
if(p->state != UNUSED)
count++;
80104180:	83 7a 0c 01          	cmpl   $0x1,0xc(%edx)
80104184:	83 db ff             	sbb    $0xffffffff,%ebx
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104187:	81 c2 98 00 00 00    	add    $0x98,%edx
8010418d:	81 fa 54 53 11 80    	cmp    $0x80115354,%edx
80104193:	72 eb                	jb     80104180 <getnumproc+0x20>
}

release(&ptable.lock);
80104195:	83 ec 0c             	sub    $0xc,%esp
80104198:	68 20 2d 11 80       	push   $0x80112d20
8010419d:	e8 0e 05 00 00       	call   801046b0 <release>

return count;
}
801041a2:	89 d8                	mov    %ebx,%eax
801041a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041a7:	c9                   	leave  
801041a8:	c3                   	ret    
801041a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041b0 <getmaxpid>:

int
getmaxpid(void)
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	53                   	push   %ebx
  //struct uproc * table;
  struct proc *p;
  int i=0;
  int maxpid=0;
801041b4:	31 db                	xor    %ebx,%ebx
{
801041b6:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801041b9:	68 20 2d 11 80       	push   $0x80112d20
801041be:	e8 2d 04 00 00       	call   801045f0 <acquire>
801041c3:	83 c4 10             	add    $0x10,%esp
  for(i=0,p=ptable.proc;p<&ptable.proc[NPROC];p++)
801041c6:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
801041cb:	90                   	nop
801041cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    if(p->state != UNUSED){
801041d0:	8b 42 0c             	mov    0xc(%edx),%eax
801041d3:	85 c0                	test   %eax,%eax
801041d5:	74 03                	je     801041da <getmaxpid+0x2a>
      maxpid = p->pid;
801041d7:	8b 5a 10             	mov    0x10(%edx),%ebx
  for(i=0,p=ptable.proc;p<&ptable.proc[NPROC];p++)
801041da:	81 c2 98 00 00 00    	add    $0x98,%edx
801041e0:	81 fa 54 53 11 80    	cmp    $0x80115354,%edx
801041e6:	72 e8                	jb     801041d0 <getmaxpid+0x20>
      i++;
    }
  }
  release(&ptable.lock);
801041e8:	83 ec 0c             	sub    $0xc,%esp
801041eb:	68 20 2d 11 80       	push   $0x80112d20
801041f0:	e8 bb 04 00 00       	call   801046b0 <release>
  return maxpid;

}
801041f5:	89 d8                	mov    %ebx,%eax
801041f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041fa:	c9                   	leave  
801041fb:	c3                   	ret    
801041fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104200 <getprocinfo>:
int
getprocinfo(int pid, struct processInfo *pI)
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	57                   	push   %edi
80104204:	56                   	push   %esi
80104205:	53                   	push   %ebx
  struct proc *p;
  
  acquire(&ptable.lock);
  for(p=ptable.proc;p<&ptable.proc[NPROC];p++)
80104206:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
8010420b:	83 ec 18             	sub    $0x18,%esp
8010420e:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&ptable.lock);
80104211:	68 20 2d 11 80       	push   $0x80112d20
80104216:	e8 d5 03 00 00       	call   801045f0 <acquire>
8010421b:	83 c4 10             	add    $0x10,%esp
8010421e:	66 90                	xchg   %ax,%ax
  {
    
    if(p->state != UNUSED){
80104220:	8b 43 0c             	mov    0xc(%ebx),%eax
80104223:	85 c0                	test   %eax,%eax
80104225:	74 36                	je     8010425d <getprocinfo+0x5d>
      pid=p->pid;
      pI->ppid = p->parent!=0? p->parent->pid : 0;
80104227:	8b 53 14             	mov    0x14(%ebx),%edx
8010422a:	31 c0                	xor    %eax,%eax
      pid=p->pid;
8010422c:	8b 7b 10             	mov    0x10(%ebx),%edi
      pI->ppid = p->parent!=0? p->parent->pid : 0;
8010422f:	85 d2                	test   %edx,%edx
80104231:	74 03                	je     80104236 <getprocinfo+0x36>
80104233:	8b 42 10             	mov    0x10(%edx),%eax
80104236:	89 06                	mov    %eax,(%esi)
      pI->psize = p->sz;
80104238:	8b 13                	mov    (%ebx),%edx
      pI->numberContextSwitches=p->csnum;
      
     cprintf("%d      %d      %d    %d   %d \n", pid, pI->ppid, pI->psize, pI->numberContextSwitches,p->priority);
8010423a:	83 ec 08             	sub    $0x8,%esp
      pI->psize = p->sz;
8010423d:	89 56 04             	mov    %edx,0x4(%esi)
      pI->numberContextSwitches=p->csnum;
80104240:	8b 4b 20             	mov    0x20(%ebx),%ecx
80104243:	89 4e 08             	mov    %ecx,0x8(%esi)
     cprintf("%d      %d      %d    %d   %d \n", pid, pI->ppid, pI->psize, pI->numberContextSwitches,p->priority);
80104246:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
8010424c:	51                   	push   %ecx
8010424d:	52                   	push   %edx
8010424e:	50                   	push   %eax
8010424f:	57                   	push   %edi
80104250:	68 64 78 10 80       	push   $0x80107864
80104255:	e8 06 c4 ff ff       	call   80100660 <cprintf>
8010425a:	83 c4 20             	add    $0x20,%esp
  for(p=ptable.proc;p<&ptable.proc[NPROC];p++)
8010425d:	81 c3 98 00 00 00    	add    $0x98,%ebx
80104263:	81 fb 54 53 11 80    	cmp    $0x80115354,%ebx
80104269:	72 b5                	jb     80104220 <getprocinfo+0x20>
       
    }
    
  }
  release(&ptable.lock);
8010426b:	83 ec 0c             	sub    $0xc,%esp
8010426e:	68 20 2d 11 80       	push   $0x80112d20
80104273:	e8 38 04 00 00       	call   801046b0 <release>
   
  return 0;
}
80104278:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010427b:	31 c0                	xor    %eax,%eax
8010427d:	5b                   	pop    %ebx
8010427e:	5e                   	pop    %esi
8010427f:	5f                   	pop    %edi
80104280:	5d                   	pop    %ebp
80104281:	c3                   	ret    
80104282:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104290 <setprio>:

int 
setprio(int newPrio)
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	57                   	push   %edi
80104294:	56                   	push   %esi
80104295:	53                   	push   %ebx
  struct proc *p;

  acquire(&ptable.lock);
  for(p=ptable.proc;p<&ptable.proc[NPROC];p++)
80104296:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
8010429b:	83 ec 18             	sub    $0x18,%esp
8010429e:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&ptable.lock);
801042a1:	68 20 2d 11 80       	push   $0x80112d20
801042a6:	e8 45 03 00 00       	call   801045f0 <acquire>
801042ab:	83 c4 10             	add    $0x10,%esp
801042ae:	eb 0e                	jmp    801042be <setprio+0x2e>
  for(p=ptable.proc;p<&ptable.proc[NPROC];p++)
801042b0:	81 c3 98 00 00 00    	add    $0x98,%ebx
801042b6:	81 fb 54 53 11 80    	cmp    $0x80115354,%ebx
801042bc:	73 55                	jae    80104313 <setprio+0x83>
  {
    
    if(p->state != UNUSED){
801042be:	8b 43 0c             	mov    0xc(%ebx),%eax
801042c1:	85 c0                	test   %eax,%eax
801042c3:	74 eb                	je     801042b0 <setprio+0x20>
801042c5:	8d 73 70             	lea    0x70(%ebx),%esi
     
      cprintf("---prio of %s %d: %d  ?%d\n", p->name,p->pid, p->priority,p->setted);
801042c8:	83 ec 0c             	sub    $0xc,%esp
801042cb:	ff b3 84 00 00 00    	pushl  0x84(%ebx)
801042d1:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
801042d7:	ff 73 10             	pushl  0x10(%ebx)
801042da:	56                   	push   %esi
801042db:	68 3c 79 10 80       	push   $0x8010793c
801042e0:	e8 7b c3 ff ff       	call   80100660 <cprintf>
      //cprintf("oldprio of pre-arg: %d\n", p->priority);
     if(p->setted!=1){//default 
801042e5:	83 c4 20             	add    $0x20,%esp
801042e8:	83 bb 84 00 00 00 01 	cmpl   $0x1,0x84(%ebx)
801042ef:	74 bf                	je     801042b0 <setprio+0x20>
      p->priority = newPrio;
      p->setted=1;
       cprintf("prio of %s %d: %d\n", p->name,p->pid, p->priority);
801042f1:	57                   	push   %edi
801042f2:	ff 73 10             	pushl  0x10(%ebx)
801042f5:	56                   	push   %esi
801042f6:	68 57 79 10 80       	push   $0x80107957
      p->priority = newPrio;
801042fb:	89 bb 80 00 00 00    	mov    %edi,0x80(%ebx)
      p->setted=1;
80104301:	c7 83 84 00 00 00 01 	movl   $0x1,0x84(%ebx)
80104308:	00 00 00 
       cprintf("prio of %s %d: %d\n", p->name,p->pid, p->priority);
8010430b:	e8 50 c3 ff ff       	call   80100660 <cprintf>
       break;
80104310:	83 c4 10             	add    $0x10,%esp
     
    //  cprintf("proc %s priority changed ; new prio: %d\n",p->name,p->priority);
      
    }
  }
  release(&ptable.lock);
80104313:	83 ec 0c             	sub    $0xc,%esp
80104316:	68 20 2d 11 80       	push   $0x80112d20
8010431b:	e8 90 03 00 00       	call   801046b0 <release>

  
  return 0;

}
80104320:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104323:	31 c0                	xor    %eax,%eax
80104325:	5b                   	pop    %ebx
80104326:	5e                   	pop    %esi
80104327:	5f                   	pop    %edi
80104328:	5d                   	pop    %ebp
80104329:	c3                   	ret    
8010432a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104330 <getprio>:


int 
getprio(void)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	53                   	push   %ebx
80104334:	83 ec 10             	sub    $0x10,%esp
  asm volatile("sti");
80104337:	fb                   	sti    
  struct proc *p;
  sti();
  acquire(&ptable.lock);
80104338:	68 20 2d 11 80       	push   $0x80112d20
  int priority=0;
8010433d:	31 db                	xor    %ebx,%ebx
  acquire(&ptable.lock);
8010433f:	e8 ac 02 00 00       	call   801045f0 <acquire>
80104344:	83 c4 10             	add    $0x10,%esp

  for(p=ptable.proc;p<&ptable.proc[NPROC];p++)
80104347:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
8010434c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    if(p->state != UNUSED){
80104350:	8b 42 0c             	mov    0xc(%edx),%eax
80104353:	85 c0                	test   %eax,%eax
80104355:	74 06                	je     8010435d <getprio+0x2d>
    priority=p->priority;
80104357:	8b 9a 80 00 00 00    	mov    0x80(%edx),%ebx
  for(p=ptable.proc;p<&ptable.proc[NPROC];p++)
8010435d:	81 c2 98 00 00 00    	add    $0x98,%edx
80104363:	81 fa 54 53 11 80    	cmp    $0x80115354,%edx
80104369:	72 e5                	jb     80104350 <getprio+0x20>
    }
  }
  release(&ptable.lock);
8010436b:	83 ec 0c             	sub    $0xc,%esp
8010436e:	68 20 2d 11 80       	push   $0x80112d20
80104373:	e8 38 03 00 00       	call   801046b0 <release>

  return priority;
}
80104378:	89 d8                	mov    %ebx,%eax
8010437a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010437d:	c9                   	leave  
8010437e:	c3                   	ret    
8010437f:	90                   	nop

80104380 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	53                   	push   %ebx
80104384:	83 ec 0c             	sub    $0xc,%esp
80104387:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010438a:	68 ac 79 10 80       	push   $0x801079ac
8010438f:	8d 43 04             	lea    0x4(%ebx),%eax
80104392:	50                   	push   %eax
80104393:	e8 18 01 00 00       	call   801044b0 <initlock>
  lk->name = name;
80104398:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010439b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801043a1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801043a4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801043ab:	89 43 38             	mov    %eax,0x38(%ebx)
}
801043ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043b1:	c9                   	leave  
801043b2:	c3                   	ret    
801043b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043c0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	56                   	push   %esi
801043c4:	53                   	push   %ebx
801043c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043c8:	83 ec 0c             	sub    $0xc,%esp
801043cb:	8d 73 04             	lea    0x4(%ebx),%esi
801043ce:	56                   	push   %esi
801043cf:	e8 1c 02 00 00       	call   801045f0 <acquire>
  while (lk->locked) {
801043d4:	8b 13                	mov    (%ebx),%edx
801043d6:	83 c4 10             	add    $0x10,%esp
801043d9:	85 d2                	test   %edx,%edx
801043db:	74 16                	je     801043f3 <acquiresleep+0x33>
801043dd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801043e0:	83 ec 08             	sub    $0x8,%esp
801043e3:	56                   	push   %esi
801043e4:	53                   	push   %ebx
801043e5:	e8 06 fa ff ff       	call   80103df0 <sleep>
  while (lk->locked) {
801043ea:	8b 03                	mov    (%ebx),%eax
801043ec:	83 c4 10             	add    $0x10,%esp
801043ef:	85 c0                	test   %eax,%eax
801043f1:	75 ed                	jne    801043e0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801043f3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801043f9:	e8 02 f4 ff ff       	call   80103800 <myproc>
801043fe:	8b 40 10             	mov    0x10(%eax),%eax
80104401:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104404:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104407:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010440a:	5b                   	pop    %ebx
8010440b:	5e                   	pop    %esi
8010440c:	5d                   	pop    %ebp
  release(&lk->lk);
8010440d:	e9 9e 02 00 00       	jmp    801046b0 <release>
80104412:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104420 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	56                   	push   %esi
80104424:	53                   	push   %ebx
80104425:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104428:	83 ec 0c             	sub    $0xc,%esp
8010442b:	8d 73 04             	lea    0x4(%ebx),%esi
8010442e:	56                   	push   %esi
8010442f:	e8 bc 01 00 00       	call   801045f0 <acquire>
  lk->locked = 0;
80104434:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010443a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104441:	89 1c 24             	mov    %ebx,(%esp)
80104444:	e8 67 fb ff ff       	call   80103fb0 <wakeup>
  release(&lk->lk);
80104449:	89 75 08             	mov    %esi,0x8(%ebp)
8010444c:	83 c4 10             	add    $0x10,%esp
}
8010444f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104452:	5b                   	pop    %ebx
80104453:	5e                   	pop    %esi
80104454:	5d                   	pop    %ebp
  release(&lk->lk);
80104455:	e9 56 02 00 00       	jmp    801046b0 <release>
8010445a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104460 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	57                   	push   %edi
80104464:	56                   	push   %esi
80104465:	53                   	push   %ebx
80104466:	31 ff                	xor    %edi,%edi
80104468:	83 ec 18             	sub    $0x18,%esp
8010446b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010446e:	8d 73 04             	lea    0x4(%ebx),%esi
80104471:	56                   	push   %esi
80104472:	e8 79 01 00 00       	call   801045f0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104477:	8b 03                	mov    (%ebx),%eax
80104479:	83 c4 10             	add    $0x10,%esp
8010447c:	85 c0                	test   %eax,%eax
8010447e:	74 13                	je     80104493 <holdingsleep+0x33>
80104480:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104483:	e8 78 f3 ff ff       	call   80103800 <myproc>
80104488:	39 58 10             	cmp    %ebx,0x10(%eax)
8010448b:	0f 94 c0             	sete   %al
8010448e:	0f b6 c0             	movzbl %al,%eax
80104491:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104493:	83 ec 0c             	sub    $0xc,%esp
80104496:	56                   	push   %esi
80104497:	e8 14 02 00 00       	call   801046b0 <release>
  return r;
}
8010449c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010449f:	89 f8                	mov    %edi,%eax
801044a1:	5b                   	pop    %ebx
801044a2:	5e                   	pop    %esi
801044a3:	5f                   	pop    %edi
801044a4:	5d                   	pop    %ebp
801044a5:	c3                   	ret    
801044a6:	66 90                	xchg   %ax,%ax
801044a8:	66 90                	xchg   %ax,%ax
801044aa:	66 90                	xchg   %ax,%ax
801044ac:	66 90                	xchg   %ax,%ax
801044ae:	66 90                	xchg   %ax,%ax

801044b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801044b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801044b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801044bf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801044c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801044c9:	5d                   	pop    %ebp
801044ca:	c3                   	ret    
801044cb:	90                   	nop
801044cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801044d0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801044d1:	31 d2                	xor    %edx,%edx
{
801044d3:	89 e5                	mov    %esp,%ebp
801044d5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801044d6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801044d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801044dc:	83 e8 08             	sub    $0x8,%eax
801044df:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801044e0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801044e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801044ec:	77 1a                	ja     80104508 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801044ee:	8b 58 04             	mov    0x4(%eax),%ebx
801044f1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801044f4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801044f7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801044f9:	83 fa 0a             	cmp    $0xa,%edx
801044fc:	75 e2                	jne    801044e0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801044fe:	5b                   	pop    %ebx
801044ff:	5d                   	pop    %ebp
80104500:	c3                   	ret    
80104501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104508:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010450b:	83 c1 28             	add    $0x28,%ecx
8010450e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104510:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104516:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104519:	39 c1                	cmp    %eax,%ecx
8010451b:	75 f3                	jne    80104510 <getcallerpcs+0x40>
}
8010451d:	5b                   	pop    %ebx
8010451e:	5d                   	pop    %ebp
8010451f:	c3                   	ret    

80104520 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	53                   	push   %ebx
80104524:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104527:	9c                   	pushf  
80104528:	5b                   	pop    %ebx
  asm volatile("cli");
80104529:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010452a:	e8 31 f2 ff ff       	call   80103760 <mycpu>
8010452f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104535:	85 c0                	test   %eax,%eax
80104537:	75 11                	jne    8010454a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104539:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010453f:	e8 1c f2 ff ff       	call   80103760 <mycpu>
80104544:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010454a:	e8 11 f2 ff ff       	call   80103760 <mycpu>
8010454f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104556:	83 c4 04             	add    $0x4,%esp
80104559:	5b                   	pop    %ebx
8010455a:	5d                   	pop    %ebp
8010455b:	c3                   	ret    
8010455c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104560 <popcli>:

void
popcli(void)
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104566:	9c                   	pushf  
80104567:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104568:	f6 c4 02             	test   $0x2,%ah
8010456b:	75 35                	jne    801045a2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010456d:	e8 ee f1 ff ff       	call   80103760 <mycpu>
80104572:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104579:	78 34                	js     801045af <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010457b:	e8 e0 f1 ff ff       	call   80103760 <mycpu>
80104580:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104586:	85 d2                	test   %edx,%edx
80104588:	74 06                	je     80104590 <popcli+0x30>
    sti();
}
8010458a:	c9                   	leave  
8010458b:	c3                   	ret    
8010458c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104590:	e8 cb f1 ff ff       	call   80103760 <mycpu>
80104595:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010459b:	85 c0                	test   %eax,%eax
8010459d:	74 eb                	je     8010458a <popcli+0x2a>
  asm volatile("sti");
8010459f:	fb                   	sti    
}
801045a0:	c9                   	leave  
801045a1:	c3                   	ret    
    panic("popcli - interruptible");
801045a2:	83 ec 0c             	sub    $0xc,%esp
801045a5:	68 b7 79 10 80       	push   $0x801079b7
801045aa:	e8 e1 bd ff ff       	call   80100390 <panic>
    panic("popcli");
801045af:	83 ec 0c             	sub    $0xc,%esp
801045b2:	68 ce 79 10 80       	push   $0x801079ce
801045b7:	e8 d4 bd ff ff       	call   80100390 <panic>
801045bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045c0 <holding>:
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	56                   	push   %esi
801045c4:	53                   	push   %ebx
801045c5:	8b 75 08             	mov    0x8(%ebp),%esi
801045c8:	31 db                	xor    %ebx,%ebx
  pushcli();
801045ca:	e8 51 ff ff ff       	call   80104520 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801045cf:	8b 06                	mov    (%esi),%eax
801045d1:	85 c0                	test   %eax,%eax
801045d3:	74 10                	je     801045e5 <holding+0x25>
801045d5:	8b 5e 08             	mov    0x8(%esi),%ebx
801045d8:	e8 83 f1 ff ff       	call   80103760 <mycpu>
801045dd:	39 c3                	cmp    %eax,%ebx
801045df:	0f 94 c3             	sete   %bl
801045e2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801045e5:	e8 76 ff ff ff       	call   80104560 <popcli>
}
801045ea:	89 d8                	mov    %ebx,%eax
801045ec:	5b                   	pop    %ebx
801045ed:	5e                   	pop    %esi
801045ee:	5d                   	pop    %ebp
801045ef:	c3                   	ret    

801045f0 <acquire>:
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	56                   	push   %esi
801045f4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801045f5:	e8 26 ff ff ff       	call   80104520 <pushcli>
  if(holding(lk))
801045fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045fd:	83 ec 0c             	sub    $0xc,%esp
80104600:	53                   	push   %ebx
80104601:	e8 ba ff ff ff       	call   801045c0 <holding>
80104606:	83 c4 10             	add    $0x10,%esp
80104609:	85 c0                	test   %eax,%eax
8010460b:	0f 85 83 00 00 00    	jne    80104694 <acquire+0xa4>
80104611:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104613:	ba 01 00 00 00       	mov    $0x1,%edx
80104618:	eb 09                	jmp    80104623 <acquire+0x33>
8010461a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104620:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104623:	89 d0                	mov    %edx,%eax
80104625:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104628:	85 c0                	test   %eax,%eax
8010462a:	75 f4                	jne    80104620 <acquire+0x30>
  __sync_synchronize();
8010462c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104631:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104634:	e8 27 f1 ff ff       	call   80103760 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104639:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010463c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010463f:	89 e8                	mov    %ebp,%eax
80104641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104648:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010464e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104654:	77 1a                	ja     80104670 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104656:	8b 48 04             	mov    0x4(%eax),%ecx
80104659:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010465c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010465f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104661:	83 fe 0a             	cmp    $0xa,%esi
80104664:	75 e2                	jne    80104648 <acquire+0x58>
}
80104666:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104669:	5b                   	pop    %ebx
8010466a:	5e                   	pop    %esi
8010466b:	5d                   	pop    %ebp
8010466c:	c3                   	ret    
8010466d:	8d 76 00             	lea    0x0(%esi),%esi
80104670:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104673:	83 c2 28             	add    $0x28,%edx
80104676:	8d 76 00             	lea    0x0(%esi),%esi
80104679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104680:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104686:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104689:	39 d0                	cmp    %edx,%eax
8010468b:	75 f3                	jne    80104680 <acquire+0x90>
}
8010468d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104690:	5b                   	pop    %ebx
80104691:	5e                   	pop    %esi
80104692:	5d                   	pop    %ebp
80104693:	c3                   	ret    
    panic("acquire");
80104694:	83 ec 0c             	sub    $0xc,%esp
80104697:	68 d5 79 10 80       	push   $0x801079d5
8010469c:	e8 ef bc ff ff       	call   80100390 <panic>
801046a1:	eb 0d                	jmp    801046b0 <release>
801046a3:	90                   	nop
801046a4:	90                   	nop
801046a5:	90                   	nop
801046a6:	90                   	nop
801046a7:	90                   	nop
801046a8:	90                   	nop
801046a9:	90                   	nop
801046aa:	90                   	nop
801046ab:	90                   	nop
801046ac:	90                   	nop
801046ad:	90                   	nop
801046ae:	90                   	nop
801046af:	90                   	nop

801046b0 <release>:
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	53                   	push   %ebx
801046b4:	83 ec 10             	sub    $0x10,%esp
801046b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801046ba:	53                   	push   %ebx
801046bb:	e8 00 ff ff ff       	call   801045c0 <holding>
801046c0:	83 c4 10             	add    $0x10,%esp
801046c3:	85 c0                	test   %eax,%eax
801046c5:	74 22                	je     801046e9 <release+0x39>
  lk->pcs[0] = 0;
801046c7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801046ce:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801046d5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801046da:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801046e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046e3:	c9                   	leave  
  popcli();
801046e4:	e9 77 fe ff ff       	jmp    80104560 <popcli>
    panic("release");
801046e9:	83 ec 0c             	sub    $0xc,%esp
801046ec:	68 dd 79 10 80       	push   $0x801079dd
801046f1:	e8 9a bc ff ff       	call   80100390 <panic>
801046f6:	66 90                	xchg   %ax,%ax
801046f8:	66 90                	xchg   %ax,%ax
801046fa:	66 90                	xchg   %ax,%ax
801046fc:	66 90                	xchg   %ax,%ax
801046fe:	66 90                	xchg   %ax,%ax

80104700 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	57                   	push   %edi
80104704:	53                   	push   %ebx
80104705:	8b 55 08             	mov    0x8(%ebp),%edx
80104708:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010470b:	f6 c2 03             	test   $0x3,%dl
8010470e:	75 05                	jne    80104715 <memset+0x15>
80104710:	f6 c1 03             	test   $0x3,%cl
80104713:	74 13                	je     80104728 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104715:	89 d7                	mov    %edx,%edi
80104717:	8b 45 0c             	mov    0xc(%ebp),%eax
8010471a:	fc                   	cld    
8010471b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010471d:	5b                   	pop    %ebx
8010471e:	89 d0                	mov    %edx,%eax
80104720:	5f                   	pop    %edi
80104721:	5d                   	pop    %ebp
80104722:	c3                   	ret    
80104723:	90                   	nop
80104724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104728:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010472c:	c1 e9 02             	shr    $0x2,%ecx
8010472f:	89 f8                	mov    %edi,%eax
80104731:	89 fb                	mov    %edi,%ebx
80104733:	c1 e0 18             	shl    $0x18,%eax
80104736:	c1 e3 10             	shl    $0x10,%ebx
80104739:	09 d8                	or     %ebx,%eax
8010473b:	09 f8                	or     %edi,%eax
8010473d:	c1 e7 08             	shl    $0x8,%edi
80104740:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104742:	89 d7                	mov    %edx,%edi
80104744:	fc                   	cld    
80104745:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104747:	5b                   	pop    %ebx
80104748:	89 d0                	mov    %edx,%eax
8010474a:	5f                   	pop    %edi
8010474b:	5d                   	pop    %ebp
8010474c:	c3                   	ret    
8010474d:	8d 76 00             	lea    0x0(%esi),%esi

80104750 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	57                   	push   %edi
80104754:	56                   	push   %esi
80104755:	53                   	push   %ebx
80104756:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104759:	8b 75 08             	mov    0x8(%ebp),%esi
8010475c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010475f:	85 db                	test   %ebx,%ebx
80104761:	74 29                	je     8010478c <memcmp+0x3c>
    if(*s1 != *s2)
80104763:	0f b6 16             	movzbl (%esi),%edx
80104766:	0f b6 0f             	movzbl (%edi),%ecx
80104769:	38 d1                	cmp    %dl,%cl
8010476b:	75 2b                	jne    80104798 <memcmp+0x48>
8010476d:	b8 01 00 00 00       	mov    $0x1,%eax
80104772:	eb 14                	jmp    80104788 <memcmp+0x38>
80104774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104778:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010477c:	83 c0 01             	add    $0x1,%eax
8010477f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104784:	38 ca                	cmp    %cl,%dl
80104786:	75 10                	jne    80104798 <memcmp+0x48>
  while(n-- > 0){
80104788:	39 d8                	cmp    %ebx,%eax
8010478a:	75 ec                	jne    80104778 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010478c:	5b                   	pop    %ebx
  return 0;
8010478d:	31 c0                	xor    %eax,%eax
}
8010478f:	5e                   	pop    %esi
80104790:	5f                   	pop    %edi
80104791:	5d                   	pop    %ebp
80104792:	c3                   	ret    
80104793:	90                   	nop
80104794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104798:	0f b6 c2             	movzbl %dl,%eax
}
8010479b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010479c:	29 c8                	sub    %ecx,%eax
}
8010479e:	5e                   	pop    %esi
8010479f:	5f                   	pop    %edi
801047a0:	5d                   	pop    %ebp
801047a1:	c3                   	ret    
801047a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047b0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	56                   	push   %esi
801047b4:	53                   	push   %ebx
801047b5:	8b 45 08             	mov    0x8(%ebp),%eax
801047b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801047bb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801047be:	39 c3                	cmp    %eax,%ebx
801047c0:	73 26                	jae    801047e8 <memmove+0x38>
801047c2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801047c5:	39 c8                	cmp    %ecx,%eax
801047c7:	73 1f                	jae    801047e8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801047c9:	85 f6                	test   %esi,%esi
801047cb:	8d 56 ff             	lea    -0x1(%esi),%edx
801047ce:	74 0f                	je     801047df <memmove+0x2f>
      *--d = *--s;
801047d0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801047d4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801047d7:	83 ea 01             	sub    $0x1,%edx
801047da:	83 fa ff             	cmp    $0xffffffff,%edx
801047dd:	75 f1                	jne    801047d0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801047df:	5b                   	pop    %ebx
801047e0:	5e                   	pop    %esi
801047e1:	5d                   	pop    %ebp
801047e2:	c3                   	ret    
801047e3:	90                   	nop
801047e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801047e8:	31 d2                	xor    %edx,%edx
801047ea:	85 f6                	test   %esi,%esi
801047ec:	74 f1                	je     801047df <memmove+0x2f>
801047ee:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801047f0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801047f4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801047f7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801047fa:	39 d6                	cmp    %edx,%esi
801047fc:	75 f2                	jne    801047f0 <memmove+0x40>
}
801047fe:	5b                   	pop    %ebx
801047ff:	5e                   	pop    %esi
80104800:	5d                   	pop    %ebp
80104801:	c3                   	ret    
80104802:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104810 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104813:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104814:	eb 9a                	jmp    801047b0 <memmove>
80104816:	8d 76 00             	lea    0x0(%esi),%esi
80104819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104820 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	57                   	push   %edi
80104824:	56                   	push   %esi
80104825:	8b 7d 10             	mov    0x10(%ebp),%edi
80104828:	53                   	push   %ebx
80104829:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010482c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010482f:	85 ff                	test   %edi,%edi
80104831:	74 2f                	je     80104862 <strncmp+0x42>
80104833:	0f b6 01             	movzbl (%ecx),%eax
80104836:	0f b6 1e             	movzbl (%esi),%ebx
80104839:	84 c0                	test   %al,%al
8010483b:	74 37                	je     80104874 <strncmp+0x54>
8010483d:	38 c3                	cmp    %al,%bl
8010483f:	75 33                	jne    80104874 <strncmp+0x54>
80104841:	01 f7                	add    %esi,%edi
80104843:	eb 13                	jmp    80104858 <strncmp+0x38>
80104845:	8d 76 00             	lea    0x0(%esi),%esi
80104848:	0f b6 01             	movzbl (%ecx),%eax
8010484b:	84 c0                	test   %al,%al
8010484d:	74 21                	je     80104870 <strncmp+0x50>
8010484f:	0f b6 1a             	movzbl (%edx),%ebx
80104852:	89 d6                	mov    %edx,%esi
80104854:	38 d8                	cmp    %bl,%al
80104856:	75 1c                	jne    80104874 <strncmp+0x54>
    n--, p++, q++;
80104858:	8d 56 01             	lea    0x1(%esi),%edx
8010485b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010485e:	39 fa                	cmp    %edi,%edx
80104860:	75 e6                	jne    80104848 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104862:	5b                   	pop    %ebx
    return 0;
80104863:	31 c0                	xor    %eax,%eax
}
80104865:	5e                   	pop    %esi
80104866:	5f                   	pop    %edi
80104867:	5d                   	pop    %ebp
80104868:	c3                   	ret    
80104869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104870:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104874:	29 d8                	sub    %ebx,%eax
}
80104876:	5b                   	pop    %ebx
80104877:	5e                   	pop    %esi
80104878:	5f                   	pop    %edi
80104879:	5d                   	pop    %ebp
8010487a:	c3                   	ret    
8010487b:	90                   	nop
8010487c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104880 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	56                   	push   %esi
80104884:	53                   	push   %ebx
80104885:	8b 45 08             	mov    0x8(%ebp),%eax
80104888:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010488b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010488e:	89 c2                	mov    %eax,%edx
80104890:	eb 19                	jmp    801048ab <strncpy+0x2b>
80104892:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104898:	83 c3 01             	add    $0x1,%ebx
8010489b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010489f:	83 c2 01             	add    $0x1,%edx
801048a2:	84 c9                	test   %cl,%cl
801048a4:	88 4a ff             	mov    %cl,-0x1(%edx)
801048a7:	74 09                	je     801048b2 <strncpy+0x32>
801048a9:	89 f1                	mov    %esi,%ecx
801048ab:	85 c9                	test   %ecx,%ecx
801048ad:	8d 71 ff             	lea    -0x1(%ecx),%esi
801048b0:	7f e6                	jg     80104898 <strncpy+0x18>
    ;
  while(n-- > 0)
801048b2:	31 c9                	xor    %ecx,%ecx
801048b4:	85 f6                	test   %esi,%esi
801048b6:	7e 17                	jle    801048cf <strncpy+0x4f>
801048b8:	90                   	nop
801048b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801048c0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801048c4:	89 f3                	mov    %esi,%ebx
801048c6:	83 c1 01             	add    $0x1,%ecx
801048c9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801048cb:	85 db                	test   %ebx,%ebx
801048cd:	7f f1                	jg     801048c0 <strncpy+0x40>
  return os;
}
801048cf:	5b                   	pop    %ebx
801048d0:	5e                   	pop    %esi
801048d1:	5d                   	pop    %ebp
801048d2:	c3                   	ret    
801048d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048e0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	53                   	push   %ebx
801048e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801048e8:	8b 45 08             	mov    0x8(%ebp),%eax
801048eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801048ee:	85 c9                	test   %ecx,%ecx
801048f0:	7e 26                	jle    80104918 <safestrcpy+0x38>
801048f2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801048f6:	89 c1                	mov    %eax,%ecx
801048f8:	eb 17                	jmp    80104911 <safestrcpy+0x31>
801048fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104900:	83 c2 01             	add    $0x1,%edx
80104903:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104907:	83 c1 01             	add    $0x1,%ecx
8010490a:	84 db                	test   %bl,%bl
8010490c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010490f:	74 04                	je     80104915 <safestrcpy+0x35>
80104911:	39 f2                	cmp    %esi,%edx
80104913:	75 eb                	jne    80104900 <safestrcpy+0x20>
    ;
  *s = 0;
80104915:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104918:	5b                   	pop    %ebx
80104919:	5e                   	pop    %esi
8010491a:	5d                   	pop    %ebp
8010491b:	c3                   	ret    
8010491c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104920 <strlen>:

int
strlen(const char *s)
{
80104920:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104921:	31 c0                	xor    %eax,%eax
{
80104923:	89 e5                	mov    %esp,%ebp
80104925:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104928:	80 3a 00             	cmpb   $0x0,(%edx)
8010492b:	74 0c                	je     80104939 <strlen+0x19>
8010492d:	8d 76 00             	lea    0x0(%esi),%esi
80104930:	83 c0 01             	add    $0x1,%eax
80104933:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104937:	75 f7                	jne    80104930 <strlen+0x10>
    ;
  return n;
}
80104939:	5d                   	pop    %ebp
8010493a:	c3                   	ret    

8010493b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010493b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010493f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104943:	55                   	push   %ebp
  pushl %ebx
80104944:	53                   	push   %ebx
  pushl %esi
80104945:	56                   	push   %esi
  pushl %edi
80104946:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104947:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104949:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010494b:	5f                   	pop    %edi
  popl %esi
8010494c:	5e                   	pop    %esi
  popl %ebx
8010494d:	5b                   	pop    %ebx
  popl %ebp
8010494e:	5d                   	pop    %ebp
  ret
8010494f:	c3                   	ret    

80104950 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	53                   	push   %ebx
80104954:	83 ec 04             	sub    $0x4,%esp
80104957:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010495a:	e8 a1 ee ff ff       	call   80103800 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010495f:	8b 00                	mov    (%eax),%eax
80104961:	39 d8                	cmp    %ebx,%eax
80104963:	76 1b                	jbe    80104980 <fetchint+0x30>
80104965:	8d 53 04             	lea    0x4(%ebx),%edx
80104968:	39 d0                	cmp    %edx,%eax
8010496a:	72 14                	jb     80104980 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010496c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010496f:	8b 13                	mov    (%ebx),%edx
80104971:	89 10                	mov    %edx,(%eax)
  return 0;
80104973:	31 c0                	xor    %eax,%eax
}
80104975:	83 c4 04             	add    $0x4,%esp
80104978:	5b                   	pop    %ebx
80104979:	5d                   	pop    %ebp
8010497a:	c3                   	ret    
8010497b:	90                   	nop
8010497c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104985:	eb ee                	jmp    80104975 <fetchint+0x25>
80104987:	89 f6                	mov    %esi,%esi
80104989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104990 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	53                   	push   %ebx
80104994:	83 ec 04             	sub    $0x4,%esp
80104997:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010499a:	e8 61 ee ff ff       	call   80103800 <myproc>

  if(addr >= curproc->sz)
8010499f:	39 18                	cmp    %ebx,(%eax)
801049a1:	76 29                	jbe    801049cc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801049a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801049a6:	89 da                	mov    %ebx,%edx
801049a8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801049aa:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801049ac:	39 c3                	cmp    %eax,%ebx
801049ae:	73 1c                	jae    801049cc <fetchstr+0x3c>
    if(*s == 0)
801049b0:	80 3b 00             	cmpb   $0x0,(%ebx)
801049b3:	75 10                	jne    801049c5 <fetchstr+0x35>
801049b5:	eb 39                	jmp    801049f0 <fetchstr+0x60>
801049b7:	89 f6                	mov    %esi,%esi
801049b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801049c0:	80 3a 00             	cmpb   $0x0,(%edx)
801049c3:	74 1b                	je     801049e0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801049c5:	83 c2 01             	add    $0x1,%edx
801049c8:	39 d0                	cmp    %edx,%eax
801049ca:	77 f4                	ja     801049c0 <fetchstr+0x30>
    return -1;
801049cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801049d1:	83 c4 04             	add    $0x4,%esp
801049d4:	5b                   	pop    %ebx
801049d5:	5d                   	pop    %ebp
801049d6:	c3                   	ret    
801049d7:	89 f6                	mov    %esi,%esi
801049d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801049e0:	83 c4 04             	add    $0x4,%esp
801049e3:	89 d0                	mov    %edx,%eax
801049e5:	29 d8                	sub    %ebx,%eax
801049e7:	5b                   	pop    %ebx
801049e8:	5d                   	pop    %ebp
801049e9:	c3                   	ret    
801049ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
801049f0:	31 c0                	xor    %eax,%eax
      return s - *pp;
801049f2:	eb dd                	jmp    801049d1 <fetchstr+0x41>
801049f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a00 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	56                   	push   %esi
80104a04:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a05:	e8 f6 ed ff ff       	call   80103800 <myproc>
80104a0a:	8b 40 18             	mov    0x18(%eax),%eax
80104a0d:	8b 55 08             	mov    0x8(%ebp),%edx
80104a10:	8b 40 44             	mov    0x44(%eax),%eax
80104a13:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a16:	e8 e5 ed ff ff       	call   80103800 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a1b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a1d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a20:	39 c6                	cmp    %eax,%esi
80104a22:	73 1c                	jae    80104a40 <argint+0x40>
80104a24:	8d 53 08             	lea    0x8(%ebx),%edx
80104a27:	39 d0                	cmp    %edx,%eax
80104a29:	72 15                	jb     80104a40 <argint+0x40>
  *ip = *(int*)(addr);
80104a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a2e:	8b 53 04             	mov    0x4(%ebx),%edx
80104a31:	89 10                	mov    %edx,(%eax)
  return 0;
80104a33:	31 c0                	xor    %eax,%eax
}
80104a35:	5b                   	pop    %ebx
80104a36:	5e                   	pop    %esi
80104a37:	5d                   	pop    %ebp
80104a38:	c3                   	ret    
80104a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a45:	eb ee                	jmp    80104a35 <argint+0x35>
80104a47:	89 f6                	mov    %esi,%esi
80104a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a50 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	53                   	push   %ebx
80104a55:	83 ec 10             	sub    $0x10,%esp
80104a58:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104a5b:	e8 a0 ed ff ff       	call   80103800 <myproc>
80104a60:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104a62:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a65:	83 ec 08             	sub    $0x8,%esp
80104a68:	50                   	push   %eax
80104a69:	ff 75 08             	pushl  0x8(%ebp)
80104a6c:	e8 8f ff ff ff       	call   80104a00 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a71:	83 c4 10             	add    $0x10,%esp
80104a74:	85 c0                	test   %eax,%eax
80104a76:	78 28                	js     80104aa0 <argptr+0x50>
80104a78:	85 db                	test   %ebx,%ebx
80104a7a:	78 24                	js     80104aa0 <argptr+0x50>
80104a7c:	8b 16                	mov    (%esi),%edx
80104a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a81:	39 c2                	cmp    %eax,%edx
80104a83:	76 1b                	jbe    80104aa0 <argptr+0x50>
80104a85:	01 c3                	add    %eax,%ebx
80104a87:	39 da                	cmp    %ebx,%edx
80104a89:	72 15                	jb     80104aa0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a8e:	89 02                	mov    %eax,(%edx)
  return 0;
80104a90:	31 c0                	xor    %eax,%eax
}
80104a92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a95:	5b                   	pop    %ebx
80104a96:	5e                   	pop    %esi
80104a97:	5d                   	pop    %ebp
80104a98:	c3                   	ret    
80104a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104aa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104aa5:	eb eb                	jmp    80104a92 <argptr+0x42>
80104aa7:	89 f6                	mov    %esi,%esi
80104aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ab0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104ab6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ab9:	50                   	push   %eax
80104aba:	ff 75 08             	pushl  0x8(%ebp)
80104abd:	e8 3e ff ff ff       	call   80104a00 <argint>
80104ac2:	83 c4 10             	add    $0x10,%esp
80104ac5:	85 c0                	test   %eax,%eax
80104ac7:	78 17                	js     80104ae0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104ac9:	83 ec 08             	sub    $0x8,%esp
80104acc:	ff 75 0c             	pushl  0xc(%ebp)
80104acf:	ff 75 f4             	pushl  -0xc(%ebp)
80104ad2:	e8 b9 fe ff ff       	call   80104990 <fetchstr>
80104ad7:	83 c4 10             	add    $0x10,%esp
}
80104ada:	c9                   	leave  
80104adb:	c3                   	ret    
80104adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ae0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ae5:	c9                   	leave  
80104ae6:	c3                   	ret    
80104ae7:	89 f6                	mov    %esi,%esi
80104ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104af0 <syscall>:
[SYS_getprio] sys_getprio,
};

void
syscall(void)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	53                   	push   %ebx
80104af4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104af7:	e8 04 ed ff ff       	call   80103800 <myproc>
80104afc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104afe:	8b 40 18             	mov    0x18(%eax),%eax
80104b01:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104b04:	8d 50 ff             	lea    -0x1(%eax),%edx
80104b07:	83 fa 1b             	cmp    $0x1b,%edx
80104b0a:	77 1c                	ja     80104b28 <syscall+0x38>
80104b0c:	8b 14 85 20 7a 10 80 	mov    -0x7fef85e0(,%eax,4),%edx
80104b13:	85 d2                	test   %edx,%edx
80104b15:	74 11                	je     80104b28 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104b17:	ff d2                	call   *%edx
80104b19:	8b 53 18             	mov    0x18(%ebx),%edx
80104b1c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104b1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b22:	c9                   	leave  
80104b23:	c3                   	ret    
80104b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104b28:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104b29:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104b2c:	50                   	push   %eax
80104b2d:	ff 73 10             	pushl  0x10(%ebx)
80104b30:	68 e5 79 10 80       	push   $0x801079e5
80104b35:	e8 26 bb ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104b3a:	8b 43 18             	mov    0x18(%ebx),%eax
80104b3d:	83 c4 10             	add    $0x10,%esp
80104b40:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104b47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b4a:	c9                   	leave  
80104b4b:	c3                   	ret    
80104b4c:	66 90                	xchg   %ax,%ax
80104b4e:	66 90                	xchg   %ax,%ax

80104b50 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	57                   	push   %edi
80104b54:	56                   	push   %esi
80104b55:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b56:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104b59:	83 ec 44             	sub    $0x44,%esp
80104b5c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104b5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104b62:	56                   	push   %esi
80104b63:	50                   	push   %eax
{
80104b64:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104b67:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104b6a:	e8 a1 d3 ff ff       	call   80101f10 <nameiparent>
80104b6f:	83 c4 10             	add    $0x10,%esp
80104b72:	85 c0                	test   %eax,%eax
80104b74:	0f 84 46 01 00 00    	je     80104cc0 <create+0x170>
    return 0;
  ilock(dp);
80104b7a:	83 ec 0c             	sub    $0xc,%esp
80104b7d:	89 c3                	mov    %eax,%ebx
80104b7f:	50                   	push   %eax
80104b80:	e8 0b cb ff ff       	call   80101690 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104b85:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104b88:	83 c4 0c             	add    $0xc,%esp
80104b8b:	50                   	push   %eax
80104b8c:	56                   	push   %esi
80104b8d:	53                   	push   %ebx
80104b8e:	e8 2d d0 ff ff       	call   80101bc0 <dirlookup>
80104b93:	83 c4 10             	add    $0x10,%esp
80104b96:	85 c0                	test   %eax,%eax
80104b98:	89 c7                	mov    %eax,%edi
80104b9a:	74 34                	je     80104bd0 <create+0x80>
    iunlockput(dp);
80104b9c:	83 ec 0c             	sub    $0xc,%esp
80104b9f:	53                   	push   %ebx
80104ba0:	e8 7b cd ff ff       	call   80101920 <iunlockput>
    ilock(ip);
80104ba5:	89 3c 24             	mov    %edi,(%esp)
80104ba8:	e8 e3 ca ff ff       	call   80101690 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104bad:	83 c4 10             	add    $0x10,%esp
80104bb0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104bb5:	0f 85 95 00 00 00    	jne    80104c50 <create+0x100>
80104bbb:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104bc0:	0f 85 8a 00 00 00    	jne    80104c50 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104bc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bc9:	89 f8                	mov    %edi,%eax
80104bcb:	5b                   	pop    %ebx
80104bcc:	5e                   	pop    %esi
80104bcd:	5f                   	pop    %edi
80104bce:	5d                   	pop    %ebp
80104bcf:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104bd0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104bd4:	83 ec 08             	sub    $0x8,%esp
80104bd7:	50                   	push   %eax
80104bd8:	ff 33                	pushl  (%ebx)
80104bda:	e8 41 c9 ff ff       	call   80101520 <ialloc>
80104bdf:	83 c4 10             	add    $0x10,%esp
80104be2:	85 c0                	test   %eax,%eax
80104be4:	89 c7                	mov    %eax,%edi
80104be6:	0f 84 e8 00 00 00    	je     80104cd4 <create+0x184>
  ilock(ip);
80104bec:	83 ec 0c             	sub    $0xc,%esp
80104bef:	50                   	push   %eax
80104bf0:	e8 9b ca ff ff       	call   80101690 <ilock>
  ip->major = major;
80104bf5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104bf9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104bfd:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104c01:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104c05:	b8 01 00 00 00       	mov    $0x1,%eax
80104c0a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104c0e:	89 3c 24             	mov    %edi,(%esp)
80104c11:	e8 ca c9 ff ff       	call   801015e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104c16:	83 c4 10             	add    $0x10,%esp
80104c19:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104c1e:	74 50                	je     80104c70 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104c20:	83 ec 04             	sub    $0x4,%esp
80104c23:	ff 77 04             	pushl  0x4(%edi)
80104c26:	56                   	push   %esi
80104c27:	53                   	push   %ebx
80104c28:	e8 03 d2 ff ff       	call   80101e30 <dirlink>
80104c2d:	83 c4 10             	add    $0x10,%esp
80104c30:	85 c0                	test   %eax,%eax
80104c32:	0f 88 8f 00 00 00    	js     80104cc7 <create+0x177>
  iunlockput(dp);
80104c38:	83 ec 0c             	sub    $0xc,%esp
80104c3b:	53                   	push   %ebx
80104c3c:	e8 df cc ff ff       	call   80101920 <iunlockput>
  return ip;
80104c41:	83 c4 10             	add    $0x10,%esp
}
80104c44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c47:	89 f8                	mov    %edi,%eax
80104c49:	5b                   	pop    %ebx
80104c4a:	5e                   	pop    %esi
80104c4b:	5f                   	pop    %edi
80104c4c:	5d                   	pop    %ebp
80104c4d:	c3                   	ret    
80104c4e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104c50:	83 ec 0c             	sub    $0xc,%esp
80104c53:	57                   	push   %edi
    return 0;
80104c54:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104c56:	e8 c5 cc ff ff       	call   80101920 <iunlockput>
    return 0;
80104c5b:	83 c4 10             	add    $0x10,%esp
}
80104c5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c61:	89 f8                	mov    %edi,%eax
80104c63:	5b                   	pop    %ebx
80104c64:	5e                   	pop    %esi
80104c65:	5f                   	pop    %edi
80104c66:	5d                   	pop    %ebp
80104c67:	c3                   	ret    
80104c68:	90                   	nop
80104c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104c70:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104c75:	83 ec 0c             	sub    $0xc,%esp
80104c78:	53                   	push   %ebx
80104c79:	e8 62 c9 ff ff       	call   801015e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c7e:	83 c4 0c             	add    $0xc,%esp
80104c81:	ff 77 04             	pushl  0x4(%edi)
80104c84:	68 b0 7a 10 80       	push   $0x80107ab0
80104c89:	57                   	push   %edi
80104c8a:	e8 a1 d1 ff ff       	call   80101e30 <dirlink>
80104c8f:	83 c4 10             	add    $0x10,%esp
80104c92:	85 c0                	test   %eax,%eax
80104c94:	78 1c                	js     80104cb2 <create+0x162>
80104c96:	83 ec 04             	sub    $0x4,%esp
80104c99:	ff 73 04             	pushl  0x4(%ebx)
80104c9c:	68 af 7a 10 80       	push   $0x80107aaf
80104ca1:	57                   	push   %edi
80104ca2:	e8 89 d1 ff ff       	call   80101e30 <dirlink>
80104ca7:	83 c4 10             	add    $0x10,%esp
80104caa:	85 c0                	test   %eax,%eax
80104cac:	0f 89 6e ff ff ff    	jns    80104c20 <create+0xd0>
      panic("create dots");
80104cb2:	83 ec 0c             	sub    $0xc,%esp
80104cb5:	68 a3 7a 10 80       	push   $0x80107aa3
80104cba:	e8 d1 b6 ff ff       	call   80100390 <panic>
80104cbf:	90                   	nop
    return 0;
80104cc0:	31 ff                	xor    %edi,%edi
80104cc2:	e9 ff fe ff ff       	jmp    80104bc6 <create+0x76>
    panic("create: dirlink");
80104cc7:	83 ec 0c             	sub    $0xc,%esp
80104cca:	68 b2 7a 10 80       	push   $0x80107ab2
80104ccf:	e8 bc b6 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104cd4:	83 ec 0c             	sub    $0xc,%esp
80104cd7:	68 94 7a 10 80       	push   $0x80107a94
80104cdc:	e8 af b6 ff ff       	call   80100390 <panic>
80104ce1:	eb 0d                	jmp    80104cf0 <argfd.constprop.0>
80104ce3:	90                   	nop
80104ce4:	90                   	nop
80104ce5:	90                   	nop
80104ce6:	90                   	nop
80104ce7:	90                   	nop
80104ce8:	90                   	nop
80104ce9:	90                   	nop
80104cea:	90                   	nop
80104ceb:	90                   	nop
80104cec:	90                   	nop
80104ced:	90                   	nop
80104cee:	90                   	nop
80104cef:	90                   	nop

80104cf0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	56                   	push   %esi
80104cf4:	53                   	push   %ebx
80104cf5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104cf7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104cfa:	89 d6                	mov    %edx,%esi
80104cfc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104cff:	50                   	push   %eax
80104d00:	6a 00                	push   $0x0
80104d02:	e8 f9 fc ff ff       	call   80104a00 <argint>
80104d07:	83 c4 10             	add    $0x10,%esp
80104d0a:	85 c0                	test   %eax,%eax
80104d0c:	78 2a                	js     80104d38 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d0e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d12:	77 24                	ja     80104d38 <argfd.constprop.0+0x48>
80104d14:	e8 e7 ea ff ff       	call   80103800 <myproc>
80104d19:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d1c:	8b 44 90 2c          	mov    0x2c(%eax,%edx,4),%eax
80104d20:	85 c0                	test   %eax,%eax
80104d22:	74 14                	je     80104d38 <argfd.constprop.0+0x48>
  if(pfd)
80104d24:	85 db                	test   %ebx,%ebx
80104d26:	74 02                	je     80104d2a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104d28:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104d2a:	89 06                	mov    %eax,(%esi)
  return 0;
80104d2c:	31 c0                	xor    %eax,%eax
}
80104d2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d31:	5b                   	pop    %ebx
80104d32:	5e                   	pop    %esi
80104d33:	5d                   	pop    %ebp
80104d34:	c3                   	ret    
80104d35:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104d38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d3d:	eb ef                	jmp    80104d2e <argfd.constprop.0+0x3e>
80104d3f:	90                   	nop

80104d40 <sys_dup>:
{
80104d40:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104d41:	31 c0                	xor    %eax,%eax
{
80104d43:	89 e5                	mov    %esp,%ebp
80104d45:	56                   	push   %esi
80104d46:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104d47:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104d4a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104d4d:	e8 9e ff ff ff       	call   80104cf0 <argfd.constprop.0>
80104d52:	85 c0                	test   %eax,%eax
80104d54:	78 42                	js     80104d98 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104d56:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104d59:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104d5b:	e8 a0 ea ff ff       	call   80103800 <myproc>
80104d60:	eb 0e                	jmp    80104d70 <sys_dup+0x30>
80104d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104d68:	83 c3 01             	add    $0x1,%ebx
80104d6b:	83 fb 10             	cmp    $0x10,%ebx
80104d6e:	74 28                	je     80104d98 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104d70:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80104d74:	85 d2                	test   %edx,%edx
80104d76:	75 f0                	jne    80104d68 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104d78:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
80104d7c:	83 ec 0c             	sub    $0xc,%esp
80104d7f:	ff 75 f4             	pushl  -0xc(%ebp)
80104d82:	e8 69 c0 ff ff       	call   80100df0 <filedup>
  return fd;
80104d87:	83 c4 10             	add    $0x10,%esp
}
80104d8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d8d:	89 d8                	mov    %ebx,%eax
80104d8f:	5b                   	pop    %ebx
80104d90:	5e                   	pop    %esi
80104d91:	5d                   	pop    %ebp
80104d92:	c3                   	ret    
80104d93:	90                   	nop
80104d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d98:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104d9b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104da0:	89 d8                	mov    %ebx,%eax
80104da2:	5b                   	pop    %ebx
80104da3:	5e                   	pop    %esi
80104da4:	5d                   	pop    %ebp
80104da5:	c3                   	ret    
80104da6:	8d 76 00             	lea    0x0(%esi),%esi
80104da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104db0 <sys_read>:
{
80104db0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104db1:	31 c0                	xor    %eax,%eax
{
80104db3:	89 e5                	mov    %esp,%ebp
80104db5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104db8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104dbb:	e8 30 ff ff ff       	call   80104cf0 <argfd.constprop.0>
80104dc0:	85 c0                	test   %eax,%eax
80104dc2:	78 4c                	js     80104e10 <sys_read+0x60>
80104dc4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104dc7:	83 ec 08             	sub    $0x8,%esp
80104dca:	50                   	push   %eax
80104dcb:	6a 02                	push   $0x2
80104dcd:	e8 2e fc ff ff       	call   80104a00 <argint>
80104dd2:	83 c4 10             	add    $0x10,%esp
80104dd5:	85 c0                	test   %eax,%eax
80104dd7:	78 37                	js     80104e10 <sys_read+0x60>
80104dd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ddc:	83 ec 04             	sub    $0x4,%esp
80104ddf:	ff 75 f0             	pushl  -0x10(%ebp)
80104de2:	50                   	push   %eax
80104de3:	6a 01                	push   $0x1
80104de5:	e8 66 fc ff ff       	call   80104a50 <argptr>
80104dea:	83 c4 10             	add    $0x10,%esp
80104ded:	85 c0                	test   %eax,%eax
80104def:	78 1f                	js     80104e10 <sys_read+0x60>
  return fileread(f, p, n);
80104df1:	83 ec 04             	sub    $0x4,%esp
80104df4:	ff 75 f0             	pushl  -0x10(%ebp)
80104df7:	ff 75 f4             	pushl  -0xc(%ebp)
80104dfa:	ff 75 ec             	pushl  -0x14(%ebp)
80104dfd:	e8 5e c1 ff ff       	call   80100f60 <fileread>
80104e02:	83 c4 10             	add    $0x10,%esp
}
80104e05:	c9                   	leave  
80104e06:	c3                   	ret    
80104e07:	89 f6                	mov    %esi,%esi
80104e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e15:	c9                   	leave  
80104e16:	c3                   	ret    
80104e17:	89 f6                	mov    %esi,%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e20 <sys_write>:
{
80104e20:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e21:	31 c0                	xor    %eax,%eax
{
80104e23:	89 e5                	mov    %esp,%ebp
80104e25:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e28:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e2b:	e8 c0 fe ff ff       	call   80104cf0 <argfd.constprop.0>
80104e30:	85 c0                	test   %eax,%eax
80104e32:	78 4c                	js     80104e80 <sys_write+0x60>
80104e34:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e37:	83 ec 08             	sub    $0x8,%esp
80104e3a:	50                   	push   %eax
80104e3b:	6a 02                	push   $0x2
80104e3d:	e8 be fb ff ff       	call   80104a00 <argint>
80104e42:	83 c4 10             	add    $0x10,%esp
80104e45:	85 c0                	test   %eax,%eax
80104e47:	78 37                	js     80104e80 <sys_write+0x60>
80104e49:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e4c:	83 ec 04             	sub    $0x4,%esp
80104e4f:	ff 75 f0             	pushl  -0x10(%ebp)
80104e52:	50                   	push   %eax
80104e53:	6a 01                	push   $0x1
80104e55:	e8 f6 fb ff ff       	call   80104a50 <argptr>
80104e5a:	83 c4 10             	add    $0x10,%esp
80104e5d:	85 c0                	test   %eax,%eax
80104e5f:	78 1f                	js     80104e80 <sys_write+0x60>
  return filewrite(f, p, n);
80104e61:	83 ec 04             	sub    $0x4,%esp
80104e64:	ff 75 f0             	pushl  -0x10(%ebp)
80104e67:	ff 75 f4             	pushl  -0xc(%ebp)
80104e6a:	ff 75 ec             	pushl  -0x14(%ebp)
80104e6d:	e8 7e c1 ff ff       	call   80100ff0 <filewrite>
80104e72:	83 c4 10             	add    $0x10,%esp
}
80104e75:	c9                   	leave  
80104e76:	c3                   	ret    
80104e77:	89 f6                	mov    %esi,%esi
80104e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104e80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e85:	c9                   	leave  
80104e86:	c3                   	ret    
80104e87:	89 f6                	mov    %esi,%esi
80104e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e90 <sys_close>:
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104e96:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104e99:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e9c:	e8 4f fe ff ff       	call   80104cf0 <argfd.constprop.0>
80104ea1:	85 c0                	test   %eax,%eax
80104ea3:	78 2b                	js     80104ed0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104ea5:	e8 56 e9 ff ff       	call   80103800 <myproc>
80104eaa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104ead:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104eb0:	c7 44 90 2c 00 00 00 	movl   $0x0,0x2c(%eax,%edx,4)
80104eb7:	00 
  fileclose(f);
80104eb8:	ff 75 f4             	pushl  -0xc(%ebp)
80104ebb:	e8 80 bf ff ff       	call   80100e40 <fileclose>
  return 0;
80104ec0:	83 c4 10             	add    $0x10,%esp
80104ec3:	31 c0                	xor    %eax,%eax
}
80104ec5:	c9                   	leave  
80104ec6:	c3                   	ret    
80104ec7:	89 f6                	mov    %esi,%esi
80104ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104ed0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ed5:	c9                   	leave  
80104ed6:	c3                   	ret    
80104ed7:	89 f6                	mov    %esi,%esi
80104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ee0 <sys_fstat>:
{
80104ee0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ee1:	31 c0                	xor    %eax,%eax
{
80104ee3:	89 e5                	mov    %esp,%ebp
80104ee5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ee8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104eeb:	e8 00 fe ff ff       	call   80104cf0 <argfd.constprop.0>
80104ef0:	85 c0                	test   %eax,%eax
80104ef2:	78 2c                	js     80104f20 <sys_fstat+0x40>
80104ef4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ef7:	83 ec 04             	sub    $0x4,%esp
80104efa:	6a 14                	push   $0x14
80104efc:	50                   	push   %eax
80104efd:	6a 01                	push   $0x1
80104eff:	e8 4c fb ff ff       	call   80104a50 <argptr>
80104f04:	83 c4 10             	add    $0x10,%esp
80104f07:	85 c0                	test   %eax,%eax
80104f09:	78 15                	js     80104f20 <sys_fstat+0x40>
  return filestat(f, st);
80104f0b:	83 ec 08             	sub    $0x8,%esp
80104f0e:	ff 75 f4             	pushl  -0xc(%ebp)
80104f11:	ff 75 f0             	pushl  -0x10(%ebp)
80104f14:	e8 f7 bf ff ff       	call   80100f10 <filestat>
80104f19:	83 c4 10             	add    $0x10,%esp
}
80104f1c:	c9                   	leave  
80104f1d:	c3                   	ret    
80104f1e:	66 90                	xchg   %ax,%ax
    return -1;
80104f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f25:	c9                   	leave  
80104f26:	c3                   	ret    
80104f27:	89 f6                	mov    %esi,%esi
80104f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f30 <sys_link>:
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	57                   	push   %edi
80104f34:	56                   	push   %esi
80104f35:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f36:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f39:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f3c:	50                   	push   %eax
80104f3d:	6a 00                	push   $0x0
80104f3f:	e8 6c fb ff ff       	call   80104ab0 <argstr>
80104f44:	83 c4 10             	add    $0x10,%esp
80104f47:	85 c0                	test   %eax,%eax
80104f49:	0f 88 fb 00 00 00    	js     8010504a <sys_link+0x11a>
80104f4f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f52:	83 ec 08             	sub    $0x8,%esp
80104f55:	50                   	push   %eax
80104f56:	6a 01                	push   $0x1
80104f58:	e8 53 fb ff ff       	call   80104ab0 <argstr>
80104f5d:	83 c4 10             	add    $0x10,%esp
80104f60:	85 c0                	test   %eax,%eax
80104f62:	0f 88 e2 00 00 00    	js     8010504a <sys_link+0x11a>
  begin_op();
80104f68:	e8 43 dc ff ff       	call   80102bb0 <begin_op>
  if((ip = namei(old)) == 0){
80104f6d:	83 ec 0c             	sub    $0xc,%esp
80104f70:	ff 75 d4             	pushl  -0x2c(%ebp)
80104f73:	e8 78 cf ff ff       	call   80101ef0 <namei>
80104f78:	83 c4 10             	add    $0x10,%esp
80104f7b:	85 c0                	test   %eax,%eax
80104f7d:	89 c3                	mov    %eax,%ebx
80104f7f:	0f 84 ea 00 00 00    	je     8010506f <sys_link+0x13f>
  ilock(ip);
80104f85:	83 ec 0c             	sub    $0xc,%esp
80104f88:	50                   	push   %eax
80104f89:	e8 02 c7 ff ff       	call   80101690 <ilock>
  if(ip->type == T_DIR){
80104f8e:	83 c4 10             	add    $0x10,%esp
80104f91:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f96:	0f 84 bb 00 00 00    	je     80105057 <sys_link+0x127>
  ip->nlink++;
80104f9c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104fa1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80104fa4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104fa7:	53                   	push   %ebx
80104fa8:	e8 33 c6 ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
80104fad:	89 1c 24             	mov    %ebx,(%esp)
80104fb0:	e8 bb c7 ff ff       	call   80101770 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104fb5:	58                   	pop    %eax
80104fb6:	5a                   	pop    %edx
80104fb7:	57                   	push   %edi
80104fb8:	ff 75 d0             	pushl  -0x30(%ebp)
80104fbb:	e8 50 cf ff ff       	call   80101f10 <nameiparent>
80104fc0:	83 c4 10             	add    $0x10,%esp
80104fc3:	85 c0                	test   %eax,%eax
80104fc5:	89 c6                	mov    %eax,%esi
80104fc7:	74 5b                	je     80105024 <sys_link+0xf4>
  ilock(dp);
80104fc9:	83 ec 0c             	sub    $0xc,%esp
80104fcc:	50                   	push   %eax
80104fcd:	e8 be c6 ff ff       	call   80101690 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104fd2:	83 c4 10             	add    $0x10,%esp
80104fd5:	8b 03                	mov    (%ebx),%eax
80104fd7:	39 06                	cmp    %eax,(%esi)
80104fd9:	75 3d                	jne    80105018 <sys_link+0xe8>
80104fdb:	83 ec 04             	sub    $0x4,%esp
80104fde:	ff 73 04             	pushl  0x4(%ebx)
80104fe1:	57                   	push   %edi
80104fe2:	56                   	push   %esi
80104fe3:	e8 48 ce ff ff       	call   80101e30 <dirlink>
80104fe8:	83 c4 10             	add    $0x10,%esp
80104feb:	85 c0                	test   %eax,%eax
80104fed:	78 29                	js     80105018 <sys_link+0xe8>
  iunlockput(dp);
80104fef:	83 ec 0c             	sub    $0xc,%esp
80104ff2:	56                   	push   %esi
80104ff3:	e8 28 c9 ff ff       	call   80101920 <iunlockput>
  iput(ip);
80104ff8:	89 1c 24             	mov    %ebx,(%esp)
80104ffb:	e8 c0 c7 ff ff       	call   801017c0 <iput>
  end_op();
80105000:	e8 1b dc ff ff       	call   80102c20 <end_op>
  return 0;
80105005:	83 c4 10             	add    $0x10,%esp
80105008:	31 c0                	xor    %eax,%eax
}
8010500a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010500d:	5b                   	pop    %ebx
8010500e:	5e                   	pop    %esi
8010500f:	5f                   	pop    %edi
80105010:	5d                   	pop    %ebp
80105011:	c3                   	ret    
80105012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105018:	83 ec 0c             	sub    $0xc,%esp
8010501b:	56                   	push   %esi
8010501c:	e8 ff c8 ff ff       	call   80101920 <iunlockput>
    goto bad;
80105021:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105024:	83 ec 0c             	sub    $0xc,%esp
80105027:	53                   	push   %ebx
80105028:	e8 63 c6 ff ff       	call   80101690 <ilock>
  ip->nlink--;
8010502d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105032:	89 1c 24             	mov    %ebx,(%esp)
80105035:	e8 a6 c5 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
8010503a:	89 1c 24             	mov    %ebx,(%esp)
8010503d:	e8 de c8 ff ff       	call   80101920 <iunlockput>
  end_op();
80105042:	e8 d9 db ff ff       	call   80102c20 <end_op>
  return -1;
80105047:	83 c4 10             	add    $0x10,%esp
}
8010504a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010504d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105052:	5b                   	pop    %ebx
80105053:	5e                   	pop    %esi
80105054:	5f                   	pop    %edi
80105055:	5d                   	pop    %ebp
80105056:	c3                   	ret    
    iunlockput(ip);
80105057:	83 ec 0c             	sub    $0xc,%esp
8010505a:	53                   	push   %ebx
8010505b:	e8 c0 c8 ff ff       	call   80101920 <iunlockput>
    end_op();
80105060:	e8 bb db ff ff       	call   80102c20 <end_op>
    return -1;
80105065:	83 c4 10             	add    $0x10,%esp
80105068:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010506d:	eb 9b                	jmp    8010500a <sys_link+0xda>
    end_op();
8010506f:	e8 ac db ff ff       	call   80102c20 <end_op>
    return -1;
80105074:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105079:	eb 8f                	jmp    8010500a <sys_link+0xda>
8010507b:	90                   	nop
8010507c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105080 <sys_unlink>:
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	57                   	push   %edi
80105084:	56                   	push   %esi
80105085:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105086:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105089:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010508c:	50                   	push   %eax
8010508d:	6a 00                	push   $0x0
8010508f:	e8 1c fa ff ff       	call   80104ab0 <argstr>
80105094:	83 c4 10             	add    $0x10,%esp
80105097:	85 c0                	test   %eax,%eax
80105099:	0f 88 77 01 00 00    	js     80105216 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010509f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801050a2:	e8 09 db ff ff       	call   80102bb0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801050a7:	83 ec 08             	sub    $0x8,%esp
801050aa:	53                   	push   %ebx
801050ab:	ff 75 c0             	pushl  -0x40(%ebp)
801050ae:	e8 5d ce ff ff       	call   80101f10 <nameiparent>
801050b3:	83 c4 10             	add    $0x10,%esp
801050b6:	85 c0                	test   %eax,%eax
801050b8:	89 c6                	mov    %eax,%esi
801050ba:	0f 84 60 01 00 00    	je     80105220 <sys_unlink+0x1a0>
  ilock(dp);
801050c0:	83 ec 0c             	sub    $0xc,%esp
801050c3:	50                   	push   %eax
801050c4:	e8 c7 c5 ff ff       	call   80101690 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801050c9:	58                   	pop    %eax
801050ca:	5a                   	pop    %edx
801050cb:	68 b0 7a 10 80       	push   $0x80107ab0
801050d0:	53                   	push   %ebx
801050d1:	e8 ca ca ff ff       	call   80101ba0 <namecmp>
801050d6:	83 c4 10             	add    $0x10,%esp
801050d9:	85 c0                	test   %eax,%eax
801050db:	0f 84 03 01 00 00    	je     801051e4 <sys_unlink+0x164>
801050e1:	83 ec 08             	sub    $0x8,%esp
801050e4:	68 af 7a 10 80       	push   $0x80107aaf
801050e9:	53                   	push   %ebx
801050ea:	e8 b1 ca ff ff       	call   80101ba0 <namecmp>
801050ef:	83 c4 10             	add    $0x10,%esp
801050f2:	85 c0                	test   %eax,%eax
801050f4:	0f 84 ea 00 00 00    	je     801051e4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
801050fa:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801050fd:	83 ec 04             	sub    $0x4,%esp
80105100:	50                   	push   %eax
80105101:	53                   	push   %ebx
80105102:	56                   	push   %esi
80105103:	e8 b8 ca ff ff       	call   80101bc0 <dirlookup>
80105108:	83 c4 10             	add    $0x10,%esp
8010510b:	85 c0                	test   %eax,%eax
8010510d:	89 c3                	mov    %eax,%ebx
8010510f:	0f 84 cf 00 00 00    	je     801051e4 <sys_unlink+0x164>
  ilock(ip);
80105115:	83 ec 0c             	sub    $0xc,%esp
80105118:	50                   	push   %eax
80105119:	e8 72 c5 ff ff       	call   80101690 <ilock>
  if(ip->nlink < 1)
8010511e:	83 c4 10             	add    $0x10,%esp
80105121:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105126:	0f 8e 10 01 00 00    	jle    8010523c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010512c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105131:	74 6d                	je     801051a0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105133:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105136:	83 ec 04             	sub    $0x4,%esp
80105139:	6a 10                	push   $0x10
8010513b:	6a 00                	push   $0x0
8010513d:	50                   	push   %eax
8010513e:	e8 bd f5 ff ff       	call   80104700 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105143:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105146:	6a 10                	push   $0x10
80105148:	ff 75 c4             	pushl  -0x3c(%ebp)
8010514b:	50                   	push   %eax
8010514c:	56                   	push   %esi
8010514d:	e8 1e c9 ff ff       	call   80101a70 <writei>
80105152:	83 c4 20             	add    $0x20,%esp
80105155:	83 f8 10             	cmp    $0x10,%eax
80105158:	0f 85 eb 00 00 00    	jne    80105249 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010515e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105163:	0f 84 97 00 00 00    	je     80105200 <sys_unlink+0x180>
  iunlockput(dp);
80105169:	83 ec 0c             	sub    $0xc,%esp
8010516c:	56                   	push   %esi
8010516d:	e8 ae c7 ff ff       	call   80101920 <iunlockput>
  ip->nlink--;
80105172:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105177:	89 1c 24             	mov    %ebx,(%esp)
8010517a:	e8 61 c4 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
8010517f:	89 1c 24             	mov    %ebx,(%esp)
80105182:	e8 99 c7 ff ff       	call   80101920 <iunlockput>
  end_op();
80105187:	e8 94 da ff ff       	call   80102c20 <end_op>
  return 0;
8010518c:	83 c4 10             	add    $0x10,%esp
8010518f:	31 c0                	xor    %eax,%eax
}
80105191:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105194:	5b                   	pop    %ebx
80105195:	5e                   	pop    %esi
80105196:	5f                   	pop    %edi
80105197:	5d                   	pop    %ebp
80105198:	c3                   	ret    
80105199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801051a0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801051a4:	76 8d                	jbe    80105133 <sys_unlink+0xb3>
801051a6:	bf 20 00 00 00       	mov    $0x20,%edi
801051ab:	eb 0f                	jmp    801051bc <sys_unlink+0x13c>
801051ad:	8d 76 00             	lea    0x0(%esi),%esi
801051b0:	83 c7 10             	add    $0x10,%edi
801051b3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801051b6:	0f 83 77 ff ff ff    	jae    80105133 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051bc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801051bf:	6a 10                	push   $0x10
801051c1:	57                   	push   %edi
801051c2:	50                   	push   %eax
801051c3:	53                   	push   %ebx
801051c4:	e8 a7 c7 ff ff       	call   80101970 <readi>
801051c9:	83 c4 10             	add    $0x10,%esp
801051cc:	83 f8 10             	cmp    $0x10,%eax
801051cf:	75 5e                	jne    8010522f <sys_unlink+0x1af>
    if(de.inum != 0)
801051d1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801051d6:	74 d8                	je     801051b0 <sys_unlink+0x130>
    iunlockput(ip);
801051d8:	83 ec 0c             	sub    $0xc,%esp
801051db:	53                   	push   %ebx
801051dc:	e8 3f c7 ff ff       	call   80101920 <iunlockput>
    goto bad;
801051e1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801051e4:	83 ec 0c             	sub    $0xc,%esp
801051e7:	56                   	push   %esi
801051e8:	e8 33 c7 ff ff       	call   80101920 <iunlockput>
  end_op();
801051ed:	e8 2e da ff ff       	call   80102c20 <end_op>
  return -1;
801051f2:	83 c4 10             	add    $0x10,%esp
801051f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051fa:	eb 95                	jmp    80105191 <sys_unlink+0x111>
801051fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105200:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105205:	83 ec 0c             	sub    $0xc,%esp
80105208:	56                   	push   %esi
80105209:	e8 d2 c3 ff ff       	call   801015e0 <iupdate>
8010520e:	83 c4 10             	add    $0x10,%esp
80105211:	e9 53 ff ff ff       	jmp    80105169 <sys_unlink+0xe9>
    return -1;
80105216:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010521b:	e9 71 ff ff ff       	jmp    80105191 <sys_unlink+0x111>
    end_op();
80105220:	e8 fb d9 ff ff       	call   80102c20 <end_op>
    return -1;
80105225:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010522a:	e9 62 ff ff ff       	jmp    80105191 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010522f:	83 ec 0c             	sub    $0xc,%esp
80105232:	68 d4 7a 10 80       	push   $0x80107ad4
80105237:	e8 54 b1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010523c:	83 ec 0c             	sub    $0xc,%esp
8010523f:	68 c2 7a 10 80       	push   $0x80107ac2
80105244:	e8 47 b1 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105249:	83 ec 0c             	sub    $0xc,%esp
8010524c:	68 e6 7a 10 80       	push   $0x80107ae6
80105251:	e8 3a b1 ff ff       	call   80100390 <panic>
80105256:	8d 76 00             	lea    0x0(%esi),%esi
80105259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105260 <sys_open>:

int
sys_open(void)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	57                   	push   %edi
80105264:	56                   	push   %esi
80105265:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105266:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105269:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010526c:	50                   	push   %eax
8010526d:	6a 00                	push   $0x0
8010526f:	e8 3c f8 ff ff       	call   80104ab0 <argstr>
80105274:	83 c4 10             	add    $0x10,%esp
80105277:	85 c0                	test   %eax,%eax
80105279:	0f 88 1d 01 00 00    	js     8010539c <sys_open+0x13c>
8010527f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105282:	83 ec 08             	sub    $0x8,%esp
80105285:	50                   	push   %eax
80105286:	6a 01                	push   $0x1
80105288:	e8 73 f7 ff ff       	call   80104a00 <argint>
8010528d:	83 c4 10             	add    $0x10,%esp
80105290:	85 c0                	test   %eax,%eax
80105292:	0f 88 04 01 00 00    	js     8010539c <sys_open+0x13c>
    return -1;

  begin_op();
80105298:	e8 13 d9 ff ff       	call   80102bb0 <begin_op>

  if(omode & O_CREATE){
8010529d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801052a1:	0f 85 a9 00 00 00    	jne    80105350 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801052a7:	83 ec 0c             	sub    $0xc,%esp
801052aa:	ff 75 e0             	pushl  -0x20(%ebp)
801052ad:	e8 3e cc ff ff       	call   80101ef0 <namei>
801052b2:	83 c4 10             	add    $0x10,%esp
801052b5:	85 c0                	test   %eax,%eax
801052b7:	89 c6                	mov    %eax,%esi
801052b9:	0f 84 b2 00 00 00    	je     80105371 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801052bf:	83 ec 0c             	sub    $0xc,%esp
801052c2:	50                   	push   %eax
801052c3:	e8 c8 c3 ff ff       	call   80101690 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801052c8:	83 c4 10             	add    $0x10,%esp
801052cb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801052d0:	0f 84 aa 00 00 00    	je     80105380 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801052d6:	e8 a5 ba ff ff       	call   80100d80 <filealloc>
801052db:	85 c0                	test   %eax,%eax
801052dd:	89 c7                	mov    %eax,%edi
801052df:	0f 84 a6 00 00 00    	je     8010538b <sys_open+0x12b>
  struct proc *curproc = myproc();
801052e5:	e8 16 e5 ff ff       	call   80103800 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801052ea:	31 db                	xor    %ebx,%ebx
801052ec:	eb 0e                	jmp    801052fc <sys_open+0x9c>
801052ee:	66 90                	xchg   %ax,%ax
801052f0:	83 c3 01             	add    $0x1,%ebx
801052f3:	83 fb 10             	cmp    $0x10,%ebx
801052f6:	0f 84 ac 00 00 00    	je     801053a8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801052fc:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105300:	85 d2                	test   %edx,%edx
80105302:	75 ec                	jne    801052f0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105304:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105307:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
8010530b:	56                   	push   %esi
8010530c:	e8 5f c4 ff ff       	call   80101770 <iunlock>
  end_op();
80105311:	e8 0a d9 ff ff       	call   80102c20 <end_op>

  f->type = FD_INODE;
80105316:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010531c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010531f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105322:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105325:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010532c:	89 d0                	mov    %edx,%eax
8010532e:	f7 d0                	not    %eax
80105330:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105333:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105336:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105339:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010533d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105340:	89 d8                	mov    %ebx,%eax
80105342:	5b                   	pop    %ebx
80105343:	5e                   	pop    %esi
80105344:	5f                   	pop    %edi
80105345:	5d                   	pop    %ebp
80105346:	c3                   	ret    
80105347:	89 f6                	mov    %esi,%esi
80105349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105350:	83 ec 0c             	sub    $0xc,%esp
80105353:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105356:	31 c9                	xor    %ecx,%ecx
80105358:	6a 00                	push   $0x0
8010535a:	ba 02 00 00 00       	mov    $0x2,%edx
8010535f:	e8 ec f7 ff ff       	call   80104b50 <create>
    if(ip == 0){
80105364:	83 c4 10             	add    $0x10,%esp
80105367:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105369:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010536b:	0f 85 65 ff ff ff    	jne    801052d6 <sys_open+0x76>
      end_op();
80105371:	e8 aa d8 ff ff       	call   80102c20 <end_op>
      return -1;
80105376:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010537b:	eb c0                	jmp    8010533d <sys_open+0xdd>
8010537d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105380:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105383:	85 c9                	test   %ecx,%ecx
80105385:	0f 84 4b ff ff ff    	je     801052d6 <sys_open+0x76>
    iunlockput(ip);
8010538b:	83 ec 0c             	sub    $0xc,%esp
8010538e:	56                   	push   %esi
8010538f:	e8 8c c5 ff ff       	call   80101920 <iunlockput>
    end_op();
80105394:	e8 87 d8 ff ff       	call   80102c20 <end_op>
    return -1;
80105399:	83 c4 10             	add    $0x10,%esp
8010539c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801053a1:	eb 9a                	jmp    8010533d <sys_open+0xdd>
801053a3:	90                   	nop
801053a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801053a8:	83 ec 0c             	sub    $0xc,%esp
801053ab:	57                   	push   %edi
801053ac:	e8 8f ba ff ff       	call   80100e40 <fileclose>
801053b1:	83 c4 10             	add    $0x10,%esp
801053b4:	eb d5                	jmp    8010538b <sys_open+0x12b>
801053b6:	8d 76 00             	lea    0x0(%esi),%esi
801053b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053c0 <sys_mkdir>:

int
sys_mkdir(void)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801053c6:	e8 e5 d7 ff ff       	call   80102bb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801053cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053ce:	83 ec 08             	sub    $0x8,%esp
801053d1:	50                   	push   %eax
801053d2:	6a 00                	push   $0x0
801053d4:	e8 d7 f6 ff ff       	call   80104ab0 <argstr>
801053d9:	83 c4 10             	add    $0x10,%esp
801053dc:	85 c0                	test   %eax,%eax
801053de:	78 30                	js     80105410 <sys_mkdir+0x50>
801053e0:	83 ec 0c             	sub    $0xc,%esp
801053e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053e6:	31 c9                	xor    %ecx,%ecx
801053e8:	6a 00                	push   $0x0
801053ea:	ba 01 00 00 00       	mov    $0x1,%edx
801053ef:	e8 5c f7 ff ff       	call   80104b50 <create>
801053f4:	83 c4 10             	add    $0x10,%esp
801053f7:	85 c0                	test   %eax,%eax
801053f9:	74 15                	je     80105410 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801053fb:	83 ec 0c             	sub    $0xc,%esp
801053fe:	50                   	push   %eax
801053ff:	e8 1c c5 ff ff       	call   80101920 <iunlockput>
  end_op();
80105404:	e8 17 d8 ff ff       	call   80102c20 <end_op>
  return 0;
80105409:	83 c4 10             	add    $0x10,%esp
8010540c:	31 c0                	xor    %eax,%eax
}
8010540e:	c9                   	leave  
8010540f:	c3                   	ret    
    end_op();
80105410:	e8 0b d8 ff ff       	call   80102c20 <end_op>
    return -1;
80105415:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010541a:	c9                   	leave  
8010541b:	c3                   	ret    
8010541c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105420 <sys_mknod>:

int
sys_mknod(void)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105426:	e8 85 d7 ff ff       	call   80102bb0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010542b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010542e:	83 ec 08             	sub    $0x8,%esp
80105431:	50                   	push   %eax
80105432:	6a 00                	push   $0x0
80105434:	e8 77 f6 ff ff       	call   80104ab0 <argstr>
80105439:	83 c4 10             	add    $0x10,%esp
8010543c:	85 c0                	test   %eax,%eax
8010543e:	78 60                	js     801054a0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105440:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105443:	83 ec 08             	sub    $0x8,%esp
80105446:	50                   	push   %eax
80105447:	6a 01                	push   $0x1
80105449:	e8 b2 f5 ff ff       	call   80104a00 <argint>
  if((argstr(0, &path)) < 0 ||
8010544e:	83 c4 10             	add    $0x10,%esp
80105451:	85 c0                	test   %eax,%eax
80105453:	78 4b                	js     801054a0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105455:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105458:	83 ec 08             	sub    $0x8,%esp
8010545b:	50                   	push   %eax
8010545c:	6a 02                	push   $0x2
8010545e:	e8 9d f5 ff ff       	call   80104a00 <argint>
     argint(1, &major) < 0 ||
80105463:	83 c4 10             	add    $0x10,%esp
80105466:	85 c0                	test   %eax,%eax
80105468:	78 36                	js     801054a0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010546a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010546e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105471:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105475:	ba 03 00 00 00       	mov    $0x3,%edx
8010547a:	50                   	push   %eax
8010547b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010547e:	e8 cd f6 ff ff       	call   80104b50 <create>
80105483:	83 c4 10             	add    $0x10,%esp
80105486:	85 c0                	test   %eax,%eax
80105488:	74 16                	je     801054a0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010548a:	83 ec 0c             	sub    $0xc,%esp
8010548d:	50                   	push   %eax
8010548e:	e8 8d c4 ff ff       	call   80101920 <iunlockput>
  end_op();
80105493:	e8 88 d7 ff ff       	call   80102c20 <end_op>
  return 0;
80105498:	83 c4 10             	add    $0x10,%esp
8010549b:	31 c0                	xor    %eax,%eax
}
8010549d:	c9                   	leave  
8010549e:	c3                   	ret    
8010549f:	90                   	nop
    end_op();
801054a0:	e8 7b d7 ff ff       	call   80102c20 <end_op>
    return -1;
801054a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054aa:	c9                   	leave  
801054ab:	c3                   	ret    
801054ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054b0 <sys_chdir>:

int
sys_chdir(void)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	56                   	push   %esi
801054b4:	53                   	push   %ebx
801054b5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801054b8:	e8 43 e3 ff ff       	call   80103800 <myproc>
801054bd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801054bf:	e8 ec d6 ff ff       	call   80102bb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801054c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054c7:	83 ec 08             	sub    $0x8,%esp
801054ca:	50                   	push   %eax
801054cb:	6a 00                	push   $0x0
801054cd:	e8 de f5 ff ff       	call   80104ab0 <argstr>
801054d2:	83 c4 10             	add    $0x10,%esp
801054d5:	85 c0                	test   %eax,%eax
801054d7:	78 77                	js     80105550 <sys_chdir+0xa0>
801054d9:	83 ec 0c             	sub    $0xc,%esp
801054dc:	ff 75 f4             	pushl  -0xc(%ebp)
801054df:	e8 0c ca ff ff       	call   80101ef0 <namei>
801054e4:	83 c4 10             	add    $0x10,%esp
801054e7:	85 c0                	test   %eax,%eax
801054e9:	89 c3                	mov    %eax,%ebx
801054eb:	74 63                	je     80105550 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801054ed:	83 ec 0c             	sub    $0xc,%esp
801054f0:	50                   	push   %eax
801054f1:	e8 9a c1 ff ff       	call   80101690 <ilock>
  if(ip->type != T_DIR){
801054f6:	83 c4 10             	add    $0x10,%esp
801054f9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054fe:	75 30                	jne    80105530 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105500:	83 ec 0c             	sub    $0xc,%esp
80105503:	53                   	push   %ebx
80105504:	e8 67 c2 ff ff       	call   80101770 <iunlock>
  iput(curproc->cwd);
80105509:	58                   	pop    %eax
8010550a:	ff 76 6c             	pushl  0x6c(%esi)
8010550d:	e8 ae c2 ff ff       	call   801017c0 <iput>
  end_op();
80105512:	e8 09 d7 ff ff       	call   80102c20 <end_op>
  curproc->cwd = ip;
80105517:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
8010551a:	83 c4 10             	add    $0x10,%esp
8010551d:	31 c0                	xor    %eax,%eax
}
8010551f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105522:	5b                   	pop    %ebx
80105523:	5e                   	pop    %esi
80105524:	5d                   	pop    %ebp
80105525:	c3                   	ret    
80105526:	8d 76 00             	lea    0x0(%esi),%esi
80105529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105530:	83 ec 0c             	sub    $0xc,%esp
80105533:	53                   	push   %ebx
80105534:	e8 e7 c3 ff ff       	call   80101920 <iunlockput>
    end_op();
80105539:	e8 e2 d6 ff ff       	call   80102c20 <end_op>
    return -1;
8010553e:	83 c4 10             	add    $0x10,%esp
80105541:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105546:	eb d7                	jmp    8010551f <sys_chdir+0x6f>
80105548:	90                   	nop
80105549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105550:	e8 cb d6 ff ff       	call   80102c20 <end_op>
    return -1;
80105555:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010555a:	eb c3                	jmp    8010551f <sys_chdir+0x6f>
8010555c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105560 <sys_exec>:

int
sys_exec(void)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	57                   	push   %edi
80105564:	56                   	push   %esi
80105565:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105566:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010556c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105572:	50                   	push   %eax
80105573:	6a 00                	push   $0x0
80105575:	e8 36 f5 ff ff       	call   80104ab0 <argstr>
8010557a:	83 c4 10             	add    $0x10,%esp
8010557d:	85 c0                	test   %eax,%eax
8010557f:	0f 88 87 00 00 00    	js     8010560c <sys_exec+0xac>
80105585:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010558b:	83 ec 08             	sub    $0x8,%esp
8010558e:	50                   	push   %eax
8010558f:	6a 01                	push   $0x1
80105591:	e8 6a f4 ff ff       	call   80104a00 <argint>
80105596:	83 c4 10             	add    $0x10,%esp
80105599:	85 c0                	test   %eax,%eax
8010559b:	78 6f                	js     8010560c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010559d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801055a3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801055a6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801055a8:	68 80 00 00 00       	push   $0x80
801055ad:	6a 00                	push   $0x0
801055af:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801055b5:	50                   	push   %eax
801055b6:	e8 45 f1 ff ff       	call   80104700 <memset>
801055bb:	83 c4 10             	add    $0x10,%esp
801055be:	eb 2c                	jmp    801055ec <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801055c0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801055c6:	85 c0                	test   %eax,%eax
801055c8:	74 56                	je     80105620 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801055ca:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801055d0:	83 ec 08             	sub    $0x8,%esp
801055d3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801055d6:	52                   	push   %edx
801055d7:	50                   	push   %eax
801055d8:	e8 b3 f3 ff ff       	call   80104990 <fetchstr>
801055dd:	83 c4 10             	add    $0x10,%esp
801055e0:	85 c0                	test   %eax,%eax
801055e2:	78 28                	js     8010560c <sys_exec+0xac>
  for(i=0;; i++){
801055e4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801055e7:	83 fb 20             	cmp    $0x20,%ebx
801055ea:	74 20                	je     8010560c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801055ec:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801055f2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801055f9:	83 ec 08             	sub    $0x8,%esp
801055fc:	57                   	push   %edi
801055fd:	01 f0                	add    %esi,%eax
801055ff:	50                   	push   %eax
80105600:	e8 4b f3 ff ff       	call   80104950 <fetchint>
80105605:	83 c4 10             	add    $0x10,%esp
80105608:	85 c0                	test   %eax,%eax
8010560a:	79 b4                	jns    801055c0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010560c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010560f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105614:	5b                   	pop    %ebx
80105615:	5e                   	pop    %esi
80105616:	5f                   	pop    %edi
80105617:	5d                   	pop    %ebp
80105618:	c3                   	ret    
80105619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105620:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105626:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105629:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105630:	00 00 00 00 
  return exec(path, argv);
80105634:	50                   	push   %eax
80105635:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010563b:	e8 d0 b3 ff ff       	call   80100a10 <exec>
80105640:	83 c4 10             	add    $0x10,%esp
}
80105643:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105646:	5b                   	pop    %ebx
80105647:	5e                   	pop    %esi
80105648:	5f                   	pop    %edi
80105649:	5d                   	pop    %ebp
8010564a:	c3                   	ret    
8010564b:	90                   	nop
8010564c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105650 <sys_pipe>:

int
sys_pipe(void)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	57                   	push   %edi
80105654:	56                   	push   %esi
80105655:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105656:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105659:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010565c:	6a 08                	push   $0x8
8010565e:	50                   	push   %eax
8010565f:	6a 00                	push   $0x0
80105661:	e8 ea f3 ff ff       	call   80104a50 <argptr>
80105666:	83 c4 10             	add    $0x10,%esp
80105669:	85 c0                	test   %eax,%eax
8010566b:	0f 88 ae 00 00 00    	js     8010571f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105671:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105674:	83 ec 08             	sub    $0x8,%esp
80105677:	50                   	push   %eax
80105678:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010567b:	50                   	push   %eax
8010567c:	e8 cf db ff ff       	call   80103250 <pipealloc>
80105681:	83 c4 10             	add    $0x10,%esp
80105684:	85 c0                	test   %eax,%eax
80105686:	0f 88 93 00 00 00    	js     8010571f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010568c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010568f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105691:	e8 6a e1 ff ff       	call   80103800 <myproc>
80105696:	eb 10                	jmp    801056a8 <sys_pipe+0x58>
80105698:	90                   	nop
80105699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801056a0:	83 c3 01             	add    $0x1,%ebx
801056a3:	83 fb 10             	cmp    $0x10,%ebx
801056a6:	74 60                	je     80105708 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801056a8:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
801056ac:	85 f6                	test   %esi,%esi
801056ae:	75 f0                	jne    801056a0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801056b0:	8d 73 08             	lea    0x8(%ebx),%esi
801056b3:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801056ba:	e8 41 e1 ff ff       	call   80103800 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056bf:	31 d2                	xor    %edx,%edx
801056c1:	eb 0d                	jmp    801056d0 <sys_pipe+0x80>
801056c3:	90                   	nop
801056c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056c8:	83 c2 01             	add    $0x1,%edx
801056cb:	83 fa 10             	cmp    $0x10,%edx
801056ce:	74 28                	je     801056f8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801056d0:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
801056d4:	85 c9                	test   %ecx,%ecx
801056d6:	75 f0                	jne    801056c8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801056d8:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801056dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056df:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801056e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056e4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801056e7:	31 c0                	xor    %eax,%eax
}
801056e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056ec:	5b                   	pop    %ebx
801056ed:	5e                   	pop    %esi
801056ee:	5f                   	pop    %edi
801056ef:	5d                   	pop    %ebp
801056f0:	c3                   	ret    
801056f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801056f8:	e8 03 e1 ff ff       	call   80103800 <myproc>
801056fd:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105704:	00 
80105705:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105708:	83 ec 0c             	sub    $0xc,%esp
8010570b:	ff 75 e0             	pushl  -0x20(%ebp)
8010570e:	e8 2d b7 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105713:	58                   	pop    %eax
80105714:	ff 75 e4             	pushl  -0x1c(%ebp)
80105717:	e8 24 b7 ff ff       	call   80100e40 <fileclose>
    return -1;
8010571c:	83 c4 10             	add    $0x10,%esp
8010571f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105724:	eb c3                	jmp    801056e9 <sys_pipe+0x99>
80105726:	66 90                	xchg   %ax,%ax
80105728:	66 90                	xchg   %ax,%ax
8010572a:	66 90                	xchg   %ax,%ax
8010572c:	66 90                	xchg   %ax,%ax
8010572e:	66 90                	xchg   %ax,%ax

80105730 <sys_fork>:
#include "proc.h"
#include "processInfo.h"

int
sys_fork(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105733:	5d                   	pop    %ebp
  return fork();
80105734:	e9 67 e2 ff ff       	jmp    801039a0 <fork>
80105739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105740 <sys_exit>:

int
sys_exit(void)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	83 ec 08             	sub    $0x8,%esp
  exit();
80105746:	e8 25 e5 ff ff       	call   80103c70 <exit>
  return 0;  // not reached
}
8010574b:	31 c0                	xor    %eax,%eax
8010574d:	c9                   	leave  
8010574e:	c3                   	ret    
8010574f:	90                   	nop

80105750 <sys_wait>:

int
sys_wait(void)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105753:	5d                   	pop    %ebp
  return wait();
80105754:	e9 57 e7 ff ff       	jmp    80103eb0 <wait>
80105759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105760 <sys_kill>:

int
sys_kill(void)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105766:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105769:	50                   	push   %eax
8010576a:	6a 00                	push   $0x0
8010576c:	e8 8f f2 ff ff       	call   80104a00 <argint>
80105771:	83 c4 10             	add    $0x10,%esp
80105774:	85 c0                	test   %eax,%eax
80105776:	78 18                	js     80105790 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105778:	83 ec 0c             	sub    $0xc,%esp
8010577b:	ff 75 f4             	pushl  -0xc(%ebp)
8010577e:	e8 8d e8 ff ff       	call   80104010 <kill>
80105783:	83 c4 10             	add    $0x10,%esp
}
80105786:	c9                   	leave  
80105787:	c3                   	ret    
80105788:	90                   	nop
80105789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105790:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105795:	c9                   	leave  
80105796:	c3                   	ret    
80105797:	89 f6                	mov    %esi,%esi
80105799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057a0 <sys_getpid>:

int
sys_getpid(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801057a6:	e8 55 e0 ff ff       	call   80103800 <myproc>
801057ab:	8b 40 10             	mov    0x10(%eax),%eax
}
801057ae:	c9                   	leave  
801057af:	c3                   	ret    

801057b0 <sys_sbrk>:

int
sys_sbrk(void)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801057b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057b7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057ba:	50                   	push   %eax
801057bb:	6a 00                	push   $0x0
801057bd:	e8 3e f2 ff ff       	call   80104a00 <argint>
801057c2:	83 c4 10             	add    $0x10,%esp
801057c5:	85 c0                	test   %eax,%eax
801057c7:	78 27                	js     801057f0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801057c9:	e8 32 e0 ff ff       	call   80103800 <myproc>
  if(growproc(n) < 0)
801057ce:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801057d1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801057d3:	ff 75 f4             	pushl  -0xc(%ebp)
801057d6:	e8 45 e1 ff ff       	call   80103920 <growproc>
801057db:	83 c4 10             	add    $0x10,%esp
801057de:	85 c0                	test   %eax,%eax
801057e0:	78 0e                	js     801057f0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801057e2:	89 d8                	mov    %ebx,%eax
801057e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057e7:	c9                   	leave  
801057e8:	c3                   	ret    
801057e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801057f0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057f5:	eb eb                	jmp    801057e2 <sys_sbrk+0x32>
801057f7:	89 f6                	mov    %esi,%esi
801057f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105800 <sys_sleep>:

int
sys_sleep(void)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105804:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105807:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010580a:	50                   	push   %eax
8010580b:	6a 00                	push   $0x0
8010580d:	e8 ee f1 ff ff       	call   80104a00 <argint>
80105812:	83 c4 10             	add    $0x10,%esp
80105815:	85 c0                	test   %eax,%eax
80105817:	0f 88 8a 00 00 00    	js     801058a7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010581d:	83 ec 0c             	sub    $0xc,%esp
80105820:	68 60 53 11 80       	push   $0x80115360
80105825:	e8 c6 ed ff ff       	call   801045f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010582a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010582d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105830:	8b 1d a0 5b 11 80    	mov    0x80115ba0,%ebx
  while(ticks - ticks0 < n){
80105836:	85 d2                	test   %edx,%edx
80105838:	75 27                	jne    80105861 <sys_sleep+0x61>
8010583a:	eb 54                	jmp    80105890 <sys_sleep+0x90>
8010583c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105840:	83 ec 08             	sub    $0x8,%esp
80105843:	68 60 53 11 80       	push   $0x80115360
80105848:	68 a0 5b 11 80       	push   $0x80115ba0
8010584d:	e8 9e e5 ff ff       	call   80103df0 <sleep>
  while(ticks - ticks0 < n){
80105852:	a1 a0 5b 11 80       	mov    0x80115ba0,%eax
80105857:	83 c4 10             	add    $0x10,%esp
8010585a:	29 d8                	sub    %ebx,%eax
8010585c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010585f:	73 2f                	jae    80105890 <sys_sleep+0x90>
    if(myproc()->killed){
80105861:	e8 9a df ff ff       	call   80103800 <myproc>
80105866:	8b 40 28             	mov    0x28(%eax),%eax
80105869:	85 c0                	test   %eax,%eax
8010586b:	74 d3                	je     80105840 <sys_sleep+0x40>
      release(&tickslock);
8010586d:	83 ec 0c             	sub    $0xc,%esp
80105870:	68 60 53 11 80       	push   $0x80115360
80105875:	e8 36 ee ff ff       	call   801046b0 <release>
      return -1;
8010587a:	83 c4 10             	add    $0x10,%esp
8010587d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105882:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105885:	c9                   	leave  
80105886:	c3                   	ret    
80105887:	89 f6                	mov    %esi,%esi
80105889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105890:	83 ec 0c             	sub    $0xc,%esp
80105893:	68 60 53 11 80       	push   $0x80115360
80105898:	e8 13 ee ff ff       	call   801046b0 <release>
  return 0;
8010589d:	83 c4 10             	add    $0x10,%esp
801058a0:	31 c0                	xor    %eax,%eax
}
801058a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058a5:	c9                   	leave  
801058a6:	c3                   	ret    
    return -1;
801058a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ac:	eb f4                	jmp    801058a2 <sys_sleep+0xa2>
801058ae:	66 90                	xchg   %ax,%ax

801058b0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	53                   	push   %ebx
801058b4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801058b7:	68 60 53 11 80       	push   $0x80115360
801058bc:	e8 2f ed ff ff       	call   801045f0 <acquire>
  xticks = ticks;
801058c1:	8b 1d a0 5b 11 80    	mov    0x80115ba0,%ebx
  release(&tickslock);
801058c7:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
801058ce:	e8 dd ed ff ff       	call   801046b0 <release>
  return xticks;
}
801058d3:	89 d8                	mov    %ebx,%eax
801058d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058d8:	c9                   	leave  
801058d9:	c3                   	ret    
801058da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058e0 <sys_hello>:

int 
sys_hello(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	83 ec 14             	sub    $0x14,%esp
cprintf("helloxv6\n");
801058e6:	68 f5 7a 10 80       	push   $0x80107af5
801058eb:	e8 70 ad ff ff       	call   80100660 <cprintf>
return 0;
}
801058f0:	31 c0                	xor    %eax,%eax
801058f2:	c9                   	leave  
801058f3:	c3                   	ret    
801058f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801058fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105900 <sys_helloname>:

int
sys_helloname(char *name)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	83 ec 0c             	sub    $0xc,%esp

argptr(0,(void*)&name, sizeof(name));
80105906:	8d 45 08             	lea    0x8(%ebp),%eax
80105909:	6a 04                	push   $0x4
8010590b:	50                   	push   %eax
8010590c:	6a 00                	push   $0x0
8010590e:	e8 3d f1 ff ff       	call   80104a50 <argptr>
cprintf("hello %s\n",name);
80105913:	58                   	pop    %eax
80105914:	5a                   	pop    %edx
80105915:	ff 75 08             	pushl  0x8(%ebp)
80105918:	68 ff 7a 10 80       	push   $0x80107aff
8010591d:	e8 3e ad ff ff       	call   80100660 <cprintf>
return 0;
}
80105922:	31 c0                	xor    %eax,%eax
80105924:	c9                   	leave  
80105925:	c3                   	ret    
80105926:	8d 76 00             	lea    0x0(%esi),%esi
80105929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105930 <sys_getnumproc>:
int
sys_getnumproc(void)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	83 ec 08             	sub    $0x8,%esp
 // argint(0,&proc);
  cprintf("Total number of Active Processes: %d\n",getnumproc());
80105936:	e8 25 e8 ff ff       	call   80104160 <getnumproc>
8010593b:	83 ec 08             	sub    $0x8,%esp
8010593e:	50                   	push   %eax
8010593f:	68 1c 7b 10 80       	push   $0x80107b1c
80105944:	e8 17 ad ff ff       	call   80100660 <cprintf>
  return 0;
}
80105949:	31 c0                	xor    %eax,%eax
8010594b:	c9                   	leave  
8010594c:	c3                   	ret    
8010594d:	8d 76 00             	lea    0x0(%esi),%esi

80105950 <sys_getmaxpid>:

int
sys_getmaxpid(void)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	83 ec 08             	sub    $0x8,%esp
  int size;
  if(argint(0,&size)<0 || argptr(1,(void*)&tmp, sizeof(*tmp))<0)
  {
    return -1;
  }*/
  cprintf("Maximum PID: %d\n",getmaxpid());
80105956:	e8 55 e8 ff ff       	call   801041b0 <getmaxpid>
8010595b:	83 ec 08             	sub    $0x8,%esp
8010595e:	50                   	push   %eax
8010595f:	68 09 7b 10 80       	push   $0x80107b09
80105964:	e8 f7 ac ff ff       	call   80100660 <cprintf>
  return 0;
}
80105969:	31 c0                	xor    %eax,%eax
8010596b:	c9                   	leave  
8010596c:	c3                   	ret    
8010596d:	8d 76 00             	lea    0x0(%esi),%esi

80105970 <sys_getprocinfo>:
int 
sys_getprocinfo(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	83 ec 24             	sub    $0x24,%esp
  cprintf("PID    PPID   SIZE    Number of Context Switch\n");
80105976:	68 44 7b 10 80       	push   $0x80107b44
8010597b:	e8 e0 ac ff ff       	call   80100660 <cprintf>
   int pid;
    struct processInfo *tmp;
    if(argint(0,&pid)<0 ||argptr(1,(void*)&tmp,sizeof(*tmp))<0)
80105980:	58                   	pop    %eax
80105981:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105984:	5a                   	pop    %edx
80105985:	50                   	push   %eax
80105986:	6a 00                	push   $0x0
80105988:	e8 73 f0 ff ff       	call   80104a00 <argint>
8010598d:	83 c4 10             	add    $0x10,%esp
80105990:	85 c0                	test   %eax,%eax
80105992:	78 2c                	js     801059c0 <sys_getprocinfo+0x50>
80105994:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105997:	83 ec 04             	sub    $0x4,%esp
8010599a:	6a 0c                	push   $0xc
8010599c:	50                   	push   %eax
8010599d:	6a 01                	push   $0x1
8010599f:	e8 ac f0 ff ff       	call   80104a50 <argptr>
801059a4:	83 c4 10             	add    $0x10,%esp
801059a7:	85 c0                	test   %eax,%eax
801059a9:	78 15                	js     801059c0 <sys_getprocinfo+0x50>
      return -1;
  getprocinfo(pid, tmp);
801059ab:	83 ec 08             	sub    $0x8,%esp
801059ae:	ff 75 f4             	pushl  -0xc(%ebp)
801059b1:	ff 75 f0             	pushl  -0x10(%ebp)
801059b4:	e8 47 e8 ff ff       	call   80104200 <getprocinfo>
  
  return 0;
801059b9:	83 c4 10             	add    $0x10,%esp
801059bc:	31 c0                	xor    %eax,%eax
}
801059be:	c9                   	leave  
801059bf:	c3                   	ret    
      return -1;
801059c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059c5:	c9                   	leave  
801059c6:	c3                   	ret    
801059c7:	89 f6                	mov    %esi,%esi
801059c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059d0 <sys_setprio>:
int sys_setprio(int newPrio)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	83 ec 10             	sub    $0x10,%esp
  
 
  //cprintf("new:%d\n",newPrio);

  //cprintf("newprio of pre-arg: %d\n", newPrio);
  argint(0,&newPrio);
801059d6:	8d 45 08             	lea    0x8(%ebp),%eax
801059d9:	50                   	push   %eax
801059da:	6a 00                	push   $0x0
801059dc:	e8 1f f0 ff ff       	call   80104a00 <argint>
  //cprintf("newprio arg:%d\n",newPrio);
  //cprintf("proc %s priority changed ; new prio: %d\n",p->name,p->priority);
 
  //setprio(newPrio);
  return setprio(newPrio);
801059e1:	58                   	pop    %eax
801059e2:	ff 75 08             	pushl  0x8(%ebp)
801059e5:	e8 a6 e8 ff ff       	call   80104290 <setprio>
}
801059ea:	c9                   	leave  
801059eb:	c3                   	ret    
801059ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059f0 <sys_getprio>:
int sys_getprio(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
  //getprio();
  return getprio();
}
801059f3:	5d                   	pop    %ebp
  return getprio();
801059f4:	e9 37 e9 ff ff       	jmp    80104330 <getprio>

801059f9 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801059f9:	1e                   	push   %ds
  pushl %es
801059fa:	06                   	push   %es
  pushl %fs
801059fb:	0f a0                	push   %fs
  pushl %gs
801059fd:	0f a8                	push   %gs
  pushal
801059ff:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105a00:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105a04:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105a06:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105a08:	54                   	push   %esp
  call trap
80105a09:	e8 c2 00 00 00       	call   80105ad0 <trap>
  addl $4, %esp
80105a0e:	83 c4 04             	add    $0x4,%esp

80105a11 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105a11:	61                   	popa   
  popl %gs
80105a12:	0f a9                	pop    %gs
  popl %fs
80105a14:	0f a1                	pop    %fs
  popl %es
80105a16:	07                   	pop    %es
  popl %ds
80105a17:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105a18:	83 c4 08             	add    $0x8,%esp
  iret
80105a1b:	cf                   	iret   
80105a1c:	66 90                	xchg   %ax,%ax
80105a1e:	66 90                	xchg   %ax,%ax

80105a20 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105a20:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105a21:	31 c0                	xor    %eax,%eax
{
80105a23:	89 e5                	mov    %esp,%ebp
80105a25:	83 ec 08             	sub    $0x8,%esp
80105a28:	90                   	nop
80105a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105a30:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105a37:	c7 04 c5 a2 53 11 80 	movl   $0x8e000008,-0x7feeac5e(,%eax,8)
80105a3e:	08 00 00 8e 
80105a42:	66 89 14 c5 a0 53 11 	mov    %dx,-0x7feeac60(,%eax,8)
80105a49:	80 
80105a4a:	c1 ea 10             	shr    $0x10,%edx
80105a4d:	66 89 14 c5 a6 53 11 	mov    %dx,-0x7feeac5a(,%eax,8)
80105a54:	80 
  for(i = 0; i < 256; i++)
80105a55:	83 c0 01             	add    $0x1,%eax
80105a58:	3d 00 01 00 00       	cmp    $0x100,%eax
80105a5d:	75 d1                	jne    80105a30 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a5f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105a64:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a67:	c7 05 a2 55 11 80 08 	movl   $0xef000008,0x801155a2
80105a6e:	00 00 ef 
  initlock(&tickslock, "time");
80105a71:	68 74 7b 10 80       	push   $0x80107b74
80105a76:	68 60 53 11 80       	push   $0x80115360
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a7b:	66 a3 a0 55 11 80    	mov    %ax,0x801155a0
80105a81:	c1 e8 10             	shr    $0x10,%eax
80105a84:	66 a3 a6 55 11 80    	mov    %ax,0x801155a6
  initlock(&tickslock, "time");
80105a8a:	e8 21 ea ff ff       	call   801044b0 <initlock>
}
80105a8f:	83 c4 10             	add    $0x10,%esp
80105a92:	c9                   	leave  
80105a93:	c3                   	ret    
80105a94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105a9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105aa0 <idtinit>:

void
idtinit(void)
{
80105aa0:	55                   	push   %ebp
  pd[0] = size-1;
80105aa1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105aa6:	89 e5                	mov    %esp,%ebp
80105aa8:	83 ec 10             	sub    $0x10,%esp
80105aab:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105aaf:	b8 a0 53 11 80       	mov    $0x801153a0,%eax
80105ab4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105ab8:	c1 e8 10             	shr    $0x10,%eax
80105abb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105abf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105ac2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105ac5:	c9                   	leave  
80105ac6:	c3                   	ret    
80105ac7:	89 f6                	mov    %esi,%esi
80105ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ad0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	57                   	push   %edi
80105ad4:	56                   	push   %esi
80105ad5:	53                   	push   %ebx
80105ad6:	83 ec 1c             	sub    $0x1c,%esp
80105ad9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105adc:	8b 47 30             	mov    0x30(%edi),%eax
80105adf:	83 f8 40             	cmp    $0x40,%eax
80105ae2:	0f 84 f0 00 00 00    	je     80105bd8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105ae8:	83 e8 20             	sub    $0x20,%eax
80105aeb:	83 f8 1f             	cmp    $0x1f,%eax
80105aee:	77 10                	ja     80105b00 <trap+0x30>
80105af0:	ff 24 85 1c 7c 10 80 	jmp    *-0x7fef83e4(,%eax,4)
80105af7:	89 f6                	mov    %esi,%esi
80105af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105b00:	e8 fb dc ff ff       	call   80103800 <myproc>
80105b05:	85 c0                	test   %eax,%eax
80105b07:	8b 5f 38             	mov    0x38(%edi),%ebx
80105b0a:	0f 84 42 02 00 00    	je     80105d52 <trap+0x282>
80105b10:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105b14:	0f 84 38 02 00 00    	je     80105d52 <trap+0x282>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105b1a:	0f 20 d1             	mov    %cr2,%ecx
80105b1d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b20:	e8 bb dc ff ff       	call   801037e0 <cpuid>
80105b25:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105b28:	8b 47 34             	mov    0x34(%edi),%eax
80105b2b:	8b 77 30             	mov    0x30(%edi),%esi
80105b2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105b31:	e8 ca dc ff ff       	call   80103800 <myproc>
80105b36:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105b39:	e8 c2 dc ff ff       	call   80103800 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b3e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105b41:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105b44:	51                   	push   %ecx
80105b45:	53                   	push   %ebx
80105b46:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105b47:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b4a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105b4d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105b4e:	83 c2 70             	add    $0x70,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b51:	52                   	push   %edx
80105b52:	ff 70 10             	pushl  0x10(%eax)
80105b55:	68 d8 7b 10 80       	push   $0x80107bd8
80105b5a:	e8 01 ab ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105b5f:	83 c4 20             	add    $0x20,%esp
80105b62:	e8 99 dc ff ff       	call   80103800 <myproc>
80105b67:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b6e:	e8 8d dc ff ff       	call   80103800 <myproc>
80105b73:	85 c0                	test   %eax,%eax
80105b75:	74 1d                	je     80105b94 <trap+0xc4>
80105b77:	e8 84 dc ff ff       	call   80103800 <myproc>
80105b7c:	8b 50 28             	mov    0x28(%eax),%edx
80105b7f:	85 d2                	test   %edx,%edx
80105b81:	74 11                	je     80105b94 <trap+0xc4>
80105b83:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105b87:	83 e0 03             	and    $0x3,%eax
80105b8a:	66 83 f8 03          	cmp    $0x3,%ax
80105b8e:	0f 84 6c 01 00 00    	je     80105d00 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105b94:	e8 67 dc ff ff       	call   80103800 <myproc>
80105b99:	85 c0                	test   %eax,%eax
80105b9b:	74 0b                	je     80105ba8 <trap+0xd8>
80105b9d:	e8 5e dc ff ff       	call   80103800 <myproc>
80105ba2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105ba6:	74 68                	je     80105c10 <trap+0x140>
       else
        yield();
     }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ba8:	e8 53 dc ff ff       	call   80103800 <myproc>
80105bad:	85 c0                	test   %eax,%eax
80105baf:	74 19                	je     80105bca <trap+0xfa>
80105bb1:	e8 4a dc ff ff       	call   80103800 <myproc>
80105bb6:	8b 40 28             	mov    0x28(%eax),%eax
80105bb9:	85 c0                	test   %eax,%eax
80105bbb:	74 0d                	je     80105bca <trap+0xfa>
80105bbd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105bc1:	83 e0 03             	and    $0x3,%eax
80105bc4:	66 83 f8 03          	cmp    $0x3,%ax
80105bc8:	74 37                	je     80105c01 <trap+0x131>
    exit();
}
80105bca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bcd:	5b                   	pop    %ebx
80105bce:	5e                   	pop    %esi
80105bcf:	5f                   	pop    %edi
80105bd0:	5d                   	pop    %ebp
80105bd1:	c3                   	ret    
80105bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105bd8:	e8 23 dc ff ff       	call   80103800 <myproc>
80105bdd:	8b 58 28             	mov    0x28(%eax),%ebx
80105be0:	85 db                	test   %ebx,%ebx
80105be2:	0f 85 08 01 00 00    	jne    80105cf0 <trap+0x220>
    myproc()->tf = tf;
80105be8:	e8 13 dc ff ff       	call   80103800 <myproc>
80105bed:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105bf0:	e8 fb ee ff ff       	call   80104af0 <syscall>
    if(myproc()->killed)
80105bf5:	e8 06 dc ff ff       	call   80103800 <myproc>
80105bfa:	8b 48 28             	mov    0x28(%eax),%ecx
80105bfd:	85 c9                	test   %ecx,%ecx
80105bff:	74 c9                	je     80105bca <trap+0xfa>
}
80105c01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c04:	5b                   	pop    %ebx
80105c05:	5e                   	pop    %esi
80105c06:	5f                   	pop    %edi
80105c07:	5d                   	pop    %ebp
      exit();
80105c08:	e9 63 e0 ff ff       	jmp    80103c70 <exit>
80105c0d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105c10:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105c14:	75 92                	jne    80105ba8 <trap+0xd8>
       int current=myproc()->current_slice;
80105c16:	e8 e5 db ff ff       	call   80103800 <myproc>
80105c1b:	8b 98 8c 00 00 00    	mov    0x8c(%eax),%ebx
       if(current)
80105c21:	85 db                	test   %ebx,%ebx
80105c23:	0f 84 1f 01 00 00    	je     80105d48 <trap+0x278>
       myproc()->current_slice=current-1;
80105c29:	83 eb 01             	sub    $0x1,%ebx
80105c2c:	e8 cf db ff ff       	call   80103800 <myproc>
80105c31:	89 98 8c 00 00 00    	mov    %ebx,0x8c(%eax)
80105c37:	e9 6c ff ff ff       	jmp    80105ba8 <trap+0xd8>
80105c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105c40:	e8 9b db ff ff       	call   801037e0 <cpuid>
80105c45:	85 c0                	test   %eax,%eax
80105c47:	0f 84 c3 00 00 00    	je     80105d10 <trap+0x240>
    lapiceoi();
80105c4d:	e8 0e cb ff ff       	call   80102760 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c52:	e8 a9 db ff ff       	call   80103800 <myproc>
80105c57:	85 c0                	test   %eax,%eax
80105c59:	0f 85 18 ff ff ff    	jne    80105b77 <trap+0xa7>
80105c5f:	e9 30 ff ff ff       	jmp    80105b94 <trap+0xc4>
80105c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105c68:	e8 b3 c9 ff ff       	call   80102620 <kbdintr>
    lapiceoi();
80105c6d:	e8 ee ca ff ff       	call   80102760 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c72:	e8 89 db ff ff       	call   80103800 <myproc>
80105c77:	85 c0                	test   %eax,%eax
80105c79:	0f 85 f8 fe ff ff    	jne    80105b77 <trap+0xa7>
80105c7f:	e9 10 ff ff ff       	jmp    80105b94 <trap+0xc4>
80105c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105c88:	e8 63 02 00 00       	call   80105ef0 <uartintr>
    lapiceoi();
80105c8d:	e8 ce ca ff ff       	call   80102760 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c92:	e8 69 db ff ff       	call   80103800 <myproc>
80105c97:	85 c0                	test   %eax,%eax
80105c99:	0f 85 d8 fe ff ff    	jne    80105b77 <trap+0xa7>
80105c9f:	e9 f0 fe ff ff       	jmp    80105b94 <trap+0xc4>
80105ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ca8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105cac:	8b 77 38             	mov    0x38(%edi),%esi
80105caf:	e8 2c db ff ff       	call   801037e0 <cpuid>
80105cb4:	56                   	push   %esi
80105cb5:	53                   	push   %ebx
80105cb6:	50                   	push   %eax
80105cb7:	68 80 7b 10 80       	push   $0x80107b80
80105cbc:	e8 9f a9 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105cc1:	e8 9a ca ff ff       	call   80102760 <lapiceoi>
    break;
80105cc6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cc9:	e8 32 db ff ff       	call   80103800 <myproc>
80105cce:	85 c0                	test   %eax,%eax
80105cd0:	0f 85 a1 fe ff ff    	jne    80105b77 <trap+0xa7>
80105cd6:	e9 b9 fe ff ff       	jmp    80105b94 <trap+0xc4>
80105cdb:	90                   	nop
80105cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105ce0:	e8 ab c3 ff ff       	call   80102090 <ideintr>
80105ce5:	e9 63 ff ff ff       	jmp    80105c4d <trap+0x17d>
80105cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105cf0:	e8 7b df ff ff       	call   80103c70 <exit>
80105cf5:	e9 ee fe ff ff       	jmp    80105be8 <trap+0x118>
80105cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105d00:	e8 6b df ff ff       	call   80103c70 <exit>
80105d05:	e9 8a fe ff ff       	jmp    80105b94 <trap+0xc4>
80105d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105d10:	83 ec 0c             	sub    $0xc,%esp
80105d13:	68 60 53 11 80       	push   $0x80115360
80105d18:	e8 d3 e8 ff ff       	call   801045f0 <acquire>
      wakeup(&ticks);
80105d1d:	c7 04 24 a0 5b 11 80 	movl   $0x80115ba0,(%esp)
      ticks++;
80105d24:	83 05 a0 5b 11 80 01 	addl   $0x1,0x80115ba0
      wakeup(&ticks);
80105d2b:	e8 80 e2 ff ff       	call   80103fb0 <wakeup>
      release(&tickslock);
80105d30:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
80105d37:	e8 74 e9 ff ff       	call   801046b0 <release>
80105d3c:	83 c4 10             	add    $0x10,%esp
80105d3f:	e9 09 ff ff ff       	jmp    80105c4d <trap+0x17d>
80105d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        yield();
80105d48:	e8 53 e0 ff ff       	call   80103da0 <yield>
80105d4d:	e9 56 fe ff ff       	jmp    80105ba8 <trap+0xd8>
80105d52:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105d55:	e8 86 da ff ff       	call   801037e0 <cpuid>
80105d5a:	83 ec 0c             	sub    $0xc,%esp
80105d5d:	56                   	push   %esi
80105d5e:	53                   	push   %ebx
80105d5f:	50                   	push   %eax
80105d60:	ff 77 30             	pushl  0x30(%edi)
80105d63:	68 a4 7b 10 80       	push   $0x80107ba4
80105d68:	e8 f3 a8 ff ff       	call   80100660 <cprintf>
      panic("trap");
80105d6d:	83 c4 14             	add    $0x14,%esp
80105d70:	68 79 7b 10 80       	push   $0x80107b79
80105d75:	e8 16 a6 ff ff       	call   80100390 <panic>
80105d7a:	66 90                	xchg   %ax,%ax
80105d7c:	66 90                	xchg   %ax,%ax
80105d7e:	66 90                	xchg   %ax,%ax

80105d80 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105d80:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105d85:	55                   	push   %ebp
80105d86:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105d88:	85 c0                	test   %eax,%eax
80105d8a:	74 1c                	je     80105da8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d8c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d91:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105d92:	a8 01                	test   $0x1,%al
80105d94:	74 12                	je     80105da8 <uartgetc+0x28>
80105d96:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d9b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105d9c:	0f b6 c0             	movzbl %al,%eax
}
80105d9f:	5d                   	pop    %ebp
80105da0:	c3                   	ret    
80105da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105da8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dad:	5d                   	pop    %ebp
80105dae:	c3                   	ret    
80105daf:	90                   	nop

80105db0 <uartputc.part.0>:
uartputc(int c)
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	57                   	push   %edi
80105db4:	56                   	push   %esi
80105db5:	53                   	push   %ebx
80105db6:	89 c7                	mov    %eax,%edi
80105db8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105dbd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105dc2:	83 ec 0c             	sub    $0xc,%esp
80105dc5:	eb 1b                	jmp    80105de2 <uartputc.part.0+0x32>
80105dc7:	89 f6                	mov    %esi,%esi
80105dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105dd0:	83 ec 0c             	sub    $0xc,%esp
80105dd3:	6a 0a                	push   $0xa
80105dd5:	e8 a6 c9 ff ff       	call   80102780 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105dda:	83 c4 10             	add    $0x10,%esp
80105ddd:	83 eb 01             	sub    $0x1,%ebx
80105de0:	74 07                	je     80105de9 <uartputc.part.0+0x39>
80105de2:	89 f2                	mov    %esi,%edx
80105de4:	ec                   	in     (%dx),%al
80105de5:	a8 20                	test   $0x20,%al
80105de7:	74 e7                	je     80105dd0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105de9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105dee:	89 f8                	mov    %edi,%eax
80105df0:	ee                   	out    %al,(%dx)
}
80105df1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105df4:	5b                   	pop    %ebx
80105df5:	5e                   	pop    %esi
80105df6:	5f                   	pop    %edi
80105df7:	5d                   	pop    %ebp
80105df8:	c3                   	ret    
80105df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e00 <uartinit>:
{
80105e00:	55                   	push   %ebp
80105e01:	31 c9                	xor    %ecx,%ecx
80105e03:	89 c8                	mov    %ecx,%eax
80105e05:	89 e5                	mov    %esp,%ebp
80105e07:	57                   	push   %edi
80105e08:	56                   	push   %esi
80105e09:	53                   	push   %ebx
80105e0a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105e0f:	89 da                	mov    %ebx,%edx
80105e11:	83 ec 0c             	sub    $0xc,%esp
80105e14:	ee                   	out    %al,(%dx)
80105e15:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105e1a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105e1f:	89 fa                	mov    %edi,%edx
80105e21:	ee                   	out    %al,(%dx)
80105e22:	b8 0c 00 00 00       	mov    $0xc,%eax
80105e27:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e2c:	ee                   	out    %al,(%dx)
80105e2d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105e32:	89 c8                	mov    %ecx,%eax
80105e34:	89 f2                	mov    %esi,%edx
80105e36:	ee                   	out    %al,(%dx)
80105e37:	b8 03 00 00 00       	mov    $0x3,%eax
80105e3c:	89 fa                	mov    %edi,%edx
80105e3e:	ee                   	out    %al,(%dx)
80105e3f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105e44:	89 c8                	mov    %ecx,%eax
80105e46:	ee                   	out    %al,(%dx)
80105e47:	b8 01 00 00 00       	mov    $0x1,%eax
80105e4c:	89 f2                	mov    %esi,%edx
80105e4e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e4f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e54:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105e55:	3c ff                	cmp    $0xff,%al
80105e57:	74 5a                	je     80105eb3 <uartinit+0xb3>
  uart = 1;
80105e59:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105e60:	00 00 00 
80105e63:	89 da                	mov    %ebx,%edx
80105e65:	ec                   	in     (%dx),%al
80105e66:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e6b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105e6c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105e6f:	bb 9c 7c 10 80       	mov    $0x80107c9c,%ebx
  ioapicenable(IRQ_COM1, 0);
80105e74:	6a 00                	push   $0x0
80105e76:	6a 04                	push   $0x4
80105e78:	e8 63 c4 ff ff       	call   801022e0 <ioapicenable>
80105e7d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105e80:	b8 78 00 00 00       	mov    $0x78,%eax
80105e85:	eb 13                	jmp    80105e9a <uartinit+0x9a>
80105e87:	89 f6                	mov    %esi,%esi
80105e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105e90:	83 c3 01             	add    $0x1,%ebx
80105e93:	0f be 03             	movsbl (%ebx),%eax
80105e96:	84 c0                	test   %al,%al
80105e98:	74 19                	je     80105eb3 <uartinit+0xb3>
  if(!uart)
80105e9a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105ea0:	85 d2                	test   %edx,%edx
80105ea2:	74 ec                	je     80105e90 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105ea4:	83 c3 01             	add    $0x1,%ebx
80105ea7:	e8 04 ff ff ff       	call   80105db0 <uartputc.part.0>
80105eac:	0f be 03             	movsbl (%ebx),%eax
80105eaf:	84 c0                	test   %al,%al
80105eb1:	75 e7                	jne    80105e9a <uartinit+0x9a>
}
80105eb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105eb6:	5b                   	pop    %ebx
80105eb7:	5e                   	pop    %esi
80105eb8:	5f                   	pop    %edi
80105eb9:	5d                   	pop    %ebp
80105eba:	c3                   	ret    
80105ebb:	90                   	nop
80105ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ec0 <uartputc>:
  if(!uart)
80105ec0:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105ec6:	55                   	push   %ebp
80105ec7:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105ec9:	85 d2                	test   %edx,%edx
{
80105ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105ece:	74 10                	je     80105ee0 <uartputc+0x20>
}
80105ed0:	5d                   	pop    %ebp
80105ed1:	e9 da fe ff ff       	jmp    80105db0 <uartputc.part.0>
80105ed6:	8d 76 00             	lea    0x0(%esi),%esi
80105ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105ee0:	5d                   	pop    %ebp
80105ee1:	c3                   	ret    
80105ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ef0 <uartintr>:

void
uartintr(void)
{
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105ef6:	68 80 5d 10 80       	push   $0x80105d80
80105efb:	e8 10 a9 ff ff       	call   80100810 <consoleintr>
}
80105f00:	83 c4 10             	add    $0x10,%esp
80105f03:	c9                   	leave  
80105f04:	c3                   	ret    

80105f05 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105f05:	6a 00                	push   $0x0
  pushl $0
80105f07:	6a 00                	push   $0x0
  jmp alltraps
80105f09:	e9 eb fa ff ff       	jmp    801059f9 <alltraps>

80105f0e <vector1>:
.globl vector1
vector1:
  pushl $0
80105f0e:	6a 00                	push   $0x0
  pushl $1
80105f10:	6a 01                	push   $0x1
  jmp alltraps
80105f12:	e9 e2 fa ff ff       	jmp    801059f9 <alltraps>

80105f17 <vector2>:
.globl vector2
vector2:
  pushl $0
80105f17:	6a 00                	push   $0x0
  pushl $2
80105f19:	6a 02                	push   $0x2
  jmp alltraps
80105f1b:	e9 d9 fa ff ff       	jmp    801059f9 <alltraps>

80105f20 <vector3>:
.globl vector3
vector3:
  pushl $0
80105f20:	6a 00                	push   $0x0
  pushl $3
80105f22:	6a 03                	push   $0x3
  jmp alltraps
80105f24:	e9 d0 fa ff ff       	jmp    801059f9 <alltraps>

80105f29 <vector4>:
.globl vector4
vector4:
  pushl $0
80105f29:	6a 00                	push   $0x0
  pushl $4
80105f2b:	6a 04                	push   $0x4
  jmp alltraps
80105f2d:	e9 c7 fa ff ff       	jmp    801059f9 <alltraps>

80105f32 <vector5>:
.globl vector5
vector5:
  pushl $0
80105f32:	6a 00                	push   $0x0
  pushl $5
80105f34:	6a 05                	push   $0x5
  jmp alltraps
80105f36:	e9 be fa ff ff       	jmp    801059f9 <alltraps>

80105f3b <vector6>:
.globl vector6
vector6:
  pushl $0
80105f3b:	6a 00                	push   $0x0
  pushl $6
80105f3d:	6a 06                	push   $0x6
  jmp alltraps
80105f3f:	e9 b5 fa ff ff       	jmp    801059f9 <alltraps>

80105f44 <vector7>:
.globl vector7
vector7:
  pushl $0
80105f44:	6a 00                	push   $0x0
  pushl $7
80105f46:	6a 07                	push   $0x7
  jmp alltraps
80105f48:	e9 ac fa ff ff       	jmp    801059f9 <alltraps>

80105f4d <vector8>:
.globl vector8
vector8:
  pushl $8
80105f4d:	6a 08                	push   $0x8
  jmp alltraps
80105f4f:	e9 a5 fa ff ff       	jmp    801059f9 <alltraps>

80105f54 <vector9>:
.globl vector9
vector9:
  pushl $0
80105f54:	6a 00                	push   $0x0
  pushl $9
80105f56:	6a 09                	push   $0x9
  jmp alltraps
80105f58:	e9 9c fa ff ff       	jmp    801059f9 <alltraps>

80105f5d <vector10>:
.globl vector10
vector10:
  pushl $10
80105f5d:	6a 0a                	push   $0xa
  jmp alltraps
80105f5f:	e9 95 fa ff ff       	jmp    801059f9 <alltraps>

80105f64 <vector11>:
.globl vector11
vector11:
  pushl $11
80105f64:	6a 0b                	push   $0xb
  jmp alltraps
80105f66:	e9 8e fa ff ff       	jmp    801059f9 <alltraps>

80105f6b <vector12>:
.globl vector12
vector12:
  pushl $12
80105f6b:	6a 0c                	push   $0xc
  jmp alltraps
80105f6d:	e9 87 fa ff ff       	jmp    801059f9 <alltraps>

80105f72 <vector13>:
.globl vector13
vector13:
  pushl $13
80105f72:	6a 0d                	push   $0xd
  jmp alltraps
80105f74:	e9 80 fa ff ff       	jmp    801059f9 <alltraps>

80105f79 <vector14>:
.globl vector14
vector14:
  pushl $14
80105f79:	6a 0e                	push   $0xe
  jmp alltraps
80105f7b:	e9 79 fa ff ff       	jmp    801059f9 <alltraps>

80105f80 <vector15>:
.globl vector15
vector15:
  pushl $0
80105f80:	6a 00                	push   $0x0
  pushl $15
80105f82:	6a 0f                	push   $0xf
  jmp alltraps
80105f84:	e9 70 fa ff ff       	jmp    801059f9 <alltraps>

80105f89 <vector16>:
.globl vector16
vector16:
  pushl $0
80105f89:	6a 00                	push   $0x0
  pushl $16
80105f8b:	6a 10                	push   $0x10
  jmp alltraps
80105f8d:	e9 67 fa ff ff       	jmp    801059f9 <alltraps>

80105f92 <vector17>:
.globl vector17
vector17:
  pushl $17
80105f92:	6a 11                	push   $0x11
  jmp alltraps
80105f94:	e9 60 fa ff ff       	jmp    801059f9 <alltraps>

80105f99 <vector18>:
.globl vector18
vector18:
  pushl $0
80105f99:	6a 00                	push   $0x0
  pushl $18
80105f9b:	6a 12                	push   $0x12
  jmp alltraps
80105f9d:	e9 57 fa ff ff       	jmp    801059f9 <alltraps>

80105fa2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105fa2:	6a 00                	push   $0x0
  pushl $19
80105fa4:	6a 13                	push   $0x13
  jmp alltraps
80105fa6:	e9 4e fa ff ff       	jmp    801059f9 <alltraps>

80105fab <vector20>:
.globl vector20
vector20:
  pushl $0
80105fab:	6a 00                	push   $0x0
  pushl $20
80105fad:	6a 14                	push   $0x14
  jmp alltraps
80105faf:	e9 45 fa ff ff       	jmp    801059f9 <alltraps>

80105fb4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105fb4:	6a 00                	push   $0x0
  pushl $21
80105fb6:	6a 15                	push   $0x15
  jmp alltraps
80105fb8:	e9 3c fa ff ff       	jmp    801059f9 <alltraps>

80105fbd <vector22>:
.globl vector22
vector22:
  pushl $0
80105fbd:	6a 00                	push   $0x0
  pushl $22
80105fbf:	6a 16                	push   $0x16
  jmp alltraps
80105fc1:	e9 33 fa ff ff       	jmp    801059f9 <alltraps>

80105fc6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105fc6:	6a 00                	push   $0x0
  pushl $23
80105fc8:	6a 17                	push   $0x17
  jmp alltraps
80105fca:	e9 2a fa ff ff       	jmp    801059f9 <alltraps>

80105fcf <vector24>:
.globl vector24
vector24:
  pushl $0
80105fcf:	6a 00                	push   $0x0
  pushl $24
80105fd1:	6a 18                	push   $0x18
  jmp alltraps
80105fd3:	e9 21 fa ff ff       	jmp    801059f9 <alltraps>

80105fd8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105fd8:	6a 00                	push   $0x0
  pushl $25
80105fda:	6a 19                	push   $0x19
  jmp alltraps
80105fdc:	e9 18 fa ff ff       	jmp    801059f9 <alltraps>

80105fe1 <vector26>:
.globl vector26
vector26:
  pushl $0
80105fe1:	6a 00                	push   $0x0
  pushl $26
80105fe3:	6a 1a                	push   $0x1a
  jmp alltraps
80105fe5:	e9 0f fa ff ff       	jmp    801059f9 <alltraps>

80105fea <vector27>:
.globl vector27
vector27:
  pushl $0
80105fea:	6a 00                	push   $0x0
  pushl $27
80105fec:	6a 1b                	push   $0x1b
  jmp alltraps
80105fee:	e9 06 fa ff ff       	jmp    801059f9 <alltraps>

80105ff3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105ff3:	6a 00                	push   $0x0
  pushl $28
80105ff5:	6a 1c                	push   $0x1c
  jmp alltraps
80105ff7:	e9 fd f9 ff ff       	jmp    801059f9 <alltraps>

80105ffc <vector29>:
.globl vector29
vector29:
  pushl $0
80105ffc:	6a 00                	push   $0x0
  pushl $29
80105ffe:	6a 1d                	push   $0x1d
  jmp alltraps
80106000:	e9 f4 f9 ff ff       	jmp    801059f9 <alltraps>

80106005 <vector30>:
.globl vector30
vector30:
  pushl $0
80106005:	6a 00                	push   $0x0
  pushl $30
80106007:	6a 1e                	push   $0x1e
  jmp alltraps
80106009:	e9 eb f9 ff ff       	jmp    801059f9 <alltraps>

8010600e <vector31>:
.globl vector31
vector31:
  pushl $0
8010600e:	6a 00                	push   $0x0
  pushl $31
80106010:	6a 1f                	push   $0x1f
  jmp alltraps
80106012:	e9 e2 f9 ff ff       	jmp    801059f9 <alltraps>

80106017 <vector32>:
.globl vector32
vector32:
  pushl $0
80106017:	6a 00                	push   $0x0
  pushl $32
80106019:	6a 20                	push   $0x20
  jmp alltraps
8010601b:	e9 d9 f9 ff ff       	jmp    801059f9 <alltraps>

80106020 <vector33>:
.globl vector33
vector33:
  pushl $0
80106020:	6a 00                	push   $0x0
  pushl $33
80106022:	6a 21                	push   $0x21
  jmp alltraps
80106024:	e9 d0 f9 ff ff       	jmp    801059f9 <alltraps>

80106029 <vector34>:
.globl vector34
vector34:
  pushl $0
80106029:	6a 00                	push   $0x0
  pushl $34
8010602b:	6a 22                	push   $0x22
  jmp alltraps
8010602d:	e9 c7 f9 ff ff       	jmp    801059f9 <alltraps>

80106032 <vector35>:
.globl vector35
vector35:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $35
80106034:	6a 23                	push   $0x23
  jmp alltraps
80106036:	e9 be f9 ff ff       	jmp    801059f9 <alltraps>

8010603b <vector36>:
.globl vector36
vector36:
  pushl $0
8010603b:	6a 00                	push   $0x0
  pushl $36
8010603d:	6a 24                	push   $0x24
  jmp alltraps
8010603f:	e9 b5 f9 ff ff       	jmp    801059f9 <alltraps>

80106044 <vector37>:
.globl vector37
vector37:
  pushl $0
80106044:	6a 00                	push   $0x0
  pushl $37
80106046:	6a 25                	push   $0x25
  jmp alltraps
80106048:	e9 ac f9 ff ff       	jmp    801059f9 <alltraps>

8010604d <vector38>:
.globl vector38
vector38:
  pushl $0
8010604d:	6a 00                	push   $0x0
  pushl $38
8010604f:	6a 26                	push   $0x26
  jmp alltraps
80106051:	e9 a3 f9 ff ff       	jmp    801059f9 <alltraps>

80106056 <vector39>:
.globl vector39
vector39:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $39
80106058:	6a 27                	push   $0x27
  jmp alltraps
8010605a:	e9 9a f9 ff ff       	jmp    801059f9 <alltraps>

8010605f <vector40>:
.globl vector40
vector40:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $40
80106061:	6a 28                	push   $0x28
  jmp alltraps
80106063:	e9 91 f9 ff ff       	jmp    801059f9 <alltraps>

80106068 <vector41>:
.globl vector41
vector41:
  pushl $0
80106068:	6a 00                	push   $0x0
  pushl $41
8010606a:	6a 29                	push   $0x29
  jmp alltraps
8010606c:	e9 88 f9 ff ff       	jmp    801059f9 <alltraps>

80106071 <vector42>:
.globl vector42
vector42:
  pushl $0
80106071:	6a 00                	push   $0x0
  pushl $42
80106073:	6a 2a                	push   $0x2a
  jmp alltraps
80106075:	e9 7f f9 ff ff       	jmp    801059f9 <alltraps>

8010607a <vector43>:
.globl vector43
vector43:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $43
8010607c:	6a 2b                	push   $0x2b
  jmp alltraps
8010607e:	e9 76 f9 ff ff       	jmp    801059f9 <alltraps>

80106083 <vector44>:
.globl vector44
vector44:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $44
80106085:	6a 2c                	push   $0x2c
  jmp alltraps
80106087:	e9 6d f9 ff ff       	jmp    801059f9 <alltraps>

8010608c <vector45>:
.globl vector45
vector45:
  pushl $0
8010608c:	6a 00                	push   $0x0
  pushl $45
8010608e:	6a 2d                	push   $0x2d
  jmp alltraps
80106090:	e9 64 f9 ff ff       	jmp    801059f9 <alltraps>

80106095 <vector46>:
.globl vector46
vector46:
  pushl $0
80106095:	6a 00                	push   $0x0
  pushl $46
80106097:	6a 2e                	push   $0x2e
  jmp alltraps
80106099:	e9 5b f9 ff ff       	jmp    801059f9 <alltraps>

8010609e <vector47>:
.globl vector47
vector47:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $47
801060a0:	6a 2f                	push   $0x2f
  jmp alltraps
801060a2:	e9 52 f9 ff ff       	jmp    801059f9 <alltraps>

801060a7 <vector48>:
.globl vector48
vector48:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $48
801060a9:	6a 30                	push   $0x30
  jmp alltraps
801060ab:	e9 49 f9 ff ff       	jmp    801059f9 <alltraps>

801060b0 <vector49>:
.globl vector49
vector49:
  pushl $0
801060b0:	6a 00                	push   $0x0
  pushl $49
801060b2:	6a 31                	push   $0x31
  jmp alltraps
801060b4:	e9 40 f9 ff ff       	jmp    801059f9 <alltraps>

801060b9 <vector50>:
.globl vector50
vector50:
  pushl $0
801060b9:	6a 00                	push   $0x0
  pushl $50
801060bb:	6a 32                	push   $0x32
  jmp alltraps
801060bd:	e9 37 f9 ff ff       	jmp    801059f9 <alltraps>

801060c2 <vector51>:
.globl vector51
vector51:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $51
801060c4:	6a 33                	push   $0x33
  jmp alltraps
801060c6:	e9 2e f9 ff ff       	jmp    801059f9 <alltraps>

801060cb <vector52>:
.globl vector52
vector52:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $52
801060cd:	6a 34                	push   $0x34
  jmp alltraps
801060cf:	e9 25 f9 ff ff       	jmp    801059f9 <alltraps>

801060d4 <vector53>:
.globl vector53
vector53:
  pushl $0
801060d4:	6a 00                	push   $0x0
  pushl $53
801060d6:	6a 35                	push   $0x35
  jmp alltraps
801060d8:	e9 1c f9 ff ff       	jmp    801059f9 <alltraps>

801060dd <vector54>:
.globl vector54
vector54:
  pushl $0
801060dd:	6a 00                	push   $0x0
  pushl $54
801060df:	6a 36                	push   $0x36
  jmp alltraps
801060e1:	e9 13 f9 ff ff       	jmp    801059f9 <alltraps>

801060e6 <vector55>:
.globl vector55
vector55:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $55
801060e8:	6a 37                	push   $0x37
  jmp alltraps
801060ea:	e9 0a f9 ff ff       	jmp    801059f9 <alltraps>

801060ef <vector56>:
.globl vector56
vector56:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $56
801060f1:	6a 38                	push   $0x38
  jmp alltraps
801060f3:	e9 01 f9 ff ff       	jmp    801059f9 <alltraps>

801060f8 <vector57>:
.globl vector57
vector57:
  pushl $0
801060f8:	6a 00                	push   $0x0
  pushl $57
801060fa:	6a 39                	push   $0x39
  jmp alltraps
801060fc:	e9 f8 f8 ff ff       	jmp    801059f9 <alltraps>

80106101 <vector58>:
.globl vector58
vector58:
  pushl $0
80106101:	6a 00                	push   $0x0
  pushl $58
80106103:	6a 3a                	push   $0x3a
  jmp alltraps
80106105:	e9 ef f8 ff ff       	jmp    801059f9 <alltraps>

8010610a <vector59>:
.globl vector59
vector59:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $59
8010610c:	6a 3b                	push   $0x3b
  jmp alltraps
8010610e:	e9 e6 f8 ff ff       	jmp    801059f9 <alltraps>

80106113 <vector60>:
.globl vector60
vector60:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $60
80106115:	6a 3c                	push   $0x3c
  jmp alltraps
80106117:	e9 dd f8 ff ff       	jmp    801059f9 <alltraps>

8010611c <vector61>:
.globl vector61
vector61:
  pushl $0
8010611c:	6a 00                	push   $0x0
  pushl $61
8010611e:	6a 3d                	push   $0x3d
  jmp alltraps
80106120:	e9 d4 f8 ff ff       	jmp    801059f9 <alltraps>

80106125 <vector62>:
.globl vector62
vector62:
  pushl $0
80106125:	6a 00                	push   $0x0
  pushl $62
80106127:	6a 3e                	push   $0x3e
  jmp alltraps
80106129:	e9 cb f8 ff ff       	jmp    801059f9 <alltraps>

8010612e <vector63>:
.globl vector63
vector63:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $63
80106130:	6a 3f                	push   $0x3f
  jmp alltraps
80106132:	e9 c2 f8 ff ff       	jmp    801059f9 <alltraps>

80106137 <vector64>:
.globl vector64
vector64:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $64
80106139:	6a 40                	push   $0x40
  jmp alltraps
8010613b:	e9 b9 f8 ff ff       	jmp    801059f9 <alltraps>

80106140 <vector65>:
.globl vector65
vector65:
  pushl $0
80106140:	6a 00                	push   $0x0
  pushl $65
80106142:	6a 41                	push   $0x41
  jmp alltraps
80106144:	e9 b0 f8 ff ff       	jmp    801059f9 <alltraps>

80106149 <vector66>:
.globl vector66
vector66:
  pushl $0
80106149:	6a 00                	push   $0x0
  pushl $66
8010614b:	6a 42                	push   $0x42
  jmp alltraps
8010614d:	e9 a7 f8 ff ff       	jmp    801059f9 <alltraps>

80106152 <vector67>:
.globl vector67
vector67:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $67
80106154:	6a 43                	push   $0x43
  jmp alltraps
80106156:	e9 9e f8 ff ff       	jmp    801059f9 <alltraps>

8010615b <vector68>:
.globl vector68
vector68:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $68
8010615d:	6a 44                	push   $0x44
  jmp alltraps
8010615f:	e9 95 f8 ff ff       	jmp    801059f9 <alltraps>

80106164 <vector69>:
.globl vector69
vector69:
  pushl $0
80106164:	6a 00                	push   $0x0
  pushl $69
80106166:	6a 45                	push   $0x45
  jmp alltraps
80106168:	e9 8c f8 ff ff       	jmp    801059f9 <alltraps>

8010616d <vector70>:
.globl vector70
vector70:
  pushl $0
8010616d:	6a 00                	push   $0x0
  pushl $70
8010616f:	6a 46                	push   $0x46
  jmp alltraps
80106171:	e9 83 f8 ff ff       	jmp    801059f9 <alltraps>

80106176 <vector71>:
.globl vector71
vector71:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $71
80106178:	6a 47                	push   $0x47
  jmp alltraps
8010617a:	e9 7a f8 ff ff       	jmp    801059f9 <alltraps>

8010617f <vector72>:
.globl vector72
vector72:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $72
80106181:	6a 48                	push   $0x48
  jmp alltraps
80106183:	e9 71 f8 ff ff       	jmp    801059f9 <alltraps>

80106188 <vector73>:
.globl vector73
vector73:
  pushl $0
80106188:	6a 00                	push   $0x0
  pushl $73
8010618a:	6a 49                	push   $0x49
  jmp alltraps
8010618c:	e9 68 f8 ff ff       	jmp    801059f9 <alltraps>

80106191 <vector74>:
.globl vector74
vector74:
  pushl $0
80106191:	6a 00                	push   $0x0
  pushl $74
80106193:	6a 4a                	push   $0x4a
  jmp alltraps
80106195:	e9 5f f8 ff ff       	jmp    801059f9 <alltraps>

8010619a <vector75>:
.globl vector75
vector75:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $75
8010619c:	6a 4b                	push   $0x4b
  jmp alltraps
8010619e:	e9 56 f8 ff ff       	jmp    801059f9 <alltraps>

801061a3 <vector76>:
.globl vector76
vector76:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $76
801061a5:	6a 4c                	push   $0x4c
  jmp alltraps
801061a7:	e9 4d f8 ff ff       	jmp    801059f9 <alltraps>

801061ac <vector77>:
.globl vector77
vector77:
  pushl $0
801061ac:	6a 00                	push   $0x0
  pushl $77
801061ae:	6a 4d                	push   $0x4d
  jmp alltraps
801061b0:	e9 44 f8 ff ff       	jmp    801059f9 <alltraps>

801061b5 <vector78>:
.globl vector78
vector78:
  pushl $0
801061b5:	6a 00                	push   $0x0
  pushl $78
801061b7:	6a 4e                	push   $0x4e
  jmp alltraps
801061b9:	e9 3b f8 ff ff       	jmp    801059f9 <alltraps>

801061be <vector79>:
.globl vector79
vector79:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $79
801061c0:	6a 4f                	push   $0x4f
  jmp alltraps
801061c2:	e9 32 f8 ff ff       	jmp    801059f9 <alltraps>

801061c7 <vector80>:
.globl vector80
vector80:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $80
801061c9:	6a 50                	push   $0x50
  jmp alltraps
801061cb:	e9 29 f8 ff ff       	jmp    801059f9 <alltraps>

801061d0 <vector81>:
.globl vector81
vector81:
  pushl $0
801061d0:	6a 00                	push   $0x0
  pushl $81
801061d2:	6a 51                	push   $0x51
  jmp alltraps
801061d4:	e9 20 f8 ff ff       	jmp    801059f9 <alltraps>

801061d9 <vector82>:
.globl vector82
vector82:
  pushl $0
801061d9:	6a 00                	push   $0x0
  pushl $82
801061db:	6a 52                	push   $0x52
  jmp alltraps
801061dd:	e9 17 f8 ff ff       	jmp    801059f9 <alltraps>

801061e2 <vector83>:
.globl vector83
vector83:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $83
801061e4:	6a 53                	push   $0x53
  jmp alltraps
801061e6:	e9 0e f8 ff ff       	jmp    801059f9 <alltraps>

801061eb <vector84>:
.globl vector84
vector84:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $84
801061ed:	6a 54                	push   $0x54
  jmp alltraps
801061ef:	e9 05 f8 ff ff       	jmp    801059f9 <alltraps>

801061f4 <vector85>:
.globl vector85
vector85:
  pushl $0
801061f4:	6a 00                	push   $0x0
  pushl $85
801061f6:	6a 55                	push   $0x55
  jmp alltraps
801061f8:	e9 fc f7 ff ff       	jmp    801059f9 <alltraps>

801061fd <vector86>:
.globl vector86
vector86:
  pushl $0
801061fd:	6a 00                	push   $0x0
  pushl $86
801061ff:	6a 56                	push   $0x56
  jmp alltraps
80106201:	e9 f3 f7 ff ff       	jmp    801059f9 <alltraps>

80106206 <vector87>:
.globl vector87
vector87:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $87
80106208:	6a 57                	push   $0x57
  jmp alltraps
8010620a:	e9 ea f7 ff ff       	jmp    801059f9 <alltraps>

8010620f <vector88>:
.globl vector88
vector88:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $88
80106211:	6a 58                	push   $0x58
  jmp alltraps
80106213:	e9 e1 f7 ff ff       	jmp    801059f9 <alltraps>

80106218 <vector89>:
.globl vector89
vector89:
  pushl $0
80106218:	6a 00                	push   $0x0
  pushl $89
8010621a:	6a 59                	push   $0x59
  jmp alltraps
8010621c:	e9 d8 f7 ff ff       	jmp    801059f9 <alltraps>

80106221 <vector90>:
.globl vector90
vector90:
  pushl $0
80106221:	6a 00                	push   $0x0
  pushl $90
80106223:	6a 5a                	push   $0x5a
  jmp alltraps
80106225:	e9 cf f7 ff ff       	jmp    801059f9 <alltraps>

8010622a <vector91>:
.globl vector91
vector91:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $91
8010622c:	6a 5b                	push   $0x5b
  jmp alltraps
8010622e:	e9 c6 f7 ff ff       	jmp    801059f9 <alltraps>

80106233 <vector92>:
.globl vector92
vector92:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $92
80106235:	6a 5c                	push   $0x5c
  jmp alltraps
80106237:	e9 bd f7 ff ff       	jmp    801059f9 <alltraps>

8010623c <vector93>:
.globl vector93
vector93:
  pushl $0
8010623c:	6a 00                	push   $0x0
  pushl $93
8010623e:	6a 5d                	push   $0x5d
  jmp alltraps
80106240:	e9 b4 f7 ff ff       	jmp    801059f9 <alltraps>

80106245 <vector94>:
.globl vector94
vector94:
  pushl $0
80106245:	6a 00                	push   $0x0
  pushl $94
80106247:	6a 5e                	push   $0x5e
  jmp alltraps
80106249:	e9 ab f7 ff ff       	jmp    801059f9 <alltraps>

8010624e <vector95>:
.globl vector95
vector95:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $95
80106250:	6a 5f                	push   $0x5f
  jmp alltraps
80106252:	e9 a2 f7 ff ff       	jmp    801059f9 <alltraps>

80106257 <vector96>:
.globl vector96
vector96:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $96
80106259:	6a 60                	push   $0x60
  jmp alltraps
8010625b:	e9 99 f7 ff ff       	jmp    801059f9 <alltraps>

80106260 <vector97>:
.globl vector97
vector97:
  pushl $0
80106260:	6a 00                	push   $0x0
  pushl $97
80106262:	6a 61                	push   $0x61
  jmp alltraps
80106264:	e9 90 f7 ff ff       	jmp    801059f9 <alltraps>

80106269 <vector98>:
.globl vector98
vector98:
  pushl $0
80106269:	6a 00                	push   $0x0
  pushl $98
8010626b:	6a 62                	push   $0x62
  jmp alltraps
8010626d:	e9 87 f7 ff ff       	jmp    801059f9 <alltraps>

80106272 <vector99>:
.globl vector99
vector99:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $99
80106274:	6a 63                	push   $0x63
  jmp alltraps
80106276:	e9 7e f7 ff ff       	jmp    801059f9 <alltraps>

8010627b <vector100>:
.globl vector100
vector100:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $100
8010627d:	6a 64                	push   $0x64
  jmp alltraps
8010627f:	e9 75 f7 ff ff       	jmp    801059f9 <alltraps>

80106284 <vector101>:
.globl vector101
vector101:
  pushl $0
80106284:	6a 00                	push   $0x0
  pushl $101
80106286:	6a 65                	push   $0x65
  jmp alltraps
80106288:	e9 6c f7 ff ff       	jmp    801059f9 <alltraps>

8010628d <vector102>:
.globl vector102
vector102:
  pushl $0
8010628d:	6a 00                	push   $0x0
  pushl $102
8010628f:	6a 66                	push   $0x66
  jmp alltraps
80106291:	e9 63 f7 ff ff       	jmp    801059f9 <alltraps>

80106296 <vector103>:
.globl vector103
vector103:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $103
80106298:	6a 67                	push   $0x67
  jmp alltraps
8010629a:	e9 5a f7 ff ff       	jmp    801059f9 <alltraps>

8010629f <vector104>:
.globl vector104
vector104:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $104
801062a1:	6a 68                	push   $0x68
  jmp alltraps
801062a3:	e9 51 f7 ff ff       	jmp    801059f9 <alltraps>

801062a8 <vector105>:
.globl vector105
vector105:
  pushl $0
801062a8:	6a 00                	push   $0x0
  pushl $105
801062aa:	6a 69                	push   $0x69
  jmp alltraps
801062ac:	e9 48 f7 ff ff       	jmp    801059f9 <alltraps>

801062b1 <vector106>:
.globl vector106
vector106:
  pushl $0
801062b1:	6a 00                	push   $0x0
  pushl $106
801062b3:	6a 6a                	push   $0x6a
  jmp alltraps
801062b5:	e9 3f f7 ff ff       	jmp    801059f9 <alltraps>

801062ba <vector107>:
.globl vector107
vector107:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $107
801062bc:	6a 6b                	push   $0x6b
  jmp alltraps
801062be:	e9 36 f7 ff ff       	jmp    801059f9 <alltraps>

801062c3 <vector108>:
.globl vector108
vector108:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $108
801062c5:	6a 6c                	push   $0x6c
  jmp alltraps
801062c7:	e9 2d f7 ff ff       	jmp    801059f9 <alltraps>

801062cc <vector109>:
.globl vector109
vector109:
  pushl $0
801062cc:	6a 00                	push   $0x0
  pushl $109
801062ce:	6a 6d                	push   $0x6d
  jmp alltraps
801062d0:	e9 24 f7 ff ff       	jmp    801059f9 <alltraps>

801062d5 <vector110>:
.globl vector110
vector110:
  pushl $0
801062d5:	6a 00                	push   $0x0
  pushl $110
801062d7:	6a 6e                	push   $0x6e
  jmp alltraps
801062d9:	e9 1b f7 ff ff       	jmp    801059f9 <alltraps>

801062de <vector111>:
.globl vector111
vector111:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $111
801062e0:	6a 6f                	push   $0x6f
  jmp alltraps
801062e2:	e9 12 f7 ff ff       	jmp    801059f9 <alltraps>

801062e7 <vector112>:
.globl vector112
vector112:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $112
801062e9:	6a 70                	push   $0x70
  jmp alltraps
801062eb:	e9 09 f7 ff ff       	jmp    801059f9 <alltraps>

801062f0 <vector113>:
.globl vector113
vector113:
  pushl $0
801062f0:	6a 00                	push   $0x0
  pushl $113
801062f2:	6a 71                	push   $0x71
  jmp alltraps
801062f4:	e9 00 f7 ff ff       	jmp    801059f9 <alltraps>

801062f9 <vector114>:
.globl vector114
vector114:
  pushl $0
801062f9:	6a 00                	push   $0x0
  pushl $114
801062fb:	6a 72                	push   $0x72
  jmp alltraps
801062fd:	e9 f7 f6 ff ff       	jmp    801059f9 <alltraps>

80106302 <vector115>:
.globl vector115
vector115:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $115
80106304:	6a 73                	push   $0x73
  jmp alltraps
80106306:	e9 ee f6 ff ff       	jmp    801059f9 <alltraps>

8010630b <vector116>:
.globl vector116
vector116:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $116
8010630d:	6a 74                	push   $0x74
  jmp alltraps
8010630f:	e9 e5 f6 ff ff       	jmp    801059f9 <alltraps>

80106314 <vector117>:
.globl vector117
vector117:
  pushl $0
80106314:	6a 00                	push   $0x0
  pushl $117
80106316:	6a 75                	push   $0x75
  jmp alltraps
80106318:	e9 dc f6 ff ff       	jmp    801059f9 <alltraps>

8010631d <vector118>:
.globl vector118
vector118:
  pushl $0
8010631d:	6a 00                	push   $0x0
  pushl $118
8010631f:	6a 76                	push   $0x76
  jmp alltraps
80106321:	e9 d3 f6 ff ff       	jmp    801059f9 <alltraps>

80106326 <vector119>:
.globl vector119
vector119:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $119
80106328:	6a 77                	push   $0x77
  jmp alltraps
8010632a:	e9 ca f6 ff ff       	jmp    801059f9 <alltraps>

8010632f <vector120>:
.globl vector120
vector120:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $120
80106331:	6a 78                	push   $0x78
  jmp alltraps
80106333:	e9 c1 f6 ff ff       	jmp    801059f9 <alltraps>

80106338 <vector121>:
.globl vector121
vector121:
  pushl $0
80106338:	6a 00                	push   $0x0
  pushl $121
8010633a:	6a 79                	push   $0x79
  jmp alltraps
8010633c:	e9 b8 f6 ff ff       	jmp    801059f9 <alltraps>

80106341 <vector122>:
.globl vector122
vector122:
  pushl $0
80106341:	6a 00                	push   $0x0
  pushl $122
80106343:	6a 7a                	push   $0x7a
  jmp alltraps
80106345:	e9 af f6 ff ff       	jmp    801059f9 <alltraps>

8010634a <vector123>:
.globl vector123
vector123:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $123
8010634c:	6a 7b                	push   $0x7b
  jmp alltraps
8010634e:	e9 a6 f6 ff ff       	jmp    801059f9 <alltraps>

80106353 <vector124>:
.globl vector124
vector124:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $124
80106355:	6a 7c                	push   $0x7c
  jmp alltraps
80106357:	e9 9d f6 ff ff       	jmp    801059f9 <alltraps>

8010635c <vector125>:
.globl vector125
vector125:
  pushl $0
8010635c:	6a 00                	push   $0x0
  pushl $125
8010635e:	6a 7d                	push   $0x7d
  jmp alltraps
80106360:	e9 94 f6 ff ff       	jmp    801059f9 <alltraps>

80106365 <vector126>:
.globl vector126
vector126:
  pushl $0
80106365:	6a 00                	push   $0x0
  pushl $126
80106367:	6a 7e                	push   $0x7e
  jmp alltraps
80106369:	e9 8b f6 ff ff       	jmp    801059f9 <alltraps>

8010636e <vector127>:
.globl vector127
vector127:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $127
80106370:	6a 7f                	push   $0x7f
  jmp alltraps
80106372:	e9 82 f6 ff ff       	jmp    801059f9 <alltraps>

80106377 <vector128>:
.globl vector128
vector128:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $128
80106379:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010637e:	e9 76 f6 ff ff       	jmp    801059f9 <alltraps>

80106383 <vector129>:
.globl vector129
vector129:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $129
80106385:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010638a:	e9 6a f6 ff ff       	jmp    801059f9 <alltraps>

8010638f <vector130>:
.globl vector130
vector130:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $130
80106391:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106396:	e9 5e f6 ff ff       	jmp    801059f9 <alltraps>

8010639b <vector131>:
.globl vector131
vector131:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $131
8010639d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801063a2:	e9 52 f6 ff ff       	jmp    801059f9 <alltraps>

801063a7 <vector132>:
.globl vector132
vector132:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $132
801063a9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801063ae:	e9 46 f6 ff ff       	jmp    801059f9 <alltraps>

801063b3 <vector133>:
.globl vector133
vector133:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $133
801063b5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801063ba:	e9 3a f6 ff ff       	jmp    801059f9 <alltraps>

801063bf <vector134>:
.globl vector134
vector134:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $134
801063c1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801063c6:	e9 2e f6 ff ff       	jmp    801059f9 <alltraps>

801063cb <vector135>:
.globl vector135
vector135:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $135
801063cd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801063d2:	e9 22 f6 ff ff       	jmp    801059f9 <alltraps>

801063d7 <vector136>:
.globl vector136
vector136:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $136
801063d9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801063de:	e9 16 f6 ff ff       	jmp    801059f9 <alltraps>

801063e3 <vector137>:
.globl vector137
vector137:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $137
801063e5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801063ea:	e9 0a f6 ff ff       	jmp    801059f9 <alltraps>

801063ef <vector138>:
.globl vector138
vector138:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $138
801063f1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801063f6:	e9 fe f5 ff ff       	jmp    801059f9 <alltraps>

801063fb <vector139>:
.globl vector139
vector139:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $139
801063fd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106402:	e9 f2 f5 ff ff       	jmp    801059f9 <alltraps>

80106407 <vector140>:
.globl vector140
vector140:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $140
80106409:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010640e:	e9 e6 f5 ff ff       	jmp    801059f9 <alltraps>

80106413 <vector141>:
.globl vector141
vector141:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $141
80106415:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010641a:	e9 da f5 ff ff       	jmp    801059f9 <alltraps>

8010641f <vector142>:
.globl vector142
vector142:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $142
80106421:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106426:	e9 ce f5 ff ff       	jmp    801059f9 <alltraps>

8010642b <vector143>:
.globl vector143
vector143:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $143
8010642d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106432:	e9 c2 f5 ff ff       	jmp    801059f9 <alltraps>

80106437 <vector144>:
.globl vector144
vector144:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $144
80106439:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010643e:	e9 b6 f5 ff ff       	jmp    801059f9 <alltraps>

80106443 <vector145>:
.globl vector145
vector145:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $145
80106445:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010644a:	e9 aa f5 ff ff       	jmp    801059f9 <alltraps>

8010644f <vector146>:
.globl vector146
vector146:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $146
80106451:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106456:	e9 9e f5 ff ff       	jmp    801059f9 <alltraps>

8010645b <vector147>:
.globl vector147
vector147:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $147
8010645d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106462:	e9 92 f5 ff ff       	jmp    801059f9 <alltraps>

80106467 <vector148>:
.globl vector148
vector148:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $148
80106469:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010646e:	e9 86 f5 ff ff       	jmp    801059f9 <alltraps>

80106473 <vector149>:
.globl vector149
vector149:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $149
80106475:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010647a:	e9 7a f5 ff ff       	jmp    801059f9 <alltraps>

8010647f <vector150>:
.globl vector150
vector150:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $150
80106481:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106486:	e9 6e f5 ff ff       	jmp    801059f9 <alltraps>

8010648b <vector151>:
.globl vector151
vector151:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $151
8010648d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106492:	e9 62 f5 ff ff       	jmp    801059f9 <alltraps>

80106497 <vector152>:
.globl vector152
vector152:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $152
80106499:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010649e:	e9 56 f5 ff ff       	jmp    801059f9 <alltraps>

801064a3 <vector153>:
.globl vector153
vector153:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $153
801064a5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801064aa:	e9 4a f5 ff ff       	jmp    801059f9 <alltraps>

801064af <vector154>:
.globl vector154
vector154:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $154
801064b1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801064b6:	e9 3e f5 ff ff       	jmp    801059f9 <alltraps>

801064bb <vector155>:
.globl vector155
vector155:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $155
801064bd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801064c2:	e9 32 f5 ff ff       	jmp    801059f9 <alltraps>

801064c7 <vector156>:
.globl vector156
vector156:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $156
801064c9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801064ce:	e9 26 f5 ff ff       	jmp    801059f9 <alltraps>

801064d3 <vector157>:
.globl vector157
vector157:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $157
801064d5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801064da:	e9 1a f5 ff ff       	jmp    801059f9 <alltraps>

801064df <vector158>:
.globl vector158
vector158:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $158
801064e1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801064e6:	e9 0e f5 ff ff       	jmp    801059f9 <alltraps>

801064eb <vector159>:
.globl vector159
vector159:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $159
801064ed:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801064f2:	e9 02 f5 ff ff       	jmp    801059f9 <alltraps>

801064f7 <vector160>:
.globl vector160
vector160:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $160
801064f9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801064fe:	e9 f6 f4 ff ff       	jmp    801059f9 <alltraps>

80106503 <vector161>:
.globl vector161
vector161:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $161
80106505:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010650a:	e9 ea f4 ff ff       	jmp    801059f9 <alltraps>

8010650f <vector162>:
.globl vector162
vector162:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $162
80106511:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106516:	e9 de f4 ff ff       	jmp    801059f9 <alltraps>

8010651b <vector163>:
.globl vector163
vector163:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $163
8010651d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106522:	e9 d2 f4 ff ff       	jmp    801059f9 <alltraps>

80106527 <vector164>:
.globl vector164
vector164:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $164
80106529:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010652e:	e9 c6 f4 ff ff       	jmp    801059f9 <alltraps>

80106533 <vector165>:
.globl vector165
vector165:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $165
80106535:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010653a:	e9 ba f4 ff ff       	jmp    801059f9 <alltraps>

8010653f <vector166>:
.globl vector166
vector166:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $166
80106541:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106546:	e9 ae f4 ff ff       	jmp    801059f9 <alltraps>

8010654b <vector167>:
.globl vector167
vector167:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $167
8010654d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106552:	e9 a2 f4 ff ff       	jmp    801059f9 <alltraps>

80106557 <vector168>:
.globl vector168
vector168:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $168
80106559:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010655e:	e9 96 f4 ff ff       	jmp    801059f9 <alltraps>

80106563 <vector169>:
.globl vector169
vector169:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $169
80106565:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010656a:	e9 8a f4 ff ff       	jmp    801059f9 <alltraps>

8010656f <vector170>:
.globl vector170
vector170:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $170
80106571:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106576:	e9 7e f4 ff ff       	jmp    801059f9 <alltraps>

8010657b <vector171>:
.globl vector171
vector171:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $171
8010657d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106582:	e9 72 f4 ff ff       	jmp    801059f9 <alltraps>

80106587 <vector172>:
.globl vector172
vector172:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $172
80106589:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010658e:	e9 66 f4 ff ff       	jmp    801059f9 <alltraps>

80106593 <vector173>:
.globl vector173
vector173:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $173
80106595:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010659a:	e9 5a f4 ff ff       	jmp    801059f9 <alltraps>

8010659f <vector174>:
.globl vector174
vector174:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $174
801065a1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801065a6:	e9 4e f4 ff ff       	jmp    801059f9 <alltraps>

801065ab <vector175>:
.globl vector175
vector175:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $175
801065ad:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801065b2:	e9 42 f4 ff ff       	jmp    801059f9 <alltraps>

801065b7 <vector176>:
.globl vector176
vector176:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $176
801065b9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801065be:	e9 36 f4 ff ff       	jmp    801059f9 <alltraps>

801065c3 <vector177>:
.globl vector177
vector177:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $177
801065c5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801065ca:	e9 2a f4 ff ff       	jmp    801059f9 <alltraps>

801065cf <vector178>:
.globl vector178
vector178:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $178
801065d1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801065d6:	e9 1e f4 ff ff       	jmp    801059f9 <alltraps>

801065db <vector179>:
.globl vector179
vector179:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $179
801065dd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801065e2:	e9 12 f4 ff ff       	jmp    801059f9 <alltraps>

801065e7 <vector180>:
.globl vector180
vector180:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $180
801065e9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801065ee:	e9 06 f4 ff ff       	jmp    801059f9 <alltraps>

801065f3 <vector181>:
.globl vector181
vector181:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $181
801065f5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801065fa:	e9 fa f3 ff ff       	jmp    801059f9 <alltraps>

801065ff <vector182>:
.globl vector182
vector182:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $182
80106601:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106606:	e9 ee f3 ff ff       	jmp    801059f9 <alltraps>

8010660b <vector183>:
.globl vector183
vector183:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $183
8010660d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106612:	e9 e2 f3 ff ff       	jmp    801059f9 <alltraps>

80106617 <vector184>:
.globl vector184
vector184:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $184
80106619:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010661e:	e9 d6 f3 ff ff       	jmp    801059f9 <alltraps>

80106623 <vector185>:
.globl vector185
vector185:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $185
80106625:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010662a:	e9 ca f3 ff ff       	jmp    801059f9 <alltraps>

8010662f <vector186>:
.globl vector186
vector186:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $186
80106631:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106636:	e9 be f3 ff ff       	jmp    801059f9 <alltraps>

8010663b <vector187>:
.globl vector187
vector187:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $187
8010663d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106642:	e9 b2 f3 ff ff       	jmp    801059f9 <alltraps>

80106647 <vector188>:
.globl vector188
vector188:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $188
80106649:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010664e:	e9 a6 f3 ff ff       	jmp    801059f9 <alltraps>

80106653 <vector189>:
.globl vector189
vector189:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $189
80106655:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010665a:	e9 9a f3 ff ff       	jmp    801059f9 <alltraps>

8010665f <vector190>:
.globl vector190
vector190:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $190
80106661:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106666:	e9 8e f3 ff ff       	jmp    801059f9 <alltraps>

8010666b <vector191>:
.globl vector191
vector191:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $191
8010666d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106672:	e9 82 f3 ff ff       	jmp    801059f9 <alltraps>

80106677 <vector192>:
.globl vector192
vector192:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $192
80106679:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010667e:	e9 76 f3 ff ff       	jmp    801059f9 <alltraps>

80106683 <vector193>:
.globl vector193
vector193:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $193
80106685:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010668a:	e9 6a f3 ff ff       	jmp    801059f9 <alltraps>

8010668f <vector194>:
.globl vector194
vector194:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $194
80106691:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106696:	e9 5e f3 ff ff       	jmp    801059f9 <alltraps>

8010669b <vector195>:
.globl vector195
vector195:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $195
8010669d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801066a2:	e9 52 f3 ff ff       	jmp    801059f9 <alltraps>

801066a7 <vector196>:
.globl vector196
vector196:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $196
801066a9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801066ae:	e9 46 f3 ff ff       	jmp    801059f9 <alltraps>

801066b3 <vector197>:
.globl vector197
vector197:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $197
801066b5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801066ba:	e9 3a f3 ff ff       	jmp    801059f9 <alltraps>

801066bf <vector198>:
.globl vector198
vector198:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $198
801066c1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801066c6:	e9 2e f3 ff ff       	jmp    801059f9 <alltraps>

801066cb <vector199>:
.globl vector199
vector199:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $199
801066cd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801066d2:	e9 22 f3 ff ff       	jmp    801059f9 <alltraps>

801066d7 <vector200>:
.globl vector200
vector200:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $200
801066d9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801066de:	e9 16 f3 ff ff       	jmp    801059f9 <alltraps>

801066e3 <vector201>:
.globl vector201
vector201:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $201
801066e5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801066ea:	e9 0a f3 ff ff       	jmp    801059f9 <alltraps>

801066ef <vector202>:
.globl vector202
vector202:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $202
801066f1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801066f6:	e9 fe f2 ff ff       	jmp    801059f9 <alltraps>

801066fb <vector203>:
.globl vector203
vector203:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $203
801066fd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106702:	e9 f2 f2 ff ff       	jmp    801059f9 <alltraps>

80106707 <vector204>:
.globl vector204
vector204:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $204
80106709:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010670e:	e9 e6 f2 ff ff       	jmp    801059f9 <alltraps>

80106713 <vector205>:
.globl vector205
vector205:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $205
80106715:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010671a:	e9 da f2 ff ff       	jmp    801059f9 <alltraps>

8010671f <vector206>:
.globl vector206
vector206:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $206
80106721:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106726:	e9 ce f2 ff ff       	jmp    801059f9 <alltraps>

8010672b <vector207>:
.globl vector207
vector207:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $207
8010672d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106732:	e9 c2 f2 ff ff       	jmp    801059f9 <alltraps>

80106737 <vector208>:
.globl vector208
vector208:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $208
80106739:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010673e:	e9 b6 f2 ff ff       	jmp    801059f9 <alltraps>

80106743 <vector209>:
.globl vector209
vector209:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $209
80106745:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010674a:	e9 aa f2 ff ff       	jmp    801059f9 <alltraps>

8010674f <vector210>:
.globl vector210
vector210:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $210
80106751:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106756:	e9 9e f2 ff ff       	jmp    801059f9 <alltraps>

8010675b <vector211>:
.globl vector211
vector211:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $211
8010675d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106762:	e9 92 f2 ff ff       	jmp    801059f9 <alltraps>

80106767 <vector212>:
.globl vector212
vector212:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $212
80106769:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010676e:	e9 86 f2 ff ff       	jmp    801059f9 <alltraps>

80106773 <vector213>:
.globl vector213
vector213:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $213
80106775:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010677a:	e9 7a f2 ff ff       	jmp    801059f9 <alltraps>

8010677f <vector214>:
.globl vector214
vector214:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $214
80106781:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106786:	e9 6e f2 ff ff       	jmp    801059f9 <alltraps>

8010678b <vector215>:
.globl vector215
vector215:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $215
8010678d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106792:	e9 62 f2 ff ff       	jmp    801059f9 <alltraps>

80106797 <vector216>:
.globl vector216
vector216:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $216
80106799:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010679e:	e9 56 f2 ff ff       	jmp    801059f9 <alltraps>

801067a3 <vector217>:
.globl vector217
vector217:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $217
801067a5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801067aa:	e9 4a f2 ff ff       	jmp    801059f9 <alltraps>

801067af <vector218>:
.globl vector218
vector218:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $218
801067b1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801067b6:	e9 3e f2 ff ff       	jmp    801059f9 <alltraps>

801067bb <vector219>:
.globl vector219
vector219:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $219
801067bd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801067c2:	e9 32 f2 ff ff       	jmp    801059f9 <alltraps>

801067c7 <vector220>:
.globl vector220
vector220:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $220
801067c9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801067ce:	e9 26 f2 ff ff       	jmp    801059f9 <alltraps>

801067d3 <vector221>:
.globl vector221
vector221:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $221
801067d5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801067da:	e9 1a f2 ff ff       	jmp    801059f9 <alltraps>

801067df <vector222>:
.globl vector222
vector222:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $222
801067e1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801067e6:	e9 0e f2 ff ff       	jmp    801059f9 <alltraps>

801067eb <vector223>:
.globl vector223
vector223:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $223
801067ed:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801067f2:	e9 02 f2 ff ff       	jmp    801059f9 <alltraps>

801067f7 <vector224>:
.globl vector224
vector224:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $224
801067f9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801067fe:	e9 f6 f1 ff ff       	jmp    801059f9 <alltraps>

80106803 <vector225>:
.globl vector225
vector225:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $225
80106805:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010680a:	e9 ea f1 ff ff       	jmp    801059f9 <alltraps>

8010680f <vector226>:
.globl vector226
vector226:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $226
80106811:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106816:	e9 de f1 ff ff       	jmp    801059f9 <alltraps>

8010681b <vector227>:
.globl vector227
vector227:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $227
8010681d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106822:	e9 d2 f1 ff ff       	jmp    801059f9 <alltraps>

80106827 <vector228>:
.globl vector228
vector228:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $228
80106829:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010682e:	e9 c6 f1 ff ff       	jmp    801059f9 <alltraps>

80106833 <vector229>:
.globl vector229
vector229:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $229
80106835:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010683a:	e9 ba f1 ff ff       	jmp    801059f9 <alltraps>

8010683f <vector230>:
.globl vector230
vector230:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $230
80106841:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106846:	e9 ae f1 ff ff       	jmp    801059f9 <alltraps>

8010684b <vector231>:
.globl vector231
vector231:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $231
8010684d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106852:	e9 a2 f1 ff ff       	jmp    801059f9 <alltraps>

80106857 <vector232>:
.globl vector232
vector232:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $232
80106859:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010685e:	e9 96 f1 ff ff       	jmp    801059f9 <alltraps>

80106863 <vector233>:
.globl vector233
vector233:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $233
80106865:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010686a:	e9 8a f1 ff ff       	jmp    801059f9 <alltraps>

8010686f <vector234>:
.globl vector234
vector234:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $234
80106871:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106876:	e9 7e f1 ff ff       	jmp    801059f9 <alltraps>

8010687b <vector235>:
.globl vector235
vector235:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $235
8010687d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106882:	e9 72 f1 ff ff       	jmp    801059f9 <alltraps>

80106887 <vector236>:
.globl vector236
vector236:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $236
80106889:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010688e:	e9 66 f1 ff ff       	jmp    801059f9 <alltraps>

80106893 <vector237>:
.globl vector237
vector237:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $237
80106895:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010689a:	e9 5a f1 ff ff       	jmp    801059f9 <alltraps>

8010689f <vector238>:
.globl vector238
vector238:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $238
801068a1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801068a6:	e9 4e f1 ff ff       	jmp    801059f9 <alltraps>

801068ab <vector239>:
.globl vector239
vector239:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $239
801068ad:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801068b2:	e9 42 f1 ff ff       	jmp    801059f9 <alltraps>

801068b7 <vector240>:
.globl vector240
vector240:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $240
801068b9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801068be:	e9 36 f1 ff ff       	jmp    801059f9 <alltraps>

801068c3 <vector241>:
.globl vector241
vector241:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $241
801068c5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801068ca:	e9 2a f1 ff ff       	jmp    801059f9 <alltraps>

801068cf <vector242>:
.globl vector242
vector242:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $242
801068d1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801068d6:	e9 1e f1 ff ff       	jmp    801059f9 <alltraps>

801068db <vector243>:
.globl vector243
vector243:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $243
801068dd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801068e2:	e9 12 f1 ff ff       	jmp    801059f9 <alltraps>

801068e7 <vector244>:
.globl vector244
vector244:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $244
801068e9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801068ee:	e9 06 f1 ff ff       	jmp    801059f9 <alltraps>

801068f3 <vector245>:
.globl vector245
vector245:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $245
801068f5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801068fa:	e9 fa f0 ff ff       	jmp    801059f9 <alltraps>

801068ff <vector246>:
.globl vector246
vector246:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $246
80106901:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106906:	e9 ee f0 ff ff       	jmp    801059f9 <alltraps>

8010690b <vector247>:
.globl vector247
vector247:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $247
8010690d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106912:	e9 e2 f0 ff ff       	jmp    801059f9 <alltraps>

80106917 <vector248>:
.globl vector248
vector248:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $248
80106919:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010691e:	e9 d6 f0 ff ff       	jmp    801059f9 <alltraps>

80106923 <vector249>:
.globl vector249
vector249:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $249
80106925:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010692a:	e9 ca f0 ff ff       	jmp    801059f9 <alltraps>

8010692f <vector250>:
.globl vector250
vector250:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $250
80106931:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106936:	e9 be f0 ff ff       	jmp    801059f9 <alltraps>

8010693b <vector251>:
.globl vector251
vector251:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $251
8010693d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106942:	e9 b2 f0 ff ff       	jmp    801059f9 <alltraps>

80106947 <vector252>:
.globl vector252
vector252:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $252
80106949:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010694e:	e9 a6 f0 ff ff       	jmp    801059f9 <alltraps>

80106953 <vector253>:
.globl vector253
vector253:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $253
80106955:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010695a:	e9 9a f0 ff ff       	jmp    801059f9 <alltraps>

8010695f <vector254>:
.globl vector254
vector254:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $254
80106961:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106966:	e9 8e f0 ff ff       	jmp    801059f9 <alltraps>

8010696b <vector255>:
.globl vector255
vector255:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $255
8010696d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106972:	e9 82 f0 ff ff       	jmp    801059f9 <alltraps>
80106977:	66 90                	xchg   %ax,%ax
80106979:	66 90                	xchg   %ax,%ax
8010697b:	66 90                	xchg   %ax,%ax
8010697d:	66 90                	xchg   %ax,%ax
8010697f:	90                   	nop

80106980 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106980:	55                   	push   %ebp
80106981:	89 e5                	mov    %esp,%ebp
80106983:	57                   	push   %edi
80106984:	56                   	push   %esi
80106985:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106986:	89 d3                	mov    %edx,%ebx
{
80106988:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010698a:	c1 eb 16             	shr    $0x16,%ebx
8010698d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106990:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106993:	8b 06                	mov    (%esi),%eax
80106995:	a8 01                	test   $0x1,%al
80106997:	74 27                	je     801069c0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106999:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010699e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801069a4:	c1 ef 0a             	shr    $0xa,%edi
}
801069a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801069aa:	89 fa                	mov    %edi,%edx
801069ac:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801069b2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801069b5:	5b                   	pop    %ebx
801069b6:	5e                   	pop    %esi
801069b7:	5f                   	pop    %edi
801069b8:	5d                   	pop    %ebp
801069b9:	c3                   	ret    
801069ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801069c0:	85 c9                	test   %ecx,%ecx
801069c2:	74 2c                	je     801069f0 <walkpgdir+0x70>
801069c4:	e8 07 bb ff ff       	call   801024d0 <kalloc>
801069c9:	85 c0                	test   %eax,%eax
801069cb:	89 c3                	mov    %eax,%ebx
801069cd:	74 21                	je     801069f0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801069cf:	83 ec 04             	sub    $0x4,%esp
801069d2:	68 00 10 00 00       	push   $0x1000
801069d7:	6a 00                	push   $0x0
801069d9:	50                   	push   %eax
801069da:	e8 21 dd ff ff       	call   80104700 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801069df:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801069e5:	83 c4 10             	add    $0x10,%esp
801069e8:	83 c8 07             	or     $0x7,%eax
801069eb:	89 06                	mov    %eax,(%esi)
801069ed:	eb b5                	jmp    801069a4 <walkpgdir+0x24>
801069ef:	90                   	nop
}
801069f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801069f3:	31 c0                	xor    %eax,%eax
}
801069f5:	5b                   	pop    %ebx
801069f6:	5e                   	pop    %esi
801069f7:	5f                   	pop    %edi
801069f8:	5d                   	pop    %ebp
801069f9:	c3                   	ret    
801069fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106a00 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106a00:	55                   	push   %ebp
80106a01:	89 e5                	mov    %esp,%ebp
80106a03:	57                   	push   %edi
80106a04:	56                   	push   %esi
80106a05:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106a06:	89 d3                	mov    %edx,%ebx
80106a08:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106a0e:	83 ec 1c             	sub    $0x1c,%esp
80106a11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a14:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106a18:	8b 7d 08             	mov    0x8(%ebp),%edi
80106a1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a20:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106a23:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a26:	29 df                	sub    %ebx,%edi
80106a28:	83 c8 01             	or     $0x1,%eax
80106a2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106a2e:	eb 15                	jmp    80106a45 <mappages+0x45>
    if(*pte & PTE_P)
80106a30:	f6 00 01             	testb  $0x1,(%eax)
80106a33:	75 45                	jne    80106a7a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106a35:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106a38:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106a3b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106a3d:	74 31                	je     80106a70 <mappages+0x70>
      break;
    a += PGSIZE;
80106a3f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106a45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a48:	b9 01 00 00 00       	mov    $0x1,%ecx
80106a4d:	89 da                	mov    %ebx,%edx
80106a4f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106a52:	e8 29 ff ff ff       	call   80106980 <walkpgdir>
80106a57:	85 c0                	test   %eax,%eax
80106a59:	75 d5                	jne    80106a30 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106a5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106a5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a63:	5b                   	pop    %ebx
80106a64:	5e                   	pop    %esi
80106a65:	5f                   	pop    %edi
80106a66:	5d                   	pop    %ebp
80106a67:	c3                   	ret    
80106a68:	90                   	nop
80106a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106a73:	31 c0                	xor    %eax,%eax
}
80106a75:	5b                   	pop    %ebx
80106a76:	5e                   	pop    %esi
80106a77:	5f                   	pop    %edi
80106a78:	5d                   	pop    %ebp
80106a79:	c3                   	ret    
      panic("remap");
80106a7a:	83 ec 0c             	sub    $0xc,%esp
80106a7d:	68 a4 7c 10 80       	push   $0x80107ca4
80106a82:	e8 09 99 ff ff       	call   80100390 <panic>
80106a87:	89 f6                	mov    %esi,%esi
80106a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a90 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a90:	55                   	push   %ebp
80106a91:	89 e5                	mov    %esp,%ebp
80106a93:	57                   	push   %edi
80106a94:	56                   	push   %esi
80106a95:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106a96:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a9c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106a9e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106aa4:	83 ec 1c             	sub    $0x1c,%esp
80106aa7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106aaa:	39 d3                	cmp    %edx,%ebx
80106aac:	73 66                	jae    80106b14 <deallocuvm.part.0+0x84>
80106aae:	89 d6                	mov    %edx,%esi
80106ab0:	eb 3d                	jmp    80106aef <deallocuvm.part.0+0x5f>
80106ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106ab8:	8b 10                	mov    (%eax),%edx
80106aba:	f6 c2 01             	test   $0x1,%dl
80106abd:	74 26                	je     80106ae5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106abf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106ac5:	74 58                	je     80106b1f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106ac7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106aca:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106ad0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106ad3:	52                   	push   %edx
80106ad4:	e8 47 b8 ff ff       	call   80102320 <kfree>
      *pte = 0;
80106ad9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106adc:	83 c4 10             	add    $0x10,%esp
80106adf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106ae5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106aeb:	39 f3                	cmp    %esi,%ebx
80106aed:	73 25                	jae    80106b14 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106aef:	31 c9                	xor    %ecx,%ecx
80106af1:	89 da                	mov    %ebx,%edx
80106af3:	89 f8                	mov    %edi,%eax
80106af5:	e8 86 fe ff ff       	call   80106980 <walkpgdir>
    if(!pte)
80106afa:	85 c0                	test   %eax,%eax
80106afc:	75 ba                	jne    80106ab8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106afe:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106b04:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106b0a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b10:	39 f3                	cmp    %esi,%ebx
80106b12:	72 db                	jb     80106aef <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106b14:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b17:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b1a:	5b                   	pop    %ebx
80106b1b:	5e                   	pop    %esi
80106b1c:	5f                   	pop    %edi
80106b1d:	5d                   	pop    %ebp
80106b1e:	c3                   	ret    
        panic("kfree");
80106b1f:	83 ec 0c             	sub    $0xc,%esp
80106b22:	68 26 75 10 80       	push   $0x80107526
80106b27:	e8 64 98 ff ff       	call   80100390 <panic>
80106b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b30 <seginit>:
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106b36:	e8 a5 cc ff ff       	call   801037e0 <cpuid>
80106b3b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106b41:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106b46:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b4a:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106b51:	ff 00 00 
80106b54:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
80106b5b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b5e:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106b65:	ff 00 00 
80106b68:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106b6f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b72:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106b79:	ff 00 00 
80106b7c:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106b83:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b86:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106b8d:	ff 00 00 
80106b90:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106b97:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106b9a:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106b9f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ba3:	c1 e8 10             	shr    $0x10,%eax
80106ba6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106baa:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106bad:	0f 01 10             	lgdtl  (%eax)
}
80106bb0:	c9                   	leave  
80106bb1:	c3                   	ret    
80106bb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106bc0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106bc0:	a1 a4 5b 11 80       	mov    0x80115ba4,%eax
{
80106bc5:	55                   	push   %ebp
80106bc6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106bc8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106bcd:	0f 22 d8             	mov    %eax,%cr3
}
80106bd0:	5d                   	pop    %ebp
80106bd1:	c3                   	ret    
80106bd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106be0 <switchuvm>:
{
80106be0:	55                   	push   %ebp
80106be1:	89 e5                	mov    %esp,%ebp
80106be3:	57                   	push   %edi
80106be4:	56                   	push   %esi
80106be5:	53                   	push   %ebx
80106be6:	83 ec 1c             	sub    $0x1c,%esp
80106be9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106bec:	85 db                	test   %ebx,%ebx
80106bee:	0f 84 cb 00 00 00    	je     80106cbf <switchuvm+0xdf>
  if(p->kstack == 0)
80106bf4:	8b 43 08             	mov    0x8(%ebx),%eax
80106bf7:	85 c0                	test   %eax,%eax
80106bf9:	0f 84 da 00 00 00    	je     80106cd9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106bff:	8b 43 04             	mov    0x4(%ebx),%eax
80106c02:	85 c0                	test   %eax,%eax
80106c04:	0f 84 c2 00 00 00    	je     80106ccc <switchuvm+0xec>
  pushcli();
80106c0a:	e8 11 d9 ff ff       	call   80104520 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c0f:	e8 4c cb ff ff       	call   80103760 <mycpu>
80106c14:	89 c6                	mov    %eax,%esi
80106c16:	e8 45 cb ff ff       	call   80103760 <mycpu>
80106c1b:	89 c7                	mov    %eax,%edi
80106c1d:	e8 3e cb ff ff       	call   80103760 <mycpu>
80106c22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c25:	83 c7 08             	add    $0x8,%edi
80106c28:	e8 33 cb ff ff       	call   80103760 <mycpu>
80106c2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c30:	83 c0 08             	add    $0x8,%eax
80106c33:	ba 67 00 00 00       	mov    $0x67,%edx
80106c38:	c1 e8 18             	shr    $0x18,%eax
80106c3b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106c42:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106c49:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106c4f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c54:	83 c1 08             	add    $0x8,%ecx
80106c57:	c1 e9 10             	shr    $0x10,%ecx
80106c5a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106c60:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106c65:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c6c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106c71:	e8 ea ca ff ff       	call   80103760 <mycpu>
80106c76:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c7d:	e8 de ca ff ff       	call   80103760 <mycpu>
80106c82:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106c86:	8b 73 08             	mov    0x8(%ebx),%esi
80106c89:	e8 d2 ca ff ff       	call   80103760 <mycpu>
80106c8e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106c94:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106c97:	e8 c4 ca ff ff       	call   80103760 <mycpu>
80106c9c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106ca0:	b8 28 00 00 00       	mov    $0x28,%eax
80106ca5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106ca8:	8b 43 04             	mov    0x4(%ebx),%eax
80106cab:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106cb0:	0f 22 d8             	mov    %eax,%cr3
}
80106cb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cb6:	5b                   	pop    %ebx
80106cb7:	5e                   	pop    %esi
80106cb8:	5f                   	pop    %edi
80106cb9:	5d                   	pop    %ebp
  popcli();
80106cba:	e9 a1 d8 ff ff       	jmp    80104560 <popcli>
    panic("switchuvm: no process");
80106cbf:	83 ec 0c             	sub    $0xc,%esp
80106cc2:	68 aa 7c 10 80       	push   $0x80107caa
80106cc7:	e8 c4 96 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106ccc:	83 ec 0c             	sub    $0xc,%esp
80106ccf:	68 d5 7c 10 80       	push   $0x80107cd5
80106cd4:	e8 b7 96 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106cd9:	83 ec 0c             	sub    $0xc,%esp
80106cdc:	68 c0 7c 10 80       	push   $0x80107cc0
80106ce1:	e8 aa 96 ff ff       	call   80100390 <panic>
80106ce6:	8d 76 00             	lea    0x0(%esi),%esi
80106ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cf0 <inituvm>:
{
80106cf0:	55                   	push   %ebp
80106cf1:	89 e5                	mov    %esp,%ebp
80106cf3:	57                   	push   %edi
80106cf4:	56                   	push   %esi
80106cf5:	53                   	push   %ebx
80106cf6:	83 ec 1c             	sub    $0x1c,%esp
80106cf9:	8b 75 10             	mov    0x10(%ebp),%esi
80106cfc:	8b 45 08             	mov    0x8(%ebp),%eax
80106cff:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106d02:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106d08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106d0b:	77 49                	ja     80106d56 <inituvm+0x66>
  mem = kalloc();
80106d0d:	e8 be b7 ff ff       	call   801024d0 <kalloc>
  memset(mem, 0, PGSIZE);
80106d12:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106d15:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106d17:	68 00 10 00 00       	push   $0x1000
80106d1c:	6a 00                	push   $0x0
80106d1e:	50                   	push   %eax
80106d1f:	e8 dc d9 ff ff       	call   80104700 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106d24:	58                   	pop    %eax
80106d25:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d2b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d30:	5a                   	pop    %edx
80106d31:	6a 06                	push   $0x6
80106d33:	50                   	push   %eax
80106d34:	31 d2                	xor    %edx,%edx
80106d36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d39:	e8 c2 fc ff ff       	call   80106a00 <mappages>
  memmove(mem, init, sz);
80106d3e:	89 75 10             	mov    %esi,0x10(%ebp)
80106d41:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106d44:	83 c4 10             	add    $0x10,%esp
80106d47:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106d4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d4d:	5b                   	pop    %ebx
80106d4e:	5e                   	pop    %esi
80106d4f:	5f                   	pop    %edi
80106d50:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106d51:	e9 5a da ff ff       	jmp    801047b0 <memmove>
    panic("inituvm: more than a page");
80106d56:	83 ec 0c             	sub    $0xc,%esp
80106d59:	68 e9 7c 10 80       	push   $0x80107ce9
80106d5e:	e8 2d 96 ff ff       	call   80100390 <panic>
80106d63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d70 <loaduvm>:
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	57                   	push   %edi
80106d74:	56                   	push   %esi
80106d75:	53                   	push   %ebx
80106d76:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106d79:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106d80:	0f 85 91 00 00 00    	jne    80106e17 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106d86:	8b 75 18             	mov    0x18(%ebp),%esi
80106d89:	31 db                	xor    %ebx,%ebx
80106d8b:	85 f6                	test   %esi,%esi
80106d8d:	75 1a                	jne    80106da9 <loaduvm+0x39>
80106d8f:	eb 6f                	jmp    80106e00 <loaduvm+0x90>
80106d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d98:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d9e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106da4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106da7:	76 57                	jbe    80106e00 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106da9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106dac:	8b 45 08             	mov    0x8(%ebp),%eax
80106daf:	31 c9                	xor    %ecx,%ecx
80106db1:	01 da                	add    %ebx,%edx
80106db3:	e8 c8 fb ff ff       	call   80106980 <walkpgdir>
80106db8:	85 c0                	test   %eax,%eax
80106dba:	74 4e                	je     80106e0a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106dbc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106dbe:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106dc1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106dc6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106dcb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106dd1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106dd4:	01 d9                	add    %ebx,%ecx
80106dd6:	05 00 00 00 80       	add    $0x80000000,%eax
80106ddb:	57                   	push   %edi
80106ddc:	51                   	push   %ecx
80106ddd:	50                   	push   %eax
80106dde:	ff 75 10             	pushl  0x10(%ebp)
80106de1:	e8 8a ab ff ff       	call   80101970 <readi>
80106de6:	83 c4 10             	add    $0x10,%esp
80106de9:	39 f8                	cmp    %edi,%eax
80106deb:	74 ab                	je     80106d98 <loaduvm+0x28>
}
80106ded:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106df0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106df5:	5b                   	pop    %ebx
80106df6:	5e                   	pop    %esi
80106df7:	5f                   	pop    %edi
80106df8:	5d                   	pop    %ebp
80106df9:	c3                   	ret    
80106dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e03:	31 c0                	xor    %eax,%eax
}
80106e05:	5b                   	pop    %ebx
80106e06:	5e                   	pop    %esi
80106e07:	5f                   	pop    %edi
80106e08:	5d                   	pop    %ebp
80106e09:	c3                   	ret    
      panic("loaduvm: address should exist");
80106e0a:	83 ec 0c             	sub    $0xc,%esp
80106e0d:	68 03 7d 10 80       	push   $0x80107d03
80106e12:	e8 79 95 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106e17:	83 ec 0c             	sub    $0xc,%esp
80106e1a:	68 a4 7d 10 80       	push   $0x80107da4
80106e1f:	e8 6c 95 ff ff       	call   80100390 <panic>
80106e24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106e30 <allocuvm>:
{
80106e30:	55                   	push   %ebp
80106e31:	89 e5                	mov    %esp,%ebp
80106e33:	57                   	push   %edi
80106e34:	56                   	push   %esi
80106e35:	53                   	push   %ebx
80106e36:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106e39:	8b 7d 10             	mov    0x10(%ebp),%edi
80106e3c:	85 ff                	test   %edi,%edi
80106e3e:	0f 88 8e 00 00 00    	js     80106ed2 <allocuvm+0xa2>
  if(newsz < oldsz)
80106e44:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106e47:	0f 82 93 00 00 00    	jb     80106ee0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80106e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e50:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106e56:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106e5c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106e5f:	0f 86 7e 00 00 00    	jbe    80106ee3 <allocuvm+0xb3>
80106e65:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106e68:	8b 7d 08             	mov    0x8(%ebp),%edi
80106e6b:	eb 42                	jmp    80106eaf <allocuvm+0x7f>
80106e6d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106e70:	83 ec 04             	sub    $0x4,%esp
80106e73:	68 00 10 00 00       	push   $0x1000
80106e78:	6a 00                	push   $0x0
80106e7a:	50                   	push   %eax
80106e7b:	e8 80 d8 ff ff       	call   80104700 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106e80:	58                   	pop    %eax
80106e81:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106e87:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e8c:	5a                   	pop    %edx
80106e8d:	6a 06                	push   $0x6
80106e8f:	50                   	push   %eax
80106e90:	89 da                	mov    %ebx,%edx
80106e92:	89 f8                	mov    %edi,%eax
80106e94:	e8 67 fb ff ff       	call   80106a00 <mappages>
80106e99:	83 c4 10             	add    $0x10,%esp
80106e9c:	85 c0                	test   %eax,%eax
80106e9e:	78 50                	js     80106ef0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80106ea0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ea6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106ea9:	0f 86 81 00 00 00    	jbe    80106f30 <allocuvm+0x100>
    mem = kalloc();
80106eaf:	e8 1c b6 ff ff       	call   801024d0 <kalloc>
    if(mem == 0){
80106eb4:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106eb6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106eb8:	75 b6                	jne    80106e70 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106eba:	83 ec 0c             	sub    $0xc,%esp
80106ebd:	68 21 7d 10 80       	push   $0x80107d21
80106ec2:	e8 99 97 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106ec7:	83 c4 10             	add    $0x10,%esp
80106eca:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ecd:	39 45 10             	cmp    %eax,0x10(%ebp)
80106ed0:	77 6e                	ja     80106f40 <allocuvm+0x110>
}
80106ed2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106ed5:	31 ff                	xor    %edi,%edi
}
80106ed7:	89 f8                	mov    %edi,%eax
80106ed9:	5b                   	pop    %ebx
80106eda:	5e                   	pop    %esi
80106edb:	5f                   	pop    %edi
80106edc:	5d                   	pop    %ebp
80106edd:	c3                   	ret    
80106ede:	66 90                	xchg   %ax,%ax
    return oldsz;
80106ee0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ee6:	89 f8                	mov    %edi,%eax
80106ee8:	5b                   	pop    %ebx
80106ee9:	5e                   	pop    %esi
80106eea:	5f                   	pop    %edi
80106eeb:	5d                   	pop    %ebp
80106eec:	c3                   	ret    
80106eed:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106ef0:	83 ec 0c             	sub    $0xc,%esp
80106ef3:	68 39 7d 10 80       	push   $0x80107d39
80106ef8:	e8 63 97 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106efd:	83 c4 10             	add    $0x10,%esp
80106f00:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f03:	39 45 10             	cmp    %eax,0x10(%ebp)
80106f06:	76 0d                	jbe    80106f15 <allocuvm+0xe5>
80106f08:	89 c1                	mov    %eax,%ecx
80106f0a:	8b 55 10             	mov    0x10(%ebp),%edx
80106f0d:	8b 45 08             	mov    0x8(%ebp),%eax
80106f10:	e8 7b fb ff ff       	call   80106a90 <deallocuvm.part.0>
      kfree(mem);
80106f15:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106f18:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106f1a:	56                   	push   %esi
80106f1b:	e8 00 b4 ff ff       	call   80102320 <kfree>
      return 0;
80106f20:	83 c4 10             	add    $0x10,%esp
}
80106f23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f26:	89 f8                	mov    %edi,%eax
80106f28:	5b                   	pop    %ebx
80106f29:	5e                   	pop    %esi
80106f2a:	5f                   	pop    %edi
80106f2b:	5d                   	pop    %ebp
80106f2c:	c3                   	ret    
80106f2d:	8d 76 00             	lea    0x0(%esi),%esi
80106f30:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106f33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f36:	5b                   	pop    %ebx
80106f37:	89 f8                	mov    %edi,%eax
80106f39:	5e                   	pop    %esi
80106f3a:	5f                   	pop    %edi
80106f3b:	5d                   	pop    %ebp
80106f3c:	c3                   	ret    
80106f3d:	8d 76 00             	lea    0x0(%esi),%esi
80106f40:	89 c1                	mov    %eax,%ecx
80106f42:	8b 55 10             	mov    0x10(%ebp),%edx
80106f45:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106f48:	31 ff                	xor    %edi,%edi
80106f4a:	e8 41 fb ff ff       	call   80106a90 <deallocuvm.part.0>
80106f4f:	eb 92                	jmp    80106ee3 <allocuvm+0xb3>
80106f51:	eb 0d                	jmp    80106f60 <deallocuvm>
80106f53:	90                   	nop
80106f54:	90                   	nop
80106f55:	90                   	nop
80106f56:	90                   	nop
80106f57:	90                   	nop
80106f58:	90                   	nop
80106f59:	90                   	nop
80106f5a:	90                   	nop
80106f5b:	90                   	nop
80106f5c:	90                   	nop
80106f5d:	90                   	nop
80106f5e:	90                   	nop
80106f5f:	90                   	nop

80106f60 <deallocuvm>:
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f66:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106f69:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106f6c:	39 d1                	cmp    %edx,%ecx
80106f6e:	73 10                	jae    80106f80 <deallocuvm+0x20>
}
80106f70:	5d                   	pop    %ebp
80106f71:	e9 1a fb ff ff       	jmp    80106a90 <deallocuvm.part.0>
80106f76:	8d 76 00             	lea    0x0(%esi),%esi
80106f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106f80:	89 d0                	mov    %edx,%eax
80106f82:	5d                   	pop    %ebp
80106f83:	c3                   	ret    
80106f84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f90 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	57                   	push   %edi
80106f94:	56                   	push   %esi
80106f95:	53                   	push   %ebx
80106f96:	83 ec 0c             	sub    $0xc,%esp
80106f99:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106f9c:	85 f6                	test   %esi,%esi
80106f9e:	74 59                	je     80106ff9 <freevm+0x69>
80106fa0:	31 c9                	xor    %ecx,%ecx
80106fa2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106fa7:	89 f0                	mov    %esi,%eax
80106fa9:	e8 e2 fa ff ff       	call   80106a90 <deallocuvm.part.0>
80106fae:	89 f3                	mov    %esi,%ebx
80106fb0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106fb6:	eb 0f                	jmp    80106fc7 <freevm+0x37>
80106fb8:	90                   	nop
80106fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fc0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106fc3:	39 fb                	cmp    %edi,%ebx
80106fc5:	74 23                	je     80106fea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106fc7:	8b 03                	mov    (%ebx),%eax
80106fc9:	a8 01                	test   $0x1,%al
80106fcb:	74 f3                	je     80106fc0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106fcd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106fd2:	83 ec 0c             	sub    $0xc,%esp
80106fd5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106fd8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106fdd:	50                   	push   %eax
80106fde:	e8 3d b3 ff ff       	call   80102320 <kfree>
80106fe3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106fe6:	39 fb                	cmp    %edi,%ebx
80106fe8:	75 dd                	jne    80106fc7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106fea:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106fed:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ff0:	5b                   	pop    %ebx
80106ff1:	5e                   	pop    %esi
80106ff2:	5f                   	pop    %edi
80106ff3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106ff4:	e9 27 b3 ff ff       	jmp    80102320 <kfree>
    panic("freevm: no pgdir");
80106ff9:	83 ec 0c             	sub    $0xc,%esp
80106ffc:	68 55 7d 10 80       	push   $0x80107d55
80107001:	e8 8a 93 ff ff       	call   80100390 <panic>
80107006:	8d 76 00             	lea    0x0(%esi),%esi
80107009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107010 <setupkvm>:
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	56                   	push   %esi
80107014:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107015:	e8 b6 b4 ff ff       	call   801024d0 <kalloc>
8010701a:	85 c0                	test   %eax,%eax
8010701c:	89 c6                	mov    %eax,%esi
8010701e:	74 42                	je     80107062 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107020:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107023:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107028:	68 00 10 00 00       	push   $0x1000
8010702d:	6a 00                	push   $0x0
8010702f:	50                   	push   %eax
80107030:	e8 cb d6 ff ff       	call   80104700 <memset>
80107035:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107038:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010703b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010703e:	83 ec 08             	sub    $0x8,%esp
80107041:	8b 13                	mov    (%ebx),%edx
80107043:	ff 73 0c             	pushl  0xc(%ebx)
80107046:	50                   	push   %eax
80107047:	29 c1                	sub    %eax,%ecx
80107049:	89 f0                	mov    %esi,%eax
8010704b:	e8 b0 f9 ff ff       	call   80106a00 <mappages>
80107050:	83 c4 10             	add    $0x10,%esp
80107053:	85 c0                	test   %eax,%eax
80107055:	78 19                	js     80107070 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107057:	83 c3 10             	add    $0x10,%ebx
8010705a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107060:	75 d6                	jne    80107038 <setupkvm+0x28>
}
80107062:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107065:	89 f0                	mov    %esi,%eax
80107067:	5b                   	pop    %ebx
80107068:	5e                   	pop    %esi
80107069:	5d                   	pop    %ebp
8010706a:	c3                   	ret    
8010706b:	90                   	nop
8010706c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107070:	83 ec 0c             	sub    $0xc,%esp
80107073:	56                   	push   %esi
      return 0;
80107074:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107076:	e8 15 ff ff ff       	call   80106f90 <freevm>
      return 0;
8010707b:	83 c4 10             	add    $0x10,%esp
}
8010707e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107081:	89 f0                	mov    %esi,%eax
80107083:	5b                   	pop    %ebx
80107084:	5e                   	pop    %esi
80107085:	5d                   	pop    %ebp
80107086:	c3                   	ret    
80107087:	89 f6                	mov    %esi,%esi
80107089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107090 <kvmalloc>:
{
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107096:	e8 75 ff ff ff       	call   80107010 <setupkvm>
8010709b:	a3 a4 5b 11 80       	mov    %eax,0x80115ba4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801070a0:	05 00 00 00 80       	add    $0x80000000,%eax
801070a5:	0f 22 d8             	mov    %eax,%cr3
}
801070a8:	c9                   	leave  
801070a9:	c3                   	ret    
801070aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070b0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801070b0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801070b1:	31 c9                	xor    %ecx,%ecx
{
801070b3:	89 e5                	mov    %esp,%ebp
801070b5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801070b8:	8b 55 0c             	mov    0xc(%ebp),%edx
801070bb:	8b 45 08             	mov    0x8(%ebp),%eax
801070be:	e8 bd f8 ff ff       	call   80106980 <walkpgdir>
  if(pte == 0)
801070c3:	85 c0                	test   %eax,%eax
801070c5:	74 05                	je     801070cc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801070c7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801070ca:	c9                   	leave  
801070cb:	c3                   	ret    
    panic("clearpteu");
801070cc:	83 ec 0c             	sub    $0xc,%esp
801070cf:	68 66 7d 10 80       	push   $0x80107d66
801070d4:	e8 b7 92 ff ff       	call   80100390 <panic>
801070d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	57                   	push   %edi
801070e4:	56                   	push   %esi
801070e5:	53                   	push   %ebx
801070e6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801070e9:	e8 22 ff ff ff       	call   80107010 <setupkvm>
801070ee:	85 c0                	test   %eax,%eax
801070f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801070f3:	0f 84 9f 00 00 00    	je     80107198 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801070f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801070fc:	85 c9                	test   %ecx,%ecx
801070fe:	0f 84 94 00 00 00    	je     80107198 <copyuvm+0xb8>
80107104:	31 ff                	xor    %edi,%edi
80107106:	eb 4a                	jmp    80107152 <copyuvm+0x72>
80107108:	90                   	nop
80107109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107110:	83 ec 04             	sub    $0x4,%esp
80107113:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107119:	68 00 10 00 00       	push   $0x1000
8010711e:	53                   	push   %ebx
8010711f:	50                   	push   %eax
80107120:	e8 8b d6 ff ff       	call   801047b0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107125:	58                   	pop    %eax
80107126:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010712c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107131:	5a                   	pop    %edx
80107132:	ff 75 e4             	pushl  -0x1c(%ebp)
80107135:	50                   	push   %eax
80107136:	89 fa                	mov    %edi,%edx
80107138:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010713b:	e8 c0 f8 ff ff       	call   80106a00 <mappages>
80107140:	83 c4 10             	add    $0x10,%esp
80107143:	85 c0                	test   %eax,%eax
80107145:	78 61                	js     801071a8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107147:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010714d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107150:	76 46                	jbe    80107198 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107152:	8b 45 08             	mov    0x8(%ebp),%eax
80107155:	31 c9                	xor    %ecx,%ecx
80107157:	89 fa                	mov    %edi,%edx
80107159:	e8 22 f8 ff ff       	call   80106980 <walkpgdir>
8010715e:	85 c0                	test   %eax,%eax
80107160:	74 61                	je     801071c3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107162:	8b 00                	mov    (%eax),%eax
80107164:	a8 01                	test   $0x1,%al
80107166:	74 4e                	je     801071b6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107168:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010716a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010716f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107175:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107178:	e8 53 b3 ff ff       	call   801024d0 <kalloc>
8010717d:	85 c0                	test   %eax,%eax
8010717f:	89 c6                	mov    %eax,%esi
80107181:	75 8d                	jne    80107110 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107183:	83 ec 0c             	sub    $0xc,%esp
80107186:	ff 75 e0             	pushl  -0x20(%ebp)
80107189:	e8 02 fe ff ff       	call   80106f90 <freevm>
  return 0;
8010718e:	83 c4 10             	add    $0x10,%esp
80107191:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107198:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010719b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010719e:	5b                   	pop    %ebx
8010719f:	5e                   	pop    %esi
801071a0:	5f                   	pop    %edi
801071a1:	5d                   	pop    %ebp
801071a2:	c3                   	ret    
801071a3:	90                   	nop
801071a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801071a8:	83 ec 0c             	sub    $0xc,%esp
801071ab:	56                   	push   %esi
801071ac:	e8 6f b1 ff ff       	call   80102320 <kfree>
      goto bad;
801071b1:	83 c4 10             	add    $0x10,%esp
801071b4:	eb cd                	jmp    80107183 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801071b6:	83 ec 0c             	sub    $0xc,%esp
801071b9:	68 8a 7d 10 80       	push   $0x80107d8a
801071be:	e8 cd 91 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801071c3:	83 ec 0c             	sub    $0xc,%esp
801071c6:	68 70 7d 10 80       	push   $0x80107d70
801071cb:	e8 c0 91 ff ff       	call   80100390 <panic>

801071d0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801071d0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801071d1:	31 c9                	xor    %ecx,%ecx
{
801071d3:	89 e5                	mov    %esp,%ebp
801071d5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801071d8:	8b 55 0c             	mov    0xc(%ebp),%edx
801071db:	8b 45 08             	mov    0x8(%ebp),%eax
801071de:	e8 9d f7 ff ff       	call   80106980 <walkpgdir>
  if((*pte & PTE_P) == 0)
801071e3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801071e5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801071e6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801071e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801071ed:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801071f0:	05 00 00 00 80       	add    $0x80000000,%eax
801071f5:	83 fa 05             	cmp    $0x5,%edx
801071f8:	ba 00 00 00 00       	mov    $0x0,%edx
801071fd:	0f 45 c2             	cmovne %edx,%eax
}
80107200:	c3                   	ret    
80107201:	eb 0d                	jmp    80107210 <copyout>
80107203:	90                   	nop
80107204:	90                   	nop
80107205:	90                   	nop
80107206:	90                   	nop
80107207:	90                   	nop
80107208:	90                   	nop
80107209:	90                   	nop
8010720a:	90                   	nop
8010720b:	90                   	nop
8010720c:	90                   	nop
8010720d:	90                   	nop
8010720e:	90                   	nop
8010720f:	90                   	nop

80107210 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	57                   	push   %edi
80107214:	56                   	push   %esi
80107215:	53                   	push   %ebx
80107216:	83 ec 1c             	sub    $0x1c,%esp
80107219:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010721c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010721f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107222:	85 db                	test   %ebx,%ebx
80107224:	75 40                	jne    80107266 <copyout+0x56>
80107226:	eb 70                	jmp    80107298 <copyout+0x88>
80107228:	90                   	nop
80107229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107230:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107233:	89 f1                	mov    %esi,%ecx
80107235:	29 d1                	sub    %edx,%ecx
80107237:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010723d:	39 d9                	cmp    %ebx,%ecx
8010723f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107242:	29 f2                	sub    %esi,%edx
80107244:	83 ec 04             	sub    $0x4,%esp
80107247:	01 d0                	add    %edx,%eax
80107249:	51                   	push   %ecx
8010724a:	57                   	push   %edi
8010724b:	50                   	push   %eax
8010724c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010724f:	e8 5c d5 ff ff       	call   801047b0 <memmove>
    len -= n;
    buf += n;
80107254:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107257:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010725a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107260:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107262:	29 cb                	sub    %ecx,%ebx
80107264:	74 32                	je     80107298 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107266:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107268:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010726b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010726e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107274:	56                   	push   %esi
80107275:	ff 75 08             	pushl  0x8(%ebp)
80107278:	e8 53 ff ff ff       	call   801071d0 <uva2ka>
    if(pa0 == 0)
8010727d:	83 c4 10             	add    $0x10,%esp
80107280:	85 c0                	test   %eax,%eax
80107282:	75 ac                	jne    80107230 <copyout+0x20>
  }
  return 0;
}
80107284:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107287:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010728c:	5b                   	pop    %ebx
8010728d:	5e                   	pop    %esi
8010728e:	5f                   	pop    %edi
8010728f:	5d                   	pop    %ebp
80107290:	c3                   	ret    
80107291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107298:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010729b:	31 c0                	xor    %eax,%eax
}
8010729d:	5b                   	pop    %ebx
8010729e:	5e                   	pop    %esi
8010729f:	5f                   	pop    %edi
801072a0:	5d                   	pop    %ebp
801072a1:	c3                   	ret    
