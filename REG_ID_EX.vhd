Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE WORK.PACKAGE_MIPS.ALL;

 

ENTITY REG_ID_EX IS 
					PORT   (Clock:IN STD_LOGIC:='0';
							ReadData_Rs_IdEx_I	:IN STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');
							ReadData_Rt_IdEx_I	:IN STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');
							Immediate_SE_IdEx_I	:IN STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');
---------------------------------------------------------------
							RegWrite 			:IN STD_LOGIC:='0';---CONTROL SIGNAL WB	IN	REG
							MemToReg 			:IN STD_LOGIC:='0';---CONTROL SIGNAL WB	IN	REG
							MemWrite 			:IN STD_LOGIC:='0';---CONTROL SIGNAL MEM	IN	REG
							MemRead 			:IN STD_LOGIC:='0';---CONTROL SIGNAL MEM	IN	REG
							AluOp 				:IN STD_LOGIC_VECTOR(1 DOWNTO 0):=(others=>'0');---CONTROL SIGNAL EX	IN	REG
							RegDst 				:IN STD_LOGIC;---CONTROL SIGNAL EX	IN	REG	
							AluSrc 				:IN STD_LOGIC;---CONTROL SIGNAL EX	IN	REG
-----------------------------------------------------------------
							RegRt_IdEx_I		:IN STD_LOGIC_VECTOR(3 DOWNTO 0):=(others=>'0');
							RegRd_IdEx_I		:IN STD_LOGIC_VECTOR(3 DOWNTO 0):=(others=>'0');
							RegRs_IdEx_I		:IN STD_LOGIC_VECTOR(3 DOWNTO 0):=(others=>'0');
----------------------------------
							ReadData_Rs_IdEx_O	:OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');
							ReadData_Rt_IdEx_O	:OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');
							Immediate_SE_IdEx_O	:OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');
							--------------
							RegWrite_EX 		:OUT STD_LOGIC:='0';---CONTROL SIGNAL WB	OUT  	REG
							MemToReg_EX 		:OUT STD_LOGIC:='0';---CONTROL SIGNAL WB	OUT  	REG
							MemWrite_EX 		:OUT STD_LOGIC:='0';---CONTROL SIGNAL MEM	OUT		REG
							MemRead_Ex 			:OUT STD_LOGIC:='0';---CONTROL SIGNAL MEM	OUT		REG
							AluOp_IdEx_O 		:OUT STD_LOGIC_VECTOR(1 DOWNTO 0):=(others=>'0');---CONTROL SIGNAL EX	IN		REG
							RegDst_IdEx_O 		:OUT STD_LOGIC:='0';---CONTROL SIGNAL EX	IN		REG	
							AluSrc_IdEx_O 		:OUT STD_LOGIC:='0';---CONTROL SIGNAL EX	IN		REG
-------------------------------------------------------------
							RegRt_IdEx_O		:OUT STD_LOGIC_VECTOR(3 DOWNTO 0):=(others=>'0');
							RegRd_IdEx_O		:OUT STD_LOGIC_VECTOR(3 DOWNTO 0):=(others=>'0');
							RegRs_IdEx_O		:OUT STD_LOGIC_VECTOR(3 DOWNTO 0):=(others=>'0')
							
);							
END ENTITY;

ARCHITECTURE ST of REG_ID_EX IS 

BEGIN
         process(Clock)
        begin
            if( Clock'event and Clock = '1') then
							ReadData_Rs_IdEx_O	<=	ReadData_Rs_IdEx_I;
							ReadData_Rt_IdEx_O	<=	ReadData_Rt_IdEx_I; 
							Immediate_SE_IdEx_O	<=	Immediate_SE_IdEx_I;
							--------------
							RegWrite_EX			<=	RegWrite;	 
							MemToReg_EX			<=	MemToReg;
							MemWrite_EX			<=	MemWrite;
							MemRead_Ex			<=	MemRead;
							AluOp_IdEx_O		<=	AluOp;
							RegDst_IdEx_O		<=	RegDst;
							AluSrc_IdEx_O		<=	AluSrc;
-------------------------------------------------------------
							RegRt_IdEx_O		<=RegRt_IdEx_I;
							RegRd_IdEx_O		<=RegRd_IdEx_I;
							RegRs_IdEx_O		<=RegRs_IdEx_I;
							
            end if;
        end process;

END ARCHITECTURE;

			
    
