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
    signal request0: std_logic;
    signal request1: std_logic;
    signal request2: std_logic;
    signal request3: std_logic;

    signal main_addr0: std_logic_vector(15 downto 0);
    signal main_addr1: std_logic_vector(15 downto 0);
    signal main_addr2: std_logic_vector(15 downto 0);
    signal main_addr3: std_logic_vector(15 downto 0);

    signal wr_main_from_data0: std_logic;
    signal wr_main_from_data1: std_logic;
    signal wr_main_from_data2: std_logic;
    signal wr_main_from_data3: std_logic;

    signal data_to_main_bk0: std_logic_vector(63 downto 0);
    signal data_to_main_bk1: std_logic_vector(63 downto 0);
    signal data_to_main_bk2: std_logic_vector(63 downto 0);
    signal data_to_main_bk3: std_logic_vector(63 downto 0);

    signal main_mem_wr_addr0: std_logic_vector(15 downto 0);
    signal main_mem_wr_addr1: std_logic_vector(15 downto 0);
    signal main_mem_wr_addr2: std_logic_vector(15 downto 0);
    signal main_mem_wr_addr3: std_logic_vector(15 downto 0);

    signal core0_out: std_logic_vector(97 downto 0);
    signal core1_out: std_logic_vector(97 downto 0);
    signal core2_out: std_logic_vector(97 downto 0);
    signal core3_out: std_logic_vector(97 downto 0);
    
    component cometa16_core is
        port(
            clk: in std_logic;
            rst: in std_logic; 

            wr_cache_from_main: in std_logic;
            main_to_cache_bk: in std_logic_vector(63 downto 0);

            request: out std_logic;
            main_addr: out std_logic_vector(15 downto 0);

            wr_main_from_data: out std_logic;
            data_to_main_bk: out std_logic_vector(63 downto 0);
            main_mem_wr_addr: out std_logic_vector(15 downto 0)
            
        );

    end component cometa16_core;

    signal core0_in: std_logic_vector(64 downto 0);
    signal core1_in: std_logic_vector(64 downto 0);
    signal core2_in: std_logic_vector(64 downto 0);
    signal core3_in: std_logic_vector(64 downto 0);

    signal served_out: std_logic_vector(3 downto 0);
    signal main_mem_in: std_logic_vector(97 downto 0);

    component cometa16_css is
        port(
            clk, rst: in std_logic;

            request0: in std_logic;
            request1: in std_logic;
            request2: in std_logic;
            request3: in std_logic;

            core0_in: out std_logic_vector(64 downto 0);
            core1_in: out std_logic_vector(64 downto 0);
            core2_in: out std_logic_vector(64 downto 0);
            core3_in: out std_logic_vector(64 downto 0);

            core0_out: in std_logic_vector(97 downto 0);
            core1_out: in std_logic_vector(97 downto 0);
            core2_out: in std_logic_vector(97 downto 0);
            core3_out: in std_logic_vector(97 downto 0);

            served_out: out std_logic_vector(3 downto 0);

            main_mem_in: out std_logic_vector(97 downto 0);
            main_mem_out: in std_logic_vector(64 downto 0)

        );

    end component cometa16_css;

    signal main_mem_out: std_logic_vector(64 downto 0);

    component cometa16_main_mem is
        port(
            clk: in std_logic;
            rst: in std_logic;

            served_out: in std_logic_vector(3 downto 0);

            ctrl_rd_main_mem: in std_logic;
            rd_addr: in std_logic_vector(15 downto 0);

            ctrl_wr_main_mem: in std_logic;
            main_mem_wr_addr: in std_logic_vector(15 downto 0);
            data_mem_bk_out: in std_logic_vector(63 downto 0);

            main_mem_bk_out: out std_logic_vector(63 downto 0);
            wr_cache_mem: out std_logic

        );

    end component cometa16_main_mem;

begin
    core0_out <= request0 & main_addr0 & wr_main_from_data0 & main_mem_wr_addr0 & data_to_main_bk0;
    core1_out <= request1 & main_addr1 & wr_main_from_data1 & main_mem_wr_addr1 & data_to_main_bk1;
    core2_out <= request2 & main_addr2 & wr_main_from_data2 & main_mem_wr_addr2 & data_to_main_bk2;
    core3_out <= request3 & main_addr3 & wr_main_from_data3 & main_mem_wr_addr3 & data_to_main_bk3;

    core0: cometa16_core
        port map(
            clk => clk,
            rst => rst,

            wr_cache_from_main => core0_in(64),
            main_to_cache_bk => core0_in(63 downto 0),
            
            request => request0,
            main_addr => main_addr0,

            wr_main_from_data => wr_main_from_data0,
            data_to_main_bk => data_to_main_bk0,
            main_mem_wr_addr => main_mem_wr_addr0

        );
    
    core1: cometa16_core
        port map(
            clk => clk,
            rst => rst,

            wr_cache_from_main => core1_in(64),  
            main_to_cache_bk => core1_in(63 downto 0),
            
            request => request1,
            main_addr => main_addr1,

            wr_main_from_data => wr_main_from_data1,
            data_to_main_bk => data_to_main_bk1,
            main_mem_wr_addr => main_mem_wr_addr1

        );

    core2: cometa16_core
        port map(
            clk => clk,
            rst => rst,

            wr_cache_from_main => core2_in(64),  
            main_to_cache_bk => core2_in(63 downto 0),
            
            request => request2,
            main_addr => main_addr2,

            wr_main_from_data => wr_main_from_data2,
            data_to_main_bk => data_to_main_bk2,
            main_mem_wr_addr => main_mem_wr_addr2

        );

    core3: cometa16_core
        port map(
            clk => clk,
            rst => rst,

            wr_cache_from_main => core3_in(64),  
            main_to_cache_bk => core3_in(63 downto 0),
            
            request => request3,
            main_addr => main_addr3,

            wr_main_from_data => wr_main_from_data3,
            data_to_main_bk => data_to_main_bk3,
            main_mem_wr_addr => main_mem_wr_addr3

        );
    
    css: cometa16_css
        port map(
            clk => clk,
            rst => rst,
            
            request0 => request0,
            core0_in => core0_in,
            core0_out => core0_out,

            request1 => request1,
            core1_in => core1_in,
            core1_out => core1_out,

            request2 => request2,
            core2_in => core2_in,
            core2_out => core2_out,

            request3 => request3,
            core3_in => core3_in,
            core3_out => core3_out,

            served_out => served_out,
            main_mem_in => main_mem_in,
            main_mem_out => main_mem_out

        );
    
    main_mem: cometa16_main_mem
        port map(
            clk => clk,
            rst => rst,

            served_out => served_out,

            ctrl_rd_main_mem => main_mem_in(97),
            rd_addr => main_mem_in(96 downto 81),

            ctrl_wr_main_mem => main_mem_in(80),
            main_mem_wr_addr => main_mem_in(79 downto 64),
            data_mem_bk_out => main_mem_in(63 downto 0),

            main_mem_bk_out => main_mem_out(63 downto 0),
            wr_cache_mem => main_mem_out(64)

        );

end architecture behavior_datapath;
