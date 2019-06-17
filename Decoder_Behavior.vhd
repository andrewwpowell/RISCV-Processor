--
-- VHDL Architecture my_project1_lib.Decoder.Behavior
--
-- Created:
--          by - powel.UNKNOWN (LAPTOP-627UE0BV)
--          at - 15:52:11 02/24/2019
--
-- using Mentor Graphics HDL Designer(TM) 2015.1b (Build 4)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY work;
USE work.RV32I.ALL;

ENTITY Decoder IS
  PORT( instruction : IN std_ulogic_vector(31 DOWNTO 0);
    Func : OUT RV32I_Op; -- Refer to package for enumeration type definition
    RS1, RS2, RD : OUT std_ulogic_vector(4 DOWNTO 0); -- Register IDs
    RS1v, RS2v, RDv : OUT std_ulogic; -- Valid indicators for Register IDs
    Immediate : OUT std_ulogic_vector(31 DOWNTO 0); -- Immediate Value
    FuncType : OUT InsType);
    
END ENTITY Decoder;

--
ARCHITECTURE Behavior OF Decoder IS
BEGIN
  PROCESS(instruction)
    VARIABLE OpCode : RV32I_OpField;
    VARIABLE Funct3 : RV32I_Funct3;
    VARIABLE Funct7 : RV32I_Funct7;
    CONSTANT immX : std_ulogic_vector(31 DOWNTO 0) := (others => 'X');
    CONSTANT regX : std_ulogic_vector(4 DOWNTO 0) := (others => 'X');
    CONSTANT zero : std_ulogic_vector(31 DOWNTO 0) := (others => '0');
    --VARIABLE i_immediate : std_ulogic_vector(11 DOWNTO 0);
    --VARIABLE s_immediate : std_ulogic_vector(11 DOWNTO 0);
    --VARIABLE b_immediate : std_ulogic_vector(12 DOWNTO 0);
    --VARIABLE u_immediate : std_ulogoc_vector(31 DOWNTO 0);
    --VARIABLE j_immediate : std_ulogic_vector(20 DOWNTO 0);
    
  BEGIN

    RS2v <= '0';
    RS2 <= regX;
    RS1v <= '0';
    RS1 <= regX;
    RDv <= '0';
    RD <= regX;
    Immediate <= immX;
    Func <= BAD;
    FuncType <= R;
    
    OpCode := instruction(6 DOWNTO 2);
    Funct3 := instruction(14 DOWNTO 12);
    Funct7 := instruction(31 DOWNTO 25);
    
    IF(instruction = NOP_inst) THEN
      FuncType <= R;
      RS2v <= '0';
      RS2 <= regX;
      RS1v <= '0';
      RS1 <= regX;
      RDv <= '0';
      RD <= regX;
      Immediate <= immX;
      Func <= BAD;
    ELSE
    
      IF(instruction(1 DOWNTO 0) = "11") THEN
        --Valid
        CASE OpCode IS
          --01101 (U-type)
          WHEN RV32I_OP_LUI =>
            FuncType <= U;
            RS2 <= regX;
            RS2v <= '0';
            RS1 <= regX;
            RS1v <= '0';
            RD <= instruction(11 DOWNTO 7);    
            RDv <= '1';
            Immediate(31 DOWNTO 12) <= instruction(31 DOWNTO 12);
            Immediate(11 DOWNTO 0) <= (others => '0');
            Func <= LUI;
            
          --00101 (U-type)
          WHEN RV32I_OP_AUIPC =>
            FuncType <= U;
            RS2 <= regX;
            RS2v <= '0';
            RS1 <= regX;
            RS1v <= '0';
            RD <= instruction(11 DOWNTO 7);   
            RDv <= '1'; 
            Immediate(31 DOWNTO 12) <= instruction(31 DOWNTO 12);
            Immediate(11 DOWNTO 0) <= (others => '0');
            Func <= AUIPC;
          
          --11011 (J-type)
          WHEN RV32I_OP_JAL =>
            FuncType <= UJ;
            RS2 <= regX;
            RS2v <= '0';
            RS1 <= regX;
            RS1v <= '0';
            RD <= instruction(11 DOWNTO 7);  
            RDv <= '1';  
            Immediate(31 DOWNTO 20) <= std_ulogic_vector(resize(signed(instruction(31 DOWNTO 31)),12)); 
            Immediate(19 DOWNTO 12) <= instruction(19 DOWNTO 12);
            Immediate(11) <= instruction(20);
            Immediate(10 DOWNTO 5) <= instruction(30 DOWNTO 25);
            Immediate(4 DOWNTO 1) <= instruction(24 DOWNTO 21);
            Immediate(0) <= '0';
            Func <= JAL;
          
          --11001 (I-type)
          WHEN RV32I_OP_JALR =>
            FuncType <= I;
            CASE Funct3 IS
              WHEN RV32I_FN3_JALR =>
                RS2 <= regX;
                RS2v <= '0';
                RS1 <= instruction(19 DOWNTO 15);
                RS1v <= '1';
                RD <= instruction(11 DOWNTO 7);  
                RDv <= '1';  
                Immediate(31 DOWNTO 11) <= std_ulogic_vector(resize(signed(instruction(31 DOWNTO 31)),21)); 
                Immediate(10 DOWNTO 0) <= instruction(30 DOWNTO 20); 
                Func <= JALR;
              WHEN others =>
                RS2v <= '0';
                RS2 <= regX;
                RS1v <= '0';
                RS1 <= regX;
                RDv <= '0';
                RD <= regX;
                Immediate <= immX;
                Func <= BAD;
            END CASE;
          
          --11000 (B-type)
          WHEN RV32I_OP_BRANCH =>
            FuncType <= SB;
            RS2 <= instruction(24 DOWNTO 20);
            RS2v <= '1';
            RS1 <= instruction(19 DOWNTO 15);
            RS1v <= '1';
            RD <= regX;
            RDv <= '0';
            Immediate(31 DOWNTO 12) <= std_ulogic_vector(resize(signed(instruction(31 DOWNTO 31)),20));
            Immediate(11) <= instruction(7);
            Immediate(10 DOWNTO 5) <= instruction(30 DOWNTO 25);
            Immediate(4 DOWNTO 1) <= instruction(11 DOWNTO 8);
            Immediate(0) <= '0';
            CASE Funct3 IS
              WHEN RV32I_FN3_BRANCH_EQ =>
                Func <= BEQ;
              WHEN RV32I_FN3_BRANCH_NE =>
                Func <= BNE;
              WHEN RV32I_FN3_BRANCH_LT =>
                Func <= BLT;
              WHEN RV32I_FN3_BRANCH_GE =>
                Func <= BGE;
              WHEN RV32I_FN3_BRANCH_LTU =>
                Immediate(31 DOWNTO 12) <= std_ulogic_vector(resize(signed(instruction(31 DOWNTO 31)),20));
                Func <= BLTU;
              WHEN RV32I_FN3_BRANCH_GEU =>
                Immediate(31 DOWNTO 12) <= std_ulogic_vector(resize(signed(instruction(31 DOWNTO 31)),20));
                Func <= BGEU;
              WHEN others =>
                RS2v <= '0';
                RS2 <= regX;
                RS1v <= '0';
                RS1 <= regX;
                RDv <= '0';
                RD <= regX;
                Immediate <= immX;
                Func <= BAD;
            END CASE;
            
          --00000 (I-type)
          WHEN RV32I_OP_LOAD =>
            FuncType <= I;
            RS2 <= regX;
            RS2v <= '0';
            RS1 <= instruction(19 DOWNTO 15);
            RS1v <= '1';
            RD <= instruction(11 DOWNTO 7);
            RDv <= '1';
            Immediate(31 DOWNTO 11) <= std_ulogic_vector(resize(signed(instruction(31 DOWNTO 31)),21));
            Immediate(10 DOWNTO 0) <= instruction(30 DOWNTO 20);
            CASE Funct3 IS
              WHEN RV32I_FN3_LOAD_B =>
                Func <= LB;
              WHEN RV32I_FN3_LOAD_H =>
                Func <= LH;
              WHEN RV32I_FN3_LOAD_W =>
                Func <= LW;
              WHEN RV32I_FN3_LOAD_BU =>
                Immediate(31 DOWNTO 11) <= std_ulogic_vector(resize(signed(instruction(31 DOWNTO 31)),21));
                Func <= LBU;
              WHEN RV32I_FN3_LOAD_HU =>
                Immediate(31 DOWNTO 11) <= std_ulogic_vector(resize(signed(instruction(31 DOWNTO 31)),21));
                Func <= LHU;
              WHEN others =>
                RS2v <= '0';
                RS2 <= regX;
                RS1v <= '0';
                RS1 <= regX;
                RDv <= '0';
                RD <= regX;
                Immediate <= immX;
                Func <= BAD;
            END CASE;
          
          --01000 (S-type)
          WHEN RV32I_OP_STORE =>
            FuncType <= S;
            RS2 <= instruction(24 DOWNTO 20);
            RS2v <= '1';
            RS1 <= instruction(19 DOWNTO 15);
            RS1v <= '1';
            RD <= regX;
            RDv <= '0';
            Immediate(31 DOWNTO 11) <= std_ulogic_vector(resize(signed(instruction(31 DOWNTO 31)),21));
            Immediate(10 DOWNTO 5) <= instruction(30 DOWNTO 25);
            Immediate(4 DOWNTO 0) <= instruction(11 DOWNTO 7);
            CASE Funct3 IS
              WHEN RV32I_FN3_STORE_B =>
                Func <= SB;
              WHEN RV32I_FN3_STORE_H =>
                Func <= SH;
              WHEN RV32I_FN3_STORE_W =>
                Func <= SW;
              WHEN others =>
                RS2v <= '0';
                RS2 <= regX;
                RS1v <= '0';
                RS1 <= regX;
                RDv <= '0';
                RD <= regX;
                Immediate <= immX;
                Func <= BAD;
            END CASE;
          
          --00100 (R-type Instruction Variant / I-type Shift Variant)
          WHEN RV32I_OP_ALUI =>
            FuncType <= I;
            RS2 <= regX;
            RS2v <= '0';
            RS1 <= instruction(19 DOWNTO 15);
            RS1v <= '1';
            RD <= instruction(11 DOWNTO 7);
            RDv <= '1';
            Immediate(31 DOWNTO 11) <= std_ulogic_vector(resize(signed(instruction(31 DOWNTO 31)),21));
            Immediate(10 DOWNTO 0) <= instruction(30 DOWNTO 20);
            CASE Funct3 IS
              WHEN RV32I_FN3_ALU_ADD =>
                Func <= ADDI;
              WHEN RV32I_FN3_ALU_SLT =>
                Func <= SLTI;
              WHEN RV32I_FN3_ALU_SLTU =>
                Immediate(31 DOWNTO 11) <= std_ulogic_vector(resize(signed(instruction(31 DOWNTO 31)),21));
                Func <= SLTIU;
              WHEN RV32I_FN3_ALU_XOR =>
                Func <= XORI;
              WHEN RV32I_FN3_ALU_OR =>
                Func <= ORI;
              WHEN RV32I_FN3_ALU_AND =>
                Func <= ANDI;
              WHEN RV32I_FN3_ALU_SLL =>
                CASE Funct7 IS
                  WHEN RV32I_FN7_ALU =>
                    Immediate(4 DOWNTO 0) <= instruction(24 DOWNTO 20);
                    Immediate(31 DOWNTO 5) <= std_ulogic_vector(resize(signed(zero(0 DOWNTO 0)),27));
                    Func <= SLLI;
                  WHEN others =>
                    RS2v <= '0';
                    RS2 <= regX;
                    RS1v <= '0';
                    RS1 <= regX;
                    RDv <= '0';
                    RD <= regX;
                    Immediate <= immX;
                    Func <= BAD;
                END CASE;
              WHEN RV32I_FN3_ALU_SRL =>
                CASE Funct7 IS
                  WHEN RV32I_FN7_ALU_SA => 
                    Immediate(4 DOWNTO 0) <= instruction(24 DOWNTO 20);
                    Immediate(31 DOWNTO 5) <= std_ulogic_vector(resize(signed(instruction(31 DOWNTO 31)),27));
                    Func <= SRAI;
                  WHEN RV32I_FN7_ALU =>
                    Immediate(4 DOWNTO 0) <= instruction(24 DOWNTO 20);
                    Immediate(31 DOWNTO 5) <= std_ulogic_vector(resize(signed(zero(0 DOWNTO 0)),27));
                    Func <= SRLI;
                  WHEN others =>
                    RS2v <= '0';
                    RS2 <= regX;
                    RS1v <= '0';
                    RS1 <= regX;
                    RDv <= '0';
                    RD <= regX;
                    Immediate <= immX;
                    Func <= BAD;
                END CASE;
            
              WHEN others =>
                Func <= BAD;
            END CASE;
          
          --01100 (R-type)
          WHEN RV32I_OP_ALU =>
            FuncType <= R;
            RS2 <= instruction(24 DOWNTO 20);
            RS2v <= '1';
            RS1 <= instruction(19 DOWNTO 15);
            RS1v <= '1';
            RD <= instruction(11 DOWNTO 7);
            RDv <= '1';
            Immediate <= immX;
            CASE Funct3 IS
              WHEN RV32I_FN3_ALU_ADD =>
                CASE Funct7 IS
                  WHEN RV32I_FN7_ALU_SUB =>
                    Func <= SUBr;
                  WHEN RV32I_FN7_ALU => 
                    Func <= ADDr;
                  WHEN others => 
                    RS2v <= '0';
                    RS2 <= regX;
                    RS1v <= '0';
                    RS1 <= regX;
                    RDv <= '0';
                    RD <= regX;
                    Immediate <= immX;
                    Func <= BAD;
                END CASE;
              WHEN RV32I_FN3_ALU_SLT =>
                Func <= SLTr;
              WHEN RV32I_FN3_ALU_SLTU =>
                Func <= SLTUr;
              WHEN RV32I_FN3_ALU_XOR =>
                Func <= XORr;
              WHEN RV32I_FN3_ALU_OR =>
                Func <= ORr;
              WHEN RV32I_FN3_ALU_AND =>
                Func <= ANDr;
              WHEN RV32I_FN3_ALU_SLL =>
                Func <= SLLr;
              WHEN RV32I_FN3_ALU_SRL =>
                CASE Funct7 IS
                  WHEN RV32I_FN7_ALU_SA =>
                    Func <= SRAr;
                  WHEN RV32I_FN7_ALU =>
                    Func <= SRLr;
                  WHEN others => 
                    RS2v <= '0';
                    RS2 <= regX;
                    RS1v <= '0';
                    RS1 <= regX;
                    RDv <= '0';
                    RD <= regX;
                    Immediate <= immX;
                    Func <= BAD;
                END CASE;
              WHEN others =>
                RS2v <= '0';
                RS2 <= regX;
                RS1v <= '0';
                RS1 <= regX;
                RDv <= '0';
                RD <= regX;
                Immediate <= immX;
                Func <= BAD;
            END CASE;
            
          WHEN others =>
            RS2v <= '0';
            RS2 <= regX;
            RS1v <= '0';
            RS1 <= regX;
            RDv <= '0';
            RD <= regX;
            Immediate <= immX;
            Func <= BAD;
            
        END CASE;
          
      ELSE
        --Invalid
        FuncType <= R;
        RS2v <= '0';
        RS2 <= regX;
        RS1v <= '0';
        RS1 <= regX;
        RDv <= '0';
        RD <= regX;
        Immediate <= immX;
        Func <= BAD;
      END IF;
    END IF;
  END PROCESS;
END ARCHITECTURE;