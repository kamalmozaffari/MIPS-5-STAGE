Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE WORK.PACKAGE_MIPS.ALL;

 

ENTITY Comprator IS 
GENERIC (
		n:integer:=32
		);
  PORT (
		Input1	:IN 	STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(OTHERS=>'0');
		Input2	:IN 	STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(OTHERS=>'0');
		Output	:OUT	STD_LOGIC
		
		);
END ENTITY;

ARCHITECTURE ST of Comprator IS 
SIGNAL D:STD_LOGIC_VECTOR(n-2 DOWNTO 0);
SIGNAL R_XOR_S:STD_LOGIC_VECTOR(n-1 DOWNTO 0);
BEGIN

R_XOR_S		<=Input1 XNOR Input2;
D(0)<= (R_XOR_S(0) and R_XOR_S (1));

G0:FOR i IN 1 TO n-2 GENERATE
         D(i)<=(D(i-1) OR R_XOR_S (i+1));
   END GENERATE ;
Output<=D(n-2);


  

END ARCHITECTURE;

			
    