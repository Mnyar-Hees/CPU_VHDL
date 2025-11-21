--------------------------------------------------------------------
-- Engineer: Mnyar Hees
--
-- Create Date:   2014-10-21
-- Tool Versions: Quartus v14 and ModelSim
-- Testbench:     CPU_VHDL_projekt.vht
-- Do file:       CPU_VHDL_projekt_run_msim_rtl_vhdl.do
--
-- Description:
-- 7-segment display controller.
-- Converts a 4-bit binary value (0–15) into the corresponding
-- 7-segment display pattern (HEX output).
--
-- Input:
-- TAL  – 8-bit input, but only TAL(3 downto 0) is used
--
-- Output:
-- HEX – 7-segment display output (active-low)
--
-- Segment layout (DE2-115 / DE10 boards):
--
--     -0-
--   |     |
--   5     1
--     -6-
--   |     |
--   4     2
--     -3-
--
-- A '0' turns ON the segment, a '1' turns it OFF.
--------------------------------------------------------------------

Library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity SJU_SEG_DISPLAYER is
    port(
        TAL : in  std_logic_vector(7 downto 0);  -- Input value (only low 4 bits used)
        HEX : out std_logic_vector(6 downto 0)   -- 7-segment display output (active low)
    );
end SJU_SEG_DISPLAYER;
		
architecture SJU_SEG_DISPLAYER_arch of SJU_SEG_DISPLAYER is

    --------------------------------------------------------------------
    -- 7-segment encodings for digits 0–F
    -- Active-low patterns (0 = segment on, 1 = segment off)
    --------------------------------------------------------------------
    constant VISANOLL  : std_logic_vector(6 downto 0) := "1000000"; -- 0
    constant VISAETT   : std_logic_vector(6 downto 0) := "1111001"; -- 1
    constant VISATVA   : std_logic_vector(6 downto 0) := "0100100"; -- 2
    constant VISATRE   : std_logic_vector(6 downto 0) := "0110000"; -- 3
    constant VISAFYRA  : std_logic_vector(6 downto 0) := "0011001"; -- 4
    constant VISAFEM   : std_logic_vector(6 downto 0) := "0010010"; -- 5
    constant VISASEX   : std_logic_vector(6 downto 0) := "0000010"; -- 6
    constant VISASJU   : std_logic_vector(6 downto 0) := "1111000"; -- 7
    constant VISAATTA  : std_logic_vector(6 downto 0) := "0000000"; -- 8
    constant VISANIO   : std_logic_vector(6 downto 0) := "0011000"; -- 9
    constant VISAA     : std_logic_vector(6 downto 0) := "0001000"; -- A
    constant VISAB     : std_logic_vector(6 downto 0) := "0000011"; -- b
    constant VISAC     : std_logic_vector(6 downto 0) := "1000110"; -- C
    constant VISAD     : std_logic_vector(6 downto 0) := "0100001"; -- d
    constant VISAE     : std_logic_vector(6 downto 0) := "0000110"; -- E
    constant VISAF     : std_logic_vector(6 downto 0) := "0000111"; -- F

begin

    --------------------------------------------------------------------
    -- Select the correct 7-segment pattern based on TAL(3..0)
    --------------------------------------------------------------------
    with TAL(3 downto 0) select
        HEX <= VISANOLL when "0000",
               VISAETT  when "0001",
               VISATVA  when "0010",
               VISATRE  when "0011",
               VISAFYRA when "0100",
               VISAFEM  when "0101",
               VISASEX  when "0110",
               VISASJU  when "0111",
               VISAATTA when "1000",
               VISANIO  when "1001",
               VISAA    when "1010",
               VISAB    when "1011",
               VISAC    when "1100",
               VISAD    when "1101",
               VISAE    when "1110",
               VISAF    when others;

end SJU_SEG_DISPLAYER_arch;
