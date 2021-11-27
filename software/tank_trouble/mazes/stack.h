#ifndef _stack_h
#define _stack_h

typedef struct Stack{
    int top;
    unsigned capacity;
    int* array;
} Stack;

struct Stack* createStack(unsigned capacity);
int isFull(struct Stack* stack);
int isEmpty(struct Stack* stack);
void push(struct Stack* stack, int item);
int pop(struct Stack* stack);
int peek(struct Stack* stack);

#endif
