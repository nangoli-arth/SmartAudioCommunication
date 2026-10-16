


# Smart Digital Audio Communication Simulator

A professional, modular MATLAB-based simulation framework and interactive desktop application designed to model, analyze, and visualize a complete end-to-end digital communication system. 

The project bridges theoretical communication principles with practical software engineering by transitioning from a monolithic script structure to a clean, modular architecture supporting both command-line execution and an interactive MATLAB App Designer dashboard.

---

## Key Features

- **Complete End-to-End Pipeline:** Simulates 6 distinct stages including message generation, uniform quantization, Pulse Code Modulation (PCM) encoding, NRZ line coding, digital modulation, AWGN channel transmission, demodulation, and signal reconstruction.
- **Flexible Modulation Schemes:** Supports both Binary Phase Shift Keying (BPSK) and Quadrature Phase Shift Keying (QPSK).
- **Additive White Gaussian Noise (AWGN) Channel:** Implements dynamic SNR adjustments ($0\text{ dB}$ to $20\text{ dB}$) with real-time symbol power scaling and noise generation.
- **Rigorous Performance Metrics:** Evaluates system fidelity using Bit Error Rate (BER), Reconstruction Mean Squared Error (MSE), and theoretical Shannon Channel Capacity.
- **Interactive GUI Dashboard (`SmartAudioCommunicationApp.mlapp`):** Features live parameter controls, constellation plotting, waveform comparisons, and multi-metric sweep graphs.
- **Automated Data Export:** Exports sweep results directly to CSV and MAT formats for academic reporting and further analysis.

---

## Repository Structure

```text
SmartAudioCommunicationSimulator/
├── main.m                           # Master command-line script running all 6 stages
├── SmartAudioCommunicationApp.mlapp # Interactive App Designer GUI application
├── functions/                       # Modular core algorithm directory
│   ├── generateMessage.m            # Stage 1: Analog message generation
│   ├── quantizeAndEncode.m          # Stage 2: Uniform quantization & PCM encoding
│   ├── modulateSignal.m             # Stage 3: BPSK/QPSK digital modulation
│   ├── applyAWGN.m                  # Stage 4: AWGN channel noise injection
│   ├── demodulateSignal.m           # Stage 4: Symbol demodulation to bitstreams
│   ├── decodeAndReconstruct.m       # Stage 4: PCM decoding & signal reconstruction
│   └── evaluatePerformance.m        # Stage 5: SNR sweep for BER, MSE & Capacity
├── figures/                         # Exported high-resolution plots (.png and .fig)
├── results/                         # Exported performance summary tables (.csv and .mat)
└── README.md                        # Project documentation

```

---

## System Requirements

* **MATLAB** (Recommended: R2024b or newer)
* **Required Toolboxes:**
* MATLAB App Designer



---

## Getting Started & Usage

### 1. Running via Command Line (Master Script)

To execute the complete 6-stage simulation pipeline, print diagnostic logs, generate plots, and export results:

1. Open MATLAB and set your current working directory to the project root (`SmartAudioCommunicationSimulator/`).
2. Run the master script:
```matlab
main

```



### 2. Running the Interactive Dashboard

To launch the desktop graphical user interface:

1. Open **`SmartAudioCommunicationApp.mlapp`** directly inside MATLAB App Designer.
2. Click **Run** in the App Designer toolbar.
3. Adjust modulation schemes (BPSK / QPSK) and channel SNR sliders interactively to observe real-time constellation clustering, error rates, and reconstructed waveforms.

---

## Performance Insights

* **Low SNR ($0\text{ dB}$):** High noise interference causes significant constellation dispersion, resulting in a higher BER ($\approx 10^{-2}$) and visible distortion in the reconstructed audio waveform.
* **High SNR ($\ge 10\text{ dB}$):** Constellation points tightly cluster around reference states, driving the BER down toward zero ($0$) and achieving near-perfect signal reconstruction where MSE approaches quantization-only noise limits.

---

## Authors

NANGOLI ARTHUR - S25B48/051
PEACE TEDDIE CHEPKWURUI - S25B48/044



