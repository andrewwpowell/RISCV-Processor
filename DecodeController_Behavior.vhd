--
-- VHDL Architecture my_project1_lib.DecodeController.Behavior
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 12:25:30 03/ 4/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.RV32I.ALL;

ENTITY DecodeController IS
  PORT( FID : IN RV32I_Op;
    RS1v, RS2v, RDv : IN std_ulogic;
    RFDA, RFDB : IN std_ulogic_vector(31 DOWNTO 0);
    Immediate : IN std_ulogic_vector(31 DOWNTO 0);
    Left, Right, Extra : OUT std_ulogic_vector(31 DOWNTO 0));
END ENTITY DecodeController;

--
ARCHITECTURE Behavior OF DecodeController IS
BEGIN
  
  PROCESS(RS1v, RS2v, RDv)
  
  BEGIN
    
    IF(RS1v = '0') THEN
      -- U/J type
      CASE FID IS
        WHEN LUI =>
          
        WHEN AUIPC =>
            
        WHEN JAL =>
      
      END CASE;        
    ELSIF(RDv = '0') THEN
      -- S/B type
      CASE FID IS
        WHEN BEQ =>
          
        WHEN BNE =>
          
        WHEN BLT =>
          
        WHEN BGE =>
          
        WHEN BLTU =>
          
        WHEN BGEU =>
          
        WHEN others =>
          -- Store
      END CASE;
      
    ELSIF(RS1v = '1' AND RS2v = '1' AND RDv = '1') THEN
      -- R type
      
    ELSIF(RS1v = '1' AND RS2v = '0' AND RDv = '1') THEN
      -- I type
      CASE FID IS
        WHEN JALR =>
          
        WHEN others =>
          
      END CASE;
      
    END IF;
    
  END PROCESS;
END ARCHITECTURE Behavior;

