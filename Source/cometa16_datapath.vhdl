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

entity cometa16_datapath is
    port(
        clk: in std_logic;
        rst: in std_logic

    );

end entity cometa16_datapath;

architecture behavior_datapath of cometa16_datapath is
    signal request_0: std_logic;
    signal request_1: std_logic;
    signal request_2: std_logic;
    signal request_3: std_logic;

    signal main_rd_addr_0: std_logic_vector(15 downto 0);
    signal main_rd_addr_1: std_logic_vector(15 downto 0);
    signal main_rd_addr_2: std_logic_vector(15 downto 0);
    signal main_rd_addr_3: std_logic_vector(15 downto 0);

    signal wr_main_from_data_0: std_logic;
    signal wr_main_from_data_1: std_logic;
    signal wr_main_from_data_2: std_logic;
    signal wr_main_from_data_3: std_logic;

    signal data_to_main_bk_0: std_logic_vector(63 downto 0);
    signal data_to_main_bk_1: std_logic_vector(63 downto 0);
    signal data_to_main_bk_2: std_logic_vector(63 downto 0);
    signal data_to_main_bk_3: std_logic_vector(63 downto 0);

    signal main_wr_addr_0: std_logic_vector(15 downto 0);
    signal main_wr_addr_1: std_logic_vector(15 downto 0);
    signal main_wr_addr_2: std_logic_vector(15 downto 0);
    signal main_wr_addr_3: std_logic_vector(15 downto 0);

    signal core_out_0: std_logic_vector(97 downto 0);
    signal core_out_1: std_logic_vector(97 downto 0);
    signal core_out_2: std_logic_vector(97 downto 0);
    signal core_out_3: std_logic_vector(97 downto 0);
    
    component cometa16_core is
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

    end component cometa16_core;

    signal core_in_0: std_logic_vector(64 downto 0);
    signal core_in_1: std_logic_vector(64 downto 0);
    signal core_in_2: std_logic_vector(64 downto 0);
    signal core_in_3: std_logic_vector(64 downto 0);
    
    signal main_mem_in: std_logic_vector(97 downto 0);

    component cometa16_css is
        port(
            clk, rst: in std_logic;

            request_0: in std_logic;
            request_1: in std_logic;
            request_2: in std_logic;
            request_3: in std_logic;

            core_in_0: out std_logic_vector(64 downto 0);
            core_in_1: out std_logic_vector(64 downto 0);
            core_in_2: out std_logic_vector(64 downto 0);
            core_in_3: out std_logic_vector(64 downto 0);

            core_out_0: in std_logic_vector(97 downto 0);
            core_out_1: in std_logic_vector(97 downto 0);
            core_out_2: in std_logic_vector(97 downto 0);
            core_out_3: in std_logic_vector(97 downto 0);

            main_mem_in: out std_logic_vector(97 downto 0);
            main_mem_out: in std_logic_vector(64 downto 0)

        );

    end component cometa16_css;

    signal main_mem_out: std_logic_vector(64 downto 0);

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
    core_out_0 <= request_0 & main_rd_addr_0 & wr_main_from_data_0 & main_wr_addr_0 & data_to_main_bk_0;
    core_out_1 <= request_1 & main_rd_addr_1 & wr_main_from_data_1 & main_wr_addr_1 & data_to_main_bk_1;
    core_out_2 <= request_2 & main_rd_addr_2 & wr_main_from_data_2 & main_wr_addr_2 & data_to_main_bk_2;
    core_out_3 <= request_3 & main_rd_addr_3 & wr_main_from_data_3 & main_wr_addr_3 & data_to_main_bk_3;

    core_0: cometa16_core
        port map(
            clk => clk,
            rst => rst,

            wr_cache_from_main => core_in_0(64),
            main_to_cache_bk => core_in_0(63 downto 0),
            
            request => request_0,
            main_rd_addr => main_rd_addr_0,

            wr_main_from_data => wr_main_from_data_0,
            data_to_main_bk => data_to_main_bk_0,
            main_wr_addr => main_wr_addr_0

        );
    
    core_1: cometa16_core
        port map(
            clk => clk,
            rst => rst,

            wr_cache_from_main => core_in_1(64),  
            main_to_cache_bk => core_in_1(63 downto 0),
            
            request => request_1,
            main_rd_addr => main_rd_addr_1,

            wr_main_from_data => wr_main_from_data_1,
            data_to_main_bk => data_to_main_bk_1,
            main_wr_addr => main_wr_addr_1

        );

    core_2: cometa16_core
        port map(
            clk => clk,
            rst => rst,

            wr_cache_from_main => core_in_2(64),  
            main_to_cache_bk => core_in_2(63 downto 0),
            
            request => request_2,
            main_rd_addr => main_rd_addr_2,

            wr_main_from_data => wr_main_from_data_2,
            data_to_main_bk => data_to_main_bk_2,
            main_wr_addr => main_wr_addr_2

        );

    core_3: cometa16_core
        port map(
            clk => clk,
            rst => rst,

            wr_cache_from_main => core_in_3(64),  
            main_to_cache_bk => core_in_3(63 downto 0),
            
            request => request_3,
            main_rd_addr => main_rd_addr_3,

            wr_main_from_data => wr_main_from_data_3,
            data_to_main_bk => data_to_main_bk_3,
            main_wr_addr => main_wr_addr_3

        );
    
    css: cometa16_css
        port map(
            clk => clk,
            rst => rst,
            
            request_0 => request_0,
            core_in_0 => core_in_0,
            core_out_0 => core_out_0,

            request_1 => request_1,
            core_in_1 => core_in_1,
            core_out_1 => core_out_1,

            request_2 => request_2,
            core_in_2 => core_in_2,
            core_out_2 => core_out_2,

            request_3 => request_3,
            core_in_3 => core_in_3,
            core_out_3 => core_out_3,

            main_mem_in => main_mem_in,
            main_mem_out => main_mem_out

        );

    main_mem: cometa16_main_mem
        port map(
            clk => clk,
            rst => rst,

            request => main_mem_in(97),
            main_rd_addr => main_mem_in(96 downto 81),

            wr_main_from_data => main_mem_in(80),
            main_wr_addr => main_mem_in(79 downto 64),
            data_to_main_bk => main_mem_in(63 downto 0),

            wr_cache_from_main => main_mem_out(64),
            main_to_cache_bk => main_mem_out(63 downto 0)

        );        

end architecture behavior_datapath;
