module bmc111 
(
   input    [1:0] rx_pair,
   output   [1:0] path_0_bmc,
   output   [1:0] path_1_bmc);

   // Direct computation as per the given logic
   wire tmp00 = rx_pair[0];
   wire tmp01 = rx_pair[1];
   wire tmp10 = !tmp00;
   wire tmp11 = !tmp01;

   // Path 0 BMC calculation
   assign path_0_bmc[1] = tmp00 & tmp01;
   assign path_0_bmc[0] = tmp00 ^ tmp01;

   // Path 1 BMC calculation
   assign path_1_bmc[1] = tmp10 & tmp11;
   assign path_1_bmc[0] = tmp10 ^ tmp11;

endmodule
