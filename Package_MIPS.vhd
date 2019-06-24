library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;
use IEEE.STD_LOGIC_ARITH.ALL;




package Package_MIPS IS 


----------------------------------CONSTANTS---------------------
CONSTANT n:INTEGER:=32;
CONSTANT I:INTEGER:=16;--- the WIDTH of Immediate
CONSTANT REG:INTEGER:=4;
CONSTANT REG_COUNT:INTEGER:=2**REG; --- THE NUMBER OF REG TERS-16
CONSTANT P:INTEGER:=4;----WIDTH OF PC COUNTER WHICH  DEPENDS ON  MEMORY SIZE
CONSTANT WORD_MEM_COUNT:INTEGER:=2**P;---THE NUMBER OF WORD ADDRESS MEMORY-

        --- THE NUMBER OF  SELECTING BITS REG TERS(LOGARITHM OF THE NUMBER OF WORD ADDRESS MEMORY)



----------------------------------TYPES-------------------------
SUBTYPE BYTE IS STD_LOGIC_VECTOR(7 DOWNTO 0);
TYPE BYTE_VECTOR IS ARRAY (natural RANGE<>) OF BYTE;
SUBTYPE  Word   IS STD_LOGIC_VECTOR(n-1 DOWNTO 0);
TYPE Word_VECTOR  IS  ARRAY (natural RANGE <>) OF Word;
-------------------------------------------------------
COMPONENT FULL_ADDER   
 PORT (
        Xin,Yin,Cin:IN STD_LOGIC;
	Sout,Cout  :out STD_LOGIC
       );
END COMPONENT;
COMPONENT CPA_FA   
 GENERIC(
         n:INTEGER
         );
 PORT(
       Xin,Yin:IN  STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(OTHERS=>'0');
       Cin    :IN  STD_LOGIC:='0';
       Sout   :OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(OTHERS=>'0');
       Cout   :OUT STD_LOGIC:='0'
      );
END COMPONENT;
COMPONENT mux2to1_1  

	port (
		din0 : in std_logic;
		din1 : in std_logic;
		sel  : in std_logic;
		dout : out std_logic

	);
end COMPONENT;

COMPONENT mux2to1  
generic (
	n : integer
	);
	port (
		din0 : in std_logic_vector( n-1 downto 0):=(OTHERS=>'0');
		din1 : in std_logic_vector( n-1 downto 0):=(OTHERS=>'0');
		sel  : in std_logic;
		dout : out std_logic_vector( n-1 downto 0):=(OTHERS=>'0')

	);
end COMPONENT;

COMPONENT mux3to1  
generic (
	n : integer
	);
	port (
		din0 : in std_logic_vector( n-1 downto 0):=(OTHERS=>'0');
		din1 : in std_logic_vector( n-1 downto 0):=(OTHERS=>'0');
		din2 : in std_logic_vector( n-1 downto 0):=(OTHERS=>'0');
		sel  : in std_logic_VECTOR(1 DOWNTO 0 ):=(OTHERS=>'0');
		dout : out std_logic_vector( n-1 downto 0):=(OTHERS=>'0')

	);
end COMPONENT;


COMPONENT mux4to1  
generic (
	n : integer
	);
	port (
		din0 : in std_logic_vector( n-1 downto 0):=(OTHERS=>'0');
		din1 : in std_logic_vector( n-1 downto 0):=(OTHERS=>'0');
		din2 : in std_logic_vector( n-1 downto 0):=(OTHERS=>'0');
		din3 : in std_logic_vector( n-1 downto 0):=(OTHERS=>'0');
		sel  : in std_logic_VECTOR(1 DOWNTO 0 ):=(OTHERS=>'0');
		dout : out std_logic_vector( n-1 downto 0):=(OTHERS=>'0')

	);
end COMPONENT;

COMPONENT ALU  
GENERIC (
		n:integer
	);
PORT(
	INPUT_1		:IN		STD_LOGIC_VECTOR(n-1	DOWNTO 0):=(OTHERS=>'0');
    INPUT_2		:IN		STD_LOGIC_VECTOR(n-1 	DOWNTO 0):=(OTHERS=>'0');
    AluOp		:IN		STD_LOGIC_VECTOR(1		DOWNTO 0):=(OTHERS=>'0');
	DATA_OUT	:OUT	STD_LOGIC_VECTOR(n-1	DOWNTO 0):=(OTHERS=>'0');
	carry		:OUT	STD_LOGIC
		);
