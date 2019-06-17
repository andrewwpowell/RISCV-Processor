--
-- VHDL Architecture my_project1_lib.MemoryArbiter_tb.Testbench
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 12:20:01 04/ 8/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;

LIBRARY work;
USE work.RV32I.ALL;

ENTITY MemoryArbiter_tb IS
END ENTITY MemoryArbiter_tb;

--
ARCHITECTURE Testbench OF MemoryArbiter_tb IS
  
  FILE test_vectors : text OPEN read_mode IS "MemoryArbiter_vec.txt";
  
  SIGNAL fetchAddress, memAddress, addressOut, addressOut_val : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL fetchRd, memRd, memWrt, mdelay, delayFetch, delayFetch_val, delayMem, delayMem_val, we, we_val, re, re_val : std_ulogic;
  
  SIGNAL vecno : NATURAL := 0;
  CONSTANT period : time := 50 ns;
  
BEGIN
  
  DUV : ENTITY work.MemoryArbiter(Behavior)
    PORT MAP(fetchAddress=>fetchAddress, memAddress=>memAddress, fetchRd=>fetchRd, memRd=>memRd, memWrt=>memWrt, mdelay=>mdelay, delayFetch=>delayFetch, delayMem=>delayMem, addressOut=>addressOut, writeEnable=>we, readEnable=>re);
      
  Stim : PROCESS
  
    VARIABLE L : LINE;
    
    VARIABLE fetchAddress_v, memAddress_v, addressOut_v : std_ulogic_vector(31 DOWNTO 0);
    VARIABLE fetchRd_v, memRd_v, memWrt_v, mdelay_v, delayFetch_v, delayMem_v, we_v, re_v : std_ulogic;
    
  BEGIN
    
    readline(test_vectors, L);
    --wait for period;
    
    WHILE NOT endfile(test_vectors) LOOP
      readline(test_vectors, L);
      
      read(L, fetchAddress_v);
      fetchAddress <= fetchAddress_v;
      read(L, memAddress_v);
      memAddress <= memAddress_v;
      read(L, fetchRd_v);
      fetchRd <= fetchRd_v;
      read(L, memRd_v);
      memRd <= memRd_v;
      read(L, memWrt_v);
      memWrt <= memWrt_v;
      read(L, mdelay_v);
      mdelay <= mdelay_v;
      
      read(L, delayFetch_v);
      delayFetch_val <= delayFetch_v;
      read(L, delayMem_v);
      delayMem_val <= delayMem_v;
      read(L, we_v);
      we_val <= we_v;
      read(L, re_v);
      re_val <= re_v;
      read(L, addressOut_v);
      addressOut_val <= addressOut_v;
      
      wait for period;
    END LOOP;
      
    report "End of Testbench.";
    std.env.finish;
  END PROCESS;
  
  Check : PROCESS
  BEGIN
    wait for period;
    ASSERT delayFetch = delayFetch_val
      REPORT "ERROR: Incorrect Fetch Delay output for vector " & to_string(vecno)
      SEVERITY WARNING;
    ASSERT delayMem = delayMem_val
      REPORT "ERROR: Incorrect Destination Register output for vector " & to_string(vecno)
      SEVERITY WARNING;
    ASSERT addressOut = addressOut_val
      REPORT "ERROR: Incorrect Address output for vector" & to_string(vecno)
      SEVERITY WARNING;
    ASSERT re = re_val
      REPORT "ERROR: Incorrect Read Enable output for vector" & to_string(vecno)
      SEVERITY WARNING;
    ASSERT we = we_val
      REPORT "ERROR: Incorrect Write Enable output for vector" & to_string(vecno)
      SEVERITY WARNING;
  END PROCESS;
END ARCHITECTURE Testbench;

