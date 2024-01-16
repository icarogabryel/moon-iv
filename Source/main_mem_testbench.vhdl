library ieee;
use ieee.std_logic_1164.all;

entity main_mem_testbench is end;

architecture testbench of main_mem_testbench is
    signal clk, rst: std_logic;
    
    constant clk_period: time := 40 ns;
    signal clk_count: integer := 0;

    signal served_out: std_logic_vector(3 downto 0);
    signal request: std_logic;
    signal main_rd_addr: std_logic_vector(15 downto 0);
    signal wr_main_from_data: std_logic;
    signal main_wr_addr: std_logic_vector(15 downto 0);
    signal data_to_main_bk: std_logic_vector(63 downto 0);
    signal wr_cache_from_main: std_logic;
    signal main_to_cache_bk: std_logic_vector(63 downto 0);

    component cometa16_main_mem is
        port(
            clk: in std_logic;
            rst: in std_logic;

            served_out: in std_logic_vector(3 downto 0);

            request: in std_logic;
            main_rd_addr: in std_logic_vector(15 downto 0);

            wr_main_from_data: in std_logic;
            main_wr_addr: in std_logic_vector(15 downto 0);
            data_to_main_bk: in std_logic_vector(63 downto 0);

            wr_cache_from_main: out std_logic;
            main_to_cache_bk: out std_logic_vector(63 downto 0)

        );
    
    end component;

begin
    clock_process: process

    begin
        clk <= '0';
        wait for clk_period/2;

        clk <= '1';
        clk_count <= clk_count + 1;
        wait for clk_period/2;

        if (clk_count = 100) then
            report "ending simulation";
            wait;

        end if;

    end process clock_process;

    reset_process: process
    
    begin
        rst <= '0';
        wait for 10 ns;

        rst <= '1';
        wait for 30 ns;

        rst <= '0';
        wait;
    
    end process reset_process;

    main_mem: cometa16_main_mem
        port map(
            clk => clk,
            rst => rst,

            served_out => served_out,

            request => request,
            main_rd_addr => main_rd_addr,

            wr_main_from_data => wr_main_from_data,
            main_wr_addr => main_wr_addr,
            data_to_main_bk => data_to_main_bk,

            wr_cache_from_main => wr_cache_from_main,
            main_to_cache_bk => main_to_cache_bk
        );
    
    tesbench_process: process

    begin
        served_out <= "1000";
        request <= '1';
        main_rd_addr <= "0000000000000000";
        wr_main_from_data <= '0';
        main_wr_addr <= "0000000000000000";
        data_to_main_bk <= (others => '0');

        wait for 40 ns;

        served_out <= "0001";
        request <= '1';
        main_rd_addr <= "0000000011111111";
        wr_main_from_data <= '0';
        main_wr_addr <= "0000000000000000";
        data_to_main_bk <= (others => '0');

        wait for 40 ns;

    end process;

end testbench;
