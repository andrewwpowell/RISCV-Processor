--
-- VHDL Architecture my_project1_lib.Multiplexer.Behavior
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 12:25:15 01/23/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY Multiplexer IS
  PORT ( Data_In_0, Data_In_1 : IN std_ulogic_vector(3 DOWNTO 0);
        Data_Out : OUT std_ulogic_vector(3 DOWNTO 0);
        control : IN std_ulogic);
END ENTITY Multiplexer;

ARCHITECTURE Behavior OF Multiplexer IS
BEGIN
  PROCESS(Data_In_0, Data_In_1, control)
  BEGIN
    IF (control = '0') THEN
      Data_Out <= Data_In_0;
    ELSIF (control = '1') THEN
      Data_Out <= Data_In_1;
    ELSE
      Data_Out <= "XXXX";
    END IF;
  END PROCESS;
END ARCHITECTURE Behavior;

