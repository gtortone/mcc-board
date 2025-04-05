----------------------------------------------------------------------------------
-- Company: Jagiellonian University
-- Engineer: Krzysztof Zietara
-- 
-- Create Date: 
-- Design Name: axis_txc_generator 
-- Module Name: testbench_util - package
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
--use IEEE.NUMERIC_STD.ALL;

package testbench_util is

    --------------------------------------------------------------------------------------------
    -- constant declarations
    --------------------------------------------------------------------------------------------
    constant C_AXI_DATA_WIDTH : integer	:= 32;
    constant C_AXI_ADDR_WIDTH : integer	:= 5;
    
    constant C_S_AXIS_TDATA_WIDTH : integer	:= 32;
    constant C_M_AXIS_TDATA_WIDTH : integer := 32;
  
    --------------------------------------------------------------------------------------------
    -- type declarations
    --------------------------------------------------------------------------------------------    
    type packet_type is array (integer range <>) of std_logic_vector(7 downto 0);
    
    --------------------------------------------------------------------------------------------
    -- AXI reset procedure declaration
    --------------------------------------------------------------------------------------------
    procedure AXI_RESET (
        signal axi_aclk     : in  std_logic;
        signal axi_awaddr   : out std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
        signal axi_awvalid  : out std_logic;
        signal axi_wvalid   : out std_logic;
        signal axi_araddr   : out std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
        signal axi_arvalid  : out std_logic;
        signal axi_rready   : out std_logic);
    
    --------------------------------------------------------------------------------------------
    -- AXI write procedure declaration
    --------------------------------------------------------------------------------------------
    procedure AXI_WRITE (
        signal axi_aclk     : in  std_logic;
        signal axi_awaddr   : out std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
        signal axi_awvalid  : out std_logic;
        signal axi_awready  : in std_logic;
        signal axi_wdata    : out std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
        signal axi_wstrb    : out std_logic_vector((C_AXI_DATA_WIDTH/8)-1 downto 0);
        signal axi_wvalid   : out std_logic;
        signal axi_wready   : in std_logic;
    --        signal axi_bresp    : in std_logic_vector(1 downto 0);
    --        signal axi_bvalid   : in std_logic;
    --        signal axi_bready   : out std_logic;     
        variable data       : in std_logic_vector (C_AXI_DATA_WIDTH-1 downto 0);
        constant addr       : in integer;
        constant addr_base  : in integer);
    
    --------------------------------------------------------------------------------------------
    -- AXI read procedure declaration
    --------------------------------------------------------------------------------------------    
    procedure AXI_READ (
        signal axi_aclk     : in  std_logic;
        signal axi_araddr   : out std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
        signal axi_arvalid  : out std_logic;
        signal axi_arready  : in std_logic;
        signal axi_rdata    : in std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
        signal axi_rvalid   : in std_logic;
        signal axi_rready   : out std_logic;
        variable data         : out std_logic_vector (C_AXI_DATA_WIDTH-1 downto 0);
        constant addr       : in integer;
        constant addr_base  : in integer);

    --------------------------------------------------------------------------------------------
    -- AXIS master reset procedure declaration
    --------------------------------------------------------------------------------------------         
    procedure M_AXIS_RESET (
        signal axis_aclk        : in std_logic;
        signal m_axis_tvalid    : out std_logic;
        signal m_axis_tdata     : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
        signal m_axis_tkeep     : out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
        signal m_axis_tlast     : out std_logic);      
        
    --------------------------------------------------------------------------------------------
    -- AXIS master send packet procedure declaration
    --------------------------------------------------------------------------------------------         
    procedure M_AXIS_SEND_PACKET (
        signal axis_aclk        : in std_logic;
        signal m_axis_tvalid    : out std_logic;
        signal m_axis_tdata     : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
        signal m_axis_tkeep     : out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
        signal m_axis_tlast     : out std_logic;
        signal m_axis_tready    : in std_logic;
        constant packet         : packet_type);        
  
    --------------------------------------------------------------------------------------------
    -- AXIS slave reset procedure declaration
    --------------------------------------------------------------------------------------------         
    procedure S_AXIS_RESET (
        signal axis_aclk        : in std_logic;
        signal s_axis_tready    : out std_logic);
                
    --------------------------------------------------------------------------------------------
    -- AXIS slave receive packet procedure declaration
    --------------------------------------------------------------------------------------------     
    procedure S_AXIS_RECEIVE_PACKET (
        signal axis_aclk        : in std_logic;
        signal s_axis_tvalid    : in std_logic;
        signal s_axis_tdata     : in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
        signal s_axis_tkeep     : in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
        signal s_axis_tlast     : in std_logic;
        signal s_axis_tready    : out std_logic;
        signal packet           : out packet_type);    

end testbench_util;

