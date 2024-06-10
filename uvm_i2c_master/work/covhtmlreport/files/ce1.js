var g_data = {"20":{"pr":"/tb_top/dut","t":"inst","ce":[{"f":138,"l":48,"i":1,"s":"(~address_reg[0]? (command_reg[7] & ~status_reg[6]): (command_reg[7] & ~status_reg[5]))","bi":1,"hp":0,"t":[{"n":"address_reg[0]","c":1},{"n":"command_reg[7]","c":1},{"n":"status_reg[6]","c":1},{"n":"status_reg[5]","c":1}],"r":[{"n":"address_reg[0]_0","i":1,"b":[{"m":"-","h":12},{"m":"-","h":11}]},{"n":"address_reg[0]_1","i":2,"b":[{"m":"-","h":1},{"m":"-","h":6}]},{"n":"command_reg[7]_0","i":3,"b":[{"m":"(~address_reg[0] && ~status_reg[6]), (address_reg[0] && ~status_reg[5])","h":4},{"m":"(~address_reg[0] && ~status_reg[6]), (address_reg[0] && ~status_reg[5])","h":0}]},{"n":"command_reg[7]_1","i":4,"b":[{"m":"(~address_reg[0] && ~status_reg[6]), (address_reg[0] && ~status_reg[5])","h":0},{"m":"(~address_reg[0] && ~status_reg[6]), (address_reg[0] && ~status_reg[5])","h":12}]},{"n":"status_reg[6]_0","i":5,"b":[{"m":"(~address_reg[0] && command_reg[7])","h":0},{"m":"(~address_reg[0] && command_reg[7])","h":11}]},{"n":"status_reg[6]_1","i":6,"b":[{"m":"(~address_reg[0] && command_reg[7])","h":12},{"m":"(~address_reg[0] && command_reg[7])","h":0}]},{"n":"status_reg[5]_0","i":7,"b":[{"m":"(address_reg[0] && command_reg[7])","h":0},{"m":"(address_reg[0] && command_reg[7])","h":6}]},{"n":"status_reg[5]_1","i":8,"b":[{"m":"(address_reg[0] && command_reg[7])","h":1},{"m":"(address_reg[0] && command_reg[7])","h":0}]}],"x":1,"p":100.00}]},"22":{"pr":"/tb_top/dut/fifo_tx/fifomem","t":"inst","ce":[{"f":139,"l":21,"i":1,"s":"(write_enable && ~write_full)","bi":0,"hp":0,"t":[],"x":0,"p":"E"}]},"23":{"pr":"/tb_top/dut/fifo_tx/read_pointer_empty","t":"inst","ce":[{"f":139,"l":97,"i":1,"s":"(read_gray_next == read_to_write_pointer)","bi":0,"hp":0,"t":[{"n":"(read_gray_next == read_to_write_pointer)","c":1}],"r":[{"n":"(read_gray_next == read_to_write_pointer)_0","i":1,"b":[{"m":"-","h":11}]},{"n":"(read_gray_next == read_to_write_pointer)_1","i":2,"b":[{"m":"-","h":12}]}],"x":1,"p":100.00}]},"24":{"pr":"/tb_top/dut/fifo_tx/write_pointer_full","t":"inst","ce":[{"f":139,"l":57,"i":1,"s":"(write_gray_next == {~write_to_read_pointer[3:2],write_to_read_pointer[1:0]})","bi":0,"hp":0,"t":[{"n":"(write_gray_next == {~write_to_read_pointer[3:2],write_to_read_pointer[1:0]})","c":1}],"r":[{"n":"(write_gray_next == {~write_to_read_pointer[3:2],write_to_read_pointer[1:0]})_0","i":1,"b":[{"m":"-","h":12}]},{"n":"(write_gray_next == {~write_to_read_pointer[3:2],write_to_read_pointer[1:0]})_1","i":2,"b":[{"m":"-","h":3}]}],"x":1,"p":100.00}]},"28":{"pr":"/tb_top/dut/fifo_rx/fifomem","t":"inst","ce":[{"f":139,"l":21,"i":1,"s":"(write_enable && ~write_full)","bi":0,"hp":0,"t":[],"x":0,"p":"E"}]},"29":{"pr":"/tb_top/dut/fifo_rx/read_pointer_empty","t":"inst","ce":[{"f":139,"l":97,"i":1,"s":"(read_gray_next == read_to_write_pointer)","bi":0,"hp":0,"t":[{"n":"(read_gray_next == read_to_write_pointer)","c":1}],"r":[{"n":"(read_gray_next == read_to_write_pointer)_0","i":1,"b":[{"m":"-","h":5}]},{"n":"(read_gray_next == read_to_write_pointer)_1","i":2,"b":[{"m":"-","h":12}]}],"x":1,"p":100.00}]},"30":{"pr":"/tb_top/dut/fifo_rx/write_pointer_full","t":"inst","ce":[{"f":139,"l":57,"i":1,"s":"(write_gray_next == {~write_to_read_pointer[3:2],write_to_read_pointer[1:0]})","bi":0,"hp":0,"t":[{"n":"(write_gray_next == {~write_to_read_pointer[3:2],write_to_read_pointer[1:0]})","c":1}],"r":[{"n":"(write_gray_next == {~write_to_read_pointer[3:2],write_to_read_pointer[1:0]})_0","i":1,"b":[{"m":"-","h":12}]},{"n":"(write_gray_next == {~write_to_read_pointer[3:2],write_to_read_pointer[1:0]})_1","i":2,"b":[{"m":"-","h":1}]}],"x":1,"p":100.00}]},"33":{"pr":"/tb_top/dut/apb","t":"inst","ce":[{"f":140,"l":47,"i":1,"s":"(PENABLE & PSELx)","bi":0,"hp":0,"t":[{"n":"PENABLE","c":1},{"n":"PSELx","c":1}],"r":[{"n":"PENABLE_0","i":1,"b":[{"m":"PSELx","h":12}]},{"n":"PENABLE_1","i":2,"b":[{"m":"PSELx","h":12}]},{"n":"PSELx_0","i":3,"b":[{"m":"PENABLE","h":1}]},{"n":"PSELx_1","i":4,"b":[{"m":"PENABLE","h":12}]}],"x":1,"p":100.00},{"f":140,"l":64,"i":1,"s":"((PWRITE && PSELx) && PENABLE)","bi":0,"hp":0,"t":[{"n":"PWRITE","c":1},{"n":"PSELx","c":1},{"n":"PENABLE","c":1}],"r":[{"n":"PWRITE_0","i":1,"b":[{"m":"-","h":2}]},{"n":"PWRITE_1","i":2,"b":[{"m":"(PENABLE && PSELx)","h":12}]},{"n":"PSELx_0","i":3,"b":[{"m":"PWRITE","h":12}]},{"n":"PSELx_1","i":4,"b":[{"m":"(PENABLE && PWRITE)","h":12}]},{"n":"PENABLE_0","i":5,"b":[{"m":"(PWRITE && PSELx)","h":12}]},{"n":"PENABLE_1","i":6,"b":[{"m":"(PWRITE && PSELx)","h":12}]}],"x":0,"p":100.00},{"f":140,"l":70,"i":1,"s":"((PWRITE && PSELx) && PENABLE)","bi":0,"hp":0,"t":[{"n":"PWRITE","c":1},{"n":"PSELx","c":1},{"n":"PENABLE","c":1}],"r":[{"n":"PWRITE_0","i":1,"b":[{"m":"-","h":2}]},{"n":"PWRITE_1","i":2,"b":[{"m":"(PENABLE && PSELx)","h":12}]},{"n":"PSELx_0","i":3,"b":[{"m":"PWRITE","h":12}]},{"n":"PSELx_1","i":4,"b":[{"m":"(PENABLE && PWRITE)","h":12}]},{"n":"PENABLE_0","i":5,"b":[{"m":"(PWRITE && PSELx)","h":12}]},{"n":"PENABLE_1","i":6,"b":[{"m":"(PWRITE && PSELx)","h":12}]}],"x":0,"p":100.00},{"f":140,"l":76,"i":1,"s":"((~PWRITE && PSELx) && PENABLE)","bi":0,"hp":0,"t":[{"n":"PWRITE","c":1},{"n":"PSELx","c":1},{"n":"PENABLE","c":1}],"r":[{"n":"PWRITE_0","i":1,"b":[{"m":"(PENABLE && PSELx)","h":2}]},{"n":"PWRITE_1","i":2,"b":[{"m":"-","h":1}]},{"n":"PSELx_0","i":3,"b":[{"m":"~PWRITE","h":2}]},{"n":"PSELx_1","i":4,"b":[{"m":"(PENABLE && ~PWRITE)","h":2}]},{"n":"PENABLE_0","i":5,"b":[{"m":"(~PWRITE && PSELx)","h":2}]},{"n":"PENABLE_1","i":6,"b":[{"m":"(~PWRITE && PSELx)","h":2}]}],"x":0,"p":100.00},{"f":140,"l":82,"i":1,"s":"((PWRITE && PSELx) && PENABLE)","bi":0,"hp":0,"t":[{"n":"PWRITE","c":1},{"n":"PSELx","c":1},{"n":"PENABLE","c":1}],"r":[{"n":"PWRITE_0","i":1,"b":[{"m":"-","h":2}]},{"n":"PWRITE_1","i":2,"b":[{"m":"(PENABLE && PSELx)","h":12}]},{"n":"PSELx_0","i":3,"b":[{"m":"PWRITE","h":12}]},{"n":"PSELx_1","i":4,"b":[{"m":"(PENABLE && PWRITE)","h":12}]},{"n":"PENABLE_0","i":5,"b":[{"m":"(PWRITE && PSELx)","h":12}]},{"n":"PENABLE_1","i":6,"b":[{"m":"(PWRITE && PSELx)","h":12}]}],"x":0,"p":100.00},{"f":140,"l":95,"i":1,"s":"(~PWRITE && PENABLE)","bi":0,"hp":0,"t":[{"n":"PWRITE","c":1},{"n":"PENABLE","c":1}],"r":[{"n":"PWRITE_0","i":1,"b":[{"m":"PENABLE","h":4}]},{"n":"PWRITE_1","i":2,"b":[{"m":"-","h":1}]},{"n":"PENABLE_0","i":3,"b":[{"m":"~PWRITE","h":4}]},{"n":"PENABLE_1","i":4,"b":[{"m":"~PWRITE","h":4}]}],"x":0,"p":100.00},{"f":140,"l":103,"i":1,"s":"((PWRITE && PSELx) && PENABLE)","bi":0,"hp":0,"t":[{"n":"PWRITE","c":1},{"n":"PSELx","c":1},{"n":"PENABLE","c":1}],"r":[{"n":"PWRITE_0","i":1,"b":[{"m":"-","h":2}]},{"n":"PWRITE_1","i":2,"b":[{"m":"(PENABLE && PSELx)","h":12}]},{"n":"PSELx_0","i":3,"b":[{"m":"PWRITE","h":12}]},{"n":"PSELx_1","i":4,"b":[{"m":"(PENABLE && PWRITE)","h":12}]},{"n":"PENABLE_0","i":5,"b":[{"m":"(PWRITE && PSELx)","h":12}]},{"n":"PENABLE_1","i":6,"b":[{"m":"(PWRITE && PSELx)","h":12}]}],"x":0,"p":100.00}]},"34":{"pr":"/tb_top/dut/i2c","t":"inst","ce":[{"f":141,"l":70,"i":1,"s":"((((current_state == 1) || (current_state == 3)) || (current_state == 5)) || (current_state == 7))","bi":0,"hp":0,"t":[{"n":"(current_state == 1)","c":1},{"n":"(current_state == 3)","c":1},{"n":"(current_state == 5)","c":1},{"n":"(current_state == 7)","c":1}],"r":[{"n":"(current_state == 1)_0","i":1,"b":[{"m":"(~(current_state == 7) && ~(current_state == 5) && ~(current_state == 3))","h":12}]},{"n":"(current_state == 1)_1","i":2,"b":[{"m":"-","h":11}]},{"n":"(current_state == 3)_0","i":3,"b":[{"m":"(~(current_state == 7) && ~(current_state == 5) && ~(current_state == 1))","h":12}]},{"n":"(current_state == 3)_1","i":4,"b":[{"m":"~(current_state == 1)","h":10}]},{"n":"(current_state == 5)_0","i":5,"b":[{"m":"(~(current_state == 7) && ~((current_state == 1) || (current_state == 3)))","h":12}]},{"n":"(current_state == 5)_1","i":6,"b":[{"m":"~((current_state == 1) || (current_state == 3))","h":9}]},{"n":"(current_state == 7)_0","i":7,"b":[{"m":"~(((current_state == 1) || (current_state == 3)) || (current_state == 5))","h":12}]},{"n":"(current_state == 7)_1","i":8,"b":[{"m":"~(((current_state == 1) || (current_state == 3)) || (current_state == 5))","h":5}]}],"x":0,"p":100.00},{"f":141,"l":72,"i":1,"s":"(((current_state == 2) || (current_state == 4)) || (current_state == 6))","bi":0,"hp":0,"t":[{"n":"(current_state == 2)","c":1},{"n":"(current_state == 4)","c":1},{"n":"(current_state == 6)","c":1}],"r":[{"n":"(current_state == 2)_0","i":1,"b":[{"m":"(~(current_state == 6) && ~(current_state == 4))","h":12}]},{"n":"(current_state == 2)_1","i":2,"b":[{"m":"-","h":10}]},{"n":"(current_state == 4)_0","i":3,"b":[{"m":"(~(current_state == 6) && ~(current_state == 2))","h":12}]},{"n":"(current_state == 4)_1","i":4,"b":[{"m":"~(current_state == 2)","h":9}]},{"n":"(current_state == 6)_0","i":5,"b":[{"m":"~((current_state == 2) || (current_state == 4))","h":12}]},{"n":"(current_state == 6)_1","i":6,"b":[{"m":"~((current_state == 2) || (current_state == 4))","h":5}]}],"x":0,"p":100.00},{"f":141,"l":84,"i":1,"s":"((current_state == 5) || (current_state == 7))","bi":0,"hp":0,"t":[{"n":"(current_state == 5)","c":1},{"n":"(current_state == 7)","c":1}],"r":[{"n":"(current_state == 5)_0","i":1,"b":[{"m":"~(current_state == 7)","h":12}]},{"n":"(current_state == 5)_1","i":2,"b":[{"m":"-","h":9}]},{"n":"(current_state == 7)_0","i":3,"b":[{"m":"~(current_state == 5)","h":12}]},{"n":"(current_state == 7)_1","i":4,"b":[{"m":"~(current_state == 5)","h":5}]}],"x":0,"p":100.00},{"f":141,"l":86,"i":1,"s":"(ack_counter1 == 5)","bi":0,"hp":0,"t":[{"n":"(ack_counter1 == 5)","c":1}],"r":[{"n":"(ack_counter1 == 5)_0","i":1,"b":[{"m":"-","h":9}]},{"n":"(ack_counter1 == 5)_1","i":2,"b":[{"m":"-","h":9}]}],"x":0,"p":100.00},{"f":141,"l":91,"i":1,"s":"((current_state == 4) || (current_state == 6))","bi":0,"hp":0,"t":[{"n":"(current_state == 4)","c":1},{"n":"(current_state == 6)","c":1}],"r":[{"n":"(current_state == 4)_0","i":1,"b":[{"m":"~(current_state == 6)","h":12}]},{"n":"(current_state == 4)_1","i":2,"b":[{"m":"-","h":9}]},{"n":"(current_state == 6)_0","i":3,"b":[{"m":"~(current_state == 4)","h":12}]},{"n":"(current_state == 6)_1","i":4,"b":[{"m":"~(current_state == 4)","h":5}]}],"x":0,"p":100.00},{"f":141,"l":93,"i":1,"s":"(ack_counter2 == 5)","bi":0,"hp":0,"t":[{"n":"(ack_counter2 == 5)","c":1}],"r":[{"n":"(ack_counter2 == 5)_0","i":1,"b":[{"m":"-","h":9}]},{"n":"(ack_counter2 == 5)_1","i":2,"b":[{"m":"-","h":9}]}],"x":0,"p":100.00},{"f":141,"l":119,"i":1,"s":"(counter == 0)","bi":0,"hp":0,"t":[{"n":"(counter == 0)","c":1}],"r":[{"n":"(counter == 0)_0","i":1,"b":[{"m":"-","h":10}]},{"n":"(counter == 0)_1","i":2,"b":[{"m":"-","h":10}]}],"x":0,"p":100.00},{"f":141,"l":139,"i":1,"s":"(counter == 0)","bi":0,"hp":0,"t":[{"n":"(counter == 0)","c":1}],"r":[{"n":"(counter == 0)_0","i":1,"b":[{"m":"-","h":9}]},{"n":"(counter == 0)_1","i":2,"b":[{"m":"-","h":9}]}],"x":0,"p":100.00},{"f":141,"l":166,"i":1,"s":"(counter == 0)","bi":0,"hp":0,"t":[{"n":"(counter == 0)","c":1}],"r":[{"n":"(counter == 0)_0","i":1,"b":[{"m":"-","h":5}]},{"n":"(counter == 0)_1","i":2,"b":[{"m":"-","h":5}]}],"x":0,"p":100.00},{"f":141,"l":237,"i":1,"s":"(ack_counter2 == 3)","bi":0,"hp":0,"t":[{"n":"(ack_counter2 == 3)","c":1}],"r":[{"n":"(ack_counter2 == 3)_0","i":1,"b":[{"m":"-","h":9}]},{"n":"(ack_counter2 == 3)_1","i":2,"b":[{"m":"-","h":9}]}],"x":0,"p":100.00},{"f":141,"l":249,"i":1,"s":"(ack_counter1 == 3)","bi":0,"hp":0,"t":[{"n":"(ack_counter1 == 3)","c":1}],"r":[{"n":"(ack_counter1 == 3)_0","i":1,"b":[{"m":"-","h":9}]},{"n":"(ack_counter1 == 3)_1","i":2,"b":[{"m":"-","h":9}]}],"x":0,"p":100.00},{"f":141,"l":269,"i":1,"s":"(ack_counter2 == 3)","bi":0,"hp":0,"t":[{"n":"(ack_counter2 == 3)","c":1}],"r":[{"n":"(ack_counter2 == 3)_0","i":1,"b":[{"m":"-","h":5}]},{"n":"(ack_counter2 == 3)_1","i":2,"b":[{"m":"-","h":5}]}],"x":0,"p":100.00},{"f":141,"l":283,"i":1,"s":"(ack_counter1 == 3)","bi":0,"hp":0,"t":[{"n":"(ack_counter1 == 3)","c":1}],"r":[{"n":"(ack_counter1 == 3)_0","i":1,"b":[{"m":"-","h":5}]},{"n":"(ack_counter1 == 3)_1","i":2,"b":[{"m":"-","h":5}]}],"x":0,"p":100.00}]},"35":{"pr":"/tb_top/dut/converter","t":"inst","ce":[{"f":142,"l":20,"i":1,"s":"(counter == 7)","bi":0,"hp":0,"t":[{"n":"(counter == 7)","c":1}],"r":[{"n":"(counter == 7)_0","i":1,"b":[{"m":"-","h":12}]},{"n":"(counter == 7)_1","i":2,"b":[{"m":"-","h":5}]}],"x":0,"p":100.00},{"f":142,"l":31,"i":1,"s":"((counter == 0) && (tmp != 0))","bi":0,"hp":0,"t":[{"n":"(counter == 0)","c":1},{"n":"(tmp != 0)","c":1}],"r":[{"n":"(counter == 0)_0","i":1,"b":[{"m":"-","h":5}]},{"n":"(counter == 0)_1","i":2,"b":[{"m":"(tmp != 0)","h":2}]},{"n":"(tmp != 0)_0","i":3,"b":[{"m":"(counter == 0)","h":5}]},{"n":"(tmp != 0)_1","i":4,"b":[{"m":"(counter == 0)","h":2}]}],"x":0,"p":100.00}]},"36":{"pr":"/tb_top/dut/clock_gen","t":"inst","ce":[{"f":143,"l":16,"i":1,"s":"(counter == 3)","bi":0,"hp":0,"t":[{"n":"(counter == 3)","c":1}],"r":[{"n":"(counter == 3)_0","i":1,"b":[{"m":"-","h":12}]},{"n":"(counter == 3)_1","i":2,"b":[{"m":"-","h":12}]}],"x":0,"p":100.00}]},"15":{"pr":"work.BitToByteConverter","t":"du","ce":[{"f":142,"l":20,"i":1,"s":"(counter == 7)","bi":0,"hp":0,"t":[{"n":"(counter == 7)","c":1}],"r":[{"n":"(counter == 7)_0","i":1,"b":[{"m":"-","h":12}]},{"n":"(counter == 7)_1","i":2,"b":[{"m":"-","h":5}]}],"x":0,"p":100.00},{"f":142,"l":31,"i":1,"s":"((counter == 0) && (tmp != 0))","bi":0,"hp":0,"t":[{"n":"(counter == 0)","c":1},{"n":"(tmp != 0)","c":1}],"r":[{"n":"(counter == 0)_0","i":1,"b":[{"m":"-","h":5}]},{"n":"(counter == 0)_1","i":2,"b":[{"m":"(tmp != 0)","h":2}]},{"n":"(tmp != 0)_0","i":3,"b":[{"m":"(counter == 0)","h":5}]},{"n":"(tmp != 0)_1","i":4,"b":[{"m":"(counter == 0)","h":2}]}],"x":0,"p":100.00}]},"16":{"pr":"work.ClockGenerator","t":"du","ce":[{"f":143,"l":16,"i":1,"s":"(counter == 3)","bi":0,"hp":0,"t":[{"n":"(counter == 3)","c":1}],"r":[{"n":"(counter == 3)_0","i":1,"b":[{"m":"-","h":12}]},{"n":"(counter == 3)_1","i":2,"b":[{"m":"-","h":12}]}],"x":0,"p":100.00}]},"8":{"pr":"work.FIFO_memory","t":"du","ce":[{"f":139,"l":21,"i":1,"s":"(write_enable && ~write_full)","bi":0,"hp":0,"t":[],"x":0,"p":"E"}]},"13":{"pr":"work.apb","t":"du","ce":[{"f":140,"l":64,"i":1,"s":"((PWRITE && PSELx) && PENABLE)","bi":0,"hp":0,"t":[{"n":"PWRITE","c":1},{"n":"PSELx","c":1},{"n":"PENABLE","c":1}],"r":[{"n":"PWRITE_0","i":1,"b":[{"m":"-","h":2}]},{"n":"PWRITE_1","i":2,"b":[{"m":"(PENABLE && PSELx)","h":12}]},{"n":"PSELx_0","i":3,"b":[{"m":"PWRITE","h":12}]},{"n":"PSELx_1","i":4,"b":[{"m":"(PENABLE && PWRITE)","h":12}]},{"n":"PENABLE_0","i":5,"b":[{"m":"(PWRITE && PSELx)","h":12}]},{"n":"PENABLE_1","i":6,"b":[{"m":"(PWRITE && PSELx)","h":12}]}],"x":0,"p":100.00},{"f":140,"l":70,"i":1,"s":"((PWRITE && PSELx) && PENABLE)","bi":0,"hp":0,"t":[{"n":"PWRITE","c":1},{"n":"PSELx","c":1},{"n":"PENABLE","c":1}],"r":[{"n":"PWRITE_0","i":1,"b":[{"m":"-","h":2}]},{"n":"PWRITE_1","i":2,"b":[{"m":"(PENABLE && PSELx)","h":12}]},{"n":"PSELx_0","i":3,"b":[{"m":"PWRITE","h":12}]},{"n":"PSELx_1","i":4,"b":[{"m":"(PENABLE && PWRITE)","h":12}]},{"n":"PENABLE_0","i":5,"b":[{"m":"(PWRITE && PSELx)","h":12}]},{"n":"PENABLE_1","i":6,"b":[{"m":"(PWRITE && PSELx)","h":12}]}],"x":0,"p":100.00},{"f":140,"l":76,"i":1,"s":"((~PWRITE && PSELx) && PENABLE)","bi":0,"hp":0,"t":[{"n":"PWRITE","c":1},{"n":"PSELx","c":1},{"n":"PENABLE","c":1}],"r":[{"n":"PWRITE_0","i":1,"b":[{"m":"(PENABLE && PSELx)","h":2}]},{"n":"PWRITE_1","i":2,"b":[{"m":"-","h":1}]},{"n":"PSELx_0","i":3,"b":[{"m":"~PWRITE","h":2}]},{"n":"PSELx_1","i":4,"b":[{"m":"(PENABLE && ~PWRITE)","h":2}]},{"n":"PENABLE_0","i":5,"b":[{"m":"(~PWRITE && PSELx)","h":2}]},{"n":"PENABLE_1","i":6,"b":[{"m":"(~PWRITE && PSELx)","h":2}]}],"x":0,"p":100.00},{"f":140,"l":82,"i":1,"s":"((PWRITE && PSELx) && PENABLE)","bi":0,"hp":0,"t":[{"n":"PWRITE","c":1},{"n":"PSELx","c":1},{"n":"PENABLE","c":1}],"r":[{"n":"PWRITE_0","i":1,"b":[{"m":"-","h":2}]},{"n":"PWRITE_1","i":2,"b":[{"m":"(PENABLE && PSELx)","h":12}]},{"n":"PSELx_0","i":3,"b":[{"m":"PWRITE","h":12}]},{"n":"PSELx_1","i":4,"b":[{"m":"(PENABLE && PWRITE)","h":12}]},{"n":"PENABLE_0","i":5,"b":[{"m":"(PWRITE && PSELx)","h":12}]},{"n":"PENABLE_1","i":6,"b":[{"m":"(PWRITE && PSELx)","h":12}]}],"x":0,"p":100.00},{"f":140,"l":95,"i":1,"s":"(~PWRITE && PENABLE)","bi":0,"hp":0,"t":[{"n":"PWRITE","c":1},{"n":"PENABLE","c":1}],"r":[{"n":"PWRITE_0","i":1,"b":[{"m":"PENABLE","h":4}]},{"n":"PWRITE_1","i":2,"b":[{"m":"-","h":1}]},{"n":"PENABLE_0","i":3,"b":[{"m":"~PWRITE","h":4}]},{"n":"PENABLE_1","i":4,"b":[{"m":"~PWRITE","h":4}]}],"x":0,"p":100.00},{"f":140,"l":103,"i":1,"s":"((PWRITE && PSELx) && PENABLE)","bi":0,"hp":0,"t":[{"n":"PWRITE","c":1},{"n":"PSELx","c":1},{"n":"PENABLE","c":1}],"r":[{"n":"PWRITE_0","i":1,"b":[{"m":"-","h":2}]},{"n":"PWRITE_1","i":2,"b":[{"m":"(PENABLE && PSELx)","h":12}]},{"n":"PSELx_0","i":3,"b":[{"m":"PWRITE","h":12}]},{"n":"PSELx_1","i":4,"b":[{"m":"(PENABLE && PWRITE)","h":12}]},{"n":"PENABLE_0","i":5,"b":[{"m":"(PWRITE && PSELx)","h":12}]},{"n":"PENABLE_1","i":6,"b":[{"m":"(PWRITE && PSELx)","h":12}]}],"x":0,"p":100.00},{"f":140,"l":47,"i":1,"s":"(PENABLE & PSELx)","bi":0,"hp":0,"t":[{"n":"PENABLE","c":1},{"n":"PSELx","c":1}],"r":[{"n":"PENABLE_0","i":1,"b":[{"m":"PSELx","h":12}]},{"n":"PENABLE_1","i":2,"b":[{"m":"PSELx","h":12}]},{"n":"PSELx_0","i":3,"b":[{"m":"PENABLE","h":1}]},{"n":"PSELx_1","i":4,"b":[{"m":"PENABLE","h":12}]}],"x":1,"p":100.00}]},"14":{"pr":"work.i2c_controller","t":"du","ce":[{"f":141,"l":70,"i":1,"s":"((((current_state == 1) || (current_state == 3)) || (current_state == 5)) || (current_state == 7))","bi":0,"hp":0,"t":[{"n":"(current_state == 1)","c":1},{"n":"(current_state == 3)","c":1},{"n":"(current_state == 5)","c":1},{"n":"(current_state == 7)","c":1}],"r":[{"n":"(current_state == 1)_0","i":1,"b":[{"m":"(~(current_state == 7) && ~(current_state == 5) && ~(current_state == 3))","h":12}]},{"n":"(current_state == 1)_1","i":2,"b":[{"m":"-","h":11}]},{"n":"(current_state == 3)_0","i":3,"b":[{"m":"(~(current_state == 7) && ~(current_state == 5) && ~(current_state == 1))","h":12}]},{"n":"(current_state == 3)_1","i":4,"b":[{"m":"~(current_state == 1)","h":10}]},{"n":"(current_state == 5)_0","i":5,"b":[{"m":"(~(current_state == 7) && ~((current_state == 1) || (current_state == 3)))","h":12}]},{"n":"(current_state == 5)_1","i":6,"b":[{"m":"~((current_state == 1) || (current_state == 3))","h":9}]},{"n":"(current_state == 7)_0","i":7,"b":[{"m":"~(((current_state == 1) || (current_state == 3)) || (current_state == 5))","h":12}]},{"n":"(current_state == 7)_1","i":8,"b":[{"m":"~(((current_state == 1) || (current_state == 3)) || (current_state == 5))","h":5}]}],"x":0,"p":100.00},{"f":141,"l":72,"i":1,"s":"(((current_state == 2) || (current_state == 4)) || (current_state == 6))","bi":0,"hp":0,"t":[{"n":"(current_state == 2)","c":1},{"n":"(current_state == 4)","c":1},{"n":"(current_state == 6)","c":1}],"r":[{"n":"(current_state == 2)_0","i":1,"b":[{"m":"(~(current_state == 6) && ~(current_state == 4))","h":12}]},{"n":"(current_state == 2)_1","i":2,"b":[{"m":"-","h":10}]},{"n":"(current_state == 4)_0","i":3,"b":[{"m":"(~(current_state == 6) && ~(current_state == 2))","h":12}]},{"n":"(current_state == 4)_1","i":4,"b":[{"m":"~(current_state == 2)","h":9}]},{"n":"(current_state == 6)_0","i":5,"b":[{"m":"~((current_state == 2) || (current_state == 4))","h":12}]},{"n":"(current_state == 6)_1","i":6,"b":[{"m":"~((current_state == 2) || (current_state == 4))","h":5}]}],"x":0,"p":100.00},{"f":141,"l":84,"i":1,"s":"((current_state == 5) || (current_state == 7))","bi":0,"hp":0,"t":[{"n":"(current_state == 5)","c":1},{"n":"(current_state == 7)","c":1}],"r":[{"n":"(current_state == 5)_0","i":1,"b":[{"m":"~(current_state == 7)","h":12}]},{"n":"(current_state == 5)_1","i":2,"b":[{"m":"-","h":9}]},{"n":"(current_state == 7)_0","i":3,"b":[{"m":"~(current_state == 5)","h":12}]},{"n":"(current_state == 7)_1","i":4,"b":[{"m":"~(current_state == 5)","h":5}]}],"x":0,"p":100.00},{"f":141,"l":86,"i":1,"s":"(ack_counter1 == 5)","bi":0,"hp":0,"t":[{"n":"(ack_counter1 == 5)","c":1}],"r":[{"n":"(ack_counter1 == 5)_0","i":1,"b":[{"m":"-","h":9}]},{"n":"(ack_counter1 == 5)_1","i":2,"b":[{"m":"-","h":9}]}],"x":0,"p":100.00},{"f":141,"l":91,"i":1,"s":"((current_state == 4) || (current_state == 6))","bi":0,"hp":0,"t":[{"n":"(current_state == 4)","c":1},{"n":"(current_state == 6)","c":1}],"r":[{"n":"(current_state == 4)_0","i":1,"b":[{"m":"~(current_state == 6)","h":12}]},{"n":"(current_state == 4)_1","i":2,"b":[{"m":"-","h":9}]},{"n":"(current_state == 6)_0","i":3,"b":[{"m":"~(current_state == 4)","h":12}]},{"n":"(current_state == 6)_1","i":4,"b":[{"m":"~(current_state == 4)","h":5}]}],"x":0,"p":100.00},{"f":141,"l":93,"i":1,"s":"(ack_counter2 == 5)","bi":0,"hp":0,"t":[{"n":"(ack_counter2 == 5)","c":1}],"r":[{"n":"(ack_counter2 == 5)_0","i":1,"b":[{"m":"-","h":9}]},{"n":"(ack_counter2 == 5)_1","i":2,"b":[{"m":"-","h":9}]}],"x":0,"p":100.00},{"f":141,"l":119,"i":1,"s":"(counter == 0)","bi":0,"hp":0,"t":[{"n":"(counter == 0)","c":1}],"r":[{"n":"(counter == 0)_0","i":1,"b":[{"m":"-","h":10}]},{"n":"(counter == 0)_1","i":2,"b":[{"m":"-","h":10}]}],"x":0,"p":100.00},{"f":141,"l":139,"i":1,"s":"(counter == 0)","bi":0,"hp":0,"t":[{"n":"(counter == 0)","c":1}],"r":[{"n":"(counter == 0)_0","i":1,"b":[{"m":"-","h":9}]},{"n":"(counter == 0)_1","i":2,"b":[{"m":"-","h":9}]}],"x":0,"p":100.00},{"f":141,"l":166,"i":1,"s":"(counter == 0)","bi":0,"hp":0,"t":[{"n":"(counter == 0)","c":1}],"r":[{"n":"(counter == 0)_0","i":1,"b":[{"m":"-","h":5}]},{"n":"(counter == 0)_1","i":2,"b":[{"m":"-","h":5}]}],"x":0,"p":100.00},{"f":141,"l":237,"i":1,"s":"(ack_counter2 == 3)","bi":0,"hp":0,"t":[{"n":"(ack_counter2 == 3)","c":1}],"r":[{"n":"(ack_counter2 == 3)_0","i":1,"b":[{"m":"-","h":9}]},{"n":"(ack_counter2 == 3)_1","i":2,"b":[{"m":"-","h":9}]}],"x":0,"p":100.00},{"f":141,"l":249,"i":1,"s":"(ack_counter1 == 3)","bi":0,"hp":0,"t":[{"n":"(ack_counter1 == 3)","c":1}],"r":[{"n":"(ack_counter1 == 3)_0","i":1,"b":[{"m":"-","h":9}]},{"n":"(ack_counter1 == 3)_1","i":2,"b":[{"m":"-","h":9}]}],"x":0,"p":100.00},{"f":141,"l":269,"i":1,"s":"(ack_counter2 == 3)","bi":0,"hp":0,"t":[{"n":"(ack_counter2 == 3)","c":1}],"r":[{"n":"(ack_counter2 == 3)_0","i":1,"b":[{"m":"-","h":5}]},{"n":"(ack_counter2 == 3)_1","i":2,"b":[{"m":"-","h":5}]}],"x":0,"p":100.00},{"f":141,"l":283,"i":1,"s":"(ack_counter1 == 3)","bi":0,"hp":0,"t":[{"n":"(ack_counter1 == 3)","c":1}],"r":[{"n":"(ack_counter1 == 3)_0","i":1,"b":[{"m":"-","h":5}]},{"n":"(ack_counter1 == 3)_1","i":2,"b":[{"m":"-","h":5}]}],"x":0,"p":100.00}]},"9":{"pr":"work.read_pointer_empty","t":"du","ce":[{"f":139,"l":97,"i":1,"s":"(read_gray_next == read_to_write_pointer)","bi":0,"hp":0,"t":[{"n":"(read_gray_next == read_to_write_pointer)","c":1}],"r":[{"n":"(read_gray_next == read_to_write_pointer)_0","i":1,"b":[{"m":"-","h":16}]},{"n":"(read_gray_next == read_to_write_pointer)_1","i":2,"b":[{"m":"-","h":24}]}],"x":1,"p":100.00}]},"6":{"pr":"work.top_level","t":"du","ce":[{"f":138,"l":48,"i":1,"s":"(~address_reg[0]? (command_reg[7] & ~status_reg[6]): (command_reg[7] & ~status_reg[5]))","bi":1,"hp":0,"t":[{"n":"address_reg[0]","c":1},{"n":"command_reg[7]","c":1},{"n":"status_reg[6]","c":1},{"n":"status_reg[5]","c":1}],"r":[{"n":"address_reg[0]_0","i":1,"b":[{"m":"-","h":12},{"m":"-","h":11}]},{"n":"address_reg[0]_1","i":2,"b":[{"m":"-","h":1},{"m":"-","h":6}]},{"n":"command_reg[7]_0","i":3,"b":[{"m":"(~address_reg[0] && ~status_reg[6]), (address_reg[0] && ~status_reg[5])","h":4},{"m":"(~address_reg[0] && ~status_reg[6]), (address_reg[0] && ~status_reg[5])","h":0}]},{"n":"command_reg[7]_1","i":4,"b":[{"m":"(~address_reg[0] && ~status_reg[6]), (address_reg[0] && ~status_reg[5])","h":0},{"m":"(~address_reg[0] && ~status_reg[6]), (address_reg[0] && ~status_reg[5])","h":12}]},{"n":"status_reg[6]_0","i":5,"b":[{"m":"(~address_reg[0] && command_reg[7])","h":0},{"m":"(~address_reg[0] && command_reg[7])","h":11}]},{"n":"status_reg[6]_1","i":6,"b":[{"m":"(~address_reg[0] && command_reg[7])","h":12},{"m":"(~address_reg[0] && command_reg[7])","h":0}]},{"n":"status_reg[5]_0","i":7,"b":[{"m":"(address_reg[0] && command_reg[7])","h":0},{"m":"(address_reg[0] && command_reg[7])","h":6}]},{"n":"status_reg[5]_1","i":8,"b":[{"m":"(address_reg[0] && command_reg[7])","h":1},{"m":"(address_reg[0] && command_reg[7])","h":0}]}],"x":1,"p":100.00}]},"10":{"pr":"work.write_pointer_full","t":"du","ce":[{"f":139,"l":57,"i":1,"s":"(write_gray_next == {~write_to_read_pointer[3:2],write_to_read_pointer[1:0]})","bi":0,"hp":0,"t":[{"n":"(write_gray_next == {~write_to_read_pointer[3:2],write_to_read_pointer[1:0]})","c":1}],"r":[{"n":"(write_gray_next == {~write_to_read_pointer[3:2],write_to_read_pointer[1:0]})_0","i":1,"b":[{"m":"-","h":24}]},{"n":"(write_gray_next == {~write_to_read_pointer[3:2],write_to_read_pointer[1:0]})_1","i":2,"b":[{"m":"-","h":4}]}],"x":1,"p":100.00}]}};
processCondExprData(g_data);