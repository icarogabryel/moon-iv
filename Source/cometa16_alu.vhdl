-- ||***************************************************************||
-- ||                                                               ||
-- ||   FEDERAL UNIVERSITY OF PIAUI                                 ||
-- ||   NATURE SCIENCE CENTER                                       ||
-- ||   COMPUTING DEPARTMENT                                        ||
-- ||                                                               ||
-- ||   Computer for Every Task Architecture 16 Bits - COMETA 16    ||
-- ||                                                               ||
-- ||   Registred in National Institute of Industrial Property      ||
-- ||   (INPI) under the number BR 51 2023 000286 0                 ||
-- ||                                                               ||
-- ||   Developers:                                                 ||
-- ||   - Icaro Gabryel de Araujo Silva                             ||
-- ||   - Fabio Anderson Carvalho Silva                             ||
-- ||   - Cayo Cesar Lopes Mascarenhas Pires Cardoso                ||
-- ||   - Claudiney Ryan da Silva                                   ||
-- ||   - Antonio Geraldo Rego Junior                               ||
-- ||   - Nivaldo Nogueira Paranagua Santos e Silva                 ||
-- ||   - Ivan Saraiva Silva                                        ||
-- ||                                                               ||
-- ||***************************************************************||

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity cometa16_alu is
    port(
        control_alu:   in std_logic_vector(3 downto 0);
        control_mux_a: in std_logic;
        control_mux_b: in std_logic_vector(1 downto 0);

        rf1_data:      in std_logic_vector(15 downto 0);
        rf2_data:      in std_logic_vector(15 downto 0);

        rd_data:       in std_logic_vector(15 downto 0);
        ex_data:       in std_logic_vector(15 downto 0);
        hi_data:       in std_logic_vector(15 downto 0);

        z_signal:      out std_logic;
        n_signal:      out std_logic;

        alu_out:       out std_logic_vector(15 downto 0)
    );

end cometa16_alu;

architecture behavior_alu of cometa16_alu is
    signal out_mux_a: std_logic_vector(15 downto 0);
    signal out_mux_b: std_logic_vector(15 downto 0);
    signal alu_result:   std_logic_vector(15 downto 0);

begin
    with control_mux_a select out_mux_a <=
        rf1_data(15 downto 0)  when '0',
        rd_data(15 downto 0)   when '1',

        "XXXXXXXXXXXXXXXX"     when others;

    with control_mux_b select out_mux_b <=
        rf2_data(15 downto 0)  when "00",
        ex_data(15 downto 0)   when "01",
        hi_data(15 downto 0)   when "11",

        "XXXXXXXXXXXXXXXX"     when others;

    with control_alu select alu_result <=
        out_mux_a(15 downto 0)                             when "0000",
        out_mux_b(15 downto 0)                             when "0001",

        not out_mux_a(15 downto 0)                         when "0010",
        not out_mux_b(15 downto 0)                         when "0011",

        out_mux_a(15 downto 0) +    out_mux_b(15 downto 0) when "0100",
        out_mux_a(15 downto 0) -    out_mux_b(15 downto 0) when "0101",

        out_mux_a(15 downto 0) and  out_mux_b(15 downto 0) when "0110",
        out_mux_a(15 downto 0) or   out_mux_b(15 downto 0) when "0111",
        out_mux_a(15 downto 0) xor  out_mux_b(15 downto 0) when "1000",
        out_mux_a(15 downto 0) nand out_mux_b(15 downto 0) when "1001",
        out_mux_a(15 downto 0) nor  out_mux_b(15 downto 0) when "1010",
        out_mux_a(15 downto 0) xnor out_mux_b(15 downto 0) when "1011",

        "XXXXXXXXXXXXXXXX"                                 when others;

    z_signal <= '1' when ieee.std_logic_unsigned."="(alu_result, "0000000000000000") else '0';
    n_signal <= alu_result(15);

    alu_out <= alu_result(15 downto 0);

end behavior_alu;
