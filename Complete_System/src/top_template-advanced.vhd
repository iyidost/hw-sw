-- -----------------------------------------------------------------------------
--
--  Title      :  Template for the LC3 system
--             :
--  Developers :  Edgar Lakis s081553@student.dtu.dk
--             :
--  Revision   :  1.0    06-01-10    Initial version
--             :
--  Notes      :  Look for comments marked "<<<" ">>>", they mark places where
--             :  customisation can be applied.
--
-- -----------------------------------------------------------------------------

Library UNISIM;
use UNISIM.vcomponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_bit.all;


entity system_complete is
   port (
      clk100					: in  std_logic;          -- 100 MHZ system clock
      -- <<< Comment out unused signals: >>>
      -- serial   
      rx							: in std_logic;
      tx							: out std_logic;
      -- I/O board
      sw_i						: in std_logic_vector (7 downto 0);
      btn_i						: in std_logic_vector (4 downto 0);
      led						: out std_logic_vector (7 downto 0);
      ledg						: out std_logic;
      seg						: out std_logic_vector (7 downto 0);
      an							: out std_logic_vector (3 downto 0);
		
      -- main board buttons/switches/leds (These are active LOW: enabled is '0')
      mb_sw_i					: in std_logic_vector (3 downto 0);
      mb_btn_i					: in std_logic_vector (4 downto 0);
      mb_led_o					: out std_logic_vector (3 downto 0);
		
		--- VGA main board
		vsync_out				: out STD_LOGIC;
		hsync_out 				: out STD_LOGIC;
		comp_synch				: out STD_LOGIC;
		blank_out				: out STD_LOGIC;
		pixelclk_out			: out STD_LOGIC;
		b_out						: out STD_LOGIC_VECTOR(7 downto 0);
		g_out						: out STD_LOGIC_VECTOR(7 downto 0);
		r_out						: out STD_LOGIC_VECTOR(7 downto 0);
		
		-- A/D Converter for Steering Wheel
		nCS      				: out std_logic;
		SDATA1      			: in std_logic;
		SCLK     				: out std_logic;
		
		-- Vibrator
		vibe						: out std_logic
   );
end system_complete;

architecture Behavioral of system_complete is
   
-------------------------------------------------------------------------------
-- I/O constants for addr from 0xFE00 to 0xFFFF:
-- If 7 MSB of an address are '1': 9 least significant bits of address determine the I/O device 
   
subtype lc3_io_bits is natural range 8 downto 0;
------------------------------
constant IO_STDIN_S   : std_logic_vector(lc3_io_bits) := "0" & X"00";  -- Keyboard status register
constant IO_STDIN_D   : std_logic_vector(lc3_io_bits) := "0" & X"02";  -- Keyboard data register
constant IO_STDOUT_S  : std_logic_vector(lc3_io_bits) := "0" & X"04";  -- Display status register
constant IO_STDOUT_D  : std_logic_vector(lc3_io_bits) := "0" & X"06";  -- Display data register
constant IO_SW_S      : std_logic_vector(lc3_io_bits) := "0" & X"08"; 
constant IO_SW_D      : std_logic_vector(lc3_io_bits) := "0" & X"0A";  -- Switches
constant IO_BTN_S     : std_logic_vector(lc3_io_bits) := "0" & X"0c"; 
constant IO_BTN_D     : std_logic_vector(lc3_io_bits) := "0" & X"0e";  -- Buttons
constant IO_SSEG_S    : std_logic_vector(lc3_io_bits) := "0" & X"10";
constant IO_SSEG_D    : std_logic_vector(lc3_io_bits) := "0" & X"12";  -- 7 segment
constant IO_LED_S     : std_logic_vector(lc3_io_bits) := "0" & X"14";
constant IO_LED_D     : std_logic_vector(lc3_io_bits) := "0" & X"16";  -- Leds
constant IO_PS2KBD_S  : std_logic_vector(lc3_io_bits) := "0" & X"18";  -- PS2 keyboard
constant IO_PS2KBD_D  : std_logic_vector(lc3_io_bits) := "0" & X"1a";

-------------------------------------------------------------------------------
-- <<< Define small IO ports here if needed >>>
-------------------------------------------------------------------------------

               -- RESERVED for system use:!!! --
