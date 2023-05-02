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

entity cometa16_data_memory is
    port(
        clk: in std_logic;
        rst: in std_logic;

        ctrl_wr_data_mem: in std_logic;

        alu_out: in std_logic_vector(15 downto 0);
        ac_out: in std_logic_vector(15 downto 0);

        data_mem_out: out std_logic_vector(15 downto 0)

    );

end cometa16_data_memory;

architecture behavior_data_memory of cometa16_data_memory is
    type memory is array(0 to 15) of std_logic_vector(15 downto 0);
    signal memory_data : memory;

begin
    data_mem_out <= memory_data(conv_integer(alu_out(15 downto 0)))(15 downto 0);

    wr_data_mem_process: process(clk, rst, ctrl_wr_data_mem)

    begin
        if rst = '1' then
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

        elsif ((clk'event and clk = '1') and (ctrl_wr_data_mem = '1')) then
            memory_data(conv_integer(saida_ula_endereco(15 downto 0))) <= dadoEsc;

        end if;
			
	end process wr_data_mem_process;

end behavior_data_memory;
