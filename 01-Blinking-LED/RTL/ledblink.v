module ledblink(
input switch,
input rst_n,
input clk,
output reg [5:0] led=6'b111111
);
reg[31:0] r_count=0;

parameter counter=12500000;


always @(posedge clk or negedge rst_n) begin
if(!rst_n) begin
  led=6'b111111;
end
else begin
r_count<=r_count+1;
if(r_count==counter) begin
led<=~led; 
r_count<=0; 
end
if(switch==0) begin
led<=6'b000000;
end
end

end
endmodule