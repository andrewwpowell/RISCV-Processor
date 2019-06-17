--
-- VHDL Architecture my_project1_lib.ALU.Behavior
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 12:39:48 03/18/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.RV32I.ALL; 

ENTITY ALU IS
  PORT(Left, Right : IN std_ulogic_vector(31 DOWNTO 0);
    Operation : IN ALU_Op;
    Output : OUT std_ulogic_vector(31 DOWNTO 0);
    Status : OUT std_ulogic);
END ENTITY ALU;

--
ARCHITECTURE Behavior OF ALU IS
BEGIN
  
  PROCESS(Left, Right, Operation)
  
  VARIABLE sOp : SIGNED(31 DOWNTO 0);
  VARIABLE uOp : UNSIGNED(31 DOWNTO 0);
  VARIABLE shift : INTEGER;
  CONSTANT X : std_ulogic_vector(31 DOWNTO 0) := (others => 'X');
  CONSTANT zero : std_ulogic_vector(31 DOWNTO 0) := (others => '0');
  CONSTANT one : std_ulogic_vector(31 DOWNTO 0) := "00000000000000000000000000000001";
  
  BEGIN
    
    Status <= '1';
    
    CASE Operation IS
      WHEN aADD =>
        sOp := SIGNED(Left) + SIGNED(Right);
        Output <= std_ulogic_vector(sOp);
        
      WHEN aSUB =>
        sOp := SIGNED(Right) - SIGNED(Left);
        Output <= std_ulogic_vector(sOp);
        
      WHEN aAND =>
        Output <= Left AND Right;
        
      WHEN aOR =>
        Output <= Left OR Right;
        
      WHEN aXOR =>
        Output <= Left XOR Right;
        
      WHEN sSL =>
        uOp := shift_left(UNSIGNED(Right), to_integer(UNSIGNED(Left)));
        Output <= std_ulogic_vector(uOp);
        
      WHEN sSRL =>
        --shift := shift_right(conv_integer(UNSIGNED(Left), conv_integer(UNSIGNED(Right));
        --Output <= std_ulogic_vector(to_unsigned(shift, Output'length));
        uOp := shift_right(UNSIGNED(Right), to_integer(UNSIGNED(Left)));
        Output <= std_ulogic_vector(uOp);
        
      WHEN sSRA =>
        --shift := conv_integer(UNSIGNED(Left)) SRA conv_integer(UNSIGNED(Right));
        --Output <= std_ulogic_vector(to_unsigned(shift, Output'length));
        sOp := shift_right(SIGNED(Right), to_integer(UNSIGNED(Left)));
        Output <= std_ulogic_vector(sOp);
        
      WHEN USUB =>
        uOp := UNSIGNED(Right) - UNSIGNED(Left);
        Output <= std_ulogic_vector(uOp);
        
      WHEN LTU =>
        IF(to_integer(UNSIGNED(Right)) < to_integer(UNSIGNED(Left))) THEN
          Output <= one;
        ELSE
          Output <= zero;
        END IF;
      
      WHEN LT =>
        IF(SIGNED(Right) < SIGNED(Left)) THEN
          Output <= one;
        ELSE
          Output <= zero;
        END IF;
        
      WHEN others =>
        Output <= X;
        Status <= '0';
        
    END CASE;
    
  END PROCESS;
END ARCHITECTURE Behavior;

