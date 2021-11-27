#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include "stack.h"

int main()
{
    struct Stack* stack = createStack(100);
 
    push(stack, 10);
    push(stack, 20);
    push(stack, 30);
 
    printf("%d popped from stack\n", pop(stack));
 
    return 0;
}
