--
-- VHDL Architecture my_project1_lib.ExecuteStage_tb.Testbench
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 13:16:08 04/ 1/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;

LIBRARY work;
USE work.RV32I.ALL;

ENTITY ExecuteStage_tb IS
END ENTITY ExecuteStage_tb;

--
ARCHITECTURE Testbench OF ExecuteStage_tb IS
  
  FILE test_vectors : text OPEN read_mode IS "ExecuteStage_vec.txt";
  
  SIGNAL Left, Right, Extra, Address, Address_val, Data, Data_val, Jaddr, Jaddr_val : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL Dest_reg_in : std_ulogic_vector(4 DOWNTO 0);
  SIGNAL Funct_in : RV32I_Op;
  SIGNAL Jump, Clk, Rd, Jump_val : std_ulogic;
  
  SIGNAL vecno : NATURAL := 0;
  
BEGIN
  
  DUV : ENTITY work.ExecuteStage(Behavior)
    PORT MAP(Left=>Left, Right=>Right, Extra=>Extra, 
          Dest_reg_in=>Dest_reg_in, Funct_in=>Funct_in, Clk=>Clk,
          Address=>Address, AddressIn=>"00000000000000000000000000000000", Data=>Data, Jaddr=>Jaddr, Jump=>Jump, stall=>'0');
  
      
  Stim : PROCESS
    VARIABLE L : LINE;

    VARIABLE Left_v, Right_v, Extra_v, Address_v, Data_v, Jaddr_v : std_ulogic_vector(31 DOWNTO 0);
    VARIABLE Funct_in_v : STRING(5 DOWNTO 1);
    VARIABLE Jump_v, Rd_v : std_ulogic;
  
  BEGIN
    Clk <= '0';
    wait for 50 ns;
    readline(test_vectors, L);
    
    -- Func -> Left -> Right -> Extra -> PC -> Rd -> 
    -- Address -> Data -> Jump -> Jaddr
    WHILE NOT endfile(test_vectors) LOOP
      readline(test_vectors, L);
      
      read(L, Funct_in_v);
      Funct_in <= Ftype(Funct_in_v);
      read(L, Left_v);
      Left <= Left_v;
      read(L, Right_v);
      Right <= Right_v;
      read(L, Extra_v);
      Extra <= Extra_v;
      
      read(L, Address_v);
      Address_val <= Address_v;
      read(L, Data_v);
      Data_val <= Data_v;
      read(L, Jump_v);
      Jump_val <= Jump_v;
      read(L, Jaddr_v);
      Jaddr_val <= Jaddr_v;
      
      Clk <= '1';
      wait for 50 ns;
      Clk <= '0';
      wait for 50 ns;
      
      END LOOP;
      
      report "End of Testbench.";
      std.env.finish;
  END PROCESS;
    
  Check : PROCESS(Clk)
  BEGIN
    IF(falling_edge(Clk)) THEN
      ASSERT Address = Address_val
        REPORT "ERROR: Incorrect Address output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT Data = Data_val
        REPORT "ERROR: Incorrect Data output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT Jump = Jump_val
        REPORT "ERROR: Incorrect Jump output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT Jaddr = Jaddr_val
        REPORT "ERROR: Incorrect Jaddr output for vector " & to_string(vecno)
        SEVERITY WARNING;
      vecno <= vecno + 1;
    END IF;
  END PROCESS;  
    
END ARCHITECTURE Testbench;

