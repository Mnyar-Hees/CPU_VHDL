-------------------------------------------------------------------------------
-- Engineer: Mnyar Hees
--
-- Description:
--  This module implements a clock control and debouncing system for a CPU.
--  The clock source can be selected between:
--     1. The normal 50 MHz system clock
--     2. A manual push-button clock (IN_KEY_n)
--
--  When manual clock mode is enabled (Use_Manual_Clock = '1'),
--  the push button is debounced to avoid false triggering due to mechanical
--  bounce. The debouncing time is configured using the generic parameter
--  'cnt_high'. For example:
--       cnt_high = 20 → 2^20 cycles = 1,048,576 cycles
--       At 50 MHz this corresponds to ~20 ms.
--
--  Clk_out is the selected and filtered clock signal used by the CPU.
--
-- Debounce filter operation:
--  * IN_KEY_n is synchronized with 3 flip-flops to avoid metastability.
--  * A counter increments on each 50 MHz clock pulse.
--  * If IN_KEY_n remains stable long enough (counter MSB = '1'),
--    the filtered result is output on clk_status.
--  * If the button changes state, the counter resets.
--
-- Inputs:
--   Clk_50_in         – 50 MHz system clock
--   reset_n           – Active-low reset
--   IN_KEY_n          – Manual push-button clock input (active low)
--   Use_Manual_Clock  – Selects between manual clock and system clock
--
-- Output:
--   Clk_out           – The output clock used by the rest of the system
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity INPUT_FILTER is
   generic(
      cnt_high : integer := 20   -- Number of bits used in debounce counter
                                 -- (defines debounce duration)
   );

   port(
      Clk_50_in        : in  std_logic;     -- Must always be connected to 50 MHz clock
      reset_n          : in  std_logic;     -- Active-low reset
      IN_KEY_n         : in  std_logic;     -- Manual clock button (e.g., KEY0)
      Use_Manual_Clock : in  std_logic;     -- When '1': output follows filtered IN_KEY_n
      Clk_out          : out std_logic      -- Selected clock output
   );
end entity;
		
architecture rtl of INPUT_FILTER is

   -- Synchronization flip-flops for push button
   signal in_key_n_s1, in_key_n_s2, in_key_n_s3 : std_logic;

   -- Debounce counter
   signal btn_counter : std_logic_vector(cnt_high-1 downto 0);

   -- Filtered button state
   signal clk_status : std_logic;

   -- Startup flag (used to avoid invalid initial transitions)
   signal start_up : std_logic;

begin

   --------------------------------------------------------------------
   -- Clock Selection Logic
   -- If manual mode is disabled → output system clock
   -- If enabled → output debounced push-button clock
   --------------------------------------------------------------------
   Clk_out <= Clk_50_in when (Use_Manual_Clock = '0' and start_up = '0')
              else clk_status;

   --------------------------------------------------------------------
   -- Debounce processing
   --------------------------------------------------------------------
   process(Clk_50_in, reset_n)
   begin
      if reset_n = '0' then
         -- Reset all internal states
         btn_counter     <= (others => '0');
         in_key_n_s1     <= '0';
         in_key_n_s2     <= '0';
         in_key_n_s3     <= '0';
         clk_status      <= '0';
         start_up        <= '1';

      elsif rising_edge(Clk_50_in) then
         start_up <= '0';

         -- Synchronize button input to avoid metastability
         in_key_n_s1 <= IN_KEY_n;
         in_key_n_s2 <= in_key_n_s1;
         in_key_n_s3 <= in_key_n_s2;

         -- Debounce counter increments every clock cycle
         btn_counter <= btn_counter + 1;

         -- If button changes state → reset counter
         if in_key_n_s2 /= in_key_n_s3 then
            btn_counter <= (others => '0');

         -- If MSB of counter is '1', button considered stable
         elsif btn_counter(btn_counter'high) = '1' then
            clk_status <= in_key_n_s2;
         end if;

      end if;
   end process;

end architecture;
