-- ||***************************************************************||
-- ||                                                               ||
-- ||   FEDERAL UNIVERSITY OF PIAUI                                 ||
-- ||   NATURE SCIENCE CENTER                                       ||
-- ||   COMPUTING DEPARTMENT                                        ||
-- ||                                                               ||
-- ||   Computer for Every Task Architecture 16 Bits - COMETA 16    ||
-- ||                                                               ||
-- ||   Registred in National Institute of Industrial Property      ||
-- ||   (INPI) under the number BR 51 2023 000286 0                 ||
-- ||                                                               ||
-- ||   Developers:                                                 ||
-- ||   - Icaro Gabryel de Araujo Silva                             ||
-- ||   - Fabio Anderson Carvalho Silva                             ||
-- ||   - Cayo Cesar Lopes Mascarenhas Pires Cardoso                ||
-- ||   - Claudiney Ryan da Silva                                   ||
-- ||   - Antonio Geraldo Rego Junior                               ||
-- ||   - Nivaldo Nogueira Paranagua Santos e Silva                 ||
-- ||   - Ivan Saraiva Silva                                        ||
-- ||                                                               ||
-- ||***************************************************************||

library ieee;
use ieee.std_logic_1164.all;

package codops is
    constant nop_ins:   std_logic_vector(5 downto 0) := "000000";

    constant add_ins:   std_logic_vector(5 downto 0) := "000001";
    constant sub_ins:   std_logic_vector(5 downto 0) := "000010";

    constant sll_ins:   std_logic_vector(5 downto 0) := "000011";
    constant srl_ins:   std_logic_vector(5 downto 0) := "000100";
    constant sra_ins:   std_logic_vector(5 downto 0) := "000101";

    constant and_ins:   std_logic_vector(5 downto 0) := "000110";
    constant or_ins:    std_logic_vector(5 downto 0) := "000111";
    constant xor_ins:   std_logic_vector(5 downto 0) := "001000";
    constant nand_ins:  std_logic_vector(5 downto 0) := "001001";
    constant nor_ins:   std_logic_vector(5 downto 0) := "001010";
    constant xnor_ins:  std_logic_vector(5 downto 0) := "001011";

    constant tasm_ins:  std_logic_vector(5 downto 0) := "100110";
    constant tasd_ins:  std_logic_vector(5 downto 0) := "100111";
    constant mtl_ins:   std_logic_vector(5 downto 0) := "101000";
    constant mfl_ins:   std_logic_vector(5 downto 0) := "101001";
    constant mth_ins:   std_logic_vector(5 downto 0) := "101010";
    constant mfh_ins:   std_logic_vector(5 downto 0) := "101011";

    constant mfac_ins:  std_logic_vector(5 downto 0) := "001100";
    constant mtac_ins:  std_logic_vector(5 downto 0) := "001101";

    constant slt_ins:   std_logic_vector(5 downto 0) := "001110";

    constant addi_ins:  std_logic_vector(5 downto 0) := "001111";
    constant subi_ins:  std_logic_vector(5 downto 0) := "010000";

    constant loi_ins:   std_logic_vector(5 downto 0) := "010001";
    constant lui_ins:   std_logic_vector(5 downto 0) := "010010";
    constant lis_ins:   std_logic_vector(5 downto 0) := "010011";

    constant andi_ins:  std_logic_vector(5 downto 0) := "010100";
    constant ori_ins:   std_logic_vector(5 downto 0) := "010101";
    constant xori_ins:  std_logic_vector(5 downto 0) := "010110";
    constant nandi_ins: std_logic_vector(5 downto 0) := "010111";
    constant nori_ins:  std_logic_vector(5 downto 0) := "011000";
    constant xnori_ins: std_logic_vector(5 downto 0) := "011001";

    constant lwr_ins:   std_logic_vector(5 downto 0) := "011010";
    constant swr_ins:   std_logic_vector(5 downto 0) := "011011";
    constant push_ins:  std_logic_vector(5 downto 0) := "011100";
    constant pop_ins:   std_logic_vector(5 downto 0) := "011101";

    constant j_ins:     std_logic_vector(5 downto 0) := "011110";
    constant jal_ins:   std_logic_vector(5 downto 0) := "011111";
    constant jr_ins:    std_logic_vector(5 downto 0) := "100000";
    constant jral_ins:  std_logic_vector(5 downto 0) := "100001";

    constant jgtz_ins:  std_logic_vector(5 downto 0) := "100010";
    constant jltz_ins:  std_logic_vector(5 downto 0) := "100011";
    constant jnez_ins:  std_logic_vector(5 downto 0) := "100100";
    constant jize_ins:  std_logic_vector(5 downto 0) := "100101";

end package;

package body codops is

end package body;
