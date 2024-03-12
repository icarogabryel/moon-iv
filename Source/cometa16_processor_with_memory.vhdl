-- ||***************************************************||
-- ||                                                   ||
-- ||   FEDERAL UNIVERSITY OF PIAUI                     ||
-- ||   NATURE SCIENCE CENTER                           ||
-- ||   COMPUTING DEPARTMENT                            ||
-- ||                                                   ||
-- ||   Computer for Every Task Architecture Mark II    ||
-- ||   COMETA MK II                                    ||
-- ||                                                   ||
-- ||   Developer: Icaro Gabryel                        ||
-- ||                                                   ||
-- ||***************************************************||

library ieee;
use ieee.std_logic_1164.all;

entity cometa16_processor_with_memory is
    port(
        clk: in std_logic;
        rst: in std_logic

    );

end entity cometa16_processor_with_memory;

architecture behavior_processor_with_memory of cometa16_processor_with_memory is
    signal request: std_logic;
    signal main_rd_addr: std_logic_vector(15 downto 0);
    signal wr_main_from_data: std_logic;
    signal data_to_main_bk: std_logic_vector(63 downto 0);
    signal main_wr_addr: std_logic_vector(15 downto 0);
    
    component cometa16_processor is
        port(
            clk: in std_logic;
            rst: in std_logic; 

            wr_cache_from_main: in std_logic;
            main_to_cache_bk: in std_logic_vector(63 downto 0);

            request: out std_logic;
            main_rd_addr: out std_logic_vector(15 downto 0);

            wr_main_from_data: out std_logic;
            data_to_main_bk: out std_logic_vector(63 downto 0);
            main_wr_addr: out std_logic_vector(15 downto 0)
            
        );

    end component cometa16_processor;

    signal main_to_cache_bk: std_logic_vector(63 downto 0);
    signal wr_cache_from_main: std_logic;

    component cometa16_main_mem is
        port(
            clk: in std_logic;
            rst: in std_logic;

            request: in std_logic;
            main_rd_addr: in std_logic_vector(15 downto 0);

            wr_main_from_data: in std_logic;
            main_wr_addr: in std_logic_vector(15 downto 0);
            data_to_main_bk: in std_logic_vector(63 downto 0);

            main_to_cache_bk: out std_logic_vector(63 downto 0);
            wr_cache_from_main: out std_logic

        );

    end component cometa16_main_mem;

begin
    processor: cometa16_processor
        port map(
            clk => clk,
            rst => rst,

            wr_cache_from_main => wr_cache_from_main,
            main_to_cache_bk => main_to_cache_bk,
            
            request => request,
            main_rd_addr => main_rd_addr,

            wr_main_from_data => wr_main_from_data,
            data_to_main_bk => data_to_main_bk,
            main_wr_addr => main_wr_addr

        );

    main_mem: cometa16_main_mem
        port map(
            clk => clk,
            rst => rst,

            request => request,
            main_rd_addr => main_rd_addr,

            wr_main_from_data => wr_main_from_data,
            main_wr_addr => main_wr_addr,
            data_to_main_bk => data_to_main_bk,

            wr_cache_from_main => wr_cache_from_main,
            main_to_cache_bk => main_to_cache_bk

        ); 

end architecture behavior_processor_with_memory;
