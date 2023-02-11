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

ENTITY ISA_testbench IS
END ISA_testbench;

ARCHITECTURE bhv_testbench OF ISA_testbench IS
    CONSTANT clk_period 		: time := 40 ns;
    SIGNAL clk_count 			: integer := 0;

    SIGNAl clk_signal			: STD_LOGIC;
    SIGNAl reset_signal			: STD_LOGIC;

    COMPONENT ISA_datapath IS
        PORT (
            clk_sig   : IN std_logic;
            reset_sig : IN std_logic
        );
    END COMPONENT;

    BEGIN

        datapath : ISA_datapath
            PORT MAP (
                clk_sig => clk_signal,
                reset_sig => reset_signal
            );

    -- Processo de Clock
	clock_process : PROCESS 	
        BEGIN
            clk_signal <= '0';
            WAIT FOR clk_period/2;
            clk_signal  <= '1';
            clk_count <= clk_count + 1;
            WAIT FOR clk_period/2;

            IF (clk_count = 60) THEN     
                REPORT "Parando simulacao";
                WAIT;
            END IF;
    END PROCESS clock_process;

    -- Processo de Reset
    reset_process : PROCESS    
        BEGIN
            reset_signal <= '0';
            WAIT FOR 10 ns;
            reset_signal <= '1';
            WAIT FOR 30 ns;
            reset_signal <= '0';
            WAIT;
    END PROCESS reset_process;

END bhv_testbench;
