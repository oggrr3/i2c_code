

# I. I2C
## 1. Struct of I2C
![Block diagram of i2c master](./image/image-1.png)
Bao gồm các khối sau:
- APB Slave Interface
- Register Block
- DATA FIFO
- Clock Generator
- FSM
- Data path i2c to core
## 2. Hoạt động của I2C
![alt text](./image/image-2.png)

Các điều kiện hoạt động:

![alt text](./image/image-4.png)

## 3. Registermap
![register map](./image/image-5.png)

## 4. FSM
![alt text](./image/image-6.png)
![alt text](./image/image-7.png)
![alt text](./image/image-8.png)

## 5. User guide
`Step 1: Reset APB and config`

    1.1. reset APB
	1.2. APB write data to FIFO
	1.3. Write slave’s address, bit 0 is 0 to write-mode
	1.4. Write prescale
	1.5. Write command to enable i2c core
![alt text](./image/image-9.png)

`Step 2 : Test write data`

    2.1. You can run until the FIFO is empty, then i2c will STOP.
![alt text](./image/image-10.png)

`Step 3: After STOP condition, you have to config command to enable again `

	3.1. Write slave’s address, bit 0 is 1 to read-mode
	3.2. Write prescale if changed
	3.3. Write command

![alt text](./image/image-11.png)

`Step 4: Slave ACK and then write data to sda`

    4.1. You can run until the FIFO is full, then i2c will STOP
![alt text](./image/image-12.png)

`Step 5: CPU read data from FIFO through APB interface`

    5.1. You need to config the APB at read-mode
![alt text](./image/image-13.png)

## 6. Verification 
`The architecture of top_tb to verification `

![alt text](./image/top_verification.png)
