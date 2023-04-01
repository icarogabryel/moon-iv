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
-- || 	- Icaro Gabryel de Araujo Silva                             ||
-- ||   - Fabio Anderson Carvalho Silva                             ||
-- ||   - Cayo Cesar Lopes Mascarenhas Pires Cardoso                ||
-- ||   - Claudiney Ryan da Silva                                   ||
-- ||   - Antonio Geraldo Rego Junior                               ||
-- ||   - Nivaldo Nogueira Paranagua Santos e Silva                 ||
-- ||   - Ivan Saraiva Silva                                        ||
-- ||                                                               ||
-- ||***************************************************************||

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity cometa16_alu is
    port(     
        -- Control signals
        control_alu:   in std_logic_vector(3 downto 0);
        control_mux_a: in std_logic;
        control_mux_b: in std_logic_vector(1 downto 0);
		
		-- Multiplexer A in
        rf1_data:       in std_logic_vector(15 downto 0);
        rf2_data:       in std_logic_vector(15 downto 0);
		
		-- Multiplexer B in
        rd_data:        in std_logic_vector(15 downto 0);
        ex_data:        in std_logic_vector(15 downto 0);
        high_data:      in std_logic_vector(15 downto 0);
		
        -- Signals z(Zero) and n(negative)
        z_signal:       out std_logic;
        n_signal:       out std_logic;

        alu_out:        out std_logic_vector(15 downto 0)
    );

end cometa16_alu;

architecture behavior_alu of cometa16_alu is
    -- Out of the multiplexers
    signal out_mux_a: std_logic_vector(15 downto 0);
    signal out_mux_b: std_logic_vector(15 downto 0);

begin
    with control_mux_a select out_mux_a <=
		rf1_data(15 downto 0)  when '0',
        rd_signal(15 downto 0) when others;

    with control_mux_b select out_mux_b <=
		rf2_data(15 downto 0)  when "00",
        ex_data(15 downto 0)   when "01",
        high_data(15 downto 0) when others;

    with control_alu select alu_out <=
        out_amux_a(15 downto 0)                              when "0010",
        out_amux_b(15 downto 0)                              when "0011",
		out_amux_a(15 downto 0) +    out_amux_b(15 downto 0) when "0000",
        out_amux_a(15 downto 0) -    out_amux_b(15 downto 0) when "0001",
        out_amux_a(15 downto 0) and  out_amux_b(15 downto 0) when "0100",
        out_amux_a(15 downto 0) or   out_amux_b(15 downto 0) when "0101",
        out_amux_a(15 downto 0) xor  out_amux_b(15 downto 0) when "0110",
        out_amux_a(15 downto 0) nor  out_amux_b(15 downto 0) when "0111",  
        out_amux_a(15 downto 0) nand out_amux_b(15 downto 0) when others;

    with alu_out select z <=
        '1' when "0000000000000000",
        '0' when others;

    n <= alu_out(15);

end behavior_alu;
