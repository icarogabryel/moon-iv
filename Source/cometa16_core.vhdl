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

        main_mem_out: in std_logic_vector(63 downto 0);
        pc_out: out std_logic_vector(15 downto 0);
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

    component cometa16_controller is
        port(
            ins_mux:          in std_logic_vector(15 downto 0);
    
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
        
            ctrl_shifter:     out std_logic_vector(1 downto 0)
    
        );

    end component;

    signal pc_out: std_logic_vector(15 downto 0);
    signal pc_plus_one: std_logic_vector(15 downto 0);

    component cometa16_pc is
        port(
            clk, rst:        in std_logic;
    
            z, n:            in std_logic;
    
            ctrl_dvc:        in std_logic_vector(2 downto 0);
            ctrl_dvi:        in std_logic_vector(1 downto 0);

            hit_out:         in std_logic;

            rf1_out:         in std_logic_vector(15 downto 0);
            ins_mux_out:     in std_logic_vector(16 downto 0);
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

    signal rf1_out: std_logic_vector(15 downto 0);
    signal rf2_out: std_logic_vector(15 downto 0);

    component cometa16_rf_registers is
        port(
            clk: in std_logic;
            rst: in std_logic;
    
            ctrl_wr_rf: in std_logic;
            ctrl_src_rf: in std_logic;
    
            ctrl_stk:  in std_logic_vector(1 downto 0);
            ctrl_link: in std_logic;
    
            pc_plus_one: in std_logic_vector(15 downto 0);
            rd_bank_reg_out: in std_logic_vector(15 downto 0);
    
            rf1_addr: in std_logic_vector(3 downto 0);
            rf2_addr: in std_logic_vector(3 downto 0);
    
            rf1_out : out std_logic_vector(15 downto 0);
            rf2_out : out std_logic_vector(15 downto 0)
    
        );
    
    end component;

    signal rd_lido_bus: std_logic_vector(15 downto 0);

    component cometa16_ac_registers is
        port(
            clk: in std_logic;
            rst: in std_logic;
    
            ctrl_wr_ac:   in std_logic;
            ctrl_src_ac:  in std_logic_vector(2 downto 0);
    
            alu_out:      in std_logic_vector(15 downto 0);
            data_mem_out: in std_logic_vector(15 downto 0);
            n_signal:     in std_logic;
            hi_reg:       in std_logic_vector(15 downto 0);
            lo_reg:       in std_logic_vector(15 downto 0);
    
            ac_addr:      in std_logic_vector(1 downto 0);
            ac_out:       out std_logic_vector(15 downto 0)
    
        );
    end component;

    signal low_register_bus : std_logic_vector(15 downto 0);
    signal high_register_bus : std_logic_vector(15 downto 0);
    
    component isA_rlh is
        PORT(
            --Sinais clock e reset
            clk              : IN std_logic;
            reset            : IN std_logic;

            -- Controle de controle
            EscRLH           : IN std_logic;
            SrcRLH           : IN std_logic;

            -- Entradas de dados
            rf1_mais_high : IN STD_LOGIC_VECTOR(15 downto 0);
            rd            : IN STD_LOGIC_VECTOR(15 downto 0);

            -- Dados lidos
            low_out       : OUT STD_LOGIC_VECTOR(15 downto 0);
            high_out      : OUT STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    signal Extension_signal_Bus : std_logic_vector(15 downto 0);

    component isA_extension_signal is
        port( 
        Imm 			:IN std_logic_vector(7 downto 0);
        Extensor_Input   	:IN std_logic_vector(1 downto 0);
        Extension_signal 	:OUT std_logic_vector(15 downto 0)
        );
    end component;

    signal Z_BUS : std_logic;
    signal N_BUS : std_logic;
    signal Ula_out_BUS : std_logic_vector(15 downto 0);

    component isA_alu is
        port(
            clock : IN std_logic;
            reset : IN std_logic;
            
            -- Sinais de controle
            control_alu    : IN std_logic_vector(3 downto 0);
            control_amux_a : IN std_logic;
            control_amux_b : IN std_logic_vector(1 downto 0);

            rf1_lido       : IN std_logic_vector(15 downto 0);
            rf2_lido       : IN std_logic_vector(15 downto 0);

            rd_signal      : IN std_logic_vector(15 downto 0);
            ex_signal      : IN std_logic_vector(15 downto 0);
            high_signal    : IN std_logic_vector(15 downto 0);

            -- Sinais z e N
            z              : OUT std_logic;
            n              : OUT std_logic;

            -- Saida da ula
            alu_out        : OUT std_logic_vector(15 downto 0)
        );
    end component;

    signal saida_SH_BUS : std_logic_vector(15 downto 0);

    component isA_shifter is
        port( 
        ALU_Output   	 : IN std_logic_vector(15 downto 0);
        Shift_signal	 : IN std_logic_vector(3 downto 0);
        SH_Input		 : IN std_logic_vector(1 downto 0);
        SH_Output	     : OUT std_logic_vector(15 downto 0)
        );
    end component;

    signal out_Saida_BUS : std_logic_vector(15 downto 0);

    component isA_data_memory is
        port(
            clk              : IN std_logic;
            reset            : IN std_logic;

            -- Controle De escrita
            EscMem          : IN std_logic;

            -- Controle do Amux
            Amux            : IN std_logic;

            -- Saida da ula
            saida_ula_endereco : IN std_logic_vector(15 downto 0);

            -- dado de escrita
            dadoEsc : IN std_logic_vector(15 downto 0);
            
            -- Endereco da ula e dado lido
            amux_dadolido_ula        : OUT std_logic_vector(15 downto 0)
        );
    end component;

    BEGIN

    CODOP_bus                    <= InstructionMemory_Output_BUS(15 downto 10);
    rf1_bus                      <= InstructionMemory_Output_BUS(7 downto 4);
    rf2_bus                      <= InstructionMemory_Output_BUS(3 downto 0);
    
    rd_bus                       <= InstructionMemory_Output_BUS(9 downto 8);
    
    imm_bus                      <= InstructionMemory_Output_BUS(9 downto 0);
    imm_to_extension_bus         <= InstructionMemory_Output_BUS(7 downto 0);

    -- INSTANCIAS DOS componentES

    controller : isA_controller
        portMAP (
            CLK           => clk_sig,
            RESET         => reset_sig,
            
            CODOP         => CODOP_bus, -- gerado no instruction memory
            Dvc           => dvc_BUS,
            Dvi           => dvi_BUS,
            SrcReg1Esc    => SrcReg1Esc_BUS,
            Reg1Esc       => Reg1Esc_BUS,
            SrcReg2Esc    => SrcReg2Esc_BUS,
            Reg2Esc       => Reg2Esc_BUS,
            SrcRLH        => SrcRLH_BUS,
            EscRLH        => EscRLH_BUS,
            Push          => Push_BUS,
            Pop           => Pop_BUS,
            Jump          => Jump_BUS,
            Extensor      => Extensor_BUS,
            SrcAluA       => SrcAluA_BUS,
            SrcAluB       => SrcAluB_BUS,
            AluOP         => AluOP_BUS,
            SH            => SH_BUS,
            EscMem        => EscMem_BUS,
            Saida         => Saida_BUS
        );
    
    pc : isA_pc
        portMAP (
            clk              => clk_sig,
            reset            => reset_sig,

            Z                => Z_bus, -- GERADO NA ULA
            N                => N_bus, -- GERADO NA ULA
            DvC              => DvC_bus,
            DvI              => DvI_bus,

            rf1_lido         => rf1_lido_bus,                               -- gerado no rg1
            imm              => imm_bus, -- gerado no instruction memory
            signal_Extension => Extension_signal_Bus,    -- gerado no signal extension

            PC_Out           => PC_Out_bus,
            PCmaisUm         => PCmaisUm_bus

        );

    instruction_memory : isA_instruction_memory
        portMAP (
            clk                      => clk_sig,
            reset                    => reset_sig,

            PC_Output                => PC_Out_BUS,
            InstructionMemory_Output => InstructionMemory_Output_BUS
        );

    bank_register_1 : isA_bank_registers_1
        portMAP(
            clk                      => clk_sig,
            reset                    => reset_sig, 
        
            EscReg1      => Reg1Esc_BUS,
            SrcReg1Esc   => SrcReg1Esc_bus,
            pop          => pop_bus,
            push         => push_bus,
            jump         => jump_bus,

            -- Dados que podem ser escritos
            pc_mais_um    => pcmaisum_bus,
            rd_lido       => RD_LIDO_BUS,

            -- Endereco de rf1 e rf2
            rf1_address   => rf1_bus, ---------------
            rf2_address   => rf2_bus, --------------

            -- Dados lidos
            dado_lido_rf1 => rf1_lido_bus,
            dado_lido_rf2 => rf2_lido_bus
        );

    bank_register_2 : isA_bank_registers_2
        portMAP(
            clk          => CLK_Sig,
            reset        => Reset_Sig,

            EscReg2           => Reg2Esc_bus,
            SrcReg2Esc        => SrcReg2Esc_bus,

            saida_ula_ou_mem =>  out_saida_BUS,
            n_signal         =>  N_BUS,

            low_register     =>  low_register_bus,
            high_register    =>  high_register_bus,
    
            -- Endereco de escrita/leitura e dado lido
            rd_address        => rd_bus,
            dado_lido         => RD_LIDO_BUS
        );

    rlh : isA_rlh
        portMAP(
            clk           => CLK_Sig,
            reset         => Reset_Sig,

            EscRLH        => EscRLH_BUS,
            SrcRLH        => SrcRLH_BUS,

            rf1_mais_high => Ula_out_BUS,
            rd            => rd_lido_bus,

            low_out  => low_register_bus,
            high_out => high_register_bus
        );

    Extension_signal : isA_Extension_signal
        portMAP(
            Imm              => imm_to_extension_bus,
            Extensor_input   => Extensor_bus,
            Extension_signal => Extension_signal_bus
        );

    alu : isA_alu
        portMAP(

            clock => clk_sig,
            reset => reset_sig,
            
            control_alu    => AluOP_BUS,
            control_amux_a => SrcAluA_BUS,
            control_amux_b => SrcAluB_BUS,

            rf1_lido       => rf1_lido_bus, -- gerado em br1
            rf2_lido       => rf2_lido_bus, -- gerado em br1

            rd_signal      => rd_lido_bus,  -- gerado em br2
            ex_signal      => Extension_signal_bus, -- gerado em extension_signal
            high_signal    => high_register_bus, -- gerado em rlh;

            z              => Z_BUS,
            n              => N_BUS,

            alu_out        => Ula_out_BUS
        );

    sh : isA_shifter
        portMAP(
            ALU_Output   	 => ula_out_bus,
            Shift_signal	 => rf2_bus,
            SH_Input		 => sh_bus,
            SH_Output	     => saida_sh_bus
        );

    data_memory : isA_data_memory
        portMAP(
            clk          => CLK_Sig,
            reset        => Reset_Sig,
            
            EscMem       => EscMem_BUS,
            Amux         => Saida_BUS,
            
            saida_ula_endereco => saida_sh_bus,
            dadoEsc            => RD_LIDO_BUS, -- gerado em br2
            amux_dadolido_ula  => out_saida_BUS
        );

end behavior_core;
