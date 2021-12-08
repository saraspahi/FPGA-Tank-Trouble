module game_states(input logic CLK, RESET,
                   input logic tank1shot, tank2shot, maze_ready,
                   input logic [31:0] keycode,
						 input logic [1:0] game_reset,
                   output logic title,
                   output logic[1:0] game_end);

    enum logic [2:0] { title_state, in_game, tank1win, tank2win, start_game } State, Next_state;
	
    logic[7:0] key; 
    always_ff @ (posedge CLK)
    begin
        if(RESET)
            State <= title_state;
        else
            State <= Next_state;
    end

    always_comb
    begin
    Next_state = State;
    game_end = 2'b00;
    title = 1'b0;

    if ((keycode[31:24] ==8'h28 )||(keycode[23:16]==8'h28)||(keycode[15:8] ==8'h28)||(keycode[7:0]==8'h28))
        key = 8'h28;
	 else
		  key = 8'h00;
    Next_state = State;
    
    unique case(State)
        title_state:
            if(key == 8'h28)
                Next_state = start_game;
		  start_game:
		      if(maze_ready)
					Next_state = in_game;
				else
					Next_state = start_game;
        tank1win:
            if(maze_ready)
                Next_state = in_game;
            else
                Next_state = tank1win;
		  tank2win:
		      if(maze_ready)
					Next_state = in_game;
				else
					Next_state = tank2win;
        in_game:
            if(tank1shot)
                Next_state = tank2win;
				else if(tank2shot)
				    Next_state = tank1win;
            else
                Next_state = in_game;
				default:;
    endcase

    case(State)
        title:
        begin
            title = 1'b1;
        end
        tank1win:
        begin
            game_end = 2'b01;
        end
		  tank2win:
		  begin
				game_end = 2'b10;
		  end
		  start_game:
		  begin
				game_end = 2'b11;
		  end
        in_game:
        begin
            game_end = 2'b00;
        end
		  default:;
    endcase

    end
endmodule