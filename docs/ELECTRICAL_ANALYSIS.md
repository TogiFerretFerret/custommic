# Electrical Analysis: P48 Biasing & Power Budget

## 1. Phantom Power (P48) Source
- **Voltage (V_source):** 48V DC (Standard).
- **Supply Resistors (R_s):** 6.81kΩ (Internal to Scarlett Solo, per XLR leg).
- **Effective Resistance (R_eff):** Since P48 is delivered via Pin 2 and Pin 3 in parallel, $R_{eff} = 6.81k\Omega / 2 = 3405 \Omega$.

## 2. Preamp Current Draw & Rail Voltage
The Schoeps circuit typically draws between 2mA and 4mA.

- **Assumed Current (I_total):** 3mA.
- **Voltage Drop (V_drop):** $V_{drop} = I_{total} \times R_{eff} = 0.003A \times 3405\Omega \approx 10.2V$.
- **Circuit Rail (V_rail):** $V_{rail} = 48V - 10.2V = 37.8V$.

**Conclusion:** The circuit has ~38V available for active components. This is plenty for the BC547C output stage and the LSK170 JFET.

## 3. Capsule Bias (The "Charge" Voltage)
The RK-47 capsule needs a high DC voltage to function as a transducer.
- **Classic Schoeps Trick:** It uses the full P48 rail (before the drop) for the capsule bias by tapping through a massive RC filter.
- **Bias Filter (R_bias, C_bias):**
  - **R_bias:** 1GΩ (Input) + 10MΩ (Filtering).
  - **C_bias:** 0.1uF.
- **Time Constant ($\tau$):** $\tau = R \times C = 10^7\Omega \times 10^{-7}F = 1 \text{ second}$.
- **Startup Time:** It will take ~3-5 seconds for the capsule to fully "charge" and reach operating sensitivity after plugging in.

## 4. JFET Biasing (LSK170B)
- **V_gs (off):** -0.2V to -1.5V.
- **Desired I_d:** ~0.5mA to 1.0mA.
- **Source Resistor (R_s):** To set $V_{gs} \approx -0.5V$ at 0.5mA:
  - $R_s = V / I = 0.5V / 0.0005A = 1000 \Omega$.
- **Drain Resistor (R_d):** To drop ~10V from the 38V rail:
  - $R_d = 10V / 0.0005A = 20k\Omega$.

## 5. Maximum SPL Handling
- **Constraint:** The output swing is limited by the $V_{rail}$.
- **Calculation:** With a 38V rail and a balanced output, the mic can theoretically swing ~70V peak-to-peak before clipping. This is extremely high headroom, typical of transformerless designs.

## Summary for Schematic
- **Main Filter Cap:** 0.1uF (Film).
- **Zener Regulation:** 6.2V (only for the JFET source/base reference if needed).
- **Matched Pair:** R3, R4 must be 6.81kΩ 0.1% or 1% matched for high CMRR (Common Mode Rejection Ratio).