end COMPONENT;

COMPONENT PC  
    Generic(n : integer);
     Port (Clock	: IN 	STD_LOGIC:='0';
      
			DETECT_H: IN 	STD_LOGIC:='0';
			Reset	: IN	STD_LOGIC:='0';
---------------------------------------------------------------------------------------
			PC_in   : IN 	STD_LOGIC_VECTOR(n-1 downto 0):=(others=>'0');
			PC_out  : OUT 	STD_LOGIC_VECTOR(n-1 downto 0):=(OTHERS=>'0')
			);
End COMPONENT;


COMPONENT ADD4   
 GENERIC(
         n:INTEGER
         );
 PORT(
		Xin		:IN		STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(OTHERS=>'0');
		Sout	:OUT	STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(OTHERS=>'0');
		Cout	:OUT	STD_LOGIC
      );
END COMPONENT;

COMPONENT REGISTER_FILES   
GENERIC (
		n:integer ;
		REG:integer ;
		REG_COUNT:integer 
		);
		

  PORT (
		Clock			:IN 	STD_LOGIC :='0';
		rs_Add 			:IN		STD_LOGIC_VECTOR(REG-1 DOWNTO 0):=(OTHERS=>'0');
		rt_Add			:IN		STD_LOGIC_VECTOR(REG-1 DOWNTO 0):=(OTHERS=>'0');
		rd_Add			:IN 	STD_LOGIC_VECTOR(REG-1 DOWNTO 0):=(OTHERS=>'0');	
		RegWrite		:IN 	STD_LOGIC:='0';
		Data_in			:IN 	STD_LOGIC_VECTOR(n-1 DOWNTO 0) :=(OTHERS=>'0');
		OutPut_Reg_rs	:OUT	STD_LOGIC_VECTOR(n-1 DOWNTO 0) :=(OTHERS=>'0');
		OutPut_Reg_rt	:OUT	STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(OTHERS=>'0')
		);
END COMPONENT;


COMPONENT Comprator   
GENERIC (
		n:integer
		);
  PORT (
		Input1	:IN 	STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(OTHERS=>'0');
		Input2	:IN 	STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(OTHERS=>'0');
		Output	:OUT	STD_LOGIC
		
		);
END COMPONENT;

COMPONENT Control_Unit  

  PORT (
		Cu_in		:IN	 STD_LOGIC_VECTOR(3 DOWNTO 0):=(OTHERS=>'0');
		AluOp		:OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		AluSrc		:OUT STD_LOGIC;
		RegDst		:OUT STD_LOGIC;
		RegWrite 	:OUT STD_LOGIC;
		MemRead		:OUT STD_LOGIC;
		MemWrite	:OUT STD_LOGIC;
		MemToReg	:OUT STD_LOGIC;
		Jmp			:OUT STD_LOGIC;
		Brq			:OUT STD_LOGIC
		);
END COMPONENT;


COMPONENT HazardDetection_Unit   
GENERIC 
(
REG : INTEGER
);
  PORT (
  MemRead_IdEx	:IN STD_LOGIC:='0';
  RegRt_IdEx	:IN STD_LOGIC_VECTOR(REG-1 DOWNTO 0):=(others=>'0');
  RegRs_IfId	:IN STD_LOGIC_VECTOR(REG-1 DOWNTO 0):=(others=>'0');
  RegRt_IfId	:IN STD_LOGIC_VECTOR(REG-1 DOWNTO 0):=(others=>'0');
	DETECT_H	:OUT STD_LOGIC:='1';
	IfId_Disable:OUT STD_LOGIC:='0';
	NOP			:OUT STD_LOGIC:='0'
		);
END COMPONENT;

