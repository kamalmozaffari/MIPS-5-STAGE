Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE WORK.PACKAGE_MIPS.ALL;

 ENTITY HazardDetection_Unit IS 
GENERIC 
(
REG : INTEGER:=4
);
  PORT (
  MemRead_IdEx	:IN STD_LOGIC:='0';
  RegRt_IdEx	:IN STD_LOGIC_VECTOR(REG-1 DOWNTO 0):=(others=>'0');
  RegRs_IfId	:IN STD_LOGIC_VECTOR(REG-1 DOWNTO 0):=(others=>'0');
  RegRt_IfId	:IN STD_LOGIC_VECTOR(REG-1 DOWNTO 0):=(others=>'0');
	DETECT_H	:OUT STD_LOGIC:='0';
	IfId_Disable:OUT STD_LOGIC:='0';
	NOP			:OUT STD_LOGIC:='0'
		);
END ENTITY;

ARCHITECTURE ST of HazardDetection_Unit IS 
SIGNAL SS :STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
						
SS<= "111" when 
                       (MemRead_IdEx='1'
                    and 
					((RegRt_IdEx = RegRs_IfId)
					or 
					(RegRt_IdEx=RegRt_IfId))) ELSE
					(OTHERS=>'0');
     DETECT_H		<=SS(2);
	 IfId_Disable	<=SS(1);
	 NOP			<=SS(0);

END ARCHITECTURE;

			
    
