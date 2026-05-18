\TLV_version 1d: tl-x.org
\SV
/* 
 * USACO Platinum Schoeps-Style Preamp - Makerchip Edition
 * ------------------------------------------------------
 * Use this file in Makerchip (makerchip.com) to visualize 
 * the structural logic of the microphone preamp.
 */

module top (
    input  clk, 
    input  reset, 
    input  [31:0] cyc_cnt, 
    output passed, 
    output failed
);
   
    // --- Internal Signal Nets ---
    wire main_rail;    // High-level power bus
    wire gate_node;    // Ultra-high impedance input node
    wire source_node;  // Shared drive signal for the output stage
    wire q2_emitter;   // Hot output (0-deg phase)
    wire q3_emitter;   // Cold output (180-deg phase)
    wire gnd = 1'b0;   // Ground Reference

    // --- Inputs ---
    assign gate_node = 1'b1; // Simulate a signal present

    // --- Power Supply Logic ---
    // In hardware, this is the 6.2V Zener-regulated rail
    analog_tap power_section (
        .in(1'b1), 
        .out(main_rail)
    );
   
    // --- Input Stage (The Buffer) ---
    // Q1 converts the giga-ohm capsule impedance to low impedance
    jfet_buffer q1 (
        .g(gate_node), 
        .d(main_rail), 
        .s(source_node)
    );
   
    // --- Output Stage (Balanced Phase Splitter) ---
    // Q2 generates the non-inverted (HOT) signal
    output_driver q2 (
        .b(source_node), 
        .c(main_rail), 
        .e(q2_emitter)
    );
    
    // Q3 generates the inverted (COLD) signal via phase flip
    output_driver q3 (
        .b(source_node), 
        .c(gnd),        // <--- THE PHYSICAL PHASE FLIP (Collector to GND)
        .e(q3_emitter)
    );

    // --- Simulation Pass/Fail Logic ---
    assign passed = cyc_cnt > 40;
    assign failed = 1'b0;

endmodule

// --- Behavioral Modules for Visualization ---
// These are simplified to allow Verilator to render the logic hierarchy.

module jfet_buffer (input g, input d, output s);
    // Mimics the source-follower behavior
    assign s = g & d; 
endmodule

module output_driver (input b, input c, output e);
    // Emitter-follower logic: e follows b, relative to c
    assign e = b ^ c; 
endmodule

module analog_tap (input in, output out);
    assign out = in;
endmodule
