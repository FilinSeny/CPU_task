module control_unit (
    input  logic [5:0] opcode,
    input  logic [5:0] funct,
    input  logic       zero,

    output logic       RegDst,
    output logic       ALUSrc,
    output logic       MemToReg,
    output logic       RegWrite,
    output logic       MemWrite,
    output logic       Branch,
    output logic       Jump,
    output logic [2:0] ALUOp
);

    localparam OP_RTYPE = 6'b000000;
    localparam OP_ADDI  = 6'b001000;
    localparam OP_LW    = 6'b100011;
    localparam OP_SW    = 6'b101011;
    localparam OP_BEQ   = 6'b000100;
    localparam OP_J     = 6'b000010;

    localparam FUNCT_ADD = 6'b100000;
    localparam FUNCT_SUB = 6'b100010;
    localparam FUNCT_AND = 6'b100100;
    localparam FUNCT_OR  = 6'b100101;
    localparam FUNCT_SLT = 6'b101010;

    localparam ALU_ADD = 3'b000;
    localparam ALU_SUB = 3'b001;
    localparam ALU_AND = 3'b010;
    localparam ALU_OR  = 3'b011;
    localparam ALU_SLT = 3'b100;

    always_comb begin
        RegDst   = 1'b0;
        ALUSrc   = 1'b0;
        MemToReg = 1'b0;
        RegWrite = 1'b0;
        MemWrite = 1'b0;
        Branch   = 1'b0;
        Jump     = 1'b0;
        ALUOp    = ALU_ADD;

        unique case (opcode)

            OP_RTYPE: begin
                RegDst   = 1'b1;
                RegWrite = 1'b1;

                unique case (funct)
                    FUNCT_ADD: ALUOp = ALU_ADD;
                    FUNCT_SUB: ALUOp = ALU_SUB;
                    FUNCT_AND: ALUOp = ALU_AND;
                    FUNCT_OR:  ALUOp = ALU_OR;
                    FUNCT_SLT: ALUOp = ALU_SLT;
                    default:   ALUOp = ALU_ADD;
                endcase
            end

            OP_ADDI: begin
                ALUSrc   = 1'b1;
                RegWrite = 1'b1;
                ALUOp    = ALU_ADD;
            end

            OP_LW: begin
                ALUSrc   = 1'b1;
                MemToReg = 1'b1;
                RegWrite = 1'b1;
                ALUOp    = ALU_ADD;
            end

            OP_SW: begin
                ALUSrc   = 1'b1;
                MemWrite = 1'b1;
                ALUOp    = ALU_ADD;
            end

            OP_BEQ: begin
                Branch = 1'b1;
                ALUOp  = ALU_SUB;
            end

            OP_J: begin
                Jump = 1'b1;
            end

            default: begin
                RegDst   = 1'b0;
                ALUSrc   = 1'b0;
                MemToReg = 1'b0;
                RegWrite = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                Jump     = 1'b0;
                ALUOp    = ALU_ADD;
            end

        endcase
    end

endmodule