constant IO_INT0_CR   : std_logic_vector(lc3_io_bits) := "0" & X"f0";  -- Interrupt control registers
constant IO_INT1_CR   : std_logic_vector(lc3_io_bits) := "0" & X"f1";
constant IO_INT2_CR   : std_logic_vector(lc3_io_bits) := "0" & X"f2";
constant IO_INT3_CR   : std_logic_vector(lc3_io_bits) := "0" & X"f3";
constant IO_INT4_CR   : std_logic_vector(lc3_io_bits) := "0" & X"f4";
constant IO_INT5_CR   : std_logic_vector(lc3_io_bits) := "0" & X"f5";
constant IO_INT6_CR   : std_logic_vector(lc3_io_bits) := "0" & X"f6";
constant IO_INT7_CR   : std_logic_vector(lc3_io_bits) := "0" & X"f7";

constant IO_MCR       : std_logic_vector(lc3_io_bits) := "1" & X"FE";  -- Machine control register (for halt)
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- I/O device registers
------------------------------

------------------------------
-- Machine control register <<< Remove if not needed >>>
-- Default value: CLK_ENABLE, ~SINGLE_STEP, MASK_INT
constant MCR_INIT_VALUE : std_logic_vector(15 downto 0) := "1010"&"0000"&"0000"&"0000";
signal MCR_reg           : std_logic_vector(15 downto 0);
constant MCR_MASK_INT    : natural := 13;
constant MCR_SINGLE_STEP : natural := 14;
constant MCR_CLK_ENABLE  : natural := 15;
-- <<< set ld_MCR to '1' during bus write to MCR register >>>
signal ld_MCR            : std_logic;
------------------------------

-------------------------------------------------------------------------------
-- System control/status (the buttons/switches/leds on main board)
------------------------------
signal mb_led : std_logic_vector(3 downto 0);
signal mb_sw : std_logic_vector(3 downto 0);
-- "Enter" & "Left" & "Down" & "Right" & Up
signal mb_btn : std_logic_vector(4 downto 0);
alias sys_reset : std_logic is mb_btn(4);  -- Enter
alias sys_program : std_logic is mb_btn(3);  -- Left
alias sys_halt : std_logic is mb_btn(1);   -- Right
-- edge detection on halt button
signal sys_halt_delay: std_logic;
alias hand_clk: std_logic is btn_i(4);
signal hand_clk_delay: std_logic;
signal hand_clk_pulse: std_logic;
signal cpu_clk_enable : std_logic;
------------------------------


-------------------------------------------------------------------------------
------------------------------
-- Clocks
signal cpu_clk: std_logic;

------------------------------
-- Bus Wires
signal bus_address: std_logic_vector(15 downto 0);
signal bus_data: std_logic_vector(15 downto 0);
signal bus_RE, bus_WE:  std_logic;
signal mem_RE, mem_WE:  std_logic;
signal uart_RE, uart_WE:  std_logic;
------------------------------
-- Misc Wires
signal sseg_out: std_logic_vector(15 downto 0);
signal sys_halted: std_logic;
signal tx_full: std_logic;
signal rx_empty: std_logic;
-------------------------------------------------------------------------------
-- Registers for I/O
signal sseg_reg: std_logic_vector(15 downto 0);
signal leds_reg: std_logic_vector(7 downto 0);

-- Steering Wheel wires
signal steer_wheel_start: std_logic;
signal steer_wheel_done: std_logic;
signal steer_wheel_data: std_logic_vector(11 downto 0);

-- VGA
signal vga_car_x: std_logic_vector(9 downto 0);
signal vga_obstacle1_x: std_logic_vector (9 downto 0);
signal vga_obstacle1_y: std_logic_vector (9 downto 0);
signal vga_obstacle2_x: std_logic_vector (9 downto 0);
signal vga_obstacle2_y: std_logic_vector (9 downto 0);
signal vga_obstacle3_x: std_logic_vector (9 downto 0);
signal vga_obstacle3_y: std_logic_vector (9 downto 0);
signal vga_refresh_tick: std_logic;

signal ROM_read: std_logic_vector(13 downto 0);



component lc3 is
   port (
      clk        : in    std_logic;
      clk_enable : in    std_logic;
      reset      : in    std_logic;
      program    : in    std_logic;
      addr       : out   std_logic_vector(15 downto 0);
      data       : inout std_logic_vector(15 downto 0);
      RE         : out   std_logic;
      WE         : out   std_logic);
end component lc3;

   constant CPU_ClkDiv : natural := 1;

begin

