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

entity testbench_sign_extend is
end testbench_sign_extend;

architecture testbench of testbench_sign_extend is
    component cometa16_sign_extend
        port(
            control_sign_extend: in std_logic_vector(1 downto 0);
            imm:                 in std_logic_vector(7 downto 0);

            imm_extended:        out std_logic_vector(15 downto 0)

        );

    end component cometa16_sign_extend;

    signal control_sign_extend: std_logic_vector(1 downto 0);
    signal imm:                 std_logic_vector(7 downto 0);

    signal imm_extended:        std_logic_vector(15 downto 0);

begin
    sign_extend: cometa16_sign_extend port map(
        control_sign_extend => control_sign_extend,
        imm                 => imm,

        imm_extended        => imm_extended
    );

    tb: process

    begin
        control_sign_extend <= "11";
        imm                 <= "10001001";

        wait for 100 ns;
        assert imm_extended = "1111111110001001" report "arithmetical sign extend failed" severity note;

        report "Testbench finished" severity note;
        wait;

    end process tb;

end testbench;