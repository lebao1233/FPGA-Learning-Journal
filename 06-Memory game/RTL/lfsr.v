module lfsr(input clk,
input rst_n,
output reg [3:0] rnd);
reg [29:0] counter;
always@(posedge clk or negedge rst_n)
begin
if(!rst_n) begin
 rnd<=4'b1110;
counter<=0;
end
else 
begin
rnd<={rnd[2:0], rnd[3]^rnd[2]};
end
end
endmodule