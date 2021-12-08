/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  frameRAM
(
		input [2:0] data_In,
		input [18:0] wraddress, rdaddress,
		input we, Clk,

		output logic [2:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [2:0] mem [0:399];

initial
begin
	 $readmemh("sprites/title.txt", mem);
end


always_ff @ (posedge Clk) begin
	if (we)
		mem[wraddress] <= data_In;
	data_Out<= mem[rdaddress];
end

endmodule
