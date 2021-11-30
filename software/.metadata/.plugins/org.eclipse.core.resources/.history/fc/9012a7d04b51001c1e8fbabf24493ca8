#ifndef _paired_stack_h
#define _paired_stack_h

typedef struct pair{
    int first;
    int second;
} pair;

typedef struct paired_stack{
    int top;
    unsigned capacity;
    struct pair* pairs;
} paired_stack;

struct paired_stack* createPStack(unsigned capacity);
int PisFull(struct paired_stack* stack);
int PisEmpty(struct paired_stack* stack);
void Ppush(struct paired_stack* stack, struct pair pair);
struct pair Ppop(struct paired_stack* stack);
struct pair Ppeek(struct paired_stack* stack);

#endif
