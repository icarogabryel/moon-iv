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

entity cometa16_css is
    port(
        clk, rst: in std_logic;

        req0: in std_logic;
        req1: in std_logic;
        req2: in std_logic;
        req3: in std_logic;

        core0_in: out std_logic_vector(64 downto 0);
        core1_in: out std_logic_vector(64 downto 0);
        core2_in: out std_logic_vector(64 downto 0);
        core3_in: out std_logic_vector(64 downto 0);

        core0_out: in std_logic_vector(97 downto 0);
        core1_out: in std_logic_vector(97 downto 0);
        core2_out: in std_logic_vector(97 downto 0);
        core3_out: in std_logic_vector(97 downto 0);

        served_out: out std_logic_vector(3 downto 0);

        main_mem_in: out std_logic_vector(97 downto 0);
        main_mem_out: in std_logic_vector(64 downto 0)

    );

end cometa16_css;

architecture behavior_css of cometa16_css is
    signal priority: std_logic_vector(1 downto 0);
    signal priority_reg: std_logic_vector(1 downto 0);
    signal priority_plus_one: std_logic_vector(1 downto 0);
    signal served_reg: std_logic_vector(3 downto 0);

    signal mux: std_logic;
    signal not_mux: std_logic;

    signal served: std_logic_vector(3 downto 0);
    signal served_ord0, served_ord1, served_ord2, served_ord3: std_logic;
    signal served_desord0, served_desord1, served_desord2, served_desord3: std_logic;

    -- request signal ordeneated by priority
    signal req_ord0, req_ord1, req_ord2, req_ord3: std_logic;

begin
    served_out <= served_reg;
    -- requests enters

    -- requests priority ordenation top to down
    with priority select req_ord0 <=
        req0 when "00",
        req1 when "01",
        req2 when "10",
        req3 when "11",
        'X'  when others;

    with priority select req_ord1 <=
        req1 when "00",
        req2 when "01",
        req3 when "10",
        req0 when "11",
        'X'  when others;

    with priority select req_ord2 <=
        req2 when "00",
        req3 when "01",
        req0 when "10",
        req1 when "11",
        'X'  when others;

    with priority select req_ord3 <=
        req3 when "00",
        req0 when "01",
        req1 when "10",
        req2 when "11",
        'X'  when others;

    -- requests priority accordance. Tell what rewuest is being served
    served_ord0 <=     req_ord0;
    served_ord1 <= not req_ord0 and     req_ord1;
    served_ord2 <= not req_ord0 and not req_ord1 and     req_ord2;
    served_ord3 <= not req_ord0 and not req_ord1 and not req_ord2 and req_ord3;

    -- served desord
    with priority select served_desord0 <=
        served_ord0 when "00",
        served_ord3 when "01",
        served_ord2 when "10",
        served_ord1 when "11",
        'X'  when others;

    with priority select served_desord1 <=
        served_ord1 when "00",
        served_ord0 when "01",
        served_ord3 when "10",
        served_ord2 when "11",
        'X'  when others;

    with priority select served_desord2 <= 
        served_ord2 when "00",
        served_ord1 when "01",
        served_ord0 when "10",
        served_ord3 when "11",
        'X'  when others;

    with priority select served_desord3 <=
        served_ord3 when "00",
        served_ord2 when "01",
        served_ord1 when "10",
        served_ord0 when "11",
        'X'  when others;

    served <= served_desord0 & served_desord1 & served_desord2 & served_desord3;

    -- priority write process
    registers: process (clk, rst)

    begin    
        if (rst = '1') then
            priority_reg <= "00";
            served_reg <= "0000";

        elsif ((clk'event and clk = '1') and (not_mux = '1')) then
            if (served_reg = "0000") then
                served_reg <= served;
                
            else
                priority_reg <= priority_plus_one;
                served_reg <= served;

            end if;
        end if;

    end process registers;

    with served_reg select mux <=
        '0'            when "0000",
        served_desord0 when "1000",
        served_desord1 when "0100",
        served_desord2 when "0010",
        served_desord3 when "0001",
        'X'            when others;

    not_mux <= (not mux);
    
    priority <= priority_reg;
    priority_plus_one <= priority + 1;
    
    -- memory to core data
    with served_reg select core0_in <=
        main_mem_out         when "1000",
        (others => '0') when others;

    with served_reg select core1_in <=
        main_mem_out         when "0100",
        (others => '0') when others;

    with served_reg select core2_in <=
        main_mem_out         when "0010",
        (others => '0') when others;

    with served_reg select core3_in <=
        main_mem_out         when "0001",
        (others => '0') when others;

    -- core to memory data
    with served_reg select main_mem_in <=
        core0_out       when "1000",
        core1_out       when "0100",
        core2_out       when "0010",
        core3_out       when "0001",
        (others => '0') when others;

end behavior_css;
