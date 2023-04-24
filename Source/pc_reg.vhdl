library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity pc_reg is
    port(
        clk: in std_logic;
        rst: in std_logic;
        hit: in std_logic;
        pc_out: out std_logic_vector(15 downto 0)

    );

end pc_reg;

architecture behavior_pc_reg of pc_reg is
    signal pc: std_logic_vector(15 downto 0);

begin
    update: process(clk, rst)

    begin
        if rst = '1' then
            pc <= "0000000000000000";

        elsif ((clk'event and clk = '1') and (hit = '1')) then
            pc <= pc + 1;

        end if;

    end process update;

    pc_out <= pc;

end behavior_pc_reg;
