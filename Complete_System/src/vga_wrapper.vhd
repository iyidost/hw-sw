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
      clk, reset			: in std_logic;	
      --hsync, vsync		: out STD_LOGIC;
		VGA_VSYNCH			: out STD_LOGIC;
		VGA_HSYNCH			: out STD_LOGIC;
		VGA_COMP_SYNCH		: out STD_LOGIC;
		VGA_OUT_BLANK_Z	: out STD_LOGIC;
		VGA_OUT_PIXEL_CLOCK : out STD_LOGIC;
		VGA_OUT_BLUE		: out STD_LOGIC_VECTOR(7 downto 0);
		VGA_OUT_GREEN		: out STD_LOGIC_VECTOR(7 downto 0);
		VGA_OUT_RED			: out STD_LOGIC_VECTOR(7 downto 0);
	--	ROM_read				: in STD_LOGIC_VECTOR (14 downto 0);
		car_x_input			: in STD_LOGIC_VECTOR(9 downto 0);
		obstacle1_x_input	: in STD_LOGIC_VECTOR(9 downto 0);
		obstacle1_y_input	: in STD_LOGIC_VECTOR(9 downto 0);
		obstacle2_x_input	: in STD_LOGIC_VECTOR(9 downto 0);
		obstacle2_y_input	: in STD_LOGIC_VECTOR(9 downto 0);
		obstacle3_x_input	: in STD_LOGIC_VECTOR(9 downto 0);
		obstacle3_y_input	: in STD_LOGIC_VECTOR(9 downto 0);
		--middle_line outcommented by Mini 18/1 kl. 16:25 to be able to compile
		--- this value is how fast the tiles and middle line have to move.
		movement_pixel		: in STD_LOGIC_VECTOR(7 downto 0);
		refresh_tick		: out std_logic
   );
end vga_wrapper;

architecture Behavioral of vga_wrapper is
	
	constant MAX_X: integer:=640;
   constant MAX_Y: integer:=480;
	
	signal refr_tick		: std_logic;
	signal b_out_reg  	: STD_LOGIC_VECTOR(7 downto 0);
	signal g_out_reg 		: STD_LOGIC_VECTOR(7 downto 0);
	signal r_out_reg 		: STD_LOGIC_VECTOR(7 downto 0);
   --signal video_on		: STD_LOGIC;
	signal clk_out			: STD_LOGIC;
	signal blank_z			: STD_LOGIC;

	signal pixel_x			: STD_LOGIC_VECTOR (9 downto 0);
	signal pixel_x_reg1	: STD_LOGIC_VECTOR (9 downto 0);
	signal pixel_x_reg2	: STD_LOGIC_VECTOR (9 downto 0);
	signal pixel_y			: STD_LOGIC_VECTOR (9 downto 0);
	signal car_color		: STD_LOGIC_VECTOR (7 downto 0);
	signal obstacle1_color: STD_LOGIC_VECTOR (7 downto 0);
	signal obstacle2_color: STD_LOGIC_VECTOR (7 downto 0);
	signal obstacle3_color: STD_LOGIC_VECTOR (7 downto 0);
	
	signal car_on						: STD_LOGIC;
	signal car_inverted_on			: STD_LOGIC;
	signal obstacle1_on				: STD_LOGIC;
	signal obstacle1_inv_on			: STD_LOGIC;
	signal obstacle2_on				: STD_LOGIC;
	signal obstacle3_on				: STD_LOGIC;
	signal middle_line_on			: STD_LOGIC;

-- Car constant and signal
	constant car_y_size	: integer:= 64;
   constant car_velocity: integer:=4;
	signal 	car_y_top		: unsigned(9 downto 0);
	signal 	car_y_bottom	: unsigned(9 downto 0);
	constant car_x_left		: integer:= 530;
	signal 	car_x_left_v	: STD_LOGIC_VECTOR(9 downto 0);
	constant	car_x_right		: integer:= 625;
	signal car_y_reg, car_y_next: unsigned(9 downto 0);
	
