module deboune_switch(
input clk,
input i_switch,
output o_switch);
reg r_state=1;
reg [17:0] r_count=0;
always @(posedge clk) begin
 if(i_switch !=r_state) begin
if(r_count<125000) begin
    r_count<=r_count+1;
end
else begin
   r_count<=0;
   r_state<=i_switch;
end
end
else begin
r_count<=0;
end
end
assign o_switch=r_state;
endmodule
