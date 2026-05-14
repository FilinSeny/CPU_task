module tb_cpu;

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

        $dumpfile("../build/tb_cpu1.vcd");
        $dumpvars(0, tb_cpu);

        rst = 1;

        #20;

        rst = 0;

        #300;

        $display("");
        $display("========== REGISTERS ==========");

        $display("r0 = %0d", dut.dp.register_file_i.regs[0]);
        $display("r1 = %0d", dut.dp.register_file_i.regs[1]);
        $display("r2 = %0d", dut.dp.register_file_i.regs[2]);
        $display("r3 = %0d", dut.dp.register_file_i.regs[3]);

        $display("");
        $display("========== MEMORY ==========");

        $display("mem[0] = %0d", dut.dp.data_mem_i.mem[0]);

        $display("");
        $display("Waveform:");
        $display("../build/cpu.vcd");

        $finish;
    end

endmodule