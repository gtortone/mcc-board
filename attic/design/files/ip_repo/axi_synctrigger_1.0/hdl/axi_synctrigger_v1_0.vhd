library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Library UNISIM;
use UNISIM.vcomponents.all;

entity axi_synctrigger_v1_0 is
	generic (
		-- Users to add parameters here

        C_TRIG_PERIOD : integer := 25000000;
        C_SYNC_PERIOD : integer := 25000000;
        C_TRIG_PULSE_WIDTH : integer := 25;
        C_SYNC_PULSE_WIDTH : integer := 25;

		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- Parameters of Axi Slave Bus Interface S_AXI
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 4
	);
	port (
		-- Users to add ports here
		
		CLK : in std_logic;
		CLK_100 : in std_logic;
		CLK_10 : in std_logic;

        MPMT_TRIG_p : out std_logic;
        MPMT_TRIG_n : out std_logic;
        MPMT_SYNC_p : out std_logic;
        MPMT_SYNC_n : out std_logic;
        
        EXT_TRIG_I_p : in std_logic;
        EXT_TRIG_I_n : in std_logic;
        SAS_TRIG_I_p : in std_logic;
        SAS_TRIG_I_n : in std_logic;
        SAS_SYNC_I_p : in std_logic;
        SAS_SYNC_I_n : in std_logic;
        
        EXT_TRIG_O_p : out std_logic;
        EXT_TRIG_O_n : out std_logic;
        SAS_TRIG_O_p : out std_logic;
        SAS_TRIG_O_n : out std_logic;
        SAS_SYNC_O_p : out std_logic;
        SAS_SYNC_O_n : out std_logic;
        
        EXT_TRIG_OUT : out std_logic;
        SAS_TRIG_OUT : out std_logic;
        SAS_SYNC_OUT : out std_Logic;
        

		-- User ports ends
		-- Do not modify the ports beyond this line


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
		s_axi_rready	: in std_logic
	);
end axi_synctrigger_v1_0;

