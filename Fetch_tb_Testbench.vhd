--
-- VHDL Architecture my_project1_lib.Fetch_tb.Testbench
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 12:08:41 02/11/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;

ENTITY Fetch_tb IS
END ENTITY Fetch_tb;

--
ARCHITECTURE Testbench OF Fetch_tb IS
  
  FILE test_vectors : text OPEN read_mode IS "Fetch_vec.txt";
  
  SIGNAL Jaddr, Mdata : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL Address, Addressv, Inst, Instv : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL Clock, Jmp, Reset, Delay : std_ulogic;
  SIGNAL Rd, Readv : std_ulogic;
  
  SIGNAL vecno : NATURAL := 0;
  
BEGIN
  
  DUV : ENTITY work.Fetch2(Behavior)
    PORT MAP(Jaddr=>Jaddr, Mdata=>Mdata, Address=>Address, Inst=>Inst, Clock=>Clock, Jmp=>Jmp, Reset=>Reset, Delay=>Delay, Read=>Rd);
      
  Stim : PROCESS
    VARIABLE L : LINE;
    VARIABLE Jaddr_val, Mdata_val, Address_val, Inst_val : std_ulogic_vector(31 DOWNTO 0);
    VARIABLE Jmp_val, Reset_val, Delay_val, Read_val : std_ulogic;
    
  BEGIN
    Clock <= '0';
    wait for 40 ns;
    readline(test_vectors, L);
    
    WHILE NOT endfile(test_vectors) LOOP
      readline(test_vectors, L);
      read(L, Jaddr_val);
      Jaddr <= Jaddr_val;
      read(L, Mdata_val);
      Mdata <= Mdata_val;
      read(L, Jmp_val);
      Jmp <= Jmp_val;
      read(L, Reset_val);
      Reset <= Reset_val;
      read(L, Delay_val);
      Delay <= Delay_val;
      
      read(L, Address_val);
      Addressv <= Address_val;
      read(L, Inst_val);
      Instv <= Inst_val;
      read(L, Read_val);
      Readv <= Read_val;
      
      wait for 10 ns;
      Clock <= '1';
      wait for 50 ns;
      Clock <= '0';
      wait for 40 ns;
      END LOOP;
    
      report "End of Testbench.";
      std.env.finish;
  END PROCESS;
  
  Check : PROCESS(Clock)
  BEGIN
    IF(falling_edge(Clock)) THEN
      ASSERT Address = Addressv
        REPORT "ERROR: Incorrect Address output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT Rd = Readv
        REPORT "ERROR: Incorrect Read output for vector " & to_string(vecno)
        SEVERITY WARNING;
      ASSERT Inst = Instv
        REPORT "ERROR: Incorrect Instruction output for vector " & to_string(vecno)
        SEVERITY WARNING;
      vecno <= vecno + 1;
    END IF;
  END PROCESS;
END ARCHITECTURE Testbench;

