--
-- VHDL Architecture my_project1_lib.MemoryArbiter.Behavior
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 16:41:57 04/ 7/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.RV32I.ALL; 

ENTITY MemoryArbiter IS
  PORT( fetchAddress, memAddress : IN std_ulogic_vector(31 DOWNTO 0);
    fetchRd, memRd, memWrt, mdelay : IN std_ulogic;
    delayFetch, delayMem, writeEnable, readEnable : OUT std_ulogic;
    addressOut : OUT std_ulogic_vector(31 DOWNTO 0));
END ENTITY MemoryArbiter;

--
ARCHITECTURE Behavior OF MemoryArbiter IS
  
  CONSTANT X : std_ulogic_vector(31 DOWNTO 0) := (others=>'X');
  
BEGIN
      
  PROCESS(fetchAddress, memAddress, mdelay, fetchRd, memRd, memWrt)
  
  BEGIN
 
    IF(memRd  = '1' OR memWrt = '1') THEN
      delayFetch <= '1';
      delayMem <= mdelay;
      addressOut <= memAddress;
      writeEnable <= memWrt;
      readEnable <= memRd;
    ELSE
      delayFetch <= mdelay;
      delayMem <= '0';
      addressOut <= fetchAddress;
      writeEnable <= '0';
      readEnable <= fetchRd;
    END IF;
  END PROCESS;
    
END ARCHITECTURE Behavior;

