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

ENTITY ISA_bank_registers_1 IS
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
END ISA_bank_registers_1;

ARCHITECTURE bhv_bank_registers_1 OF ISA_bank_registers_1 IS

	TYPE BANKREG1 IS ARRAY(0 TO 15) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL bank_register1 : BANKREG1;

	-- Saida do multiplexador
	SIGNAL amux_out : std_logic_vector(15 DOWNTO 0);
	SIGNAL pp       : std_logic_vector(1 DOWNTO 0);

	SIGNAL Endereco_escrita : std_logic_vector(3 DOWNTO 0);

	BEGIN

		pp <= push & pop;

		WITH pp SELECT
			dado_lido_rf1 <= bank_register1(14)                        WHEN "01",
			                 bank_register1(14) - 1                    WHEN "10",
							 bank_register1(conv_integer(rf1_address)) WHEN OTHERS;

		dado_lido_rf2 <= bank_register1(conv_integer(rf2_address));

		WITH jump SELECT
			Endereco_escrita <= rf1_address(3 downto 0) WHEN '0',
			                    "1111" WHEN OTHERS;

		-- Saida do multiplexador
		WITH SrcReg1Esc SELECT
				amux_out <= pc_mais_um(15 DOWNTO 0)  WHEN '0',
						    rd_lido(15 DOWNTO 0)     WHEN OTHERS;


		write_bank_register1 : PROCESS (clk, EscReg1, reset)
			BEGIN

				IF reset = '1' THEN
					bank_register1(0)  <= "0000000000000000"; -- rf0 
					bank_register1(1)  <= "0000000000000000"; -- rf1
					bank_register1(2)  <= "0000000000000000"; -- rf2 
					bank_register1(3)  <= "0000000000000000"; -- rf3
					bank_register1(4)  <= "0000000000000000"; -- rf4
					bank_register1(5)  <= "0000000000000000"; -- rf5 
					bank_register1(6)  <= "0000000000000000"; -- rf6
					bank_register1(7)  <= "0000000000000000"; -- rf7
					bank_register1(8)  <= "0000000000000000"; -- rf8
					bank_register1(9)  <= "0000000000000000"; -- rf9 
					bank_register1(10) <= "0000000000000000"; -- rf10
					bank_register1(11) <= "0000000000000000"; -- rf11
					bank_register1(12) <= "0000000000000000"; -- rf12
					bank_register1(13) <= "0000000000000000"; -- rf13
					bank_register1(14) <= "0000000000000000"; -- sp
					bank_register1(15) <= "0000000000000000"; -- rf15 (pc+1)
				
				-- Salvando dado no registrador
				ELSIF ((clk'event AND clk ='1') AND (EscReg1 = '1') AND (pp = "00")) THEN
				    bank_register1(conv_integer(endereco_escrita)) <= amux_out;
				ELSIF ((clk'event AND clk ='1') AND (EscReg1 = '1') AND (pp = "01")) THEN -- pop
					bank_register1(14) <= bank_register1(14) + 1;
				ELSIF ((clk'event AND clk ='1') AND (EscReg1 = '1') AND (pp = "10")) THEN -- push
					bank_register1(14) <= bank_register1(14) - 1;
				END IF;

					
			END PROCESS write_bank_register1;

END bhv_bank_registers_1;
