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

entity cometa16_core is
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

end cometa16_core;

architecture behavior_core of cometa16_core is
    -- Controller signals
    signal ctrl_cj:          std_logic_vector(2 downto 0);
    signal ctrl_ij:          std_logic_vector(1 downto 0);

    signal ctrl_stk:          std_logic_vector(1 downto 0);
    signal ctrl_lk:           std_logic;
    signal ctrl_wr_rf:        std_logic;
    signal ctrl_src_rf:       std_logic;

    signal ctrl_wr_ac:        std_logic;
    signal ctrl_src_ac:       std_logic_vector(2 downto 0);

    signal ctrl_wr_hilo:      std_logic;
    signal ctrl_src_hilo:     std_logic_vector(1 downto 0);

    signal ctrl_sign_extend:  std_logic_vector(1 downto 0);

    signal ctrl_src_alu_a:    std_logic;
    signal ctrl_src_alu_b:    std_logic_vector(1 downto 0);
    signal ctrl_alu:          std_logic_vector(3 downto 0);

    signal ctrl_sh:           std_logic_vector(1 downto 0);

    signal ctrl_wr_data_mem:  std_logic;
    signal ctrl_data_mem_use: std_logic;

    component cometa16_controller is
        port(
            opcode:            in std_logic_vector(5 downto 0);
    
            ctrl_cj:           out std_logic_vector(2 downto 0);
            ctrl_ij:           out std_logic_vector(1 downto 0);
    
            ctrl_stk:          out std_logic_vector(1 downto 0);
            ctrl_lk:           out std_logic;
            ctrl_wr_rf:        out std_logic;
            ctrl_src_rf:       out std_logic;
        
            ctrl_wr_ac:        out std_logic;
            ctrl_src_ac:       out std_logic_vector(2 downto 0);
        
            ctrl_wr_hilo:      out std_logic;
            ctrl_src_hilo:     out std_logic_vector(1 downto 0);
        
            ctrl_sign_extend:  out std_logic_vector(1 downto 0);
        
            ctrl_src_alu_a:    out std_logic;
            ctrl_src_alu_b:    out std_logic_vector(1 downto 0);
            ctrl_alu:          out std_logic_vector(3 downto 0);
        
            ctrl_sh:           out std_logic_vector(1 downto 0);

            ctrl_wr_data_mem:  out std_logic;
            ctrl_data_mem_use: out std_logic
    
        );

    end component;

    signal pc_out: std_logic_vector(15 downto 0);
    signal pc_plus_one: std_logic_vector(15 downto 0);

    component cometa16_pc is
        port(
            clk: in std_logic;
            rst: in std_logic;

            z_signal:        in std_logic;
            n_signal:        in std_logic;

            ctrl_cj:         in std_logic_vector(2 downto 0);
            ctrl_ij:         in std_logic_vector(1 downto 0);

            rf1_out:         in std_logic_vector(15 downto 0);
            inst_mem_out:    in std_logic_vector(15 downto 0);
            sign_extend_out: in std_logic_vector(15 downto 0);

            hit_signal:      in std_logic;

            pc_out:          out std_logic_vector(15 downto 0);
            pc_plus_one:     out std_logic_vector(15 downto 0)

        );

    end component;

    signal inst_hit_out: std_logic;
    signal inst_mem_out: std_logic_vector(15 downto 0);

    component cometa16_inst_mem is
        port(
            clk: in std_logic;
            rst: in std_logic;

            pc_out: in std_logic_vector(15 downto 0);

            main_to_inst_bk: in std_logic_vector(63 downto 0);
            wr_inst_from_main: in std_logic;

            inst_hit_out: out std_logic;
            inst_mem_out: out std_logic_vector(15 downto 0)

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
    
            ctrl_stk: in std_logic_vector(1 downto 0);
            ctrl_lk: in std_logic;

            hit_signal: in std_logic;

            pc_plus_one: in std_logic_vector(15 downto 0);
            ac_out: in std_logic_vector(15 downto 0);
    
            rf1_addr: in std_logic_vector(3 downto 0);
            rf2_addr: in std_logic_vector(3 downto 0);
    
            rf1_out: out std_logic_vector(15 downto 0);
            rf2_out: out std_logic_vector(15 downto 0)
    
        );
    
    end component;

    signal ac_out: std_logic_vector(15 downto 0);

    component cometa16_ac_registers is
        port(
            clk: in std_logic;
            rst: in std_logic;
    
            ctrl_wr_ac:   in std_logic;
            ctrl_src_ac:  in std_logic_vector(2 downto 0);
    
            shifter_out:  in std_logic_vector(15 downto 0);
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

            sh_out:       in std_logic_vector(15 downto 0);
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
            ctrl_sh:         in std_logic_vector(1 downto 0);
            shamt:           in std_logic_vector(3 downto 0);

            alu_out:         in std_logic_vector(15 downto 0);

            shifter_out:     out std_logic_vector(15 downto 0)
        );

    end component;

    signal data_hit_out: std_logic;
    signal data_mem_out: std_logic_vector(15 downto 0);

    component cometa16_data_mem is
        port(
            clk: in std_logic;
            rst: in std_logic;

            ctrl_wr_data_mem: in std_logic;
            ctrl_data_mem_use: in std_logic;

            shifter_out: in std_logic_vector(15 downto 0);
            ac_out: in std_logic_vector(15 downto 0);

            -- Recive the block from main memory
            main_to_data_bk: in std_logic_vector(63 downto 0);
            wr_data_from_main: in std_logic;

            -- Send the block to main memory
            wr_main_from_data: out std_logic;
            data_to_main_bk: out std_logic_vector(63 downto 0);
            main_wr_addr: out std_logic_vector(15 downto 0);
            
            data_hit_out: out std_logic;
            data_mem_out: out std_logic_vector(15 downto 0)

        );
    
    end component;

    signal wr_inst_from_main: std_logic;
    signal main_to_inst_bk: std_logic_vector(63 downto 0);
    signal wr_data_from_main: std_logic;
    signal main_to_data_bk: std_logic_vector(63 downto 0);
    signal hit_signal: std_logic;

    component cometa16_mau is
        port(
            inst_hit_out: in std_logic;
            data_hit_out: in std_logic;

            pc_out: in std_logic_vector(15 downto 0);
            shifter_out: in std_logic_vector(15 downto 0);

            wr_cache_from_main: in std_logic;
            main_to_cache_bk: in std_logic_vector(63 downto 0);

            wr_inst_from_main: out std_logic;
            main_to_inst_bk: out std_logic_vector(63 downto 0);

            wr_data_from_main: out std_logic;
            main_to_data_bk: out std_logic_vector(63 downto 0);

            hit_signal: out std_logic;
            request: out std_logic;
            main_rd_addr: out std_logic_vector(15 downto 0)

        );

    end component;

