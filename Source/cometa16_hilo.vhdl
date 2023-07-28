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

entity cometa16_hilo is
    port(
        clk: in std_logic;
        rst: in std_logic;

        ctrl_wr_hilo:  in std_logic;
        ctrl_src_hilo: in std_logic_vector(1 downto 0);

        sh_out:       in std_logic_vector(15 downto 0);
        ac_out:        in std_logic_vector(15 downto 0);

        lo_out:        out std_logic_vector(15 downto 0);
        hi_out:        out std_logic_vector(15 downto 0)

    );

end cometa16_hilo;

architecture behavior_hilo of cometa16_hilo is
    signal high_register:   std_logic_vector(15 downto 0);
    signal low_register:    std_logic_vector(15 downto 0);

    signal src_shifter_mux: std_logic_vector(31 downto 0);
    signal src_hilo_mux:    std_logic_vector(31 downto 0);

begin
    with low_register(0) select src_shifter_mux <=
        '0' & hi_out(15 downto 0) & lo_out(15 downto 1) when '0',
        '0' & sh_out(15 downto 0) & lo_out(15 downto 1) when '1',
        "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"               when others;

    with ctrl_src_hilo select src_hilo_mux <=
        src_shifter_mux(31 downto 0)              when "00",
        hi_out(15 downto 0) & ac_out(15 downto 0) when "01",
        ac_out(15 downto 0) & lo_out(15 downto 0) when "10",
        "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"        when others;

    lo_out <= low_register;
    hi_out <= high_register;
    
    wr_hilo: process(clk, rst, ctrl_wr_hilo)

    begin
        if (rst = '1') then
            low_register <= "0000000000000000";
            high_register <= "0000000000000000";

        elsif (clk'event and clk = '1') and (ctrl_wr_hilo = '1') then
            low_register <= src_hilo_mux(15 downto 0);
            high_register <= src_hilo_mux(31 downto 16);

        end if;

    end process;

end behavior_hilo;
