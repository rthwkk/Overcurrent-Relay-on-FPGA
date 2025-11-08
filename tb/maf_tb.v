// Filename: maf_tb.v
// Test bench for the Moving Average Filter

`timescale 1ns / 1ps

module maf_tb;

    // Parameters for clock and test duration
    parameter CLK_PERIOD = 10; // 10ns period (100 MHz clock for simulation)

    // Signals to connect to the Device Under Test (DUT)
    reg clk;
    reg reset;
    reg [15:0] adc_data_in;
    wire [15:0] filtered_data_out;

    // Instantiate the DUT (your MAF module)
    moving_average_filter DUT (
        .clk(clk),
        .reset(reset),
        .adc_data_in(adc_data_in),
        .filtered_data_out(filtered_data_out)
    );

    // Clock generation (runs perpetually)
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Test sequence
    initial begin
        // 1. Initialize and Reset
        $display("Time: %t | Starting MAF Test Bench...", $time);
        reset = 1;
        adc_data_in = 16'd0;
        #(CLK_PERIOD * 2);

        // 2. Release Reset and apply a stable input (value 100)
        reset = 0;
        adc_data_in = 16'd1000;
        $display("Time: %t | Input set to 100", $time);
        #(CLK_PERIOD * 5); // Wait for the filter to settle on 100
        
        // 3. Simulate a step change (e.g., noise/fault spike)
        adc_data_in = 16'd200;
        $display("Time: %t | Input changed to 200 (Step Change)", $time);
        #(CLK_PERIOD * 10);
        
        // 4. Return to original value
        adc_data_in = 16'd100;
        $display("Time: %t | Input returned to 100", $time);
        #(CLK_PERIOD * 10);

        // 5. End simulation
        $finish;
    end

endmodule
