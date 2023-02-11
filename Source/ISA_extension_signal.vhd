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
USE ieee.std_logic_signed.all;

ENTITY ISA_Extension_SIGNAL IS
    PORT ( 
       Imm 			:IN std_logic_vector(7 DOWNTO 0);
       Extensor_Input   	:IN std_logic_vector(1 DOWNTO 0);
       Extension_Signal 	:OUT std_logic_vector(15 DOWNTO 0)
    );

END ISA_Extension_SIGNAL;

ARCHITECTURE bhv_Extension_SIGNAL OF ISA_Extension_SIGNAL IS
BEGIN

	WITH Extensor_Input SELECT
	
        Extension_Signal <= "00000000" & Imm(7 DOWNTO 0) when "00",
			                Imm(7 DOWNTO 0) & "00000000" when "01",
			                Imm(7) & Imm(7) & Imm(7) & Imm(7) & Imm(7) & Imm(7) & Imm(7) & Imm(7) & Imm(7 DOWNTO 0) WHEN OTHERS;
									
END bhv_Extension_SIGNAL;