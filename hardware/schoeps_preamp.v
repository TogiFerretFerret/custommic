/*
 * Schoeps-Style JFET Preamp - Structural Verilog Reference
 * ---------------------------------------------------------
 * This file represents the logical connectivity of the studio microphone.
 * It is intended for structural verification and as a "source code"
 * reference for the KiCad schematic.
 */

module schoeps_preamp (
    // Inputs from the RK-47 Capsule
    input  capsule_diaphragm, // High-impedance signal input
    output capsule_backplate, // High-voltage bias supply

    // XLR Interface (Physical Connector)
    inout  xlr_pin1,          // Chassis / System Ground
    inout  xlr_pin2,          // Audio HOT / Phantom Power (+)
    inout  xlr_pin3           // Audio COLD / Phantom Power (+)
);

    // --- Internal Net Declarations ---
    wire main_rail;           // 6.2V Regulated DC supply
    wire gate_node;           // Ultra-high impedance node (Capsule-JFET)
    wire source_node;         // Phase splitter drive signal
    wire q2_emitter;          // Positive-phase audio output
    wire q3_emitter;          // Negative-phase audio output
    wire gnd = xlr_pin1;      // System Ground alias

    // --- Power Harvesting (Phantom Power Tapping) ---
    // R5/R6 drop the 48V to a level the Zener can manage
    resistor #(.value("6.81k")) r5 (.a(xlr_pin2), .b(main_rail));
    resistor #(.value("6.81k")) r6 (.a(xlr_pin3), .b(main_rail));
    
    // Voltage Regulation & Smoothing
    zener_diode             d1 (.cathode(main_rail), .anode(gnd)); // 6.2V Clamp
    capacitor #(.value("0.1uF")) c3 (.a(main_rail), .b(gnd));      // Filter

    // Capsule Bias Supply
    resistor #(.value("1M"))    r9 (.a(main_rail), .b(capsule_backplate));

    // --- Input Stage (High-Impedance JFET Buffer) ---
    assign gate_node = capsule_diaphragm;
    
    // R1 provides the 0V reference path for the Gate
    resistor #(.value("1G"))    r1 (.a(gate_node), .b(gnd));
    
    // Q1 matches the capsule's giga-ohm impedance to the circuit
    lsk170                  q1 (
        .gate(gate_node), 
        .drain(main_rail), 
        .source(source_node)
    );
    
    // R10 sets the JFET operating current
    resistor #(.value("1k"))   r10 (.a(source_node), .b(gnd));

    // --- Output Stage (Balanced Phase Splitter) ---
    // Q2 generates the non-inverted (HOT) signal
    bc547                   q2 (
        .base(source_node), 
        .collector(main_rail), 
        .emitter(q2_emitter)
    );
    
    // Q3 generates the inverted (COLD) signal via Grounded-Collector topology
    bc547                   q3 (
        .base(source_node), 
        .collector(gnd),       // <--- PHASE INVERSION POINT
        .emitter(q3_emitter)
    );

    // Emitter Load Resistors
    resistor #(.value("100k"))  r2 (.a(q2_emitter), .b(gnd));
    resistor #(.value("100k"))  r3 (.a(q3_emitter), .b(gnd));

    // --- Signal Coupling & DC Blocking ---
    // C1/C2 pass audio while blocking the 48V DC from the mixer
    capacitor #(.value("0.1uF")) c1 (.a(q2_emitter), .b(xlr_pin2));
    capacitor #(.value("0.1uF")) c2 (.a(q3_emitter), .b(xlr_pin3));

    // --- EMI/RF Protection ---
    // High-frequency shunt to ground for radio interference
    capacitor #(.value("1000pF")) c4 (.a(xlr_pin2), .b(gnd));
    capacitor #(.value("1000pF")) c5 (.a(xlr_pin3), .b(gnd));

endmodule
