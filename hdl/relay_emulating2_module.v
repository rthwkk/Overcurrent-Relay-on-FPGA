// Filename: relay_emulating2_module.v
// Function: Implements a LATCHING Instantaneous Overcurrent Relay.

module relay_emulating2_module (
    input clk_800hz,            // 800 Hz Clock signal
    input reset,
    
    // Inputs
    input [15:0] I_rms,            // 16-bit Fixed-Point RMS Current
    input [15:0] I_p,              // 16-bit Fixed-Point Pick-up Current
    
    // Output
    output reg trip_signal         // Latching trip signal
);

    // Latching trip logic
    always @(posedge clk_800hz) begin
        if (reset) begin
            // The only way to clear the trip is a system reset
            trip_signal <= 0;
        end else begin
            // If the current is too high...
            if (I_rms > I_p) begin
                // ...trip and STAY TRIPPED (latch)
                trip_signal <= 1;
            end
        end
    end

endmodule
