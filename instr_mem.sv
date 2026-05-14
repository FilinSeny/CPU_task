module instr_mem (
    input  logic [31:0] addr,
    output logic [31:0] instr
);

    logic [31:0] mem [0:31];

    initial begin
        $readmemh("../data/program.mem", mem);
    end

    assign instr = mem[addr[31:2]];

endmodule