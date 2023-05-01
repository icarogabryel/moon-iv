-- ||****************************************************************||
-- ||                                                                ||
-- ||   FEDERAL UNIVERSITY OF PIAUI                                  ||
-- ||   NATURE SCIENCE CENTER                                        ||
-- ||   COMPUTING DEPARTMENT                                         ||
-- ||                                                                ||
-- ||   Computer for Every Task Architecture 16 Bits Generation 2    ||
-- ||   COMETA 16 G2                                                 ||
-- ||                                                                ||
-- ||   Developer: Icaro Gabryel de Araujo Silva                     ||
-- ||                                                                ||
-- ||****************************************************************||

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cometa16_rf_bank_registers is
    port(
        clk: in std_logic;
        rst: in std_logic;

        ctrl_wr_rf_reg: IN std_logic; --todo
        ctrl_src_rf_reg: IN std_logic;  --todo

        ctrl_stack: in std_logic_vector(1 downto 0);
        ctrl_link: in std_logic;

        pc_plus_one: in std_logic_vector(15 downto 0);
        rd_bank_reg_out: in std_logic_vector(15 downto 0);

        rf1_addr: in std_logic_vector(3 downto 0);
        rf2_addr: in std_logic_vector(3 downto 0);

        rf1_out : out std_logic_vector(15 downto 0);
        rf2_out : out std_logic_vector(15 downto 0)
    );
end cometa16_rf_bank_registers;

architecture behavior_rf_bank_registers of cometa16_rf_bank_registers is
    type bank_register is array(0 to 15) of std_logic_vector(15 downto 0);
	signal rf_bank_register: bank_register;

	signal src_rf_reg_mux: std_logic_vector(15 downto 0);
	signal wr_adrr: std_logic_vector(3 downto 0);

begin
	with ctrl_stack select rf1_out <=
		rf_bank_register(conv_integer(rf1_addr)) when "00",
		rf_bank_register(14)                     when "01",
		rf_bank_register(14) - 1                 when "10",
		"XXXXXXXXXXXXXXXX"                       when others;

	rf2_out <= rf_bank_register(conv_integer(rf2_addr));

	with ctrl_link select wr_adrr <=
		rf1_addr(3 downto 0) when '0',
		"1111"               when '1',
		"XXXX"               when others;

	with ctrl_src_rf_reg select src_rf_reg_mux <=
		pc_plus_one(15 DOWNTO 0)     when '0',
		rd_bank_reg_out(15 DOWNTO 0) when '1',
		"XXXXXXXXXXXXXXXX"           when others;

	wr_rf_bank_register: process(clk, rst, EscReg1)

	begin

		if rst = '1' then
			rf_bank_register(0)  <= "0000000000000000"; -- rf0 
			rf_bank_register(1)  <= "0000000000000000"; -- rf1
			rf_bank_register(2)  <= "0000000000000000"; -- rf2 
			rf_bank_register(3)  <= "0000000000000000"; -- rf3
			rf_bank_register(4)  <= "0000000000000000"; -- rf4
			rf_bank_register(5)  <= "0000000000000000"; -- rf5 
			rf_bank_register(6)  <= "0000000000000000"; -- rf6
			rf_bank_register(7)  <= "0000000000000000"; -- rf7
			rf_bank_register(8)  <= "0000000000000000"; -- rf8
			rf_bank_register(9)  <= "0000000000000000"; -- rf9 
			rf_bank_register(10) <= "0000000000000000"; -- rf10
			rf_bank_register(11) <= "0000000000000000"; -- rf11
			rf_bank_register(12) <= "0000000000000000"; -- rf12
			rf_bank_register(13) <= "0000000000000000"; -- rf13
			rf_bank_register(14) <= "0000000000000000"; -- sp
			rf_bank_register(15) <= "0000000000000000"; -- link

		elsif ((clk'event and clk ='1') and (ctrl_wr_rf_Reg = '1') and (stack = "00")) then
			rf_bank_register(conv_integer(wr_adrr)) <= amux_out;
		elsif ((clk'event and clk ='1') and (ctrl_wr_rf_Reg = '1') and (stack = "01")) then -- pop
			rf_bank_register(14) <= rf_bank_register(14) + 1;
		elsif ((clk'event and clk ='1') and (ctrl_wr_rf_Reg = '1') and (stack = "10")) then -- push
			rf_bank_register(14) <= rf_bank_register(14) - 1;
		end if;

	end process wr_rf_bank_register;

END behavior_rf_bank_registers;
