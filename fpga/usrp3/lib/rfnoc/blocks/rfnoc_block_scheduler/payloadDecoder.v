//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2020 10:52:57 AM
// Design Name: 
// Module Name: payloadDecoder
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

    
module payloadDecoder #(parameter CHDR_W = 64)(

      input               clk,
      input               reset,
      // Payload Stream to User Logic: in
      input [32-1:0]  m_in_payload_tdata,
      input [1-1:0]       m_in_payload_tkeep,
      input               m_in_payload_tlast,
      input               m_in_payload_tvalid,
      input               m_in_payload_tready,
      // Context Stream to User Logic: in
      input [CHDR_W-1:0]  m_in_context_tdata,
      input [3:0]         m_in_context_tuser,
      input               m_in_context_tlast,
      input               m_in_context_tvalid,
      input               m_in_context_tready,
      
      // Decoded Information
      output [31:0]       phase,
      output              writeEn
    );
reg [31:0] phaseOut;
reg writeEnOut;
reg [15:0] L = 0, L_count = 0;
reg [2:0] decodeType = 0; // 0: No decode, 1: only phase values
reg payload_context_align;
(* keep = "true" *) reg err = 0; // for debug

always @ (posedge clk) begin // context and payload head
    if (reset) begin
        L <= 0;
        L_count <= 0;
        decodeType <= 0;
        err <= 0;
    end else if ((m_in_context_tvalid == 1) && (m_in_context_tuser == 0)) begin // checking if its CHDR Header
        if (m_in_payload_tvalid && ~m_in_payload_tlast) begin  // checking whether payload comes write after context or not
            payload_context_align <= 1;
        end else begin 
            payload_context_align <= 0;
            L_count <= m_in_context_tdata[31:16];           // if aligned start counting rightaway
        end
        L <= m_in_context_tdata[31:16];                     // Store the length of payload from CHDR header           
    end else if (m_in_payload_tvalid) begin
        if (payload_context_align && m_in_payload_tlast) begin                    // if payload was not aligned with its context
            L_count <= L;
        end else begin
            L_count <= L_count - 4; //if it ever goes to zero there is something wrong
        end 
        if (L == L_count && L != 0) begin // at this point we will have payload header 
            decodeType <= m_in_payload_tdata[31:29]; // Here we will pass the Type of Table to write
        end else if (m_in_payload_tlast) begin
            decodeType <= 0;        // if last payload then stop writeEn
        end
        if (L_count == 0) begin
            err <= 1;
        end
    end 
end

always@ (posedge clk) begin
    if (m_in_payload_tvalid) begin
        case (decodeType)
            1: begin 
                writeEnOut <= 1; 
                phaseOut <= m_in_payload_tdata; 
            end
            default: begin 
                writeEnOut <= 0;
                phaseOut <= 0; 
            end 
        endcase
    end
end
    
assign phase = phaseOut;
assign writeEn = writeEnOut;

endmodule : payloadDecoder
