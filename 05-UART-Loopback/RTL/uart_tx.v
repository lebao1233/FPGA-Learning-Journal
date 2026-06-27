module uart_tx(input clk,
               input rst_n,
               input [7:0] i_tx_byte,
               input tx_dv,
               output reg o_tx_serial);
  parameter clk_per_bit=234;
  parameter idle=3'b000;
  parameter start=3'b001;
  parameter data=3'b010;
  parameter stop=3'b011;
  reg[2:0] state=idle;
  reg[7:0] tx_data;
  reg[2:0] bit_index;
  reg[8:0] counter;
  always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      counter<=0;
      state<=idle;
      bit_index<=0;
      o_tx_serial<=1;
      tx_data<=0;
    end
    else begin
    case(state)
      idle:
        begin
          o_tx_serial <= 1;
          bit_index<=0;
          counter<=0;
          if(tx_dv==1) 
            begin
              tx_data <= i_tx_byte;
             state<=start;
            end
             else begin
               state<=idle;
             end
        end
      start:
        begin
          o_tx_serial<=0;
          if(counter<clk_per_bit) begin
            counter<=counter+1;
            state<=start;
          end
        else begin
          
           counter<=0;
          state<=data;
        end
        end
      data:
        begin
          o_tx_serial<=tx_data[bit_index];
          if(counter<clk_per_bit) begin
            counter<=counter+1;
            state<=data;
          end
          else begin
            counter<=0;
          
          if(bit_index<7) begin
            bit_index<=bit_index+1;
          end
            else begin
              bit_index<=0;
              state<=stop;
            end
          end
        end
      stop:
        begin
          o_tx_serial<=1;
          if(counter<clk_per_bit) begin
            counter<=counter+1;
            state<=stop;
          end
          else begin
          counter<=0;
            
        state<=idle;
          end
        end
      default: state<=idle;
    endcase
    end
  end
  
    endmodule
            