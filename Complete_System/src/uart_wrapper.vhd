----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:00:27 01/06/2011 
-- Design Name: 
-- Module Name:    uart_wrapper - Behavioral 
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

entity uart_wrapper is
   port(
      clk, reset: in std_logic;
      rd_uart, wr_uart: in std_logic;
      rx: in std_logic;
		tx: out std_logic;
		tx_full, rx_empty: out std_logic;
		data_inout: inout std_logic_vector(15 downto 0)
   );
end uart_wrapper;	

architecture Behavioral of uart_wrapper is
	signal data_in		: STD_LOGIC_VECTOR(7 downto 0);
	signal data_out	: STD_LOGIC_VECTOR(7 downto 0);
begin

		
-- UART
uart : entity work.uart
	port map (
		clk		=> clk,
		reset 	=> reset,
		rd_uart	=> rd_uart,
		wr_uart	=> wr_uart,
		rx			=> rx,
		w_data	=>	data_in,
		tx_full	=> tx_full,
		rx_empty => rx_empty,
		r_data	=> data_out,
		tx			=> tx
		);

	--- Tristate buffer 
	--- takes data out of uart and on the bus.
	 data_inout <= X"00" & data_out when rd_uart = '1' else (others => 'Z');
	 data_in <= data_inout(7 downto 0);

end Behavioral;

