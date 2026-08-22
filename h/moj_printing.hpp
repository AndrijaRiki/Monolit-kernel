//
// Created by os on 6/16/26.
//

#ifndef PROJEKAT_PRINTING_HPP
#define PROJEKAT_PRINTING_HPP

#include "../lib/hw.h"

#ifdef __cplusplus
extern "C" {
#endif


void printString(const char* str);
void printInteger(uint64 num, int base);

#ifdef __cplusplus
}
#endif
#endif //PROJEKAT_PRINTING_HPP