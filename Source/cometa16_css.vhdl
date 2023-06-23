library ieee;
use ieee.std_logic_1164.all;

entity cometa16_css is
    port(
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
    type ins is array(0 to 3) of std_logic_vector(130 downto 0);
    type outs is array(0 to 3) of std_logic_vector(114 downto 0);

    signal priority: integer := 0;
    signal served: integer := 0;
    
    signal reqs: std_logic_vector(0 to 3);
    signal cores_in: ins;
    signal cores_out: outs;

begin
    reqs <= (core0_out(114) or core0_out(113)) &
            (core1_out(114) or core1_out(113)) &
            (core2_out(114) or core2_out(113)) &
            (core3_out(114) or core3_out(113));
    
    -- css to cores
    core0_in <= cores_in(0);
    core1_in <= cores_in(1);
    core2_in <= cores_in(2);
    core3_in <= cores_in(3);

    -- cores to css
    cores_out(0) <= core0_out;
    cores_out(1) <= core1_out;
    cores_out(2) <= core2_out;
    cores_out(3) <= core3_out;

    round_process: process(priority, reqs, cores_in, cores_out)
    begin
        if (reqs(priority) = '1') then
            cores_in(priority) <= main_mem_out;
            main_mem_in <= cores_out(priority);

            cores_in((priority + 1) mod 4) <= (others => '0');
            cores_in((priority + 2) mod 4) <= (others => '0');
            cores_in((priority + 3) mod 4) <= (others => '0');

            served <= priority;

        elsif (reqs((priority + 1) mod 4) = '1') then
            cores_in((priority + 1) mod 4) <= main_mem_out;
            main_mem_in <= cores_out((priority + 1) mod 4);

            cores_in((priority + 2) mod 4) <= (others => '0');
            cores_in((priority + 3) mod 4) <= (others => '0');
            cores_in(priority)             <= (others => '0');

            served <= (priority + 1) mod 4;

        elsif (reqs((priority + 2) mod 4) = '1') then
            cores_in((priority + 2) mod 4) <= main_mem_out;
            main_mem_in <= cores_out((priority + 2) mod 4);

            cores_in((priority + 3) mod 4) <= (others => '0');
            cores_in(priority)             <= (others => '0');
            cores_in((priority + 1) mod 4) <= (others => '0');

            served <= (priority + 2) mod 4;

        elsif (reqs((priority + 3) mod 4) = '1') then
            cores_in((priority + 3) mod 4) <= main_mem_out;
            main_mem_in <= cores_out((priority + 3) mod 4);

            cores_in(priority)             <= (others => '0');
            cores_in((priority + 1) mod 4) <= (others => '0');
            cores_in((priority + 2) mod 4) <= (others => '0');

            served <= (priority + 3) mod 4;

        end if;

    end process round_process;

    process begin
        if (served'event) then
            priority <= (priority + 1) mod 4;
        end if;
        
        wait on served;
    end process;

end behavior_css;