-- Car invert constant and signal
	constant car_inv_y_size	: integer:= 64;
   constant car_inv_velocity: integer:=4;
	signal 	car_inv_y_top		: unsigned(9 downto 0);
	signal 	car_inv_y_bottom	: unsigned(9 downto 0);
	constant car_inv_x_left		: integer:= 530;
	signal 	car_inv_x_left_v	: STD_LOGIC_VECTOR(9 downto 0);
	constant	car_inv_x_right		: integer:= 625;
	signal car_inv_y_reg, car_inv_y_next: unsigned(9 downto 0);
	
-- Obstacle1 constant and signal
	constant obstacle1_x_size	: integer:= 96;
	constant obstacle1_y_size	: integer:= 48;
	--X axis
	signal 	obstacle1_x_left, obstacle1_x_right: unsigned(9 downto 0);
	signal 	obstacle1_x_reg, obstacle1_x_next: unsigned(9 downto 0);
	--y axis
	signal 	obstacle1_y_top, obstacle1_y_bottom: unsigned(9 downto 0);
	signal 	obstacle1_y_reg, obstacle1_y_next: unsigned(9 downto 0);
	
-- Obstacle1_inv constant and signal
	constant obstacle1_inv_x_size	: integer:= 96;
	constant obstacle1_inv_y_size	: integer:= 48;
	--X axis
	signal 	obstacle1_inv_x_left, obstacle1_inv_x_right: unsigned(9 downto 0);
	signal 	obstacle1_inv_x_reg, obstacle1_inv_x_next: unsigned(9 downto 0);
	--y axis
	signal 	obstacle1_inv_y_top, obstacle1_inv_y_bottom: unsigned(9 downto 0);
	signal 	obstacle1_inv_y_reg, obstacle1_inv_y_next: unsigned(9 downto 0);
	
	
	-- Obstacle2 constant and signal
	constant obstacle2_x_size	: integer:= 96;
	constant obstacle2_y_size	: integer:= 64;
	--X axis
	signal 	obstacle2_x_left, obstacle2_x_right: unsigned(9 downto 0);
	signal 	obstacle2_x_reg, obstacle2_x_next: unsigned(9 downto 0);
	--y axis
	signal 	obstacle2_y_top, obstacle2_y_bottom: unsigned(9 downto 0);
	signal 	obstacle2_y_reg, obstacle2_y_next: unsigned(9 downto 0);
	
-- Obstacle2_inv constant and signal
	constant obstacle2_inv_x_size	: integer:= 96;
	constant obstacle2_inv_y_size	: integer:= 64;
	--X axis
	signal 	obstacle2_inv_x_left, obstacle2_inv_x_right: unsigned(9 downto 0);
	signal 	obstacle2_inv_x_reg, obstacle2_inv_x_next: unsigned(9 downto 0);
	--y axis
	signal 	obstacle2_inv_y_top, obstacle2_inv_y_bottom: unsigned(9 downto 0);
	signal 	obstacle2_inv_y_reg, obstacle2_inv_y_next: unsigned(9 downto 0);

-- Obstacle3 constant and signal
	constant obstacle3_x_size	: integer:= 128;
	constant obstacle3_y_size	: integer:= 64;
	--X axis
	signal 	obstacle3_x_left, obstacle3_x_right: unsigned(9 downto 0);
	signal 	obstacle3_x_reg, obstacle3_x_next: unsigned(9 downto 0);
	--y axis
	signal 	obstacle3_y_top, obstacle3_y_bottom: unsigned(9 downto 0);
	signal 	obstacle3_y_reg, obstacle3_y_next: unsigned(9 downto 0);

