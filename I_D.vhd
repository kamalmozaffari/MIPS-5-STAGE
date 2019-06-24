Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE WORK.PACKAGE_MIPS.ALL;

 

ENTITY I_D IS 
GENERIC (
		n         :INTEGER;
		REG       :INTEGER;
		REG_COUNT :INTEGER;
		I         :INTEGER
		);
  PORT (
		Clock           		:IN 	STD_LOGIC:='0';
		RegWrite_ExMem_I  		:IN		STD_LOGIC:='0';
		INSTRUCTION_IfId_I		:IN		STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');
		ADD4_RESULT_IfId_I		:IN 	STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');
		RegRd_MemWb_I			:IN		STD_LOGIC_VECTOR(REG-1 DOWNTO 0):=(others=>'0');
		DATA_WB_I				:IN 	STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');
		CU_O					:OUT	STD_LOGIC_VECTOR(3 	DOWNTO 0):=(others=>'0');
		ReadData_Rs_IdEx_O		:OUT	STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');
		ReadData_Rt_IdEx_O		:OUT	STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');
		Immediate_SE_IdEx_O		:OUT	STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');
		RegRt_IdEx_O			:OUT	STD_LOGIC_VECTOR(REG-1 DOWNTO 0):=(others=>'0');
		RegRd_IdEx_O			:OUT	STD_LOGIC_VECTOR(REG-1 DOWNTO 0):=(others=>'0');
		RegRs_IdEx_O			:OUT	STD_LOGIC_VECTOR(REG-1 DOWNTO 0):=(others=>'0');
		ADD_Branch_IF_O			:OUT	STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');
		Branch_equals					:OUT	STD_LOGIC:='0'
		);
END ENTITY;
----------------یه ماکس به این سیستم اضافه کن برای hazard detection unit
ARCHITECTURE ST of I_D IS 
SIGNAL SignExtend                                                      :STD_LOGIC_VECTOR(n-I-1  DOWNTO 0):=(OTHERS=>'0');
SIGNAL Immediate_SE_S,Immediate_SE_Shift_S,ReadData_Rs_S,ReadData_Rt_S :STD_LOGIC_VECTOR(n-1    DOWNTO 0):=(OTHERS=>'0');
SIGNAL RegRs_S,RegRt_S,RegRd_S	                                        :STD_LOGIC_VECTOR(REG-1  DOWNTO 0):=(OTHERS=>'0');
SIGNAL CU_S                                                            :STD_LOGIC_VECTOR(3      DOWNTO 0):=(OTHERS=>'0');
SIGNAL GND                                                             :STD_LOGIC:='0';
BEGIN

Immediate_SE_S      <=SignExtend&INSTRUCTION_IfId_I(I-1 DOWNTO 0);---SIGN_EXTEND
Immediate_SE_Shift_S<=Immediate_SE_S(n-3 DOWNTO 0)&GND&GND;---IMMEDEIATE SHIFT

CU_S	<=INSTRUCTION_IfId_I(31 DOWNTO 28);
RegRs_S	<=INSTRUCTION_IfId_I(27 DOWNTO 24);
RegRt_S	<=INSTRUCTION_IfId_I(23 DOWNTO 20);
RegRd_S	<=INSTRUCTION_IfId_I(19 DOWNTO 16);


Reg_File        :REGISTER_FILES   GENERIC MAP (n,REG,REG_COUNT)	PORT MAP(
																			Clock,
																			RegRs_S,
																			RegRt_S,
																			RegRd_MemWb_I,
																			RegWrite_ExMem_I,
																			DATA_WB_I,
																			ReadData_Rs_S,
																			ReadData_Rt_S
																			);
G_ADDD_BRANCH   :CPA_FA           GENERIC MAP (n) 		    	PORT MAP(
																			Immediate_SE_Shift_S,
																			ADD4_RESULT_IfId_I,
																			GND,
																			ADD_Branch_IF_O,
																			OPEN
																			);
G_comparator    :COMPRATOR        GENERIC MAP (n) 		        PORT MAP (
																			ReadData_Rs_S,
																			ReadData_Rt_S,
																			Branch_equals
																			);

Immediate_SE_IdEx_O<=Immediate_SE_S;
CU_O				<=CU_S;
RegRt_IdEx_O		<=RegRt_S;
RegRd_IdEx_O		<=RegRd_S;
RegRs_IdEx_O		<=RegRs_S;
ReadData_Rs_IdEx_O	<=ReadData_Rs_S;
ReadData_Rt_IdEx_O	<=ReadData_Rt_S;


END ARCHITECTURE;

			
    