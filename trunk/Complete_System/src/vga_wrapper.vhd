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
	--	ROM_read			: in STD_LOGIC_VECTOR (14 downto 0);
		car_x_input		: in STD_LOGIC_VECTOR(9 downto 0);
		obstacle1_x_input: in STD_LOGIC_VECTOR(9 downto 0);
		obstacle1_y_input: in STD_LOGIC_VECTOR(9 downto 0);
		obstacle2_x_input: in STD_LOGIC_VECTOR(9 downto 0);
		obstacle2_y_input: in STD_LOGIC_VECTOR(9 downto 0);
		obstacle3_x_input: in STD_LOGIC_VECTOR(9 downto 0);
		obstacle3_y_input: in STD_LOGIC_VECTOR(9 downto 0)

		--vga_addr			: in STD_LOGIC_VECTOR(8 downto 0)
		--btn_i				: in STD_LOGIC_VECTOR( 4 downto 0)
      ---rgb: out std_logic_vector(2 downto 0)
   );
end vga_wrapper;

architecture Behavioral of vga_wrapper is
	signal refr_tick		: std_logic;
   --signal rgb_reg 		: std_logic_vector(2 downto 0);
	signal b_out_reg  	: STD_LOGIC_VECTOR(7 downto 0);
	signal g_out_reg 		: STD_LOGIC_VECTOR(7 downto 0);
	signal r_out_reg 		: STD_LOGIC_VECTOR(7 downto 0);
   --signal video_on		: STD_LOGIC;
	signal clk_out			: STD_LOGIC;
	signal blank_z			: STD_LOGIC;
	
	signal vga_tile_line	: STD_LOGIC_VECTOR(15 downto 0);
	signal vga_tile_color: STD_LOGIC_VECTOR(15 downto 0);
	signal pixel_x			: STD_LOGIC_VECTOR (9 downto 0);
	signal pixel_y			: STD_LOGIC_VECTOR (9 downto 0);
	signal vga_data_line : STD_LOGIC_VECTOR (9 downto 0);
	signal car_color		: STD_LOGIC_VECTOR (7 downto 0);
	signal obstacle1_color: STD_LOGIC_VECTOR (7 downto 0);
	signal obstacle2_color: STD_LOGIC_VECTOR (7 downto 0);
	signal obstacle3_color: STD_LOGIC_VECTOR (7 downto 0);
	
	signal car_on			: STD_LOGIC;
	signal obstacle1_on	: STD_LOGIC;
	signal obstacle2_on	: STD_LOGIC;
	signal obstacle3_on	: STD_LOGIC;
	
	constant MAX_X: integer:=640;
   constant MAX_Y: integer:=480;
	
	-- Car constant and signal
	constant car_y_size	: integer:= 64;
   constant car_velocity: integer:=4;
	signal 	car_y_top		: unsigned(9 downto 0);
	signal 	car_y_bottom	: unsigned(9 downto 0);
	constant car_x_left		: integer:= 530;
	constant	car_x_right		: integer:= 626;
	signal car_y_reg, car_y_next: unsigned(9 downto 0);
	

-- Obstacle1 constant and signal
	constant obstacle1_x_size	: integer:= 96;
	constant obstacle1_y_size	: integer:= 64;
	--   constant obstacle_velocity: integer:=4;
--	constant obstacle_x_left		: integer:= 300;
--	constant obstacle_x_right	: integer:= 364;
	--X axis
	signal 	obstacle1_x_left, obstacle1_x_right: unsigned(9 downto 0);
	signal 	obstacle1_x_reg, obstacle1_x_next: unsigned(9 downto 0);
	--y axis
	signal 	obstacle1_y_top, obstacle1_y_bottom: unsigned(9 downto 0);
	signal 	obstacle1_y_reg, obstacle1_y_next: unsigned(9 downto 0);
	
	-- Obstacle2 constant and signal
	constant obstacle2_x_size	: integer:= 64;
	constant obstacle2_y_size	: integer:= 48;
	--   constant obstacle_velocity: integer:=4;
--	constant obstacle_x_left		: integer:= 300;
--	constant obstacle_x_right	: integer:= 364;
	--X axis
	signal 	obstacle2_x_left, obstacle2_x_right: unsigned(9 downto 0);
	signal 	obstacle2_x_reg, obstacle2_x_next: unsigned(9 downto 0);
	--y axis
	signal 	obstacle2_y_top, obstacle2_y_bottom: unsigned(9 downto 0);
	signal 	obstacle2_y_reg, obstacle2_y_next: unsigned(9 downto 0);


