Library ieee;
Use ieee.std_logic_1164.all;
USE work.PACKAGE_MIPS.all;
USE ieee.numeric_std.all;

 

ENTITY Control_Unit IS 

  PORT (
		Cu_in		:IN	 STD_LOGIC_VECTOR(3 DOWNTO 0):=(OTHERS=>'0');
		AluOp		:OUT STD_LOGIC_VECTOR(1 DOWNTO 0):=(others=>'0');
		AluSrc		:OUT STD_LOGIC:='0';
		RegDst		:OUT STD_LOGIC:='0';
		RegWrite 	:OUT STD_LOGIC:='0';
		MemRead		:OUT STD_LOGIC:='0';
		MemWrite	:OUT STD_LOGIC:='0';
		MemToReg	:OUT STD_LOGIC:='0';
		Jmp			:OUT STD_LOGIC:='0';
		Brq			:OUT STD_LOGIC:='0'
		);
END ENTITY;

ARCHITECTURE ST of Control_Unit IS 
SIGNAL C				:STD_LOGIC_VECTOR(6 DOWNTO 0 );
BEGIN
    


RegDst		<=Cu_in(3);
AluSrc		<=C(6);
RegWrite	<=C(5);
MemRead		<=C(4);
MemWrite	<=C(3);
MemToReg	<=C(2);
Jmp			<=C(1);
Brq			<=C(0);
---------------mux signal
C	<=	"0100000" WHEN Cu_in="0001" ELSE--1 
		"0100000" WHEN Cu_in="0010" ELSE--2
		"0100000" WHEN Cu_in="0011" ELSE--3
		"0100000" WHEN Cu_in="0100" ELSE--4																					
		"0000010" WHEN Cu_in="0101" ELSE--5
		"1110100" WHEN Cu_in="1000" ELSE--8
		"1100000" WHEN Cu_in="1001" ELSE--9
		"1100000" WHEN Cu_in="1010" ELSE--10
		"0100001" WHEN Cu_in="1011" ELSE--11																																																	
		"1001000" WHEN Cu_in="1100" ELSE--12
										(others => '0');	
										
--------------Alu signal
		AluOp	<=	"00" WHEN Cu_in="0001" ELSE--1 
		"01" WHEN Cu_in="0010" ELSE--2
		"10" WHEN Cu_in="0011" ELSE--3
		"11" WHEN Cu_in="0100" ELSE--4																					
		"00" WHEN Cu_in="0101" ELSE--5
		"00" WHEN Cu_in="1000" ELSE--8
		"01" WHEN Cu_in="1001" ELSE--9
		"10" WHEN Cu_in="1010" ELSE--10
		"11" WHEN Cu_in="1011" ELSE--11																																																	
		"00" WHEN Cu_in="1100" ELSE--12
										(others => '0');																						

   

		   

END ARCHITECTURE;

			
    
