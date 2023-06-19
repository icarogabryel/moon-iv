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

entity cometa16_css is
    port(
        clk: in std_logic;
        
        core0_in: out std_logic_vector(129 downto 0);
        core0_out: in std_logic_vector(144 downto 0);
        
        core1_in: out std_logic_vector(129 downto 0);
        core1_out: in std_logic_vector(144 downto 0);

        core2_in: out std_logic_vector(129 downto 0);
        core2_out: in std_logic_vector(144 downto 0);

        core3_in: out std_logic_vector(129 downto 0);
        core3_out: in std_logic_vector(114 downto 0);

        main_mem_in: out std_logic_vector(114 downto 0);
        -- 2 miss bits, 32 rd_addr bits, 64 data_mem_bk_out bits, 16 main_mem_wr_addr bits, 1 wr_main_mem bit
        main_mem_out: in std_logic_vector(129 downto 0)

    )

end cometa16_css;

architecture behaviior_css of cometa16_css is
    signal priority: integer =: 0;

begin
    round_process: process(clk)

    begin
        if (clk'event and clk = '1')  then
            if priority = 3 then
                priority <= 0;
            else
                priority <= priority + 1;
            end if;
            
        end if;
        
    end process;

    connection_process: process(request_1, request_2, request_3, request_4)
    
    begin
        if priority = 0 then
            core0_in <= main_mem_out;
            main_mem_in <= core0_out;

            core1_in <= (others => '0');
            core2_in <= (others => '0');
            core3_in <= (others => '0');

        elsif priority = 1 then
            core1_in <= main_mem_out;
            main_mem_in <= core1_out;

            core0_in <= (others => '0');
            core2_in <= (others => '0');
            core3_in <= (others => '0');

        elsif priority = 2 then
            core2_in <= main_mem_out;
            main_mem_in <= core2_out;

            core0_in <= (others => '0');
            core1_in <= (others => '0');
            core3_in <= (others => '0');

        elsif priority = 3 then
            core3_in <= main_mem_out;
            main_mem_in <= core3_out;

            core0_in <= (others => '0');
            core1_in <= (others => '0');
            core2_in <= (others => '0');
            
        end if;
            
    end process;
    