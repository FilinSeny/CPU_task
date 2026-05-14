module tb_complex;

    logic clk;
    logic rst;

    cpu dut (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("../build/tb_complex.vcd");
        $dumpvars(0, tb_complex);

        rst = 1;
        #20;
        rst = 0;

        #500;

        $display("");
        $display("========== COMPLEX TEST ==========");

        $display("r0 = %0d", dut.dp.register_file_i.regs[0]);
        $display("r1 = %0d", dut.dp.register_file_i.regs[1]);
        $display("r2 = %0d", dut.dp.register_file_i.regs[2]);
        $display("r3 = %0d", dut.dp.register_file_i.regs[3]);

        $display("");
        $display("========== DATA MEMORY ==========");

        $display("mem[0] = %0d", dut.dp.data_mem_i.mem[0]);
        $display("mem[1] = %0d", dut.dp.data_mem_i.mem[1]);
        $display("mem[2] = %0d", dut.dp.data_mem_i.mem[2]);
        $display("mem[3] = %0d", dut.dp.data_mem_i.mem[3]);
        $display("mem[4] = %0d", dut.dp.data_mem_i.mem[4]);

        $display("");
        $display("========== EXPECTED ==========");
        $display("r1 = 11");
        $display("r2 = 5");
        $display("r3 = 1");
        $display("mem[0] = 13");
        $display("mem[1] = 7");
        $display("mem[2] = 2");
        $display("mem[3] = 11");
        $display("mem[4] = 1");

        if (
            dut.dp.register_file_i.regs[1] == 32'd11 &&
            dut.dp.register_file_i.regs[2] == 32'd5  &&
            dut.dp.register_file_i.regs[3] == 32'd1  &&
            dut.dp.data_mem_i.mem[0] == 32'd13 &&
            dut.dp.data_mem_i.mem[1] == 32'd7  &&
            dut.dp.data_mem_i.mem[2] == 32'd2  &&
            dut.dp.data_mem_i.mem[3] == 32'd11 &&
            dut.dp.data_mem_i.mem[4] == 32'd1
        ) begin
            $display("");
            $display("TEST PASSED");
        end else begin
            $display("");
            $display("TEST FAILED");
        end

        $finish;
    end

endmodule