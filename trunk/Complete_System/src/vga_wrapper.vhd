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
		VGA_OUT_RED		: out STD_LOGIC_VECTOR(7 downto 0);
		car_x_input		: in STD_LOGIC_VECTOR(9 downto 0)
		--btn_i				: in STD_LOGIC_VECTOR( 4 downto 0)
      ---rgb: out std_logic_vector(2 downto 0)
   );
end vga_wrapper;

architecture Behavioral of vga_wrapper is
	signal refr_tick: std_logic;
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
	signal car_color		: STD_LOGIC_VECTOR (7 downto 0);
	
	signal car_on			: STD_LOGIC;
	
	constant MAX_X: integer:=640;
   constant MAX_Y: integer:=480;
	constant car_x_size	: integer:= 64;
   constant car_velocity: integer:=4;
	constant car_y_top		: integer:= 300;
	constant car_y_bottom	: integer:= 396;
--	constant car_x_left	: integer:= MAX_X/2 - car_x_size/2; 
--	constant car_x_right	: integer:= car_x_left + car_x_size - 1;
	signal 	car_x_left, car_x_right: unsigned(9 downto 0);
	signal car_x_reg, car_x_next: unsigned(9 downto 0);

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
			car_x_reg <= (others=>'0');
--         b_out_reg <= (others=>'0');
--			g_out_reg <= (others=>'0');
--			r_out_reg <= (others=>'0');
      elsif (clk_out'event and clk_out='1') then
			car_x_reg <= car_x_next;
--				b_out_reg <= "11000000";
--				g_out_reg <= "11000000";
--				r_out_reg <= "11000000";
--			if(pixel_x > "0101000000" and pixel_x < "0101010000" and pixel_y > "0011110000" and pixel_y < "0100000000") then
----				vga_addr => x"000000000";
----				vga_data_line => vga_tile_line;
----				
----				vga_addr => vga_addr & '1';
--				b_out_reg <= "10000000";
--				g_out_reg <= "10000000";
--				r_out_reg <= "10000000";
--			else
--				b_out_reg <= "00000000";
--				g_out_reg <= "00000000";
--				r_out_reg <= "00000000";
--			end if;

      end if;
   end process;
	car_x_left <= car_x_reg;
	car_x_right <= car_x_left + car_x_size -1;

---- her skal ligge noget code fra pong graph til at flytte car.
   car_on <=
      '1' when (car_x_left<=unsigned(pixel_x)) and (unsigned(pixel_x)<=car_x_right) and
               (car_y_top<=pixel_y) and (pixel_y<=car_y_bottom) else
      '0';
   car_color <= "11011010";

	
	   -- rgb multiplexing circuit
   process(car_on,car_color)
   begin
      if car_on='1' then
				r_out_reg <= car_color(7 downto 5) & "00000";
				g_out_reg <= car_color(4 downto 2) & "00000";
				b_out_reg <= car_color(1 downto 0) & "000000";
--         rgb <= car_rgb;
      else
         r_out_reg <= "00000000";
			g_out_reg <= "00000000";
			b_out_reg <= "00000000";
      end if;
   end process;
	
	   -- new car x-position
   process(car_x_reg,car_x_left,car_x_right,refr_tick,car_x_input)
   begin
      car_x_next <= car_x_reg; -- no move
      if refr_tick='1' then
--         if btn_i(1)='1' and car_x_right<(MAX_X-1-car_velocity) then
--            car_x_next <= car_x_reg + car_velocity; -- move down
--         elsif btn_i(0)='1' and car_x_left > car_velocity then
--            car_x_next <= car_x_reg - car_velocity; -- move up
--         end if;
				  car_x_next <= unsigned(car_x_input);
      end if;
   end process;
	
	 refr_tick <= '1' when (pixel_y=481) and (pixel_x=0) else '0';
	
   --rgb <= rgb_reg when video_on='1' else "000";
	VGA_OUT_PIXEL_CLOCK <= clk_out;
	VGA_OUT_BLANK_Z <= blank_z;
	VGA_OUT_BLUE <= b_out_reg when blank_z='1' else "00000000";
	VGA_OUT_GREEN <= g_out_reg when blank_z='1' else "00000000";
	VGA_OUT_RED <= r_out_reg when blank_z='1' else "00000000";

end Behavioral;

