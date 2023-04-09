-- ||***************************************************************||
-- ||                                                               ||
-- ||   FEDERAL UNIVERSITY OF PIAUI                                 ||
-- ||   NATURE SCIENCE CENTER                                       ||
-- ||   COMPUTING DEPARTMENT                                        ||
-- ||                                                               ||
-- ||   Computer for Every Task Architecture 16 Bits - COMETA 16    ||
-- ||                                                               ||
-- ||   Registred in National Institute of Industrial Property      ||
-- ||   (INPI) under the number BR 51 2023 000286 0                 ||
-- ||                                                               ||
-- ||   Developers:                                                 ||
-- ||   - Icaro Gabryel de Araujo Silva                             ||
-- ||   - Fabio Anderson Carvalho Silva                             ||
-- ||   - Cayo Cesar Lopes Mascarenhas Pires Cardoso                ||
-- ||   - Claudiney Ryan da Silva                                   ||
-- ||   - Antonio Geraldo Rego Junior                               ||
-- ||   - Nivaldo Nogueira Paranagua Santos e Silva                 ||
-- ||   - Ivan Saraiva Silva                                        ||
-- ||                                                               ||
-- ||***************************************************************||

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

entity cometa16_main_memory is
    port(
        clk: in std_logic;
        rst: in std_logic;

        control_wr_main_memory: in std_logic;
        addr: in std_logic_vector(15 downto 0);
        data: in std_logic_vector(15 downto 0);

        main_memory_out: out std_logic_vector(15 downto 0)

    );

end cometa16_main_memory;

architecture behavior_main_memory of cometa16_main_memory is
    type main_memory is array(0 to 65535) of std_logic_vector(15 downto 0);
    signal main: main_memory;

    impure function read_main_memory_file(file_name: in string) return main_memory is
        file main_memory_file: text open read_mode is file_name;
        variable main_memory_line: line;
        
        variable temp_bit_vector: bit_vector(15 downto 0);
        variable temp_main_memory: main_memory;
        
        variable i: integer := 0;

    begin
        while not endfile(main_memory_file) loop
            readline(main_memory_file, main_memory_line);
            read(main_memory_line, temp_bit_vector);
            temp_main_memory(i) := to_stdlogicvector(temp_bit_vector);

            i := i + 1;

        end loop;

        return temp_main_memory;

    end function read_main_memory_file;

begin
    wr_main_memory: process(clk, rst)
    
    begin
        if(rst = '1') then
            main <= read_main_memory_file("memories/main_memory.txt");
        
        elsif(rising_edge(clk)) then
            if(control_wr_main_memory = '1') then
                main(conv_integer(addr)) <= data;
            end if;
            
            main_memory_out <= main(conv_integer(addr))(15 downto 0);
        
        end if;
    
    end process wr_main_memory;
 
end behavior_main_memory;
