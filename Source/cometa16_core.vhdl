-- ||****************************************************************||
-- ||                                                                ||
-- ||   FEDERAL UNIVERSITY OF PIAUI                                  ||
-- ||   NATURE SCIENCE CENTER                                        ||
-- ||   COMPUTING DEPARTMENT                                         ||
-- ||                                                                ||
-- ||   Computer for Every Task Architecture 16 Bits Generation 2    ||
-- ||   COMETA 16 G2                                                 ||
-- ||                                                                ||
-- ||   Developer: Icaro Gabryel de Araujo Silva                     ||
-- ||                                                                ||
-- ||****************************************************************||

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cometa16_core is
    port(
        clk: in std_logic;
        rst: in std_logic

        -- main_mem_out: in std_logic_vector(63 downto 0);
        -- pc_out: out std_logic_vector(15 downto 0);
    );

end cometa16_core;

architecture behavior_core of cometa16_core is
    signal ctrl_dvc:         std_logic_vector(2 downto 0);
    signal ctrl_dvi:         std_logic_vector(1 downto 0);

    signal ctrl_stk:         std_logic_vector(1 downto 0);
    signal ctrl_wr_rf:       std_logic;
    signal ctrl_src_rf:      std_logic;

    signal ctrl_wr_ac:       std_logic;
    signal ctrl_src_ac:      std_logic_vector(2 downto 0);

    signal ctrl_wr_hilo:     std_logic;
    signal ctrl_src_hilo:    std_logic_vector(1 downto 0);

    signal ctrl_sign_extend: std_logic_vector(1 downto 0);

    signal ctrl_src_alu_a:   std_logic;
    signal ctrl_src_alu_b:   std_logic_vector(1 downto 0);
    signal ctrl_alu:         std_logic_vector(3 downto 0);

    signal ctrl_shifter:     std_logic_vector(1 downto 0);

    signal ctrl_wr_data_mem: std_logic;

    component cometa16_controller is
        port(
            opcode:           in std_logic_vector(5 downto 0);
    
            ctrl_dvc:         out std_logic_vector(2 downto 0);
            ctrl_dvi:         out std_logic_vector(1 downto 0);
    
            ctrl_stk:         out std_logic_vector(1 downto 0);
            ctrl_wr_rf:       out std_logic;
            ctrl_src_rf:      out std_logic;
        
            ctrl_wr_ac:       out std_logic;
            ctrl_src_ac:      out std_logic_vector(2 downto 0);
        
            ctrl_wr_hilo:     out std_logic;
            ctrl_src_hilo:    out std_logic_vector(1 downto 0);
        
            ctrl_sign_extend: out std_logic_vector(1 downto 0);
        
            ctrl_src_alu_a:   out std_logic;
            ctrl_src_alu_b:   out std_logic_vector(1 downto 0);
            ctrl_alu:         out std_logic_vector(3 downto 0);
        
            ctrl_shifter:     out std_logic_vector(1 downto 0);

            ctrl_wr_data_mem: out std_logic
    
        );

    end component;

    signal pc_out: std_logic_vector(15 downto 0);
    signal pc_plus_one: std_logic_vector(15 downto 0);

    component cometa16_pc is
        port(
            clk, rst:        in std_logic;
    
            z_signal:        in std_logic;
            n_signal:        in std_logic;
    
            ctrl_dvc:        in std_logic_vector(2 downto 0);
            ctrl_dvi:        in std_logic_vector(1 downto 0);

            hit_out:         in std_logic;

            rf1_out:         in std_logic_vector(15 downto 0);
            ins_mux:         in std_logic_vector(15 downto 0);
            sign_extend_out: in std_logic_vector(15 downto 0);
    
            pc_out:          out std_logic_vector(15 downto 0);
            pc_plus_one:     out std_logic_vector(15 downto 0)
    
        );

    end component;

    signal ins_mux: std_logic_vector(15 downto 0);
    signal hit_out: std_logic;

    component cometa16_instruction_memory is
        port(
            clk: in std_logic;
            rst: in std_logic;
    
            pc_out: in std_logic_vector(15 downto 0);
            main_mem_out: in std_logic_vector(63 downto 0);
            ctrl_wr_ins_mem: in std_logic;
    
            ins_mux: out std_logic_vector(15 downto 0);
            hit_out: out std_logic
    
        );

    end component;
    
    signal rd_time: std_logic_vector(9 downto 0);
    signal main_mem_out: std_logic_vector(63 downto 0);

    component cometa16_main_memory is
        port(
            clk: in std_logic;
            rst: in std_logic;

            pc_out:       in std_logic_vector(15 downto 0);
            rd_time:      out std_logic_vector(9 downto 0);
            main_mem_out: out std_logic_vector(63 downto 0)

        );

    end component;

    signal ctrl_wr_ins_mem: std_logic;

    component cometa16_miss_penalty_unit is
        port(
            clk: in std_logic;
            rst: in std_logic;

            hit_out: in std_logic;
            rd_time: in std_logic_vector(9 downto 0);

            ctrl_wr_ins_mem: out std_logic

        );

    end component;

    signal opcode:   std_logic_vector(5 downto 0);
    signal ac_addr:  std_logic_vector(1 downto 0);
    signal rf1_addr: std_logic_vector(3 downto 0);
    signal rf2_addr: std_logic_vector(3 downto 0);
    signal imm:      std_logic_vector(7 downto 0);

    signal rf1_out: std_logic_vector(15 downto 0);
    signal rf2_out: std_logic_vector(15 downto 0);

    component cometa16_rf_registers is
        port(
            clk: in std_logic;
            rst: in std_logic;
    
            ctrl_wr_rf: in std_logic;
            ctrl_src_rf: in std_logic;
    
            ctrl_stk:  in std_logic_vector(1 downto 0);
    
            pc_plus_one: in std_logic_vector(15 downto 0);
            ac_out: in std_logic_vector(15 downto 0);
    
            rf1_addr: in std_logic_vector(3 downto 0);
            rf2_addr: in std_logic_vector(3 downto 0);
    
            rf1_out : out std_logic_vector(15 downto 0);
            rf2_out : out std_logic_vector(15 downto 0)
    
        );
    
    end component;

    signal ac_out: std_logic_vector(15 downto 0);

    component cometa16_ac_registers is
        port(
            clk: in std_logic;
            rst: in std_logic;
    
            ctrl_wr_ac:   in std_logic;
            ctrl_src_ac:  in std_logic_vector(2 downto 0);
    
            alu_out:      in std_logic_vector(15 downto 0);
            data_mem_out: in std_logic_vector(15 downto 0);
            n_signal:     in std_logic;
            hi_out:       in std_logic_vector(15 downto 0);
            lo_out:       in std_logic_vector(15 downto 0);
    
            ac_addr:      in std_logic_vector(1 downto 0);
            ac_out:       out std_logic_vector(15 downto 0)
    
        );

    end component;

    signal lo_out: std_logic_vector(15 downto 0);
    signal hi_out: std_logic_vector(15 downto 0);
    
    component cometa16_hilo is
        port(
        clk: in std_logic;
        rst: in std_logic;

        ctrl_wr_hilo:  in std_logic;
        ctrl_src_hilo: in std_logic_vector(1 downto 0);

        alu_out:       in std_logic_vector(15 downto 0);
        ac_out:        in std_logic_vector(15 downto 0);

        lo_out:        out std_logic_vector(15 downto 0);
        hi_out:        out std_logic_vector(15 downto 0)

        );

    end component;

    signal sign_extend_out: std_logic_vector(15 downto 0);

    component cometa16_sign_extend is
        port(
        ctrl_sign_extend: in std_logic_vector(1 downto 0);
        imm:              in std_logic_vector(7 downto 0);

        sign_extend_out:  out std_logic_vector(15 downto 0)

        );

    end component;

    signal z_signal: std_logic;
    signal n_signal: std_logic;
    signal alu_out: std_logic_vector(15 downto 0);

    component cometa16_alu is
        port(
            ctrl_alu:        in std_logic_vector(3 downto 0);
            ctrl_src_alu_a:  in std_logic;
            ctrl_src_alu_b:  in std_logic_vector(1 downto 0);

            rf1_out:         in std_logic_vector(15 downto 0);
            rf2_out:         in std_logic_vector(15 downto 0);

            ac_out:          in std_logic_vector(15 downto 0);
            sign_extend_out: in std_logic_vector(15 downto 0);
            hi_out:          in std_logic_vector(15 downto 0);

            z_signal:        out std_logic;
            n_signal:        out std_logic;

            alu_out:         out std_logic_vector(15 downto 0)
        );

    end component;

    signal shifter_out: std_logic_vector(15 downto 0);

    component cometa16_shifter is
        port(
            ctrl_shifter: in std_logic_vector(1 downto 0);
            shamt:           in std_logic_vector(3 downto 0);

            alu_out:         in std_logic_vector(15 downto 0);

            shifter_out:     out std_logic_vector(15 downto 0)
        );

    end component;

    signal data_mem_out: std_logic_vector(15 downto 0);

    component cometa16_data_memory is
        port(
            clk: in std_logic;
            rst: in std_logic;

            ctrl_wr_data_mem: in std_logic;

            alu_out: in std_logic_vector(15 downto 0);
            ac_out: in std_logic_vector(15 downto 0);

            data_mem_out: out std_logic_vector(15 downto 0)

        );
    
    end component;