-- Tile signal
	signal bit_addr			: STD_LOGIC_VECTOR(3 downto 0);
	signal tile_row_addr		: STD_LOGIC_VECTOR(3 downto 0);
	signal tile_addr			: STD_LOGIC_VECTOR(4 downto 0);
	signal tile_bit			: STD_LOGIC;
	signal vga_tile_line		: STD_LOGIC_VECTOR(15 downto 0);
	signal vga_tile_color	: STD_LOGIC_VECTOR(15 downto 0);
	signal vga_data_line 	: STD_LOGIC_VECTOR (8 downto 0);
	signal vga_addr			: STD_LOGIC_VECTOR(8 downto 0);
--- Car signal
	signal vga_car_addr	: STD_LOGIC_VECTOR(8 downto 0);
	signal vga_car_data	: STD_LOGIC_VECTOR(15 downto 0);
	signal vga_car_bit	: STD_LOGIC;
	signal car_bit_add	: STD_LOGIC_VECTOR(3 downto 0);
	signal vga_car_row	: STD_LOGIC_VECTOR(9 downto 0);
	signal vga_car_column: STD_LOGIC_VECTOR(9 downto 0);
--- Car invert signal
	signal vga_car_inv_addr	: STD_LOGIC_VECTOR(8 downto 0);
	signal vga_car_inv_data	: STD_LOGIC_VECTOR(15 downto 0);
	signal vga_car_inv_bit	: STD_LOGIC;

--- Obstacle 1 Sprite
	signal vga_obstacle1_addr	: STD_LOGIC_VECTOR(8 downto 0);
	signal vga_obstacle1_data	: STD_LOGIC_VECTOR(15 downto 0);
	signal vga_obstacle1_bit	: STD_LOGIC;
	signal obstacle1_bit_add	: STD_LOGIC_VECTOR(3 downto 0);
	signal vga_obstacle1_row	: STD_LOGIC_VECTOR(9 downto 0);
	signal vga_obstacle1_column: STD_LOGIC_VECTOR(9 downto 0);
	
--- Obstacle 1 invert signal
	signal vga_obstacle1_inv_addr		: STD_LOGIC_VECTOR(8 downto 0);
	signal vga_obstacle1_inv_data		: STD_LOGIC_VECTOR(15 downto 0);
	signal vga_obstacle1_inv_bit		: STD_LOGIC;

	
--- Obstacle 2 Sprite
	signal vga_obstacle2_addr	: STD_LOGIC_VECTOR(8 downto 0);
	signal vga_obstacle2_data	: STD_LOGIC_VECTOR(15 downto 0);
	signal vga_obstacle2_bit	: STD_LOGIC;
	signal obstacle2_bit_add	: STD_LOGIC_VECTOR(3 downto 0);
	signal vga_obstacle2_row	: STD_LOGIC_VECTOR(9 downto 0);
	signal vga_obstacle2_column: STD_LOGIC_VECTOR(9 downto 0);
	
