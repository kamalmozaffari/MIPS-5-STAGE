Library ieee;
Use ieee.std_logic_1164.all;
USE work.PACKAGE_MIPS.all;
USE ieee.numeric_std.all;



ENTITY STAGE_MIPS IS 
  
PORT (
		CLOCK             	 	:IN STD_LOGIC:='0';---COMING 
		RST                 	:IN  STD_LOGIC:='0';--COMING
		---------------------
		GEN_ADDRESS_INSTRUCTION	:OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');--- GOING TO TEST BENCH
		INPUT_INSTRUCTION		:IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0'); ---COMING BASED ON GEN_ADDRESS_INSTRUCTIONS
	----------------------------------------------

		ADDRESS_MEMORY			:OUT  STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');---ADDESS
		COMING_DATA_MEMORY 		:IN   STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0'); ---- 
	-----------------------------------------------------------------------------------

		GOING_DATA_MEMORY 		:OUT  STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0')
);

END ENTITY;

ARCHITECTURE STRUCTURAL OF STAGE_MIPS IS 
SIGNAL RegRd_IdEx_O,CU,RegRt_IdEx_O,RegRs_IdEx_I,RegRt_IdEx_I,RegRd_MemWb_O,RegRd_Mem,RegRs_IdEx_O,RegRd_IdEx_I,RegRd_ExMem_I :STD_LOGIC_VECTOR(REG-1 DOWNTO 0):=(OTHERS=>'0');
SIGNAL AluOp_IdEx_O,AluOp_IdEx_S1,AluOp,FUA,FUB:STD_LOGIC_VECTOR(1 DOWNTO 0):=(OTHERS=>'0');
SIGNAL AluSrc_IdEx_S1,RegDst_IdEx_S1,RegWrite_IdEx_S1,MemRead_IdEx_S1,MemWrite_IdEx_S1,MemToReg_IdEx_S1,Jmp_IdEx_S1,Brq_S1 :STD_LOGIC:='0';
SIGNAL MemRead_ExMem_O,MemToReg_Mem,CARRY,AluSrc ,RegDst ,RegWrite ,MemRead ,MemWrite ,MemToReg ,Jmp ,Brq,Branch_equals,RegWrite_EX ,RegDst_IdEx_O,AluSrc_IdEx_O,MemToReg_Wb,MemWrite_ExMem_O,MemWrite_ExMem_O1,BRQ_F  :STD_LOGIC:='0';
SIGNAL MemRead_Ex,IfId_Disable,NOP,DETECT_H,RegWrite_MemWb_O,RegWrite_Mem,Over_Flow,FLUSH,MemToReg_EX,MemWrite_EX :STD_LOGIC:='0';
SIGNAL controlsignal_in,controlsignal_out:STD_LOGIC_VECTOR(9 DOWNTO 0):=(OTHERS=>'0');
SIGNAL No_Z:STD_LOGIC_VECTOR(9 DOWNTO 0):=(OTHERS=>'0');
SIGNAL AluResult_ExMem_O1,DATA_ExMem_O1,DATA_ExMem_O,AluResult_ExMem_O, AluResult_MemWb_O,DATA_MemWb_O,DATA_MemWb_I,AluResult_MemWb_I,DATA_ExMem_I,AluResult_ExMem_I,Immediate_SE_IdEx_O,ReadData_Rt_IdEx_O,ReadData_Rs_IdEx_O,  Immediate_SE_IdEx_I,ReadData_Rt_IdEx_I,ReadData_Rs_IdEx_I,ADD_Branch_IF,INSTRUCTION_IfId_I,ADD4_Result_IfId_I,Jump_Address_MemWb_I,INSTRUCTION_IfId_O,ADD4_Result_IfId_O,DATA_WB,address_instructionIF_ID_I,
					address_instructionIF_ID_O,address_instructionID_EX_O: STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(OTHERS=>'0');

 BEGIN

  ----------------TEST
  
 --------------------------------------CONTROL Unit-----------------------------------------------------
 G_ControlUnit   :Control_Unit		PORT MAP(
												CU,-------
												AluOp_IdEx_S1,
												AluSrc_IdEx_S1,
												RegDst_IdEx_S1,
												RegWrite_IdEx_S1,
												MemRead_IdEx_S1,
												MemWrite_IdEx_S1,
												MemToReg_IdEx_S1,
												Jmp_IdEx_S1,
												Brq_S1
												);
												
												
