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
        ins_mux: in std_logic_vector(15 downto 0);

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
    
        ctrl_shifter:     out std_logic_vector(1 downto 0)

    );

end cometa16_controller;

architecture behavior_controller of cometa16_controller is
    signal opcode: std_logic_vector(5 downto 0) := ins_mux(5 downto 0);

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

when SUBx  => Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0001";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '1';

when SLLx  =>               Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0001";
SH           <= "01";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '1';

when SRLx  => Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0010";
SH           <= "10";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '1';

when SRAx  => Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0010";
SH           <= "11";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '1';

when ANDx  => Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0100";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '1';

when ORx  => Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0101";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '1';

when XORx  => Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0110";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '1';

when NORx  => Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0111";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '1';

when MFACx => Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '1';
Reg1Esc      <= '1';
SrcReg2Esc   <= "00";
Reg2Esc      <= '0';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0000";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '0';

when MTACx => Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0010";
SH           <= "00";
LerMem       <= '1';
EscMem       <= '0';
Saida        <= '0';

when SLTx  => Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "01";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0001";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '0';

when ADDIS  => Dvc         <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "11";
SrcAluA      <= '1';
SrcAluB      <= "01";
AluOP        <= "0000";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '1';

when SUBIS  => Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "11";
SrcAluA      <= '1';
SrcAluB      <= "01";
AluOP        <= "0001";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '1';

when LOI  => Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "01";
AluOP        <= "0011";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '1';                                                    

when LUI  => Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "01";
SrcAluA      <= '0';
SrcAluB      <= "01";
AluOP        <= "0011";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '1'; 

when LIS  => Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "11";
SrcAluA      <= '0';
SrcAluB      <= "01";
AluOP        <= "0011";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '1';              

when ANDI  => Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '1';
SrcAluB      <= "01";
AluOP        <= "0100";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '1';

when ORI  => Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '1';
SrcAluB      <= "01";
AluOP        <= "0101";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '1';              

when XORI  =>               Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '1';
SrcAluB      <= "01";
AluOP        <= "0110";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '1'; 

when NORI  =>               Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '1';
SrcAluB      <= "01";
AluOP        <= "0111";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '1';

when NANDI  => Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH         <= '0';
Extensor     <= "00";
SrcAluA      <= '1';
SrcAluB      <= "01";
AluOP        <= "1000";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '1';                            

when LWR  => Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0010";
SH           <= "00";
LerMem       <= '1';
EscMem       <= '0';
Saida        <= '0';  

when SWR  => Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '0';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0010";
SH           <= "00";
LerMem       <= '1';
EscMem       <= '1';
Saida        <= '0';

when PUSHx => Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '1';
SrcReg2Esc   <= "00";
Reg2Esc      <= '0';
Push         <= '1';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0010";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '1';
Saida        <= '0';

when POPx  => Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '1';
SrcReg2Esc   <= "00";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '1';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0010";
SH           <= "00";
LerMem       <= '1';
EscMem       <= '0';
Saida        <= '0';


when J  => Dvc          <= "100";
Dvi          <= "01";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '0';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0000";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '0';

when JAL  => Dvc          <= "100";
Dvi          <= "01";
SrcReg1Esc   <= '0';
Reg1Esc      <= '1';
SrcReg2Esc   <= "00";
Reg2Esc      <= '0';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '1';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0000";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '0';             

when JR  => Dvc          <= "100";
Dvi          <= "10";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '0';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0000";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '0'; 

when JRL  => Dvc          <= "100";
Dvi          <= "10";
SrcReg1Esc   <= '0';
Reg1Esc      <= '1';
SrcReg2Esc   <= "00";
Reg2Esc      <= '0';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '1';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0000";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '0'; 


when JgTZ  => Dvc          <= "011";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '0';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '1';
SrcAluB      <= "00";
AluOP        <= "0010";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '0';

when JLTZ  => Dvc         <= "010";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '0';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '1';
SrcAluB      <= "00";
AluOP        <= "0010";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '0';

when JNEZ => Dvc          <= "001";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '0';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '1';
SrcAluB      <= "00";
AluOP        <= "0010";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '0';   

when JIZE => Dvc          <= "000"; --JIZE
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '0';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '1';
SrcAluB      <= "00";
AluOP        <= "0010";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '0';

WHEN TADM =>  Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '0';
EscRLH       <= '1';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH       <= '1';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "10";
AluOP        <= "0000";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '0';

WHEN MTL =>   Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '0';
EscRLH       <= '1';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH       <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0000";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '0';

WHEN MFH =>   Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "11";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH       <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0000";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '0';

WHEN MFL =>   Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "10";
Reg2Esc      <= '1';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH       <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0000";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '0';

WHEN OTHERS => Dvc          <= "100";
Dvi          <= "00";
SrcReg1Esc   <= '0';
Reg1Esc      <= '0';
SrcReg2Esc   <= "00";
Reg2Esc      <= '0';
EscRLH       <= '0';
Push         <= '0';
Pop          <= '0';
Jump         <= '0';
SrcRLH          <= '0';
Extensor     <= "00";
SrcAluA      <= '0';
SrcAluB      <= "00";
AluOP        <= "0010";
SH           <= "00";
LerMem       <= '0';
EscMem       <= '0';
Saida        <= '0';

        end case;

    end process;

end behavior_controller;
