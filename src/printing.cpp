//
// Created by os on 6/16/26.
//

#include "../h/printing.hpp"
#include "../lib/console.h"
#include  "../lib/hw.h"

void printString(const char *str)
{
    while (*str != '\0')
    {
        __putc(*str);
        str ++;
    }
}

void printInteger(uint64 num)
{
    int base = 16;
    static char digits[] = "0123456789abcdef";
    char buf[16];
    int i;
    uint64 x = num;

    i = 0;
    do
    {
        buf[i++] = digits[x%base];
    } while ((x /= base) != 0);

    while (--i >= 0)
    {
        __putc(buf[i]);
    }
}