-- Obstacle3 constant and signal
	constant obstacle3_x_size	: integer:= 64;
	constant obstacle3_y_size	: integer:= 48;
	--   constant obstacle_velocity: integer:=4;
--	constant obstacle_x_left		: integer:= 300;
--	constant obstacle_x_right	: integer:= 364;
	--X axis
	signal 	obstacle3_x_left, obstacle3_x_right: unsigned(9 downto 0);
	signal 	obstacle3_x_reg, obstacle3_x_next: unsigned(9 downto 0);
	--y axis
	signal 	obstacle3_y_top, obstacle3_y_bottom: unsigned(9 downto 0);
	signal 	obstacle3_y_reg, obstacle3_y_next: unsigned(9 downto 0);
	
	
	

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
					
	-- VGA ROM TILE COLOR				
--	vga_rom_tile_color: entity work.vga_rom_tile_color
--		port map(  
--		clk 	=> clk_out,
--      addr  => vga_addr(8 downto 4),
--      data	=> vga_tile_color
--		);
--	-- VGA Tile				
--	vga_rom_tile: entity work.vga_rom_tile
--		port map(  
--		clk 	=> clk_out,
--      addr  => vga_addr,
--      data	=> vga_tile_line
--		);
   -- rgb buffer
	ClockDivider_unit: entity ClockDivider
			GENERIC MAP(
			div => 2.0
			)
	      port map(clkIn=>clk, clkOut=> clk_out);
  process (clk,reset)
   begin
      if reset='1' then
			car_y_reg <= (others=>'0');
			obstacle1_x_reg <= (others=>'0');
			obstacle1_y_reg <= (others=>'0');
			obstacle2_x_reg <= (others=>'0');
			obstacle2_y_reg <= (others=>'0');
			obstacle3_x_reg <= (others=>'0');
			obstacle3_y_reg <= (others=>'0');
