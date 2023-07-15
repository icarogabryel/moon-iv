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

entity cometa16_testbench is end;

architecture behavior_testbench of cometa16_testbench is
    constant clk_period: time := 40 ns;
    signal clk_count: integer := 0;

    signal clk: std_logic;
    signal rst: std_logic;

    component cometa16_datapath is
        port(
            clk: in std_logic;
            rst: in std_logic
            
        );
    
    end component;

begin
    dut: cometa16_datapath
        port map(
            clk=> clk,
            rst => rst
        );

    clock_process: process

    begin
        clk <= '0';
        wait for clk_period/2;

        clk <= '1';
        clk_count <= clk_count + 1;
        wait for clk_period/2;

        if (clk_count = 100) then
            report "ending simulation";
            wait;

        end if;

    end process clock_process;

    reset_process: process
    
    begin
        rst <= '0';
        wait for 10 ns;

        rst <= '1';
        wait for 30 ns;

        rst <= '0';
        wait;
    
    end process reset_process;

end behavior_testbench;
