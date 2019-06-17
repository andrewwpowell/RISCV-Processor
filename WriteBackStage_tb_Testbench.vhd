--
-- VHDL Architecture my_project1_lib.WriteBackStage_tb.Testbench
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 12:00:28 04/ 8/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;

LIBRARY work;
USE work.RV32I.ALL;

ENTITY WriteBackStage_tb IS
END ENTITY WriteBackStage_tb;

--
ARCHITECTURE Testbench OF WriteBackStage_tb IS
  
  FILE test_vectors : text OPEN read_mode IS "WriteBackStage_vec.txt";
  
  SIGNAL dataIn, dataOut, dataOut_val : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL destRegIn, destRegOut, destRegOut_val : std_ulogic_vector(4 DOWNTO 0);
  SIGNAL write, write_val : std_ulogic;
  SIGNAL clock : std_ulogic;
  SIGNAL funct : RV32I_Op;
  
  SIGNAL vecno : NATURAL := 0;
  --CONSTANT period : time := 50 ns;
  
BEGIN
  
  DUV : ENTITY work.WriteBackStage(Behavior)
    PORT MAP(DataIn=>dataIn, DataOut=>dataOut, Dest_reg_in=>destRegIn, Dest_reg_out=>destRegOut, write=>write, Funct=>funct, clk=>clock);
     
  
  Stim : PROCESS
  
    VARIABLE L : LINE;
    
    VARIABLE dataIn_v, dataOut_v : std_ulogic_vector(31 DOWNTO 0);
    VARIABLE destRegIn_v, destRegOut_v : std_ulogic_vector(4 DOWNTO 0);
    VARIABLE write_v : std_ulogic;
    VARIABLE funct_v : STRING(5 DOWNTO 1);
    
  BEGIN
    clock <= '0';
    wait for 40 ns;
    readline(test_vectors, L);
    
    WHILE NOT endfile(test_vectors) LOOP
      readline(test_vectors, L);
      
      read(L, funct_v);
      funct <= Ftype(funct_v);
      read(L, dataIn_v);
      dataIn <= dataIn_v;
      read(L, destRegIn_v);
      destRegIn <= destRegIn_v;
      
      read(L, dataOut_v);
      dataOut_val <= dataOut_v;
      read(L, destRegOut_v);
      destRegOut_val <= destRegOut_v;
      read(L, write_v);
      write_val <= write_v;
      
      wait for 10 ns;
      clock <= '1';
      wait for 50 ns;
      clock <= '0';
      wait for 40 ns;
    END LOOP;
      
    report "End of Testbench.";
    std.env.finish;
  END PROCESS;
  
  Check : PROCESS(clock)
  BEGIN
    IF(falling_edge(clock)) THEN
      --wait for period;
      ASSERT dataOut = dataOut_val
        REPORT "ERROR: Incorrect Data output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT destRegOut = destRegOut_val
        REPORT "ERROR: Incorrect Destination Register output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT write = write_val
        REPORT "ERROR: Incorrect Write output for vector" & to_string(vecno)
        SEVERITY WARNING;
      vecno <= vecno + 1;
    END IF;    
  END PROCESS;  
  
END ARCHITECTURE Testbench;

