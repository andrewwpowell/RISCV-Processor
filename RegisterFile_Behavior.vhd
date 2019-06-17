--
-- VHDL Architecture my_project1_lib.RegisterFile.Behavior
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 20:54:54 04/11/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.RV32I.ALL; 

ENTITY RegisterFile IS
  GENERIC(RegWidth : NATURAL RANGE 2 TO 64 := 32;
          RegSel : NATURAL RANGE 2 TO 5 := 5);
  PORT(WBDataIn : IN std_ulogic_vector(RegWidth-1 DOWNTO 0);
    RFDA, RFDB : OUT std_logic_vector(RegWidth-1 DOWNTO 0);
    RFAA, RFAB, DestReg : IN std_ulogic_vector(RegSel-1 DOWNTO 0);
    ReadA, ReadB, Write, clk : IN std_ulogic);
END ENTITY RegisterFile;

--
ARCHITECTURE Behavior OF RegisterFile IS
  SIGNAL ReadDC1, ReadDC2, WriteDC : std_logic_vector((2**RegSel)-1 DOWNTO 0);
  
BEGIN
  
  ReadDecode1 : ENTITY work.RegFileDecoder(Behavior)
    GENERIC MAP(InBits=>RegSel)
    PORT MAP(sel=>RFAA, OneHot=>ReadDC1, enable=>ReadA);

  ReadDecode2 : ENTITY work.RegFileDecoder(Behavior)
    GENERIC MAP(InBits=>RegSel)
    PORT MAP(sel=>RFAB, OneHot=>ReadDC2, enable=>ReadB);
          
  WriteDecode : ENTITY work.RegFileDecoder(Behavior)
    GENERIC MAP(InBits=>RegSel)
    PORT MAP(sel=>DestReg, OneHot=>WriteDC, enable=>Write);
      
  RegZero : ENTITY work.RegReadWrite(Mixed)
    GENERIC MAP(size=>RegWidth)
    PORT MAP(D=>"00000000000000000000000000000000", QA=>RFDA, QB=>RFDB, clk=>clk, LE=>WriteDC(0), OE1=>ReadDC1(0), OE2=>ReadDC2(0));
      
  RegArray : FOR i IN 1 TO ((2**RegSel)-1) GENERATE
    BEGIN
      RegI : ENTITY work.RegReadWrite(Mixed)
        GENERIC MAP(size=>RegWidth)
        PORT MAP(D=>WBDataIn, QA=>RFDA, QB=>RFDB, Clk=>Clk, LE=>WriteDC(i), OE1=>ReadDC1(i), OE2=>ReadDC2(i));
          
    END GENERATE RegArray;
END ARCHITECTURE Behavior;

