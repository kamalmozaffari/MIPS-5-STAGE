Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE WORK.PACKAGE_MIPS.ALL;
ENTITY REGISTER_FILES IS 
GENERIC (
		n:integer:=32;
		REG:integer:=4;
		REG_COUNT:integer:=4
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
END ENTITY;

ARCHITECTURE BEHAVIRAL of REGISTER_FILES IS 
SIGNAL  REGISTER_F:Word_VECTOR(REG_COUNT-1 DOWNTO 0):=(OTHERS=>"00000000000000000000000000000000"); 

SIGNAL A3,A2,A1 :STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(OTHERS=>'0');
BEGIN

A3<= Data_in 	WHEN RegWrite='1'  ;


				A1<=REGISTER_F(to_integer(UNsigned(rs_Add)));
				A2<=REGISTER_F(to_integer(UNsigned(rt_Add)));


g:process(Clock)
BEGIN
--------read
	if( Clock'event and Clock = '0') then
	
	  OutPut_Reg_rs<=A1;
	 OutPut_Reg_rt<=A2;
	 END IF;
	 ----------------write
	if( Clock'event and Clock = '1' and rd_Add/="0000") then 
	  
    REGISTER_F(to_integer(UNsigned(rd_Add)))<=A3;
    end if;
		
	   
END PROCESS g;
		   

END  ARCHITECTURE;

			
    
