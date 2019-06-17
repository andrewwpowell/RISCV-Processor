--
-- VHDL Architecture my_project1_lib.RegisterTracker_tb.Testbench
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 14:33:06 04/16/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;

LIBRARY my_project1_lib;
USE my_project1_lib.RV32I.ALL;

ENTITY RegisterTracker_tb IS
END ENTITY RegisterTracker_tb;

--
ARCHITECTURE Testbench OF RegisterTracker_tb IS
  
  FILE test_vectors : text OPEN read_mode IS "RegTrack_vec.txt";
  
  SIGNAL RFRAA, RFRAB, RFWA_dec, RFWA_wb : std_ulogic_vector(4 DOWNTO 0);
  SIGNAL ReadA, ReadB, Reserve, Free, clk, Stall, Stall_v : std_ulogic;
  SIGNAL ReserveVector, ReserveVector_v : std_ulogic_vector(31 DOWNTO 0);
  
  SIGNAL vecno : NATURAL := 0;
  
BEGIN
  
  DUV : ENTITY work.RegisterTracker(Behavior)
    GENERIC MAP(RegWidth=>32, RegSel=>5)
    PORT MAP(RFRAA=>RFRAA, RFRAB=>RFRAB, RFWA_dec=>RFWA_dec, RFWA_wb=>RFWA_wb, ReadA=>ReadA, ReadB=>ReadB, 
            Reserve=>Reserve, Free=>Free, clk=>clk, Stall=>Stall, ReserveVector=>ReserveVector);
            
  Stim : PROCESS
    VARIABLE L : LINE;
    VARIABLE RFRAA_val, RFRAB_val, RFWA_dec_val, RFWA_wb_val : std_ulogic_vector(4 DOWNTO 0);
    VARIABLE ReadA_val, ReadB_val, Reserve_val, Free_val, Stall_val : std_ulogic;
    VARIABLE ReserveVector_val : std_ulogic_vector(31 DOWNTO 0);
    
  BEGIN
    
    Clk <= '0';
    wait for 40 ns;
    readline(test_vectors, L);
    
    WHILE NOT endfile(test_vectors) LOOP
      readline(test_vectors, L);
      read(L, RFRAA_val);
      RFRAA <= RFRAA_val;
      read(L, RFRAB_val);
      RFRAB <= RFRAB_val;
      read(L, RFWA_dec_val);
      RFWA_dec <= RFWA_dec_val;
      read(L, RFWA_wb_val);
      RFWA_wb <= RFWA_wb_val;
      read(L, ReadA_val);
      ReadA <= ReadA_val;
      read(L, ReadB_val);
      ReadB <= ReadB_val;
      read(L, Reserve_val);
      Reserve <= Reserve_val;
      read(L, Free_val);
      Free <= Free_val;
      
      read(L, Stall_val);
      Stall_v <= Stall_val;
      read(L, ReserveVector_val);
      ReserveVector_v <= ReserveVector_val;
      
      
      
      wait for 10 ns;
      Clk <= '1';
      wait for 50 ns;
      Clk <= '0';
      wait for 40 ns;
      END LOOP;
    
      report "End of Testbench.";
      std.env.finish;
  END PROCESS;
  
  Check : PROCESS(Clk)
  BEGIN
    IF(falling_edge(Clk)) THEN
      ASSERT Stall = Stall_v
        REPORT "ERROR: Incorrect Stall output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT ReserveVector = ReserveVector_v
        REPORT "ERROR: Incorrect ReserveVector output for vector " & to_string(vecno)
        SEVERITY WARNING;
      vecno <= vecno + 1;
    END IF;
  END PROCESS;
END ARCHITECTURE Testbench;

