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

ENTITY ISA_shifter IS
    PORT ( 
       ALU_Output   	 : IN std_logic_vector(15 DOWNTO 0);
       Shift_Signal	 : IN std_logic_vector(3 DOWNTO 0);
       SH_Input		 : IN std_logic_vector(1 DOWNTO 0);
       SH_Output	 : OUT std_logic_vector(15 DOWNTO 0)
    );

END ISA_shifter;

ARCHITECTURE bhv_shifter OF ISA_shifter IS

      SIGNAL SH : std_logic_vector (5 DOWNTO 0);
     
BEGIN

      SH <= SH_Input(1 DOWNTO 0) & Shift_Signal(3 DOWNTO 0);

	 WITH SH SELECT
         SH_Output <= 	  ALU_Output(14 DOWNTO 0) & '0' WHEN "010001",    -- Deslocamento logico a Esquerda
						  ALU_Output(13 DOWNTO 0) & "00" WHEN "010010",
			  			  ALU_Output(12 DOWNTO 0) & "000" WHEN "010011",
			  			  ALU_Output(11 DOWNTO 0) & "0000" WHEN "010100",
			  			  ALU_Output(10 DOWNTO 0) & "00000" WHEN "010101",
			  			  ALU_Output(9 DOWNTO 0)  & "000000" WHEN "010110",
			  			  ALU_Output(8 DOWNTO 0)  & "0000000" WHEN "010111",
			  			  ALU_Output(7 DOWNTO 0)  & "00000000" WHEN "011000",
			  			  ALU_Output(6 DOWNTO 0)  & "000000000" WHEN "011001",
			  			  ALU_Output(5 DOWNTO 0)  & "0000000000" WHEN "011010",
			  			  ALU_Output(4 DOWNTO 0)  & "00000000000" WHEN "011011",
			  			  ALU_Output(3 DOWNTO 0)  & "000000000000" WHEN "011100",
			  			  ALU_Output(2 DOWNTO 0)  & "0000000000000" WHEN "011101",
			              ALU_Output(1 DOWNTO 0)  & "00000000000000" WHEN "011110",
			              ALU_Output(0)		      & "000000000000000" WHEN "011111",
			
	
			 '0' & ALU_Output(15 DOWNTO 1) WHEN "100001",    -- Deslocamento logico a Direita
			 "00" & ALU_Output(15 DOWNTO 2) WHEN "100010",
			 "000" & ALU_Output(15 DOWNTO 3) WHEN "100011",
			 "0000" & ALU_Output(15 DOWNTO 4) WHEN "100100",
			 "00000" & ALU_Output(15 DOWNTO 5) WHEN "100101",
			 "000000" & ALU_Output(15 DOWNTO 6) WHEN "100110",
			 "0000000" & ALU_Output(15 DOWNTO 7) WHEN "100111",
			 "00000000" & ALU_Output(15 DOWNTO 8) WHEN "101000",
			 "000000000" & ALU_Output(15 DOWNTO 9) WHEN "101001",
			 "0000000000" & ALU_Output(15 DOWNTO 10) WHEN "101010",
			 "00000000000" & ALU_Output(15 DOWNTO 11) WHEN "101011",
			 "000000000000" & ALU_Output(15 DOWNTO 12) WHEN "101100",
			 "0000000000000" & ALU_Output(15 DOWNTO 13) WHEN "101101",
			 "00000000000000" & ALU_Output(15 DOWNTO 14) WHEN "101110",
			 "000000000000000" &  ALU_Output(15)	      WHEN "101111",

			 ALU_Output(15) & ALU_Output(15 DOWNTO 1) WHEN "110001",		-- Deslocamento Aritmetico a Direita
			 ALU_Output(15) & ALU_Output(15) & ALU_Output(15 DOWNTO 2) WHEN "110010",
			 ALU_Output(15) & ALU_Output(15) &  ALU_Output(15) & ALU_Output(15 DOWNTO 3) WHEN "110011",
			 ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15 DOWNTO 4) WHEN "110100",
			 ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15 DOWNTO 5) WHEN "110101",
  			 ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15 DOWNTO 6) WHEN "110110",
			 ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15 DOWNTO 7) WHEN "110111",
 			 ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15 DOWNTO 8) WHEN "111000",
			 ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15 DOWNTO 9) WHEN "111001",
			 ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15 DOWNTO 10) WHEN "111010",
			 ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15 DOWNTO 11) WHEN "111011",
			 ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15 DOWNTO 12) WHEN "111100",
			 ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15 DOWNTO 13) WHEN "111101",               
			 ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15 DOWNTO 14) WHEN "111110",               
			 ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15) & ALU_Output(15)         WHEN "111111",
	
			ALU_Output(15 DOWNTO 0) WHEN OTHERS;    	--Transparencia Saida ULA
END bhv_shifter; 