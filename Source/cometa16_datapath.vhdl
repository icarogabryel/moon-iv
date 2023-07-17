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
    signal core0_out: std_logic_vector(97 downto 0);
    signal core1_out: std_logic_vector(97 downto 0);
    signal core2_out: std_logic_vector(97 downto 0);
    signal core3_out: std_logic_vector(97 downto 0);

    signal req0: std_logic;
    signal req1: std_logic;
    signal req2: std_logic;
    signal req3: std_logic;
    
    component cometa16_core is
        port(
            clk:      in std_logic;
            rst:      in std_logic;

            req:      out std_logic;
            core_in:  in std_logic_vector(64 downto 0);
            core_out: out std_logic_vector(97 downto 0)

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

            req0: in std_logic;
            req1: in std_logic;
            req2: in std_logic;
            req3: in std_logic;

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
            main_mem_wr_addr: in std_logic_vector(15 downto 0); --wr_addr
            data_mem_bk_out: in std_logic_vector(63 downto 0); --data_mem_to_css
    
            main_mem_bk_out: out std_logic_vector(63 downto 0);
            wr_cache_mem: out std_logic
    
        );

    end component cometa16_main_mem;

begin 
    core0: cometa16_core
        port map(
            clk => clk,
            rst => rst,

            req => req0,
            core_in => core0_in,
            core_out => core0_out

        );
    
    core1: cometa16_core
        port map(
            clk => clk,
            rst => rst,

            req => req1,
            core_in => core1_in,
            core_out => core1_out

        );

    core2: cometa16_core
        port map(
            clk => clk,
            rst => rst,

            req => req2,
            core_in => core2_in,
            core_out => core2_out

        );

    core3: cometa16_core
        port map(
            clk => clk,
            rst => rst,

            req => req3,
            core_in => core3_in,
            core_out => core3_out

        );
    
    css: cometa16_css
        port map(
            clk => clk,
            rst => rst,
            
            req0 => req0,
            core0_in => core0_in,
            core0_out => core0_out,

            req1 => req1,
            core1_in => core1_in,
            core1_out => core1_out,

            req2 => req2,
            core2_in => core2_in,
            core2_out => core2_out,

            req3 => req3,
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
