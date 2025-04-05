----------------------------------------------------------------------------------
-- Company: Jagiellonian University
-- Engineer: Krzysztof Zietara
-- 
-- Create Date: 
-- Design Name: axis_txc_generator 
-- Module Name: axis_txc_generator_v1_0 - arch_imp
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

entity axis_txc_generator_v1_0 is
	generic (
		-- Parameters of Axi Slave Bus Interface S_AXI
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 5;

		-- Parameters of Axi Master Bus Interface M_AXIS
		C_M_AXIS_TDATA_WIDTH	: integer	:= 32
	);
	port (
		-- Ports of Axi Slave Bus Interface S_AXI
		s_axi_aclk	: in std_logic;
		s_axi_aresetn	: in std_logic;
		s_axi_awaddr	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		s_axi_awprot	: in std_logic_vector(2 downto 0);
		s_axi_awvalid	: in std_logic;
		s_axi_awready	: out std_logic;
		s_axi_wdata	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		s_axi_wstrb	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		s_axi_wvalid	: in std_logic;
		s_axi_wready	: out std_logic;
		s_axi_bresp	: out std_logic_vector(1 downto 0);
		s_axi_bvalid	: out std_logic;
		s_axi_bready	: in std_logic;
		s_axi_araddr	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		s_axi_arprot	: in std_logic_vector(2 downto 0);
		s_axi_arvalid	: in std_logic;
		s_axi_arready	: out std_logic;
		s_axi_rdata	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		s_axi_rresp	: out std_logic_vector(1 downto 0);
		s_axi_rvalid	: out std_logic;
		s_axi_rready	: in std_logic;

		-- Ports of Axi Master Bus Interface M_AXIS
		m_axis_aclk	: in std_logic;
		m_axis_aresetn	: in std_logic;
		m_axis_tvalid	: out std_logic;
		m_axis_tdata	: out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
		m_axis_tkeep	: out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
		m_axis_tlast	: out std_logic;
		m_axis_tready	: in std_logic
	);
end axis_txc_generator_v1_0;

architecture arch_imp of axis_txc_generator_v1_0 is

	-- component declaration
	component axis_txc_generator_v1_0_S_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 5
		);
		port (
        TXC_W0_OUT : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        TXC_W1_OUT : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        TXC_W2_OUT : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        TXC_W3_OUT : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        TXC_W4_OUT : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        TXC_W5_OUT : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component axis_txc_generator_v1_0_S_AXI;

	component axis_txc_generator_v1_0_M_AXIS is
		generic (
		C_M_AXIS_TDATA_WIDTH	: integer	:= 32
		);
		port (
        TXC_W0_IN : in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
        TXC_W1_IN : in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
        TXC_W2_IN : in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
        TXC_W3_IN : in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
        TXC_W4_IN : in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
        TXC_W5_IN : in std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);		
		M_AXIS_ACLK	: in std_logic;
		M_AXIS_ARESETN	: in std_logic;
		M_AXIS_TVALID	: out std_logic;
		M_AXIS_TDATA	: out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
		M_AXIS_TKEEP	: out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
		M_AXIS_TLAST	: out std_logic;
		M_AXIS_TREADY	: in std_logic
		);
	end component axis_txc_generator_v1_0_M_AXIS;

-- transmit control words signals	
signal txc_w0 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
signal txc_w1 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);	
signal txc_w2 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);	
signal txc_w3 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);	
signal txc_w4 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);	
signal txc_w5 : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);		

begin

-- Instantiation of Axi Bus Interface S_AXI
axis_txc_generator_v1_0_S_AXI_inst : axis_txc_generator_v1_0_S_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S_AXI_ADDR_WIDTH
	)
	port map (
        TXC_W0_OUT => txc_w0,
        TXC_W1_OUT => txc_w1,
        TXC_W2_OUT => txc_w2,
        TXC_W3_OUT => txc_w3,
        TXC_W4_OUT => txc_w4,
        TXC_W5_OUT => txc_w5,
		S_AXI_ACLK	=> s_axi_aclk,
		S_AXI_ARESETN	=> s_axi_aresetn,
		S_AXI_AWADDR	=> s_axi_awaddr,
		S_AXI_AWPROT	=> s_axi_awprot,
		S_AXI_AWVALID	=> s_axi_awvalid,
		S_AXI_AWREADY	=> s_axi_awready,
		S_AXI_WDATA	=> s_axi_wdata,
		S_AXI_WSTRB	=> s_axi_wstrb,
		S_AXI_WVALID	=> s_axi_wvalid,
		S_AXI_WREADY	=> s_axi_wready,
		S_AXI_BRESP	=> s_axi_bresp,
		S_AXI_BVALID	=> s_axi_bvalid,
		S_AXI_BREADY	=> s_axi_bready,
		S_AXI_ARADDR	=> s_axi_araddr,
		S_AXI_ARPROT	=> s_axi_arprot,
		S_AXI_ARVALID	=> s_axi_arvalid,
		S_AXI_ARREADY	=> s_axi_arready,
		S_AXI_RDATA	=> s_axi_rdata,
		S_AXI_RRESP	=> s_axi_rresp,
		S_AXI_RVALID	=> s_axi_rvalid,
		S_AXI_RREADY	=> s_axi_rready
	);

-- Instantiation of Axi Bus Interface M_AXIS
axis_txc_generator_v1_0_M_AXIS_inst : axis_txc_generator_v1_0_M_AXIS
	generic map (
		C_M_AXIS_TDATA_WIDTH	=> C_M_AXIS_TDATA_WIDTH
	)
	port map (
        TXC_W0_IN => txc_w0,
        TXC_W1_IN => txc_w1,
        TXC_W2_IN => txc_w2,
        TXC_W3_IN => txc_w3,
        TXC_W4_IN => txc_w4,
        TXC_W5_IN => txc_w5,        	
		M_AXIS_ACLK	=> m_axis_aclk,
		M_AXIS_ARESETN	=> m_axis_aresetn,
		M_AXIS_TVALID	=> m_axis_tvalid,
		M_AXIS_TDATA	=> m_axis_tdata,
		M_AXIS_TKEEP	=> m_axis_tkeep,
		M_AXIS_TLAST	=> m_axis_tlast,
		M_AXIS_TREADY	=> m_axis_tready
	);

end arch_imp;
