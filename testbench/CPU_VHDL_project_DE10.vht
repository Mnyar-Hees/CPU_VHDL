-- Copyright (C) 2023  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "10/27/2024 13:37:07"
                                                            
-- Vhdl Test Bench template for design  :  CPU_VHDL_project_DE10
-- 
-- Simulation tool : ModelSim (VHDL)
-- 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Testbench för CPU_VHDL_project_DE10
ENTITY CPU_VHDL_project_DE10_vhd_tst IS
END CPU_VHDL_project_DE10_vhd_tst;

ARCHITECTURE CPU_VHDL_project_DE10_arch OF CPU_VHDL_project_DE10_vhd_tst IS
   -- Signaler för att simulera de externa anslutningarna
   SIGNAL clock_50         : STD_LOGIC;
   SIGNAL HEX0             : STD_LOGIC_VECTOR(6 DOWNTO 0);
   SIGNAL HEX1             : STD_LOGIC_VECTOR(6 DOWNTO 0);
   SIGNAL HEX2             : STD_LOGIC_VECTOR(6 DOWNTO 0);
   SIGNAL HEX3             : STD_LOGIC_VECTOR(6 DOWNTO 0);
   SIGNAL Key              : STD_LOGIC_VECTOR(0 DOWNTO 0);
   SIGNAL LEDR             : STD_LOGIC_VECTOR(3 DOWNTO 0);
   SIGNAL SW               : STD_LOGIC_VECTOR(9 DOWNTO 9);

   -- Klockperiod för systemets huvudklocka
   CONSTANT sys_clk_period : TIME := 20 ns;

   -- Komponentdeklaration som matchar huvuddesignens entity exakt
   COMPONENT CPU_VHDL_project_DE10
      PORT (
         clock_50 : IN STD_LOGIC;
         Key      : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
         SW       : IN STD_LOGIC_VECTOR(9 DOWNTO 9);
         HEX0     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
         HEX1     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
         HEX2     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
         HEX3     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
         LEDR     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
      );
   END COMPONENT;

BEGIN
   -- Instansiera huvuddesignen för teständamål
   i1 : CPU_VHDL_project_DE10
      PORT MAP(
         clock_50 => clock_50, 
         HEX0     => HEX0,
         HEX1     => HEX1,
         HEX2     => HEX2,    
         HEX3     => HEX3, 
         LEDR     => LEDR,
         Key      => Key,
         SW       => SW    
      );

   -- Process för att generera en klocksignal
   clock : PROCESS
   BEGIN
      clock_50 <= '0';  -- Sätt klockan låg
      WAIT FOR sys_clk_period / 2;
      clock_50 <= '1';  -- Sätt klockan hög
      WAIT FOR sys_clk_period / 2;
   END PROCESS clock;

   -- Simulera knapptryck genom att ändra SW(9)
   SW(9) <= '0', '1' AFTER 10 * sys_clk_period;

END CPU_VHDL_project_DE10_arch;
