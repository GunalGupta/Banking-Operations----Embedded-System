`timescale 1ns / 1ps

module simple_bank_tb;

    // Inputs to the bank module
    reg clk;
    reg reset;
    reg [2:0] operation;
    reg [31:0] amount;
    reg [7:0] account_id;

    // Outputs from the bank module
    wire [31:0] balance;
    wire [31:0] transaction_log;

    // Instantiate the bank module
    simple_bank uut (
        .clk(clk),
        .reset(reset),
        .operation(operation),
        .amount(amount),
        .account_id(account_id),
        .balance(balance),
        .transaction_log(transaction_log)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk; // Generate a clock with a period of 20ns
    end

    // Test sequence
    initial begin
        // Initialize inputs
        reset = 1;
        operation = 0;
        amount = 0;
        account_id = 0;

        // Setup the dump file
        $dumpfile("simple_bank.vcd");
        $dumpvars(0, simple_bank_tb);

        // Apply reset
        #20 reset = 0;
        $display("System reset");

        // Show balance
        #20 operation = 3'b000;
        #10 $display("Current balance: $%0.2f in account: %0d", balance / 100.0, account_id);

        // Withdraw $200.00
        #20 operation = 3'b001;
            amount = 20000;
        #10 $display("Withdrawing $%0.2f. New balance: $%0.2f in account: %0d ", amount/100, balance / 100.0, account_id);

        // Transfer $300.00 to account 5
        #20 operation = 3'b010;
            amount = 30000;
            account_id = 5;
        #10 $display("Transferring $%0.2f. New balance: $%0.2f in account: %0d",amount/100, balance / 100.0, account_id);

        // End of test
        #20;
        $finish;
    end
endmodule
