--
-- VHDL Architecture my_project1_lib.RegReadWrite.Mixed
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 23:21:40 04/11/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.RV32I.ALL; 

ENTITY RegReadWrite IS
  GENERIC (size : NATURAL RANGE 2 TO 64 := 4);
  PORT (D : IN std_ulogic_vector(size-1 DOWNTO 0);
    QA, QB : OUT std_logic_vector(size-1 DOWNTO 0);
    Clk, LE, OE1, OE2 : IN std_ulogic);
END ENTITY RegReadWrite;

--
ARCHITECTURE Mixed OF RegReadWrite IS
  SIGNAL Qval : std_logic_vector(size-1 DOWNTO 0) := (others=>'0');
  CONSTANT HiZ : std_logic_vector(size-1 DOWNTO 0) := (others=>'Z');
  
BEGIN
  store : ENTITY work.Reg(Behavior)
    GENERIC MAP(width=>size)
    PORT MAP(D=>D, Q=>Qval, Clk=>Clk, enable=>LE, rst=>'0');
      
  QA <= Qval WHEN OE1 = '1' ELSE HiZ;
  QB <= Qval WHEN OE2 = '1' ELSE HiZ;
    
END ARCHITECTURE Mixed;

