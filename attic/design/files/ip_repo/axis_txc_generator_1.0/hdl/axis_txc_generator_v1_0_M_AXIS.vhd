----------------------------------------------------------------------------------
-- Company: Jagiellonian University
-- Engineer: Krzysztof Zietara
-- 
-- Create Date: 
-- Design Name: axis_txc_generator 
-- Module Name: axis_txc_generator_v1_0_M_AXIS - implementation
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axis_txc_generator_v1_0_M_AXIS is
	generic (
		-- Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_M_AXIS_TDATA_WIDTH.
		C_M_AXIS_TDATA_WIDTH	: integer	:= 32
	);
	port (
		-- txc control words
		TXC_W0_IN : in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
        TXC_W1_IN : in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
        TXC_W2_IN : in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
        TXC_W3_IN : in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
        TXC_W4_IN : in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
        TXC_W5_IN : in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);

		-- Global ports
		M_AXIS_ACLK	: in std_logic;
		-- 
		M_AXIS_ARESETN	: in std_logic;
		-- Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
		M_AXIS_TVALID	: out std_logic;
		-- TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
		M_AXIS_TDATA	: out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
		-- TKEEP is the data valid strobe
		M_AXIS_TKEEP	: out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
		-- TLAST indicates the boundary of a packet.
		M_AXIS_TLAST	: out std_logic;
		-- TREADY indicates that the slave can accept a transfer in the current cycle.
		M_AXIS_TREADY	: in std_logic
	);
end axis_txc_generator_v1_0_M_AXIS;

architecture implementation of axis_txc_generator_v1_0_M_AXIS is

signal tvalid  : std_logic;
signal tdata   : std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
signal tlast   : std_logic;

begin

M_AXIS_TVALID <= tvalid;
M_AXIS_TLAST  <= tlast;
M_AXIS_TDATA  <= tdata;
M_AXIS_TKEEP  <= (others => '1');

-- process controlling m_axis bus
m_axis_state_machine: process(M_AXIS_ACLK)
variable counter : integer range 0 to 6;
variable sent : std_logic;
begin
    if rising_edge(M_AXIS_ACLK) then
        if M_AXIS_ARESETN = '0' then
            tvalid <= '0';
            tlast <= '0';
            counter := 0;
            sent := '0';
        else
            -- if eth subsystem is ready to accept controll packet
            if M_AXIS_TREADY = '1' then
                -- start sending control packet if not already sent
                if sent = '0' then
                    -- send control words 0 to 5
                    case counter is
                        when 0 =>
                            tdata <= TXC_W0_IN;
                            -- first word of the packet, assert tvalid
                            tvalid <= '1';
                        when 1 =>
                            tdata <= TXC_W1_IN;
                        when 2 =>
                            tdata <= TXC_W2_IN;
                        when 3 =>
                            tdata <= TXC_W3_IN;
                        when 4 =>
                            tdata <= TXC_W4_IN;
                        when 5 =>
                            tdata <= TXC_W5_IN;
                            -- last word of the packet, assert tlast
                            tlast <= '1';
                        when 6 =>
                            -- packet sent, deasert tvalid and tlast, set sent marker
                            tvalid <= '0';
                            tlast <= '0';
                            sent := '1';
                    end case;
                    counter := counter + 1;
                end if;
            -- if already sent then enable next packet, when tready is active again
            elsif sent = '1' then
                counter := 0;
                sent := '0';
            end if;
        end if;
    end if;
end process;

end implementation;
