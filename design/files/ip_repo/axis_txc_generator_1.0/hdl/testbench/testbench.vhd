----------------------------------------------------------------------------------
-- Company: Jagiellonian University
-- Engineer: Krzysztof Zietara
-- 
-- Create Date: 
-- Design Name: axis_txc_generator 
-- Module Name: testbench
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
use IEEE.NUMERIC_STD.ALL;

LIBRARY xil_defaultlib;
USE xil_defaultlib.testbench_util.ALL;

entity testbench is

end testbench;

architecture Behavioral of testbench is

    --------------------------------------------------------------------------------------------
    -- constant declarations
    --------------------------------------------------------------------------------------------   
    -- number of channels
    constant C_CH_NUM : integer := 1;
    -- clock periods
    constant C_PERIOD_CLK_AXI : time := 8ns; --125MHz
    constant C_PERIOD_CLK_M_AXIS : time := 8ns; --125MHz
    constant C_PERIOD_CLK_S_AXIS : time := 8ns; --125MHz    
    -- axi data and address width
    constant C_S_AXI_DATA_WIDTH	: integer	:= 32;
    constant C_S_AXI_ADDR_WIDTH	: integer	:= 5;
    -- m_axis data widths
    constant C_M_AXIS_TDATA_WIDTH	: integer	:= 32;
    -- short versions
    constant RXD_W : integer := C_M_AXIS_TDATA_WIDTH;
    -- base address
    constant C_BASE_ADDRESS     : integer := 0;
    -- packet length (in bytes)
    constant C_PACKET_LENGTH    : integer := 24;
    constant C_PACKET_NUMBER    : integer := 10;
    
    --------------------------------------------------------------------------------------------
    -- DUT component declaration
    --------------------------------------------------------------------------------------------       
    component axis_txc_generator_v1_0 is
--        generic (
--            -- Parameters of Axi Slave Bus Interface S_AXI
--            C_S_AXI_DATA_WIDTH    : integer    := 32;
--            C_S_AXI_ADDR_WIDTH    : integer    := 5;  
--            -- Parameters of Axi Master Bus Interface M_AXIS
--            C_M_AXIS_TDATA_WIDTH    : integer    := 32
--        );
        port (
            -- Ports of Axi Slave Bus Interface S_AXI
            s_axi_aclk    : in std_logic;
            s_axi_aresetn    : in std_logic;
            s_axi_awaddr    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
            s_axi_awprot    : in std_logic_vector(2 downto 0);
            s_axi_awvalid    : in std_logic;
            s_axi_awready    : out std_logic;
            s_axi_wdata    : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            s_axi_wstrb    : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
            s_axi_wvalid    : in std_logic;
            s_axi_wready    : out std_logic;
            s_axi_bresp    : out std_logic_vector(1 downto 0);
            s_axi_bvalid    : out std_logic;
            s_axi_bready    : in std_logic;
            s_axi_araddr    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
            s_axi_arprot    : in std_logic_vector(2 downto 0);
            s_axi_arvalid    : in std_logic;
            s_axi_arready    : out std_logic;
            s_axi_rdata    : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
            s_axi_rresp    : out std_logic_vector(1 downto 0);
            s_axi_rvalid    : out std_logic;
            s_axi_rready    : in std_logic;
            -- Ports of Axi Master Bus Interface M_AXIS
            m_axis_aclk    : in std_logic;
            m_axis_aresetn    : in std_logic;
            m_axis_tvalid    : out std_logic;
            m_axis_tdata    : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
            m_axis_tkeep    : out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
            m_axis_tlast    : out std_logic;
            m_axis_tready    : in std_logic
        );
    end component;
    
    --------------------------------------------------------------------------------------------
    -- signal definitions
    --------------------------------------------------------------------------------------------       
    -- reset
    signal resetn: std_logic;
    -- clocks
    signal clk_axi : std_logic;
    signal clk_m_axis : std_logic;
    signal clk_s_axis : std_logic;
    -- array of packets
    type packet_array_type is array (0 to C_CH_NUM-1) of packet_type(0 to C_PACKET_LENGTH-1);
    signal packet_tx_array : packet_array_type;
    signal packet_rx_array : packet_array_type;
    -- axi bus signals
    signal axi_awaddr	: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    --signal axi_awprot	: std_logic_vector(2 downto 0);
    signal axi_awvalid	: std_logic;
    signal axi_awready	: std_logic;
    signal axi_wdata	: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal axi_wstrb	: std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    signal axi_wvalid	: std_logic;
    signal axi_wready	: std_logic;
    signal axi_bresp	: std_logic_vector(1 downto 0);
    signal axi_bvalid	: std_logic;
    signal axi_bready	: std_logic;
    signal axi_araddr	: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    --signal axi_arprot	: std_logic_vector(2 downto 0);
    signal axi_arvalid	: std_logic;
    signal axi_arready	: std_logic;
    signal axi_rdata	: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    signal axi_rresp	: std_logic_vector(1 downto 0);
    signal axi_rvalid	: std_logic;
    signal axi_rready	: std_logic;

    -- s_axis buses (rxd)
    signal rxd_tvalid  : std_logic_vector(0 downto 0);
    signal rxd_tdata   : std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
    signal rxd_tkeep   : std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
    signal rxd_tlast   : std_logic_vector(0 downto 0);
    signal rxd_tready  : std_logic_vector(0 downto 0);
    
    signal configured : std_logic := '0';
    signal received_packet : std_logic := '0';
    signal received_packet_cfm : std_logic := '0';

