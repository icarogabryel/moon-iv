-- ||******************************************||
-- ||                                          ||
-- ||   FEDERAL UNIVERSITY OF PIAUI            ||
-- ||   NATURE SCIENCE CENTER                  ||
-- ||   COMPUTING DEPARTMENT                   ||
-- ||                                          ||
-- ||   Many As Only ONe Quad-Core - MOON IV   ||
-- ||                                          ||
-- ||   Developer: Icaro Gabryel               ||
-- ||                                          ||
-- ||******************************************||

library ieee;
use ieee.std_logic_1164.all;

package opcodes is
    constant nope_opcode : std_logic_vector(5 downto 0) := "000000";

    -- Logical and Arithmetic Operations
    constant add_opcode : std_logic_vector(5 downto 0) := "000001";
    constant sub_opcode : std_logic_vector(5 downto 0) := "000010";

    constant not_opcode  : std_logic_vector(5 downto 0) := "000011";
    constant and_opcode  : std_logic_vector(5 downto 0) := "000100";
    constant or_opcode   : std_logic_vector(5 downto 0) := "000101";
    constant xor_opcode  : std_logic_vector(5 downto 0) := "000110";
    constant nand_opcode : std_logic_vector(5 downto 0) := "000111";
    constant nor_opcode  : std_logic_vector(5 downto 0) := "001000";
    constant xnor_opcode : std_logic_vector(5 downto 0) := "001001";

    constant tmul_opcode : std_logic_vector(5 downto 0) := "001101";
    constant tdiv_opcode : std_logic_vector(5 downto 0) := "001110";

    constant slt_opcode : std_logic_vector(5 downto 0) := "010101";

    -- Shift Operations
    constant sll_opcode : std_logic_vector(5 downto 0) := "001010";
    constant srl_opcode : std_logic_vector(5 downto 0) := "001011";
    constant sra_opcode : std_logic_vector(5 downto 0) := "001100";

    -- Move Operations
    constant mtl_opcode : std_logic_vector(5 downto 0) := "001111";
    constant mfl_opcode : std_logic_vector(5 downto 0) := "010000";
    constant mth_opcode : std_logic_vector(5 downto 0) := "010001";
    constant mfh_opcode : std_logic_vector(5 downto 0) := "010010";

    constant mtac_opcode : std_logic_vector(5 downto 0) := "010011";
    constant mfac_opcode : std_logic_vector(5 downto 0) := "010100";

    -- Inmediate Operations
    constant addi_opcode : std_logic_vector(5 downto 0) := "010110";
    constant subi_opcode : std_logic_vector(5 downto 0) := "010111";

    constant andi_opcode  : std_logic_vector(5 downto 0) := "011000";
    constant ori_opcode   : std_logic_vector(5 downto 0) := "011001";
    constant xori_opcode  : std_logic_vector(5 downto 0) := "011010";
    constant nandi_opcode : std_logic_vector(5 downto 0) := "011011";
    constant nori_opcode  : std_logic_vector(5 downto 0) := "011100";
    constant xnori_opcode : std_logic_vector(5 downto 0) := "011101";

    constant lli_opcode : std_logic_vector(5 downto 0) := "011110";
    constant lui_opcode : std_logic_vector(5 downto 0) := "011111";
    constant lsi_opcode : std_logic_vector(5 downto 0) := "100000";

    -- Memory Access Operations
    constant lwr_opcode  : std_logic_vector(5 downto 0) := "100001";
    constant swr_opcode  : std_logic_vector(5 downto 0) := "100010";
    constant push_opcode : std_logic_vector(5 downto 0) := "100011";
    constant pop_opcode  : std_logic_vector(5 downto 0) := "100100";

    -- Control Operations
    constant jr_opcode  : std_logic_vector(5 downto 0) := "100101";
    constant jrl_opcode : std_logic_vector(5 downto 0) := "100110";
    constant ja_opcode  : std_logic_vector(5 downto 0) := "100111";
    constant jal_opcode : std_logic_vector(5 downto 0) := "101000";

    constant bgtz_opcode : std_logic_vector(5 downto 0) := "101001";
    constant bltz_opcode : std_logic_vector(5 downto 0) := "101010";
    constant beqz_opcode : std_logic_vector(5 downto 0) := "101011";
    constant bnez_opcode : std_logic_vector(5 downto 0) := "101100";

    constant bgtzr_opcode : std_logic_vector(5 downto 0) := "101101";
    constant bltzr_opcode : std_logic_vector(5 downto 0) := "101110";
    constant beqzr_opcode : std_logic_vector(5 downto 0) := "101111";
    constant bnezr_opcode : std_logic_vector(5 downto 0) := "110000";

end package;

package body opcodes is
end package body;
