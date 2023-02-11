-- || ****************************************************************** ||
-- ||                                                                    ||
-- || UNIVERSIDADE FEDERAL DO PIAUÍ - UFPI                               ||
-- || CENTRO DE CIÊNCIAS DA NATUREZA                                     ||
-- || DEPARTAMENTO DE COMPUTAÇÃO                                         ||
-- ||                                                                    ||
-- || Trabalho de Arquitetura de Computadores                            ||
-- || Computer for Every Task Architecture 16 Bits - COMETA 16           ||
-- ||                                                                    ||
-- || ****************************************************************** ||

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY ISA_datapath IS 
    PORT (
        clk_sig : IN std_logic;
        reset_sig : IN std_logic
    );
END ISA_datapath;

ARCHITECTURE bhv_datapath OF ISA_datapath is

    SIGNAL dvc_BUS           : std_logic_vector(2 DOWNTO 0);
    SIGNAL dvi_BUS           : std_logic_vector(1 DOWNTO 0);
    SIGNAL SrcReg1Esc_BUS    : std_logic;
    SIGNAL Reg1Esc_BUS       : std_logic;
    SIGNAL SrcReg2Esc_BUS    : std_logic_vector(1 DOWNTO 0);
    SIGNAL Reg2Esc_BUS       : std_logic;
    SIGNAL SrcRLH_BUS        : std_logic;
    SIGNAL EscRLH_BUS        : std_logic;
    SIGNAL Push_BUS          : std_logic;
    SIGNAL Pop_BUS           : std_logic;
    SIGNAL Jump_BUS          : std_logic;
    SIGNAL Extensor_BUS      : std_logic_vector(1 DOWNTO 0);
    SIGNAL SrcAluA_BUS       : std_logic;
    SIGNAL SrcAluB_BUS       : std_logic_vector(1 DOWNTO 0);
    SIGNAL AluOP_BUS         : std_logic_vector(3 DOWNTO 0);
    SIGNAL SH_BUS            : std_logic_vector(1 DOWNTO 0);
    SIGNAL EscMem_BUS        : std_logic;
    SIGNAL Saida_BUS         : std_logic;

    COMPONENT ISA_controller IS
        PORT (
            CLK	          : in std_logic;
            RESET	      : in std_logic;
            
            CODOP         : in std_logic_vector(5 DOWNTO 0);
            
            Dvc           : out std_logic_vector(2 DOWNTO 0);
            Dvi           : out std_logic_vector(1 DOWNTO 0);
            SrcReg1Esc    : out std_logic;
            Reg1Esc       : out std_logic;
            SrcReg2Esc	  : out std_logic_vector(1 DOWNTO 0);
            Reg2Esc       : out std_logic;
            SrcRLH        : out std_logic;
            EscRLH        : out std_logic;
            Push          : out std_logic;
            Pop           : out std_logic;
            Jump          : out std_logic;
            Extensor      : out std_logic_vector(1 DOWNTO 0);
            SrcAluA       : out std_logic;
            SrcAluB       : out std_logic_vector(1 DOWNTO 0);
            AluOP         : out std_logic_vector(3 DOWNTO 0);
            SH            : out std_logic_vector(1 DOWNTO 0);
            EscMem        : out std_logic;
            Saida         : out std_logic
        );
    END COMPONENT;

    SIGNAL PC_Out_bus   : std_logic_vector(15 Downto 0);
    SIGNAL PCmaisUm_bus : std_logic_vector(15 Downto 0);

    COMPONENT ISA_pc IS
        PORT (
            clk              : in std_logic;
            reset            : in std_logic;
    
            Z, N             : in std_logic;
            DvC              : in std_logic_vector(2 downto 0);
            DvI              : in std_logic_vector(1 downto 0);
    
            rf1_lido         : in std_logic_vector(15 downto 0);
            imm              : in std_logic_vector(9 downto 0);
            Signal_Extension : in std_logic_vector(15 downto 0);
    
            PC_Out           : out std_logic_vector(15 downto 0);
            PCmaisUm         : out std_logic_vector(15 downto 0)
        );
    END COMPONENT;

    SIGNAL InstructionMemory_Output_BUS : std_logic_vector(15 Downto 0);
    SIGNAL CODOP_bus                    : std_logic_vector(5 Downto 0);
    SIGNAL rf1_bus                      : std_logic_vector(3 Downto 0);
    SIGNAL rf2_bus                      : std_logic_vector(3 Downto 0);
    
    SIGNAL rd_bus                       : std_logic_vector(1 Downto 0);
    
    SIGNAL imm_bus                      : std_logic_vector(9 Downto 0);
    SIGNAL imm_to_extension_bus         : std_logic_vector(7 Downto 0);

    COMPONENT ISA_instruction_memory IS
        PORT (
            clk                      : IN std_logic;
            reset                    : IN std_logic;
            -- Entrada
            PC_Output                : IN std_logic_vector(15 Downto 0);
            -- Saida
            InstructionMemory_Output : OUT std_logic_vector(15 Downto 0)
        );
    END COMPONENT;

    SIGNAL rf1_lido_bus : std_logic_vector(15 Downto 0);
    SIGNAL rf2_lido_bus : std_logic_vector(15 Downto 0);

    COMPONENT ISA_bank_registers_1 IS
        PORT(
            clk           : IN std_logic;
            reset         : IN std_logic;

            -- Controle de leitura e controle do multiplexador
            EscReg1       : IN std_logic;
            SrcReg1Esc    : IN std_logic;

            pop		      : IN std_logic;
            push          : IN std_logic;
            jump          : IN std_logic;

            -- Dados que podem ser escritos
            pc_mais_um    : IN std_logic_vector(15 DOWNTO 0);
            rd_lido       : IN std_logic_vector(15 DOWNTO 0);

            -- Endereco de rf1 e rf2
            rf1_address   : IN std_logic_vector(3 DOWNTO 0);
            rf2_address   : IN std_logic_vector(3 DOWNTO 0);

            -- Dados lidos
            dado_lido_rf1 : OUT std_logic_vector(15 DOWNTO 0);
            dado_lido_rf2 : OUT std_logic_vector(15 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL rd_lido_bus : std_logic_vector(15 DOWNTO 0);

    COMPONENT ISA_bank_registers_2 IS
        PORT(
            clk              : IN std_logic;
            reset            : IN std_logic;

            -- Controle de leitura e controle do multiplexador
            EscReg2          : IN std_logic;
            SrcReg2Esc       : IN std_logic_vector(1 DOWNTO 0);

            -- Dados de escrita
            saida_ula_ou_mem : IN std_logic_vector(15 DOWNTO 0);
            n_signal         : IN std_logic;

            low_register	 : IN std_logic_vector(15 DOWNTO 0);
		    high_register	 : IN std_logic_vector(15 DOWNTO 0);

            -- Endereco de escrita/leitura e dado lido
            rd_address       : IN std_logic_vector(1 DOWNTO 0);
            dado_lido        : OUT std_logic_vector(15 downto 0)
        );
    END COMPONENT;

    SIGNAL low_register_bus : std_logic_vector(15 DOWNTO 0);
    SIGNAL high_register_bus : std_logic_vector(15 DOWNTO 0);
    
    COMPONENT ISA_rlh IS
        PORT(
            --Sinais clock e reset
            clk              : IN std_logic;
            reset            : IN std_logic;

            -- Controle de controle
            EscRLH           : IN std_logic;
            SrcRLH           : IN std_logic;

            -- Entradas de dados
            rf1_mais_high : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            rd            : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

            -- Dados lidos
            low_out       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            high_out      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL Extension_Signal_Bus : std_logic_vector(15 DOWNTO 0);

    COMPONENT ISA_extension_signal IS
        PORT ( 
        Imm 			:IN std_logic_vector(7 DOWNTO 0);
        Extensor_Input   	:IN std_logic_vector(1 DOWNTO 0);
        Extension_Signal 	:OUT std_logic_vector(15 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL Z_BUS : std_logic;
    SIGNAL N_BUS : std_logic;
    SIGNAL Ula_out_BUS : std_logic_vector(15 DOWNTO 0);

    COMPONENT ISA_alu IS
        PORT (
            clock : IN std_logic;
            reset : IN std_logic;
            
            -- Sinais de controle
            control_alu    : IN std_logic_vector(3 DOWNTO 0);
            control_amux_a : IN std_logic;
            control_amux_b : IN std_logic_vector(1 DOWNTO 0);

            rf1_lido       : IN std_logic_vector(15 DOWNTO 0);
            rf2_lido       : IN std_logic_vector(15 DOWNTO 0);

            rd_signal      : IN std_logic_vector(15 DOWNTO 0);
            ex_signal      : IN std_logic_vector(15 DOWNTO 0);
            high_signal    : IN std_logic_vector(15 DOWNTO 0);

            -- Sinais z e N
            z              : OUT std_logic;
            n              : OUT std_logic;

            -- Saida da ula
            alu_out        : OUT std_logic_vector(15 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL saida_SH_BUS : std_logic_vector(15 DOWNTO 0);

    COMPONENT ISA_shifter IS
        PORT ( 
        ALU_Output   	 : IN std_logic_vector(15 DOWNTO 0);
        Shift_Signal	 : IN std_logic_vector(3 DOWNTO 0);
        SH_Input		 : IN std_logic_vector(1 DOWNTO 0);
        SH_Output	     : OUT std_logic_vector(15 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL out_Saida_BUS : std_logic_vector(15 Downto 0);

    COMPONENT ISA_data_memory IS
        PORT (
            clk              : IN std_logic;
            reset            : IN std_logic;

            -- Controle De escrita
            EscMem          : IN std_logic;

            -- Controle do Amux
            Amux            : IN std_logic;

            -- Saida da ula
            saida_ula_endereco : IN std_logic_vector(15 DOWNTO 0);

            -- dado de escrita
            dadoEsc : IN std_logic_vector(15 DOWNTO 0);
            
            -- Endereco da ula e dado lido
            amux_dadolido_ula        : OUT std_logic_vector(15 downto 0)
        );
    END COMPONENT;

    BEGIN

    CODOP_bus                    <= InstructionMemory_Output_BUS(15 Downto 10);
    rf1_bus                      <= InstructionMemory_Output_BUS(7 Downto 4);
    rf2_bus                      <= InstructionMemory_Output_BUS(3 Downto 0);
    
    rd_bus                       <= InstructionMemory_Output_BUS(9 Downto 8);
    
    imm_bus                      <= InstructionMemory_Output_BUS(9 Downto 0);
    imm_to_extension_bus         <= InstructionMemory_Output_BUS(7 Downto 0);

    -- INSTANCIAS DOS COMPONENTES

    controller : ISA_controller
        PORT MAP (
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
    
    pc : ISA_pc
        PORT MAP (
            clk              => clk_sig,
            reset            => reset_sig,

            Z                => Z_bus, -- GERADO NA ULA
            N                => N_bus, -- GERADO NA ULA
            DvC              => DvC_bus,
            DvI              => DvI_bus,

            rf1_lido         => rf1_lido_bus,                               -- gerado no rg1
            imm              => imm_bus, -- gerado no instruction memory
            Signal_Extension => Extension_Signal_Bus,    -- gerado no signal extension

            PC_Out           => PC_Out_bus,
            PCmaisUm         => PCmaisUm_bus

        );

    instruction_memory : ISA_instruction_memory
        PORT MAP (
            clk                      => clk_sig,
            reset                    => reset_sig,

            PC_Output                => PC_Out_BUS,
            InstructionMemory_Output => InstructionMemory_Output_BUS
        );

    bank_register_1 : ISA_bank_registers_1
        PORT MAP(
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

    bank_register_2 : ISA_bank_registers_2
        PORT MAP(
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

    rlh : ISA_rlh
        PORT MAP(
            clk           => CLK_Sig,
            reset         => Reset_Sig,

            EscRLH        => EscRLH_BUS,
            SrcRLH        => SrcRLH_BUS,

            rf1_mais_high => Ula_out_BUS,
            rd            => rd_lido_bus,

            low_out  => low_register_bus,
            high_out => high_register_bus
        );

    Extension_Signal : ISA_Extension_Signal
        PORT MAP(
            Imm              => imm_to_extension_bus,
            Extensor_input   => Extensor_bus,
            Extension_Signal => Extension_Signal_bus
        );

    alu : ISA_alu
        PORT MAP(

            clock => clk_sig,
            reset => reset_sig,
            
            control_alu    => AluOP_BUS,
            control_amux_a => SrcAluA_BUS,
            control_amux_b => SrcAluB_BUS,

            rf1_lido       => rf1_lido_bus, -- gerado em br1
            rf2_lido       => rf2_lido_bus, -- gerado em br1

            rd_signal      => rd_lido_bus,  -- gerado em br2
            ex_signal      => Extension_Signal_bus, -- gerado em extension_signal
            high_signal    => high_register_bus, -- gerado em rlh;

            z              => Z_BUS,
            n              => N_BUS,

            alu_out        => Ula_out_BUS
        );

    sh : ISA_shifter
        PORT MAP(
            ALU_Output   	 => ula_out_bus,
            Shift_Signal	 => rf2_bus,
            SH_Input		 => sh_bus,
            SH_Output	     => saida_sh_bus
        );

    data_memory : ISA_data_memory
        PORT MAP(
            clk          => CLK_Sig,
            reset        => Reset_Sig,
            
            EscMem       => EscMem_BUS,
            Amux         => Saida_BUS,
            
            saida_ula_endereco => saida_sh_bus,
            dadoEsc            => RD_LIDO_BUS, -- gerado em br2
            amux_dadolido_ula  => out_saida_BUS
        );

END bhv_datapath;
