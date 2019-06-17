--
-- VHDL Architecture my_project1_lib.RegFile_tb.Testbench
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 14:32:43 04/16/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;

ENTITY RegFile_tb IS
END ENTITY RegFile_tb;

--
ARCHITECTURE Testbench OF RegFile_tb IS
  
  FILE test_vectors : text OPEN read_mode IS "RegFile_vec.txt";
  
  SIGNAL WBDataIn : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL RFDA, RFDA_v, RFDB, RFDB_v : std_logic_vector(31 DOWNTO 0);
  SIGNAL RFAA, RFAB, DestReg : std_ulogic_vector(4 DOWNTO 0);
  SIGNAL ReadA, ReadB, Write, clk : std_ulogic;
  
  SIGNAL vecno : NATURAL := 0;
  
BEGIN
  
  DUV : ENTITY work.RegisterFile(Behavior)
    GENERIC MAP(RegWidth=>32, RegSel=>5)
    PORT MAP(WBDataIn=>WBDataIn, RFDA=>RFDA, RFDB=>RFDB, RFAA=>RFAA, 
            RFAB=>RFAB, DestReg=>DestReg, ReadA=>ReadA, ReadB=>ReadB,
            Write=>Write, clk=>clk);
            
  Stim : PROCESS
    VARIABLE L : LINE;
    VARIABLE WBDataIn_val : std_ulogic_vector(31 DOWNTO 0);
    VARIABLE RFDA_val, RFDB_val : std_ulogic_vector(31 DOWNTO 0);
    VARIABLE RFAA_val, RFAB_val, DestReg_val : std_ulogic_vector(4 DOWNTO 0);
    VARIABLE ReadA_val, ReadB_val, Write_val : std_ulogic;
  
  BEGIN
    
    Clk <= '0';
    wait for 40 ns;
    readline(test_vectors, L);
    
    WHILE NOT endfile(test_vectors) LOOP
      readline(test_vectors, L);
      read(L, WBDataIn_val);
      WBDataIn <= WBDataIn_val;
      read(L, RFAA_val);
      RFAA <= RFAA_val;
      read(L, RFAB_val);
      RFAB <= RFAB_val;
      read(L, DestReg_val);
      DestReg <= DestReg_val;
      read(L, ReadA_val);
      ReadA <= ReadA_val;
      read(L, ReadB_val);
      ReadB <= ReadB_val;
      read(L, Write_val);
      Write <= Write_val;
      
      read(L, RFDA_val);
      RFDA_v <= RFDA_val;
      read(L, RFDB_val);
      RFDB_v <= RFDB_val;
      
      
      
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
      ASSERT RFDA = RFDA_v
        REPORT "ERROR: Incorrect RFDA output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT RFDB = RFDB_v
        REPORT "ERROR: Incorrect RFDB output for vector " & to_string(vecno)
        SEVERITY WARNING;
      vecno <= vecno + 1;
    END IF;
  END PROCESS;
  
END ARCHITECTURE Testbench;