begin
    -- Instruction fields
    opcode   <= inst_mem_out(15 downto 10);
    ac_addr  <= inst_mem_out(9 downto 8);
    rf1_addr <= inst_mem_out(7 downto 4);
    rf2_addr <= inst_mem_out(3 downto 0);
    imm      <= inst_mem_out(7 downto 0);

    controller: cometa16_controller
        port map(
            opcode => opcode,
    
            ctrl_cj => ctrl_cj,
            ctrl_ij => ctrl_ij,
    
            ctrl_stk => ctrl_stk,
            ctrl_lk => ctrl_lk,
            ctrl_wr_rf => ctrl_wr_rf,
            ctrl_src_rf => ctrl_src_rf,
        
            ctrl_wr_ac => ctrl_wr_ac,
            ctrl_src_ac => ctrl_src_ac,
        
            ctrl_wr_hilo => ctrl_wr_hilo,
            ctrl_src_hilo => ctrl_src_hilo,
        
            ctrl_sign_extend => ctrl_sign_extend,
        
            ctrl_src_alu_a => ctrl_src_alu_a,
            ctrl_src_alu_b => ctrl_src_alu_b,
            ctrl_alu => ctrl_alu,
        
            ctrl_sh => ctrl_sh,

            ctrl_wr_data_mem => ctrl_wr_data_mem,
            ctrl_data_mem_use => ctrl_data_mem_use

        );
    
    pc: cometa16_pc
        port map(
            clk => clk,
            rst => rst,

            z_signal => z_signal,
            n_signal => n_signal,

            ctrl_cj => ctrl_cj,
            ctrl_ij => ctrl_ij,

            rf1_out => rf1_out,
            inst_mem_out => inst_mem_out,
            sign_extend_out => sign_extend_out,

            hit_signal => hit_signal,

            pc_out => pc_out,
            pc_plus_one => pc_plus_one

        );

    inst_mem: cometa16_inst_mem
        port map(
            clk => clk,
            rst => rst,

            pc_out => pc_out,

            main_to_inst_bk => main_to_inst_bk,
            wr_inst_from_main => wr_inst_from_main,

            inst_hit_out => inst_hit_out,
            inst_mem_out => inst_mem_out

        );

    rf_registers: cometa16_rf_registers
        port map(
            clk => clk,
            rst => rst,

            ctrl_wr_rf => ctrl_wr_rf,
            ctrl_src_rf => ctrl_src_rf,

            ctrl_stk => ctrl_stk,
            ctrl_lk => ctrl_lk,

            hit_signal => hit_signal,

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

            shifter_out => shifter_out,
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

            sh_out => shifter_out,
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
            ctrl_sh => ctrl_sh,
            shamt => rf2_addr,

            alu_out => alu_out,

            shifter_out => shifter_out

        );

    data_mem: cometa16_data_mem
        port map(
            clk => clk,
            rst => rst,

            ctrl_wr_data_mem => ctrl_wr_data_mem,
            ctrl_data_mem_use => ctrl_data_mem_use,

            shifter_out => shifter_out,
            ac_out => ac_out,

            main_to_data_bk => main_to_data_bk,
            wr_data_from_main => wr_data_from_main,

            wr_main_from_data => wr_main_from_data,
            main_wr_addr => main_wr_addr,
            data_to_main_bk => data_to_main_bk,

            data_hit_out => data_hit_out,
            data_mem_out => data_mem_out

        );

    mau: cometa16_mau
        port map(
            inst_hit_out => inst_hit_out,
            data_hit_out => data_hit_out,

            pc_out => pc_out,
            shifter_out => shifter_out,

            wr_cache_from_main => wr_cache_from_main,
            main_to_cache_bk => main_to_cache_bk,

            wr_inst_from_main => wr_inst_from_main,
            main_to_inst_bk => main_to_inst_bk,

            wr_data_from_main => wr_data_from_main,
            main_to_data_bk => main_to_data_bk,

            hit_signal => hit_signal,
            request => request,
            main_rd_addr => main_rd_addr

        );

end behavior_core;
