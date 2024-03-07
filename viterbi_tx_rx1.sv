// contains convolutional encoder,
//  (possibly corrupting) channel,
//  and Viterbi decoder
// parameter N sets the channel bit error rate
//  e.g. when N=4, 256 test cases (512 total bits) have 53 error bits,
//  about 1 bad bit out of every 10
// For N=3, 256 test cases gave me 179 bad bits 
module viterbi_tx_rx #(parameter N=2) (
   input    clk,
   input    rst,
   input    encoder_i,
   input    enable_encoder_i,
   output   decoder_o);

   wire  [1:0] encoder_o;  // connects encoder to decoder

   int           error_counter,
                 bad_bit_ct,
                 word_ct;
   logic   [1:0] encoder_o_reg;
   logic         encoder_i_reg;
   logic         enable_decoder_in;
   logic         enable_encoder_i_reg;
   wire          valid_encoder_o;
   logic   [1:0] err_inj;

   always @ (posedge clk, negedge rst) 
      if(!rst) begin  
         error_counter        <= 'd0;
         encoder_o_reg        <= 'b0;
         enable_decoder_in    <= 'b0;
		 enable_encoder_i_reg <= 'b0;
		 word_ct              <= 'b0;
      end
      else  begin 
         enable_encoder_i_reg <= enable_encoder_i;  
         enable_decoder_in    <= valid_encoder_o; 
//         encoder_o_reg        <= 'b0;
         error_counter        <= $random;
         word_ct              <= word_ct + 1;			
// bit error injection in encoder_o_reg        					           					           
         encoder_i_reg     <= encoder_i;
         if(error_counter[N-1:0]=='1) begin
		    err_inj        <= error_counter[29:28];
            if(word_ct<256)
              bad_bit_ct     <= bad_bit_ct + error_counter[29] + error_counter[28];
			$display("error_counter,err_inj = %h %b %d",error_counter,err_inj,bad_bit_ct);
            encoder_o_reg  <= encoder_o^err_inj;	 // inject bad bits 
         end
         else begin       		   // clean version
            encoder_o_reg  <= {encoder_o[1],encoder_o[0]};
            err_inj        <= 2'b0;
		end
      end   


// insert your convolutional encoder here
// change port names and module name as necessary/desired
   encoder encoder1	     (
      .clk,
      .rst,
      .enable_i(enable_encoder_i), //_reg),
      .d_in    (encoder_i),        //_reg),
      .valid_o (valid_encoder_o),
      .d_out   (encoder_o)   );

// insert your term project code here 
   decoder decoder1	     (
      .clk,
      .rst,
      .enable (enable_decoder_in),
      .d_in   (encoder_o_reg),
      .d_out  (decoder_o)   );

endmodule
