
//////////////////////////////////////////////////////////////////////////////////
// Company: BCUBE
// Engineer: Nauman
// 
// Create Date: 10/16/2020 09:51:02 AM
// Design Name: Rfnoc_block_scheduler
// Module Name: scheduler
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module scheduler #(parameter tableLength = 10, parameter phaseWidth = 32, parameter hopCycles = 10000)
				( input ctrlport_clk, axis_data_clk, 
				  input ctrlport_rst, axis_data_rst,
				  input start,
				  input writeEn,
				  input [phaseWidth - 1: 0] writePhase,
				  output [phaseWidth-1:0] readPhase,
				  output outValid
					);
//localparam MIN_HOPCYCLES = 10000;
//localparam unsigned MAX_HOPCYCLES = 4294967295;
//localparam unsigned MAX_LENGTH = 4294967295;

reg [phaseWidth-1:0] phaseTable [0:tableLength - 1];
reg [31:0] phaseIndex = tableLength - 1;
reg [31:0] count = hopCycles - 1;
reg [31:0] writeIndex = 0;
reg valid;

always @(posedge axis_data_clk) begin : proc_writing
    if (axis_data_rst)
    begin
      writeIndex <= 0;      
    end else if (writeEn) begin      // writing Table
      if (writeIndex == tableLength - 1) begin
        writeIndex <= 32'b0;
      end else begin
        writeIndex <= writeIndex + 32'b1;
      end
      phaseTable[writeIndex] <= writePhase;
    end
end : proc_writing

always @(posedge ctrlport_clk) begin : proc_hopping 
    if (ctrlport_rst) begin  
        count  <= 32'b0;      
        valid <= 1'b0;
        phaseIndex <= 32'b0;
    end else if (start) begin         // start Scheduling
        if (count == hopCycles-1) begin
            if (phaseIndex == tableLength - 1)
                phaseIndex <= 32'b0;
            else
                phaseIndex <= phaseIndex + 32'b1;
            valid <= 1'b1;
            count  <= 32'b0;
        end else begin
            count <= count + 'b1;
            valid <= 1'b0;
        end
    end
end : proc_hopping

assign readPhase = phaseTable[phaseIndex];
assign outValid = valid;

endmodule : scheduler
