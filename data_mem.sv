module data_mem (
    input  logic        clk,
    input  logic        we,

    input  logic [31:0] addr,
    input  logic [31:0] write_data,

    output logic [31:0] read_data
);

    logic [31:0] mem [0:31];

    assign read_data = mem[addr[31:2]];

    always_ff @(posedge clk) begin
        if (we) begin
            mem[addr[31:2]] <= write_data;
        end
    end

endmodule