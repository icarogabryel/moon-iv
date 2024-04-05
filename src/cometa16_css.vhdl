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
use ieee.numeric_std.all;

entity cometa16_css is
    port(
        clk, rst: in std_logic;

        request_0: in std_logic;
        request_1: in std_logic;
        request_2: in std_logic;
        request_3: in std_logic;

        core_in_0: out std_logic_vector(64 downto 0);
        core_in_1: out std_logic_vector(64 downto 0);
        core_in_2: out std_logic_vector(64 downto 0);
        core_in_3: out std_logic_vector(64 downto 0);

        core_out_0: in std_logic_vector(97 downto 0);
        core_out_1: in std_logic_vector(97 downto 0);
        core_out_2: in std_logic_vector(97 downto 0);
        core_out_3: in std_logic_vector(97 downto 0);

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

    signal main_rd_addr: std_logic_vector(15 downto 0);
    signal main_wr_addr: std_logic_vector(15 downto 0);
    signal conv_main_rd_addr: std_logic_vector(15 downto 0);
    signal conv_main_wr_addr: std_logic_vector(15 downto 0);
    signal pre_main_mem_in: std_logic_vector(97 downto 0);

begin
    -- requests enters

    -- requests priority ordenation top to down
    with priority select req_ord0 <=
        request_0 when "00",
        request_1 when "01",
        request_2 when "10",
        request_3 when "11",
        'X'  when others;

    with priority select req_ord1 <=
        request_1 when "00",
        request_2 when "01",
        request_3 when "10",
        request_0 when "11",
        'X'  when others;

    with priority select req_ord2 <=
        request_2 when "00",
        request_3 when "01",
        request_0 when "10",
        request_1 when "11",
        'X'  when others;

    with priority select req_ord3 <=
        request_3 when "00",
        request_0 when "01",
        request_1 when "10",
        request_2 when "11",
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
    with served_reg select core_in_0 <=
        main_mem_out         when "1000",
        (others => '0') when others;

    with served_reg select core_in_1 <=
        main_mem_out         when "0100",
        (others => '0') when others;

    with served_reg select core_in_2 <=
        main_mem_out         when "0010",
        (others => '0') when others;

    with served_reg select core_in_3 <=
        main_mem_out         when "0001",
        (others => '0') when others;

    -- core to memory data
    with served_reg select pre_main_mem_in <=
        core_out_0       when "1000",
        core_out_1       when "0100",
        core_out_2       when "0010",
        core_out_3       when "0001",
        (others => '0') when others;

    -- Calculate real address of maim memory
    main_rd_addr <= pre_main_mem_in(96 downto 81);
    main_wr_addr <= pre_main_mem_in(79 downto 64);

    with served_reg select conv_main_rd_addr <=
        std_logic_vector(to_unsigned(conv_integer(main_rd_addr) + 0, 16)) when "1000",
        std_logic_vector(to_unsigned(conv_integer(main_rd_addr) + 256, 16)) when "0100",
        std_logic_vector(to_unsigned(conv_integer(main_rd_addr) + 512, 16)) when "0010",
        std_logic_vector(to_unsigned(conv_integer(main_rd_addr) + 768, 16)) when "0001",
        (others => '0') when others;

    with served_reg select conv_main_wr_addr <=
        std_logic_vector(to_unsigned(conv_integer(main_wr_addr) + 0, 16)) when "1000",
        std_logic_vector(to_unsigned(conv_integer(main_wr_addr) + 256, 16)) when "0100",
        std_logic_vector(to_unsigned(conv_integer(main_wr_addr) + 512, 16)) when "0010",
        std_logic_vector(to_unsigned(conv_integer(main_wr_addr) + 768, 16)) when "0001",
        (others => '0') when others;

    main_mem_in <= pre_main_mem_in(97) & conv_main_rd_addr(15 downto 0) & pre_main_mem_in(80) & conv_main_wr_addr(15 downto 0) & pre_main_mem_in(63 downto 0);

end behavior_css;
