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

entity cometa16_mau is
    port(
        inst_hit_out: in std_logic;
        data_hit_out: in std_logic;

        pc_out: in std_logic_vector(15 downto 0);
        shifter_out: in std_logic_vector(15 downto 0);

        wr_cache_from_main: in std_logic;
        main_to_cache_bk: in std_logic_vector(63 downto 0);

        wr_inst_from_main: out std_logic;
        main_to_inst_bk: out std_logic_vector(63 downto 0);

        wr_data_from_main: out std_logic;
        main_to_data_bk: out std_logic_vector(63 downto 0);

        hit_signal: out std_logic;
        request: out std_logic;
        main_rd_addr: out std_logic_vector(15 downto 0)

    );

end cometa16_mau;

architecture behavior_mau of cometa16_mau is

begin
    hit_signal <= inst_hit_out and data_hit_out;
    request <= not hit_signal;

    with inst_hit_out select main_rd_addr <=
        pc_out               when '0',
        shifter_out          when '1',
        "XXXXXXXXXXXXXXXX"   when others;

    main_to_inst_bk <= main_to_cache_bk(63 downto 0) when inst_hit_out = '0' else (others => '0');
    main_to_data_bk <= main_to_cache_bk(63 downto 0) when inst_hit_out = '1' else (others => '0');

    wr_inst_from_main <= wr_cache_from_main when inst_hit_out = '0' else '0';
    wr_data_from_main <= wr_cache_from_main when inst_hit_out = '1' else '0';

end behavior_mau;
