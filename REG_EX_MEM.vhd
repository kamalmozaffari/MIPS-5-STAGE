Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE WORK.PACKAGE_MIPS.ALL;

 

ENTITY REG_EX_MEM IS 
					PORT (Clock:IN STD_LOGIC; 
					
							AluResult_ExMem_I	:IN STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');		---OUTPUT ALU			IN		REGISTER
 							DATA_ExMem_I		:IN STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');		 ---INPUT DATA MEMORY		IN		REGISTER
------------------------------------------------------------------
							RegWrite_EX			:IN STD_LOGIC:='0'; ---CONTROL SIGNAL WB		IN		REG
							MemToReg_EX 		:IN STD_LOGIC:='0'; ---CONTROL SIGNAL WB		IN		REG
							MemWrite_Ex			:IN STD_LOGIC:='0'; ---CONTROL SIGNAL MEM	IN		REG
							MemRead_Ex			:IN STD_LOGIC:='0'; ---CONTROL SIGNAL MEM	IN		REG
------------------------------------------------------------------
							RegRd_ExMem_I 		:IN STD_LOGIC_VECTOR(3 DOWNTO 0):=(others=>'0');---REGISTER DESTINATION 	IN REGISTER
---------------------------------------------------------------------------------------------------------------											
							AluResult_ExMem_O	:OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0'); ---OUTPUT ALU			OUT		REGISTER				
							DATA_ExMem_O 		:OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0'); ---INPUT DATA MEMORY	OUT		REGISTER
--------------------------------------------------------------------
							RegWrite_Mem		:OUT STD_LOGIC:='0'; ---CONTROL SIGNAL WB		OUT		REG
							MemToReg_Mem		:OUT STD_LOGIC:='0'; ---CONTROL SIGNAL WB		OUT		REG
--------------------------------------------------------------------
							MemWrite_ExMem_O	:OUT STD_LOGIC:='0';	 ---CONTROL SIGNAL MEM		OUT		REG
							MemRead_ExMem_O		:OUT STD_LOGIC:='0';	 ---CONTROL SIGNAL MEM		OUT		REG
-----------------------------------------------------------------
							RegRd_Mem			:OUT STD_LOGIC_VECTOR(3 DOWNTO 0):=(others=>'0')---REGISTER DESTINATION 	OUT REGISTER
											);
END ENTITY;

ARCHITECTURE ST of REG_EX_MEM IS 

BEGIN
         process(Clock)
        begin
            if( Clock'event and Clock = '1') then
							AluResult_ExMem_O	<=AluResult_ExMem_I;	---OUTPUT ALU			IN		REGISTER
 							DATA_ExMem_O		<=DATA_ExMem_I;			---INPUT DATA MEMORY	IN		REGISTER
------------------------------------------------------------------
							RegWrite_Mem		<=RegWrite_EX;			---CONTROL SIGNAL WB	IN		REG
							MemToReg_Mem		<=MemToReg_EX ;			---CONTROL SIGNAL WB	IN		REG
							
							MemWrite_ExMem_O	<=MemWrite_Ex;			---CONTROL SIGNAL MEM	IN		REG
							MemRead_ExMem_O		<=MemRead_Ex;			---CONTROL SIGNAL MEM	IN		REG
------------------------------------------------------------------
							RegRd_Mem			<=RegRd_ExMem_I;		---REGISTER DESTINATION	IN REGISTER
            end if;
        end process;

END ARCHITECTURE;

			
    