begin
    opcode   <= ins_mux(15 downto 10);
    ac_addr  <= ins_mux(9 downto 8);
    rf1_addr <= ins_mux(7 downto 4);
    rf2_addr <= ins_mux(3 downto 0);
    imm      <= ins_mux(7 downto 0);

    controller: cometa16_controller
        port map(
            opcode          => opcode,
    
            ctrl_dvc         => ctrl_dvc,
            ctrl_dvi         => ctrl_dvi,
    
            ctrl_stk         => ctrl_stk,
            ctrl_wr_rf       => ctrl_wr_rf,
            ctrl_src_rf      => ctrl_src_rf,
        
            ctrl_wr_ac       => ctrl_wr_ac,
            ctrl_src_ac      => ctrl_src_ac,
        
            ctrl_wr_hilo     => ctrl_wr_hilo,
            ctrl_src_hilo    => ctrl_src_hilo,
        
            ctrl_sign_extend => ctrl_sign_extend,
        
            ctrl_src_alu_a   => ctrl_src_alu_a,
            ctrl_src_alu_b   => ctrl_src_alu_b,
            ctrl_alu         => ctrl_alu,
        
            ctrl_shifter     => ctrl_shifter
    
        );
    
    pc: cometa16_pc
        port map(
            clk => clk,
            rst => rst,

            z_signal => z_signal,
            n_signal => n_signal,
    
            ctrl_dvc => ctrl_dvc,
            ctrl_dvi => ctrl_dvi,
            hit_out => hit_out,

            rf1_out => rf1_out,
            ins_mux => ins_mux,
            sign_extend_out => sign_extend_out,
    
            pc_out => pc_out,
            pc_plus_one => pc_plus_one
    
        );

    instruction_memory: cometa16_instruction_memory
        port map(
            clk => clk,
            rst => rst,

            pc_out => pc_out,
            main_mem_out => main_mem_out,
            ctrl_wr_ins_mem => ctrl_wr_ins_mem,

            ins_mux => ins_mux,
            hit_out => hit_out

        );

    main_memory: cometa16_main_memory
        port map(
            clk => clk,
            rst => rst,

            pc_out => pc_out,
            rd_time => rd_time,
            main_mem_out => main_mem_out

        );

    miss_penalty_unit: cometa16_miss_penalty_unit
        port map(
            clk => clk,
            rst => rst,

            hit_out => hit_out,
            rd_time => rd_time,
            ctrl_wr_ins_mem => ctrl_wr_ins_mem

        );

    rf_registers: cometa16_rf_registers
        port map(
            clk => clk,
            rst => rst,

            ctrl_wr_rf => ctrl_wr_rf,
            ctrl_src_rf => ctrl_src_rf,

            ctrl_stk => ctrl_stk,

            pc_plus_one => pc_plus_one,
            ac_out => ac_out,
            rf1_addr => rf1_addr,
            rf2_addr => rf2_addr,

            rf1_out => rf1_out,
            rf2_out => rf2_out

        );

    ac_registers: cometa16_ac_registers
        port map(
            clk => clk,
            rst => rst,

            ctrl_wr_ac => ctrl_wr_ac,
            ctrl_src_ac => ctrl_src_ac,

            alu_out => alu_out,
            data_mem_out => data_mem_out,
            n_signal => n_signal,
            hi_out => hi_out,
            lo_out => lo_out,

            ac_addr => ac_addr,
            ac_out => ac_out

        );

    hilo: cometa16_hilo
        port map(
            clk => clk,
            rst => rst,

            ctrl_wr_hilo => ctrl_wr_hilo,
            ctrl_src_hilo => ctrl_src_hilo,

            alu_out => alu_out,
            ac_out => ac_out,

            lo_out => lo_out,
            hi_out => hi_out

        );

    sign_extend: cometa16_sign_extend
        port map(
            ctrl_sign_extend => ctrl_sign_extend,
            imm => imm,

            sign_extend_out => sign_extend_out

        );

    alu: cometa16_alu
        port map(
            ctrl_alu => ctrl_alu,
            ctrl_src_alu_a => ctrl_src_alu_a,
            ctrl_src_alu_b => ctrl_src_alu_b,
    
            rf1_out => rf1_out,
            rf2_out => rf2_out,
    
            ac_out => ac_out,
            sign_extend_out => sign_extend_out,
            hi_out => hi_out,
    
            z_signal => z_signal,
            n_signal => n_signal,
    
            alu_out => alu_out

        );

    shifter: cometa16_shifter
        port map(
            ctrl_shifter => ctrl_shifter,
            shamt => rf2_addr,

            alu_out => alu_out,

            shifter_out => shifter_out

        );

    data_memory: cometa16_data_memory
        port map(
            clk => clk,
            rst => rst,

            ctrl_wr_data_mem => ctrl_wr_data_mem,

            alu_out => alu_out,
            ac_out => ac_out,

            data_mem_out => data_mem_out

        );

end behavior_core;
