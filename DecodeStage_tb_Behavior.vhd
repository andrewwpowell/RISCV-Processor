--
-- VHDL Architecture my_project1_lib.Decoder_tb.Testbench
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 20:32:45 02/25/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;

LIBRARY work;
USE work.RV32I.ALL;

ENTITY DecodeStage_tb IS
END ENTITY DecodeStage_tb;

--
ARCHITECTURE Testbench OF DecodeStage_tb IS
  
  FILE test_vectors : text OPEN read_mode IS "DecodeStage_vec.txt";
  
  SIGNAL Address, Inst, RFDA, RFDB, Left, Left_val, Right, Right_val, Extra, Extra_val : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL Func, Func_val : RV32I_Op;
  SIGNAL Rd, Clk : std_ulogic;
  SIGNAL RFAA, RFAA_val, RFAB, RFAB_val, Dest_reg, Dest_reg_val : std_ulogic_vector(4 DOWNTO 0);
  
  SIGNAL vecno : NATURAL := 0;
  
BEGIN
  
  DUV : ENTITY work.DecodeStage(Behavior)
    PORT MAP(Address=>Address, Inst=>Inst, RFDA=>RFDA, RFDB=>RFDB, Left=>Left, 
              Right=>Right, Extra=>Extra, Funct=>Func, Read=>Rd, 
              RFAA=>RFAA, RFAB=>RFAB, Dest_reg=>Dest_reg, Clk=>Clk);
      
  Stim : PROCESS
    VARIABLE L : LINE;
    VARIABLE Address_v, Inst_v, RFDA_v, RFDB_v, Left_v, Right_v, Extra_v : std_ulogic_vector(31 DOWNTO 0);
    VARIABLE Func_v : string(5 DOWNTO 1);
    VARIABLE RFAA_v, RFAB_v, Dest_reg_v : std_ulogic_vector(4 DOWNTO 0);
    VARIABLE Read_v : std_ulogic;
  
  BEGIN
    Clk <= '0';
    wait for 40 ns;
    readline(test_vectors, L);
    
    -- Inputs: Address, Inst, Read, Clk, RFDA, RFDB
    -- Outputs: Dest_reg, Left, Right, Extra, Funct, RFAA, RFAB
    -- Func -> Inst -> Address -> Read -> RFAA -> RFAB -> 
    -- RFDA -> RFDB -> Left -> Right -> Extra -> Dest_reg
    WHILE NOT endfile(test_vectors) LOOP
      readline(test_vectors, L);
      
      read(L, Func_v);
      Func_val <= Ftype(Func_v);
      
      read(L, Inst_v);
      Inst <= Inst_v;
      read(L, Address_v);
      Address <= Address_v;
      read(L, Read_v);
      Rd <= Read_v;
      
      read(L, RFAA_v);
      RFAA_val <= RFAA_v;
      read(L, RFAB_v);
      RFAB_val <= RFAB_v;
      
      read(L, RFDA_v);
      RFDA <= RFDA_v;
      read(L, RFDB_v);
      RFDB <= RFDB_v;
      
      read(L, Left_v);
      Left_val <= Left_v;
      read(L, Right_v);
      Right_val <= Right_v;
      read(L, Extra_v);
      Extra_val <= Extra_v;
      read(L, Dest_reg_v);
      Dest_reg_val <= Dest_reg_v;
      
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
      ASSERT Func = Func_val
        REPORT "ERROR: Incorrect Function output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT RFAA = RFAA_val
        REPORT "ERROR: Incorrect RFAA output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT RFAB = RFAB_val
        REPORT "ERROR: Incorrect RFAB output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT Left = Left_val
        REPORT "ERROR: Incorrect Left output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT Right = Right_val
        REPORT "ERROR: Incorrect Right output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT Extra = Extra_val
        REPORT "ERROR: Incorrect Extra output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT Dest_reg = Dest_reg_val
        REPORT "ERROR: Incorrect Dest_reg output for vector " & to_string(vecno)
        SEVERITY WARNING;
      vecno <= vecno + 1;
    END IF;
  END PROCESS;  
    
END ARCHITECTURE Testbench;