begin

    --------------------------------------------------------------------------------------------
    -- slave axis process generation
    --------------------------------------------------------------------------------------------
    S_AXIS: for i in 0 to C_CH_NUM-1 generate    
        s_axis_process : process
        begin
        
            S_AXIS_RESET(clk_m_axis,rxd_tready(i));
                
            -- wait for dut reset to be finished 
            wait until resetn = '1';
            
            -- wait until dut is configured over axi interface (all txc controll words written)
            wait until configured = '1';
            
            -- receive packets
            
            for j in 0 to C_PACKET_NUMBER-1 loop
                wait for C_PERIOD_CLK_S_AXIS*10*(j+1);
                S_AXIS_RECEIVE_PACKET(clk_s_axis,rxd_tvalid(i),rxd_tdata(RXD_W*(i+1)-1 downto RXD_W*i),rxd_tkeep((RXD_W/8)*(i+1)-1 downto (RXD_W/8)*i),rxd_tlast(i),rxd_tready(i),packet_rx_array(i));  
                received_packet <= '1';
                wait until received_packet_cfm = '1';
                received_packet <= '0';      
            end loop;
            
            wait;
        
        end process;
    end generate S_AXIS;    
    
    --------------------------------------------------------------------------------------------
    -- axi process - main process controlling whole test
    --------------------------------------------------------------------------------------------    
    axi_process : process
    variable reg_rd : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    variable reg_wr : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    variable packet_error : std_logic := '0';
    variable data : std_logic_vector(7 downto 0);
    begin
    
        data := X"01";
        
        -- initialize array of tx packets only to compare with received packets
        for i in 0 to C_CH_NUM-1 loop
            for j in 0 to C_PACKET_LENGTH/4-1 loop
                for k in 0 to 3 loop
                    packet_tx_array(i)(4*j+k) <= data;
                end loop;
                for k in data'length-1 downto 1 loop
                    data(k) := data(k-1);
                end loop;
                data(0) := '0';       
            end loop;
        end loop;
        
        --reset axi signals        
        AXI_RESET(clk_axi,axi_awaddr,axi_awvalid,axi_wvalid,axi_araddr,axi_arvalid,axi_rready);   
        
        -- wait for dut reset to be finished 
        wait until resetn = '1';
        
        reg_wr := X"01010101";
        
        --write to txc control registers
        for addr in 0 to 5 loop
            AXI_WRITE(clk_axi,axi_awaddr,axi_awvalid,axi_awready,axi_wdata,axi_wstrb,axi_wvalid,axi_wready,reg_wr,addr,C_BASE_ADDRESS);
            for i in reg_wr'length-1 downto 1 loop
                reg_wr(i) := reg_wr(i-1);
            end loop;
            reg_wr(0) := '0';
        end loop;      
        
        configured <= '1';
        
        for k in 0 to C_PACKET_NUMBER-1 loop 
            wait until received_packet = '1';
            received_packet_cfm <= '1';
            wait until received_packet = '0';
            received_packet_cfm <= '0';    
            report ("Received packet "&integer'IMAGE(k+1)&" out of "&integer'IMAGE(C_PACKET_NUMBER)) severity NOTE;               
            -- verify received packets (compare with respect tx packets and report errors)
            for i in 0 to C_CH_NUM-1 loop
                for j in 0 to C_PACKET_LENGTH-1 loop
                    if packet_rx_array(i)(j) /= packet_tx_array(i)(j) then
                        report ("Error on byte "&integer'IMAGE(j)&" !!!") severity ERROR;
                        packet_error := '1';
                    end if;          
                end loop;
            end loop;
        end loop;
        
        -- report packet test result
        if packet_error = '1' then
            report ("Test failed !!!") severity ERROR;
        else
            report ("Test succeded !!!") severity NOTE;
        end if;        
    
        wait;
    end process;   
    
    --------------------------------------------------------------------------------------------
    -- axi write response channel process
    --------------------------------------------------------------------------------------------    
    axi_wr_resp_process : process(clk_axi)
    begin
        if clk_axi'event and clk_axi = '1' then
            if axi_bvalid = '1' then
                axi_bready <= '1';
            else
                axi_bready <= '0';
            end if;
        end if;
    end process;
    
    --------------------------------------------------------------------------------------------
    -- clock generation processes
    --------------------------------------------------------------------------------------------
    clk_axi_process : process
    begin
        clk_axi <= '1';
        wait for C_PERIOD_CLK_AXI/2;
        clk_axi <= '0';
        wait for C_PERIOD_CLK_AXI/2;
    end process;
    
    clk_m_axis_process : process
    begin
        clk_m_axis <= '1';
        wait for C_PERIOD_CLK_M_AXIS/2;
        clk_m_axis <= '0';
        wait for C_PERIOD_CLK_M_AXIS/2;
    end process;
    
    clk_s_axis_process : process
    begin
        clk_s_axis <= '1';
        wait for C_PERIOD_CLK_S_AXIS/2;
        clk_s_axis <= '0';
        wait for C_PERIOD_CLK_S_AXIS/2;
    end process;    
    
    --------------------------------------------------------------------------------------------
    -- reset process
    --------------------------------------------------------------------------------------------       
    reset_process : process
    begin
        resetn <= '0';
        wait for 100ns;
        resetn <= '1';
        wait;
    end process; 
    
    --------------------------------------------------------------------------------------------
    -- DUT component instantiation
    --------------------------------------------------------------------------------------------   
    dut : axis_txc_generator_v1_0
        port map (
            -- Ports of Axi Slave Bus Interface S_AXI
            s_axi_aclk => clk_axi,
            s_axi_aresetn => resetn,
            s_axi_awaddr => axi_awaddr,
            s_axi_awprot => (others => '0'),--axi_awprot,
            s_axi_awvalid => axi_awvalid,
            s_axi_awready => axi_awready,
            s_axi_wdata => axi_wdata,
            s_axi_wstrb => axi_wstrb,
            s_axi_wvalid => axi_wvalid,
            s_axi_wready => axi_wready,
            s_axi_bresp => axi_bresp,
            s_axi_bvalid => axi_bvalid,
            s_axi_bready => axi_bready,
            s_axi_araddr => axi_araddr,
            s_axi_arprot => (others => '0'),--axi_arprot,
            s_axi_arvalid => axi_arvalid,
            s_axi_arready => axi_arready,
            s_axi_rdata => axi_rdata,
            s_axi_rresp => axi_rresp,
            s_axi_rvalid => axi_rvalid,
            s_axi_rready => axi_rready,
    
            -- Ports of Axi Master Bus Interface M_AXIS
            m_axis_aclk => clk_m_axis,
            m_axis_aresetn => resetn,
            m_axis_tready => rxd_tready(0),
            m_axis_tdata  => rxd_tdata(C_M_AXIS_TDATA_WIDTH*1-1 downto C_M_AXIS_TDATA_WIDTH*0),
            m_axis_tkeep  => rxd_tkeep((C_M_AXIS_TDATA_WIDTH/8)*1-1 downto (C_M_AXIS_TDATA_WIDTH/8)*0),
            m_axis_tlast  => rxd_tlast(0),
            m_axis_tvalid => rxd_tvalid(0)
        );   

end Behavioral;
