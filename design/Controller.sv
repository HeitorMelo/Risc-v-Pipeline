`timescale 1ns / 1ps

module Controller (
    //Input
    input logic [6:0] Opcode,
    //7-bit opcode field from the instruction

    //Outputs
    output logic ALUSrc,
    //0: The second ALU operand comes from the second register file output (Read data 2); 
    //1: The second ALU operand is the sign-extended, lower 16 bits of the instruction.
    output logic MemtoReg,
    //0: The value fed to the register Write data input comes from the ALU.
    //1: The value fed to the register Write data input comes from the data memory.
    output logic RegWrite, //The register on the Write register input is written with the value on the Write data input 
    output logic MemRead,  //Data memory contents designated by the address input are put on the Read data output
    output logic MemWrite, //Data memory contents designated by the address input are replaced by the value on the Write data input.
    output logic [2:0] ALUOp,  //00: LW/SW; 01:Branch; 10: Rtype
    output logic Branch,  //0: branch is not taken; 1: branch is taken
    output logic [1:0] JalType,  //0: instruction is not a jump, 1: instruction is a jump
    output logic halt  //0: continue, 1: stop
);

  logic [6:0] R_TYPE, I_TYPE, LW, SW, BR, JAL, JALR, LUI, HALT;

  assign R_TYPE = 7'b0110011;  //ADD, AND, OR, XOR, ADD, SUB, SRL, SRA, SLL, SLT, SLTU
  assign I_TYPE = 7'b0010011;  //addi, andi, ori, xori, slti, sltiu, slli, srli, srai
  assign LW = 7'b0000011;  //lw
  assign SW = 7'b0100011;  //sw
  assign BR = 7'b1100011;  //branch - BEQ, BNE, BLT, BGE, BLTU, BGEU
  assign JAL = 7'b1101111;  //jal
  assign JALR = 7'b1100111;  //jalr
  assign LUI = 7'b0110111;  //lui
  assign HALT = 7'b1111111; //halt

  // 000 - LW/SW
  // 001 - Branch
  // 010 - Rtype & jalr & jal
  // 011 - Itype
  // 100 - lui & auipc

  assign ALUSrc = (Opcode == LW || Opcode == SW || Opcode == JALR || Opcode == I_TYPE || Opcode == LUI);
  assign MemtoReg = (Opcode == LW);
  assign RegWrite = (Opcode == R_TYPE || Opcode == LW || Opcode == JAL || Opcode == JALR || Opcode == I_TYPE || Opcode == LUI);
  assign MemRead = (Opcode == LW);
  assign MemWrite = (Opcode == SW);

  assign ALUOp[0] = (Opcode == BR || Opcode == I_TYPE );
  assign ALUOp[1] = (Opcode == I_TYPE || Opcode == R_TYPE || Opcode == JAL || Opcode == JALR);
  assign ALUOp[2] = Opcode == LUI;
  
  assign Branch = (Opcode == BR);
  assign JalType = {Opcode == JAL, Opcode == JALR};

  assign halt = (((Opcode == HALT)) ? 1'b1 : 1'b0);

endmodule
