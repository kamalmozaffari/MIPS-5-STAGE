library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY FULL_ADDER IS 
 PORT (
        Xin,Yin,Cin:IN STD_LOGIC:='0';
	Sout,Cout  :out STD_LOGIC:='0'
       );
END FULL_ADDER;

ARCHITECTURE STRUCTURAL OF FULL_ADDER IS 
 BEGIN 
    Sout<=(Xin XOR Yin XOR Cin);
    Cout<= (Xin AND Yin )OR (Xin AND Cin )OR (Yin AND Cin);
END STRUCTURAL;
