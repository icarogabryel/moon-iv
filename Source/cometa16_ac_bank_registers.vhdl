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

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY ISA_bank_registers_2 IS
    PORT(
		clk              : IN std_logic;
        reset            : IN std_logic;

		-- Controle de leitura e controle do multiplexador
        EscReg2          : IN std_logic;
		SrcReg2Esc       : IN std_logic_vector(1 downto 0);

		-- Dados de escrita
		saida_ula_ou_mem : IN std_logic_vector(15 DOWNTO 0);
        n_signal         : IN std_logic;

		-- RLH
		low_register	 : IN std_logic_vector(15 DOWNTO 0);
		high_register	 : IN std_logic_vector(15 DOWNTO 0);

		-- Endereco de escrita/leitura e dado lido
		rd_address       : IN std_logic_vector(1 DOWNTO 0);
        dado_lido        : OUT std_logic_vector(15 downto 0)
	);
END ISA_bank_registers_2;

ARCHITECTURE bhv_bank_registers_2 OF ISA_bank_registers_2 IS

	TYPE BANKREG2 IS ARRAY(0 TO 3) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL bank_register2 : BANKREG2;

	-- Saida do multiplexador
    SIGNAL amux_out : std_logic_vector(15 DOWNTO 0);

	BEGIN
		-- Saida do multiplexador
		WITH SrcReg2Esc SELECT
		    amux_out <= saida_ula_ou_mem(15 DOWNTO 0)  WHEN "00",
			            "000000000000000" & n_signal   WHEN "01",
						low_register(15 DOWNTO 0)      WHEN "10",
						high_register(15 DOWNTO 0)     WHEN OTHERS;

		-- Dado lido de rd
		dado_lido <= bank_register2(conv_integer(rd_address(1 DOWNTO 0)))(15 DOWNTO 0);

		-- Escrita no registrador
		write_bank_register2 : PROCESS (clk, EscReg2, reset)
			BEGIN
				IF reset = '1' THEN
					bank_register2(0)  <= "0000000000000000"; -- AC0
					bank_register2(1)  <= "0000000000000000"; -- AC1
					bank_register2(2)  <= "0000000000000000"; -- AC2
					bank_register2(3)  <= "0000000000000000"; -- AC3
				
				ELSIF ((clk'event AND clk ='1') AND (EscReg2 = '1')) THEN
					bank_register2(conv_integer(rd_address(1 downto 0))) <= amux_out;

				END IF;
					
			END PROCESS write_bank_register2;

END bhv_bank_registers_2;
