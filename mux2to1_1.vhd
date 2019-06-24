library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity mux2to1_1 is

	port (
		din0 : in std_logic;
		din1 : in std_logic;
		sel  : in std_logic;
		dout : out std_logic

	);
end mux2to1_1;

architecture Behavioral of mux2to1_1 is

begin

	muxit: process (din0,din1,sel)
	begin 
	case sel is
		when '0' =>
			dout <= din0;
		when '1' =>
			dout <= din1;
                when others => 
		dout <= ('0');

	end case;

	end process;


end Behavioral;

