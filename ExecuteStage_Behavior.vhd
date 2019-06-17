--
-- VHDL Architecture my_project1_lib.ExecuteStage.Behavior
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 11:59:12 03/25/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.RV32I.ALL; 

ENTITY ExecuteStage IS
  PORT(Left, Right, Extra, AddressIn : IN std_ulogic_vector(31 DOWNTO 0);
    Dest_reg_in : IN std_ulogic_vector(4 DOWNTO 0);
    Funct_in : IN RV32I_Op;
    Address, Data, Jaddr : OUT std_ulogic_vector(31 DOWNTO 0);
    Dest_reg_out : OUT std_ulogic_vector(4 DOWNTO 0);
    Funct_out : OUT RV32I_Op;
    Jump : OUT std_ulogic;
    Clk, stall : IN std_ulogic);
END ENTITY ExecuteStage;

--
ARCHITECTURE Behavior OF ExecuteStage IS
  SIGNAL LeftRegOut, RightRegOut, ExtraRegOut, PCRegOut : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL DestRegOut : std_ulogic_vector(4 DOWNTO 0);
  SIGNAL FunctRegOut : RV32I_Op;
  SIGNAL Op : ALU_Op;
  SIGNAL s : std_ulogic;
  SIGNAL ALU_output : std_ulogic_vector(31 DOWNTO 0);
  
  CONSTANT zero : std_ulogic_vector(31 DOWNTO 0) := (others => '0');
  CONSTANT one : std_ulogic_vector(31 DOWNTO 0) := "00000000000000000000000000000001";
  CONSTANT X : std_ulogic_vector(31 DOWNTO 0) := (others => 'X');
  
