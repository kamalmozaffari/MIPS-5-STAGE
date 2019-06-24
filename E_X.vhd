Library ieee;
Use ieee.std_logic_1164.all;
USE work.PACKAGE_MIPS.all;
USE ieee.numeric_std.all;

 

ENTITY E_X IS 
GENERIC(
		n:INTEGER;
		REG:INTEGER
		);

  PORT (
  AluOp_IdEx_I			:IN		STD_LOGIC_VECTOR(1 DOWNTO 0):=(others=>'0');---ok
  RegDst_IdEx_I 		:IN		STD_LOGIC:='0';---ok
  AluSrc_IdEx_I			:IN		STD_LOGIC:='0';---ok
  FUA					:IN		STD_LOGIC_VECTOR(1		DOWNTO 0):=(others=>'0');---ok
  FUB					:IN		STD_LOGIC_VECTOR(1		DOWNTO 0):=(others=>'0');---ok
  ReadData_Rs_IdEx_I	:IN		STD_LOGIC_VECTOR(n-1	DOWNTO 0):=(others=>'0');---ok
  ReadData_Rt_IdEx_I	:IN		STD_LOGIC_VECTOR(n-1	DOWNTO 0):=(others=>'0');---ok
  Immediate_SE_IdEx_I	:IN		STD_LOGIC_VECTOR(n-1	DOWNTO 0):=(others=>'0');---ok
  DATA_WB_I				:IN		STD_LOGIC_VECTOR(n-1	DOWNTO 0):=(others=>'0');---ok
  AluResult_ExMem_I		:IN 	STD_LOGIC_VECTOR(n-1	DOWNTO 0):=(others=>'0');---ok
  RegRt_IdEx_I			:IN 	STD_LOGIC_VECTOR(REG-1	DOWNTO 0):=(others=>'0');---ok
  RegRd_IdEx_I			:IN 	STD_LOGIC_VECTOR(REG-1	DOWNTO 0):=(others=>'0');---ok
  AluResult_ExMem_O		:OUT	STD_LOGIC_VECTOR(n-1	DOWNTO 0):=(others=>'0');---ok
  DATA_ExMem_O			:OUT	STD_LOGIC_VECTOR(n-1 	DOWNTO 0):=(others=>'0');---ok
  RegRd_ExMem_O			:OUT	STD_LOGIC_VECTOR(REG-1	DOWNTO 0):=(others=>'0');---ok
  CARRY_O				:OUT	STD_LOGIC---ok
  );

END ENTITY;

ARCHITECTURE ST of E_X IS 
SIGNAL ALU_in1_S,DataMux_AluSrc_S,ALU_in2_S :STD_LOGIC_VECTOR (n-1 DOWNTO 0);
BEGIN
G_MUX_FORWARD_UNITA:MUX3TO1	GENERIC MAP	(n) PORT MAP(ReadData_Rs_IdEx_I,AluResult_ExMem_I,DATA_WB_I,FUA,ALU_in1_S);
G_MUX_FORWARD_UNITB:MUX3TO1	GENERIC MAP	(n) PORT MAP(ReadData_Rt_IdEx_I,AluResult_ExMem_I,DATA_WB_I,FUB,DataMux_AluSrc_S);
G_MUX_AluSrc	:MUX2TO1	GENERIC MAP	(n)	PORT MAP(DataMux_AluSrc_S,Immediate_SE_IdEx_I,AluSrc_IdEx_I,ALU_in2_S);
G_ALU			:ALU		GENERIC MAP	(n) PORT MAP(ALU_in1_S,ALU_in2_S,AluOp_IdEx_I,AluResult_ExMem_O,CARRY_O);
G_MUX3_rt_rd	:MUX2TO1	GENERIC MAP	(REG) PORT MAP(RegRd_IdEx_I,RegRt_IdEx_I,RegDst_IdEx_I,RegRd_ExMem_O);
---G_MUX3_rt_rd	:MUX2TO1	GENERIC MAP	(REG) PORT MAP(RegRt_IdEx_I,RegRd_IdEx_I,RegDst_IdEx_I,RegRd_ExMem_O);
DATA_ExMem_O<=DataMux_AluSrc_S;

END ARCHITECTURE;

			
    
