--
-- VHDL Architecture my_project1_lib.DecodeStage.Behavior
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 16:36:14 03/ 3/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.RV32I.ALL;

ENTITY DecodeStage IS
  PORT( Address, Inst : IN std_ulogic_vector(31 DOWNTO 0);
    Clk, stall, jmp : IN std_ulogic;
    Dest_reg : OUT std_ulogic_vector(4 DOWNTO 0);
    Left, Right, Extra, AddressOut : OUT std_ulogic_vector(31 DOWNTO 0);
    Funct : OUT RV32I_Op;
    RFAA, RFAB : OUT std_ulogic_vector(4 DOWNTO 0);
    RFDA, RFDB : IN std_ulogic_vector(31 DOWNTO 0);
    RS1v, RS2v, RDv : OUT std_ulogic);
END ENTITY DecodeStage;

-- Load & Store data path operations
--  RS1 -> RFAA (Base Register)
--  RS2 -> RFAB (Source Register) *Only for store operations
--  RFDA -> Right output
--  Extended Immediate -> Left output
--  RFDB -> Extra output *needed for store operations
--  RD -> Dest_reg output *for store operations

-- R-Type Data path operations
--  RS1 -> RFAA
--  RS2 -> RFAB
--  RFDA -> Right output
--  RFDB -> Left output
--  RD -> Dest_reg

-- Data path altered based on instruction type
ARCHITECTURE Behavior OF DecodeStage IS
  SIGNAL AddressA, AddressB : std_ulogic_vector(4 DOWNTO 0);
  SIGNAL DataA, DataB : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL RS1,RS2,RD : std_ulogic_vector(4 DOWNTO 0);
  SIGNAL Immediate : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL InstRegOut, PCRegOut : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL FuncType : InsType;
  SIGNAL decodedFunction : RV32I_Op;
  SIGNAL RS1v_reg, RS2v_reg, RDv_reg : std_ulogic;
  
BEGIN
  
  InstructionDecoder : ENTITY work.Decoder(Behavior)
    PORT MAP(instruction=>InstRegOut, Immediate=>Immediate, RS1=>RFAA, RS2=>RFAB, RD=>Dest_reg, RS1v=>RS1v_reg, RS2v=>RS2v_reg, RDv=>RDv_reg, Func=>decodedFunction, FuncType=>FuncType);
      
  InstructionRegister : ENTITY work.Reg(Behavior)
    GENERIC MAP(width=>32)
    PORT MAP(D=>Inst , Q=>InstRegOut , clk=>Clk, enable=>NOT(stall), rst=>'0');
      
  PCRegister : ENTITY work.Reg(Behavior)
    GENERIC MAP(width=>32)
    PORT MAP(D=>Address, Q=>PCRegOut, clk=>Clk, enable=>NOT(stall), rst=>'0');
  
  PROCESS(Funct, PCRegOut, RFDA, RFDB, Immediate, FuncType, stall)
    
    VARIABLE operation : UNSIGNED (31 DOWNTO 0);
    VARIABLE PCval : std_ulogic_vector(31 DOWNTO 0);
    VARIABLE ImmediateVal : std_ulogic_vector(31 DOWNTO 0);
    
  BEGIN
    
    PCval := PCRegOut;
    ImmediateVal := Immediate;
    IF(stall = '1') THEN
      Funct <= NOP;
    ELSE
      Funct <= decodedFunction;
    END IF;
    
    IF(jmp = '1') THEN
      Funct <= NOP;
      RS1v <= '0';
      RS2v <= '0';
      RDv <= '0';
    ELSE
      Funct <= decodedFunction;
      RS1v <=RS1v_reg;
      RS2v <= RS2v_reg;
      RDv <= RDv_reg;
    END IF;
      
    
    IF(Funct = NOP) THEN
      Right <= RFDA;
      Left <= RFDB;
      Extra <= ImmediateVal;
    ELSIF(FuncType = R) THEN
      Right <= RFDA;
      Left <= RFDB;
      Extra <= ImmediateVal;
    ELSIF(FuncType = S) THEN
      Right <= RFDA;
      Left <= ImmediateVal;
      Extra <= RFDB;
    ELSIF(FuncType = SB) THEN
      Right <= RFDA;
      Left <= RFDB;
      operation := UNSIGNED(PCval) + UNSIGNED(ImmediateVal);
      Extra <= std_ulogic_vector(operation);
    ELSIF((Funct = LB) OR (Funct = LH) OR (Funct = LW) OR (Funct = LBU) OR (Funct = LHU)) THEN
      Right <= RFDA;
      Left <= ImmediateVal;
      Extra <= RFDB;
    ELSIF(Funct = JAL) THEN
      Right <= PCval;
      Left <= ImmediateVal;
      operation := UNSIGNED(PCval) + 4;
      Extra <= std_ulogic_vector(operation);
    ELSIF(Funct = JALR) THEN
      Right <= RFDA;
      Left <= ImmediateVal;
      operation := UNSIGNED(PCval) + 4;
      Extra <= std_ulogic_vector(operation);
    ELSIF(Funct = LUI) THEN
      Right <= RFDA;
      Left <= RFDB;
      Extra <= ImmediateVal;
    ELSIF(Funct = AUIPC) THEN
      Right <= RFDA;
      Left <= RFDB;
      operation := UNSIGNED(PCval) + UNSIGNED(ImmediateVal);
      Extra <= std_ulogic_vector(operation);
    ELSIF(Funct = ADDI OR Funct = SLTI OR Funct = SLTIU OR Funct = XORI OR Funct = ORI
            OR Funct = ANDI OR Funct = SLLI OR Funct = SRLI OR Funct = SRAI) THEN
      Right <= RFDA;
      Left <= ImmediateVal;
      Extra <= RFDB;
    ELSE
      Left <= RFDB;
      Right <= RFDA;
      Extra <= ImmediateVal;
    END IF;
    
    AddressOut <= PCval;
    
  END PROCESS;
END ARCHITECTURE Behavior;

