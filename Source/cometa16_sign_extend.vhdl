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

entity cometa16_sign_extend is
    port(
        control_sign_extend: in std_logic_vector(1 downto 0);
        imm:                 in std_logic_vector(7 downto 0);

        imm_extended:        out std_logic_vector(15 downto 0)

    );

end cometa16_sign_extend;

architecture behavior_sign_extend of cometa16_sign_extend is

begin
    with control_sign_extend select imm_extended <=
        "00000000" & imm(7 downto 0) when "00",
        imm(7 downto 0) & "00000000" when "01",
        (15 downto 8 => imm(7)) & imm(7 downto 0) when "11",
        "XXXXXXXXXXXXXXXX" when others;

end behavior_sign_extend;
