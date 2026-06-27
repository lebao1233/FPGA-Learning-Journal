module uart_rx(input clk,
               input rst_n,
              input i_rx_serial,
              output o_rx_dv,
               output [7:0] o_rx_serial);
parameter clk_per_bit= 234;
parameter idle=3'b000;
parameter rx_start=3'b001;
parameter rx_data=3'b010;
parameter rx_stop=3'b011;
reg[2:0] state=idle;
  reg [8:0] r_clk_count;
  reg [7:0] rx_byte;
  reg [2:0] rx_index_bit;
  reg rx_dv;
  always@(posedge clk or negedge rst_n) begin 
    if(!rst_n) begin
        state<=idle;
      rx_index_bit<=0;
      r_clk_count<=0;
      rx_byte<=0;
      rx_dv<=0;
    end
    else begin
  case(state)
    idle:
      begin 
        rx_index_bit<=0;
        rx_dv<=0;
        r_clk_count<=0;
        if(i_rx_serial==0) 
          begin
         state<=rx_start;
          end
        else
          begin
          state<=idle; 
        end
       end//idle case
    rx_start:
         begin
            if(r_clk_count<(clk_per_bit-1)/2) 
              begin
              r_clk_count<=r_clk_count+1;
              state<=rx_start;
              end
              else begin
                if(i_rx_serial==0) begin
                state<=rx_data;
              r_clk_count<=0;
                end
             else
               begin
               state<=idle;
                end
              end
         end//start case
    rx_data:
           begin
             if(r_clk_count<clk_per_bit-1) 
               begin
               r_clk_count<=r_clk_count+1;
               state<=rx_data;
               end
               else
                 begin
                 rx_byte[rx_index_bit]<=i_rx_serial;
                    if(rx_index_bit<7) 
                      begin
                       rx_index_bit<=rx_index_bit+1;
                       state<=rx_data;
                       r_clk_count<=0; 
                      end
                    else 
                      begin
                        
                        state<=rx_stop;
                        r_clk_count<=0;
                        rx_index_bit<=0;
                      end
                 end
           end
    rx_stop:
           begin
             if(r_clk_count<clk_per_bit-1) 
               begin
               r_clk_count<=r_clk_count+1;
               state<=rx_stop;
             end
             else 
               begin 
               if(i_rx_serial==1)
                 begin
                 state<=idle;
                 r_clk_count<=0;
                 rx_dv<=1;
                 end
                 else
                   begin
                   state <= idle;
                   rx_dv <= 0;
                   end
             
           end
           end
   
           
           default:
           state<=idle;
           
           endcase
           
         end
  end
  

 assign o_rx_dv=rx_dv;
 assign o_rx_serial=rx_byte;
    endmodule