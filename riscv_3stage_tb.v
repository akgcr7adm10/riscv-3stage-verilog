`timescale 1ns / 1ps

module riscv_3stage_tb();

    // 1. Testbench control signals
    reg clk;
    reg rst;

    // 2. Debug outputs from the processor
    wire [31:0] pc_debug;
    wire [31:0] alu_result_debug;

    // 3. Instantiate the complete 3-Stage RISC-V Processor
    riscv_3stage_top uut (
        .clk(clk),
        .rst(rst),
        .pc_debug(pc_debug),
        .alu_result_debug(alu_result_debug)
    );

    // 4. Generate 100 MHz Clock (10ns period)
    always #5 clk = ~clk;

    // 5. Run Reset & Simulation Sequence
    initial begin
        // Hold processor in reset
        clk = 0;
        rst = 1;
        #20;

        // Release reset to start executing instructions
        rst = 0;

        // Run for 150ns (15 clock cycles) to watch instructions flow through all 3 stages
        #150;

        $stop;
    end

endmodule