----------------------------------
-- Fiddling with Clocks
----------------------------------
-- It might be that LC3 system will not be able to run at 100 MHz.
-- If this is the case "Timing constraint violation" error will be reported
-- during synthesis. Adjust CPU_ClkDiv constant to slow down the clock for LC3.
--
-- NOTE! You should use "cpu_clk" instead of "clk100" for all the parts used by
-- LC3 CPU: registers and RAM ports
--------------------------------------------------------------------------------
   -- Set clock for LC3. 
   --   1 == 10 ns, 100 MHz    (No division is made.)
   --   2 == 20 ns, 50 MHz
   --   3 == 30 ns, 33.33 MHz
   --   4 == 40 ns, 25 MHz
   --   5 == 50 ns, 20 MHz
   --   6 == 60 ns, 16.67 MHz
   --   7 == 70 ns, 14.29 MHz
   --   8 == 80 ns, 12.5 MHz
   --     ...
   --   Note: DCM is used for clock division, so clock distribution and timing
   --         constraints are dealt with.
   --
   
   -- Generate clock for Accelerator
   -- Use ACC_ClkDiv constant at top of the file
   Div_ACC_clk : entity work.ClockDivider
      generic map (
         div => real(CPU_ClkDiv))
      port map (
         clkIn  => clk100,
         clkOut => cpu_clk 
         );

sys_halted <= not MCR_reg(MCR_CLK_ENABLE);
cpu_clk_enable <= hand_clk_pulse when sys_halted='1' else '1';
   
-------------------------------------------------------------------------------
-- <<< Instantiatiate your components here >>>
----------------------

-- LC3 CPU
lc3_1: lc3
port map (
    clk        => cpu_clk,
    clk_enable => cpu_clk_enable,
    reset      => sys_reset,
    program    => sys_program,
    addr       => bus_address,
    data       => bus_data,
    WE         => bus_WE,
    RE         => bus_RE 
    );
	 
-- Memory
memory_wrapper : entity work.memory_wrapper
	port map (
		clk			=> cpu_clk,
		WE 			=> bus_WE,
		RE 			=> bus_RE,
		addr 			=> bus_address,
		data_inout 	=> bus_data
--		switches		=> sw_i,
--		buttons		=> btn_i,
--		leds_reg		=> leds_reg
		);
		
-- Disp
disp_hex_mux : entity work.disp_hex_mux
	port map (
		clk		=> cpu_clk,
		reset 	=> sys_reset,
		hex0 		=> sseg_out(3 downto 0),
		hex1 		=> sseg_out(7 downto 4),
		hex2 		=> sseg_out(11 downto 8),
		hex3 		=> sseg_out(15 downto 12),
		dp_in		=> "1111", -- Dots is not used and should always be off
		an			=> an,
		sseg		=> seg
		);


-- UART WRAPPER
uart_wrapper : entity work.uart_wrapper
	port map (
	   clk			=> cpu_clk,
		reset			=> sys_reset,
      rd_uart		=> uart_RE,
		wr_uart		=> uart_WE,
      rx				=> rx,
		tx				=> tx,
		tx_full		=> tx_full,
		rx_empty 	=> rx_empty,
		data_inout	=> bus_data
		);
		
-- Steering Wheel A/D converter
steeringwheel_ad : entity work.steeringwheel_ad
	port map (
		clk 		=> cpu_clk,
		rst 		=> sys_reset,
		start 	=> steer_wheel_start,
		done 		=> steer_wheel_done,
		data1 	=> steer_wheel_data,
		SDATA1	=> SDATA1,
		nCS		=> nCS,
		SCLK 		=> SCLK
	);

-- VGA WRAPPER
vga_wrapper : entity work.vga_wrapper
   port map (
	   clk					=> cpu_clk,
		reset					=> sys_reset,
		VGA_VSYNCH			=> vsync_out,
		VGA_HSYNCH			=> hsync_out,
		VGA_COMP_SYNCH		=> comp_synch,
		VGA_OUT_BLANK_Z	=> blank_out,
		VGA_OUT_PIXEL_CLOCK => pixelclk_out,
		VGA_OUT_BLUE		=> b_out,
		VGA_OUT_GREEN		=> g_out,
		VGA_OUT_RED			=> r_out,
		car_x_input			=> vga_car_x,
		obstacle1_x_input	=> vga_obstacle1_x,
		obstacle1_y_input	=> vga_obstacle1_y,
		obstacle2_x_input	=> vga_obstacle2_x,
		obstacle2_y_input	=> vga_obstacle2_y,
		obstacle3_x_input	=> vga_obstacle3_x,
		obstacle3_y_input	=> vga_obstacle3_y
--		refresh_tick		=> vga_refresh_tick
   );

