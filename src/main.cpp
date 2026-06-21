#include "../lib/console.h"
#include "../lib/hw.h"
#include "../h/printing.hpp"
#include "../h/syscall_c.h"

static void printLabel(const char* label)
{
    printString(label);
}

static void printLine(const char* label, uint64 value)
{
    printString(label);
    printInteger(value, 16);
    __putc('\n');
}

// ── thread bodies ──────────────────────────────────────────────────────────

static volatile int t1_ran = 0;
static void body_t1(void* arg)
{
    t1_ran = 1;
}

static volatile int counter = 0;
static void body_add(void* arg)
{
    int val = (int)(uint64)arg;
    counter += val;
}

static volatile int orderLog[8];
static volatile int orderIdx = 0;
static void body_log(void* arg)
{
    int id = (int)(uint64)arg;
    int idx = orderIdx++;
    if (idx < 8) orderLog[idx] = id;
    thread_dispatch();
    idx = orderIdx++;
    if (idx < 8) orderLog[idx] = id;
    thread_dispatch();
    idx = orderIdx++;
    if (idx < 8) orderLog[idx] = id;
}

static volatile int t4_val = 0;
static void body_early_exit(void* arg)
{
    t4_val = 1;
    thread_exit();
    t4_val = 2;  // must never run
}

static void body_increment(void* arg)
{
    counter++;
}

// ── main ──────────────────────────────────────────────────────────────────

int main()
{
    thread_t h;

    // ---- Test 1: single thread runs and sets a flag ----------------------
    printLabel("[Test 1] single thread sets flag\n");
    t1_ran = 0;
    int r = thread_create(&h, body_t1, nullptr);
    printLine("  thread_create ret=", (uint64)r);
    // yield until the thread runs
    while (t1_ran == 0) thread_dispatch();
    printLine("  t1_ran=", (uint64)t1_ran);
    if (t1_ran == 1)
        printLabel("  OK\n");
    else
        printLabel("  FAIL\n");
    __putc('\n');

    // ---- Test 2: argument passing, two threads add 3 and 7 ---------------
    printLabel("[Test 2] argument passing (3 + 7 = 10)\n");
    counter = 0;
    thread_t h2;
    thread_create(&h,  body_add, (void*)(uint64)3);
    thread_create(&h2, body_add, (void*)(uint64)7);
    while (counter != 10) thread_dispatch();
    printLine("  counter=", (uint64)counter);
    if (counter == 10)
        printLabel("  OK\n");
    else
        printLabel("  FAIL\n");
    __putc('\n');

    // ---- Test 3: interleaving, two threads yield in a loop ---------------
    printLabel("[Test 3] interleaving via thread_dispatch\n");
    orderIdx = 0;
    for (int i = 0; i < 8; i++) orderLog[i] = -1;
    thread_t hA, hB;
    thread_create(&hA, body_log, (void*)(uint64)1);
    thread_create(&hB, body_log, (void*)(uint64)2);
    //while (orderIdx < 6) thread_dispatch();
    while (orderIdx < 6) {
        printString("main spin orderIdx=");
        printInteger((uint64)orderIdx, 10);
        printString("\n");
        thread_dispatch();
    }
    printLabel("  order: ");
    for (int i = 0; i < 6; i++)
    {
        printInteger((uint64)orderLog[i], 10);
        __putc(' ');
    }
    __putc('\n');
    int saw1 = 0, saw2 = 0;
    for (int i = 0; i < 6; i++)
    {
        if (orderLog[i] == 1) saw1++;
        if (orderLog[i] == 2) saw2++;
    }
    printLine("  thread 1 entries=", (uint64)saw1);
    printLine("  thread 2 entries=", (uint64)saw2);
    if (saw1 == 3 && saw2 == 3)
        printLabel("  OK\n");
    else
        printLabel("  FAIL\n");
    __putc('\n');

    // ---- Test 4: explicit thread_exit stops thread mid-body --------------
    printLabel("[Test 4] thread_exit stops mid-body\n");
    t4_val = 0;
    thread_create(&h, body_early_exit, nullptr);
    while (t4_val == 0) thread_dispatch();
    thread_dispatch();
    thread_dispatch();
    printLine("  t4_val=", (uint64)t4_val);
    if (t4_val == 1)
        printLabel("  OK: second assignment never ran\n");
    else
        printLabel("  FAIL: thread continued past thread_exit\n");
    __putc('\n');

    // ---- Test 5: 8 threads each increment counter once -------------------
    printLabel("[Test 5] 8 threads increment counter (expect 8)\n");
    counter = 0;
    thread_t handles[8];
    for (int i = 0; i < 8; i++)
        thread_create(&handles[i], body_increment, nullptr);
    while (counter < 8) thread_dispatch();
    printLine("  counter=", (uint64)counter);
    if (counter == 8)
        printLabel("  OK\n");
    else
        printLabel("  FAIL\n");
    __putc('\n');

    // ---- Test 6: null body must return error -----------------------------
    printLabel("[Test 6] thread_create(null body) must fail\n");
    thread_t hBad;
    int bad = thread_create(&hBad, nullptr, nullptr);
    printLine("  ret=", (uint64)bad);
    if (bad != 0)
        printLabel("  OK\n");
    else
        printLabel("  FAIL\n");
    __putc('\n');

    printLabel("All thread tests finished.\n");
    *((volatile int*)0x100000) = 0x5555;
    while (true) {}
    return 0;
}