--
-- VHDL Architecture my_project1_lib.WriteBackStage.Behavior
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 17:29:56 04/ 4/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.RV32I.ALL; 

ENTITY WriteBackStage IS
  PORT(DataIn : IN std_ulogic_vector(31 DOWNTO 0);
    Dest_reg_in : IN std_ulogic_vector(4 DOWNTO 0);
    Funct : IN RV32I_Op;
    clk : IN std_ulogic;
    DataOut : OUT std_ulogic_vector(31 DOWNTO 0);
    Dest_reg_out : OUT std_ulogic_vector(4 DOWNTO 0);
    write : OUT std_ulogic);
END ENTITY WriteBackStage;

--
ARCHITECTURE Behavior OF WriteBackStage IS
  
  SIGNAL DataRegOut : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL DestRegOut : std_ulogic_vector(4 DOWNTO 0);
  SIGNAL FunctRegOut : RV32I_Op;
  
  CONSTANT X : std_ulogic_vector(31 DOWNTO 0) := (others => 'X');
  
BEGIN
  
  DataRegister : ENTITY work.Reg(Behavior)
    GENERIC MAP(width=>32)
    PORT MAP(D=>DataIn, Q=>DataRegOut, clk=>clk, enable=>'1', rst=>'0');
  
  DestRegister : ENTITY work.Reg(Behavior)
    GENERIC MAP(width=>5)
    PORT MAP(D=>Dest_reg_in, Q=> DestRegOut, clk=>clk, enable=>'1', rst=>'0');
      
  FunctionRegister : ENTITY work.RV32IReg(Behavior)
    PORT MAP(D=>Funct, Q=>FunctRegOut, clk=>clk, enable=>'1', rst=>'0');
  
  PROCESS(DataRegOut, DestRegOut, FunctRegout)
  
  BEGIN
    
    --ALU functions, loads, 
    --not branches, stores,
    
    DataOut <= DataRegOut;
    Dest_reg_out <= DestRegOut;
    write <= '1';
    
    IF(FunctRegOut = NOP OR FunctRegOut = BAD) THEN
      DataOut <= X;
      Dest_reg_out <= "XXXXX";
      write <= '0';
    ELSIF(DataRegOut = X) THEN
      DataOut <= X;
      Dest_reg_out <= "XXXXX";
      write <= '0';
    ELSIF(FunctRegOut = BEQ OR FunctRegOut = BNE OR FunctRegOut = BLT OR FunctRegOut = BGE OR FunctRegOut = BLTU OR FunctRegOut = BGEU)THEN
      DataOut <= X;
      Dest_reg_out <= "XXXXX";
      write <= '0';
    ELSIF(FunctRegOut = JALR OR FunctRegOut = JAL)THEN
      DataOut <= X;
      Dest_reg_out <= "XXXXX";
      write <= '0';
    ELSIF(FunctRegOut = SB OR FunctRegOut = SH OR FunctRegOut = SW) THEN
      DataOut <= X;
      Dest_reg_out <= "XXXXX";
      write <= '0';
    ELSIF(FunctRegOut = AUIPC)THEN
      DataOut <= X;
      Dest_reg_out <= "XXXXX";
      write <= '0';          
    END IF;
  END PROCESS;
END ARCHITECTURE Behavior;

