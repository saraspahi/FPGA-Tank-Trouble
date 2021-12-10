// Inspired by https://www.geeksforgeeks.org/stack-data-structure-introduction-program/
// modified to be a stack of structs containing paired integeres

#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include "../mazes/paired_stack.h"






struct paired_stack* createPStack(unsigned capacity)
{
    struct paired_stack* stack = (struct paired_stack*)malloc(sizeof(struct pair));
    stack->capacity = capacity*2;
    stack->top = -1;
    stack->pairs = (struct pair*)malloc(stack->capacity * sizeof(int));
    return stack;
}


int PisFull(struct paired_stack* stack)
{
    return stack->top == stack->capacity - 1;
}


int PisEmpty(struct paired_stack* stack)
{
    return stack->top == -1; 
}


void Ppush(struct paired_stack* stack, struct pair pair)
{
    if(PisFull(stack))
        return;
    stack->pairs[++stack->top] = pair;
}


struct pair Ppop(struct paired_stack* stack)
{
    if(PisEmpty(stack))
        return (struct pair){0,0};
    return stack->pairs[stack->top--];
}


struct pair Ppeek(struct paired_stack* stack)
{
    if(PisEmpty(stack))
        return (struct pair){0,0};
    return stack->pairs[stack->top];
}


