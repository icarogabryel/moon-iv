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

entity cometa16_pc is
    port(
        clk: in std_logic;
        rst: in std_logic;

        z_signal:        in std_logic;
        n_signal:        in std_logic;

        ctrl_cj:         in std_logic_vector(2 downto 0);
        ctrl_ij:         in std_logic_vector(1 downto 0);

        rf1_out:         in std_logic_vector(15 downto 0);
        inst_mem_out:    in std_logic_vector(15 downto 0);
        sign_extend_out: in std_logic_vector(15 downto 0);

        hit_signal:      in std_logic;

        pc_out:          out std_logic_vector(15 downto 0);
        pc_plus_one:     out std_logic_vector(15 downto 0)

    );

end cometa16_pc;

architecture behavior_pc of cometa16_pc is
    signal pc_reg: std_logic_vector(15 downto 0) := "0000000000000000";
    signal take: std_logic;
    signal cj_mux, ij_mux: std_logic_vector(15 downto 0);

begin
    with ctrl_cj select take <=
        '0'                               when "000",
        z_signal                          when "001",
        not z_signal                      when "010",
        n_signal                          when "011",
        (not Z_signal) and (not N_signal) when "100",
        'X'                               when others;

    with take select cj_mux <=
        pc_plus_one                   when '0',
        sign_extend_out + pc_plus_one when '1',
        "XXXXXXXXXXXXXXXX"            when others;

    with ctrl_ij select ij_mux <=
        cj_mux                                          when "00",
        pc_reg(15 downto 10) & inst_mem_out(9 downto 0) when "01",
        rf1_out                                         when "10",
        "XXXXXXXXXXXXXXXX"                              when others;

    write_pc_reg: process(clk, rst, ij_mux)
    
    begin
        if (rst = '1') then
            pc_reg <= "0000000000000000";
        
        elsif ((clk'event and clk ='1') and (hit_signal = '1')) then
            pc_reg <= ij_mux;
        
        end if;
    
    end process write_pc_reg; 

    pc_out <= pc_reg;
    pc_plus_one <= pc_reg + 1;

end behavior_pc;
