--
-- VHDL Architecture my_project1_lib.ALU_tb.Testbench
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 13:23:29 03/18/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;

LIBRARY work;
USE work.RV32I.ALL; 

ENTITY ALU_tb IS
END ENTITY ALU_tb;

--
ARCHITECTURE Testbench OF ALU_tb IS
  
  FILE test_vectors : text OPEN read_mode IS "ALU_vec.txt";
  
  SIGNAL Left, Right, Output, Output_val : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL Status, Status_val : std_ulogic;
  SIGNAL Operation : ALU_Op;
  
  SIGNAL vecno : NATURAL := 0;
  CONSTANT period : time := 50 ns;
  
BEGIN
  
  DUV : ENTITY work.ALU(Behavior)
    PORT MAP(Left=>Left, Right=>Right, Output=>Output, Status=>Status, Operation=>Operation);
    
  Stim : PROCESS
    VARIABLE L : LINE;
    VARIABLE Left_v, Right_v, Output_v : std_ulogic_vector(31 DOWNTO 0);
    VARIABLE Status_v : std_ulogic;
    VARIABLE Operation_v : string(4 DOWNTO 1);
    
  BEGIN
    readline(test_vectors, L);
    
    WHILE NOT endfile(test_vectors) LOOP
      readline(test_vectors, L);
      read(L, Operation_v);
      Operation <= ALUtype(Operation_v);
      read(L, Left_v);
      Left <= Left_v;
      read(L, Right_v);
      Right <= Right_v;
      
      read(L, Output_v);
      Output_val <= Output_v;
      read(L, Status_v);
      Status_val <= Status_v;
    
      wait for period;
    END LOOP;
    
    report "End of testbench.";
    std.env.finish;
  END PROCESS;
  
  Check : PROCESS
  BEGIN
    wait for period;
    ASSERT Output = Output_val
      REPORT "ERROR: Incorrect Output for vector " & to_string(vecno)
      SEVERITY WARNING;
    ASSERT Status = Status_val
      REPORT "ERROR: Incorrect Status output for vector " & to_string(vecno)
      SEVERITY WARNING;
    vecno <= vecno + 1;
  END PROCESS;
    
END ARCHITECTURE Testbench;

