module register_file (
    input wire clk,
    input wire rst,
    input wire we,              // Write Enable (from Writeback stage)
    input wire [4:0] rs1_addr,  // Source Register 1 Address
    input wire [4:0] rs2_addr,  // Source Register 2 Address
    input wire [4:0] rd_addr,   // Destination Register Address
    input wire [31:0] rd_data,  // Data to write into Destination Register
    output wire [31:0] rs1_data,// Output data from Source Register 1
    output wire [31:0] rs2_data // Output data from Source Register 2
);

    // Declare 32 registers, each 32 bits wide
    reg [31:0] rf [0:31];
    integer i;

    // Read logic (combinational): x0 is always hardwired to 0 in RISC-V
    assign rs1_data = (rs1_addr == 5'b0) ? 32'd0 : rf[rs1_addr];
    assign rs2_data = (rs2_addr == 5'b0) ? 32'd0 : rf[rs2_addr];

    // Write logic (sequential on clock edge)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                rf[i] <= 32'd0;
            end
        end else if (we && (rd_addr != 5'b0)) begin
            rf[rd_addr] <= rd_data;
        end
    end

endmodule