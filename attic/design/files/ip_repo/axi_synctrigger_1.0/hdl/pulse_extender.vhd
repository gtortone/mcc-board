----------------------------------------------------------------------------------
-- Company: SGPR.TECH
-- Engineer: K.Zietara
-- 
-- Create Date:
-- Design Name: axi_ad9915
-- Module Name: pulse_extender
-- Project Name: Georadar
-- Target Devices: Zynq Ultrascale+
-- Tool Versions: Vivado 2018.3
-- Description:
-- Dependencies:
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pulse_extender is
	generic(
		C_PULSE_WIDTH : integer := 1
	);
    port(
        I : in STD_LOGIC;
        O : out STD_LOGIC;
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC
    );
end pulse_extender;

architecture arch_imp of pulse_extender is

signal pulse : std_logic;

begin

process (CLK)
variable cnt : integer range 0 to C_PULSE_WIDTH;
begin
	if CLK='1' and CLK'event then
		if RESET = '1' then
			cnt := 0;
			pulse <= '0';	
		elsif I='1' then
			cnt := C_PULSE_WIDTH-1;
			pulse <= '1';
		elsif cnt /= 0 then
			cnt := cnt - 1;
		else
			pulse <= '0';
		end if;
	end if;
end process;

O <= pulse;

end arch_imp;
