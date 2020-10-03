#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
int main(void)
{
 int newPrio = -23;
	setprio(newPrio);
	exit();
}