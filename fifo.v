module FIFObuffer( Clk,Data_IN, Cen, QUE_Data_Out, reset, QUE_Empty, QUE_Full, QUE_Last, QUE_Read_Write, Cipher_Key); //QUE_Read_Write High= write Low= read
	input  Clk, RD,WR, Cen, reset,QUE_Read_Write;
	output  QUE_Empty, QUE_Full, QUE_Last;
	input [31:0] Cipher_Key;
	input   [31:0] Data_IN;
	output reg [31:0] QUE_Data_Out; // internal registers 
	reg [5:0]  Count = 0; 
	reg [31:0] FIFO [0:47]; 
	reg [5:0]  readCounter = 0, writeCounter = 0; 
	assign QUE_Empty = (Count==0)? 1'b1:1'b0;	
	assign QUE_Last = (Count==47)? 1'b1:1'b0; 
	assign QUE_Full = (Count==48)? 1'b1:1'b0; 
	always @ (posedge Clk) 
		begin 

			 if (Cen==0); 

			 else begin 

			  if (reset) begin 
			   readCounter = 0; 
			   writeCounter = 0; 
			  end 
			  
				//read
			  else if (QUE_Read_Write ==1'b0 && Count!=0) begin 			  
			   QUE_Data_Out  = FIFO[readCounter] ^ Cipher_Key; 
			   //Delete read value
			   FIFO[readCounter] = 1'dx;
			   readCounter = readCounter+1; 
			  end 
			  
				//write
			  else if (QUE_Read_Write==1'b1 && Count<48) begin
			   FIFO[writeCounter]  = Data_IN ^ Cipher_Key; 
			   writeCounter  = writeCounter+1; 
			  end 

			  else; 

		 end 

		 if (readCounter > writeCounter) begin 
		  Count=readCounter-writeCounter; 
		 end 
		 
		 else if (readCounter == writeCounter) begin 			  
			   Count=0; 	  
		 end 

		 else if (writeCounter > readCounter) 
		  Count=writeCounter-readCounter; 
		 else;

	end 

endmodule