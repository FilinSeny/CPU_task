module register_file (
    input  logic        clk,
    input  logic        rst,
    //разрешение записи
    input  logic        we,

    //адреса для 2х регистров
    input  logic [4:0]  ra1,
    input  logic [4:0]  ra2,

    output logic [31:0] rd1,
    output logic [31:0] rd2,
    //адрес записи одного
    input  logic [4:0]  wa,
    input  logic [31:0] wd
);

    logic [31:0] regs [0:3];

    assign rd1 = regs[ra1[1:0]];
    assign rd2 = regs[ra2[1:0]];

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            regs[0] <= 32'd0;
            regs[1] <= 32'd0;
            regs[2] <= 32'd0;
            regs[3] <= 32'd0;
        end else begin
            regs[0] <= 32'd0;

            if (we && wa[1:0] != 2'd0) begin
                regs[wa[1:0]] <= wd;
            end
        end
    end

endmodule