--- Obstacle 3 Sprite
	signal vga_obstacle3_addr	: STD_LOGIC_VECTOR(8 downto 0);
	signal vga_obstacle3_data	: STD_LOGIC_VECTOR(15 downto 0);
	signal vga_obstacle3_bit	: STD_LOGIC;
	signal obstacle3_bit_add	: STD_LOGIC_VECTOR(3 downto 0);
	signal vga_obstacle3_row	: STD_LOGIC_VECTOR(9 downto 0);
	signal vga_obstacle3_column: STD_LOGIC_VECTOR(9 downto 0);

	constant middle_line_top1		: integer:= 224;
	constant middle_line_buttom1	: integer:= 236;
	constant middle_line_top2		: integer:= 244;
	constant middle_line_buttom2	: integer:= 256;
	signal pixel_x_movement : STD_LOGIC_VECTOR(9 downto 0);
	constant middle_line_lenght_x : integer:= 96;
	constant middle_line_wide_space :integer := 112;

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
					
	--- VGA ROM TILE COLOR				
	vga_rom_tile_color: entity work.vga_rom_tile_color
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
	-- VGA ROM CAR 
	vga_rom_car: entity work.vga_rom_car
		port map(
			clk 	=> clk_out,
			addr  => vga_car_addr,
			data	=> vga_car_data
		);
	-- VGA ROM CAR INVERT
	vga_rom_car_inv: entity work.vga_rom_car_inv
		port map(
			clk 	=> clk_out,
			addr  => vga_car_inv_addr,
			data	=> vga_car_inv_data
		);
	-- VGA ROM OBSTACLE 1
	vga_rom_obstacle1: entity work.vga_rom_obstacle1
		port map (
			clk 	=> clk_out,
			addr  => vga_obstacle1_addr,
			data	=> vga_obstacle1_data
		);
		
	-- VGA ROM OBSTACLE 1 inverted
	vga_rom_obstacle1_inv: entity work.vga_rom_obstacle1_inv
		port map (
			clk 	=> clk_out,
			addr  => vga_obstacle1_inv_addr,
			data	=> vga_obstacle1_inv_data
		);
		
	-- VGA ROM OBSTACLE 2
	vga_rom_obstacle2: entity work.vga_rom_obstacle2
		port map (
			clk 	=> clk_out,
			addr  => vga_obstacle2_addr,
			data	=> vga_obstacle2_data
		);

