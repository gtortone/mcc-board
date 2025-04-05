----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.01.2016 18:25:02
-- Design Name: 
-- Module Name: oddr_clk - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity oddr_clk is
    Port 
    (
        CLK_IN : in std_logic;
        DATA_OUT_P : out std_logic;
        DATA_OUT_N : out std_logic
    );
end oddr_clk;

architecture Behavioral of oddr_clk is

signal ddr : std_logic;

begin

  ODDRE1_i : ODDRE1
   generic map (
      IS_C_INVERTED => '0',       -- Optional inversion for C
      IS_D1_INVERTED => '0',      -- Unsupported, do not use
      IS_D2_INVERTED => '0',      -- Unsupported, do not use
      SIM_DEVICE => "ULTRASCALE_PLUS", -- Set the device version (ULTRASCALE, ULTRASCALE_PLUS, ULTRASCALE_PLUS_ES1,
                                  -- ULTRASCALE_PLUS_ES2, VERSAL, VERSAL_ES1, VERSAL_ES2)
      SRVAL => '0'                -- Initializes the ODDRE1 Flip-Flops to the specified value ('0', '1')
   )
   port map (
      Q => ddr,  -- 1-bit output: Data output to IOB
      C => CLK_IN,   -- 1-bit input: High-speed clock input
      D1 => '1', -- 1-bit input: Parallel data input 1
      D2 => '0', -- 1-bit input: Parallel data input 2
      SR => '0'  -- 1-bit input: Active High Async Reset
   ); 

  OBUFDS_inst : OBUFDS
  port map (
     O => DATA_OUT_P,     -- Diff_p output (connect directly to top-level port)
     OB => DATA_OUT_N,   -- Diff_n output (connect directly to top-level port)
     I => ddr      -- Buffer input 
  );    

end Behavioral;
