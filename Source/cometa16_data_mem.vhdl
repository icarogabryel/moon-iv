-- ||***********************************************************||
-- ||                                                           ||
-- ||   FEDERAL UNIVERSITY OF PIAUI                             ||
-- ||   NATURE SCIENCE CENTER                                   ||
-- ||   COMPUTING DEPARTMENT                                    ||
-- ||                                                           ||
-- ||   Computer for Every Task Architecture 16 Bits Mark II    ||
-- ||   COMETA 16 MK II                                         ||
-- ||                                                           ||
-- ||   Developer: Icaro Gabryel de Araujo Silva                ||
-- ||                                                           ||
-- ||***********************************************************||

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cometa16_data_mem is
    port(
        clk: in std_logic;
        rst: in std_logic;

        ctrl_wr_data_mem: in std_logic;
        ctrl_rd_data_mem: in std_logic;

        alu_out: in std_logic_vector(15 downto 0);
        ac_out: in std_logic_vector(15 downto 0);

        css_out: in std_logic_vector(64 downto 0);
        
        data_hit_out: out std_logic;
        data_mem_out: out std_logic_vector(15 downto 0)
        data_mem_to_css: out std_logic_vector(64 downto 0)

    );

end cometa16_data_mem;

architecture behavior_data_mem of cometa16_data_mem is
    type memory is array(0 to 3, 0 to 3) of std_logic_vector(29 downto 0);
    signal data_mem: memory;

    signal hit_signal: std_logic;

begin
    data_mem_out <= memory_data(conv_integer(alu_out(3 downto 2)), conv_integer(alu_out(1 downto 0)));
    
    data_mem_to_css <=
        '1'                                  &
        data_mem(conv_integer(alu_out)/4, 0) &
        data_mem(conv_integer(alu_out)/4, 1) &
        data_mem(conv_integer(alu_out)/4, 2) &
        data_mem(conv_integer(alu_out)/4, 3);
    
    hit_process: process (clk, rst)
    
    begin
        if (alu_out(15 downto 4) = data_mem_out(27 downto 16)) and (data_mem_out(28) = '1') then --todo
            hit_signal <= '1';
        else
            hit_signal <= '0';
        end if;

    end process hit_process;
    
    with ctrl_rd_data_mem select data_hit_out <=
        '1'        when '0',
        hit_signal when '1',
        'X'        when others;

    wr_data_mem_process: process(clk, rst, ctrl_wr_data_mem)

    begin
        if (rst = '1') then
            data_mem(0)  <= "0000000000000000";  
            data_mem(1)  <= "0000000000000000"; 
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
            memory_data(conv_integer(alu_out(15 downto 0))) <= ac_out;

        end if;
			
	end process wr_data_mem_process;

end behavior_data_mem;
