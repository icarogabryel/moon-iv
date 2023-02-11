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

entity ISA_pc is
    port 
    (
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
end ISA_pc;

architecture bhv_pc of ISA_pc is
    signal pc_register : std_logic_vector(15 DOWNTO 0);
    signal write_data  : std_logic_vector(15 downto 0);
    signal AmuxCond_Out : std_logic;
    signal saida_mux1, saida_mux2 : std_logic_vector(15 downto 0);
    signal dadoLidoPC :STD_LOGIC_VECTOR (15 DOWNTO 0);
    signal dadoLidoPCmaisUm :STD_LOGIC_VECTOR (15 DOWNTO 0);
    
    begin

	dadoLidoPC <= pc_register; 
	dadoLidoPCmaisUm <= dadoLidoPC + 1;
	
	WITH DvC SELECT
        AmuxCond_Out  <= Z    	    WHEN "000",
			  not Z 	                WHEN "001",
			  N                     WHEN "010",
			  ((not Z) and (not N)) WHEN "011",
                          '0' 			WHEN OTHERS;
	
	WITH AmuxCond_Out SELECT
        saida_mux1    <=  PCmaisUm    			        WHEN '0',
                          (Signal_Extension + dadoLidoPCmaisUm)	WHEN OTHERS;

	WITH DvI SELECT
         saida_mux2   <=  saida_mux1    		WHEN "00",
			              PC_Out(15 DOWNTO 10) & Imm 	WHEN "01",
                          rf1_lido 		        WHEN OTHERS;
	
        write_pc_register : process (clk, reset, saida_mux2)
	        begin
		    if reset = '1' then
                    pc_register <= "0000000000000000";
                elsif ((clk'event and clk ='1')) then
                    pc_register <= saida_mux2;
                end if;
            end process write_pc_register; 

	PCmaisUm <= DadoLidoPCmaisUm;
	PC_Out <= dadoLidoPC; 

END bhv_pc;
