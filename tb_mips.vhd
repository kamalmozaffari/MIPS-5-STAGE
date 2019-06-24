Library ieee;
Use ieee.std_logic_1164.all;
USE work.PACKAGE_MIPS.all;
USE ieee.numeric_std.all;


entity tb_mips is
end tb_mips;

architecture behaviour of tb_mips is
signal clock:std_logic:='0';
signal rst:std_logic:='0';
signal GND:std_logic:='0';
constant clk_period : time := 10 ns;
signal GEN_ADDRESS_INSTRUCTION,INPUT_INSTRUCTION:std_logic_vector(n-1 downto 0):=(others=>'0');
signal  ADDRESS_MEMORY ,COMING_DATA_MEMORY ,GOING_DATA_MEMORY:std_logic_vector(n-1 downto 0):=(others=>'0');
signal Mi,Md,Msw:word_vector(50 downto 0):=(OTHERS=>"00000000000000000000000000000000");
SIGNAL ADDERSS_IN :STD_LOGIC_VECTOR(n-1 DOWNTO 0 ):=(OTHERS=>'0');

begin
   mips5: STAGE_MIPS port map(
								CLOCK,
							RST,
							-----------------
						GEN_ADDRESS_INSTRUCTION,
							INPUT_INSTRUCTION,
							-------------------
							ADDRESS_MEMORY,
							COMING_DATA_MEMORY,
							------------------
							GOING_DATA_MEMORY
							);

Mi(0)<="10000000000100000000000000000000";
Mi(1)<="10000000001000000000000000000001";
Mi(2)<="00010001001000110000000000000000";
-----------------------------------------------------------------------------
Md(0)<="00000000000000000000000000001010";
Md(1)<="00000000000000000000000000001011";
ADDERSS_IN<=GND&GND&GEN_ADDRESS_INSTRUCTION(n-1 DOWNTO 2);
    process -- controle de clock
begin
CLOCK <= not CLOCK;
wait for 10 ns;
end process;
g:process(Clock)
BEGIN
--------read
	if( Clock'event and Clock = '0') then
INPUT_INSTRUCTION<=Mi(TO_INTEGER(UNsigned(ADDERSS_IN)) );
COMING_DATA_MEMORY<=Md(TO_INTEGER(UNsigned(ADDRESS_MEMORY)));
	 END IF;
	 ----------------write
	if( Clock'event and Clock = '1' ) then 
Msw(TO_INTEGER(UNsigned(ADDRESS_MEMORY)))<=GOING_DATA_MEMORY;
    end if;
end process;
end behaviour;

