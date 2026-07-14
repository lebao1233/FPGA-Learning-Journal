module debounce_switch(
input clk,
input i_switch,
input rst_n,
output reg o_switch=0);
reg [17:0] r_count=0;
always @(posedge clk or negedge rst_n) begin
if(!rst_n) begin
o_switch<=1;
r_count<=0;
end
else if(i_switch !=o_switch) begin
if(r_count<125000-1) begin
    r_count<=r_count+1;
end
else begin
   r_count<=0;
   o_switch<=i_switch;
end
end
else begin
r_count<=0;
end
end

endmodule