controlsignal_in<=AluOp_IdEx_S1&AluSrc_IdEx_S1&RegDst_IdEx_S1&RegWrite_IdEx_S1&MemRead_IdEx_S1&MemWrite_IdEx_S1&MemToReg_IdEx_S1&Jmp_IdEx_S1&Brq_S1;
------------------------------------------------Hazard -----------------------------------------
 Mux_hazard_detection: MUX2TO1 GENERIC MAP (10) PORT MAP (controlsignal_in,
 															No_Z,
 															NOP,
 														controlsignal_out
 														);
AluOp		<=	controlsignal_out(9 DOWNTO 8);	
AluSrc		<=	controlsignal_out(7);			
RegDst		<=	controlsignal_out(6);
RegWrite	<=	controlsignal_out(5);---	
MemRead		<=	controlsignal_out(4);---MEM
MemWrite	<=	controlsignal_out(3);---MEM			
MemToReg	<=	controlsignal_out(2); -----------WB
Jmp			<=	controlsignal_out(1);
Brq			<=	controlsignal_out(0);
Brq_F<= Brq AND	Branch_equals;
----------------------------------------------------------------------------------------------------------
 G_HAZARD_DEC: HazardDetection_Unit GENERIC MAP(REG) PORT MAP (
												MemRead_Ex,		----OK
												RegRt_IdEx_O,	---OK
												RegRs_IdEx_I,	---OK
												RegRt_IdEx_I,	---OK
												DETECT_H,		---GOING IF BLOCK
												IfId_Disable,	--- GOING IF/ID REG 
												nop				--- GOING HAZARD-MUX
												);
												
