module data_memory (
    input wire clk,
    input wire mem_write,           // 1 = Write to RAM (sw), 0 = Do not write
    input wire [31:0] addr,         // Memory address calculated by ALU
    input wire [31:0] write_data,   // Data from rs2 to store into RAM
    output wire [31:0] read_data    // Data read from RAM (for lw)
);

    // 256 words of 32-bit RAM (power-of-two depth)
    reg [31:0] dmem [0:255];
    integer i;

    // Initialize RAM to 0 for clean simulations
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            dmem[i] = 32'd0;
        end
    end

    // Word-aligned address slice [9:2] maps byte address to 256-word index
    wire [7:0] word_addr = addr[9:2];

    // Combinational read
    assign read_data = dmem[word_addr];

    // Synchronous write on rising clock edge
    always @(posedge clk) begin
        if (mem_write) begin
            dmem[word_addr] <= write_data;
        end
    end

endmodule