`timescale 1ns / 1ps

module ALUController (
    //Inputs
    input logic [2:0] ALUOp,  // 2-bit opcode field from the Controller--00: LW/SW/AUIPC; 01:Branch; 10: Rtype/Itype; 11:JAL/LUI
    input logic [6:0] Funct7,  // bits 25 to 31 of the instruction
    input logic [2:0] Funct3,  // bits 12 to 14 of the instruction

    //Output
    output logic [3:0] Operation  // operation selection for ALU
);

  assign Operation[0] = ((ALUOp == 3'b001) && (Funct3 == 3'b000)) ||  // BEQ
      ((ALUOp == 3'b001) && (Funct3 == 3'b100)) || // BLT
			((ALUOp == 3'b010) && (Funct3 == 3'b000) && (Funct7 == 7'b0000000)) ||	// ADD
      ((ALUOp == 3'b011) && (Funct3 == 3'b000)) ||	// ADDI
      ((ALUOp == 3'b010) && (Funct3 == 3'b110) && (Funct7 == 7'b0000000)) ||   // OR
      (ALUOp == 3'b000) ||  // SW\SB LW\LH\LBU\LB
      ((ALUOp == 3'b011) && (Funct3 == 3'b010)); // SLTI 

  assign Operation[1] = (ALUOp == 3'b000) ||  // SW\SB LW\LH\LBU\LB
      ((ALUOp == 3'b010) && (Funct3 == 3'b000) && (Funct7 == 7'b0000000)) ||  // ADD
      ((ALUOp == 3'b011) && (Funct3 == 3'b000)) ||	// ADDI
      ((ALUOp == 3'b010) && (Funct3 == 3'b100) && (Funct7 == 7'b0000000)) ||  // XOR
      ((ALUOp == 3'b011) && (Funct3 == 3'b010)) || // SLTI 
      ((ALUOp == 3'b001) && (Funct3 == 3'b001)) || // BNE
      ((ALUOp == 3'b001) && (Funct3 == 3'b100)); // BLT

  assign Operation[2] = ((ALUOp == 3'b001) && (Funct3 == 3'b000)) ||  // BEQ
      ((ALUOp == 3'b010) && (Funct3 == 3'b000) && (Funct7 == 7'b0100000)) ||	// SUB  
      ((ALUOp == 3'b001) && (Funct3 == 3'b001)) || // BNE
      ((ALUOp == 3'b001) && (Funct3 == 3'b100)) || // BLT
      ((ALUOp == 3'b011) && (Funct3 == 3'b010)) || // SLTI 
      (ALUOp == 3'b100); // LUI

  assign Operation[3] = (ALUOp == 3'b100) || // LUI
  ((ALUOp == 3'b001) && (Funct3 == 3'b101));  // BGE

endmodule
