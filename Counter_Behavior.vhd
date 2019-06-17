--
-- VHDL Architecture my_project1_lib.Counter.Behavior
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 13:31:41 01/28/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Counter IS
  GENERIC(width : NATURAL RANGE 1 TO 64 := 8);
  PORT(D : IN std_ulogic_vector(width - 1 DOWNTO 0);
    Q : OUT std_ulogic_vector(width - 1 DOWNTO 0);
    clk, enable, rst : IN std_ulogic);
END ENTITY Counter;

--
ARCHITECTURE Behavior OF Counter IS
  SIGNAL IncOut, MuxOut, RegOut : std_ulogic_vector(width - 1 DOWNTO 0);
  CONSTANT unknown : std_ulogic_vector(width - 1 DOWNTO 0) := (others => 'X');
  
BEGIN
  CountRegister : ENTITY work.Reg(Behavior)
    GENERIC MAP(width=>width)
    PORT MAP(D=>MuxOut,enable=>(enable OR rst),rst=>'0',clk=>clk,Q=>RegOut);
  
  CountIncrementer : ENTITY work.Incrementer(Behavior)
    GENERIC MAP(width=>width)
    PORT MAP(D=>RegOut,Inc=>"11",Q=>IncOut);
  
  ResMux : ENTITY work.Mux2(Behavior)
    GENERIC MAP(width=>width)
    PORT MAP(In0=>IncOut, In1=>D, Sel=>rst,Q=>MuxOut);
  
  Q<=RegOut;
  
END ARCHITECTURE Behavior;

