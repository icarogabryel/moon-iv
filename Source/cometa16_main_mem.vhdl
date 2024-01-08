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
use std.textio.all;

entity cometa16_main_mem is
    port(
        clk: in std_logic;
        rst: in std_logic;

        served_out: in std_logic_vector(3 downto 0);

        ctrl_rd_main_mem: in std_logic;
        rd_addr: in std_logic_vector(15 downto 0);

        ctrl_wr_main_mem: in std_logic;
        main_mem_wr_addr: in std_logic_vector(15 downto 0);
        data_mem_bk_out: in std_logic_vector(63 downto 0);

        main_mem_bk_out: out std_logic_vector(63 downto 0);
        wr_cache_mem: out std_logic

    );

end cometa16_main_mem;

architecture behavior_main_mem of cometa16_main_mem is
    type memory is array(0 to 63, 0 to 3) of std_logic_vector(15 downto 0);

    impure function read_main_memory_file(file_name: in string) return memory is
        file main_memory_file: text open read_mode is file_name;
        variable main_memory_line: line;
        
        variable temp_bit_vector: bit_vector(15 downto 0);
        variable temp_main_memory: memory;
        
        variable i: integer := 0;
        variable j: integer := 0;

    begin
        while not endfile(main_memory_file) loop
            readline(main_memory_file, main_memory_line);
            read(main_memory_line, temp_bit_vector);
            temp_main_memory(i, j) := to_stdlogicvector(temp_bit_vector);
            
            if (j = 3) then
                j := 0;
                i := i + 1;
            else
                j := j + 1;
            end if;

        end loop;

        return temp_main_memory;

    end function read_main_memory_file;

    signal main_mem_0: memory := read_main_memory_file("memories/main_mem_0.txt");
    signal main_mem_1: memory := read_main_memory_file("memories/main_mem_1.txt");
    signal main_mem_2: memory := read_main_memory_file("memories/main_mem_2.txt");
    signal main_mem_3: memory := read_main_memory_file("memories/main_mem_3.txt");

begin
    -- reading in main memory only when requested
    rd_main_memory: process(clk, rst, ctrl_rd_main_mem)

    begin
        if (ctrl_rd_main_mem) then
            with served_out select main_mem_bk_out <=
                main_mem_0(conv_integer(rd_addr)/4, 0) &
                main_mem_0(conv_integer(rd_addr)/4, 1) &
                main_mem_0(conv_integer(rd_addr)/4, 2) &
                main_mem_0(conv_integer(rd_addr)/4, 3) when "1000",

                main_mem_1(conv_integer(rd_addr)/4, 0) &
                main_mem_1(conv_integer(rd_addr)/4, 1) &
                main_mem_1(conv_integer(rd_addr)/4, 2) &
                main_mem_1(conv_integer(rd_addr)/4, 3) when "0100",

                main_mem_2(conv_integer(rd_addr)/4, 0) &
                main_mem_2(conv_integer(rd_addr)/4, 1) &    
                main_mem_2(conv_integer(rd_addr)/4, 2) &
                main_mem_2(conv_integer(rd_addr)/4, 3) when "0010",

                main_mem_3(conv_integer(rd_addr)/4, 0) &
                main_mem_3(conv_integer(rd_addr)/4, 1) &
                main_mem_3(conv_integer(rd_addr)/4, 2) &
                main_mem_3(conv_integer(rd_addr)/4, 3) when "0001",

                (others => 'X') when others;

            wr_cache_mem <= '1';
        
        else
            main_mem_bk_out <= (others => '0');
            wr_cache_mem <= '0';

        end if;
    
    end process rd_main_memory;

    wr_main_memory: process(clk, rst, ctrl_wr_main_mem)
    
    begin
        if (rst = '1') then
            main_mem_0 <= read_main_memory_file("memories/main_mem_0.txt");
            main_mem_1 <= read_main_memory_file("memories/main_mem_1.txt");
            main_mem_2 <= read_main_memory_file("memories/main_mem_2.txt");
            main_mem_3 <= read_main_memory_file("memories/main_mem_3.txt");

        -- writing in main memory
        elsif ((clk'event and clk = '1') and (ctrl_wr_main_mem = '1')) then
            if (served_out = "1000") then
                main_mem_0(conv_integer(main_mem_wr_addr)/4, 0) <= data_mem_bk_out(63 downto 48);
                main_mem_0(conv_integer(main_mem_wr_addr)/4, 1) <= data_mem_bk_out(47 downto 32);
                main_mem_0(conv_integer(main_mem_wr_addr)/4, 2) <= data_mem_bk_out(31 downto 16);
                main_mem_0(conv_integer(main_mem_wr_addr)/4, 3) <= data_mem_bk_out(15 downto 0);
            elsif (served_out = "0100") then
                main_mem_1(conv_integer(main_mem_wr_addr)/4, 0) <= data_mem_bk_out(63 downto 48);
                main_mem_1(conv_integer(main_mem_wr_addr)/4, 1) <= data_mem_bk_out(47 downto 32);
                main_mem_1(conv_integer(main_mem_wr_addr)/4, 2) <= data_mem_bk_out(31 downto 16);
                main_mem_1(conv_integer(main_mem_wr_addr)/4, 3) <= data_mem_bk_out(15 downto 0);
            elsif (served_out = "0010") then
                main_mem_2(conv_integer(main_mem_wr_addr)/4, 0) <= data_mem_bk_out(63 downto 48);
                main_mem_2(conv_integer(main_mem_wr_addr)/4, 1) <= data_mem_bk_out(47 downto 32);
                main_mem_2(conv_integer(main_mem_wr_addr)/4, 2) <= data_mem_bk_out(31 downto 16);
                main_mem_2(conv_integer(main_mem_wr_addr)/4, 3) <= data_mem_bk_out(15 downto 0);
            elsif (served_out = "0001") then
                main_mem_3(conv_integer(main_mem_wr_addr)/4, 0) <= data_mem_bk_out(63 downto 48);
                main_mem_3(conv_integer(main_mem_wr_addr)/4, 1) <= data_mem_bk_out(47 downto 32);
                main_mem_3(conv_integer(main_mem_wr_addr)/4, 2) <= data_mem_bk_out(31 downto 16);
                main_mem_3(conv_integer(main_mem_wr_addr)/4, 3) <= data_mem_bk_out(15 downto 0);
            end if;

        end if;
    
    end process wr_main_memory;

end behavior_main_mem;
