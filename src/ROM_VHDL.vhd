library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM_VHDL is

	port 
	(
		clk_50, CS_ROM_n			: in std_logic;
		addr						: in std_logic_vector(7 downto 0); 
		data_out					: out std_logic_vector(15 downto 0)
	);

end entity;

architecture rtl of ROM_VHDL is

	-- Build a 2-D array type for the RoM
	subtype word_t is std_logic_vector(15 downto 0);
	type memory_t is array(0 to 15) of word_t;
 
	signal rom : memory_t := memory_t'(
	X"0000", -- Adress 0; NOP
	X"100A", -- Adress 1; LOAD_R0 #A
	X"2010", -- Adress 2; STORE_R0 #10
	X"1001", -- Adress 3; LOAD_R0 #1
	X"2010", -- Adress 4; STORE_R0 #10
	X"3001", -- Adress 5; JMP #1
	X"0000",
	X"0000",
	X"0000", -- Adress 8
	X"0000",
	X"0000",
	X"0000",
	X"0000", -- Adress 12
	X"0000",
	X"0000",
	X"0000"); -- Adress 15
	

begin

	process(clk_50)
	begin
	if(rising_edge(clk_50)) then
		data_out <= rom(to_integer(unsigned(addr(3 downto 0))));
	end if;
	end process;

end rtl;
