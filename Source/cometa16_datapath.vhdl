library ieee;
use ieee.std_logic_1164.all;

entity cometa16_datapath is
    port(
        clk: in std_logic;
        rst: in std_logic

    );

end entity cometa16_datapath;

architecture behavior_datapath of cometa16_datapath is
    signal core0_out: std_logic_vector(114 downto 0);
    signal core1_out: std_logic_vector(114 downto 0);
    signal core2_out: std_logic_vector(114 downto 0);
    signal core3_out: std_logic_vector(114 downto 0);
    
    component cometa16_core is
        port(
            clk:      in std_logic;
            rst:      in std_logic;

            core_in:  in std_logic_vector(130 downto 0);
            core_out: out std_logic_vector(114 downto 0)

        );

    end component cometa16_core;

    signal core0_in: std_logic_vector(130 downto 0);
    signal core1_in: std_logic_vector(130 downto 0);
    signal core2_in: std_logic_vector(130 downto 0);
    signal core3_in: std_logic_vector(130 downto 0);

    signal main_mem_in: std_logic_vector(114 downto 0);

    component cometa16_css is
        port(
        rst: in std_logic;

        core0_in: out std_logic_vector(130 downto 0);
        core0_out: in std_logic_vector(114 downto 0);

        core1_in: out std_logic_vector(130 downto 0);
        core1_out: in std_logic_vector(114 downto 0);

        core2_in: out std_logic_vector(130 downto 0);
        core2_out: in std_logic_vector(114 downto 0);

        core3_in: out std_logic_vector(130 downto 0);
        core3_out: in std_logic_vector(114 downto 0);

        main_mem_in: out std_logic_vector(114 downto 0);
        main_mem_out: in std_logic_vector(130 downto 0)

    );

    end component cometa16_css;

    signal main_mem_out: std_logic_vector(130 downto 0);

    component cometa16_main_mem is
        port(
            clk:                        in std_logic;
            rst:                        in std_logic;

            pc_out:                     in std_logic_vector(15 downto 0);
            alu_out:                    in std_logic_vector(15 downto 0);
            
            inst_hit_out:               in std_logic;
            data_hit_out:               in std_logic;

            ctrl_wr_main_mem:           in std_logic;
            main_mem_wr_addr:           in std_logic_vector(15 downto 0);
            data_mem_bk_out:            in std_logic_vector(63 downto 0);

            main_mem_to_inst:           out std_logic_vector(63 downto 0);
            main_mem_to_data:           out std_logic_vector(63 downto 0);
            ctrl_wr_inst_mem_from_main: out std_logic;
            ctrl_wr_data_mem_from_main: out std_logic;

            ctrl_wr_pc:                 out std_logic

        );

    end component cometa16_main_mem;

begin
    core0: cometa16_core
        port map(
            clk => clk,
            rst => rst,

            core_in => core0_in,
            core_out => core0_out

        );
    
    core1: cometa16_core
        port map(
            clk => clk,
            rst => rst,

            core_in => core1_in,
            core_out => core1_out

        );

    core2: cometa16_core
        port map(
            clk => clk,
            rst => rst,

            core_in => core2_in,
            core_out => core2_out

        );

    core3: cometa16_core
        port map(
            clk => clk,
            rst => rst,

            core_in => core3_in,
            core_out => core3_out

        );
    
    css: cometa16_css
        port map(
            rst => rst,

            core0_in => core0_in,
            core0_out => core0_out,

            core1_in => core1_in,
            core1_out => core1_out,

            core2_in => core2_in,
            core2_out => core2_out,

            core3_in => core3_in,
            core3_out => core3_out,

            main_mem_in => main_mem_in,
            main_mem_out => main_mem_out

        );

    main_mem: cometa16_main_mem
        port map(
            clk => clk,
            rst => rst,

            -- Core to main memory
            inst_hit_out => main_mem_in(114),
            data_hit_out => main_mem_in(113),

            pc_out => main_mem_in(112 downto 97),
            alu_out => main_mem_in(96 downto 81),

            ctrl_wr_main_mem => main_mem_in(80),
            main_mem_wr_addr => main_mem_in(79 downto 64),
            data_mem_bk_out => main_mem_in(63 downto 0),

            -- Main memory to core
            ctrl_wr_pc => main_mem_out(130),
            
            ctrl_wr_inst_mem_from_main => main_mem_out(129),
            main_mem_to_inst => main_mem_out(128 downto 65),
            
            ctrl_wr_data_mem_from_main => main_mem_out(64),
            main_mem_to_data => main_mem_out(63 downto 0)
            
        );

end architecture behavior_datapath;
