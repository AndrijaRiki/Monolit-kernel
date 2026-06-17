#include "../lib/console.h"
#include "../lib/hw.h"
#include  "../h/printing.hpp"
#include "../h/syscall_c.h"

void main() {
    void* p1 = mem_alloc(10);
    printInteger((uint64)p1);
    __putc('\n');
    __putc('1');
    __putc('\n');
    uint64 status = mem_free(p1);
    printInteger(status);
    __putc('\n');
    __putc('2');
    __putc('\n');
}