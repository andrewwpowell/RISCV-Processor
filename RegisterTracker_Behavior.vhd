--
-- VHDL Architecture my_project1_lib.RegisterTracker.Behavior
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 21:10:41 04/11/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.RV32I.ALL; 

ENTITY RegisterTracker IS
  GENERIC(RegWidth : NATURAL RANGE 2 to 32 := 32;
              RegSel : NATURAL RANGE 2 to 5 := 5);
  PORT(RFRAA, RFRAB, RFWA_dec, RFWA_wb : IN std_ulogic_vector(RegSel-1 DOWNTO 0);
    ReadA, ReadB, Reserve, Free, clk : IN std_ulogic;
    ReserveVector : OUT std_ulogic_vector(RegWidth-1 DOWNTO 0);
    Stall : OUT std_ulogic);
END ENTITY RegisterTracker;

--
ARCHITECTURE Behavior OF RegisterTracker IS
  SIGNAL RegisterReserve : std_ulogic_vector(RegWidth-1 DOWNTO 0) := (others=>'0');
  
BEGIN

  PROCESS(clk, ReadA, ReadB, Reserve, Free, RFWA_dec, RFWA_wb, RegisterReserve)
  
  VARIABLE stallVar : std_ulogic := '0';
  BEGIN
    
    stallVar := '0';
    
    IF(Reserve = '1' AND RegisterReserve(to_integer(unsigned(RFWA_dec))) = '1') THEN
      stallVar := '1';
    ELSIF(ReadA = '1' AND RegisterReserve(to_integer(unsigned(RFRAA))) = '1') THEN
      stallVar := '1';
    ELSIF(ReadB = '1' AND RegisterReserve(to_integer(unsigned(RFRAB))) = '1') THEN
      stallVar := '1';
    END IF;
    
    IF(rising_edge(clk)) THEN
      IF(Reserve = '1' AND RegisterReserve(to_integer(unsigned(RFWA_dec))) = '0' AND stallVar = '0') THEN
        RegisterReserve(to_integer(unsigned(RFWA_dec))) <= '1';
      ELSIF(Free = '1' AND RegisterReserve(to_integer(unsigned(RFWA_wb))) = '1') THEN
        RegisterReserve(to_integer(unsigned(RFWA_wb))) <= '0';
      END IF;
    END IF;
    
    
    Stall <= stallVar;
    ReserveVector <= RegisterReserve;
  END PROCESS;
END ARCHITECTURE Behavior;

