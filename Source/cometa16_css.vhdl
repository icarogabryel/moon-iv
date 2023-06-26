library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity cometa16_css is
    port(
        rst: in std_logic;

        core0_in: out std_logic_vector(130 downto 0);
        core0_out: in std_logic_vector(114 downto 0);

        core1_in: out std_logic_vector(130 downto 0);
        core1_out: in std_logic_vector(114 downto 0);

        core2_in: out std_logic_vector(130 downto 0);
        core2_out: in std_logic_vector(114 downto 0);

        core3_in: out std_logic_vector(130 downto 0);
        core3_out: in std_logic_vector(114 downto 0);

        main_mem_in: out std_logic_vector(114 downto 0);
        main_mem_out: in std_logic_vector(130 downto 0)

    );

end cometa16_css;

architecture behavior_css of cometa16_css is
    signal priority: std_logic_vector(1 downto 0);
    signal priority_plus_one: integer;

    signal served: std_logic_vector(3 downto 0);
    signal served_ord0, served_ord1, served_ord2, served_ord3: std_logic;
    signal served_desord0, served_desord1, served_desord2, served_desord3: std_logic;

    -- request signal ordeneated by priority
    signal req0, req1, req2, req3: std_logic;
    signal req_ord0, req_ord1, req_ord2, req_ord3: std_logic;

begin
    req0 <= (not core0_out(114)) or (not core0_out(113));
    req1 <= (not core1_out(114)) or (not core1_out(113));
    req2 <= (not core2_out(114)) or (not core2_out(113));
    req3 <= (not core3_out(114)) or (not core3_out(113));

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
    priority_plus_one <= conv_integer(priority) + 1;

    reg: process (rst)

    begin
        if (rst = '1') then
            priority <= "00";

        elsif (req0'event and req0 = '0') then
            priority <= std_logic_vector(to_unsigned(priority_plus_one mod 4, 2));

        elsif (req1'event and req1 = '0') then
            priority <= std_logic_vector(to_unsigned(priority_plus_one mod 4, 2));

        elsif (req2'event and req2 = '0') then
            priority <= std_logic_vector(to_unsigned(priority_plus_one mod 4, 2));

        elsif (req3'event and req3 = '0') then
            priority <= std_logic_vector(to_unsigned(priority_plus_one mod 4, 2));

        end if;

    end process reg;
    
    -- memory to core data
    with served select core0_in <=
        main_mem_out    when "1000",
        (others => '0') when others;

    with served select core1_in <=
        main_mem_out    when "0100",
        (others => '0') when others;

    with served select core2_in <=
        main_mem_out    when "0010",
        (others => '0') when others;

    with served select core3_in <=
        main_mem_out    when "0001",
        (others => '0') when others;

    -- core to memory data
    with served select main_mem_in <=
        core0_out       when "1000",
        core1_out       when "0100",
        core2_out       when "0010",
        core3_out       when "0001",
        (others => '0') when others;

end behavior_css;
