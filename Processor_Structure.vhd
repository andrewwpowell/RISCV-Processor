--
-- VHDL Architecture my_project1_lib.Processor.Structure
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 17:42:08 04/28/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.RV32I.ALL; 

ENTITY Processor IS
  PORT(clock, reset, MemSysDelay : IN std_ulogic;
    MemSysAddr, MemSysDataOut : OUT std_ulogic_vector(31 DOWNTO 0);
    MemSysWrite, MemSysRead : OUT std_ulogic;
    MemSysDataIn : IN std_ulogic_vector(31 DOWNTO 0));
END ENTITY Processor;

--
ARCHITECTURE Structure OF Processor IS
  
  SIGNAL memStall, trackerStall : std_ulogic := '0';
  SIGNAL jmp : std_ulogic := '0';
  SIGNAL jmpAddr : std_ulogic_vector(31 DOWNTO 0) := (others=>'X');
  SIGNAL fetchRead, memRead, memWrite : std_ulogic := '0';
  SIGNAL decodeDest, execDest, memDest, wbDest : std_ulogic_vector(4 DOWNTO 0);
  SIGNAL Left, Right, Extra : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL decodeFunc, execFunc, memFunc : RV32I_Op;
  SIGNAL fetchAddr, fetchInst : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL execAddr, memAddr, decAddr : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL execData, memData, wbData, memoryDataIn, memoryDataOut, wbDataOut : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL arbiterAddress : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL arbWE, arbRE : std_ulogic;
  SIGNAL memoryDelay, fetchDelay : std_ulogic := '0';
  SIGNAL RFAA, RFAB : std_ulogic_vector(4 DOWNTO 0);
  SIGNAL RFDA, RFDB : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL RS1v, RS2v, RDv, wbWrite : std_ulogic;
  SIGNAL ReserveVector : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL size : std_ulogic_vector(1 DOWNTO 0);
  SIGNAL systemDelay : std_ulogic;
  
BEGIN
  
  Fetch : ENTITY work.Fetch2(Behavior)
    PORT MAP(Jaddr=>jmpAddr, Mdata=>MemSysDataIn, Address=>fetchAddr, Inst=>fetchInst, 
            Clock=>clock, Jmp=>jmp, Reset=>reset, Delay=>(fetchDelay OR trackerStall), Read=>fetchRead);
  
  Decode : ENTITY work.DecodeStage(Behavior)
    PORT MAP(Address=>fetchAddr, Inst=>fetchInst, Clk=>clock, stall=>(trackerStall OR memStall), 
            Dest_reg=>decodeDest, Left=>Left, Right=>Right, Extra=>Extra, Funct=>decodeFunc, 
            RFAA=>RFAA, RFAB=>RFAB, RFDA=>RFDA, RFDB=>RFDB, RS1v=>RS1v, RS2v=>RS2v, RDv=>RDv, AddressOut=>decAddr, jmp=>jmp);
      
  Execute : ENTITY work.ExecuteStage(Behavior)
    PORT MAP(Left=>Left, Right=>Right, Extra=>Extra, Dest_reg_in=>decodeDest, 
            Funct_in=>decodeFunc, Data=>execData, Jaddr=>jmpAddr, AddressIn=>decAddr, Address=>execAddr,
            Dest_reg_out=>execDest, Funct_out=>execFunc, Jump=>jmp, Clk=>clock, stall=>memStall);
      
  Memory : ENTITY work.MemoryStage(Behavior)
    PORT MAP(Address=>execAddr, Data=>execData, DataIn=>MemSysDataIn, Dest_reg=>execDest, 
            Funct=>execFunc, Mdelay=>memoryDelay, Clk=>clock, AddressOut=>memAddr, DataOut=>memoryDataOut, 
            DataWriteBack=>wbData, Dest_regOut=>memDest, FunctOut=>memFunc, Rd=>memRead, Wrt=>memWrite, Stall=>memStall, DataSize=>size);
      
  Writeback : ENTITY work.WriteBackStage(Behavior)
    PORT MAP(DataIn=>wbData, Dest_reg_in=>memDest, Funct=>memFunc, clk=>clock, 
            DataOut=>wbDataOut, Dest_reg_out=>wbDest, write=>wbWrite);
      
  Arbiter : ENTITY work.MemoryArbiter(Behavior)
    PORT MAP(fetchAddress=>fetchAddr, memAddress=>memAddr, fetchRd=>fetchRead, 
            memRd=>memRead, memWrt=>memWrite, mdelay=>MemSysDelay, delayFetch=>fetchDelay, 
            delayMem=>memoryDelay, writeEnable=>arbWE, readEnable=>arbRE, addressOut=>arbiterAddress);
      
  --System : ENTITY work.MemorySystem(Behavior)
    --PORT MAP(Addr=>arbiterAddress, DataIn=>memoryDataOut, clock=>clock, we=>arbWE, re=>arbRE, mdelay=>systemDelay, DataOut=>memoryDataIn);
      
  Tracker : ENTITY work.RegisterTracker(Behavior)
    GENERIC MAP(RegWidth=>32, RegSel=>5)
    PORT MAP(RFRAA=>RFAA, RFRAB=>RFAB, RFWA_dec=>decodeDest, RFWA_wb=>wbDest, ReadA=>RS1v, ReadB=>RS2v, Reserve=>RDv, Free=>wbWrite, clk=>clock, ReserveVector=>ReserveVector, Stall=>trackerStall);
      
  RegisterFile : ENTITY work.RegisterFile(Behavior)
    GENERIC MAP(RegWidth=>32, RegSel=>5)
    PORT MAP(WBDataIn=>wbDataOut, RFDA=>RFDA, RFDB=>RFDB, RFAA=>RFAA, RFAB=>RFAB, DestReg=>wbDest, ReadA=>RS1v, ReadB=>RS2v, Write=>wbWrite, clk=>clock);
      
  MemSysAddr <= arbiterAddress;
  MemSysDataOut <= memoryDataOut;
  MemSysRead <= arbRE;
  MemSysWrite <= arbWE;
  
END ARCHITECTURE Structure;

