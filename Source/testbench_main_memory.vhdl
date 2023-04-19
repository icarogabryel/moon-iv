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

            ins_addr: in std_logic_vector(15 downto 0);
            block_out: out std_logic_vector(63 downto 0)

        );
    
    end component cometa16_main_memory;

    CONSTANT clk_period 		: time := 40 ns;

    signal clk: std_logic;
    signal rst: std_logic;

    signal ins_addr: std_logic_vector(15 downto 0);
    signal block_out: std_logic_vector(63 downto 0);

begin
    main_memory: cometa16_main_memory port map(
        clk => clk,
        rst => rst,

        ins_addr => ins_addr,
        block_out => block_out

    );

    clock_process : PROCESS

    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2;
        clk  <= '1';
        WAIT FOR clk_period/2;

    END PROCESS clock_process;

    reset_process : PROCESS

    BEGIN
        rst <= '0';
        WAIT FOR 10 ns;
        rst <= '1';
        WAIT FOR 30 ns;
        rst <= '0';
        WAIT;
    END PROCESS reset_process;

    tb: process

    begin
        ins_addr <= "0000000000000000";

        wait for 40 ns;
        report "Memory loaded";

        ins_addr <= "0000000000000000";

        wait for 40 ns;
        assert block_out = "1000000000000001000000000000000100000000000000010000000000000001" report "read test failed!";

        report "Testbench finished" severity note;
        wait;
    
    end process tb;

end testbench;
