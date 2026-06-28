module shift_register(input clk,
                      input rst_n,
                      output reg [5:0] led=6'b011111);
reg[21:0] counter=0;
always@(posedge clk or negedge rst_n) begin
if(!rst_n) begin
led<=6'b011111;
counter<=0;
end
else 
begin
counter<=counter+1;
if(counter==1250000) begin
    led<={led[4:0] ,led[5]};
    counter<=0;
end
end
end
endmodule