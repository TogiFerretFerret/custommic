# Technical Overview: High-Fidelity Studio Condenser Microphone

## 1. System Architecture
The project follows a traditional discrete condenser microphone signal chain, optimized for low noise and transparent frequency response.

### Front-End: RK-47 Capsule
- **Type:** 34mm large-diaphragm, gold-sputtered condenser.
- **Transduction:** Electrostatic. Requires a high-voltage bias (Phantom Power) to charge the capacitor formed by the diaphragm and backplate.
- **Characteristics:** RK-47 profile provides a mid-forward, "vintage" warmth, taming the harsh sibilance often found in cheap electret or K67-style capsules.

### Preamp: Schoeps-Style Topology
A discrete, transformerless impedance-matching circuit.
- **Input Stage:** LSK170 JFET. Chosen for extremely low noise and high input impedance. It converts the ultra-high impedance capsule signal to a lower impedance that can drive the rest of the circuit.
- **Output Stage:** Balanced NPN pair (BC547C). Provides a low-impedance differential output to drive long XLR cables.
- **Biasing:** Utilizes 48V Phantom Power (P48) from the Scarlett Solo. The circuit must derive both the capsule bias (typically ~40-60V) and the active component operating voltages from the XLR signal lines.

### Directionality: Cardioid Polar Pattern
- **Mechanism:** The RK-47 is a single-diaphragm capsule. Achieving a cardioid (heart-shaped) pattern requires a combination of electrical biasing and acoustic phase cancellation.
- **Acoustic Porting:** The U87-style body must allow sound to reach the *rear* of the diaphragm through calibrated vents. This creates a time-of-arrival delay that cancels sound originating from 180° off-axis.
- **Electrical Biasing:** The backplate will be biased at a high DC potential (P48 derived) relative to the diaphragm. The high-impedance node must be perfectly isolated to maintain the electrostatic field required for consistent directional sensitivity.

## 2. Key Engineering Challenges
- **High-Impedance Nodes (Giga-ohm Range):** The connection between the capsule and the JFET gate is extremely sensitive. Any contamination (finger oils, flux residue) will create leakage paths, resulting in "frying" noises or total signal loss.
- **Phantom Power Management:** Ensuring stable voltage rails without introducing switching noise or ripple from the interface.
- **EMI/RFI Shielding:** The high-impedance front-end acts as an antenna. The circuit must be enclosed in a Faraday cage (the mic body) and utilize proper RF filtering (C0G/NP0 capacitors).

## 3. Toolchain & Workflow
1. **Simulation (LTspice/Simulink):** Verify biasing points and frequency response.
2. **Schematic Capture (KiCad):** Map out the Schoeps circuit.
3. **PCB Layout (KiCad):** Focus on tight loops, guarding high-impedance traces, and maximizing ground planes.
4. **Assembly:** Precision soldering with the Pinecil V2.
5. **Diagnostics:** Using the FNIRSI 1014D scope to audit signal integrity and bias rails.
