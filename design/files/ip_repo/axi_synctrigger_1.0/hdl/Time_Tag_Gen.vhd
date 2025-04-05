----------------------------------------------------------------------------------
-- Company: INFN
-- Engineer:  AB
--  Genera i 25MHz col tag_0  e tag RES
--  ingresso 10MHZ e 100MHz
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--------------------------------------------------------

entity Time_Tag_Gen is
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
end Time_Tag_Gen;

architecture Behavioral of Time_Tag_Gen is


--===================================================================================
-- 						COSTANTI & SEGNALI
--===================================================================================
     -- Slow controll Signal 

signal Time_Tag 		:  STD_LOGIC_VECTOR (26 downto 0); -- Conta fino a 99.999.999Hz ovf 1sec
signal GO		 		:  STD_LOGIC;  	-- FLG_
signal ResGO		 	:  STD_LOGIC;  	-- FLG_
signal int_CLK25M_Tag  :  STD_LOGIC;  	-- FLG_
signal ContMon 		:  STD_LOGIC_VECTOR (19 downto 0); -- Conta x LED @ 10MHz 100ms
signal Cont_100ms		:  STD_LOGIC_VECTOR (3 downto 0); -- Conta 100ms OVF a 1,6 Sec
signal PPSin10Mr		:  STD_LOGIC;  	-- 
signal PPSin100Mr		:  STD_LOGIC;  	-- 
signal PPSin100Mrr	:  STD_LOGIC;  	-- 
signal ResSec10Mr		:  STD_LOGIC;  	-- 
signal ResSec100Mr	:  STD_LOGIC;  	-- 
signal Reset_Inviato	:  STD_LOGIC;  	-- 
signal PPSin10MEnR   :  STD_LOGIC;
signal intPPS_PRESENT:  STD_LOGIC;
signal Force_Allingr :  STD_LOGIC;
signal Force_Allingrr:  STD_LOGIC;
signal Force_AllingFF:  STD_LOGIC;

signal int_Pre_PPS	: STD_LOGIC; --impulso che arriva prima del PPS reale

constant OVF_men_3		: Integer :=  OVF - 3;
constant Val_X_Per_PPS	: Integer := OVF_men_3 - 32767 ; --





begin

Gen_Time : process (CLK100MHz, RESET)  
begin 

if RESET = '1' then

	GO 				<= '0';  
	ResGO 			<= '0';  
	int_CLK25M_Tag <= '0';
	Time_Tag 		<=(others => '0');
	PPSin100Mr		<= '0';
	PPSin100Mrr		<= '0';
	ResSec100Mr		<= '0';
	Reset_Inviato	<= '0';
	int_Pre_PPS		<= '0';
   Force_Allingr  <= '0';
   Force_Allingrr <= '0';
	Force_AllingFF <= '0';
	
elsif(rising_edge(CLK100MHz))then -- ___|----  FRONTE

   -------- Forza allineamento tra i PPS ... Da RC ---
	 if Force_Allingrr = '0' and Force_Allingr = '1' then
				Force_AllingFF <= '1';
	 end if;	
	 
	 if Force_AllingFF = '1' then
			PPSin100Mr 	<= PPSin;-- Se forzato viene direttamente dal BNC <<< Lo fa una sola volta 
	 else 		
			PPSin100Mr 	<= PPSin10MEnR;-- reg e cambio dominio ---- PPS
	end if;
-------------
	
	PPSin100Mrr	<= PPSin100Mr; -- reg reg 
	ResSec100Mr	<= ResSec10Mr;            --- RES Secondi
	Force_Allingr <= Force_Alling;
	Force_Allingrr <= Force_Allingr;
			

	
	---  Conta secondi
	if PPSin100Mr = '1' and PPSin100Mrr = '0' then
			Time_Tag 		<= conv_std_logic_vector(OVF_men_3, 27);  
			Force_AllingFF <= '0';	
   elsif Time_Tag < OVF then
			Time_Tag <= Time_Tag +1;
	else  
			Time_Tag <=(others => '0');
	end if;
	
--  Segnale GO per inviare il TAG0 ------------
	 if Time_Tag = 0  then   					
			GO <= '1';
			
		elsif	Time_Tag (2 downto 0) = 6 then
					GO <= '0' ;		
      end if;
	------------------------------------	
	
 --  Segnale ResGO per inviare il TAG res
	 if Time_Tag = 16 and ResSec100Mr = '1' then   					
			ResGO <= '1';
			Reset_Inviato <= '1';
					
		elsif	Time_Tag (2 downto 0) = 5 then
					ResGO <= '0' ;
	
		elsif Time_Tag = 32 then
						Reset_Inviato <= '0';
      		
      end if;
	------------------------------------	
  
   if GO = '1'   and Time_Tag (2 downto 0) = 1 then   --(2,5) --__--__-___---_--__--
	    int_CLK25M_Tag <= '0';
	elsif GO = '1'   and Time_Tag (2 downto 0) = 6 then
	    int_CLK25M_Tag <= '1';
		 
	elsif ResGO = '1'   and Time_Tag (2 downto 0) = 2 then --(1,6)--__--__---_-___--__
	    int_CLK25M_Tag <= '1';
	elsif ResGO = '1'   and Time_Tag (2 downto 0) = 5 then
	    int_CLK25M_Tag <= '0';	 
		 
	else
			int_CLK25M_Tag <= not Time_Tag(1) ;
	
	end if;
	
---  Per Pre PPS
		if Time_Tag = Val_X_Per_PPS then
			int_Pre_PPS		<= '1';
		else
			int_Pre_PPS		<= '0';
		end if;
 end if;
end process Gen_Time;


-- Assegna le uscite


CLK25M_Tag  <= int_CLK25M_Tag;
PPSout 		<= GO;
PPS_PRESENT <= intPPS_PRESENT;
RC_Time		<= Time_Tag;
Pre_PPS		<= int_Pre_PPS;



---------------------------
-- Monostabile LED
-- Sync PPS e ResSec
---------------------------
Monostabile : process (CLK10MHz, RESET)  
begin 

if RESET = '1' then
 ContMon 	<= (others => '0');
 Cont_100ms <= X"F";
 MonResSec	<= '0';
 MonPPSin	<= '0';
 PPSin10Mr	<= '0';
 ResSec10Mr	<= '0';
 PPSin10MEnR <= '0';
 intPPS_PRESENT <= '0';

elsif(rising_edge(CLK10MHz))then -- ___|----  FRONTE

PPSin10Mr 	<= PPSin;
PPSin10MEnR <= PPSin and F10MHz_Present;

ResSec10Mr	<= ResSec or  ( ResSec10Mr and not Reset_Inviato ) ;

ContMon		<= ContMon+1;

	if PPSin10Mr = '1' then -- Monostabile PPS 
			MonPPSin <= '1';
	elsif ContMon = 0 then
			MonPPSin <= '0';
	end if;		

	if ResSec10Mr = '1'  then -- Monostabile Reset Secondi
			MonResSec <= '1';		-- rimane acceso fino a che non viene inviato
	elsif ContMon = 0 then
			MonResSec <= '0';
	end if;
	
--PPS PRESENT	
	if PPSin10Mr = '1' then
		Cont_100ms <= (others => '0');
	elsif	ContMon = X"FFFFF" and Cont_100ms < X"F" then
	  Cont_100ms <= Cont_100ms + 1 ;
	end if;
	
	if Cont_100ms = X"F" then
	 intPPS_PRESENT <= '0';
	else 
	 intPPS_PRESENT <= '1';
	end if;
----------------------	
end if;
-------------------------------------------------

end process Monostabile;



end Behavioral;

