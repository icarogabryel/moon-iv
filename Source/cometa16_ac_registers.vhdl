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

entity cometa16_ac_registers is
    port(
        clk: in std_logic;
        rst: in std_logic;

        ctrl_wr_ac:   in std_logic;
        ctrl_src_ac:  in std_logic_vector(2 downto 0);

        shifter_out:  in std_logic_vector(15 downto 0);
        data_mem_out: in std_logic_vector(15 downto 0);
        n_signal:     in std_logic;
        hi_out:       in std_logic_vector(15 downto 0);
        lo_out:       in std_logic_vector(15 downto 0);

        ac_addr:      in std_logic_vector(1 downto 0);
        ac_out:       out std_logic_vector(15 downto 0)

    );

end cometa16_ac_registers;

architecture behavior_ac_registers of cometa16_ac_registers is
    type registers is array(0 to 3) of std_logic_vector(15 downto 0);
    signal ac_registers: registers;

    signal src_ac_mux : std_logic_vector(15 downto 0);

begin
    with ctrl_src_ac select src_ac_mux <=
        shifter_out                  when "000",
        data_mem_out                 when "001",
        "000000000000000" & n_signal when "010",
        lo_out                       when "011",
        hi_out                       when "100",
        "XXXXXXXXXXXXXXXX"           when others;

    ac_out <= ac_registers(conv_integer(ac_addr(1 downto 0)))(15 downto 0);

    wr_ac_regiters: process(clk, rst, ctrl_wr_ac)

    begin
        if (rst = '1') then
            ac_registers(0) <= "0000000000000000";
            ac_registers(1) <= "0000000000000000";
            ac_registers(2) <= "0000000000000000";
            ac_registers(3) <= "0000000000000000";
        
        elsif ((clk'event and clk ='1') and (ctrl_wr_ac = '1')) then
            ac_registers(conv_integer(ac_addr(1 downto 0))) <= src_ac_mux;

        end if;
            
    end process wr_ac_regiters;

end behavior_ac_registers;
