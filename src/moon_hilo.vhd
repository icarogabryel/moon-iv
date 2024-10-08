-- ||******************************************||
-- ||                                          ||
-- ||   FEDERAL UNIVERSITY OF PIAUI            ||
-- ||   NATURE SCIENCE CENTER                  ||
-- ||   COMPUTING DEPARTMENT                   ||
-- ||                                          ||
-- ||   Many As Only ONe Quad-Core - MOON IV   ||
-- ||                                          ||
-- ||   Developer: Icaro Gabryel               ||
-- ||                                          ||
-- ||******************************************||

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity moon_hilo is
    port(
        clk           : in  std_logic;
        rst           : in  std_logic;
        ctrl_wr_hilo  : in  std_logic;
        ctrl_src_hilo : in  std_logic_vector(1 downto 0);
        shifter_out   : in  std_logic_vector(15 downto 0);
        ac_out        : in  std_logic_vector(15 downto 0);
        c_signal      : in  std_logic;
        lo_out        : out std_logic_vector(15 downto 0);
        hi_out        : out std_logic_vector(15 downto 0)
    );

end moon_hilo;

architecture bhv_hilo of moon_hilo is
    signal high_register : std_logic_vector(15 downto 0);
    signal low_register  : std_logic_vector(15 downto 0);

    signal mul_mux_and_right_shifter : std_logic_vector(31 downto 0);
    signal div_mux_and_left_shifter  : std_logic_vector(31 downto 0);
    signal src_hilo_mux              : std_logic_vector(31 downto 0);

begin
    with low_register(0) select mul_mux_and_right_shifter <= -- Multiplication step.
        '0' & hi_out(15 downto 0) & lo_out(15 downto 1)           when '0', -- Just shift right.
        c_signal & shifter_out(15 downto 0) & lo_out(15 downto 1) when others; -- Add and shift right.

    with shifter_out(15) select div_mux_and_left_shifter <= -- Division step.
        shifter_out(14 downto 0) & lo_out(15 downto 0) & '1' when '0', -- Positive result, save subtraction and shift left with '1'.
        hi_out(14 downto 0) & lo_out(15 downto 0) & '0'      when others; -- Negative result, don't save subtraction and shift left with '0'.

    with ctrl_src_hilo select src_hilo_mux <=
        mul_mux_and_right_shifter(31 downto 0)    when "00",
        div_mux_and_left_shifter(31 downto 0)     when "01",
        hi_out(15 downto 0) & ac_out(15 downto 0) when "10",
        ac_out(15 downto 0) & lo_out(15 downto 0) when others;

    lo_out <= low_register;
    hi_out <= high_register;

    wr_hilo : process(clk, rst, ctrl_wr_hilo)
    begin
        if (rst = '1') then
            low_register  <= "0000000000000000";
            high_register <= "0000000000000000";

        elsif (clk'event and clk = '1') and (ctrl_wr_hilo = '1') then
            low_register  <= src_hilo_mux(15 downto 0);
            high_register <= src_hilo_mux(31 downto 16);

        end if;

    end process;

end bhv_hilo;
