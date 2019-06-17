--
-- VHDL Architecture my_project1_lib.Fetch.Behavior
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 12:01:10 02/ 4/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Fetch IS
  PORT( Jaddr, Mdata : IN std_ulogic_vector(31 DOWNTO 0);
    Address, Inst : OUT std_ulogic_vector(31 DOWNTO 0);
    Clock, Jmp, Reset, Delay : IN std_ulogic;
    Read : OUT std_ulogic);
END ENTITY Fetch;

--
ARCHITECTURE Behavior OF Fetch IS
BEGIN
  PROCESS(Jaddr, Mdata, Clock, Jmp, Reset, Delay)
    CONSTANT zero : std_ulogic_vector(31 DOWNTO 0) := (others => '0');
    CONSTANT NOP : std_ulogic_vector(31 DOWNTO 0) := "00000000000000000000000000010011";
    VARIABLE PCin : std_ulogic_vector(31 DOWNTO 0);

  BEGIN
      
    IF(Jmp = '1' OR Reset = '1' OR Delay = '1') THEN
      Inst <= NOP;
    ELSE
      Inst <= Mdata;
    END IF;
      
    Read <= NOT(Jmp AND Delay);
    
    IF(rising_edge(Clock)) THEN 
      
      IF(Delay = '0' AND Reset = '0') THEN
        PCin := std_ulogic_vector(UNSIGNED(PCin) + 4);
      END IF;           
      
      IF(Jmp = '1') THEN
        PCin := Jaddr;
      END IF;
      
      IF(Reset = '1') THEN
        PCin := zero;
      END IF;                                             
      
    END IF;
      
    Address <= PCin;
    
  END PROCESS;    
END ARCHITECTURE Behavior;

