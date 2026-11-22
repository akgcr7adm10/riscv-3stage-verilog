module instruction_memory (
    input wire [31:0] addr,
    output reg [31:0] instr
);

    // Declare a small memory array: 256 words of 32 bits each
    reg [31:0] rom [0:255];

    initial begin
        // Preload some simple RISC-V instructions for testing simulation
        rom[0] = 32'h00500093; // addi x1, x0, 5  (x1 = 5)
        rom[1] = 32'h00A00113; // addi x2, x0, 10 (x2 = 10)
        rom[2] = 32'h002081B3; // add  x3, x1, x2  (x3 = x1 + x2 = 15)
        rom[3] = 32'h00000013; // nop (addi x0, x0, 0)
    end

    // Combinational read: Address divided by 4 because instructions are 4 bytes apart
    always @(*) begin
        instr = rom[addr[9:2]];
    end

endmodule