COMPONENT ForwardingUnit   

  PORT (
  RegWrite_MemWb  :IN    STD_LOGIC;
  RegWrite_ExMem  :IN    STD_LOGIC;
  RegRd_MemWb     :IN    STD_LOGIC_VECTOR(REG-1 DOWNTO 0);
  RegRd_ExMem     :IN    STD_LOGIC_VECTOR(REG-1 DOWNTO 0);
  RegRs_IdEx      :IN    STD_LOGIC_VECTOR(REG-1 DOWNTO 0);
  RegRt_IdEx      :IN    STD_LOGIC_VECTOR(REG-1 DOWNTO 0);
  ForwardA        :OUT   STD_LOGIC_VECTOR(1     DOWNTO 0);
  ForwardB        :OUT   STD_LOGIC_VECTOR(1     DOWNTO 0)
		);
END		COMPONENT;
COMPONENT I_F   
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
END COMPONENT;

COMPONENT REG_IF_ID IS 
PORT  (Clock:IN STD_LOGIC:='0';
											IfId_Disable:IN STD_LOGIC:='1';		---COMING HAZARD DETECTION
											FLUSH		:IN STD_LOGIC:='0';				---COMING CONTROL UNIT
											------------------------------------------------
											INSTRUCTION_IfId_I:IN STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');	--- COMING IF
											ADD4_Result_IfId_I:IN STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');	--- COMING IF

											------------------------------------------------
											INSTRUCTION_IfId_O:OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');	--- GOING ID 
											ADD4_Result_IfId_O:OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0')	--- GIING ID
											
											);
END COMPONENT;

COMPONENT I_D   
GENERIC (
		n         :INTEGER;
		REG       :INTEGER;
		REG_COUNT :INTEGER;
		I         :INTEGER
		);
  PORT (
		Clock           		:IN 	STD_LOGIC;
		RegWrite_ExMem_I  		:IN		STD_LOGIC;
		INSTRUCTION_IfId_I		:IN		STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		ADD4_RESULT_IfId_I		:IN 	STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		RegRd_MemWb_I			:IN		STD_LOGIC_VECTOR(REG-1 DOWNTO 0);
		DATA_WB_I				:IN 	STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		CU_O					:OUT	STD_LOGIC_VECTOR(3 	DOWNTO 0);
		ReadData_Rs_IdEx_O		:OUT	STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		ReadData_Rt_IdEx_O		:OUT	STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Immediate_SE_IdEx_O		:OUT	STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		RegRt_IdEx_O			:OUT	STD_LOGIC_VECTOR(REG-1 DOWNTO 0);
		RegRd_IdEx_O			:OUT	STD_LOGIC_VECTOR(REG-1 DOWNTO 0);
		RegRs_IdEx_O			:OUT	STD_LOGIC_VECTOR(REG-1 DOWNTO 0);
		ADD_Branch_IF_O			:OUT	STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Branch_equals					:OUT	STD_LOGIC
		);
END COMPONENT;

COMPONENT REG_ID_EX   
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
END COMPONENT;

COMPONENT E_X   
GENERIC(
		n:INTEGER;
		REG:INTEGER
		);

  PORT (
  AluOp_IdEx_I			:IN		STD_LOGIC_VECTOR(1 DOWNTO 0);---ok
  RegDst_IdEx_I 		:IN		STD_LOGIC;---ok
  AluSrc_IdEx_I			:IN		STD_LOGIC;---ok
  FUA					:IN		STD_LOGIC_VECTOR(1		DOWNTO 0);---ok
  FUB					:IN		STD_LOGIC_VECTOR(1		DOWNTO 0);---ok
  ReadData_Rs_IdEx_I	:IN		STD_LOGIC_VECTOR(n-1	DOWNTO 0);---ok
  ReadData_Rt_IdEx_I	:IN		STD_LOGIC_VECTOR(n-1	DOWNTO 0);---ok
  Immediate_SE_IdEx_I	:IN		STD_LOGIC_VECTOR(n-1	DOWNTO 0);---ok
  DATA_WB_I				:IN		STD_LOGIC_VECTOR(n-1	DOWNTO 0);---ok
  AluResult_ExMem_I		:IN 	STD_LOGIC_VECTOR(n-1	DOWNTO 0);---ok
  RegRt_IdEx_I			:IN 	STD_LOGIC_VECTOR(REG-1	DOWNTO 0);---ok
  RegRd_IdEx_I			:IN 	STD_LOGIC_VECTOR(REG-1	DOWNTO 0);---ok
  AluResult_ExMem_O		:OUT	STD_LOGIC_VECTOR(n-1	DOWNTO 0);---ok
  DATA_ExMem_O			:OUT	STD_LOGIC_VECTOR(n-1 	DOWNTO 0);---ok
  RegRd_ExMem_O			:OUT	STD_LOGIC_VECTOR(REG-1	DOWNTO 0);---ok
  CARRY_O				:OUT	STD_LOGIC---ok
  );

