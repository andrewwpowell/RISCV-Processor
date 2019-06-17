--
-- VHDL Architecture my_project1_lib.ProcessorSystem.Mixed
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 13:03:44 04/29/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.RV32I.ALL; 

ENTITY ProcessorSystem IS
  PORT(reset, clock : IN std_ulogic);
END ENTITY ProcessorSystem;

--
ARCHITECTURE Mixed OF ProcessorSystem IS
  
  SIGNAL delay, write, read : std_ulogic;
  SIGNAL address : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL data_out, data_in : std_ulogic_vector(31 DOWNTO 0);
  
BEGIN
  
  Processor : ENTITY work.Processor(Structure)
    PORT MAP(clock=>clock, reset=>reset, MemSysDelay=>delay, MemSysAddr=>address, MemSysDataOut=>data_out, MemSysWrite=>write, MemSysRead=>read, MemSysDataIn=>data_in);
      
  System : ENTITY work.MemorySystem(Behavior)
    PORT MAP(Addr=>address, DataIn=>data_out, clock=>clock, we=>write, re=>read, mdelay=>delay, DataOut=>data_in);
      
END ARCHITECTURE Mixed;

