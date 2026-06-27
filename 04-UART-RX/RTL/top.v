module top(input clk,
           input i_rx_serial,
           input rst_n,
           output reg [5:0] led=6'b111111);
wire rx_dv;
wire [7:0] rx_byte;
uart_rx u_instance(
.clk(clk),
.rst_n(rst_n),
.i_rx_serial(i_rx_serial),
.o_rx_serial(rx_byte),
.o_rx_dv(rx_dv));
always @(posedge clk or negedge rst_n) begin
if(!rst_n) begin
   led<=6'b111111;
end
else if(rx_dv==1) begin
 led<=~rx_byte [5:0];
end
end
endmodule