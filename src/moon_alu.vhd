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
use ieee.std_logic_signed.all;

entity moon_alu is
    port(
        ctrl_alu:        in std_logic_vector(3 downto 0);
        ctrl_src_alu_a:  in std_logic_vector(1 downto 0);
        ctrl_src_alu_b:  in std_logic;

        rf1_out:         in std_logic_vector(15 downto 0);
        rf2_out:         in std_logic_vector(15 downto 0);

        ac_out:          in std_logic_vector(15 downto 0);
        sign_extend_out: in std_logic_vector(15 downto 0);
        hi_out:          in std_logic_vector(15 downto 0);

        z_signal:        out std_logic;
        n_signal:        out std_logic;
        
        alu_out:         out std_logic_vector(15 downto 0)
    );

end moon_alu;

architecture bhv_alu of moon_alu is
    signal out_mux_a: std_logic_vector(15 downto 0);
    signal out_mux_b: std_logic_vector(15 downto 0);

begin
    with ctrl_src_alu_a select out_mux_a <=
        rf1_out(15 downto 0)
        when "00",
        ac_out(15 downto 0)
        when "01",
        hi_out(15 downto 0)
        when others;

    with ctrl_src_alu_b select out_mux_b <=
        rf2_out(15 downto 0)
        when '0',
        sign_extend_out(15 downto 0)
        when others;

    with ctrl_alu select alu_out <=
        out_mux_a(15 downto 0)                             when "0000",
        out_mux_b(15 downto 0)                             when "0001",

        out_mux_a(15 downto 0) +    out_mux_b(15 downto 0) when "0010",
        out_mux_a(15 downto 0) -    out_mux_b(15 downto 0) when "0011",

        not out_mux_a(15 downto 0)                         when "0100",

        out_mux_a(15 downto 0) and  out_mux_b(15 downto 0) when "0101",
        out_mux_a(15 downto 0) or   out_mux_b(15 downto 0) when "0110",
        out_mux_a(15 downto 0) xor  out_mux_b(15 downto 0) when "0111",
        out_mux_a(15 downto 0) nand out_mux_b(15 downto 0) when "1000",
        out_mux_a(15 downto 0) nor  out_mux_b(15 downto 0) when "1001",
        out_mux_a(15 downto 0) xnor out_mux_b(15 downto 0) when "1010",

        "XXXXXXXXXXXXXXXX"                                 when others;

    z_signal <= '1' when ieee.std_logic_unsigned."="(alu_out, "0000000000000000") else '0';
    n_signal <= alu_out(15);

end bhv_alu;
