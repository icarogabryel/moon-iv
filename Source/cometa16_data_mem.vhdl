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

entity cometa16_data_mem is
    port(
        clk: in std_logic;
        rst: in std_logic;

        ctrl_wr_data_mem: in std_logic;
        ctrl_data_mem_use: in std_logic;

        shifter_out: in std_logic_vector(15 downto 0);
        ac_out: in std_logic_vector(15 downto 0);

        -- Recive the block from main memory
        main_to_data_bk: in std_logic_vector(63 downto 0);
        wr_data_from_main: in std_logic;

        -- Send the block to main memory
        wr_main_from_data: out std_logic;
        data_to_main_bk: out std_logic_vector(63 downto 0);
        main_wr_addr: out std_logic_vector(15 downto 0);
        
        data_hit_out: out std_logic;
        data_mem_out: out std_logic_vector(15 downto 0)

    );

end cometa16_data_mem;

architecture behavior_data_mem of cometa16_data_mem is
    type memory is array(0 to 3, 0 to 3) of std_logic_vector(29 downto 0);
    signal data_mem: memory;

    signal hit_signal: std_logic;
    signal data_mem_data_read: std_logic_vector(29 downto 0);

begin
    -- Read the data memory and send the data to the ac registers
    data_mem_data_read <= data_mem(conv_integer(shifter_out(3 downto 2)), conv_integer(shifter_out(1 downto 0)));
    data_mem_out <= data_mem_data_read(15 downto 0);
    
    -- "write in maim memory" control signal check if any word in the block
    -- is modified (29 is modified bit) and if the bock is being substituted. If so, the
    -- modified block is written back to the memory at the same moment the
    -- "write in data memory" control signal is activated.
    wr_main_from_data <=
        wr_data_from_main and
        (
            data_mem(conv_integer(shifter_out(3 downto 2)), 0)(29) or
            data_mem(conv_integer(shifter_out(3 downto 2)), 1)(29) or
            data_mem(conv_integer(shifter_out(3 downto 2)), 2)(29) or
            data_mem(conv_integer(shifter_out(3 downto 2)), 3)(29)
        );
    
    -- Send the block to the main memory and use the "write in data memory" control signal
    -- to enable the written in the main.
    data_to_main_bk <=
        data_mem(conv_integer(shifter_out(3 downto 2)), 0)(15 downto 0) &
        data_mem(conv_integer(shifter_out(3 downto 2)), 1)(15 downto 0) &
        data_mem(conv_integer(shifter_out(3 downto 2)), 2)(15 downto 0) &
        data_mem(conv_integer(shifter_out(3 downto 2)), 3)(15 downto 0);

    main_wr_addr <= data_mem_data_read(27 downto 16) & shifter_out(3 downto 0);
    
    hit_process: process (shifter_out, data_mem_data_read)
    
    begin
        -- check if the label of the address is the same as the label of the
        -- data memory block and if the block is valid. If so, the hit signal
        -- is activated.
        if ((shifter_out(15 downto 4) = data_mem_data_read(27 downto 16)) and (data_mem_data_read(28) = '1')) then
            hit_signal <= '1';
        else
            hit_signal <= '0';
        end if;

    end process hit_process;
    
    -- check if the data memory is being read. If so, the hit signal is send.
    -- If not, the hit signal is always set '1' to not stop pc when the shifter out
    -- point to a invalid address or a modified block.

    with ctrl_data_mem_use select data_hit_out <=
        '1'        when '0',
        hit_signal when '1',
        'X'        when others;

    wr_data_mem_process: process(clk, rst, ctrl_wr_data_mem)

    begin
        if (rst = '1') then
            data_mem(0, 0) <= "000000000000000000000000000000";
            data_mem(0, 1) <= "000000000000000000000000000000";
            data_mem(0, 2) <= "000000000000000000000000000000";
            data_mem(0, 3) <= "000000000000000000000000000000";
            data_mem(1, 0) <= "000000000000000000000000000000";
            data_mem(1, 1) <= "000000000000000000000000000000";
            data_mem(1, 2) <= "000000000000000000000000000000";
            data_mem(1, 3) <= "000000000000000000000000000000";
            data_mem(2, 0) <= "000000000000000000000000000000";
            data_mem(2, 1) <= "000000000000000000000000000000";
            data_mem(2, 2) <= "000000000000000000000000000000";
            data_mem(2, 3) <= "000000000000000000000000000000";
            data_mem(3, 0) <= "000000000000000000000000000000";
            data_mem(3, 1) <= "000000000000000000000000000000";
            data_mem(3, 2) <= "000000000000000000000000000000";
            data_mem(3, 3) <= "000000000000000000000000000000";

        elsif ((clk'event and clk = '1') and (ctrl_wr_data_mem = '1') and (hit_signal = '1')) then
            data_mem(conv_integer(shifter_out(3 downto 2)), conv_integer(shifter_out(1 downto 0))) <= '1' & data_mem(conv_integer(shifter_out(3 downto 2)), conv_integer(shifter_out(1 downto 0)))(28 downto 16) & ac_out(15 downto 0);
        end if;
        
        -- write block from css to data memory
        if ((clk'event and clk = '1') and (wr_data_from_main = '1')) then
            data_mem(conv_integer(shifter_out(3 downto 2)), 0) <= '0' & '1' & shifter_out(15 downto 4) & main_to_data_bk(63 downto 48);
            data_mem(conv_integer(shifter_out(3 downto 2)), 1) <= '0' & '1' & shifter_out(15 downto 4) & main_to_data_bk(47 downto 32);
            data_mem(conv_integer(shifter_out(3 downto 2)), 2) <= '0' & '1' & shifter_out(15 downto 4) & main_to_data_bk(31 downto 16);
            data_mem(conv_integer(shifter_out(3 downto 2)), 3) <= '0' & '1' & shifter_out(15 downto 4) & main_to_data_bk(15 downto 0);

        end if;

    end process wr_data_mem_process;

end behavior_data_mem;
