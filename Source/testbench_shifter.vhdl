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

entity testbench_shifter is
end testbench_shifter;

architecture testbench of testbench_shifter is
    component cometa16_shifter
        port(
            control_shifter: in std_logic_vector(1 downto 0);
            shamt:           in std_logic_vector(3 downto 0);

            alu_out:         in std_logic_vector(15 downto 0);

            shifter_out:     out std_logic_vector(15 downto 0)
        );

    end component cometa16_shifter;

    signal control_shifter: std_logic_vector(1 downto 0);
    signal shamt:           std_logic_vector(3 downto 0);

    signal alu_out:         std_logic_vector(15 downto 0);

    signal shifter_out:     std_logic_vector(15 downto 0);

begin
    shifter: cometa16_shifter port map(
        control_shifter => control_shifter,
        shamt           => shamt,

        alu_out         => alu_out,

        shifter_out     => shifter_out
    );

    tb: process

    begin
        control_shifter <= "00";
        shamt           <= "0010";

        alu_out         <= "0000000000000010";

        wait for 100 ns;
        assert shifter_out = "0000000000000010" report "Transparency test failed!";

        control_shifter <= "01";
        shamt           <= "0010";

        alu_out         <= "1000000000000100";

        wait for 100 ns;
        assert shifter_out = "0010000000000001" report "Right shift test failed!";

        control_shifter <= "10";
        shamt           <= "0010";

        alu_out         <= "1000000000000001";

        wait for 100 ns;
        assert shifter_out = "0000000000000100" report "Left shift test failed!";

        control_shifter <= "11";
        shamt           <= "0010";

        alu_out         <= "1000000000000100";

        wait for 100 ns;
        assert shifter_out = "1110000000000001" report "Right arit shift test failed!";

        report "Testbench finished" severity note;
        wait;

    end process tb;

end testbench;