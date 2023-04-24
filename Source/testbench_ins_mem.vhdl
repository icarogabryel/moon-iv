library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity testbench_ins_mem is
end testbench_ins_mem;

architecture testbench of testbench_ins_mem is
    constant clk_period: time := 40 ns;

    signal clk: std_logic;
    signal rst: std_logic;

    signal hit_bus: std_logic;
    signal ctrl_ins_mem_wr_bus: std_logic;
    signal main_mem_data_read_bus: std_logic_vector(63 downto 0);
    signal pc_out_bus: std_logic_vector(15 downto 0);
    signal rd_time_bus: std_logic_vector(9 downto 0);
    signal ins_mux_out_bus: std_logic_vector(15 downto 0);

    -- PC Register
    component pc_reg
        port(
            clk: in std_logic;
            rst: in std_logic;

            hit: in std_logic;
            pc_out: out std_logic_vector(15 downto 0)

        );
    
    end component pc_reg;

    -- Instruction Memory
    component cometa16_instruction_memory
        port(
            clk: in std_logic;
            rst: in std_logic;

            pc_out: in std_logic_vector(15 downto 0);
            main_mem_data_read: in std_logic_vector(63 downto 0);
            ctrl_ins_mem_wr: in std_logic;

            ins_mux_out: out std_logic_vector(15 downto 0);
            hit_out: out std_logic

        );
    
    end component cometa16_instruction_memory;

    -- Main Memory
    component cometa16_main_memory
        port(
            clk: in std_logic;
            rst: in std_logic;

            ins_addr:        in std_logic_vector(15 downto 0);
            rd_time:         out std_logic_vector(9 downto 0);
            main_mem_out:       out std_logic_vector(63 downto 0)

        );
    
    end component cometa16_main_memory;

    -- Miss Penalty Unit
    component cometa16_miss_penalty_unit
        port(
            clk: in std_logic;
            rst: in std_logic;

            hit: in std_logic;
            rd_time: in std_logic_vector(9 downto 0);

            ctrl_ins_mem_wr: out std_logic

        );
    
    end component cometa16_miss_penalty_unit;

begin
    pc: pc_reg port map(
        clk => clk,
        rst => rst,

        hit => hit_bus,
        pc_out => pc_out_bus
    );

    ins_mem: cometa16_instruction_memory port map(
        clk => clk,
        rst => rst,

        pc_out => pc_out_bus,
        main_mem_data_read => main_mem_data_read_bus,
        ctrl_ins_mem_wr => ctrl_ins_mem_wr_bus,

        ins_mux_out => ins_mux_out_bus,
        hit_out => hit_bus
    );

    main_mem: cometa16_main_memory port map(
        clk => clk,
        rst => rst,

        ins_addr => pc_out_bus,
        rd_time => rd_time_bus,
        main_mem_out => main_mem_data_read_bus
    );

    miss_penalty_unit: cometa16_miss_penalty_unit port map(
        clk => clk,
        rst => rst,

        hit => hit_bus,
        rd_time => rd_time_bus,

        ctrl_ins_mem_wr => ctrl_ins_mem_wr_bus
    );

    clock_process: process

    begin
        clk <= '0';
        wait for clk_period/2;
        clk  <= '1';
        wait for clk_period/2;

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

end testbench;
