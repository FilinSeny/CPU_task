module datapath (
    input  logic        clk,
    input  logic        rst,

    input  logic        RegDst,
    input  logic        ALUSrc,
    input  logic        MemToReg,
    input  logic        RegWrite,
    input  logic        MemWrite,
    input  logic        Branch,
    input  logic        Jump,
    input  logic [2:0]  ALUOp,

    output logic [31:0] instr,
    output logic        zero
);

    logic [31:0] pc;
    logic [31:0] next_pc;

    logic [31:0] pc_plus_4;
    logic [31:0] branch_addr;
    logic [31:0] pc_branch;
    logic [31:0] jump_addr;

    logic [31:0] sign_imm;
    logic [31:0] sign_imm_shifted;

    logic [4:0]  rs;
    logic [4:0]  rt;
    logic [4:0]  rd;
    logic [4:0]  write_reg;

    logic [31:0] read_data1;
    logic [31:0] read_data2;
    logic [31:0] alu_src_b;
    logic [31:0] alu_result;
    logic [31:0] mem_read_data;
    logic [31:0] write_back_data;

    assign rs = instr[25:21];
    assign rt = instr[20:16];
    assign rd = instr[15:11];

    pc_reg pc_reg_i (
        .clk     (clk),
        .rst     (rst),
        .next_pc (next_pc),
        .pc      (pc)
    );

    instr_mem instr_mem_i (
        .addr  (pc),
        .instr (instr)
    );

    adder32 pc_adder_i (
        .a (pc),
        .b (32'd4),
        .y (pc_plus_4)
    );

    sign_extend sign_extend_i (
        .imm16 (instr[15:0]),
        .imm32 (sign_imm)
    );

    assign sign_imm_shifted = sign_imm << 2;

    adder32 branch_adder_i (
        .a (pc_plus_4),
        .b (sign_imm_shifted),
        .y (branch_addr)
    );

    mux2 #(.WIDTH(5)) reg_dst_mux_i (
        .a   (rt),
        .b   (rd),
        .sel (RegDst),
        .y   (write_reg)
    );

    register_file register_file_i (
        .clk   (clk),
        .rst   (rst),
        .we    (RegWrite),
        .ra1   (rs),
        .ra2   (rt),
        .wa    (write_reg),
        .wd    (write_back_data),
        .rd1   (read_data1),
        .rd2   (read_data2)
    );

    mux2 #(.WIDTH(32)) alu_src_mux_i (
        .a   (read_data2),
        .b   (sign_imm),
        .sel (ALUSrc),
        .y   (alu_src_b)
    );

    alu alu_i (
        .a      (read_data1),
        .b      (alu_src_b),
        .op     (ALUOp),
        .result (alu_result),
        .zero   (zero)
    );

    data_mem data_mem_i (
        .clk        (clk),
        .we         (MemWrite),
        .addr       (alu_result),
        .write_data (read_data2),
        .read_data  (mem_read_data)
    );

    mux2 #(.WIDTH(32)) wb_mux_i (
        .a   (alu_result),
        .b   (mem_read_data),
        .sel (MemToReg),
        .y   (write_back_data)
    );

    assign pc_branch = (Branch && zero) ? branch_addr : pc_plus_4;

    assign jump_addr = {pc_plus_4[31:28], instr[25:0], 2'b00};

    assign next_pc = Jump ? jump_addr : pc_branch;

endmodule