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

library work;
use work.opcodes.all;

entity cometa16_controller is
    port(
        opcode:           in std_logic_vector(5 downto 0);

        ctrl_dvc:         out std_logic_vector(2 downto 0);
        ctrl_dvi:         out std_logic_vector(1 downto 0);

        ctrl_stk:         out std_logic_vector(1 downto 0);
        ctrl_wr_rf:       out std_logic;
        ctrl_src_rf:      out std_logic;
    
        ctrl_wr_ac:       out std_logic;
        ctrl_src_ac:      out std_logic_vector(2 downto 0);
    
        ctrl_wr_hilo:     out std_logic;
        ctrl_src_hilo:    out std_logic_vector(1 downto 0);
    
        ctrl_sign_extend: out std_logic_vector(1 downto 0);
    
        ctrl_src_alu_a:   out std_logic;
        ctrl_src_alu_b:   out std_logic_vector(1 downto 0);
        ctrl_alu:         out std_logic_vector(3 downto 0);
    
        ctrl_shifter:     out std_logic_vector(1 downto 0);

        ctrl_wr_data_mem: out std_logic;
        ctrl_data_mem_use: out std_logic

    );

end cometa16_controller;

architecture behavior_controller of cometa16_controller is

begin
    process(opcode)

    begin
        case opcode is
            when nope_opcode =>

            ctrl_dvc         <= "000";
            ctrl_dvi         <= "00";

            ctrl_stk         <= "00";
            ctrl_wr_rf       <= '0';
            ctrl_src_rf      <= '0';
        
            ctrl_wr_ac       <= '0';
            ctrl_src_ac      <= "000";
        
            ctrl_wr_hilo     <= '0';
            ctrl_src_hilo    <= "00";
        
            ctrl_sign_extend <= "00";
        
            ctrl_src_alu_a   <= '0';
            ctrl_src_alu_b   <= "00";
            ctrl_alu         <= "0000";
        
            ctrl_shifter     <= "00";

            ctrl_wr_data_mem <= '0';
            ctrl_data_mem_use <= '0';

            when add_opcode =>

            ctrl_dvc         <= "000";
            ctrl_dvi         <= "00";

            ctrl_stk         <= "00";
            ctrl_wr_rf       <= '0';
            ctrl_src_rf      <= '0';
        
            ctrl_wr_ac       <= '1';
            ctrl_src_ac      <= "000";
        
            ctrl_wr_hilo     <= '0';
            ctrl_src_hilo    <= "00";
        
            ctrl_sign_extend <= "00";
        
            ctrl_src_alu_a   <= '0';
            ctrl_src_alu_b   <= "00";
            ctrl_alu         <= "0100";
        
            ctrl_shifter     <= "00";

            ctrl_wr_data_mem <= '0';
            ctrl_data_mem_use <= '0';

            when lwr_opcode =>

            ctrl_dvc         <= "000";
            ctrl_dvi         <= "00";

            ctrl_stk         <= "00";
            ctrl_wr_rf       <= '0';
            ctrl_src_rf      <= '0';
        
            ctrl_wr_ac       <= '1';
            ctrl_src_ac      <= "001";
        
            ctrl_wr_hilo     <= '0';
            ctrl_src_hilo    <= "00";
        
            ctrl_sign_extend <= "00";
        
            ctrl_src_alu_a   <= '0';
            ctrl_src_alu_b   <= "00";
            ctrl_alu         <= "0000";
        
            ctrl_shifter     <= "00";

            ctrl_wr_data_mem <= '0';
            ctrl_data_mem_use <= '1';

            when swr_opcode =>

            ctrl_dvc         <= "000";
            ctrl_dvi         <= "00";

            ctrl_stk         <= "00";
            ctrl_wr_rf       <= '0';
            ctrl_src_rf      <= '0';
        
            ctrl_wr_ac       <= '0';
            ctrl_src_ac      <= "000";
        
            ctrl_wr_hilo     <= '0';
            ctrl_src_hilo    <= "00";
        
            ctrl_sign_extend <= "00";
        
            ctrl_src_alu_a   <= '0';
            ctrl_src_alu_b   <= "00";
            ctrl_alu         <= "0000";
        
            ctrl_shifter     <= "00";

            ctrl_wr_data_mem <= '1';
            ctrl_data_mem_use <= '1';

            when others =>

            ctrl_dvc         <= "XXX";
            ctrl_dvi         <= "XX";

            ctrl_stk         <= "XX";
            ctrl_wr_rf       <= 'X';
            ctrl_src_rf      <= 'X';
        
            ctrl_wr_ac       <= 'X';
            ctrl_src_ac      <= "XXX";
        
            ctrl_wr_hilo     <= 'X';
            ctrl_src_hilo    <= "XX";
        
            ctrl_sign_extend <= "XX";
        
            ctrl_src_alu_a   <= 'X';
            ctrl_src_alu_b   <= "XX";
            ctrl_alu         <= "XXXX";
        
            ctrl_shifter     <= "XX";

            ctrl_wr_data_mem <= 'X';
            ctrl_data_mem_use <= 'X';

        end case;

    end process;

end behavior_controller;
