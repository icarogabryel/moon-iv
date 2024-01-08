-- ||***************************************************||
-- ||                                                   ||
-- ||   FEDERAL UNIVERSITY OF PIAUI                     ||
-- ||   NATURE SCIENCE CENTER                           ||
-- ||   COMPUTING DEPARTMENT                            ||
-- ||                                                   ||
-- ||   Computer for Every Task Architecture Mark II    ||
-- ||   COMETA MK II                                    ||
-- ||                                                   ||
-- ||   Developer: Icaro Gabryel                        ||
-- ||                                                   ||
-- ||***************************************************||

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cometa16_inst_mem is
    port(
        clk: in std_logic;
        rst: in std_logic;

        pc_out: in std_logic_vector(15 downto 0);

        main_to_inst_bk: in std_logic_vector(63 downto 0);
        wr_inst_from_main: in std_logic;

        inst_hit_out: out std_logic;
        inst_mem_out: out std_logic_vector(15 downto 0)

    );

end cometa16_inst_mem;

architecture behavior_inst_mem of cometa16_inst_mem is
    type memory is array(0 to 3, 0 to 3) of std_logic_vector(28 downto 0);
    signal inst_mem: memory;

    signal hit_signal: std_logic;
    signal data_pointed: std_logic_vector(28 downto 0);

begin
    data_pointed <= inst_mem(conv_integer(pc_out(3 downto 2)), conv_integer(pc_out(1 downto 0)));

    hit_process: process(data_pointed, pc_out)
    
    begin
        if (pc_out(15 downto 4) = data_pointed(27 downto 16)) and (data_pointed(28) = '1') then
            hit_signal <= '1';
        else
            hit_signal <= '0';
        end if;

    end process hit_process;

    inst_hit_out <= hit_signal;

    with hit_signal select inst_mem_out <=
        "0000000000000000"        when '0',
        data_pointed(15 downto 0) when '1',
        "XXXXXXXXXXXXXXXX"        when others;

    wr_inst_mem_process: process (clk, rst)
    
    begin
        if (rst = '1') then
            inst_mem(0, 0)  <= "00000000000000000000000000000";
            inst_mem(0, 1)  <= "00000000000000000000000000000";
            inst_mem(0, 2)  <= "00000000000000000000000000000";
            inst_mem(0, 3)  <= "00000000000000000000000000000";
            inst_mem(1, 0)  <= "00000000000000000000000000000";
            inst_mem(1, 1)  <= "00000000000000000000000000000";
            inst_mem(1, 2)  <= "00000000000000000000000000000";
            inst_mem(1, 3)  <= "00000000000000000000000000000";
            inst_mem(2, 0)  <= "00000000000000000000000000000";
            inst_mem(2, 1)  <= "00000000000000000000000000000";
            inst_mem(2, 2)  <= "00000000000000000000000000000";
            inst_mem(2, 3)  <= "00000000000000000000000000000";
            inst_mem(3, 0)  <= "00000000000000000000000000000";
            inst_mem(3, 1)  <= "00000000000000000000000000000";
            inst_mem(3, 2)  <= "00000000000000000000000000000";
            inst_mem(3, 3)  <= "00000000000000000000000000000";
        
        elsif ((clk'event and clk = '1') and (wr_inst_from_main = '1')) then
            inst_mem((conv_integer(pc_out)/4) mod 4, 0) <= '1' & pc_out(15 downto 4) & main_to_inst_bk(63 downto 48);
            inst_mem((conv_integer(pc_out)/4) mod 4, 1) <= '1' & pc_out(15 downto 4) & main_to_inst_bk(47 downto 32);
            inst_mem((conv_integer(pc_out)/4) mod 4, 2) <= '1' & pc_out(15 downto 4) & main_to_inst_bk(31 downto 16);
            inst_mem((conv_integer(pc_out)/4) mod 4, 3) <= '1' & pc_out(15 downto 4) & main_to_inst_bk(15 downto 0);

        end if;
	
    end process wr_inst_mem_process;

end behavior_inst_mem;
