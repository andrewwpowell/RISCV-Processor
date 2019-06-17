--
-- VHDL Architecture my_project1_lib.Mux3.Behavior
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 12:19:35 01/28/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Mux3 IS
  GENERIC(width: NATURAL RANGE 1 TO 64 := 8);
  PORT(In0, In1, In2 : IN std_ulogic_vector(width - 1 DOWNTO 0);
    Q : OUT std_ulogic_vector(width - 1 DOWNTO 0);
    Sel : IN std_ulogic_vector(1 DOWNTO 0));
END ENTITY Mux3;

--
ARCHITECTURE Behavior OF Mux3 IS
BEGIN
  PROCESS(In0, In1, In2, Sel)
    CONSTANT X : std_ulogic_vector(width - 1 DOWNTO 0) := (others => 'X');
    
  BEGIN
    IF (Sel = "00") THEN
      Q <= In0;
    ELSIF (Sel = "01") THEN
      Q <= In1;
    ELSIF (Sel = "10") THEN
      Q <= In2;
    ELSE
      Q <= X;
    END IF;
  END PROCESS;
END ARCHITECTURE Behavior;

