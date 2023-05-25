-- ||***********************************************************||
-- ||                                                           ||
-- ||   FEDERAL UNIVERSITY OF PIAUI                             ||
-- ||   NATURE SCIENCE CENTER                                   ||
-- ||   COMPUTING DEPARTMENT                                    ||
-- ||                                                           ||
-- ||   Computer for Every Task Architecture 16 Bits Mark II    ||
-- ||   COMETA 16 II                                            ||
-- ||                                                           ||
-- ||   Developer: Icaro Gabryel de Araujo Silva                ||
-- ||                                                           ||
-- ||***********************************************************||

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

entity cometa16_main_mem is
    port(
        clk: in std_logic;
        rst: in std_logic;

        pc_out:       in std_logic_vector(15 downto 0);
        alu_out:      in std_logic_vector(15 downto 0);
        
        inst_hit:     in std_logic;
        data_hit:     in std_logic;

        ctrl_wr_main_mem: in std_logic;
        data_mem_to_css: in std_logic_vector(15 downto 0);

        main_mem_to_inst: out std_logic_vector(63 downto 0);
        main_mem_to_data: out std_logic_vector(63 downto 0);
        css_wr_inst_mem: out std_logic;
        css_wr_data_mem: out std_logic;

        ctrl_wr_pc:   out std_logic

    );

end cometa16_main_mem;

architecture behavior_main_mem of cometa16_main_mem is
    type memory is array(0 to 63, 0 to 3) of std_logic_vector(15 downto 0);
    signal main_mem: memory;

    signal main_mem_out: std_logic_vector(63 downto 0);
    signal ctrl_rd_main_mem: std_logic;

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

begin
    ctrl_wr_pc <= inst_hit and data_hit;
    ctrl_rd_main_mem <= not ctrl_wr_pc;

    rd_addr <= pc_out when data_hit = '1' else alu_out;

    -- reading in main memory only when requested
    rd_main_memory: process(clk, rst, ctrl_rd_main_mem)

    begin
        if (ctrl_rd_main_mem) then
            main_mem_out <=
                main_mem(conv_integer(rd_addr)/4, 0) &
                main_mem(conv_integer(rd_addr)/4, 1) &
                main_mem(conv_integer(rd_addr)/4, 2) &
                main_mem(conv_integer(rd_addr)/4, 3);

            wr_cache_mem <= '1';
        
        else
            main_mem_out <= (others => '0');
            wr_cache_mem <= '0';

        end if;
    
    end process rd_main_memory;

    -- 1 to 2 demux
    main_mem_to_inst <= main_mem_out when data_hit = '1' else (others => '0');
    main_mem_to_data <= main_mem_out when data_hit = '0' else (others => '0');

    wr_main_memory: process(clk, rst, ctrl_wr_main_mem)
    
    begin
        if (rst = '1') then
            main_mem <= read_main_memory_file("memories/main_memmory.txt");

        -- writing in main memory
        elsif (clk'event and clk = '1') and (ctrl_wr_main_mem = '1') then
            main_mem(conv_integer(rd_addr)/4, 0) <= data_mem_to_css(63 downto 48);
            main_mem(conv_integer(rd_addr)/4, 1) <= data_mem_to_css(47 downto 32);
            main_mem(conv_integer(rd_addr)/4, 2) <= data_mem_to_css(31 downto 16);
            main_mem(conv_integer(rd_addr)/4, 3) <= data_mem_to_css(15 downto 0);

        end if;
    
    end process wr_main_memory;

end behavior_main_mem;