END COMPONENT;


COMPONENT REG_EX_MEM   
					PORT (Clock:IN STD_LOGIC; 
					
							AluResult_ExMem_I	:IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);		---OUTPUT ALU			IN		REGISTER
 							DATA_ExMem_I		:IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);		 ---INPUT DATA MEMORY		IN		REGISTER
------------------------------------------------------------------
							RegWrite_EX			:IN STD_LOGIC; ---CONTROL SIGNAL WB		IN		REG
							MemToReg_EX 		:IN STD_LOGIC; ---CONTROL SIGNAL WB		IN		REG
							MemWrite_Ex			:IN STD_LOGIC; ---CONTROL SIGNAL MEM	IN		REG
							MemRead_Ex			:IN STD_LOGIC; ---CONTROL SIGNAL MEM	IN		REG
------------------------------------------------------------------
							RegRd_ExMem_I 		:IN STD_LOGIC_VECTOR(3 DOWNTO 0);---REGISTER DESTINATION 	IN REGISTER
---------------------------------------------------------------------------------------------------------------											
							AluResult_ExMem_O	:OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0); ---OUTPUT ALU			OUT		REGISTER				
							DATA_ExMem_O 		:OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0); ---INPUT DATA MEMORY	OUT		REGISTER
--------------------------------------------------------------------
							RegWrite_Mem		:OUT STD_LOGIC; ---CONTROL SIGNAL WB		OUT		REG
							MemToReg_Mem		:OUT STD_LOGIC; ---CONTROL SIGNAL WB		OUT		REG
--------------------------------------------------------------------
							MemWrite_ExMem_O	:OUT STD_LOGIC;	 ---CONTROL SIGNAL MEM		OUT		REG
							MemRead_ExMem_O		:OUT STD_LOGIC;	 ---CONTROL SIGNAL MEM		OUT		REG
-----------------------------------------------------------------
							RegRd_Mem			:OUT STD_LOGIC_VECTOR(3 DOWNTO 0)---REGISTER DESTINATION 	OUT REGISTER
											);
END COMPONENT;



COMPONENT REG_MEM_WB   
						PORT   (Clock:IN STD_LOGIC;
								AluResult_MemWb_I	:IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);		---result alu 				 IN register
								DATA_MemWb_I		:IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);		---out put memory 			 IN register
								--------------------------------------------------------------
								RegWrite_Mem		:IN STD_LOGIC;							---CONTROL SIGNAL WB 		IN  REG
								MemToReg_Mem		:IN STD_LOGIC;							---CONTROL SIGNAL WB 		IN  REG
								----------------------------------------------------------
								RegRd_Mem			:IN STD_LOGIC_VECTOR(3	 DOWNTO 0);		---REGISTER DESTINATION 	IN REGISTER
								---------------------------------------------------------

								AluResult_MemWb_O	:OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);	---result alu	 			 OUT register
								DATA_MemWb_O		:OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);	---out put memory			 OUT register
								----------------------------------------------------------------
								RegWrite_MemWb_O	:OUT STD_LOGIC;							---CONTROL SIGNAL WB 		OUT  REG
								MemToReg_Wb			:OUT STD_LOGIC;							---CONTROL SIGNAL WB 		OUT REG
--------------------------------------------------------------------------------------------------------------								
								RegRd_MemWb_O		:OUT STD_LOGIC_VECTOR(3 DOWNTO 0)		---REGISTER DESTINATION 	OUT REGISTER	
								);
END COMPONENT;

COMPONENT W_B   
GENERIC (
		n:integer
		);
  PORT (
		AluResult_MemWb_O	:IN 	STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		DATA_MemWb_O		:IN 	STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		DATA_WB				:OUT	STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		MemToReg_MemWb_O	:IN 	STD_LOGIC--- CONTROL SIGNAL
		
		);
END COMPONENT;


COMPONENT STAGE_MIPS   
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
END COMPONENT;

END PACKAGE;


 
 

	