-- VGA ROM OBSTACLE 2 inverted
	vga_rom_obstacle2_inv: entity work.vga_rom_obstacle2_inv
		port map (
			clk 	=> clk_out,
			addr  => vga_obstacle2_inv_addr,
			data	=> vga_obstacle2_inv_data
		);
		
	-- VGA ROM OBSTACLE 3
	vga_rom_obstacle3: entity work.vga_rom_obstacle3
		port map (
			clk 	=> clk_out,
			addr  => vga_obstacle3_addr,
			data	=> vga_obstacle3_data
		);
	-- VGA ROM OBSTACLE 3 inverted
	vga_rom_obstacle3_inv: entity work.vga_rom_obstacle3_inv
		port map (
			clk 	=> clk_out,
			addr  => vga_obstacle3_inv_addr,
			data	=> vga_obstacle3_inv_data
		
   -- rgb buffer
	ClockDivider_unit: entity ClockDivider
			GENERIC MAP(
			div => 4.0
			)
	      port map(clkIn=>clk, clkOut=> clk_out);
  process (clk_out,reset)
   begin
      if reset='1' then
			car_y_reg <= (others=>'0');
			obstacle1_x_reg <= (others=>'0');
			obstacle1_y_reg <= (others=>'0');
			obstacle2_x_reg <= (others=>'0');
			obstacle2_y_reg <= (others=>'0');
			obstacle3_x_reg <= (others=>'0');
			obstacle3_y_reg <= (others=>'0');
			pixel_x_reg1 			 <= (others=>'0');
      elsif (clk_out'event and clk_out='1') then
				car_y_reg <= car_y_next;
				obstacle1_x_reg <= obstacle1_x_next;
				obstacle1_y_reg <= obstacle1_y_next;
				obstacle2_x_reg <= obstacle2_x_next;
				obstacle2_y_reg <= obstacle2_y_next;
				obstacle3_x_reg <= obstacle3_x_next;
				obstacle3_y_reg <= obstacle3_y_next;
				pixel_x_reg1	 <= pixel_x;
				pixel_x_reg2	 <= pixel_x_reg1;
				
      end if;
   end process;
	
	pixel_x_movement <= pixel_x + movement_pixel;
	
	
	middle_line_on <=
		'1' when (((middle_line_top1 <pixel_y) and (pixel_y<middle_line_buttom1)) or
					(( middle_line_top2 <pixel_y) and (pixel_y<middle_line_buttom2))) and
					((pixel_x_movement > 0 and pixel_x_movement < 96) 
					or (pixel_x_movement > 208 and pixel_x_movement < 304) 
					or (pixel_x_movement > 416 and pixel_x_movement < 512))
					else
		'0';
	
	
	
	
	-- Tiles 
	tile_addr <= "00000" when (pixel_x_movement(4) <= '0') else
		"00001";
--tile_addr <= "00010" when (pixel_y(8 downto 4)= "01110") or (pixel_y(8 downto 4)= "01111") else
--				"00000" when (pixel_x(4)<= '0')
--			else
--		"00001";
	tile_row_addr <= pixel_y(3 downto 0);
	bit_addr <= pixel_x_movement(3 downto 0) ;
	vga_addr <= tile_addr & tile_row_addr;
	tile_bit <= vga_tile_line(to_integer(unsigned(not bit_addr)));
	
	--- Sprites
	car_y_top <= car_y_reg;
	car_y_bottom <= car_y_top + car_y_size - 1;
-- Car on signal
   car_on <=
      '1' when (car_x_left <= pixel_x_reg1) and (pixel_x_reg1  <= car_x_right) and
               (car_y_top<=unsigned(pixel_y)) and (unsigned(pixel_y)<=car_y_bottom) else
      '0';
   ---car_color <= "11011010";

	--- Car 
	--- 	signal pixel_x			: STD_LOGIC_VECTOR (9 downto 0);
	---- 	constant car_x_left		: integer:= 530;
	car_x_left_v <= STD_LOGIC_VECTOR(to_signed(car_x_left, 10));
	car_bit_add <= pixel_x_reg1 - car_x_left_v (3 downto 0);
	--- vga_car_row <= unsigned(pixel_y) - car_y_top(5 downto 4);
	vga_car_row <= pixel_y - STD_LOGIC_VECTOR(car_y_top);
	vga_car_column <= pixel_x - car_x_left_v;
	
	
	--- Row 2bit + column 3bit + line 4bit
--	vga_car_addr <= vga_car_row & vga_car_column & vga_sprite_line
	vga_car_addr <= vga_car_row(5 downto 4) & vga_car_column(6 downto 4) & vga_car_row(3 downto 0)
			when (car_x_left<=pixel_x) and (pixel_x<=car_x_right) and
			(car_y_top<=unsigned(pixel_y)) and (unsigned(pixel_y)<=car_y_bottom)
		else "000000000";
	vga_car_bit <= vga_car_data(to_integer(unsigned(not car_bit_add)));
	
	---- Car invented
	vga_car_inv_addr <= vga_car_row(5 downto 4) & vga_car_column(6 downto 4) & vga_car_row(3 downto 0)
			when (car_x_left<=pixel_x) and (pixel_x<=car_x_right) and
			(car_y_top<=unsigned(pixel_y)) and (unsigned(pixel_y)<=car_y_bottom)
		else "000000000";
	vga_car_inv_bit <= vga_car_inv_data(to_integer(unsigned(not car_bit_add)));
	

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

	-- OBSTACLE 1 drawing values
	obstacle1_bit_add <= unsigned(pixel_x_reg1) - obstacle1_x_left(3 downto 0);
	vga_obstacle1_row <= pixel_y - STD_LOGIC_VECTOR(obstacle1_y_top);
	
	vga_obstacle1_column <= unsigned(pixel_x) - obstacle1_x_left;
	
	--- Row 2bit + column 3bit + line 4bit
	vga_obstacle1_addr <= vga_obstacle1_row(5 downto 4) & vga_obstacle1_column(6 downto 4) & vga_obstacle1_row(3 downto 0)
			when (obstacle1_x_left <=unsigned( pixel_x)) and (unsigned(pixel_x) <= obstacle1_x_right) and
			(obstacle1_y_top<=unsigned(pixel_y)) and (unsigned(pixel_y)<=obstacle1_y_bottom)
		else "000000000";
	vga_obstacle1_bit <= vga_obstacle1_data(to_integer(unsigned(not obstacle1_bit_add)));
	
	---- OBSTACLE 1  inverted
	vga_obstacle1_inv_addr <= vga_obstacle1_row(5 downto 4) & vga_obstacle1_column(6 downto 4) & vga_obstacle1_row(3 downto 0)
			when (obstacle1_x_left<=unsigned(pixel_x)) and (unsigned(pixel_x)<=obstacle1_x_right) and
			(obstacle1_y_top<=unsigned(pixel_y)) and (unsigned(pixel_y)<=obstacle1_y_bottom)
		else "000000000";
	vga_obstacle1_inv_bit <= vga_obstacle1_inv_data(to_integer(unsigned(not obstacle1_bit_add)));
	
	-- OBSTACLE 2 drawing values
	obstacle2_bit_add <= unsigned(pixel_x_reg1) - obstacle2_x_left(3 downto 0);
	vga_obstacle2_row <= pixel_y - STD_LOGIC_VECTOR(obstacle2_y_top);
	

	vga_obstacle2_column <= unsigned(pixel_x) - obstacle2_x_left;
	
	--- Row 2bit + column 3bit + line 4bit
	vga_obstacle2_addr <= vga_obstacle2_row(5 downto 4) & vga_obstacle2_column(6 downto 4) & vga_obstacle2_row(3 downto 0)
			when (obstacle2_x_left <=unsigned( pixel_x)) and (unsigned(pixel_x) <= obstacle2_x_right) and
			(obstacle2_y_top<=unsigned(pixel_y)) and (unsigned(pixel_y)<=obstacle2_y_bottom)
		else "000000000";
	vga_obstacle2_bit <= vga_obstacle2_data(to_integer(unsigned(not obstacle2_bit_add)));
	
---- OBSTACLE 2  inverted
	vga_obstacle2_inv_addr <= vga_obstacle2_row(5 downto 4) & vga_obstacle2_column(6 downto 4) & vga_obstacle2_row(3 downto 0)
			when (obstacle2_x_left<=unsigned(pixel_x)) and (unsigned(pixel_x)<=obstacle2_x_right) and
			(obstacle2_y_top<=unsigned(pixel_y)) and (unsigned(pixel_y)<=obstacle2_y_bottom)
		else "000000000";
	vga_obstacle2_inv_bit <= vga_obstacle2_inv_data(to_integer(unsigned(not obstacle2_bit_add)));


	-- OBSTACLE 3 drawing values
	obstacle3_bit_add <= unsigned(pixel_x_reg1) - obstacle3_x_left(3 downto 0);
	vga_obstacle3_row <= pixel_y - STD_LOGIC_VECTOR(obstacle3_y_top);
	

	vga_obstacle3_column <= unsigned(pixel_x) - obstacle3_x_left;
	
	--- Row 2bit + column 3bit + line 4bit
	vga_obstacle3_addr <= vga_obstacle3_row(5 downto 4) & vga_obstacle3_column(6 downto 4) & vga_obstacle3_row(3 downto 0)
			when (obstacle3_x_left <=unsigned( pixel_x)) and (unsigned(pixel_x) <= obstacle3_x_right) and
			(obstacle3_y_top<=unsigned(pixel_y)) and (unsigned(pixel_y)<=obstacle3_y_bottom)
		else "000000000";
	vga_obstacle3_bit <= vga_obstacle3_data(to_integer(unsigned(not obstacle3_bit_add)));
	
---- OBSTACLE 3  inverted
	vga_obstacle3_inv_addr <= vga_obstacle3_row(5 downto 4) & vga_obstacle3_column(6 downto 4) & vga_obstacle3_row(3 downto 0)
			when (obstacle3_x_left<=unsigned(pixel_x)) and (unsigned(pixel_x)<=obstacle3_x_right) and
			(obstacle3_y_top<=unsigned(pixel_y)) and (unsigned(pixel_y)<=obstacle3_y_bottom)
		else "000000000";
	vga_obstacle3_inv_bit <= vga_obstacle3_inv_data(to_integer(unsigned(not obstacle3_bit_add)));

	

---- Obstacle1 on signal
--		obstacle1_on <=
--      '1' when (obstacle1_x_left<=unsigned(pixel_x)) and (unsigned(pixel_x)<=obstacle1_x_right) and
--               (obstacle1_y_top<=unsigned(pixel_y)) and (unsigned(pixel_y)<=obstacle1_y_bottom) else
--      '0';
--   obstacle1_color <= "11100000";

-- Obstacle2 on signal
--		obstacle2_on <=
--      '1' when (obstacle2_x_left<=unsigned(pixel_x)) and (unsigned(pixel_x)<=obstacle2_x_right) and
--               (obstacle2_y_top<=unsigned(pixel_y)) and (unsigned(pixel_y)<=obstacle2_y_bottom) else
--      '0';
--   obstacle2_color <= "00011100";

-- Obstacle3 on signal
--		obstacle3_on <=
--      '1' when (obstacle3_x_left<=unsigned(pixel_x)) and (unsigned(pixel_x)<=obstacle3_x_right) and
--               (obstacle3_y_top<=unsigned(pixel_y)) and (unsigned(pixel_y)<=obstacle3_y_bottom) else
--      '0';
--   obstacle3_color <= "11100011";

	   -- rgb multiplexing circuit
   process(vga_car_inv_bit,car_on,vga_obstacle1_bit,vga_obstacle2_bit,vga_obstacle3_bit,tile_bit,vga_tile_color)
   begin
		if 	car_on='1' and vga_car_inv_bit='1' then
				r_out_reg <= X"A9";
				g_out_reg <= X"A9";
				b_out_reg <= X"A9";
      elsif car_on='1' and vga_car_bit='1' then
---- old color DodgerBlue X"1E",X"90",X"FF"
				r_out_reg <= X"00";
				g_out_reg <= X"00";
				b_out_reg <= X"FF";
--		elsif obstacle1_on = '1' and vga_obstacle1_bit = '1' then
		elsif vga_obstacle1_inv_bit = '1' then
				r_out_reg <= X"FF";
				g_out_reg <= X"8C";
				b_out_reg <= X"00";
		elsif vga_obstacle1_bit = '1' then
				r_out_reg <= X"FF";
				g_out_reg <= X"D7";
				b_out_reg <= X"00";
		elsif vga_obstacle2_bit = '1' then
				r_out_reg <= "11111111";
				g_out_reg <= "00000000";
				b_out_reg <= "11111111";
		elsif vga_obstacle3_bit = '1' then
				r_out_reg <= X"55";
				g_out_reg <= X"6B";
				b_out_reg <= X"2F";
		elsif middle_line_on = '1' then
				r_out_reg <= "11110101";
				g_out_reg <= "11110101";
				b_out_reg <= "11110101";
      else
			if tile_bit ='1' then
				r_out_reg <= vga_tile_color(15 downto 13) & "00000";
				g_out_reg <= vga_tile_color(12 downto 10) & "00000";
				b_out_reg <= vga_tile_color(9 downto 8)   & "000000";
			else
				r_out_reg <= vga_tile_color(7 downto 5) & "00000";
				g_out_reg <= vga_tile_color(4 downto 2) & "00000";
				b_out_reg <= vga_tile_color(1 downto 0) & "000000";
			end if;
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

	refr_tick <= '1' when (pixel_y=481) and (pixel_x=0);
	refresh_tick <= refr_tick;
	
	VGA_OUT_PIXEL_CLOCK <= clk_out;
	VGA_OUT_BLANK_Z <= blank_z;
	VGA_OUT_BLUE <= b_out_reg when blank_z='1' else "00000000";
	VGA_OUT_GREEN <= g_out_reg when blank_z='1' else "00000000";
	VGA_OUT_RED <= r_out_reg when blank_z='1' else "00000000";

end Behavioral;