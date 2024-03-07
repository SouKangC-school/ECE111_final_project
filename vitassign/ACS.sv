module ACS		                        // add-compare-select
(
   input       path_0_valid,
   input       path_1_valid,
   input [1:0] path_0_bmc,	            // branch metric computation
   input [1:0] path_1_bmc,				
   input [7:0] path_0_pmc,				// path metric computation
   input [7:0] path_1_pmc,

   output logic        selection,
   output logic        valid_o,
   output      [7:0] path_cost);  

   wire  [7:0] path_cost_0;			   // branch metric + path metric
   wire  [7:0] path_cost_1;

/* Fill in the guts per ACS instructions
*/
   // Compute path costs as the sum of path and branch metrics
   wire [7:0] path_cost_0 = path_0_pmc + {6'b000000, path_0_bmc};  // Extend branch metric to 8 bits
   wire [7:0] path_cost_1 = path_1_pmc + {6'b000000, path_1_bmc};  // Extend branch metric to 8 bits

   // Determine output validity
   assign valid_o = path_0_valid | path_1_valid;

   // Select the best (lowest cost) path
   always @* begin
      if (!path_0_valid && !path_1_valid) begin
         selection = 0; // Default selection when both paths are invalid
         path_cost = 8'b0;
      end else if (!path_0_valid) begin
         selection = 1; // Select path 1 if path 0 is not valid
         path_cost = path_cost_1;
      end else if (!path_1_valid) begin
         selection = 0; // Select path 0 if path 1 is not valid
         path_cost = path_cost_0;
      end else begin
         // When both paths are valid, select based on lower path cost
         if (path_cost_0 > path_cost_1) begin
               selection = 1;
               path_cost = path_cost_1;
         end else begin
               selection = 0;
               path_cost = path_cost_0;
         end
      end
   end

endmodule