--         b_out_reg <= (others=>'0');
--			g_out_reg <= (others=>'0');
--			r_out_reg <= (others=>'0');
      elsif (clk_out'event and clk_out='1') then
				car_y_reg <= car_y_next;
				obstacle1_x_reg <= obstacle1_x_next;
				obstacle1_y_reg <= obstacle1_y_next;
				obstacle2_x_reg <= obstacle2_x_next;
				obstacle2_y_reg <= obstacle2_y_next;
				obstacle3_x_reg <= obstacle3_x_next;
				obstacle3_y_reg <= obstacle3_y_next;
--			
--			
--			if refr_tick='1' then
--				car_y_reg <= unsigned(car_x_input);
--				obstacle_x_reg <= unsigned(obstacle_x_input);
--				obstacle_y_reg <= unsigned(obstacle_y_input);
--			end if;
--			
--


      end if;
   end process;
	car_y_top <= car_y_reg;
	car_y_bottom <= car_y_top + car_y_size - 1;

-- Car on signal
   car_on <=
      '1' when (car_x_left<=pixel_x) and (pixel_x<=car_x_right) and
               (car_y_top<=unsigned(pixel_y)) and (unsigned(pixel_y)<=car_y_bottom) else
      '0';
   car_color <= "11011010";


	
	obstacle1_x_left <= obstacle1_x_reg;
	obstacle1_x_right <= obstacle1_x_left + obstacle1_x_size -1;
	obstacle1_y_top <= obstacle1_y_reg;
	obstacle1_y_bottom <= obstacle1_y_top + obstacle1_y_size -1;
   
	
	obstacle2_x_left <= obstacle2_x_reg;
	obstacle2_x_right <= obstacle2_x_left + obstacle2_x_size -1;
	obstacle2_y_top <= obstacle2_y_reg;
	obstacle2_y_bottom <= obstacle2_y_top + obstacle2_y_size -1;
	
	obstacle3_x_left <= obstacle3_x_reg;
	obstacle3_x_right <= obstacle3_x_left + obstacle3_x_size -1;
	obstacle3_y_top <= obstacle3_y_reg;
	obstacle3_y_bottom <= obstacle3_y_top + obstacle3_y_size -1;
   
	
-- Obstacle1 on signal
		obstacle1_on <=
      '1' when (obstacle1_x_left<=unsigned(pixel_x)) and (unsigned(pixel_x)<=obstacle1_x_right) and
               (obstacle1_y_top<=unsigned(pixel_y)) and (unsigned(pixel_y)<=obstacle1_y_bottom) else
      '0';
   obstacle1_color <= "11100000";



-- Obstacle2 on signal
		obstacle2_on <=
      '1' when (obstacle2_x_left<=unsigned(pixel_x)) and (unsigned(pixel_x)<=obstacle2_x_right) and
               (obstacle2_y_top<=unsigned(pixel_y)) and (unsigned(pixel_y)<=obstacle2_y_bottom) else
      '0';
   obstacle2_color <= "00011100";


-- Obstacle3 on signal
		obstacle3_on <=
      '1' when (obstacle3_x_left<=unsigned(pixel_x)) and (unsigned(pixel_x)<=obstacle3_x_right) and
               (obstacle3_y_top<=unsigned(pixel_y)) and (unsigned(pixel_y)<=obstacle3_y_bottom) else
      '0';
   obstacle3_color <= "11100011";


	

	
	   -- rgb multiplexing circuit
   process(car_on,car_color,obstacle1_on,obstacle1_color,obstacle2_on,obstacle2_color)
   begin
      if car_on='1' then
				r_out_reg <= car_color(7 downto 5) & "00000";
				g_out_reg <= car_color(4 downto 2) & "00000";
				b_out_reg <= car_color(1 downto 0) & "000000";
		elsif obstacle1_on = '1' then
				r_out_reg <= obstacle1_color(7 downto 5) & "00000";
				g_out_reg <= obstacle1_color(4 downto 2) & "00000";
				b_out_reg <= obstacle1_color(1 downto 0) & "000000";
		elsif obstacle2_on = '1' then
				r_out_reg <= obstacle2_color(7 downto 5) & "00000";
				g_out_reg <= obstacle2_color(4 downto 2) & "00000";
				b_out_reg <= obstacle2_color(1 downto 0) & "000000";
		elsif obstacle3_on = '1' then
				r_out_reg <= obstacle3_color(7 downto 5) & "00000";
				g_out_reg <= obstacle3_color(4 downto 2) & "00000";
				b_out_reg <= obstacle3_color(1 downto 0) & "000000";
--
--		elsif draw_on = '1' and vga_tile_line = '1' then
--				r_out_reg <= vga_tile_color(15 downto 13) & "00000";
--				g_out_reg <= vga_tile_color(12 downto 10) & "00000";
--				b_out_reg <= vga_tile_color(9 downto 8) & "000000";
--
--		elsif draw_on = '1' and vga_tile_line = '0' then
--				r_out_reg <= vga_tile_color(7 downto 5) & "00000";
--				g_out_reg <= vga_tile_color(4 downto 2) & "00000";
--				b_out_reg <= vga_tile_color(1 downto 0) & "000000";
      else
         r_out_reg <= "01100100";
			g_out_reg <= "01100100";
			b_out_reg <= "01100100";
      end if;
   end process;
	
--	    new car x-position
--		 new obstacle x,y-position
   process(car_y_reg,refr_tick,car_x_input,obstacle1_x_reg,obstacle1_x_input,obstacle1_y_reg,obstacle1_y_input
	,obstacle2_x_reg,obstacle2_x_input,obstacle2_y_reg,obstacle2_y_input
	,obstacle3_x_reg,obstacle3_x_input,obstacle3_y_reg,obstacle3_y_input)
   begin
      car_y_next <= car_y_reg; -- no move
		obstacle1_y_next <= obstacle1_y_reg; -- no move
		obstacle1_x_next <= obstacle1_x_reg; -- no move
		obstacle2_y_next <= obstacle2_y_reg; -- no move
		obstacle2_x_next <= obstacle2_x_reg; -- no move
		obstacle3_y_next <= obstacle3_y_reg; -- no move
		obstacle3_x_next <= obstacle3_x_reg; -- no move
      if refr_tick='1' then
--         if btn_i(1)='1' and car_x_right<(MAX_X-1-car_velocity) then
--            car_y_next <= car_y_reg + car_velocity; -- move down
--         elsif btn_i(0)='1' and car_x_left > car_velocity then
--            car_y_next <= car_y_reg - car_velocity; -- move up
--         end if;
				  car_y_next <= unsigned(car_x_input);
				  obstacle1_x_next <= unsigned(obstacle1_x_input);
				  obstacle1_y_next <= unsigned(obstacle1_y_input);
				  obstacle2_x_next <= unsigned(obstacle2_x_input);
				  obstacle2_y_next <= unsigned(obstacle2_y_input);
				  obstacle3_x_next <= unsigned(obstacle3_x_input);
				  obstacle3_y_next <= unsigned(obstacle3_y_input);
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
