module top(input clk,
           input rst_n,
           input uart_rx,
           output uart_tx,
           output reg [5:0] led=6'b11111);

wire dv;
wire [7:0] data;
uart_rx u_instance1(
.clk(clk),
.rst_n(rst_n),
.i_rx_serial(uart_rx),
.o_rx_serial(data),
.o_rx_dv(dv));   
always @(posedge clk or negedge rst_n) begin
if(!rst_n) begin
   led<=6'b111111;
end
else begin 
 if (dv==1) begin
 led<=~data[5:0];
end
end
end
uart_tx u_instance2(
.clk(clk),
.rst_n(rst_n),
.i_tx_byte(data),
.o_tx_serial(uart_tx),
.tx_dv(dv));
endmodule