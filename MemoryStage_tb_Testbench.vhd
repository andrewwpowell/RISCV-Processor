--
-- VHDL Architecture my_project1_lib.MemoryStage_tb.Testbench
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 11:14:44 04/ 8/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;

LIBRARY work;
USE work.RV32I.ALL;

ENTITY MemoryStage_tb IS
END ENTITY MemoryStage_tb;

--
ARCHITECTURE Testbench OF MemoryStage_tb IS
  
  FILE test_vectors : text OPEN read_mode IS "MemoryStage_vec.txt";
  
  SIGNAL address, data, dataIn, addressOut, dataOut, dataWriteBack, addressOut_val, dataOut_val, dataWriteBack_val : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL funct : RV32I_Op;
  SIGNAL mdelay, clk : std_ulogic;
  SIGNAL rd, rd_val, wrt, wrt_val, stall, stall_val : std_ulogic;
  SIGNAL dataSize, dataSize_val : std_ulogic_vector(1 DOWNTO 0);
  
  SIGNAL vecno : NATURAL := 0;
  
BEGIN
  
  DUV : ENTITY work.MemoryStage(Behavior)
    PORT MAP(Address=>address, Data=>data, DataIn=>dataIn, Mdelay=>mdelay, Funct=>funct, clk=>clk, Dest_reg=>"00000", AddressOut=>addressOut, DataOut=>dataOut, DataWriteBack=>dataWriteBack, Rd=>rd, Wrt=>wrt, Stall=>stall, DataSize=>dataSize);
      
  Stim : PROCESS
    VARIABLE L : LINE;
    
    VARIABLE address_v, data_v, dataIn_v, addressOut_v, dataOut_v, dataWriteBack_v : std_ulogic_vector(31 DOWNTO 0);
    VARIABLE funct_v : STRING(5 DOWNTO 1);
    VARIABLE rd_v, wrt_v, stall_v, mdelay_v : std_ulogic;
    VARIABLE dataSize_v : std_ulogic_vector(1 DOWNTO 0);
    
  BEGIN
    clk <= '0';
    wait for 40 ns;
    readline(test_vectors, L);
    
    WHILE NOT endfile(test_vectors) LOOP
      readline(test_vectors, L);
      
      read(L, funct_v);
      funct <= Ftype(funct_v);
      read(L, address_v);
      address <= address_v;
      read(L, data_v);
      data <= data_v;
      read(L, dataIn_v);
      dataIn <= dataIn_v;
      read(L, mdelay_v);
      mdelay <= mdelay_v;
      
      read(L, addressOut_v);
      addressOut_val <= addressOut_v;
      read(L, dataOut_v);
      dataOut_val <= dataOut_v;
      read(L, rd_v);
      rd_val <= rd_v;
      read(L, wrt_v);
      wrt_val <= wrt_v;
      read(L, dataWriteBack_v);
      dataWriteBack_val <= dataWriteBack_v;
      read(L, stall_v);
      stall_val <= stall_v;
      read(L, dataSize_v);
      dataSize_val <= dataSize_v;
      
      wait for 10 ns;
      clk <= '1';
      wait for 50 ns;
      clk <= '0';
      wait for 40 ns;
      
      END LOOP;
      
      report "End of Testbench.";
      std.env.finish;
  END PROCESS;
  
  Check : PROCESS(clk)
  BEGIN
    IF(falling_edge(clk)) THEN
      ASSERT addressOut = addressOut_val
        REPORT "ERROR: Incorrect Address output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT dataOut = dataOut_val
        REPORT "ERROR: Incorrect Data output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT rd = rd_val
        REPORT "ERROR: Incorrect Read output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT wrt = wrt_val
        REPORT "ERROR: Incorrect Write output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT dataWriteBack = dataWriteBack_val
        REPORT "ERROR: Incorrect WriteBack Data output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT stall = stall_val
        REPORT "ERROR: Incorrect Stall output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT dataSize = dataSize_val
        REPORT "ERROR: Incorrect Data Size output for vector " & to_string(vecno)
        SEVERITY WARNING;
      vecno <= vecno + 1;
    END IF;
  END PROCESS; 
    
END ARCHITECTURE Testbench;

