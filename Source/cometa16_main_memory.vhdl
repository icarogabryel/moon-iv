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
use std.textio.all;

entity cometa16_main_memory is
    port(
        clk: in std_logic;
        rst: in std_logic;

        ins_addr:        in std_logic_vector(15 downto 0);
        rd_time:         out std_logic_vector(9 downto 0);
        main_mem_out:       out std_logic_vector(63 downto 0)

    );

end cometa16_main_memory;

architecture behavior_main_memory of cometa16_main_memory is
    type memory is array(0 to 63, 0 to 3) of std_logic_vector(15 downto 0);
    signal main_memory: memory;

    signal rd_time_reg: std_logic_vector(9 downto 0) := "0001100100";

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
            
            if(j = 3) then
                j := 0;
                i := i + 1;
            else
                j := j + 1;
            end if;

        end loop;

        return temp_main_memory;

    end function read_main_memory_file;

begin
    main_mem_out <=
        main_memory(conv_integer(ins_addr)/4, 0) &
        main_memory(conv_integer(ins_addr)/4, 1) &
        main_memory(conv_integer(ins_addr)/4, 2) &
        main_memory(conv_integer(ins_addr)/4, 3);

    rd_time <= rd_time_reg(9 downto 0);

    wr_main_memory: process(clk, rst)

    begin
        if(rst = '1') then
            main_memory <= read_main_memory_file("memories/main_memory.txt");
        end if;

        -- writing in main memory
        -- elsif(rising_edge(clk) and control sign) then

        -- end if;
    
    end process wr_main_memory;

end behavior_main_memory;