-----------------------------------------FORWARDING UINT--------------------------------------
G_FORWADING: ForwardingUnit	PORT MAP(
									RegWrite_MemWb_O,	---OK
									RegWrite_Mem,		---OK
									RegRd_MemWb_O,		---OK
									RegRd_Mem,			---OK
									RegRs_IdEx_O,		---OK
									RegRt_IdEx_O,		---OK
									FUA,				---OK
									FUB					---OK
									);
									
 
 G_IF	:I_F  GENERIC MAP (n) PORT MAP (	Clock,
						DETECT_H,				--- COMING HAZARD DETECTION UNIT
						RST,					--- GENERAL
						Brq_F,					--- COMING CONTROL UNIT
						Jmp,					-----COMING CONTROL UNIT
						ADD_Branch_IF,			---COMING ID 
						INPUT_INSTRUCTION,		--- GENERAL 
						ReadData_Rs_IdEx_I,---?????   jump
						GEN_ADDRESS_INSTRUCTION,---------------OUT
						INSTRUCTION_IfId_I,		--- GOING REG IF/ID
						ADD4_Result_IfId_I,		--- GOING REG IF/ID
						Over_Flow--- GENERAL 
				
						);
						
						--------------------------
						
 IF_ID	:REG_IF_ID		PORT MAP (CLOCK,
											IfId_Disable,		---COMING HAZARD DETECTION
											FLUSH,				---COMING CONTROL UNIT
											------------------------------------------------
											INSTRUCTION_IfId_I,	--- COMING IF
											ADD4_Result_IfId_I,
											------------------------------------------------
											INSTRUCTION_IfId_O,	--- GOING ID 
											ADD4_Result_IfId_O									
											);
 G_ID	:I_D GENERIC MAP (n,REG,REG_COUNT,I)PORT MAP (	Clock,
						RegWrite_MemWB_O,		---- write signal for register file coming MEM/WB REGISTER
						INSTRUCTION_IfId_O,		---- INSTRUCTION FETCH COMING IF/ID REGISTER
						ADD4_RESULT_IfId_O,		---- ADD 4 COMING IF.ID REGISTER
						RegRd_MemWB_O,			---- DESTINATION REGISTER COMING FROM EX/MEM REGISTER 
						DATA_WB,				---- DATA COMING WRITE-BACK STAGE 
						CU,						---- OPCODE GOING TO CONTROL UNIT 
						ReadData_Rs_IdEx_I, 	---- DATA REGISTER RS GOING TO ID/EXE REGISTER 
						ReadData_Rt_IdEx_I,		---- DATA REGISTER RT GOING TO ID/EXE REGISTER 
						Immediate_SE_IdEx_I,	---- IMMEDIATE 32 BIT GOING TO ID/EXE REGISTER 
						RegRt_IdEx_I,			---- NUMBER OF RT REGISTER GOING TO ID/EX REGISTER 
						RegRd_IdEx_I,			---- NUMBER OF RD REGISTER GOING TO ID/EX REGISTER
						RegRs_IdEx_I,			---- NUMBER OF RD REGISTER GOING TO ID/EX REGISTER
						ADD_Branch_IF,			---- GOING IF
						Branch_equals 			---- BRANCH EQUAL ZERO 
						
						);
 ID_EX	:REG_ID_EX 				 PORT MAP (CLOCK,
                      ReadData_Rs_IdEx_I,
											ReadData_Rt_IdEx_I,
											Immediate_SE_IdEx_I,
											---------------------------------------------------------------
											RegWrite,			---CONTROL SIGNAL WB	IN	REG
											MemToReg,			---CONTROL SIGNAL WB	IN	REG
											MemWrite,			---CONTROL SIGNAL MEM	IN	REG
											MemRead,			---CONTROL SIGNAL MEM	IN	REG
											AluOp,				---CONTROL SIGNAL EX	IN	REG
											RegDst,				---CONTROL SIGNAL EX	IN	REG	
											AluSrc,				---CONTROL SIGNAL EX	IN	REG
											------------------------------------------------------------------
											RegRt_IdEx_I,
											RegRd_IdEx_I,
											RegRs_IdEx_I,
											----------------------------------
											 
											ReadData_Rs_IdEx_O,
											ReadData_Rt_IdEx_O,
											Immediate_SE_IdEx_O,
											--------------
											RegWrite_EX,		---CONTROL SIGNAL WB	OUT  	REG
											MemToReg_EX,		---CONTROL SIGNAL WB	OUT  	REG
											MemWrite_EX,		---CONTROL SIGNAL MEM	OUT		REG
											MemRead_Ex,			---CONTROL SIGNAL MEM	OUT		REG
											AluOp_IdEx_O,		---CONTROL SIGNAL EX	IN		REG
											RegDst_IdEx_O,		---CONTROL SIGNAL EX	IN		REG	
											AluSrc_IdEx_O,		---CONTROL SIGNAL EX	IN		REG
											-------------------------------------------------------------
											RegRt_IdEx_O,
											RegRd_IdEx_O,
											RegRs_IdEx_O
																				
											);
 G_EX	: E_X GENERIC MAP (n,REG)  PORT MAP(
						AluOp_IdEx_O,
						RegDst_IdEx_O,
						AluSrc_IdEx_O,
						FUA,
						FUB,
						ReadData_Rs_IdEx_O,
						ReadData_Rt_IdEx_O,
						Immediate_SE_IdEx_O,					
						DATA_WB,								---INPUT DATA AS WB
						AluResult_ExMem_O,						---INPUT DATA AS FORWARDING
						RegRt_IdEx_O,
						RegRd_IdEx_O,
						AluResult_ExMem_I,						---OUTPUT ALU			IN		REGISTER
						DATA_ExMem_I,							--INPUT DATA MEMORY		IN		REGISTER						
						RegRd_ExMem_I,
						CARRY
						);
						
						
 EX_MEM	:REG_EX_MEM					PORT MAP(CLOCK,
											AluResult_ExMem_I,		---OUTPUT ALU			IN		REGISTER
 											DATA_ExMem_I,		 ---INPUT DATA MEMORY		IN		REGISTER
											------------------------------------------------------------------
											RegWrite_EX,			 ---CONTROL SIGNAL WB		IN		REG
											MemToReg_EX, 		 ---CONTROL SIGNAL WB		IN		REG
											MemWrite_Ex,		 ---CONTROL SIGNAL MEM		IN		REG
											MemRead_Ex,			 ---CONTROL SIGNAL MEM		IN		REG
											------------------------------------------------------------------
											RegRd_ExMem_I,		---REGISTER DESTINATION 	IN REGISTER
											------------------------------------------------------------------
			---------------------------------------------------------------------------------------------------------------											
											AluResult_ExMem_O,		---OUTPUT ALU			OUT		REGISTER				
											DATA_ExMem_O,		 ---INPUT DATA MEMORY		OUT		REGISTER
											--------------------------------------------------------------------
											RegWrite_Mem,		 ---CONTROL SIGNAL WB		OUT		REG
											MemToReg_Mem,		 ---CONTROL SIGNAL WB		OUT		REG
											--------------------------------------------------------------------
											MemWrite_ExMem_O,	 ---CONTROL SIGNAL MEM		OUT		REG
											MemRead_ExMem_O,	 ---CONTROL SIGNAL MEM		OUT		REG
											-----------------------------------------------------------------
											RegRd_Mem 		---REGISTER DESTINATION 	OUT REGISTER
											);
