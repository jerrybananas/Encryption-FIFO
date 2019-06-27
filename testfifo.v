 // The timescale directive  
 `timescale     10 ps/ 10 ps  
 // Preprocessor Directives  
 `define          DELAY 10  

module FIFObuffer_tb;
 // Parameter definitions  
 parameter     ENDTIME      = 4000;  
 // Inputs
 reg Clk;
 reg [31:0] Data_IN;
 reg QUE_Read_Write;
 reg Cen;
 reg reset;
 reg [31:0] Cipher_Key;
 // Outputs
 wire [31:0] QUE_Data_Out;
 wire QUE_Empty;
 wire QUE_Full;
 wire QUE_Last;
 integer i;
 // Instantiate the Unit Under Test (UUT)
 FIFObuffer uut ( Clk,Data_IN, Cen, QUE_Data_Out, reset, QUE_Empty, QUE_Full, QUE_Last, QUE_Read_Write, Cipher_Key );

 initial begin
	  // Initialize Inputs
	  Clk  = 1'b0;
	  Data_IN  = 32'd0;
	  Cipher_Key  = 32'd0;//cipher key for input
	  QUE_Read_Write  = 1'b0;
	  Cen  = 1'b0;
	  reset  = 1'b1; 
	  $dumpfile("fifo.vcd");
	  $dumpvars(0);
  end 
  
  initial  
      begin  
           main;  
      end  
 task main;  
      fork  
           reset_generator;  
           operation_process;  
           debug_fifo;  
           endsimulation;  
      join  
 endtask  
 
 always #10 Clk = ~Clk;
 task reset_generator;  
      begin  
           #(`DELAY*2)  
           reset = 1'b1;  
           # 7.9  
           reset = 1'b0;  
           # 7.09  
           reset = 1'b1;  
      end  
 endtask  
 
 task operation_process;  
      begin  
		  // Wait 100 ns for global reset to finish
		  #100;        
		  // Add stimulus here
		  Cen  = 1'b1;
		  reset  = 1'b1;
		  #20;
		  reset  = 1'b0;
		  QUE_Read_Write  = 1'b1;
		  //i= how many number are going to be inserted
		  for (i = 0; i < 49; i = i + 1)  begin
                Data_IN = Data_IN + 32'd1;  
                #20; 
           end 		   
		  Cipher_Key  = 32'd0;//cipher key for output
		  QUE_Read_Write = 1'b0;
      end  
 endtask  
 
 task debug_fifo;  
      begin  
           $display("----------------------------------------------");  
           $display("------------------   -----------------------");  
           $display("----------- SIMULATION RESULT ----------------");  
           $display("--------------       -------------------");  
           $display("----------------     ---------------------");  
           $display("----------------------------------------------");  
           $monitor("TIME = %d, QUE_Read_Write = %b, Data_IN = %d, data_out=%d",$time, QUE_Read_Write, Data_IN,QUE_Data_Out);  
      end  
 endtask 
  
    
  
task endsimulation;  
      begin  
           #ENDTIME  
           $display("-------------- THE SIMUALTION FINISHED ------------");  
           $finish;  
      end  
 endtask     

endmodule
