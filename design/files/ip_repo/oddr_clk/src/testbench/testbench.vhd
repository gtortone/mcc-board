----------------------------------------------------------------------------------
-- Company: Jagiellonian University
-- Engineer: Krzysztof Zietara
-- 
-- Create Date: 
-- Design Name: axi_gtx_wrapper
-- Module Name: testbench - behavioral
-- Project Name: DigiCam 
-- Target Devices: Virtex7
-- Tool Versions: Vivado 15.4
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

--LIBRARY xil_defaultlib;
--USE xil_defaultlib.testbench_util.ALL;

entity testbench is

end testbench;

architecture Behavioral of testbench is

    --------------------------------------------------------------------------------------------
    -- constant declarations
    --------------------------------------------------------------------------------------------  
    constant C_PERIOD_CLK : time := 8ns; --125MHz
    
    --------------------------------------------------------------------------------------------
    -- DUT component declaration
    --------------------------------------------------------------------------------------------       
 component oddr_clk is
    Port 
    (
        CLK_IN : in std_logic;
        DATA_OUT_P : out std_logic;
        DATA_OUT_N : out std_logic
    );
end component;
    
    --------------------------------------------------------------------------------------------
    -- signal definitions
    --------------------------------------------------------------------------------------------
    signal data_out_p: std_logic;
    signal data_out_n: std_logic;
    -- clocks
    signal clk : std_logic;
    
begin
    
dut: oddr_clk
    Port map
    (
        CLK_IN => clk,
        DATA_OUT_P => data_out_p,
        DATA_OUT_N => data_out_n
    );   
    
    
    --------------------------------------------------------------------------------------------
    -- clock generation processes
    -------------------------------------------------------------------------------------------- 
    clk_axi_process : process
    begin
        clk <= '1';
        wait for C_PERIOD_CLK/2;
        clk <= '0';
        wait for C_PERIOD_CLK/2;
    end process;

end Behavioral;
