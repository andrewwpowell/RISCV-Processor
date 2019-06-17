--
-- VHDL Architecture my_project1_lib.Reg.Behavior
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 13:12:02 01/28/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.RV32I.ALL; 

ENTITY RV32IReg IS
  PORT(D : IN RV32I_Op;
    Q : OUT RV32I_Op;
    clk, enable, rst : IN std_ulogic);
END ENTITY RV32IReg;

--
ARCHITECTURE Behavior OF RV32IReg IS
BEGIN
  PROCESS(D, clk, enable, rst)
    
  BEGIN
    IF(rising_edge(clk) AND enable = '1') THEN
      Q <= D;
    END IF;
    IF(rst = '1') THEN
      Q <= NOP;
    END IF;
  END PROCESS;
END ARCHITECTURE Behavior;