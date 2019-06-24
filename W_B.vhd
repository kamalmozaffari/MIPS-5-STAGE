Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE WORK.PACKAGE_MIPS.ALL;

 

ENTITY W_B IS 
GENERIC (
		n:integer
		);
  PORT (
		AluResult_MemWb_O	:IN 	STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');
		DATA_MemWb_O		:IN 	STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');
		DATA_WB				:OUT	STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');
		MemToReg_MemWb_O	:IN 	STD_LOGIC--- CONTROL SIGNAL
		
		);
END ENTITY;

ARCHITECTURE ST of W_B IS 

BEGIN
MUX:MUX2TO1 GENERIC MAP (n) PORT MAP (AluResult_MemWb_O,DATA_MemWb_O,MemToReg_MemWb_O,DATA_WB);

END ARCHITECTURE;

			
    