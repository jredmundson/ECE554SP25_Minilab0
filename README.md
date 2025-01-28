Github link:
https://github.com/jredmundson/ECE554SP25_Minilab0

Github Usernames:
- jredmundson (Jacob Edmundson)
- jecampos (Jaime Campos)

#  Verilog Files

## No IP
-  fifo.sv, mac.sv: Filled out to get the top level moduble to properly dislpay dot product
-  Minilab0.v: Unmodified top level module to get the dot product to display on FPGA without IP (Should display 16'1B58)
-  fifo_tb.sv, mac_tb.sv: Simple tests to make sure mac and fifo were working
-  Minilab0_tb.v: Testbench for minilab 0 without IP. Runs Minilab0.v and checks if result in DONE state matches 16'1B58 (7000 decimal)

## IP
-  FIFO_IP.v, LPM_MULT_IP.v, LPM_ADD_IP.v: IP files generated for the fifo, multiplier, and adder respectively
-  Minilab0_IP.v: Modified top level module that replaced old fifo and macs, with IP versions
-  Minilab0_IP_tb.v: Testbench for minilab 0 with IP. Runs Minilab0_IP.v and checks if result in DONE state matches 16'1B58 (7000 decimal)

# Other Files
- Minilab0_Resource_Usage_Summary*.rpt: Saved resource usage summaries for Minilab0 with and without IP
- minilab0_sim_log.png: Simulation log of Minilab0_tb.v
- minilab0_sim.png: Waveform output of Minilab0_tb.v with result wave selected
- minilab0_ip_sim_log.png: Simulation log of Minilab0_IP_tb.v
- minilab0_ip_sim.png: Waveform output of Minilab0_tb.v with result wave selected

# Difference in Resource Utilization Between Reports
Based on the two reports, the design using IP was significantly more efficient in terms of logic/resource utilization. Our design used roughly 2x the logic registers of the IP design, and 1.15x more LUTs for logic. They both used the same number of IO blocks as expected, but a big difference was the IP design synthesized block memory, while ours did not. This is likely the reason why ours used many more registers - it was using them as memory (distributed RAM) instead of the block RAM. This could also explain the higher fanout, as more memory cells were spread around instead of fewer large block rams. 
