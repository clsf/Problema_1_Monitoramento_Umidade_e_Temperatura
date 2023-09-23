module baudrate_gen(clk, tick);

input clk; 
output reg tick; // Saída do clock em 9600 Hz
reg[27:0] counter=28'd0;
parameter DIVISOR = 28'd5208; // 50Mhz/9600 = 5208

always @(posedge clk)
begin
 counter <= counter + 28'd1;
 if(counter>=(DIVISOR-1)) // Fim do periodo
  counter <= 28'd0;

 tick <= (counter<DIVISOR/2)?1'b1:1'b0; // Decide se vai ser a parte em alto ou em baixa do periodo

end
endmodule