// Filename: top_level_ocr.v
// Function: Top-level module for the Instantaneous Overcurrent Relay.
// FIX: Removed internal clock divider. Now accepts clk_800hz as an input.

module top_level_ocr (
    input clk_master,             // Main FPGA clock (e.g., 100 MHz)
    input clk_800hz,              // <-- NEW INPUT: 800 Hz processing clock
    input reset,                  // System reset
    input [15:0] adc_data_in,       // 16-bit data from the physical ADC
    
    // User Configuration
    input [15:0] I_p,              // 16-bit Pick-up Current set point
    
    // Output
    output wire trip_signal       // Final 1-bit trip signal
);

    // --- Clock Generation ---
    // (The internal clock divider has been REMOVED)

    // --- Internal Pipeline Wires ---
    wire [15:0] filtered_data_out; // Output of MAF -> Input of RMS
    wire [15:0] I_rms;             // Output of RMS -> Input of REM

    // --- Module Instantiation ---
    // All modules now use the new 'clk_800hz' input

    // 1. Moving Average Filter (MAF)
    moving_average_filter u_maf (
        .clk(clk_800hz),
        .reset(reset),
        .adc_data_in(adc_data_in),
        .filtered_data_out(filtered_data_out)
    );
    
    // 2. RMS Estimation Module
    rms_estimation_module u_rms (
        .clk_800hz(clk_800hz),
        .reset(reset),
        .filtered_data_in(filtered_data_out),
        .I_rms(I_rms)
    );
    
    // 3. Relay Emulating Module (REM) - Instantaneous
    relay_emulating_module u_rem (
        .clk_800hz(clk_800hz),
        .reset(reset),
        .I_rms(I_rms),
        .I_p(I_p),
        .trip_signal(trip_signal)
    );

endmodule
