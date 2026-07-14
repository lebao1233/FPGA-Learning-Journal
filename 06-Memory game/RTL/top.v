module memory(input clk,
input rst_n,
input [3:0] btn,
output reg [5:0] led);
reg [2:0] state;
reg [29:0] counter=0;
reg [1:0] pattern[0:6];
wire [3:0] rnd;
reg[2:0] level=1;
reg[2:0] input_index=0;
reg[29:0] counter_1=0;
reg[22:0] counter_2=0;
reg [3:0] btn_old;
reg [3:0] o_btn_old;
wire [3:0] btn_pressed;
assign btn_pressed = (~o_btn) & o_btn_old;
parameter GEN= 3'b000;
parameter SHOW_LED=3'b001;
parameter GAP=3'b010;
parameter WAIT=3'b011;
parameter CORRECT=3'b100;
parameter OVER= 3'b101;
parameter WIN=3'b111;
reg[2:0] show_index;
reg blink=0;
wire [3:0] o_btn;
lfsr random(.clk(clk),
.rst_n(rst_n),
.rnd(rnd));
debounce_switch top(.clk(clk),
.rst_n(rst_n),
.i_switch(btn[0]),
.o_switch(o_btn[0]));
debounce_switch top1(.clk(clk),
.rst_n(rst_n),
.i_switch(btn[1]),
.o_switch(o_btn[1]));
debounce_switch top2(.clk(clk),
.rst_n(rst_n),
.i_switch(btn[2]),
.o_switch(o_btn[2]));
debounce_switch top3(.clk(clk),
.rst_n(rst_n),
.i_switch(btn[3]),
.o_switch(o_btn[3]));
always @(posedge clk or negedge rst_n)
begin
if(!rst_n) begin
state<=GEN;
counter<=0;
show_index<=0;
level<=1;
input_index<=0;
counter_1 <= 0;
counter_2 <= 0;
blink <= 0;
led <= 6'b111111;
end 
else
begin 
o_btn_old <= o_btn;
case(state)
GEN:
begin
pattern[level-1]<=rnd[1:0];
show_index<=0;
state<=SHOW_LED;
end
SHOW_LED:
begin
case(pattern[show_index])
2'b11: led[3:0]<=4'b1110;
2'b10: led[3:0]<=4'b1101;
2'b01: led[3:0]<=4'b1011;
2'b00: led[3:0]<=4'b0111;
default: led[3:0]<=4'b1111;
endcase 
if(counter<13500000-1) begin
counter<=counter+1;
end
else begin
counter<=0;
state<=GAP;
end
end
GAP:
begin
if(counter<2700000-1) begin
counter<=counter+1;
led<=6'b111111;
end
else begin
counter<=0;
if(show_index<level-1)
begin
show_index<=show_index+1;
state<=SHOW_LED;
end
else
 begin
input_index<=0;
show_index<=0;
state<=WAIT;
end
end
end
WAIT:
begin
if(btn_pressed!=4'b0000) 
begin
case(pattern[input_index])
2'b11: 
begin
if(btn_pressed==4'b0001) begin
if(input_index<level-1)
begin
input_index<=input_index+1;
state<=WAIT;
end
else begin
input_index<=0;
state<=CORRECT;
end
end
else begin
state<=OVER;
end
end
2'b10: 
begin
if(btn_pressed==4'b0010) begin
if(input_index<level-1)
begin
input_index<=input_index+1;
state<=WAIT;
end
else begin
input_index<=0;
state<=CORRECT;
end
end
else begin
state<=OVER;
end
end
2'b01: 
begin
if(btn_pressed==4'b0100) begin
if(input_index<level-1)
begin
input_index<=input_index+1;
state<=WAIT;
end
else begin
input_index<=0;
state<=CORRECT;
end
end
else begin
state<=OVER;
end
end
2'b00: 
begin
if(btn_pressed==4'b1000) begin
if(input_index<level-1)
begin
input_index<=input_index+1;
state<=WAIT;
end
else begin
input_index<=0;
state<=CORRECT;
end
end
else begin
state<=OVER;
end
end
endcase
end
end
CORRECT:
begin
if(counter_1<27000000-1) begin
counter_1<=counter_1+1;
led<=6'b000000;
end
else 
begin
counter_1<=0;
if(level==7) begin
led<=6'b111110;
state<=WIN;
end
else begin
level<=level+1;
led<=6'b111111;
state<=GEN;
end
end
end
OVER:
begin
if(counter_1<2700000-1) begin
counter_1<=counter_1+1;
end
else begin
counter_1<=0;
blink<=~blink;
if(blink) begin
led<=6'b000000;
end
else begin
led<=6'b111111;
end
end
end
WIN:
begin
counter_2<=counter_2+1;
if(counter_2==1250000) begin
    led<={led[4:0] ,led[5]};
    counter_2<=0;
end
end
default: state<=GEN;
endcase
end
end
endmodule