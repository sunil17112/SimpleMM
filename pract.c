
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <fcntl.h>
#include <assert.h>
//#include "memory.h"
#define PAGE_SIZE 4096
static void *alloc_from_ram(size_t size)
{
	assert((size % PAGE_SIZE) == 0 && "size must be multiples of 4096");
	void* base = mmap(NULL, size, PROT_READ|PROT_WRITE, MAP_ANON|MAP_PRIVATE, -1, 0);
	if (base == MAP_FAILED)
	{
		printf("Unable to allocate RAM space\n");
		exit(0);
	}
	return base;
}
struct node{
	struct node *next;
	struct node *prev;
	char *addr;
};
struct node *split(void *Page, size_t size){
	struct node *free_list = NULL;
	free_list=Page;
	struct node *ptr=free_list;
	int i=1;
	//printf("%d\n", free_list);
	while((Page+(size*i))<(Page+4080)){
		ptr->next=Page+(size*i);
		ptr->addr=(char*)ptr;
		printf("%d\n", ptr->addr);
		ptr=ptr->next;
		
		i++;
	}
	return free_list;

}

int main(int argc, char**argv){

	void *esp = alloc_from_ram(4096);
	printf("%d\n", esp);
	struct node *free_list=split(esp+16,atoi(argv[1]));
	return 0;
}
