// figure out what this encoder does -- differs a bit from Homework 7
module encoder                    // use this one
(  input             clk,
   input             rst,
   input             enable_i,
   input             d_in,
   output logic      valid_o,
   output      [1:0] d_out);
   
   logic         [2:0] cstate;
   logic         [2:0] nstate;
   
   logic         [1:0] d_out_reg;

   assign   d_out    =  (enable_i)? d_out_reg:2'b00;

   always_comb begin
      valid_o  =   enable_i;
      case (cstate)
         3'b000: begin
               if (!d_in) begin
                  nstate = 3'b000; // Next state if d_in is 0
                  d_out_reg = 2'b00; // Output if d_in is 0
               end else begin
                  nstate = 3'b100; // Next state if d_in is 1
                  d_out_reg = 2'b11; // Output if d_in is 1
               end
         end
         3'b001: begin
               if (!d_in) begin
                  nstate = 3'b100;
                  d_out_reg = 2'b00;
               end else begin
                  nstate = 3'b000;
                  d_out_reg = 2'b11;
               end
         end
         3'b010: begin
               if (!d_in) begin
                  nstate = 3'b101;
                  d_out_reg = 2'b10;
               end else begin
                  nstate = 3'b001;
                  d_out_reg = 2'b01;
               end
         end
         3'b011: begin
               if (!d_in) begin
                  nstate = 3'b001;
                  d_out_reg = 2'b10;
               end else begin
                  nstate = 3'b101;
                  d_out_reg = 2'b01;
               end
         end
         3'b100: begin
               if (!d_in) begin
                  nstate = 3'b010;
                  d_out_reg = 2'b10;
               end else begin
                  nstate = 3'b110;
                  d_out_reg = 2'b01;
               end
         end
         3'b101: begin
               if (!d_in) begin
                  nstate = 3'b110;
                  d_out_reg = 2'b10;
               end else begin
                  nstate = 3'b010;
                  d_out_reg = 2'b01;
               end
         end
         3'b110: begin
               if (!d_in) begin
                  nstate = 3'b111;
                  d_out_reg = 2'b00;
               end else begin
                  nstate = 3'b011;
                  d_out_reg = 2'b11;
               end
         end
         3'b111: begin
               if (!d_in) begin
                  nstate = 3'b011;
                  d_out_reg = 2'b00;
               end else begin
                  nstate = 3'b111;
                  d_out_reg = 2'b11;
               end
         end
         default: begin
               nstate = 3'b000; // Safe default
               d_out_reg = 2'b00;
         end
      endcase
   end								   

   always @ (posedge clk,negedge rst)   begin
//      $display("data in=%d state=%b%b%b data out=%b%b",d_in,reg_1,reg_2,reg_3,d_out_reg[1],d_out_reg[0]);
      if(!rst)
         cstate   <= 3'b000;
      else if(!enable_i)
         cstate   <= 3'b000;
      else
         cstate   <= nstate;
   end

endmodule
