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
use ieee.numeric_std.all;

entity cometa16_shifter is
    port(
        ctrl_sh:     in std_logic_vector(1 downto 0);
        shamt:       in std_logic_vector(3 downto 0);

        alu_out:     in std_logic_vector(15 downto 0);

        shifter_out: out std_logic_vector(15 downto 0)
    );

end cometa16_shifter;

architecture behavior_shifter of cometa16_shifter is

begin
    with ctrl_sh select shifter_out <=
        alu_out(15 downto 0)                                              when "00",
        std_logic_vector(signed(alu_out) sll to_integer(unsigned(shamt))) when "01",
        std_logic_vector(signed(alu_out) srl to_integer(unsigned(shamt))) when "10",
		std_logic_vector(signed(alu_out) sra to_integer(unsigned(shamt))) when "11",
        "XXXXXXXXXXXXXXXX"                                                when others;

end behavior_shifter;
