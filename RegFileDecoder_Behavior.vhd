--
-- VHDL Architecture my_project1_lib.RegFileDecoder.Behavior
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 21:08:05 04/11/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.RV32I.ALL; 

ENTITY RegFileDecoder IS
  GENERIC(InBits : NATURAL RANGE 2 TO 6 := 2);
  PORT(sel : IN std_ulogic_vector(InBits-1 DOWNTO 0);
    OneHot : OUT std_logic_vector((2**InBits-1) DOWNTO 0);
    enable : IN std_ulogic);
END ENTITY RegFileDecoder;

--
ARCHITECTURE Behavior OF RegFileDecoder IS
BEGIN
  PROCESS(sel, enable)
    VARIABLE selection : NATURAL RANGE 0 TO 53;
    VARIABLE result : std_ulogic_vector((2**InBits-1) DOWNTO 0);
    CONSTANT zero : std_logic_vector((2**InBits-1) DOWNTO 0) := (others=>'0');
    
  BEGIN
    result := zero;
    IF(enable = '1') THEN
      selection := to_integer(unsigned(sel));
      result(selection) := '1';
    END IF;
    OneHot <= result;
  END PROCESS;
END ARCHITECTURE Behavior;

