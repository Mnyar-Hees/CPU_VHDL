------------------
-- Company: TEIS AB
-- Engineer: Menyar Hees  
-- 
-- Create Date: 2024-10-20
--
-- Design Name: CPU_VHDL_project_DE10
--
-- Target Device: 10M50DAF484C7G
-- Tool Versions: Quartus 18.1 and ModelSim
-- 
-- Testbench File: vhdl_uppgift_8
-- Do File: vhdl_uppgift_8_run_msim_rtl_vhdl.do
-- 
-- Description:
-- A simple computer system containing a CPU, ROM, bus decoder,
-- LED output module, input filtering logic, and 7-segment displays
-- for visualizing CPU state, program counter, instruction register,
-- and current bus address.
-- 
-- In_signals:
-- clock_50   -- 50 MHz system clock
-- Key        -- push-button used when manual clock mode is enabled
-- SW(9)      -- active-low reset switch
--
-- Out_signals:
-- HEX0       -- address displayed on 7-segment
-- HEX1       -- program counter displayed on 7-segment
-- HEX2       -- instruction register displayed on 7-segment
-- HEX3       -- CPU state displayed on 7-segment
-- LEDR       -- LED outputs driven by OUT_LED component
--
-- Validated using ModelSim and verified on the DE10-Lite (10M50) FPGA board.
------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU_VHDL_project_DE10 is 
    port
    (
        clock_50  : in std_logic;                         -- 50 MHz system clock
        Key       : in std_logic_vector(0 downto 0);      -- Button input
        SW        : in std_logic_vector(9 downto 9);      -- Reset switch (active low)
        HEX0      : out std_logic_vector(6 downto 0);     -- Address display
        HEX1      : out std_logic_vector(6 downto 0);     -- Program counter display
        HEX2      : out std_logic_vector(6 downto 0);     -- Instruction register display
        HEX3      : out std_logic_vector(6 downto 0);     -- CPU state display
        LEDR      : out std_logic_vector(3 downto 0)      -- LED output
    );
end entity;

architecture bdf_type of CPU_VHDL_project_DE10 is 

    --------------------------------------------------------------------
    -- Component declarations
    --------------------------------------------------------------------

    component ISSPE is
        port (
            probe : in std_logic_vector(24 downto 0) := (others => 'X')
        );
    end component;

    component addr_bus_decoder
        port(
            bus_en_n     : in std_logic;                  -- Bus enable (active low)
            Addr_bus     : in std_logic_vector(7 downto 0);  
            CS_ROM_n     : out std_logic;                 -- Chip-select for ROM
            CS_OUT_LED_n : out std_logic                  -- Chip-select for LED unit
        );
    end component;

    component status_display_system
        port(
            addr_display_in : in std_logic_vector(7 downto 0);
            CPU_STATE       : in std_logic_vector(1 downto 0);
            IR_display_in   : in std_logic_vector(7 downto 0);
            PC_display_in   : in std_logic_vector(7 downto 0);
            SEG_adr         : out std_logic_vector(6 downto 0);
            SEG_CPU_STATE   : out std_logic_vector(6 downto 0);
            SEG_IR          : out std_logic_vector(6 downto 0);
            SEG_PC          : out std_logic_vector(6 downto 0)
        );
    end component;

    component input_filter
        generic (cnt_high : integer);
        port(
            Clk_50_in        : in std_logic;              -- 50 MHz input clock
            reset_n          : in std_logic;              -- Active-low reset
            IN_KEY_n         : in std_logic;              -- Mechanical push button input
            Use_Manual_Clock : in std_logic;              -- Selects manual clock mode
            Clk_out          : out std_logic              -- Debounced, filtered output clock
        );
    end component;

    component out_led
        port(
            Clk_50      : in std_logic;                   
            reset_n     : in std_logic;                  
            CS_n        : in std_logic;                  -- Chip-select from bus decoder
            WE_n        : in std_logic;                  -- Write-enable from CPU
            data_bus_in : in std_logic_vector(15 downto 0);
            LEDG        : out std_logic_vector(3 downto 0)
        );
    end component;

    component rom_vhdl
        port(
            clk_50   : in std_logic;
            CS_ROM_n : in std_logic;                     -- Chip-select for ROM
            addr     : in std_logic_vector(7 downto 0);  -- ROM address
            data_out : out std_logic_vector(15 downto 0)
        );
    end component;

    component simple_vhdl_cpu
        port(
            Clk_50       : in std_logic;                 -- CPU clock
            reset_n      : in std_logic;                 -- Active-low reset
            data_bus_in  : in std_logic_vector(15 downto 0);
            PC           : out std_logic_vector(7 downto 0);
            WE_n         : out std_logic;                -- Write enable
            RD_n         : out std_logic;                -- Read enable
            bus_en_n     : out std_logic;                -- Bus enable (active low)
            Addr_bus     : out std_logic_vector(7 downto 0);  
            CPU_state    : out std_logic_vector(1 downto 0);
            data_bus_out : out std_logic_vector(15 downto 0);
            IR_out       : out std_logic_vector(7 downto 0)
        );
    end component;

    --------------------------------------------------------------------
    -- Internal signals
    --------------------------------------------------------------------
    signal reset_n_t1, reset_n_t2 : std_logic;           -- Synchronized reset signals

    signal bus_en_n  : std_logic;
    signal Addr_bus  : std_logic_vector(7 downto 0);
    signal CPU_state : std_logic_vector(1 downto 0);
    signal IR_out    : std_logic_vector(7 downto 0);
    signal PC        : std_logic_vector(7 downto 0);

    signal clk_out      : std_logic;                     -- Filtered/manual clock
    signal CS_n         : std_logic;                     -- Chip-select for LEDs
    signal WE_n         : std_logic;                     -- CPU write enable
    signal data_bus_out : std_logic_vector(15 downto 0); 
    signal CS_ROM_n     : std_logic;                     -- Chip-select for ROM
    signal data_bus_in  : std_logic_vector(15 downto 0);

    signal Man_clk_n : std_logic;                        -- Manual clock select
    signal probe     : std_logic_vector(24 downto 0);    -- ISSP probe lines
    signal LEDR_signal : std_logic_vector(3 downto 0);

