-- ||****************************************************************||
-- ||                                                                ||
-- ||   FEDERAL UNIVERSITY OF PIAUI                                  ||
-- ||   NATURE SCIENCE CENTER                                        ||
-- ||   COMPUTING DEPARTMENT                                         ||
-- ||                                                                ||
-- ||   Computer for Every Task Architecture 16 Bits Generation 2    ||
-- ||   COMETA 16 G2                                                 ||
-- ||                                                                ||
-- ||   Developer: Icaro Gabryel de Araujo Silva                     ||
-- ||                                                                ||
-- ||****************************************************************||

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cometa16_miss_penalty_unit is
    port(
        clk: in std_logic;
        rst: in std_logic;

        hit: in std_logic;
        rd_time: in std_logic_vector(9 downto 0);

        ctrl_ins_mem_wr: out std_logic

    );

end cometa16_miss_penalty_unit;

architecture behavior_miss_penalty_unit of cometa16_miss_penalty_unit is
    signal clk_period: integer := 40;
    signal miss_penalty: integer;
    signal cont: integer := 1;

begin
    penalty_process: process(clk, rst)

    begin
        if (rst = '1') then
            miss_penalty <= (conv_integer(rd_time) / clk_period) + 1;
            
        elsif ((not hit = '1') and (clk'event and clk = '1')) then
            cont <= cont + 1;
            
            if (cont = miss_penalty) then
                cont <= 1;
                
            end if;
            
            if ((cont + 1) = miss_penalty) then
                ctrl_ins_mem_wr <= '1';
                
            else
                ctrl_ins_mem_wr <= '0';
                
            end if;

        end if;
    
    end process;

end behavior_miss_penalty_unit;
