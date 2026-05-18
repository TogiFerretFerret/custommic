# Schoeps-Style Preamp Circuit Design

## 1. Input Stage (High Impedance Conversion)
The goal is to convert the ultra-high impedance charge signal from the capsule to a low-impedance voltage.

- **Capsule (C1):** 34mm RK-47. Single-diaphragm configuration for fixed Cardioid.
  - **Diaphragm:** Typically connected to the JFET Gate (the ultra-high impedance node).
  - **Backplate:** Connected to the filtered P48 Bias rail (~40-60V). 
  - **Cardioid Implementation:** The directional pattern is achieved by the capsule's physical design (perforated backplate) combined with the mic body's acoustic vents. No secondary diaphragm biasing is required for fixed cardioid.

- **JFET (Q1):** LSK170B.
  - **Gate (G):** Connected to Capsule through a 1GΩ resistor (R1) for biasing.
  - **Drain (D):** Tapped to a filtered voltage rail (~15-20V).
  - **Source (S):** Connected to the output stage and a source resistor (R2) for self-biasing.
- **1GΩ Resistor (R1):** Critical for setting the gate bias without loading the capsule signal.

## 2. Output Stage (Balanced Differential)
Converts the single-ended JFET signal into a balanced differential signal to drive the XLR output.

- **NPN Transistors (Q2, Q3):** BC547CBU.
- **Topology:** Phase splitter or differential pair. The classic Schoeps uses a phase splitter to drive the hot and cold lines.
- **Output Coupling:** Film capacitors (C2, C3, 0.1uF) to block DC from the XLR lines while passing the audio signal.

## 3. Power Distribution (Phantom Power P48)
Derives power from the 48V supplied by the Scarlett Solo.

- **Input Resistors (R3, R4):** 6.81kΩ 1% (matched). Tapped from XLR Pin 2 (Hot) and Pin 3 (Cold).
- **Filtering:** Large electrolytic or film caps (C4, 0.1uF) and a Zener diode (D1, 6.2V) to regulate the rail for the active components.
- **Capsule Bias:** A high-voltage divider or multiplier might be needed if the capsule requires >20V. In a simple Schoeps, it often uses the full P48 rail through a large RC filter.

## 4. Netlist (Draft)
| Net Name | Connection Points |
| :--- | :--- |
| **BIAS_V** | R1 (1G), Capsule(+) |
| **G_JFET** | R1 (1G), Capsule(-), Q1 Gate |
| **V_RAIL** | Q1 Drain, R3, R4, Zener Cathode |
| **AUDIO_HOT** | Q2 Emitter (via C2), XLR Pin 2 |
| **AUDIO_COLD** | Q3 Emitter (via C3), XLR Pin 3 |
| **GND** | XLR Pin 1, Zener Anode, Shielding |

## 5. Critical Components Roles
- **1000pF NP0 (C5, C6):** Used at the XLR input for RF suppression. Must be NP0/C0G for audio transparency.
- **BC547C:** High gain (hFE) helps in maintaining a low noise floor in the output stage.