architecture arch_imp of axi_synctrigger_v1_0 is

	-- component declaration
	component axi_synctrigger_v1_0_S_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 4
		);
		port (
		RESET : out std_logic;
        GENEN : out std_logic;
        PPS_SOURCE : out std_logic;
        EXT_TRIG_SOURCE : out std_logic;
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
	end component axi_synctrigger_v1_0_S_AXI;
	
    component pulse_generator is
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
    end component pulse_generator;
    
    component pulse_extender is
        generic(
            C_PULSE_WIDTH : integer := 1
        );
        port(
            I : in STD_LOGIC;
            O : out STD_LOGIC;
            CLK : in STD_LOGIC;
            RESET : in STD_LOGIC
        );
    end component pulse_extender;    
	
    component sync_block is
        generic (
            INITIALISE : bit_vector(5 downto 0) := "000000"
        );
        port (
            clk         : in  std_logic; -- clock to be sync'ed to
            data_in     : in  std_logic; -- Data to be 'synced'
            data_out    : out std_logic -- synced data
        );
    end component;
    
--    component sync_block_vector is
--        generic (
--            C_WIDTH : integer := 1;
--            INITIALISE : bit_vector(5 downto 0) := "000000"
--        );
--        port ( 
--            clk         : in  std_logic; -- clock to be sync'ed to
--            data_in     : in  std_logic_vector(C_WIDTH - 1 downto 0); -- Data to be 'synced'
--            data_out    : out std_logic_vector(C_WIDTH - 1 downto 0) -- synced data    
--        );
--    end component;

component Time_Tag_Gen is
  GENERIC (  OVF     :Integer :=99999999  ); -- Indirizzo base 
    Port ( 	CLK100MHz 		: in  STD_LOGIC;
				CLK10MHz			: in  STD_LOGIC;
				RESET 			: in  STD_LOGIC;
				PPSin				: in  STD_LOGIC; -- BNC
				ResSec			: in  STD_LOGIC;
				PPSout			: out STD_LOGIC;
				Force_Alling	: in  STD_LOGIC; -- Da RC per forzare l'allineamento tra il PS del GPS e quello interno __|-|_____
				Pre_PPS			: out STD_LOGIC; -- PPS interno meno 32768 clk--- per PID
				CLK25M_Tag 		: out STD_LOGIC;
				F10MHz_Present	: in  STD_LOGIC;
				PPS_PRESENT		: out STD_LOGIC; -- 1 = PPS PRESENT
				RC_Time			: out STD_LOGIC_VECTOR (26 downto 0); -- LSB 10ns ..
		-- LED		
				MonResSec		: out STD_LOGIC;
				MonPPSin			: out STD_LOGIC
			 );
end component;	

signal reset : std_logic;
signal reset_s : std_logic;
signal genen : std_logic;
signal genen_s : std_logic;
signal pps_source : std_logic;
signal pps_source_s : std_logic;
signal ext_trig_source : std_logic;
signal ext_trig_source_s : std_logic;

signal trig : std_logic;
signal sync : std_logic;
signal trig_ext : std_logic;
signal sync_ext : std_logic;

signal ext_trig_i : std_logic;
signal sas_trig_i : std_logic;
signal sas_sync_i : std_logic;

signal mpmt_trig_o : std_logic;
signal mpmt_sync_o : std_logic;

signal ext_trig_o : std_logic;
signal sas_trig_o : std_logic;
signal sas_sync_o : std_logic;

signal pps_int : std_logic;
signal pps_out : std_logic;

signal ddr_out : std_logic;

begin

-- Instantiation of Axi Bus Interface S_AXI
axi_synctrigger_v1_0_S_AXI_inst : axi_synctrigger_v1_0_S_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S_AXI_ADDR_WIDTH
	)
	port map (
	    RESET => reset,
	    GENEN => genen,
	    PPS_SOURCE => pps_source,
	    EXT_TRIG_SOURCE => ext_trig_source,
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

	-- Add user logic here
	
pulse_generator_trig : pulse_generator
    generic map (
        C_PERIOD => C_TRIG_PERIOD,
        C_PERIOD_VAR => FALSE,
        C_POLARITY => '1'
    )
    port map (
        PULSE => trig,
        PERIOD => (others => '0'),
        CLR => '0',
        ENB => genen_s,
        RESET => reset_s,
        CLK => CLK
    );
    
pulse_extender_trig : pulse_extender
    generic map (
        C_PULSE_WIDTH => C_TRIG_PULSE_WIDTH
    )
    port map (
        I => trig, 
        O => trig_ext,
        CLK => CLK,
        RESET => reset_s
    );    
    
mpmt_trig_o <= trig_ext;
--ext_trig_o <= trig_ext;
ext_trig_o <= pps_out;
--ext_trig_o <= ddr_out;
sas_trig_o <= trig_ext;    
    
pulse_generator_sync : pulse_generator
    generic map (
        C_PERIOD => C_SYNC_PERIOD,
        C_PERIOD_VAR => FALSE,
        C_POLARITY => '1'
    )
    port map (
        PULSE => sync,
        PERIOD => (others => '0'),
        CLR => '0',
        ENB => genen_s,
        RESET => reset_s,
        CLK => CLK
    );
    
pulse_extender_sync : pulse_extender
    generic map (
        C_PULSE_WIDTH => C_SYNC_PULSE_WIDTH
    )
    port map (
        I => sync, 
        O => sync_ext,
        CLK => CLK,
        RESET => reset_s
    );    

--mpmt_sync_o <= sync_ext;
sas_sync_o <= sync_ext;

pps_int <= sync_ext when pps_source_s = '0' else ext_trig_i;
	
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
        Q => ddr_out, --mpmt_sync_o,  -- 1-bit output: Data output to IOB
        C => CLK,   -- 1-bit input: High-speed clock input
        D1 => '1', -- 1-bit input: Parallel data input 1
        D2 => '0', -- 1-bit input: Parallel data input 2
        SR => '0'  -- 1-bit input: Active High Async Reset
    ); 
    
