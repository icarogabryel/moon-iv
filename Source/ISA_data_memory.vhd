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

ENTITY ISA_data_memory IS
    PORT(
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
END ISA_data_memory;

ARCHITECTURE bhv_data_memory OF ISA_data_memory IS

	TYPE DATA_MEMORY IS ARRAY(0 TO 65535) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL memory_data : DATA_MEMORY;
    SIGNAL dadolido_ula :  std_logic_vector(15 downto 0);
	
	BEGIN
	WITH Amux SELECT 
		amux_dadolido_ula <= dadolido_ula(15 DOWNTO 0) WHEN '0',
		saida_ula_endereco (15 DOWNTO 0) WHEN OTHERS;

		-- Dado lido de rd
		dadolido_ula <= memory_data(conv_integer(saida_ula_endereco(15 DOWNTO 0)))(15 DOWNTO 0);

		-- Escrita no registrador
		write_memory_data : PROCESS (clk, EscMem, reset)

			BEGIN

				IF reset = '1' THEN
					memory_data(0)  <= "0000000000000000";  
					memory_data(1)  <= "0000000000000000"; 
					memory_data(2)  <= "0000000000000000"; 
					memory_data(3)  <= "0000000000000000"; 
					memory_data(4)  <= "0000000000000000"; 
					memory_data(5)  <= "0000000000000000";
					memory_data(6)  <= "0000000000000000"; 
					memory_data(7)  <= "0000000000000000"; 
					memory_data(8)  <= "0000000000000000"; 
					memory_data(9)  <= "0000000000000000";  
					memory_data(10) <= "0000000000000000"; 
					memory_data(11) <= "0000000000000000"; 
					memory_data(12) <= "0000000000000000"; 
					memory_data(13) <= "0000000000000000"; 
					memory_data(14) <= "0000000000000000"; 
					memory_data(15) <= "0000000000000000";
					
					for k in 16 to 65535 loop
						memory_data(k)  <= "0000000000000000";
					end loop;
                    
				ELSIF ((clk'event AND clk ='1') AND (EscMem = '1')) THEN
					memory_data(conv_integer(saida_ula_endereco(15 downto 0))) <= dadoEsc;

				END IF;
					
			END PROCESS write_memory_data;

END bhv_data_memory;