library ieee;
use ieee.std_logic_1164.all;

entity testbench_alu is
end testbench_alu;

architecture testbench of testbench_alu is
    component cometa16_alu is
        port(
            control_alu:   in std_logic_vector(3 downto 0);
            control_mux_a: in std_logic;
            control_mux_b: in std_logic_vector(1 downto 0);
    
            rf1_data:      in std_logic_vector(15 downto 0);
            rf2_data:      in std_logic_vector(15 downto 0);
    
            rd_data:       in std_logic_vector(15 downto 0);
            ex_data:       in std_logic_vector(15 downto 0);
            hi_data:       in std_logic_vector(15 downto 0);
    
            z_signal:      out std_logic;
            n_signal:      out std_logic;
    
            alu_out:       out std_logic_vector(15 downto 0)
        );
    
    end component cometa16_alu;

    signal control_alu:   std_logic_vector(3 downto 0);
    signal control_mux_a: std_logic;
    signal control_mux_b: std_logic_vector(1 downto 0);

    signal rf1_data:       std_logic_vector(15 downto 0);
    signal rf2_data:       std_logic_vector(15 downto 0);

    signal rd_data:        std_logic_vector(15 downto 0);
    signal ex_data:        std_logic_vector(15 downto 0);
    signal hi_data:        std_logic_vector(15 downto 0);

    signal z_signal:       std_logic;
    signal n_signal:       std_logic;

    signal alu_out:        std_logic_vector(15 downto 0);

begin
    alu: cometa16_alu port map(
        control_alu   => control_alu,
        control_mux_a => control_mux_a,
        control_mux_b => control_mux_b,
    
        rf1_data => rf1_data,
        rf2_data => rf2_data,
    
        rd_data => rd_data,
        ex_data => ex_data,
        hi_data => hi_data,
    
        z_signal => z_signal,
        n_signal => n_signal,
    
        alu_out => alu_out
    );

    tb: process
    
    begin
        control_alu <= "0100"; -- sum
        control_mux_a <= '0'; -- RF1
        control_mux_b <= "00"; -- RF2

        rf1_data <= "0000000000000100"; -- 4
        rf2_data <= "0000000000001000"; -- 8

        rd_data <= "0000000000000000"; -- 0
        ex_data <= "0000000000000000"; -- 0
        hi_data <= "0000000000000000"; -- 0

        wait for 10 ns;
        assert alu_out = "0000000000001100" report "Sum test failed!";


        control_alu <= "0101"; -- difference
        control_mux_a <= '0'; -- RF1
        control_mux_b <= "00"; -- RF2

        rf1_data <= "0000000000000100"; -- 4
        rf2_data <= "0000000000001000"; -- 8

        rd_data <= "0000000000000000"; -- 0
        ex_data <= "0000000000000000"; -- 0
        hi_data <= "0000000000000000"; -- 0

        wait for 10 ns;
        assert alu_out = "1111111111111100" report "Difference test failed!";

        report "Testbench finished" severity note;
        wait;

    end process;

end testbench;
