----------------------------------------------------------------------------------
-- Company: SGPR.TECH
-- Engineer: K.Zietara
-- 
-- Create Date:
-- Design Name: Georadar
-- Module Name: sync_block_vector
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

entity sync_block_vector is
    generic (
        C_WIDTH : integer := 1;
        INITIALISE : bit_vector(5 downto 0) := "000000"
    );
    port ( 
        clk         : in  std_logic; -- clock to be sync'ed to
        data_in     : in  std_logic_vector(C_WIDTH - 1 downto 0); -- Data to be 'synced'
        data_out    : out std_logic_vector(C_WIDTH - 1 downto 0) -- synced data    
    );
end sync_block_vector;

architecture structural of sync_block_vector is

    component sync_block is
        generic (
            INITIALISE : bit_vector(5 downto 0) := "000000"
        );
        port (
            clk         : in  std_logic;          -- clock to be sync'ed to
            data_in     : in  std_logic;          -- Data to be 'synced'
            data_out    : out std_logic           -- synced data
        );
    end component;

begin

SYNC_BLOCK_VECTOR : for i in 0 to C_WIDTH - 1 generate

    sync_block_i : sync_block
    generic map (
        INITIALISE => INITIALISE
    )
    port map (
        clk         => clk,
        data_in     => data_in(i),
        data_out    => data_out(i)
    );

end generate;

end structural;
