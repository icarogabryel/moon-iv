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

entity cometa16_instruction_memory is
    port(
        clk: in std_logic;
        rst: in std_logic;

        pc_out: in std_logic_vector(15 downto 0);
        main_mem_out: in std_logic_vector(63 downto 0);
        ctrl_wr_ins_mem: in std_logic;

        ins_mux: out std_logic_vector(15 downto 0);
        hit_out: out std_logic

    );

end cometa16_instruction_memory;

architecture behavior_instruction_memory of cometa16_instruction_memory is
    type memory is array(0 to 3, 0 to 3) of std_logic_vector(28 downto 0);
    signal instruction_memory: memory;

    signal hit_signal: std_logic;
    signal ins_mem_data_read: std_logic_vector(28 downto 0);

begin
    ins_mem_data_read <= instruction_memory(conv_integer(pc_out(3 downto 2)), conv_integer(pc_out(1 downto 0)));

    hit_process : process (clk, rst)
    
    begin
        if (pc_out(15 downto 4) = ins_mem_data_read(27 downto 16)) and (ins_mem_data_read(28) = '1') then
            hit_signal <= '1';
        else
            hit_signal <= '0';
        end if;

    end process hit_process;

    hit_out <= hit_signal;

    with hit_signal select
        ins_mux <=
            "0000000000000000"             when '0',
            ins_mem_data_read(15 downto 0) when '1',
            "XXXXXXXXXXXXXXXX"             when others;

    wr_ins_mem_process: process (clk, rst)
    
    begin
        if rst = '1' then
            instruction_memory(0, 0)  <= "00000000000000000000000000000";
            instruction_memory(0, 1)  <= "00000000000000000000000000000";
            instruction_memory(0, 2)  <= "00000000000000000000000000000";
            instruction_memory(0, 3)  <= "00000000000000000000000000000";
            instruction_memory(1, 0)  <= "00000000000000000000000000000";
            instruction_memory(1, 1)  <= "00000000000000000000000000000";
            instruction_memory(1, 2)  <= "00000000000000000000000000000";
            instruction_memory(1, 3)  <= "00000000000000000000000000000";
            instruction_memory(2, 0)  <= "00000000000000000000000000000";
            instruction_memory(2, 1)  <= "00000000000000000000000000000";
            instruction_memory(2, 2)  <= "00000000000000000000000000000";
            instruction_memory(2, 3)  <= "00000000000000000000000000000";
            instruction_memory(3, 0)  <= "00000000000000000000000000000";
            instruction_memory(3, 1)  <= "00000000000000000000000000000";
            instruction_memory(3, 2)  <= "00000000000000000000000000000";
            instruction_memory(3, 3)  <= "00000000000000000000000000000";
        
        elsif ((clk'event and clk = '1') and (ctrl_wr_ins_mem = '1')) then
            instruction_memory((conv_integer(pc_out)/4) mod 4, 0) <= '1' & pc_out(15 downto 4) & main_mem_out(63 downto 48);
            instruction_memory((conv_integer(pc_out)/4) mod 4, 1) <= '1' & pc_out(15 downto 4) & main_mem_out(47 downto 32);
            instruction_memory((conv_integer(pc_out)/4) mod 4, 2) <= '1' & pc_out(15 downto 4) & main_mem_out(31 downto 16);
            instruction_memory((conv_integer(pc_out)/4) mod 4, 3) <= '1' & pc_out(15 downto 4) & main_mem_out(15 downto 0);

        end if;
	
    end process wr_ins_mem_process;

end behavior_instruction_memory;
