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

entity cometa16_sign_extend is
    port(
        ctrl_sign_extend: in std_logic_vector(1 downto 0);
        imm:              in std_logic_vector(7 downto 0);

        sign_extend_out:  out std_logic_vector(15 downto 0)

    );

end cometa16_sign_extend;

architecture behavior_sign_extend of cometa16_sign_extend is

begin
    with ctrl_sign_extend select sign_extend_out <=
        "00000000" & imm(7 downto 0)         when "00",
        imm(7 downto 0) & "00000000"         when "01",
        (0 to 7 => imm(7)) & imm(7 downto 0) when "11",
        "XXXXXXXXXXXXXXXX"                   when others;

end behavior_sign_extend;
