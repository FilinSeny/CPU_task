module cpu (
    input logic clk,
    input logic rst
);

    logic [31:0] instr;
    logic        zero;

    logic        RegDst;
    logic        ALUSrc;
    logic        MemToReg;
    logic        RegWrite;
    logic        MemWrite;
    logic        Branch;
    logic        Jump;
    logic [2:0]  ALUOp;

    datapath dp (
        .clk      (clk),
        .rst      (rst),

        .RegDst   (RegDst),
        .ALUSrc   (ALUSrc),
        .MemToReg (MemToReg),
        .RegWrite (RegWrite),
        .MemWrite (MemWrite),
        .Branch   (Branch),
        .Jump     (Jump),
        .ALUOp    (ALUOp),

        .instr    (instr),
        .zero     (zero)
    );

    control_unit cu (
        .opcode   (instr[31:26]),
        .funct    (instr[5:0]),
        .zero     (zero),

        .RegDst   (RegDst),
        .ALUSrc   (ALUSrc),
        .MemToReg (MemToReg),
        .RegWrite (RegWrite),
        .MemWrite (MemWrite),
        .Branch   (Branch),
        .Jump     (Jump),
        .ALUOp    (ALUOp)
    );

endmodule