package body testbench_util is

    --------------------------------------------------------------------------------------------
    -- AXI reset procedure body
    --------------------------------------------------------------------------------------------
    procedure AXI_RESET (
        signal axi_aclk     : in  std_logic;
        signal axi_awaddr   : out std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
        signal axi_awvalid  : out std_logic;
        signal axi_wvalid   : out std_logic;
        signal axi_araddr   : out std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
        signal axi_arvalid  : out std_logic;
        signal axi_rready   : out std_logic) is
    begin
        -- wait for falling clock edge
        wait until axi_aclk = '0';
        -- reset axi
        axi_awaddr <= (others => '0');
        axi_awvalid <= '0';
        axi_wvalid <= '0';
        axi_araddr <= (others => '0');
        axi_arvalid <= '0';
        axi_rready <= '0';
    end AXI_RESET;   

    --------------------------------------------------------------------------------------------
	-- AXI write procedure body
	--------------------------------------------------------------------------------------------
    procedure AXI_WRITE (
        signal axi_aclk     : in  std_logic;
        signal axi_awaddr	: out std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
        signal axi_awvalid	: out std_logic;
        signal axi_awready  : in std_logic;
        signal axi_wdata	: out std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
        signal axi_wstrb	: out std_logic_vector((C_AXI_DATA_WIDTH/8)-1 downto 0);
        signal axi_wvalid	: out std_logic;
        signal axi_wready   : in std_logic;
--        signal axi_bresp	: in std_logic_vector(1 downto 0);
--        signal axi_bvalid   : in std_logic;
--        signal axi_bready   : out std_logic;     
        variable data         : in std_logic_vector (C_AXI_DATA_WIDTH-1 downto 0);
        constant addr       : in integer;
        constant addr_base  : in integer) is
    begin
        -- wait for falling clock edge
        wait until axi_aclk = '0';
        -- pud data, address and control to the bus
        axi_awaddr <= conv_std_logic_vector((addr+addr_base)*4,C_AXI_ADDR_WIDTH);
        axi_awvalid <= '1';
        axi_wdata <= data;
        axi_wstrb <= X"F";
        axi_wvalid <= '1';
        -- wait for rising clock edge
        wait until axi_aclk = '1';
        -- wait for both awready and wready asserted
        while axi_awready = '0' or axi_wready = '0' loop
            -- wait for rising clock edge
            wait until axi_aclk = '1';        
        end loop;
        -- wait for falling clock edge
        wait until axi_aclk = '0';
        -- deasert awvalid and wvalid
        axi_awvalid <= '0';
        axi_wvalid <= '0';
    end AXI_WRITE;
    
	--------------------------------------------------------------------------------------------
    -- AXI read procedure body
    --------------------------------------------------------------------------------------------    
    procedure AXI_READ (
        signal axi_aclk     : in  std_logic;
        signal axi_araddr	: out std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
        signal axi_arvalid	: out std_logic;
        signal axi_arready	: in std_logic;
        signal axi_rdata	: in std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
        signal axi_rvalid	: in std_logic;
        signal axi_rready	: out std_logic;
        variable data       : out std_logic_vector (C_AXI_DATA_WIDTH-1 downto 0);
        constant addr       : in integer;
        constant addr_base  : in integer) is
    begin
        -- wait for falling clock edge
        wait until axi_aclk = '0';
        -- put address to the bus
        axi_araddr <= conv_std_logic_vector((addr+addr_base)*4,C_AXI_ADDR_WIDTH);
        axi_arvalid <= '1';
        -- wait for rising clock edge
        wait until axi_aclk = '1';
        -- wait for arready asserted
        while axi_arready = '0' loop
            -- wait for rising clock edge
            wait until axi_aclk = '1';        
        end loop;        
        -- wait for falling clock edge
        wait until axi_aclk = '0';
        -- deassert arvalid and assert rready
        axi_arvalid <= '0';
        axi_rready <= '1';
        wait until axi_aclk = '1';
        -- wait for arready asserted
        while axi_rvalid = '0' loop
            -- wait for rising clock edge
            wait until axi_aclk = '1';        
        end loop;        
        -- read data from the bus
        data := axi_rdata;
        -- wait for falling clock edge
        wait until axi_aclk = '0';
        -- deasert rready
        axi_rready <= '0';
    end AXI_READ;

    --------------------------------------------------------------------------------------------
    -- AXIS master reset procedure declaration
    --------------------------------------------------------------------------------------------         
    procedure M_AXIS_RESET (
        signal axis_aclk        : in std_logic;
        signal m_axis_tvalid    : out std_logic;
        signal m_axis_tdata     : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
        signal m_axis_tkeep     : out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
        signal m_axis_tlast     : out std_logic) is
    begin
        wait until axis_aclk = '0';
        m_axis_tvalid <= '0';
        m_axis_tdata <= (others => '0');
        m_axis_tkeep <= (others => '0');
        m_axis_tlast <= '0';    
    end M_AXIS_RESET;     
    
    --------------------------------------------------------------------------------------------
    -- AXIS master send packet procedure body
    --------------------------------------------------------------------------------------------         
    procedure M_AXIS_SEND_PACKET (
        signal axis_aclk        : in std_logic;
        signal m_axis_tvalid    : out std_logic;
        signal m_axis_tdata     : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
        signal m_axis_tkeep     : out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
        signal m_axis_tlast     : out std_logic;
        signal m_axis_tready    : in std_logic;
        constant packet         : packet_type) is
    begin
        for i in 0 to packet'length-1 loop
            -- clear tkeep and tdata before new transaction
            if i mod (C_M_AXIS_TDATA_WIDTH/8) = 0 then
                -- wait for clock falling edge to change data
                wait until axis_aclk = '0';
                m_axis_tdata <= (others => '0');
                m_axis_tkeep <= (others => '0');
            end if;
            -- put byte to bus
            m_axis_tdata((i mod (C_M_AXIS_TDATA_WIDTH/8))*8+7 downto (i mod (C_M_AXIS_TDATA_WIDTH/8))*8) <= packet(i);
            -- set byte tkeep
            m_axis_tkeep(i mod (C_M_AXIS_TDATA_WIDTH/8)) <= '1';
            -- generate transaction if C_M_AXIS_TDATA_WIDTH/8 bytes on the buss or last byte
            if i mod (C_M_AXIS_TDATA_WIDTH/8) = C_M_AXIS_TDATA_WIDTH/8-1 or i = packet'length-1 then
                -- if this is last byte then set tlast
                if i = packet'length-1 then
                    m_axis_tlast <= '1';   
                else
                    m_axis_tlast <= '0';
                end if;
                -- assert tvalid
                m_axis_tvalid <= '1';
                -- wait for clock rising edge
                wait until axis_aclk = '1';
                -- wait for tready from slave
                while m_axis_tready = '0' loop
                    -- if no tready check next clock rising edge
                    wait until axis_aclk = '1';
                end loop;
                if i = packet'length-1 then
                    -- wait for clock falling edge to change deasert tvalid
                    wait until axis_aclk = '0';
                    m_axis_tvalid <= '0'; 
                end if;          
            end if;
        end loop;
    
    end M_AXIS_SEND_PACKET;   
    
    --------------------------------------------------------------------------------------------
    -- AXIS slave reset procedure declaration
    --------------------------------------------------------------------------------------------         
    procedure S_AXIS_RESET (
        signal axis_aclk        : in std_logic;
        signal s_axis_tready    : out std_logic) is
    begin         
        wait until axis_aclk = '0';
        s_axis_tready <= '0';   
    end S_AXIS_RESET;
  
    --------------------------------------------------------------------------------------------
    -- AXIS slave receive packet procedure body
    --------------------------------------------------------------------------------------------     
    procedure S_AXIS_RECEIVE_PACKET (
        signal axis_aclk        : in std_logic;
        signal s_axis_tvalid    : in std_logic;
        signal s_axis_tdata     : in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
        signal s_axis_tkeep     : in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
        signal s_axis_tlast     : in std_logic;
        signal s_axis_tready    : out std_logic;
        signal packet           : out packet_type) is
        variable byte_counter   : integer := 0;
        variable tready         : std_logic := '0';
    begin
        -- clear buffer
        for i in 0 to packet'length-1 loop
            packet(i) <= (others => '0');
        end loop;
        -- infinite loop
        loop
            -- wait for rising clock edge
            wait until axis_aclk = '1';
            -- if tvalid active then new transaction pending
            --if s_axis_tvalid = '1' then
                -- if tready is not asserted then wait for clock falling edge and assert
                if tready = '0' then
                    wait until axis_aclk = '0';
                    s_axis_tready <= '1';
                    tready := '1';
                elsif s_axis_tvalid = '1' then
                    -- put all bytes from current transaction to the packet buffer
                    for i in 0 to (C_S_AXIS_TDATA_WIDTH/8)-1 loop
                        if s_axis_tkeep(i) = '1' then
                            -- if buffer size exceded then continue reception without buffer writing
                            if byte_counter = packet'length then
                                report ("Packet buffer full!!!") severity ERROR ;
                            else
                                packet(byte_counter) <= s_axis_tdata(i*8+7 downto i*8);
                                byte_counter := byte_counter+1;
                            end if;
                        end if;
                    end loop;
                    -- check in end of packet
                    if s_axis_tlast = '1' then
                        -- wait for falling clock edge
                        wait until axis_aclk = '0';
                        -- clear tready
                        s_axis_tready <= '0';
                        tready := '0';
                        -- received less bytes then buffer length
                        if byte_counter < packet'length then
                            report ("Packet buffer not fully filled!!!") severity ERROR ;    
                        end if;
                        -- exit loop           
                        exit;
                    end if;
                end if;
            --end if;
        end loop;
    end S_AXIS_RECEIVE_PACKET;
          
end testbench_util;
