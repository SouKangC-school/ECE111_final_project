module tbu
(
   input       clk,
   input       rst,
   input       enable,
   input       selection,
   input [7:0] d_in_0,
   input [7:0] d_in_1,
   output logic  d_o,
   output logic  wr_en);

   logic         d_o_reg;
   logic         wr_en_reg;
   
   logic   [2:0] pstate;
   logic   [2:0] nstate;

   logic         selection_buf;

   always @(posedge clk)    begin
      selection_buf  <= selection;
      wr_en          <= wr_en_reg;
      d_o            <= d_o_reg;
   end
   always @(posedge clk, negedge rst) begin
      if(!rst)
         pstate   <= 3'b000;
      else if(!enable)
         pstate   <= 3'b000;
      else if(selection_buf && !selection)
         pstate   <= 3'b000;
      else
         pstate   <= nstate;
   end

/*  combinational logic drives:
wr_en_reg, d_o_reg, nstate (next state)
from selection, d_in_1[pstate], d_in_0[pstate]
See assignment text for details
*/
   always @* begin
      // Default assignments
      wr_en_reg = selection_buf;
      d_o_reg = (selection_buf) ? d_in_1[pstate] : 0;

      case ({pstate, selection, d_in_0[pstate], d_in_1[pstate]})
         5'b00000: nstate = 3'b000;
         5'b00001: nstate = 3'b001;
         5'b00010: nstate = 3'b000;
         5'b00011: nstate = 3'b001;
         5'b00100: nstate = 3'b011;
         5'b00101: nstate = 3'b010;
         5'b00110: nstate = 3'b011;
         5'b00111: nstate = 3'b010;
         5'b01000: nstate = 3'b100;
         5'b01001: nstate = 3'b101;
         5'b01010: nstate = 3'b100;
         5'b01011: nstate = 3'b101;
         5'b01100: nstate = 3'b111;
         5'b01101: nstate = 3'b110;
         5'b01110: nstate = 3'b111;
         5'b01111: nstate = 3'b110;
         5'b10000: nstate = 3'b001;
         5'b10001: nstate = 3'b000;
         5'b10010: nstate = 3'b001;
         5'b10011: nstate = 3'b000;
         5'b10100: nstate = 3'b010;
         5'b10101: nstate = 3'b011;
         5'b10110: nstate = 3'b010;
         5'b10111: nstate = 3'b011;
         5'b11000: nstate = 3'b101;
         5'b11001: nstate = 3'b100;
         5'b11010: nstate = 3'b101;
         5'b11011: nstate = 3'b100;
         5'b11100: nstate = 3'b110;
         5'b11101: nstate = 3'b111;
         5'b11110: nstate = 3'b110;
         5'b11111: nstate = 3'b111;
      endcase
   end

endmodule