-------------------------------------------------------------------------------
-- System Buttons logic
-- <<< Remove if not needed >>>
process(cpu_clk, sys_reset)
begin
   if (sys_reset='1') then
      -- System Control
      MCR_reg <= MCR_INIT_VALUE;
      sys_halt_delay <= '0';
      hand_clk_delay <= '0';
   elsif (cpu_clk'event and cpu_clk='1') then
      sys_halt_delay <= sys_halt;
      hand_clk_delay <= hand_clk;
      -- Hand clock pulse
      hand_clk_pulse <= hand_clk and not hand_clk_delay;
      --MCR control from programs
      if ld_MCR='1' then
         MCR_reg <= bus_data;
      end if;
      if sys_program='1' and sys_halt='0' then
         MCR_reg(MCR_CLK_ENABLE) <= '1';
      elsif sys_halt='1' and sys_halt_delay='0' then
         --Halt toggle-button
         MCR_reg(MCR_CLK_ENABLE) <= not MCR_reg(MCR_CLK_ENABLE);
      end if;
   end if;
end process;

-------------------------------------------------------------------------------
-- On chip debugging controll
-- <<< Remove if not needed >>>

sseg_out <= sseg_reg when sys_halted='0' else
            bus_address when sys_halted='1' and btn_i(0)='0' else
				bus_data when sys_halted='1' and btn_i(0)='1';

led <= leds_reg when sys_halted='0' else
       bus_RE & bus_WE & "000000";

mb_led <= MCR_reg(MCR_CLK_ENABLE) & "000";
mb_led_o <= not mb_led;

-------------------------------------------------------------------------------

mb_btn <= not mb_btn_i;           -- active low
mb_sw <= not mb_sw_i;             -- active low

-- Chip selector----------------------------------
uart_RE <= '1' when bus_RE = '1' AND bus_address = x"FE02" else '0';
uart_WE <= '1' when bus_WE = '1' AND bus_address = x"FE06" else '0';

bus_data <= not rx_empty & "000000000000000" when bus_address = x"FE00" else (others => 'Z');
bus_data <= not tx_full & "000000000000000" when bus_address = x"FE04" else (others => 'Z');

-- Steering Wheel -------------------------------------------------------------
-- Status register
steer_wheel_start <= '1' when bus_address = x"FE18" else '0';
bus_data <= steer_wheel_done & "000000000000000" when bus_address = x"FE18" else (others => 'Z');

-- VGA Refresh tick for timing on C++
bus_data <= vga_refresh_tick & "000000000000000" when bus_address = x"FE2A" else (others => 'Z');

-- VGA
process(cpu_clk)
begin
if (cpu_clk'event and cpu_clk='1') then
      if bus_WE='1' and bus_address = x"FE1C" then
			vga_car_x <= bus_data(9 downto 0);
		end if;
      if bus_WE='1' and bus_address = x"FE1E" then
			vga_obstacle1_x <= bus_data(9 downto 0);
		end if;
      if bus_WE='1' and bus_address = x"FE20" then
			vga_obstacle1_y <= bus_data(9 downto 0);
		end if;
		if bus_WE='1' and bus_address = x"FE22" then
			vga_obstacle2_x <= bus_data(9 downto 0);
		end if;
      if bus_WE='1' and bus_address = x"FE24" then
			vga_obstacle2_y <= bus_data(9 downto 0);
		end if;
		if bus_WE='1' and bus_address = x"FE26" then
			vga_obstacle3_x <= bus_data(9 downto 0);
		end if;
      if bus_WE='1' and bus_address = x"FE28" then
			vga_obstacle3_y <= bus_data(9 downto 0);
		end if;
		if bus_WE='1' and bus_address = x"FE2C" then
			vibe <= bus_data(0);
		end if;
   end if;
end process;

--vga_addr <= bus_data (8 downto 0) when bus_address = x"FE30";

-- Data register
bus_data <= steer_wheel_data & "0000" when bus_address = x"FE1A" else (others => 'Z');

-- DIO4 Board -----------------------------------------------------------------
bus_data <= sw_i & "00000000" when bus_address = x"FE0A" AND bus_RE = '1' else (others => 'Z');
bus_data <= btn_i & "00000000000" when bus_address = x"FE0E" AND bus_RE = '1' else (others => 'Z');
sseg_reg <= bus_data when bus_address = x"FE12" AND bus_WE = '1' else (others => 'Z');
leds_reg <= bus_data(7 downto 0) when bus_address = x"FE16" AND bus_WE = '1' else (others => 'Z');

-- set values for unused ports
ledg <= '1';

end Behavioral;