begin

    --------------------------------------------------------------------
    -- Manual clock mode (always enabled)
    --------------------------------------------------------------------
    Man_clk_n <= '1';    -- When '1', Key(0) is used as the manual clock input

    --------------------------------------------------------------------
    -- Reset synchronizer (2-stage flip-flop)
    --------------------------------------------------------------------
    sync_reset_process : process(clock_50, SW)
    begin
        if SW(9) = '0' then                     -- Asynchronous reset
            reset_n_t1 <= '0';
            reset_n_t2 <= '0';
        elsif rising_edge(clock_50) then        -- Synchronize reset
            reset_n_t1 <= '1';
            reset_n_t2 <= reset_n_t1;
        end if;
    end process;

    --------------------------------------------------------------------
    -- Address bus decoder (decodes ROM/LED chip selects)
    --------------------------------------------------------------------
    b2v_inst2 : addr_bus_decoder
        port map(
            bus_en_n     => bus_en_n,
            Addr_bus     => Addr_bus,
            CS_ROM_n     => CS_ROM_n,
            CS_OUT_LED_n => CS_n
        );

    --------------------------------------------------------------------
    -- 7-segment display system (shows PC, IR, state, address)
    --------------------------------------------------------------------
    b2v_Inst_DISPLAY_SYSTEM : status_display_system
        port map(
            addr_display_in => Addr_bus,
            CPU_STATE       => CPU_state,
            IR_display_in   => IR_out,
            PC_display_in   => PC,
            SEG_adr         => HEX0,
            SEG_CPU_STATE   => HEX3,
            SEG_IR          => HEX2,
            SEG_PC          => HEX1
        );

    --------------------------------------------------------------------
    -- Input filter (debounces Key(0), produces clean clock)
    --------------------------------------------------------------------
    b2v_inst_INPUT_FILTER : input_filter
        generic map(cnt_high => 19)
        port map(
            Clk_50_in        => clock_50,
            reset_n          => reset_n_t2,
            IN_KEY_n         => Key(0),
            Use_Manual_Clock => Man_clk_n,
            Clk_out          => clk_out
        );

    --------------------------------------------------------------------
    -- LED output module
    --------------------------------------------------------------------
    b2v_inst_OUT_LED : out_led
        port map(
            Clk_50      => clk_out,
            reset_n     => reset_n_t2,
            CS_n        => CS_n,
            WE_n        => WE_n,
            data_bus_in => data_bus_out,
            LEDG        => LEDR_signal
        );

    LEDR <= LEDR_signal;

    --------------------------------------------------------------------
    -- ROM module
    --------------------------------------------------------------------
    b2v_inst_ROM_VHDL : rom_vhdl
        port map(
            clk_50   => clk_out,
            CS_ROM_n => CS_ROM_n,
            addr     => Addr_bus,
            data_out => data_bus_in
        );

    --------------------------------------------------------------------
    -- CPU core
    --------------------------------------------------------------------
    b2v_instansiate_VHDL_CPU : simple_vhdl_cpu
        port map(
            Clk_50       => clk_out,
            reset_n      => reset_n_t2,
            data_bus_in  => data_bus_in,
            PC           => PC,
            WE_n         => WE_n,
            RD_n         => open,
            bus_en_n     => bus_en_n,
            Addr_bus     => Addr_bus,
            CPU_state    => CPU_state,
            data_bus_out => data_bus_out,
            IR_out       => IR_out
        );

    --------------------------------------------------------------------
    -- ISSP probe component (SignalTap)
    --------------------------------------------------------------------
    u0 : component ISSPE
        port map (
            probe => probe
        );

    --------------------------------------------------------------------
    -- Probe mapping for internal debugging
    --------------------------------------------------------------------
    probe(0)                <= reset_n_t2;
    probe(8 downto 1)       <= PC;
    probe(10 downto 9)      <= CPU_state;
    probe(18 downto 11)     <= Addr_bus;
    probe(19)               <= clk_out;
    probe(23 downto 20)     <= LEDR_signal;

end architecture;