Time_Tag_Gen_i : Time_Tag_Gen
    --GENERIC map (  OVF     :I-nteger :=99999999  ); -- Indirizzo base 
    Port map ( 	CLK100MHz => CLK_100,
				CLK10MHz => CLK_10,
				RESET => reset_s,
				PPSin => pps_int,
				ResSec => '0',-------
				PPSout => pps_out,
				Force_Alling => '0', --------
				Pre_PPS => open,
				CLK25M_Tag => mpmt_sync_o,
				F10MHz_Present => '1',
				PPS_PRESENT => open,
				RC_Time => open,
		-- LED		
				MonResSec => open,
				MonPPSin => open
			 );
	
IBUFDS_ext_trig : IBUFDS
    port map (
        O => ext_trig_i, -- 1-bit output: Buffer output
        I => EXT_TRIG_I_p, -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
        IB => EXT_TRIG_I_n -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );
    
IBUFDS_sas_trig : IBUFDS
    port map (
        O => sas_trig_i, -- 1-bit output: Buffer output
        I => SAS_TRIG_I_p, -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
        IB => SAS_TRIG_I_n -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );
        
IBUFDS_sas_sync : IBUFDS
    port map (
        O => sas_sync_i, -- 1-bit output: Buffer output
        I => SAS_SYNC_I_p, -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
        IB => SAS_SYNC_I_n -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
    );            
        
OBUFDS_mpmt_trig : OBUFDS
    port map (
        O => MPMT_TRIG_p, -- 1-bit output: Diff_p output (connect directly to top-level port)
        OB => MPMT_TRIG_n, -- 1-bit output: Diff_n output (connect directly to top-level port)
        I => mpmt_trig_o -- 1-bit input: Buffer input
    );        	

OBUFDS_mpmt_sync : OBUFDS
    port map (
        O => MPMT_SYNC_p, -- 1-bit output: Diff_p output (connect directly to top-level port)
        OB => MPMT_SYNC_n, -- 1-bit output: Diff_n output (connect directly to top-level port)
        I => mpmt_sync_o -- 1-bit input: Buffer input
    );

OBUFDS_ext_trig : OBUFDS
    port map (
        O => EXT_TRIG_O_p, -- 1-bit output: Diff_p output (connect directly to top-level port)
        OB => EXT_TRIG_O_n, -- 1-bit output: Diff_n output (connect directly to top-level port)
        I => ext_trig_o -- 1-bit input: Buffer input
    );
    
OBUFDS_sas_trig : OBUFDS
    port map (
        O => SAS_TRIG_O_p, -- 1-bit output: Diff_p output (connect directly to top-level port)
        OB => SAS_TRIG_O_n, -- 1-bit output: Diff_n output (connect directly to top-level port)
        I => sas_trig_o -- 1-bit input: Buffer input
    );
        
OBUFDS_sas_sync : OBUFDS
    port map (
        O => SAS_SYNC_O_p, -- 1-bit output: Diff_p output (connect directly to top-level port)
        OB => SAS_SYNC_O_n, -- 1-bit output: Diff_n output (connect directly to top-level port)
        I => sas_sync_o -- 1-bit input: Buffer input
    );
    
    EXT_TRIG_OUT <= ext_trig_i;
    SAS_TRIG_OUT <= sas_trig_i;
    SAS_SYNC_OUT <= sas_sync_i;
    
sync_reset : sync_block
    port map (
        clk         => CLK,
        data_in     => reset,
        data_out    => reset_s
    );
    
sync_genen : sync_block
    port map (
        clk         => CLK,
        data_in     => genen,
        data_out    => genen_s
    );        

sync_pps_source : sync_block
    port map (
        clk         => CLK,
        data_in     => pps_source,
        data_out    => pps_source_s
    );
    
sync_ext_trig_source : sync_block
    port map (
        clk         => CLK,
        data_in     => ext_trig_source,
        data_out    => ext_trig_source_s
    );
        
	-- User logic ends

end arch_imp;
