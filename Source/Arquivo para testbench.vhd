-- || ****************************************************************** ||
-- ||                                                                    ||
-- || UNIVERSIDADE FEDERAL DO PIAUÍ - UFPI                               ||
-- || CENTRO DE CIÊNCIAS DA NATUREZA                                     ||
-- || DEPARTAMENTO DE COMPUTAÇÃO                                         ||
-- ||                                                                    ||
-- || Trabalho de Arquitetura de Computadores                            ||
-- || Computer for Every Task Architecture 16 Bits - COMETA 16           || 
-- ||                                                                    ||
-- || A operação escrita abaixo executa a instrução ADD. Você pode fazer ||
-- || seus próprios testebenchs reescrevendo as instruções em binário na ||
-- || memória de instruções e usando a tabela de codops como ajuda.      ||
-- ||                                                                    ||
-- || ****************************************************************** ||

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY ISA_instruction_memory IS
	PORT(
		clk                      : IN std_logic;
		reset                    : IN std_logic;
        -- Entrada
        PC_Output                : IN std_logic_vector(15 Downto 0);
        -- Saida
        InstructionMemory_Output : OUT std_logic_vector(15 Downto 0)
	);

END ISA_instruction_memory;

ARCHITECTURE bhv_instruction_memory OF ISA_instruction_memory IS

	TYPE memory IS ARRAY(0 TO 15) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL instructionMemory : memory;

	BEGIN
    
		InstructionMemory_Output <= instructionMemory(conv_integer(PC_Output));
	
		instructionMemory_process : PROCESS (clk, reset)
			BEGIN
				IF reset = '1' THEN
                instructionMemory(0)  <= "0011100000000010"; -- LOI, Carrega o valor 2 no registrador AC0
                instructionMemory(1)  <= "0011100100000100"; -- LOI, Carrega o valor 4 no registrador AC1
                instructionMemory(2)  <= "0010010000000000"; -- MFAC, Move o valor do registrador AC0 para o registrador Rf0
                instructionMemory(3)  <= "0010010100010000"; -- MFAC, Move o valor do registrador AC1 para o registrador Rf1
                instructionMemory(4)  <= "0000001100000001"; -- ADD, Soma o valor do registrador Rf0 com o valor do registrador Rf1 e armazena o resultado no registrador AC3
                instructionMemory(5)  <= "0000000000000000";
                instructionMemory(6)  <= "0000000000000000"; 
                instructionMemory(7)  <= "0000000000000000"; 
                instructionMemory(8)  <= "0000000000000000"; 
                instructionMemory(9)  <= "0000000000000000";  
                instructionMemory(10) <= "0000000000000000"; 
                instructionMemory(11) <= "0000000000000000"; 
                instructionMemory(12) <= "0000000000000000"; 
                instructionMemory(13) <= "0000000000000000"; 
                instructionMemory(14) <= "0000000000000000"; 
                instructionMemory(15) <= "0000000000000000"; 
		
				END IF;
					
			END PROCESS instructionMemory_process;

END bhv_instruction_memory;