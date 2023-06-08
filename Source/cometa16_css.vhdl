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

entity cometa16_css is
    port(
        core0_in: out std_logic_vector(129 downto 0);
        core0_out: in std_logic_vector(144 downto 0);
        
        core1_in: out std_logic_vector(129 downto 0);
        core1_out: in std_logic_vector(144 downto 0);

        core2_in: out std_logic_vector(129 downto 0);
        core2_out: in std_logic_vector(144 downto 0);

        core3_in: out std_logic_vector(129 downto 0);
        core3_out: in std_logic_vector(114 downto 0);

        main_mem_in: out std_logic_vector(114 downto 0);
        -- 2 miss bits, 32 rd_addr bits, 64 data_mem_bk_out bits, 16 main_mem_wr_addr bits, 1 wr_main_mem bit
        main_mem_out: in std_logic_vector(129 downto 0)

    );

end cometa16_css;

architecture behaviior_css of cometa16_css is
    type cores_in_vector is array(0 to 3) of std_logic_vector(129 downto 0);
    type cores_out_vector is array(0 to 3) of std_logic_vector(144 downto 0);
    
    signal priority: integer =: 0;
    
    signal requests: std_logic_vector(0 to 3);
    signal have_request: std_logic;
    
    signal cores_in: cores_in_vector;
    signal cores_out: cores_out_vector;

begin
    resquests <= core0_out(144) or core0_out(143) & core1_out(144) or core1_out(143) & core2_out(144) or core2_out(143) & core3_out(144) or core3_out(143);
    have_request <= requests(0) or requests(1) or requests(2) or requests(3);

    cores_in(0) <= core0_in;
    cores_in(1) <= core1_in;
    cores_in(2) <= core2_in;
    cores_in(3) <= core3_in;

    cores_out(0) <= core0_out;
    cores_out(1) <= core1_out;
    cores_out(2) <= core2_out;
    cores_out(3) <= core3_out;

    round_process: process(priority, request, request0, request1, request2, request3)
    
    begin
        if (request = '1') then -- mudar sinal de request
            for i in 0 to 3 loop
                if (requests((priority + i) % 4) = '1') then
                    cores_in((priority + i) % 4) <= main_mem_out;
                    main_mem_in <= cores_out((priority + i) % 4);

                    priority <= (priority + 1) % 4;
                    
                    wait until requests((priority + i) % 4) = '0';
                    exit;

                else:
                    cores_in((priority + i) % 4) <= (others => '0');
                    main_mem_in <= (others => '0');

                end if;
            end loop;
        end if;
            
    end process;
    