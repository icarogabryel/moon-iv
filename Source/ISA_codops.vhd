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

package codops is
        -- Instrucoes Logicas e Aritmeticas

        constant ADDx    : std_logic_vector(5 downto 0):= "000000";
        constant SUBx    : std_logic_vector(5 downto 0):= "000001";
        constant SLLx    : std_logic_vector(5 downto 0):= "000010";
        constant SRLx    : std_logic_vector(5 downto 0):= "000011";
        constant SRAx    : std_logic_vector(5 downto 0):= "000100";
        constant ANDx    : std_logic_vector(5 downto 0):= "000101";
        constant ORx     : std_logic_vector(5 downto 0):= "000110";
        constant XORx    : std_logic_vector(5 downto 0):= "000111";
        constant NORx    : std_logic_vector(5 downto 0):= "001000";
        constant MFACx   : std_logic_vector(5 downto 0):= "001001";
        constant MTACx   : std_logic_vector(5 downto 0):= "001010";
        constant SLTx    : std_logic_vector(5 downto 0):= "001011";

        -- Instrucoes com Operando Imediato

        constant ADDIS  : std_logic_vector(5 downto 0):= "001100";
        constant SUBIS  : std_logic_vector(5 downto 0):= "001101";
        constant LOI    : std_logic_vector(5 downto 0):= "001110";
        constant LUI    : std_logic_vector(5 downto 0):= "001111";
        constant LIS    : std_logic_vector(5 downto 0):= "010000";
        constant ANDI   : std_logic_vector(5 downto 0):= "010001";
        constant ORI    : std_logic_vector(5 downto 0):= "010010";
        constant XORI   : std_logic_vector(5 downto 0):= "010011";
        constant NORI   : std_logic_vector(5 downto 0):= "010100";
        constant NANDI  : std_logic_vector(5 downto 0):= "010101";

        -- Instrucoes com acesso a memoria

        constant lWR    : std_logic_vector(5 downto 0):= "010110";
        constant SWR    : std_logic_vector(5 downto 0):= "010111";
        constant PUSHx   : std_logic_vector(5 downto 0):= "011000";
        constant POPx    : std_logic_vector(5 downto 0):= "011001";

        -- Instrucoes de Salto

        constant J      : std_logic_vector(5 downto 0):= "011010";
        constant JAL    : std_logic_vector(5 downto 0):= "011011";
        constant JR     : std_logic_vector(5 downto 0):= "011100";
        constant JRL    : std_logic_vector(5 downto 0):= "011101";
        constant JGTZ   : std_logic_vector(5 downto 0):= "011110";
        constant JLTZ   : std_logic_vector(5 downto 0):= "011111";
        constant JNEZ   : std_logic_vector(5 downto 0):= "100000";
        constant JIZE   : std_logic_vector(5 downto 0):= "100001";

        -- Instrucoes com RLH
        constant TADM      : std_logic_vector(5 downto 0):= "100010";
        constant MTL       : std_logic_vector(5 downto 0):= "100011";
        constant MFH       : std_logic_vector(5 downto 0):= "100100";
        constant MFL       : std_logic_vector(5 downto 0):= "100101";
end package;

package body codops is

end package body;