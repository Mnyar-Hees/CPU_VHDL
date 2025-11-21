library ieee;
use ieee.std_logic_1164.all;

entity OUT_LED is  -- out to leds
	port
	(
	Clk_50, reset_n 	: in std_logic;
	Cs_n, WE_n			: in std_logic;
	data_bus_in 		: in std_logic_vector(15 downto 0);
	LEDG					: out std_logic_vector(3 downto 0));
End entity;


architecture rtl of OUT_LED is

Begin

process(reset_n, clk_50)
begin
if reset_n = '0' then
   LEDG <= "1111";
	
elsif(rising_edge(clk_50)) then

if CS_n = '0' and WE_n = '0' then
  LEDG <= data_bus_in(3 downto 0);
end if;

end if;
end process;

end rtl;