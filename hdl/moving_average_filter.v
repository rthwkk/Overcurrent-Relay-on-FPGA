// Filename: moving_average_filter.v
// Function: Reduces harmonics and noise using a 4-sample moving average window, 
//           implementing division by 4 as a 2-bit right shift for efficiency.

module moving_average_filter (
    input clk,                      // Master Clock Signal
    input reset,                    // Asynchronous Reset
    input [15:0] adc_data_in,       // 16-bit input from the ADC module
    output reg [15:0] filtered_data_out // 16-bit filtered output
);

    // Registers to hold the three previous samples for the 4-sample window
    reg [15:0] sample_delay_1;
    reg [15:0] sample_delay_2;
    reg [15:0] sample_delay_3;
    
    // Sum of the four samples (Requires 18 bits to prevent overflow: 4 * max 16-bit value)
    wire [17:0] sum_of_samples;
    
    // Combinational logic: calculate the sum of the current and past three samples
    assign sum_of_samples = sample_delay_1 + sample_delay_2 + sample_delay_3 + adc_data_in;

    always @(posedge clk) begin
        if (reset) begin
            sample_delay_1    <= 16'd0;
            sample_delay_2    <= 16'd0;
            sample_delay_3    <= 16'd0;
            filtered_data_out <= 16'd0;
        end else begin
            // 1. Shift the samples to maintain the moving average window
            sample_delay_3 <= sample_delay_2;
            sample_delay_2 <= sample_delay_1;
            sample_delay_1 <= adc_data_in;
            
            // 2. Efficient Averaging: Right shift by 2 bits (division by 4)
            // The result is truncated back to 16 bits for the output.
            filtered_data_out <= sum_of_samples >> 2; 
        end
    end

endmodule
