Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE WORK.PACKAGE_MIPS.ALL;

 

ENTITY REG_IF_ID IS 
PORT  (Clock:IN STD_LOGIC:='0';
											IfId_Disable:IN STD_LOGIC:='0';		---COMING HAZARD DETECTION
											FLUSH		:IN STD_LOGIC:='0';				---COMING CONTROL UNIT
											------------------------------------------------
											INSTRUCTION_IfId_I:IN STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');	--- COMING IF
											ADD4_Result_IfId_I:IN STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');	--- COMING IF

											------------------------------------------------
											INSTRUCTION_IfId_O:OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0');	--- GOING ID 
											ADD4_Result_IfId_O:OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0):=(others=>'0')	--- GIING ID
											
											);
END ENTITY;

ARCHITECTURE ST of REG_IF_ID IS 
signal ADD4_Result_IfId_s,INSTRUCTION_IfId_s:std_logic_vector(n-1 DOWNTO 0):=(others=>'0');

BEGIN
              
    INSTRUCTION_IfId_s	<= INSTRUCTION_IfId_I when (IfId_Disable='0' and FLUSH='0'  ) else
                           INSTRUCTION_IfId_s when (IfId_Disable='1' and FLUSH='0') else
                           (others=>'0') when (IfId_Disable='0' and FLUSH='1') else 
                            ( Others=>'Z' ) ;
    ADD4_Result_IfId_s	<= ADD4_Result_IfId_I when  (IfId_Disable='0' and  FLUSH='0' ) else
                          ADD4_Result_IfId_s  when (IfId_Disable='1' and  FLUSH='0' )  else
                           ( Others=>'0' ) when  (IfId_Disable='0' and  FLUSH='1' )else 
                           (others=>'Z');        

						   
                          
         process(Clock)
        begin
          if( Clock'event and Clock = '1') then
INSTRUCTION_IfId_O<=INSTRUCTION_IfId_s;
ADD4_Result_IfId_O<=ADD4_Result_IfId_s;

          end if;
            
       end process;

END ARCHITECTURE;

			
    
