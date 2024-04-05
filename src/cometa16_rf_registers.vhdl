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

entity cometa16_rf_registers is
    port(
        clk: in std_logic;
        rst: in std_logic;

        ctrl_wr_rf: in std_logic;
        ctrl_src_rf: in std_logic;

        ctrl_stk: in std_logic_vector(1 downto 0);
		ctrl_lk: in std_logic;

		hit_signal: in std_logic;

        pc_plus_one: in std_logic_vector(15 downto 0);
        ac_out: in std_logic_vector(15 downto 0);

        rf1_addr: in std_logic_vector(3 downto 0);
        rf2_addr: in std_logic_vector(3 downto 0);

        rf1_out: out std_logic_vector(15 downto 0);
        rf2_out: out std_logic_vector(15 downto 0)

    );

end cometa16_rf_registers;

architecture behavior_rf_registers of cometa16_rf_registers is
    type registers is array(0 to 15) of std_logic_vector(15 downto 0);
	signal rf_registers: registers;

	signal src_rf_mux: std_logic_vector(15 downto 0);
	signal wr_adrr: std_logic_vector(3 downto 0);

begin
	with ctrl_stk select rf1_out <=
		rf_registers(conv_integer(rf1_addr)) when "00",
		rf_registers(14)                     when "01",
		rf_registers(14) - 1                 when "10",
		"XXXXXXXXXXXXXXXX"                   when others;

	rf2_out <= rf_registers(conv_integer(rf2_addr));

	with ctrl_lk select wr_adrr <=
		rf1_addr when '0',
		"1111"   when '1',
		"XXXX"   when others;

	with ctrl_src_rf select src_rf_mux <=
		pc_plus_one(15 downto 0)     when '0',
		ac_out(15 downto 0)          when '1',
		"XXXXXXXXXXXXXXXX"           when others;

	wr_rf_registers: process(clk, rst, ctrl_wr_rf)

	begin
		if (rst = '1') then
			rf_registers(0)  <= "0000000000000000"; -- rf0 
			rf_registers(1)  <= "0000000000000000"; -- rf1
			rf_registers(2)  <= "0000000000000000"; -- rf2 
			rf_registers(3)  <= "0000000000000000"; -- rf3

			rf_registers(4)  <= "0000000000000000"; -- rf4
			rf_registers(5)  <= "0000000000000000"; -- rf5 
			rf_registers(6)  <= "0000000000000000"; -- rf6
			rf_registers(7)  <= "0000000000000000"; -- rf7

			rf_registers(8)  <= "0000000000000000"; -- rf8
			rf_registers(9)  <= "0000000000000000"; -- rf9 
			rf_registers(10) <= "0000000000000000"; -- rf10
			rf_registers(11) <= "0000000000000000"; -- rf11

			rf_registers(12) <= "0000000000000000"; -- rf12
			rf_registers(13) <= "0000000000000000"; -- rf13
			rf_registers(14) <= "0000000100000000"; -- sp
			rf_registers(15) <= "0000000000000000"; -- lk

		elsif ((clk'event and clk = '1') and (ctrl_wr_rf = '1') and (ctrl_stk = "00") and (hit_signal = '1')) then
			rf_registers(conv_integer(wr_adrr)) <= src_rf_mux;

		elsif ((clk'event and clk = '1') and (ctrl_wr_rf = '1') and (ctrl_stk = "01") and (hit_signal = '1')) then -- pop
			rf_registers(14) <= rf_registers(14) + 1;

		elsif ((clk'event and clk = '1') and (ctrl_wr_rf = '1') and (ctrl_stk = "10") and (hit_signal = '1')) then -- push
			rf_registers(14) <= rf_registers(14) - 1;

		end if;

	end process wr_rf_registers;

end behavior_rf_registers;
