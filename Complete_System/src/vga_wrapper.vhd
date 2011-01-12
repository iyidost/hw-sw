----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:24:28 01/07/2011 
-- Design Name: 
-- Module Name:    vga_wrapper - Behavioral 
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

entity vga_wrapper is
   port (
      clk, reset		: in std_logic;	
      --hsync, vsync	: out STD_LOGIC;
		VGA_VSYNCH		: out STD_LOGIC;
		VGA_HSYNCH		: out STD_LOGIC;
		VGA_COMP_SYNCH	: out STD_LOGIC;
		VGA_OUT_BLANK_Z: out STD_LOGIC;
		VGA_OUT_PIXEL_CLOCK : out STD_LOGIC;
		VGA_OUT_BLUE	: out STD_LOGIC_VECTOR(7 downto 0);
		VGA_OUT_GREEN	: out STD_LOGIC_VECTOR(7 downto 0);
		VGA_OUT_RED		: out STD_LOGIC_VECTOR(7 downto 0)
      ---rgb: out std_logic_vector(2 downto 0)
   );
end vga_wrapper;

architecture Behavioral of vga_wrapper is
   --signal rgb_reg 		: std_logic_vector(2 downto 0);
	signal b_out_reg  	: STD_LOGIC_VECTOR(7 downto 0);
	signal g_out_reg 		: STD_LOGIC_VECTOR(7 downto 0);
	signal r_out_reg 		: STD_LOGIC_VECTOR(7 downto 0);
   --signal video_on		: STD_LOGIC;
	signal clk_out			: STD_LOGIC;
	signal blank_z			: STD_LOGIC;
	signal vga_addr		: STD_LOGIC_VECTOR(8 downto 0);
	signal vga_tile_line	: STD_LOGIC_VECTOR(15 downto 0);
	signal vga_tile_color: STD_LOGIC_VECTOR(15 downto 0);
	signal pixel_x			: STD_LOGIC_VECTOR (9 downto 0);
	signal pixel_y			: STD_LOGIC_VECTOR (9 downto 0);
	signal vga_data_line : STD_LOGIC_VECTOR (9 downto 0);

begin
   -- instantiate VGA sync circuit
   vga_sync_unit: entity work.vga_sync
      port map(
					clk				=> clk_out, 
					reset				=> reset, 
					hsync				=> VGA_HSYNCH,
               vsync				=> VGA_VSYNCH, 
					VGA_OUT_BLANK_Z=> blank_z,
               p_tick			=> open, 
					pixel_x			=> pixel_x, 
					pixel_y			=> pixel_y, 
					VGA_COMP_SYNCH => VGA_COMP_SYNCH);
					
	-- VGA ROM				
	vga_rom_color: entity work.vga_rom_color
		port map(  
		clk 	=> clk_out,
      addr  => vga_addr(8 downto 4),
      data	=> vga_tile_color
		);
	-- VGA Tile				
	vga_rom_tile: entity work.vga_rom_tile
		port map(  
		clk 	=> clk_out,
      addr  => vga_addr,
      data	=> vga_tile_line
		);
   -- rgb buffer
	ClockDivider_unit: entity ClockDivider
			GENERIC MAP(
			div => 2.0
			)
	      port map(clkIn=>clk, clkOut=> clk_out);
   process (clk,reset)
   begin
      if reset='1' then
         b_out_reg <= (others=>'0');
			g_out_reg <= (others=>'0');
			r_out_reg <= (others=>'0');
			-- rbg_reg <= (others=>'0');
      elsif (clk_out'event and clk_out='1') then
				b_out_reg <= "11000000";
				g_out_reg <= "11000000";
				r_out_reg <= "11000000";
			if(pixel_x > "0101000000" and pixel_x < "0101010000" and pixel_y > "0011110000" and pixel_y < "0100000000") then
--				vga_addr => x"000000000";
--				vga_data_line => vga_tile_line;
--				
--				vga_addr => vga_addr & '1';
				b_out_reg <= "10000000";
				g_out_reg <= "10000000";
				r_out_reg <= "10000000";
			else
			b_out_reg <= "00000000";
				g_out_reg <= "00000000";
				r_out_reg <= "00000000";
			end if;
--			if (SW_i = "000") then
--				b_out_reg <= "00000000";
--				g_out_reg <= "00000000";
--				r_out_reg <= "00000000";
--			end if;
      end if;
   end process;
   --rgb <= rgb_reg when video_on='1' else "000";
	VGA_OUT_PIXEL_CLOCK <= clk_out;
	VGA_OUT_BLANK_Z <= blank_z;
	VGA_OUT_BLUE <= b_out_reg when blank_z='1' else "00000000";
	VGA_OUT_GREEN <= g_out_reg when blank_z='1' else "00000000";
	VGA_OUT_RED <= r_out_reg when blank_z='1' else "00000000";

end Behavioral;

