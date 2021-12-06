module game_states(input logic CLK, RESET,
                   input logic hit, maze_ready,
                   input logic [31:0] keycode,
                   output logic title,
                   output logic[1:0] game_end);

    enum logic [2:0] { title_state, in_game, new_round } State, Next_state;

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
                Next_state = new_round;
        new_round:
            if(maze_ready)
                Next_state = in_game;
            else
                Next_state = new_round;
        in_game:
            if(hit)
                Next_state = new_round;
            else
                Next_state = in_game;
				default:;
    endcase

    case(State)
        title:
        begin
            title = 1'b1;
        end
        new_round:
        begin
            game_end = 2'b01;
        end
        in_game:
        begin
            game_end = 2'b00;
        end
		  default:;
    endcase

    end
endmodule