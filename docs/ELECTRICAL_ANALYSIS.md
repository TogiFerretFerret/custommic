# Electrical Analysis: P48 Biasing & Power Budget (Updated for Actual BOM)

## 1. Phantom Power (P48) Source
- **Voltage (V_source):** 48V DC (Standard).
- **Supply Resistors (R_s):** 6.81kΩ (Internal to Scarlett Solo, per XLR leg).
- **Effective Resistance (R_eff):** $R_{eff} = 6.81k\Omega / 2 = 3405 \Omega$.

## 2. Preamp Current Draw & Rail Voltage
The Schoeps circuit with 100k resistors in the output stage draws significantly less current than higher-gain variants.

- **Assumed Current (I_total):** ~1.5mA.
- **Voltage Drop (V_drop):** $V_{drop} = I_{total} \times R_{eff} = 0.0015A \times 3405\Omega \approx 5.1V$.
- **Circuit Rail (V_rail):** $V_{rail} = 48V - 5.1V = 42.9V$.
- **Zener Regulation:** The 6.2V Zener (1N5234B) clamps the JFET source/base reference to ensure a stable operating point regardless of P48 fluctuations.

## 3. Capsule Bias (The "Charge" Voltage)
- **Mechanism:** Taps the raw P48 tap before the Zener.
- **Bias Resistor:** 100kΩ (per BOM).
- **Filtering:** 0.1uF film capacitor.
- **Note:** The 100kΩ resistor provides the bias path. While lower than traditional 10M-1G bias resistors, it is matched with the RK-47's requirements in this specific topology.

## 4. JFET Biasing (LSK170B)
- **Gate Bias:** 1GΩ resistor (A106006CT) sets the gate to GND potential with ultra-low leakage.
- **Source/Drain:** The 100kΩ resistors from the BOM are used for the phase splitter and JFET load.

## 5. Output Stage (BC547C)
- **Gain:** High hFE (420-800) provides excellent linearity.
- **Impedance:** The 0.1uF output caps (495-2465) block DC while maintaining low-end response down to ~20Hz into a standard 1.5kΩ-3kΩ preamp input.

