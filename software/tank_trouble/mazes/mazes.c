// Recursive Backtracking alogrithim implementation in C 
// Inspired by OneLoneCoders C++ implmentation
// Used our own console/screen buffer and modified to use our own stacks in C
// Source: https://github.com/OneLoneCoder/videos/blob/master/OneLoneCoder_Mazes.cpp


#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <alt_types.h>
#include <system.h>
#include "../mazes/stack.h"
#include "../mazes/paired_stack.h"
#include "../mazes/mazes.h"
#include "../usb_kb/GenericMacros.h"
#include "../usb_kb/GenericTypeDefs.h"


//    struct Stack* stack = createStack(100);
//    push(stack, 10);
//    push(stack, 20);
 
//    printf("%d popped from stack\n", pop(stack));

//    struct paired_stack* pstack = createPStack(100);

//    Ppush(pstack, (struct pair){1,1});
//    Ppush(pstack, (struct pair){2,4});

//    printf("popped (%d, %d) off da stack \n", Ppeek(pstack).first, Ppeek(pstack).second);
 
#define offset(x,y) ((Ppeek(m_stack).second + y) * mazeWidth + (Ppeek(m_stack).first+x))


void genMaze(alt_u8 t1Score, alt_u8 t2Score)
{
    srand(time(NULL));
    static int PATH_N = 0x01;
    static int PATH_E = 0x02;
    static int PATH_S = 0x04;
    static int PATH_W = 0x08;
    static int VISITED = 0x10;
    int mazeWidth = 8;
    int mazeHeight = 5;
    int pathWidth = 19;
    struct Stack* neighbors = createStack(4);
    struct paired_stack* m_stack = createPStack(mazeWidth*mazeHeight);
    int visitedCells;
    
    alt_u8 maze_screen_buffer[120][160];

    int m_maze[mazeWidth*mazeHeight];
    memset(m_maze, 0x00, mazeWidth*mazeHeight*sizeof(int));
    
    int x = rand() % mazeWidth;
    int y = rand() % mazeHeight;
    printf("x: %d, y: %d", x, y);

    Ppush(m_stack, (struct pair){x,y});
    m_maze[y*mazeWidth + x] = VISITED;

    printf("offset is %d \n", offset(0,0));
    visitedCells = 1;

    int next_cell_dir;

    while(visitedCells < mazeWidth*mazeHeight){
        while(!isEmpty(neighbors))
            pop(neighbors);
        if(Ppeek(m_stack).second > 0 && (m_maze[offset(0,-1)] & VISITED) == 0)
            push(neighbors, 0);
        if(Ppeek(m_stack).first < (mazeWidth -1) && (m_maze[offset(1,0)] & VISITED) == 0)
            push(neighbors, 1);
        if(Ppeek(m_stack).second < (mazeHeight -1) && (m_maze[offset(0,1)] & VISITED) == 0)
            push(neighbors, 2);
        if(Ppeek(m_stack).first > 0 && (m_maze[offset(-1,0)] & VISITED) == 0)
            push(neighbors, 3);
        
        if(!isEmpty(neighbors)){
            next_cell_dir = neighbors->array[rand() % (neighbors->top + 1)];
            struct pair temp = Ppeek(m_stack);
            switch (next_cell_dir){
            case 0:
                m_maze[offset(0,-1)] |= VISITED | PATH_S;
                m_maze[offset(0,0)] |= PATH_N;
                Ppush(m_stack, (struct pair) {temp.first + 0, temp.second -1});
                break;
            case 1:
                m_maze[offset(1,0)] |= VISITED | PATH_W;
                m_maze[offset(0,0)] |= PATH_E;
                Ppush(m_stack, (struct pair){temp.first + 1, temp.second -0});
                break;
            case 2:
                m_maze[offset(0,1)] |= VISITED | PATH_N;
                m_maze[offset(0,0)] |= PATH_S;
                Ppush(m_stack, (struct pair){temp.first + 0, temp.second +1});
                break;
            case 3:
                m_maze[offset(-1,0)] |= VISITED | PATH_E;
                m_maze[offset(0,0)] |= PATH_W;
                Ppush(m_stack, (struct pair){temp.first - 1, temp.second +0});
                break;
            }
            visitedCells++;
        }
        else
            Ppop(m_stack);
   }
 
    for(int i = 0; i<120; i++){
        for(int j=0; j<160; j++){
            maze_screen_buffer[i][j] = 1;
        }
    }

    for(int i = 0; i<19; i++){
    	for(int j=0; j<160; j++){
    		maze_screen_buffer[i][j] = 0;
    	}
    }


    // To whoever is reading this... I'm sorry
    alt_u8 zero[16][8] = {{0,0,1,1,1,1,0,0},
						  {0,1,0,0,0,0,1,0},
						  {1,0,0,0,0,0,0,1},
						  {1,0,0,0,0,0,0,1},
						  {1,0,0,0,0,0,0,1},
						  {1,0,0,0,0,0,0,1},
						  {1,0,0,0,0,0,0,1},
						  {1,0,0,0,0,0,0,1},
						  {1,0,0,0,0,0,0,1},
						  {1,0,0,0,0,0,0,1},
						  {1,0,0,0,0,0,0,1},
						  {1,0,0,0,0,0,0,1},
						  {1,0,0,0,0,0,0,1},
						  {1,0,0,0,0,0,0,1},
						  {0,1,0,0,0,0,1,0},
						  {0,0,1,1,1,1,0,0}};

    alt_u8 one[16][8] =  {{0,0,1,1,0,0,0,0},
						  {0,1,0,0,1,0,0,0},
						  {0,0,0,0,1,0,0,0},
						  {0,0,0,0,1,0,0,0},
						  {0,0,0,0,1,0,0,0},
						  {0,0,0,0,1,0,0,0},
						  {0,0,0,0,1,0,0,0},
						  {0,0,0,0,1,0,0,0},
						  {0,0,0,0,1,0,0,0},
						  {0,0,0,0,1,0,0,0},
						  {0,0,0,0,1,0,0,0},
						  {0,0,0,0,1,0,0,0},
						  {0,0,0,0,1,0,0,0},
						  {0,0,0,0,1,0,0,0},
						  {0,0,0,0,1,0,0,0},
						  {0,0,1,1,1,1,1,0}};

    alt_u8 two[16][8] =  {{0,0,1,1,1,1,0,0},
						  {0,1,0,0,0,0,1,0},
						  {1,0,0,0,0,0,0,1},
						  {1,0,0,0,0,0,0,1},
						  {0,0,0,0,0,0,0,1},
						  {0,0,0,0,0,0,1,0},
						  {0,0,0,0,0,1,0,0},
						  {0,0,0,0,1,0,0,0},
						  {0,0,0,1,0,0,0,0},
						  {0,0,1,0,0,0,0,0},
						  {0,1,0,0,0,0,0,0},
						  {1,0,0,0,0,0,0,0},
						  {1,0,0,0,0,0,0,0},
						  {1,0,0,0,0,0,0,0},
						  {1,0,0,0,0,0,0,0},
						  {1,1,1,1,1,1,1,1}};

    alt_u8 three[16][8] = {{0,0,1,1,1,1,0,0},
   						  {0,1,0,0,0,0,1,0},
   						  {1,0,0,0,0,0,0,1},
   						  {0,0,0,0,0,0,0,1},
   						  {0,0,0,0,0,0,0,1},
   						  {0,0,0,0,0,0,0,1},
   						  {0,0,0,0,0,0,1,0},
   						  {0,1,1,1,1,1,0,0},
   						  {0,0,0,0,0,0,1,0},
   						  {0,0,0,0,0,0,0,1},
   						  {0,0,0,0,0,0,0,1},
   						  {0,0,0,0,0,0,0,1},
   						  {0,0,0,0,0,0,0,1},
   						  {1,0,0,0,0,0,0,1},
   						  {0,1,0,0,0,0,1,0},
   						  {0,0,1,1,1,1,0,0}};
    // tank1 hardcode
    int t1scorepos = 60;
    int t2scorepos = 90;

    if(t1Score == 0){
    	for(int i = 2; i < 18; i++){
    		for(int j = t1scorepos; j<t1scorepos+8; j++){
    			maze_screen_buffer[i][j] = zero[i-2][j-t1scorepos];
    		}
    	}
    }

    if(t1Score == 1){
    	for(int i = 2; i < 18; i++){
    		for(int j = t1scorepos; j<t1scorepos+8; j++){
    			maze_screen_buffer[i][j] = one[i-2][j-t1scorepos];
    		}
    	}
    }

    if(t1Score == 2){
      	for(int i = 2; i < 18; i++){
      		for(int j = t1scorepos; j<t1scorepos+8; j++){
      			maze_screen_buffer[i][j] = two[i-2][j-t1scorepos];
      		}
      	}
      }

      if(t1Score == 3){
      	for(int i = 2; i < 18; i++){
      		for(int j = t1scorepos; j<t1scorepos+8; j++){
      			maze_screen_buffer[i][j] = three[i-2][j-t1scorepos];
      		}
      	}
      }


    // tank 2 hardcode
      if(t2Score == 0){
      	for(int i = 2; i < 18; i++){
      		for(int j = t2scorepos; j<t2scorepos+8; j++){
      			maze_screen_buffer[i][j] = zero[i-2][j-t2scorepos];
      		}
      	}
      }

      if(t2Score == 1){
      	for(int i = 2; i < 18; i++){
      		for(int j = t2scorepos; j<t2scorepos+8; j++){
      			maze_screen_buffer[i][j] = one[i-2][j-t2scorepos];
      		}
      	}
      }

      if(t2Score == 2){
        	for(int i = 2; i < 18; i++){
        		for(int j = t2scorepos; j<t2scorepos+8; j++){
        			maze_screen_buffer[i][j] = two[i-2][j-t2scorepos];
        		}
        	}
        }

      if(t2Score == 3){
        	for(int i = 2; i < 18; i++){
        		for(int j = t2scorepos; j<t2scorepos+8; j++){
        			maze_screen_buffer[i][j] = three[i-2][j-t2scorepos];
        		}
        	}
        }


    for(int x = 0; x<mazeWidth; x++){
        for(int y = 0; y<mazeHeight; y++){
            for(int py = 0; py<pathWidth; py++){
                for(int px = 0; px<pathWidth; px++){
                    maze_screen_buffer[y*(pathWidth + 1) + py + 20][x*(pathWidth+1) + px] = 0;
                }
            }
            for(int p = 0; p<pathWidth; p++){
                if(m_maze[y*mazeWidth + x] & PATH_S)
                    maze_screen_buffer[y*(pathWidth+1)+pathWidth + 20][x*(pathWidth+1)+p] = 0;
                if(m_maze[y*mazeWidth + x] & PATH_E)
                    maze_screen_buffer[y*(pathWidth+1)+p + 20][x*(pathWidth+1)+pathWidth] = 0;

            }
            
        }
    }

	struct MAZE{
		alt_u32 VRAM [120*5]; //Week 2 - extended VRAM
	};
	//you may have to change this line depending on your platform designer
	static volatile struct MAZE* vga_ctrl = 0x00001000;
	unsigned int tempVal = 0;

	for (int fort=0; fort<120; fort++){
		for(int nite=0 ; nite< 160; nite++){
			tempVal += maze_screen_buffer[fort][nite];
			if((nite+1)%32 != 0){

				tempVal = tempVal << 1;
			}
			else if((nite+1)%32 == 0){
				//printf("%d \n", fort*5+(int)((nite)/32));
				vga_ctrl->VRAM[fort*5+(int)((nite)/32)] = tempVal;
				tempVal = 0;
			}
		}
	}


//    for(int i = 0; i<120; i++){
//        printf("%d \n", i);
//        for(int j=0; j<160; j++){
//            printf("%d", maze_screen_buffer[i][j]);
//        }
//    }
}
