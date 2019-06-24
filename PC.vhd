Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

 

Entity PC is
    Generic(n : integer:=4);
    Port (Clock	: IN 	STD_LOGIC:='0';
      
			DETECT_H: IN 	STD_LOGIC:='0';
			Reset	: IN	STD_LOGIC:='0';
---------------------------------------------------------------------------------------
			PC_in   : IN 	STD_LOGIC_VECTOR(n-1 downto 0):=(others=>'0');
			PC_out  : OUT 	STD_LOGIC_VECTOR(n-1 downto 0):=(OTHERS=>'0')
			);
End;

Architecture behave of PC is
SIGNAL pc_s:STD_LOGIC_VECTOR(n-1 downto 0);
    begin
	
	

	
	    pc_s	<= PC_in when (  DETECT_H='0' ) else -----------MEANS THERE IS NOT HAZARD
                   pc_s	 when (  DETECT_H='1' ) else----------MEANS HAZARAD IS EXIST
                             
                           (others=>'Z');   
	
	
      PROCESS (Reset,DETECT_H,Clock)
        BEGIN
  IF (rising_edge(Clock)) THEN
		IF Reset='0' THEN 
            PC_out <= pc_s;
	    end if;
		
		IF RESET='1'  THEN
		PC_out<=(OTHERS=>'0');
	 
		END IF;
end if;		
        end process;


END ARCHITECTURE;

			
    
