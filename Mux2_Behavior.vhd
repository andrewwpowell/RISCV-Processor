--
-- VHDL Architecture my_project1_lib.Mux2.Behavior
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 12:31:52 01/28/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Mux2 IS
  GENERIC(width : NATURAL RANGE 1 to 64 := 8);
  PORT(In0, In1 : IN std_ulogic_vector(width - 1 DOWNTO 0);
    Q : OUT std_ulogic_vector(width - 1 DOWNTO 0);
    Sel : IN std_ulogic);
END ENTITY Mux2;

--
ARCHITECTURE Behavior OF Mux2 IS
BEGIN
  PROCESS(In0, In1, Sel)
    CONSTANT X : std_ulogic_vector(width - 1 DOWNTO 0) := (others => 'X');
    
  BEGIN
    IF(Sel = '0') THEN
      Q <= In0;
    ELSIF (Sel = '1') THEN
      Q <= In1;
    ELSE
      Q <= X;
    END IF;
  END PROCESS;  
END ARCHITECTURE Behavior;