BEGIN
  LeftRegister : ENTITY work.Reg(Behavior)
    GENERIC MAP(width=>32)
    PORT MAP(D=>Left , Q=>LeftRegOut , clk=>Clk, enable=>NOT(stall), rst=>'0');
  
  RightRegister : ENTITY work.Reg(Behavior)
    GENERIC MAP(width=>32)
    PORT MAP(D=>Right , Q=>RightRegOut , clk=>Clk, enable=>NOT(stall), rst=>'0');
  
  ExtraRegister : ENTITY work.Reg(Behavior)
    GENERIC MAP(width=>32)
    PORT MAP(D=>Extra , Q=>ExtraRegOut , clk=>Clk, enable=>NOT(stall), rst=>'0');
  
  DestinationRegister : ENTITY work.Reg(Behavior)
    GENERIC MAP(width=>5)
    PORT MAP(D=>Dest_reg_in , Q=>DestRegOut , clk=>Clk, enable=>NOT(stall), rst=>'0');
  
  FunctionRegister : ENTITY work.RV32IReg(Behavior)
    PORT MAP(D=>Funct_in , Q=>FunctRegOut , clk=>Clk, enable=>NOT(stall), rst=>'0');
      
  AddressRegister : ENTITY work.Reg(Behavior)
    GENERIC MAP(width=>32)
    PORT MAP(D=>AddressIn, Q=>PCRegOut, clk=>Clk, enable=>not(stall), rst=>'0');
      
  ALU : ENTITY work.ALU(Behavior)
    PORT MAP(Left=>LeftRegOut , Right=>RightRegOut , Operation=>Op , Output=>ALU_output , Status=>s );
      
  PROCESS(FunctRegOut, stall, DestRegOut, FunctRegOut, PCRegOut, ALU_output)
  
    VARIABLE ALU_out : std_ulogic_vector(31 DOWNTO 0);
  
  BEGIN
    
    Address <= PCRegOut;
    Data <= ALU_output;
    Jaddr <= X;
    Jump <= '0';
    Dest_reg_out <= DestRegOut;
    Funct_out <= FunctRegOut;
    Op <= BAD;
    
    --Use function type / individual command to determine what to send into ALU
    IF(FunctRegOut = NOP OR FunctRegOut = BAD) THEN
      Data <= ALU_output;
      Jaddr <= X;
      Address <= X;
      Jump <= '0';
      Dest_reg_out <= "XXXXX";  
    ELSIF(FunctRegOut = LUI) THEN
      Data <= ExtraRegOut;
    ELSIF(FunctRegOut = AUIPC) THEN
      Address <= ExtraRegOut;
    ELSIF(FunctRegout = JAL) THEN
      Op <= aADD;
      Jump <= '1';
      Jaddr <= ALU_output;
      Data <= ExtraRegOut;
    ELSIF(FunctRegout = JALR) THEN
      Op <= aADD;
      Jump <= '1';
      Jaddr <= ALU_output;
      Data <= ExtraRegOut;
    ELSIF(FunctRegOut = BEQ) THEN
      Op <= aSUB;
      IF(ALU_output = zero) THEN
        Jump <= '1';
        Jaddr <= ExtraRegOut;
      END IF;
    ELSIF(FunctRegOut = BNE) THEN
      Op <= aSUB;
      IF(NOT(ALU_output = zero)) THEN
        Jump <= '1';
        Jaddr <= ExtraRegOut;
      END IF;
    ELSIF(FunctRegOut = BLT) THEN
      Op <= LT;
      IF(ALU_output = one) THEN
        Jump <= '1';
        Jaddr <= ExtraRegOut;
      END IF;
    ELSIF(FunctRegOut = BGE)  THEN
      Op <= LT;
      IF(ALU_output = zero) THEN
        Jump <= '1';
        Jaddr <= ExtraRegOut;
      END IF;
    ELSIF(FunctRegOut = BLTU) THEN
      Op <= LTU;
      IF(ALU_output = one) THEN
        Jump <= '1';
        Jaddr <= ExtraRegOut;
      END IF;
    ELSIF(FunctRegOut = BGEU) THEN
      Op <= LTU;
      IF(ALU_output = zero) THEN
        Jump <= '1';
        Jaddr <= ExtraRegOut;
      END IF;
    ELSIF(FunctRegout = LB OR FunctRegOut = LH OR FunctRegOut = LW OR FunctRegOut = LBU OR FunctRegOut = LHU OR FunctRegOut = SB OR FunctRegOut = SH OR FunctRegOut = SW) THEN
      Op <= aADD;
      Address <= ALU_output;
      Data <= ExtraRegOut;
    ELSIF(FunctRegOut = ADDI OR FunctRegOut = ADDr) THEN
      Op <= aADD;
      Data <= ALU_output;
    ELSIF(FunctRegOut = SUBr) THEN
      Op <= aSUB;
      Data <= ALU_output;
    ELSIF(FunctRegOut = SLTI OR FunctRegOut = SLTr) THEN
      Op <= LT;
      IF(ALU_output = one) THEN
        Data <= one;
      ELSE
        Data <= zero;
      END IF;
    ELSIF(FunctRegOut = SLTIU OR FunctRegOut = SLTUr) THEN
      Op <= LTU;
      IF(ALU_output = one) THEN
        Data <= one;
      ELSE
        Data <= zero;
      END IF;      
    ELSIF(FunctRegOut = XORI OR FunctRegOut = XORr) THEN
      Op <= aXOR;
      Data <= ALU_output;      
    ELSIF(FunctRegOut = ORI OR FunctRegOut = ORr) THEN
      Op <= aOR;
      Data <= ALU_output;
    ELSIF(FunctRegOut = ANDI OR FunctRegOut = ANDr) THEN
      Op <= aAND;
      Data <= ALU_output;
    ELSIF(FunctRegOut = SLLI OR FunctRegOut = SLLr) THEN
      Op <= sSL;
      Data <= ALU_output;
    ELSIF(FunctRegOut = SRLI OR FunctRegOut = SRLr) THEN
      Op <= sSRL;
      Data <= ALU_output;
    ELSIF(FunctRegOut = SRAI OR FunctRegOut = SRAr) THEN
      Op <= sSRA;
      Data <= ALU_output;
    END IF;
    
  END PROCESS;
END ARCHITECTURE Behavior;

