#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "processInfo.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
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

int
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

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int 
sys_hello(void)
{
cprintf("helloxv6\n");
return 0;
}

int
sys_helloname(char *name)
{

argptr(0,(void*)&name, sizeof(name));
cprintf("hello %s\n",name);
return 0;
}
int
sys_getnumproc(void)
{
 // argint(0,&proc);
  cprintf("Total number of Active Processes: %d\n",getnumproc());
  return 0;
}

int
sys_getmaxpid(void)
{
 /* struct uproc *tmp;
  int size;
  if(argint(0,&size)<0 || argptr(1,(void*)&tmp, sizeof(*tmp))<0)
  {
    return -1;
  }*/
  cprintf("Maximum PID: %d\n",getmaxpid());
  return 0;
}
int 
sys_getprocinfo(void)
{
  cprintf("PID    PPID   SIZE    Number of Context Switch\n");
   int pid;
    struct processInfo *tmp;
    if(argint(0,&pid)<0 ||argptr(1,(void*)&tmp,sizeof(*tmp))<0)
      return -1;
  getprocinfo(pid, tmp);
  
  return 0;
}
int sys_setprio(int newPrio)
{
  //cprintf("setting prio\n");
  
 
  //cprintf("new:%d\n",newPrio);

  //cprintf("newprio of pre-arg: %d\n", newPrio);
  argint(0,&newPrio);
  //cprintf("newprio arg:%d\n",newPrio);
  //cprintf("proc %s priority changed ; new prio: %d\n",p->name,p->priority);
 
  //setprio(newPrio);
  return setprio(newPrio);
}
int sys_getprio(void)
{
  //getprio();
  return getprio();
}
