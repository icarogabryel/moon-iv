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

entity testbench_main_memory is
end testbench_main_memory;

architecture testbench of testbench_main_memory is
    component cometa16_main_memory
        port(
            clk: in std_logic;
            rst: in std_logic;

            control_wr_main_memory: in std_logic;
            addr: in std_logic_vector(15 downto 0);
            data: in std_logic_vector(15 downto 0);

            main_memory_out: out std_logic_vector(15 downto 0)

        );
    
    end component cometa16_main_memory;

    signal clk: std_logic;
    signal rst: std_logic;
    
    signal control_wr_main_memory: std_logic;
    signal addr: std_logic_vector(15 downto 0);
    signal data: std_logic_vector(15 downto 0);

    signal main_memory_out: std_logic_vector(15 downto 0);

begin
    main_memory: cometa16_main_memory port map(
        clk => clk,
        rst => rst,

        control_wr_main_memory => control_wr_main_memory,
        addr => addr,
        data => data,

        main_memory_out => main_memory_out
    );

    tb: process

    begin
        clk <= '0';
        rst <= '1';

        control_wr_main_memory <= '0';
        addr <= "0000000000000000";
        data <= "0000000000000000";

        wait for 10 ns;
        report "Memory loaded";

        clk <= '1';
        rst <= '0';

        control_wr_main_memory <= '0';
        addr <= "0000000000000000";
        data <= "0000000000000111";

        wait for 10 ns;
        assert main_memory_out = "1000000000000001" report "read test failed!";

        report "Testbench finished" severity note;
        wait;
    
    end process tb;

end testbench;
