`timescale 1ns / 1ps

module simple_bank(
    input clk,
    input reset,
    input [2:0] operation, // 3-bit operation code (e.g., 000 for show balance, 001 for withdraw, etc.)
    input [31:0] amount, // Amount for withdrawal or transfer
    input [7:0] account_id, // Account ID for transfer
    output reg [31:0] balance, // Current balance
    output reg [31:0] transaction_log // Log of the last transaction amount
);

    // Operation codes
    parameter SHOW_BALANCE = 3'b000;
    parameter WITHDRAW = 3'b001;
    parameter TRANSFER = 3'b010;

    // Internal registers
    reg [31:0] internal_balance;
    reg [31:0] internal_transaction_log;

    // Initialize the system
    initial begin
        internal_balance = 100000; // Starting balance (e.g., $1000.00)
        internal_transaction_log = 0;
    end

    // Handle operations
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            internal_balance <= 100000; // Reset balance
            internal_transaction_log <= 0; // Clear transaction log
        end else begin
            case (operation)
                SHOW_BALANCE: begin
                    balance <= internal_balance; // Show current balance
                end
                WITHDRAW: begin
                    if (internal_balance >= amount) begin
                        internal_balance <= internal_balance - amount; // Withdraw amount
                        internal_transaction_log <= amount; // Log transaction
                    end
                end
                TRANSFER: begin
                    if (internal_balance >= amount) begin
                        internal_balance <= internal_balance - amount; // Transfer amount
                        internal_transaction_log <= amount; // Log transaction
                    end
                end
                default: begin
                    // No operation
                end
            endcase
        end
    end

    // Update outputs
    always @(internal_balance or internal_transaction_log) begin
        balance <= internal_balance;
        transaction_log <= internal_transaction_log;
    end
endmodule
