User guide
Step 1: Reset APB and config
	1.1. Prepare data
	1.2. Write slave’s address, bit 0 is 0 to write-mode
	1.3. Write prescale
	1.3. Write command


Step 2 : Test write data


Step 3: After STOP condition, you have to reset APB and then config APB again 
	3.1. Write slave’s address, bit 0 is 1 to read-mode
	3.2. Write prescale
	3.3. Write command



Step 4: Slave ACK and then write data to sda



Step 5: CPU read data from FIFO

