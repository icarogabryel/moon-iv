-- ||****************************************************************||
-- ||                                                                ||
-- ||   FEDERAL UNIVERSITY OF PIAUI                                  ||
-- ||   NATURE SCIENCE CENTER                                        ||
-- ||   COMPUTING DEPARTMENT                                         ||
-- ||                                                                ||
-- ||   Computer for Every Task Architecture 16 Bits Generation 2    ||
-- ||   COMETA 16 G2                                                 ||
-- ||                                                                ||
-- ||   Developer: Icaro Gabryel de Araujo Silva                     ||
-- ||                                                                ||
-- ||****************************************************************||

library ieee;
use ieee.std_logic_1164.all;

package codops is
    constant nope_opcode:  std_logic_vector(5 downto 0) := "000000";

    -- Logical and Arithmetic Operations
    constant add_opcode:   std_logic_vector(5 downto 0) := "000001";
    constant sub_opcode:   std_logic_vector(5 downto 0) := "000010";

    constant sll_opcode:   std_logic_vector(5 downto 0) := "000011";
    constant srl_opcode:   std_logic_vector(5 downto 0) := "000100";
    constant sra_opcode:   std_logic_vector(5 downto 0) := "000101";

    constant and_opcode:   std_logic_vector(5 downto 0) := "000110";
    constant or_opcode:    std_logic_vector(5 downto 0) := "000111";
    constant xor_opcode:   std_logic_vector(5 downto 0) := "001000";
    constant nand_opcode:  std_logic_vector(5 downto 0) := "001001";
    constant nor_opcode:   std_logic_vector(5 downto 0) := "001010";
    constant xnor_opcode:  std_logic_vector(5 downto 0) := "001011";

    constant tasm_opcode:  std_logic_vector(5 downto 0) := "001100";
    constant tasd_opcode:  std_logic_vector(5 downto 0) := "001101";
    constant mtl_opcode:   std_logic_vector(5 downto 0) := "001110";
    constant mfl_opcode:   std_logic_vector(5 downto 0) := "001111";
    constant mth_opcode:   std_logic_vector(5 downto 0) := "010000";
    constant mfh_opcode:   std_logic_vector(5 downto 0) := "010001";

    constant mtac_opcode:  std_logic_vector(5 downto 0) := "010010";
    constant mfac_opcode:  std_logic_vector(5 downto 0) := "010011";

    constant slt_opcode:   std_logic_vector(5 downto 0) := "010100";

    -- Inmediate Operations
    constant addi_opcode:  std_logic_vector(5 downto 0) := "010101";
    constant subi_opcode:  std_logic_vector(5 downto 0) := "010110";

    constant loi_opcode:   std_logic_vector(5 downto 0) := "010111";
    constant lui_opcode:   std_logic_vector(5 downto 0) := "011000";
    constant lis_opcode:   std_logic_vector(5 downto 0) := "011001";

    constant andi_opcode:  std_logic_vector(5 downto 0) := "011010";
    constant ori_opcode:   std_logic_vector(5 downto 0) := "011011";
    constant xori_opcode:  std_logic_vector(5 downto 0) := "011100";
    constant nandi_opcode: std_logic_vector(5 downto 0) := "011101";
    constant nori_opcode:  std_logic_vector(5 downto 0) := "011110";
    constant xnori_opcode: std_logic_vector(5 downto 0) := "011111";

    -- Memory Access Operations
    constant lwr_opcode:   std_logic_vector(5 downto 0) := "100000";
    constant swr_opcode:   std_logic_vector(5 downto 0) := "100001";
    constant push_opcode:  std_logic_vector(5 downto 0) := "100010";
    constant pop_opcode:   std_logic_vector(5 downto 0) := "100011";

    -- Control Operations
    constant j_opcode:     std_logic_vector(5 downto 0) := "100100";
    constant jal_opcode:   std_logic_vector(5 downto 0) := "100101";
    constant jr_opcode:    std_logic_vector(5 downto 0) := "100110";
    constant jral_opcode:  std_logic_vector(5 downto 0) := "100111";

    constant jgtz_opcode:  std_logic_vector(5 downto 0) := "101000";
    constant jltz_opcode:  std_logic_vector(5 downto 0) := "101001";
    constant jnez_opcode:  std_logic_vector(5 downto 0) := "101010";
    constant jize_opcode:  std_logic_vector(5 downto 0) := "101011";

end package;

package body codops is

end package body;
