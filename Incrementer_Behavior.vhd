--
-- VHDL Architecture my_project1_lib.Incrementer.Behavior
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 13:02:22 01/28/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Incrementer IS
  GENERIC(width : NATURAL RANGE 1 TO 64 := 8);
  PORT( D : IN std_ulogic_vector(width - 1 DOWNTO 0);
    Q : OUT std_ulogic_vector(width - 1 DOWNTO 0);
    Inc : IN std_ulogic_vector(1 DOWNTO 0));
END ENTITY Incrementer;

--
ARCHITECTURE Behavior OF Incrementer IS
BEGIN
  PROCESS(D, Inc)
    VARIABLE Sum : UNSIGNED(width - 1 DOWNTO 0);
    CONSTANT X : std_ulogic_vector(width - 1 DOWNTO 0) := (others => 'X');
    
  BEGIN
    IF (Inc = "00") THEN
      SUM := UNSIGNED(D);
      Q <= std_ulogic_vector(SUM);
    ELSIF (Inc = "01") THEN
      SUM := UNSIGNED(D) + 1;
      Q <= std_ulogic_vector(SUM);
    ELSIF (Inc = "10") THEN
      SUM := UNSIGNED(D) + 2;
      Q <= std_ulogic_vector(SUM);
    ELSIF (Inc = "11") THEN
      SUM := UNSIGNED(D) + 4;
      Q <= std_ulogic_vector(SUM);
    ELSE
      Q <= X;
    END IF;
  END PROCESS;      
END ARCHITECTURE Behavior;

