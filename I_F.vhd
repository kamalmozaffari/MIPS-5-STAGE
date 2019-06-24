Library ieee;
Use ieee.std_logic_1164.all;
USE work.PACKAGE_MIPS.all;
USE ieee.numeric_std.all;

 

ENTITY I_F IS 
GENERIC (
		n:INTEGER:=32

		);

  PORT (
    Clock     :IN STD_LOGIC;
		DETECT_H			:IN 	STD_LOGIC:='1';
		RST					:IN 	STD_LOGIC:='0';
		Brq					:IN		STD_LOGIC:='0';
		Jmp					:IN		STD_LOGIC:='0';-----------------------------------------??????????
		ADD_Branch			:IN 	STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(OTHERS=>'0');-----??????????
		INPUT_INSTRUCTION   :IN  	STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(OTHERS=>'0');
		Jump_Address_MemWb_I:IN		STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');
		ADDRESS_INSTRUCTION_GEN:OUT		STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0'); ---GOIGN TO TEST BENCH
		INSTRUCTION_IfId_O	:OUT 	STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(OTHERS=>'0');
		ADD4_Result_IfId_O	:OUT	STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');
		Over_Flow			:OUT 	STD_LOGIC:='0'
		);
END ENTITY;

ARCHITECTURE ST of I_F IS 
SIGNAL PC_in,ADDRESS_INSTRUCTION_s,ADD4_Result_S,ADD4_Branch:STD_LOGIC_VECTOR (n-1 DOWNTO 0):=(OTHERS=>'0');
SIGNAL RD:STD_LOGIC:='0';
SIGNAL GND:STD_LOGIC:='0';
BEGIN

ADD4_Result_IfId_O<=ADD4_Result_S;
PC_1			    :PC		GENERIC MAP(n)					PORT MAP(Clock,DETECT_H,RST,PC_in,ADDRESS_INSTRUCTION_s);
ADD_4				:ADD4	GENERIC MAP(n)					Port MAP(ADDRESS_INSTRUCTION_s,ADD4_Result_S,Over_Flow);
--------------BRANCH----------------------
MUX_Branch:MUX2TO1 GENERIC MAP (n) PORT MAP (ADD4_Result_S,ADD_Branch,Brq,ADD4_Branch);
----------------jump----------------------

G_MUX_JUMP		:MUX2TO1	GENERIC MAP(n)					PORT MAP (ADD4_Branch,Jump_Address_MemWb_I,Jmp,PC_in);

-----------------------------------------

INSTRUCTION_IfId_O<=INPUT_INSTRUCTION;
ADDRESS_INSTRUCTION_Gen<=ADDRESS_INSTRUCTION_s;--ok


END ARCHITECTURE;

			
    
