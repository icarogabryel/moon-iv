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
    signal out_mux_a       : std_logic_vector(15 downto 0);
    signal out_mux_b       : std_logic_vector(15 downto 0);
    signal extended_sign_a : std_logic_vector(16 downto 0);
    signal extended_sign_b : std_logic_vector(16 downto 0);
    signal op_result       : std_logic_vector(16 downto 0);

begin
    with ctrl_src_alu_a select out_mux_a <=
        rf1_out(15 downto 0) when "00",
        ac_out(15 downto 0)  when "01",
        hi_out(15 downto 0)  when others;

    with ctrl_src_alu_b select out_mux_b <=
        rf2_out(15 downto 0)         when '0',
        sign_extend_out(15 downto 0) when others;

    extended_sign_a <= '0' & out_mux_a;
    extended_sign_b <= '0' & out_mux_b;

    with ctrl_alu select op_result <=
        extended_sign_a                      when "0000",  -- A transparency
        extended_sign_b                      when "0001",  -- B transparency
        extended_sign_a + extended_sign_b    when "0010", -- Addition with carry
        extended_sign_a - extended_sign_b    when "0011", -- Subtraction with carry
        not extended_sign_a                  when "0100", -- NOT A
        extended_sign_a and  extended_sign_b when "0101",
        extended_sign_a or   extended_sign_b when "0110",
        extended_sign_a xor  extended_sign_b when "0111",
        extended_sign_a nand extended_sign_b when "1000",
        extended_sign_a nor  extended_sign_b when "1001",
        extended_sign_a xnor extended_sign_b when others;

    alu_out  <= op_result(15 downto 0); -- Assign the lower 16 bits to alu_out
    c_signal <= op_result(16);          -- Assign the carry-out to c_signal
    z_signal <= '1' when (alu_out = 0) else '0'; -- Assign the zero signal
    n_signal <= alu_out(15);            -- Assign the negative signal

    -- valid_ctrl_alu: process(ctrl_alu)
    -- begin
    --     if ctrl_alu > "1010" then
    --         report "ctrl_alu signal off range" severity failure;

    --     end if;

    -- end process;

end architecture;
