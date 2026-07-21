//
// Created by os on 7/20/26.
//

#include "../h/syscall_c.h"
#include "../h/printing.hpp"

// ============================================================================
// TEST 1: Basic Putc Output Test
// Verifies that 'putc' correctly outputs individual characters and newlines.
// ============================================================================
void test_console_basic_output()
{
    printString("\n--- [Console Test 1] Basic Output ---\n");
    printString("Printing lowercase alphabet: ");
    for (char c = 'a'; c <= 'z'; c++)
    {
        putc(c);
    }
    putc('\n');

    printString("Printing numbers: ");
    for (char c = '0'; c <= '9'; c++)
    {
        putc(c);
    }
    putc('\n');
    printString("Basic Output Test: OK\n");
}

// ============================================================================
// TEST 2: Interactive Echo (Getc -> Putc)
// Tests reading single characters from input and echoing them back.
// ============================================================================
void test_console_echo()
{
    printString("\n--- [Console Test 2] Interactive Echo ---\n");
    printString("Type any characters. Press 'q' or 'Q' to end the echo test:\n> ");

    while (true)
    {
        char c = getc();

        // Echo the pressed character back to the terminal
        putc(c);

        if (c == 'q' || c == 'Q')
        {
            printString("\nReceived 'q'. Exiting echo test...\n");
            break;
        }
    }
    printString("Interactive Echo Test: OK\n");
}

// ============================================================================
// TEST 3: Line Buffer Reader with Backspace Handling
// Tests assembling input into a string buffer until Enter (\r or \n) is hit.
// ============================================================================
void test_console_line_reader()
{
    printString("\n--- [Console Test 3] Line Reading ---\n");
    printString("Type a full line and press Enter:\n> ");

    char buffer[128];
    int pos = 0;

    while (pos < 127)
    {
        char c = getc();

        // Handle Enter key
        if (c == '\r' || c == '\n')
        {
            putc('\n');
            break;
        }
        // Handle Backspace (ASCII 8 or 127)
        else if (c == '\b' || c == 127)
        {
            if (pos > 0)
            {
                pos--;
                // Visual backspace sequence in terminal
                putc('\b');
                putc(' ');
                putc('\b');
            }
        }
        else
        {
            buffer[pos++] = c;
            putc(c); // Visual feedback
        }
    }

    buffer[pos] = '\0';

    printString("You entered: \"");
    printString(buffer);
    printString("\"\nLine Reading Test: OK\n");
}

// ============================================================================
// TEST 4: Multi-threaded Output Stress Test
// Tests whether the console output stays stable when multiple threads print.
// ============================================================================
struct WorkerData {
    int id;
    int iterations;
};

void console_worker(void* arg)
{
    WorkerData* data = (WorkerData*)arg;

    for (int i = 1; i <= data->iterations; i++)
    {
        printString("[Thread ");
        printInteger(data->id, 10); // Base 10 for decimal numbers
        printString("] Printing message line #");
        printInteger(i, 10);
        printString("\n");

        // Force a context switch/sleep to interleave thread execution
        time_sleep(1);
    }
}

void test_console_multithreaded()
{
    printString("\n--- [Console Test 4] Multi-threaded Console Stress ---\n");

    const int THREAD_COUNT = 3;
    thread_t threads[THREAD_COUNT];
    WorkerData args[THREAD_COUNT];

    for (int i = 0; i < THREAD_COUNT; i++)
    {
        args[i].id = i + 1;
        args[i].iterations = 4;

        // FIX: Removed 4th argument 'stack' to match 3-argument signature in syscall_c.h
        thread_create(&threads[i], console_worker, &args[i]);
    }

    // Wait for all worker threads to finish
    for (int i = 0; i < THREAD_COUNT; i++)
    {
        thread_join(threads[i]);
    }

    printString("Multi-threaded Console Test: OK\n");
}

// ============================================================================
// ENTRY POINT FOR CONSOLE TESTS
// ============================================================================
void run_console_tests()
{
    printString("=========================================\n");
    printString("       RUNNING CONSOLE I/O TESTS         \n");
    printString("=========================================\n");

    test_console_basic_output();
    test_console_echo();
    test_console_line_reader();
    test_console_multithreaded();

    printString("\n=========================================\n");
    printString("     ALL CONSOLE TESTS COMPLETED!        \n");
    printString("=========================================\n");
}