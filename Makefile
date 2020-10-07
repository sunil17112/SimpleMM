default: random

##this is an intereingt project
#memoryallocation
static size_t rounded_value(size_t size){
	if(size<=16){
		size=16;

	}
	else if(size<4096){
		
		size_t t=1;
		while(size>0){
			size=size>>1;
			t=t<<1;
		}
		size=t;
		
	}
	else{
		size_t t=size/4096;
		if(size%4096){
			size=(t+1)*4096;
		}
		else{
			size=t*4096;
			
		}
		
	}
	return size;


}

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
libmemory.so: memory.c
	gcc -Werror -shared -O3 -fPIC -o libmemory.so memory.c

random: randomalloc.c libmemory.so
	gcc -O3 -L`pwd` -Wl,-rpath=`pwd` -o random randomalloc.c -lmemory

run: random
	/usr/bin/time -v ./random

test: random
	@/usr/bin/time -v ./random 1000000 > out 2>&1
	@/usr/bin/time -v ./random 2000000 >> out 2>&1 
	@/usr/bin/time -v ./random 3000000 >> out 2>&1
	@/usr/bin/time -v ./random 4000000 >> out 2>&1
	@egrep "Elapsed|replace|Minor|Maximum" out
	@rm out

clean:
	rm -f libmemory.so random out
