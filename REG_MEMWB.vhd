Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE WORK.PACKAGE_MIPS.ALL;

 

ENTITY REG_MEM_WB IS 
						PORT   (Clock:IN STD_LOGIC;
								AluResult_MemWb_I	:IN STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');		---result alu 				 IN register
								DATA_MemWb_I		:IN STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');		---out put memory 			 IN register
								--------------------------------------------------------------
								RegWrite_Mem		:IN STD_LOGIC:='0';						---CONTROL SIGNAL WB 		IN  REG
								MemToReg_Mem		:IN STD_LOGIC:='0';						---CONTROL SIGNAL WB 		IN  REG
								----------------------------------------------------------
								RegRd_Mem			:IN STD_LOGIC_VECTOR(3	 DOWNTO 0):=(others=>'0');		---REGISTER DESTINATION 	IN REGISTER
								---------------------------------------------------------

								AluResult_MemWb_O	:OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');	---result alu	 			 OUT register
								DATA_MemWb_O		:OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');	---out put memory			 OUT register
								----------------------------------------------------------------
								RegWrite_MemWb_O	:OUT STD_LOGIC:='0';							---CONTROL SIGNAL WB 		OUT  REG
								MemToReg_Wb			:OUT STD_LOGIC:='0';							---CONTROL SIGNAL WB 		OUT REG
--------------------------------------------------------------------------------------------------------------								
								RegRd_MemWb_O		:OUT STD_LOGIC_VECTOR(3 DOWNTO 0):=(others=>'0')		---REGISTER DESTINATION 	OUT REGISTER	
								);
END ENTITY;

ARCHITECTURE ST of REG_MEM_WB IS 

BEGIN
         process(Clock)
        begin
            if( Clock'event and Clock = '1') then
								AluResult_MemWb_O	<=AluResult_MemWb_I;	---result alu 		 IN register
								DATA_MemWb_O		<=DATA_MemWb_I;			---out put memory 	 IN register
								--------------------------------------------------------------
								RegWrite_MemWb_O	<=RegWrite_Mem;			---CONTROL SIGNAL WB IN  REG
								MemToReg_Wb			<=MemToReg_Mem;			---CONTROL SIGNAL WB IN  REG
								----------------------------------------------------------
								RegRd_MemWb_O		<=RegRd_Mem;			---REGISTER DESTINATION 	IN REGISTER
            end if;
        end process;

END ARCHITECTURE;

			
    