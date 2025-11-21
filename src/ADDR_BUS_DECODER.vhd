library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ADDR_BUS_DECODER is  
	port
	(	
	CS_ROM_n				: out std_logic;
	CS_OUT_LED_n		: out std_logic;
	bus_en_n 			: in std_logic;
	Addr_bus				: in std_logic_vector(7 downto 0) 
	);
End entity ADDR_BUS_DECODER;

architecture rtl of ADDR_BUS_DECODER is

Begin

process(Addr_bus, bus_en_n)
begin
	if bus_en_n = '0' then
		if unsigned(addr_bus) >= 0 AND unsigned(addr_bus) < 16 then  -- 0-15; ROM adress
			CS_ROM_n <= '0';
		else
			CS_ROM_n <= '1';
		end if;

		if addr_bus = "00010000" then  -- 16 ; OUT_LED adress
			CS_OUT_LED_n <= '0';
		else
			CS_OUT_LED_n <= '1';
		end if;
	else
		CS_ROM_n <= '1';
		CS_OUT_LED_n <= '1';
	end if;

end process;
 
 end rtl;