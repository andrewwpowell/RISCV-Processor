--
-- VHDL Architecture my_project1_lib.Fetch.Structure
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 22:00:20 02/ 5/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Fetch2 IS
  PORT( Jaddr, Mdata : IN std_ulogic_vector(31 DOWNTO 0);
    Address, Inst : OUT std_ulogic_vector(31 DOWNTO 0);
    Clock, Jmp, Reset, Delay : IN std_ulogic;
    Read : OUT std_ulogic);
END ENTITY Fetch2;

--
ARCHITECTURE Behavior OF Fetch2 IS
  SIGNAL JMuxOut, DMuxOut, CountOut : std_ulogic_vector(31 DOWNTO 0);
  CONSTANT zero : std_ulogic_vector(31 DOWNTO 0) := (others => '0');
  CONSTANT NOP : std_ulogic_vector(31 DOWNTO 0) := "00000000000000000000000000010011";
  
BEGIN
  ProgramCounter : ENTITY work.Counter(Behavior)
    GENERIC MAP(width=>32)
    PORT MAP(D=>JMuxOut,clk=>Clock,enable=>(NOT(Jmp OR Delay)),rst=>(Jmp OR Reset),Q=>CountOut);
      
  JumpMux : ENTITY work.Mux2(Behavior)
    GENERIC MAP(width=>32)
    PORT MAP(In0=>Jaddr,In1=>zero,Sel=>Reset,Q=>JMuxOut);
      
  InstMux : ENTITY work.Mux2(Behavior)
    GENERIC MAP(width=>32)
    PORT MAP(In0=>Mdata,In1=>NOP,Sel=>(Jmp OR Reset OR Delay),Q=>DMuxOut);
      
  Address <= CountOut;
  Inst <= DMuxOut;
  Read <= NOT Jmp;
  
END ARCHITECTURE Behavior;

