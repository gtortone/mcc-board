----------------------------------------------------------------------------------
-- Company: SGPR.TECH
-- Engineer: K.Zietara
-- 
-- Create Date:
-- Design Name: axi_ad9915
-- Module Name: pulse_generator
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pulse_generator is
	generic(
		C_WIDTH : integer := 32;
		C_PERIOD : integer := 250000000;
		C_PERIOD_VAR : boolean := FALSE;
		C_POLARITY : std_logic := '1'
	);
	port(
		PULSE : out STD_LOGIC;
		PERIOD : in STD_LOGIC_VECTOR(C_WIDTH-1 downto 0);
		CLR : in STD_LOGIC;
		ENB : in STD_LOGIC;
	    RESET : in STD_LOGIC;
		CLK : in STD_LOGIC
	);
end pulse_generator;

architecture arch_imp of pulse_generator is

signal clr_mem: STD_LOGIC;

begin

    process (CLK)
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                clr_mem <= '0';
            else
                clr_mem <= CLR;
            end if;
        end if;
    end process;
    
FIXED_PERIOD: if C_PERIOD_VAR = FALSE generate

    process (CLK)
    variable cnt : integer range 0 to C_PERIOD;
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                cnt := 0;
                PULSE <= not C_POLARITY;
            else
                if CLR = '1' and clr_mem = '0' then
                    cnt := 0;
                    PULSE <= not C_POLARITY;
                elsif ENB = '1' then
                    if cnt = (C_PERIOD - 1) then        
                        cnt := 0;
                        PULSE <= C_POLARITY;
                    else
                        cnt := cnt + 1;
                        PULSE <= not C_POLARITY;
                    end if;
                else
                    cnt := 0;
                    PULSE <= not C_POLARITY;                
                end if;
            end if;
        end if;
    end process;
    
end generate FIXED_PERIOD;

VARIABLE_PERIOD: if C_PERIOD_VAR = TRUE generate
    
    process (CLK)
    variable cnt : std_logic_vector(C_WIDTH-1 downto 0);
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                cnt := (others => '0');
                PULSE <= not C_POLARITY;
            else
                if CLR = '1' and clr_mem = '0' then
                    cnt := (others => '0');
                    PULSE <= not C_POLARITY;
                elsif ENB = '1' then
                    if cnt >= PERIOD then        
                        cnt := (others => '0');
                        PULSE <= C_POLARITY;
                    else
                        cnt := cnt + 1;
                        PULSE <= not C_POLARITY;
                    end if;
                else
                    cnt := (others => '0');
                    PULSE <= not C_POLARITY;               
                end if;
            end if;
        end if;
    end process;     

end generate VARIABLE_PERIOD;

end arch_imp;
