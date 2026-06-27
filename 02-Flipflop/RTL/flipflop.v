module flip_flop(input switch,
input clk, 
output led);

wire clean_switch;
deboune_switch u_instance(
.clk(clk),
.i_switch(switch),
.o_switch(clean_switch));
reg r_switch=1;
reg r_led=1;
always @(posedge clk) begin
r_switch<=clean_switch;
if(clean_switch==1 && r_switch==0) begin
 r_led<=~r_led;
end
  end
assign led=r_led;
endmodule
                 