# UART Communication on FPGA

This project implements **UART (Universal Asynchronous Receiver/Transmitter) communication** using an FPGA.  
It includes **Verilog modules** for **transmitting (`uart_tx.v`) and receiving (`uart_rx.v`) data**, along with a **testbench (`uart_full_duplex_tb.v`)** to verify functionality.

---

##  Features
Baud Rate Control with `CLKS_PER_BIT`  
FSM-Based UART Transmitter & Receiver  
Full-Duplex Communication  
Tested using Verilog Testbench & Waveform Simulation  

---

## 🎯 How to Run the Simulation

### 🔹 **1. Compile the testbench** using Icarus Verilog:
```sh
iverilog -o uart_output uart_tb.v
```
## 📜 Credits
  This project is based on the UART tutorial by Nandland and has been modified and extended for full-duplex UART communication with FPGA simulation and testbenches.

   Special thanks to Nandland for the foundational UART concepts! 
