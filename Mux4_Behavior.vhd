--
-- VHDL Architecture my_project1_lib.Mux4.Behavior
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 13:00:13 01/28/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Mux4 IS
  GENERIC(width: NATURAL RANGE 1 TO 64 := 8);
  PORT(In0, In1, In2, In3 : IN std_ulogic_vector(width - 1 DOWNTO 0);
    Q : OUT std_ulogic_vector(width - 1 DOWNTO 0);
    Sel : IN std_ulogic_vector(1 DOWNTO 0));
END ENTITY Mux4;

--
ARCHITECTURE Behavior OF Mux4 IS
BEGIN
  PROCESS(In0, In1, In2, In3, Sel)
    CONSTANT X : std_ulogic_vector(width - 1 DOWNTO 0) := (others => 'X');
    
  BEGIN
    IF (Sel = "00") THEN
      Q <= In0;
    ELSIF (Sel = "01") THEN
      Q <= In1;
    ELSIF (Sel = "10") THEN
      Q <= In2;
    ELSIF (Sel = "11") THEN
      Q <= In3;
    ELSE
      Q <= X;
    END IF;
  END PROCESS;
END ARCHITECTURE Behavior;