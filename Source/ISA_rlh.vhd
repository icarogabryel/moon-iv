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

ENTITY ISA_rlh IS
    PORT (
        -- Sinais de clok e reset
        clk           : IN STD_LOGIC;
        reset         : IN STD_LOGIC;

        -- Sinais de controle
        EscRLH        : IN STD_LOGIC;
        SrcRLH        : IN STD_LOGIC;

        -- Entradas de dados
        rf1_mais_high : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        rd            : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        -- Dados lidos
        low_out       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        high_out      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ISA_rlh;

ARCHITECTURE bhv_ISA_rlh OF ISA_rlh IS
    SIGNAL high_register : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL low_register  : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL write_data1   : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL write_data2   : STD_LOGIC_VECTOR (31 DOWNTO 0);

BEGIN
    WITH low_register(0) SELECT
        write_data1 <= '0' & high_out(15 DOWNTO 0) & low_out(15 DOWNTO 1) WHEN '0',
                       '0' & rf1_mais_high(15 DOWNTO 0) & low_out(15 DOWNTO 1) WHEN OTHERS;

    WITH SrcRLH SELECT
        write_data2 <= "0000000000000000" & rd(15 DOWNTO 0) WHEN '0',
                       write_data1 WHEN OTHERS;

    low_out  <= low_register;
    high_out <= high_register;
    
    write_high : PROCESS (clk, reset, EscRLH)
    BEGIN
        IF (reset = '1') THEN
            low_register <= "0000000000000000";
            high_register <= "0000000000000000";

        ELSIF (clk'EVENT AND clk = '1') AND (EscRLH = '1') THEN
            low_register <= write_data2(15 DOWNTO 0);
            high_register <= write_data2(31 DOWNTO 16);

        END IF;
    END PROCESS;

END bhv_ISA_rlh;