----------------------------------------------------------

mux_read:mux2to1 GENERIC MAP (n)  PORT MAP (OPEN,COMING_DATA_MEMORY,MemRead_ExMem_O,DATA_MemWb_I);
mux_write:mux2to1 GENERIC MAP (n) PORT MAP (OPEN,DATA_ExMem_O,MemWrite_ExMem_O,GOING_DATA_MEMORY);

ADDRESS_MEMORY<=AluResult_ExMem_O;---ADREESS

--------------------------------------------------------------
						
 MEM_WB	:REG_MEM_WB PORT MAP (CLOCK,
								AluResult_ExMem_O,			---result alu 		 IN register
								DATA_MemWb_I,				---out put memory 	 IN register
								--------------------------------------------------------------
								RegWrite_Mem,				---CONTROL SIGNAL WB IN  REG
								MemToReg_Mem,				---CONTROL SIGNAL WB IN  REG
								----------------------------------------------------------
								RegRd_Mem,					---REGISTER DESTINATION 	IN REGISTER
								---------------------------------------------------------
						
								-----------------------------------------------------------
								AluResult_MemWb_O,			---result alu	 	 OUT register
								DATA_MemWb_O,				---out put memory	 out register
								----------------------------------------------------------------
								RegWrite_MemWb_O,			---CONTROL SIGNAL WB OUT  REG
								MemToReg_Wb,				---CONTROL SIGNAL WB OUT REG
--------------------------------------------------------------------------------------------------------------								
								RegRd_MemWb_O					---REGISTER DESTINATION 	OUT REGISTER	
								
								----------------------------------------------------------------
								);

								
 G_WB	:W_B  GENERIC MAP (n)
      PORT MAP (
						AluResult_MemWb_O,	------- result alu  
						DATA_MemWb_O,		------- out put memory 
						DATA_WB,			------- select between alu result and output memory
						MemToReg_Wb		------- signal select	
						);
						
						
 

END STRUCTURAL;
