Library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity SJU_SEG_DISPLAYER_CPU_STATE is
    port( 
        STATE : in  std_logic_vector(1 downto 0);  -- CPU state (2-bit input)
        HEX   : out std_logic_vector(6 downto 0)   -- 7-segment display output
    );
end SJU_SEG_DISPLAYER_CPU_STATE;
		
architecture rtl of SJU_SEG_DISPLAYER_CPU_STATE is

    --------------------------------------------------------------------
    -- 7-segment display encodings
    -- A '0' lights a segment, a '1' turns it off.
    --
    -- Segment positions on the DE2-115 / DE10 board:
    --
    --    -0-
    --  |     |
    --  5     1
    --    -6-
    --  |     |
    --  4     2
    --    -3-
    --
    -- The patterns below define which segments turn on for each CPU state:
    -- FETCH, DECODE, EXECUTE, STORE, and ERROR.
    --------------------------------------------------------------------
    constant FETCH   : std_logic_vector(6 downto 0) := "0001110";
    constant DECODE  : std_logic_vector(6 downto 0) := "1000000";
    constant EXECUTE : std_logic_vector(6 downto 0) := "0000110";
    constant STORE   : std_logic_vector(6 downto 0) := "0010010";
    constant ERROR   : std_logic_vector(6 downto 0) := "0000000"; -- All segments lit

begin

    --------------------------------------------------------------------
    -- Select 7-segment pattern based on the CPU STATE
    --
    -- STATE = "00" → FETCH
    -- STATE = "01" → DECODE
    -- STATE = "10" → EXECUTE
    -- STATE = "11" → STORE
    -- others      → ERROR
    --------------------------------------------------------------------
    with STATE select
        HEX <= FETCH    when "00",
               DECODE   when "01",
               EXECUTE  when "10",
               STORE    when "11",
               ERROR    when others;

end rtl;
