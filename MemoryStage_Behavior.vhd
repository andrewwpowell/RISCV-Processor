--
-- VHDL Architecture my_project1_lib.MemoryStage.Behavior
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 18:37:49 04/ 3/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.RV32I.ALL; 

ENTITY MemoryStage IS
  PORT(Address, Data, DataIn : IN std_ulogic_vector(31 DOWNTO 0);
    Dest_reg : IN std_ulogic_vector(4 DOWNTO 0);
    Funct : IN RV32I_Op;
    Mdelay, Clk : IN std_ulogic;
    AddressOut, DataOut, DataWriteBack : OUT std_ulogic_vector(31 DOWNTO 0);
    Dest_regOut : OUT std_ulogic_vector(4 DOWNTO 0);
    FunctOut : OUT RV32I_Op;
    Rd, Wrt, Stall : OUT std_ulogic;
    DataSize : OUT std_ulogic_vector(1 DOWNTO 0));
END ENTITY MemoryStage;

--
ARCHITECTURE Behavior OF MemoryStage IS
  SIGNAL DataRegOut, AddressRegOut : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL DestRegOut : std_ulogic_vector(4 DOWNTO 0);
  SIGNAL FunctRegOut : RV32I_Op;
  
  CONSTANT zero : std_ulogic_vector(31 DOWNTO 0) := (others => '0');
  CONSTANT one : std_ulogic_vector(31 DOWNTO 0) := "00000000000000000000000000000001";
  CONSTANT X : std_ulogic_vector(31 DOWNTO 0) := (others => 'X');
  
BEGIN
  
  DataRegister : ENTITY work.Reg(Behavior)
    GENERIC MAP(width=>32)
    PORT MAP(D=>Data, Q=>DataRegOut, clk=>Clk, enable=>NOT(Mdelay), rst=>'0');
  
  AddressRegister : ENTITY work.Reg(Behavior)
    GENERIC MAP(width=>32)
    PORT MAP(D=>Address, Q=>AddressRegOut, clk=>Clk, enable=>NOT(Mdelay), rst=>'0');
  
  DestRegister : ENTITY work.Reg(Behavior)
    GENERIC MAP(width=>5)
    PORT MAP(D=>Dest_reg, Q=>DestRegOut, clk=>Clk, enable=>NOT(Mdelay), rst=>'0');
  
  FunctionRegister : ENTITY work.RV32IReg(Behavior)
    PORT MAP(D=>Funct, Q=>FunctRegOut, clk=>Clk, enable=>NOT(Mdelay), rst=>'0');
  
  PROCESS(FunctRegOut, AddressRegOut, DestRegOut, DataRegOut, Mdelay, Data, DataIn)
  
  BEGIN
    
    DataSize <= "XX";
    AddressOut <= AddressRegOut;
    DataOut <= DataRegOut;
    Dest_regOut <= DestRegOut;
    FunctOut <= FunctRegOut;
    Rd <= '0';
    Wrt <= '0';
    DataWriteBack <= DataRegOut;
    Stall <= '0';
    
    IF(Mdelay = '1') THEN
      Stall <= '1';
      FunctOut <= NOP;
    ELSE
      IF(FunctRegOut = SB) THEN
        DataSize <= "00";
        AddressOut <= AddressRegOut;
        DataOut <= DataRegOut;
        Wrt <= '1';
        Rd <= '0';
        DataWriteBack <= X;
      ELSIF(FunctRegOut = SH) THEN
        DataSize <= "01";
        AddressOut <= AddressRegOut;
        DataOut <= DataRegOut;
        Wrt <= '1';
        Rd <= '0';
        DataWriteBack <= X;
      ELSIF(FunctRegOut = SW) THEN
        DataSize <= "10";
        AddressOut <= AddressRegOut;
        DataOut <= DataRegOut;
        Wrt <= '1';
        Rd <= '0';
        DataWriteBack <= X;
      ELSIF(FunctRegOut = LB OR FunctRegOut = LBU) THEN
        DataSize <= "00";
        AddressOut <= AddressRegOut;
        Wrt <= '0';
        Rd <= '1';
        DataOut <= X;
        DataWriteBack <= DataIn;    
      ELSIF(FunctRegOut = LH OR FunctRegOut = LHU) THEN
        DataSize <= "01";
        AddressOut <= AddressRegOut;
        Wrt <= '0';
        Rd <= '1';
        DataOut <= X;
        DataWriteBack <= DataIn;
      ELSIF(FunctRegOut = LW) THEN
        DataSize <= "10";
        AddressOut <= AddressRegOut;
        Wrt <= '0';
        Rd <= '1';
        DataOut <= X;
        DataWriteBack <= DataIn;
      ELSIF(FunctRegOut = LUI) THEN
        DataWriteBack <= DataRegOut;
      ELSIF(FunctRegOut = AUIPC) THEN
        Rd <= '1';
        AddressOut <= AddressRegOut;
        DataWriteBack <= DataIn;
      ELSIF(FunctRegOut = JAL OR FunctRegOut = JALR) THEN
        Wrt <= '1';
        DataOut <= DataRegOut;
      END IF;
    END IF;  
  END PROCESS;
END ARCHITECTURE Behavior;

