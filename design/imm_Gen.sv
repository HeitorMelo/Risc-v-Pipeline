`timescale 1ns / 1ps

module imm_Gen (
    input  logic [31:0] inst_code,
    output logic [31:0] Imm_out
);


  always_comb
    case (inst_code[6:0])
      7'b0000011:  /*I-type load part*/
      Imm_out = {inst_code[31] ? 20'hFFFFF : 20'b0, inst_code[31:20]};

      7'b0100011:  /*S-type*/
      Imm_out = {inst_code[31] ? 20'hFFFFF : 20'b0, inst_code[31:25], inst_code[11:7]};

      7'b1100011:  /*B-type*/
      Imm_out = {
        inst_code[31] ? 19'h7FFFF : 19'b0,
        inst_code[31],
        inst_code[7],
        inst_code[30:25],
        inst_code[11:8],
        1'b0
      };

      7'0110111:  /*U-type*/
      Imm_out = {inst_code[31:12], 12'b0};

      // imm[20|10:1|11|19:12] -- 11:0 for J-type
      // 31 | 30:21 | 20 | 19:12 | 11 : 0 
      
      7'1101111:  /*J-type*/
      Imm_out = {
        inst_code[31] ? 11'7FF : 11'b0,
        inst_code[31],
        inst_code[19:12],
        inst_code[20],
        inst_code[30:21],
        1'b0
      };

      default: Imm_out = {32'b0};

    endcase

endmodule
