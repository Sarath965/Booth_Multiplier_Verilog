module shiftreg (
  output reg [15:0] data_out,
  input [15:0 ]data_in,
  input s_in, 
  input clk, 
  input ld, 
  input clr, 
  input sft);
  
  always @(posedge clk)
    begin
      if (clr) data_out <= 0;
      else if (ld)
             data_out <= data_in;
      else if (sft)
     data_out <= {s_in,data_out[15:1]};
    end
endmodule

module PIPO (
  output reg[15:0] data_out,
  input [15:0] data_in, 
  input clk, 
  input load);
  
  always @(posedge clk)
    if (load) data_out <= data_in;
endmodule

module dff (
  input d, 
  output reg q, 
  input clk, 
  input clr);
  
  always @(posedge clk)
    if (clr) q <= 0;
    else q <= d;
endmodule

module ALU (
  output reg [15:0] out, 
  input [15:0] in1, 
  input [15:0] in2, 
  input addsub);
  
  always @(*)
    begin
     if (addsub == 0) out = in1 - in2;
     else out = in1 + in2;
    end
endmodule

module counter (
  output reg [4:0] data_out, 
  input decr, 
  input ldcnt, 
  input clk);
  
  always @(posedge clk)
    begin
      if (ldcnt) data_out <= 5'b10000;
      else if (decr) data_out <= data_out - 1;
    end
endmodule

module BOOTH (
  input ldA, 
  input ldQ, 
  input ldM, 
  input clrA, 
  input clrQ, 
  input clrff, 
  input sftA, 
  input sftQ,
  input addsub, 
  input decr, 
  input ldcnt, 
  input [15:0] data_in, 
  input clk, 
  output qm1, 
  output eqz);
  
  
  wire [15:0] A, M, Q, Z;
  wire [4:0] count;
  assign eqz = ~|count;
  
  shiftreg AR (A, Z, A[15], clk, ldA, clrA, sftA);
  shiftreg QR (Q, data_in, A[0], clk, ldQ, clrQ, sftQ);
  dff QM1 (Q[0], qm1, clk, clrff);
  PIPO MR (data_in, M, clk, ldM);
  ALU AS (Z, A, M, addsub);
  counter CN (count, decr, ldcnt, clk);
endmodule




module controller (
  output reg ldA, 
  output reg clrA, 
  output reg sftA, 
  output reg ldQ, 
  output reg clrQ, 
  output reg sftQ, 
  output reg ldM, 
  output reg clrff, 
  output reg addsub,
  input start,
  output reg decr, 
  output reg ldcnt, 
  output reg done, 
  input clk, 
  input q0, 
  input qm1,
  input eqz);
  
  reg [2:0] state;
  parameter S0=3'b000,S1=3'b001,S2=3'b010,S3=3'b011,S4=3'b100,S5=3'b101,S6=3'b110;
  
always @(posedge clk)
  begin
  case (state)
      S0:    if (start) state <= S1;
      S1:    state <= S2;
      S2:    #2 if ({q0,qm1}==2'b01) state <= S3;
    else if ({q0,qm1}==2'b10) state <= S4;
             else state <= S5;
      S3:    state <= S5;
      S4:    state <= S5;
      S5:    #2 if (({q0,qm1}==2'b01) && !eqz) state <= S3;
             else if (({q0,qm1}==2'b10) && !eqz) state <= S4;
             else if (eqz) state <= S6;
      S6:    state <= S6;
      default: state <= S0;
  endcase
end

always @(state)
  begin
  	case (state)
		S0: begin clrA=0;ldA=0;sftA=0;clrQ=0;ldQ=0;sftQ=0;
                    ldM = 0; clrff = 0; done = 0; end
		S1: begin clrA=1; clrff=1; ldcnt=1;ldM=1;end
		S2: begin clrA=0;clrff=0;ldcnt=0;ldM=0;ldQ=1;end
		S3: begin ldA=1;addsub=1;ldQ=0;sftA=0;sftQ=0;decr=0;end
		S4: begin ldA=1;addsub=0;ldQ=0;sftA=0;sftQ=0;decr=0;end
		S5: begin sftA=1;sftQ=1;ldA=0;ldQ=0;decr=1;end
		S6: done = 1;
        default: begin clrA = 0; sftA = 0; ldQ = 0; sftQ = 0; end
     endcase 
  end
  
endmodule

