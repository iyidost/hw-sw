----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:24:15 01/07/2011 
-- Design Name: 
-- Module Name:    memory_wrapper - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memory_wrapper is
   port(
      clk, WE, RE	: in std_logic;
		addr			: in std_logic_vector(15 downto 0);
		data_inout	: inout std_logic_vector(15 downto 0)
---      switches		: in std_logic_vector(7 downto 0);
---		buttons		: in std_logic_vector(4 downto 0);
---		leds_reg		: out std_logic_vector(7 downto 0)
   );
end memory_wrapper;

architecture Behavioral of memory_wrapper is
	--- signal data_in		: STD_LOGIC_VECTOR(15 downto 0);
	signal data_out	: STD_LOGIC_VECTOR(15 downto 0);
	signal mem_WE		: std_logic;

begin
-- Memory
	memory : entity work.Memory
	generic map(
			ADDR_WIDTH			=> 16,
			DATA_WIDTH			=> 16
		)	
	port map (
			clk			=> clk,
			WE 			=> mem_WE,
			RE 			=> RE,
			addr 			=> addr,-- (11 downto 0),
			memory_in 	=> data_inout,
			memory_out	=> data_out
		);
	
	-- Original tristate definition (currently outcommented)
	data_inout <= data_out when RE = '1' AND addr < x"FE00" else "ZZZZZZZZZZZZZZZZ";
	mem_WE <= '1' when WE = '1' AND addr > x"03ff" AND addr < x"FE00" else '0';
	

end Behavioral;
