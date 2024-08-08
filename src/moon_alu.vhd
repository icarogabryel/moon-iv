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
        ctrl_alu        : in  std_logic_vector(3 downto 0);
        ctrl_src_alu_a  : in  std_logic_vector(1 downto 0);
        ctrl_src_alu_b  : in  std_logic;
        rf1_out         : in  std_logic_vector(15 downto 0);
        rf2_out         : in  std_logic_vector(15 downto 0);
        ac_out          : in  std_logic_vector(15 downto 0);
        sign_extend_out : in  std_logic_vector(15 downto 0);
        hi_out          : in  std_logic_vector(15 downto 0);
        z_signal        : out std_logic;
        n_signal        : out std_logic;
        c_signal        : out std_logic;
        alu_out         : out std_logic_vector(15 downto 0)
    );

end entity;

architecture bhv_alu of moon_alu is
    signal out_mux_a : std_logic_vector(15 downto 0);
    signal out_mux_b : std_logic_vector(15 downto 0);
    signal op_result : std_logic_vector(16 downto 0);

begin
    with ctrl_src_alu_a select out_mux_a <=
        rf1_out(15 downto 0) when "00",
        ac_out(15 downto 0)  when "01",
        hi_out(15 downto 0)  when others;

    with ctrl_src_alu_b select out_mux_b <=
        rf2_out(15 downto 0)         when '0',
        sign_extend_out(15 downto 0) when others;

    with ctrl_alu select op_result <=
        ("0" & out_mux_a)                        when "0000",  -- A transparency
        ("0" & out_mux_b)                        when "0001",  -- B transparency
        ("0" & out_mux_a) + ("0" & out_mux_b)    when "0010", -- Addition with carry
        ("0" & out_mux_a) - ("0" & out_mux_b)    when "0011", -- Subtraction with carry
        not ("0" & out_mux_a)                    when "0100", -- NOT A
        ("0" & out_mux_a) and  ("0" & out_mux_b) when "0101",
        ("0" & out_mux_a) or   ("0" & out_mux_b) when "0110",
        ("0" & out_mux_a) xor  ("0" & out_mux_b) when "0111",
        ("0" & out_mux_a) nand ("0" & out_mux_b) when "1000",
        ("0" & out_mux_a) nor  ("0" & out_mux_b) when "1001",
        ("0" & out_mux_a) xnor ("0" & out_mux_b) when "1010";

    alu_out  <= op_result(15 downto 0); -- Assign the lower 16 bits to alu_out
    c_signal <= op_result(16);          -- Assign the carry-out to c_signal
    z_signal <= '1' when (alu_out = 0) else '0'; -- Assign the zero signal
    n_signal <= alu_out(15);            -- Assign the negative signal

    valid_ctrl_alu: process(ctrl_alu)
    begin
        if ctrl_alu > "1010" then
            report "ctrl_alu signal off range" severity failure;

        end if;

    end process;

end architecture;
