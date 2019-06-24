Library ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE WORK.PACKAGE_MIPS.ALL;

 

ENTITY ForwardingUnit IS 

  PORT (
  RegWrite_MemWb  :IN    STD_LOGIC:='0';
  RegWrite_ExMem  :IN    STD_LOGIC:='0';
  RegRd_MemWb     :IN    STD_LOGIC_VECTOR(REG-1 DOWNTO 0):=(others=>'0');
  RegRd_ExMem     :IN    STD_LOGIC_VECTOR(REG-1 DOWNTO 0):=(others=>'0');
  RegRs_IdEx      :IN    STD_LOGIC_VECTOR(REG-1 DOWNTO 0):=(others=>'0');
  RegRt_IdEx      :IN    STD_LOGIC_VECTOR(REG-1 DOWNTO 0):=(others=>'0');
  ForwardA        :OUT   STD_LOGIC_VECTOR(1     DOWNTO 0):=(others=>'0');
  ForwardB        :OUT   STD_LOGIC_VECTOR(1     DOWNTO 0):=(others=>'0')
		);
END ENTITY;

ARCHITECTURE ST of ForwardingUnit IS 

BEGIN
						
ForwardA <= "10" when 

                      (RegWrite_MemWb='1' 
                      and (RegRd_MemWb/="0000")
                  AND NOT(RegWrite_ExMem='1' and (RegRd_ExMem/="0000")
						and (RegRd_ExMem/=RegRs_IdEx))
				 and (RegRd_MemWb = RegRs_IdEx))
				 

             	                                    ELSE
            "01" WHEN 
                       (RegWrite_ExMem='1'
                   and (RegRd_ExMem/="0000")
             	     and (RegRd_ExMem = RegRs_IdEx))
                 	   ELSE
                  (others => '0');
                  
                  
                  
             	     
             	     
ForwardB <= "10" WHEN
                      (RegWrite_MemWb='1' 
                      and (RegRd_MemWb/="0000")
                AND NOT(RegWrite_ExMem='1' and (RegRd_ExMem/="0000")
						and (RegRd_ExMem/=RegRt_IdEx))
                and (RegRd_MemWb = RegRt_IdEx))   



                                                ELSE
            "01" WHEN 
                      	(RegWrite_ExMem='1' 
              	    and (RegRd_ExMem/="0000")
                   and (RegRd_ExMem = RegRt_IdEx))
         
              ELSE
                  (others => '0');

END ARCHITECTURE;

			
    
