-- Listing 12.1
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity vga_sync is
   port(
      clk, reset					: IN STD_LOGIC;
      hsync, vsync				: OUT STD_LOGIC;
      VGA_OUT_BLANK_Z, p_tick	: OUT STD_LOGIC;
      pixel_x, pixel_y			: OUT STD_LOGIC_VECTOR (9 downto 0);
		VGA_COMP_SYNCH				: OUT STD_LOGIC 
    );
end vga_sync;

architecture arch of vga_sync is
   -- VGA 640-by-480 sync parameters
   constant HD: integer			:= 640; --horizontal display area
   constant HF: integer			:=  16; --h. front porch
   constant HB: integer			:=  48; --h. back porch
   constant HR: integer			:=  96; --h. retrace
   constant VD: integer			:= 480; --vertical display area
   constant VF: integer			:=   9;  --v. front porch
   constant VB: integer			:=  29;  --v. back porch
   constant VR: integer			:=   2;   --v. retrace
   -- mod-2 counter
   signal mod2_next	: STD_LOGIC;
	--mod2_reg, 
   -- sync counters
   signal v_count_reg, v_count_next: unsigned(9 downto 0);
   signal h_count_reg, h_count_next: unsigned(9 downto 0);
   -- output buffer
   signal v_sync_reg, h_sync_reg: STD_LOGIC;
   signal v_sync_next, h_sync_next: STD_LOGIC;
   -- status signal
   signal h_end, v_end, pixel_tick: STD_LOGIC;
begin
   -- registers
   process (clk,reset)
   begin
      if reset='1' then
         --- mod2_reg <= '0';
         v_count_reg <= (others=>'0');
         h_count_reg <= (others=>'0');
         v_sync_reg <= '0';
         h_sync_reg <= '0';
      elsif (clk'event and clk='1') then
        ---  mod2_reg <= mod2_next;
         v_count_reg <= v_count_next;
         h_count_reg <= h_count_next;
         v_sync_reg <= v_sync_next;
         h_sync_reg <= h_sync_next;
      end if;
   end process;
	mod2_next <= '1';
   -- mod-2 circuit to generate 25 MHz enable tick
    --- mod2_next <= not mod2_reg;
   -- 25 MHz pixel tick
   pixel_tick <= '1' when mod2_next='1' else '0';
   -- status
   h_end <=  -- end of horizontal counter
      '1' when h_count_reg=(HD+HF+HB+HR-1) else --799
      '0';
   v_end <=  -- end of vertical counter
      '1' when v_count_reg=(VD+VF+VB+VR-1) else --524
      '0';
   -- mod-800 horizontal sync counter
   process (h_count_reg,h_end,pixel_tick)
   begin
      if pixel_tick='1' then  -- 25 MHz tick
         if h_end='1' then
            h_count_next <= (others=>'0');
         else
            h_count_next <= h_count_reg + 1;
         end if;
      else
         h_count_next <= h_count_reg;
      end if;
   end process;
   -- mod-525 vertical sync counter
   process (v_count_reg,h_end,v_end,pixel_tick)
   begin
      if pixel_tick='1' and h_end='1' then
         if (v_end='1') then
            v_count_next <= (others=>'0');
         else
            v_count_next <= v_count_reg + 1;
         end if;
      else
         v_count_next <= v_count_reg;
      end if;
   end process;
	
	-- Jakob:  VGA_COMP_SYNCH skal altid v�re 1 http://www.hoonio.com/wiki/VHD:Display
	VGA_COMP_SYNCH <= '1'; 
   -- horizontal and vertical sync, buffered to avoid glitch
   h_sync_next <=
      '1' when (h_count_reg>=(HD+HF))           --656
           and (h_count_reg<=(HD+HF+HR-1)) else --751
      '0';
   v_sync_next <=
      '1' when (v_count_reg>=(VD+VF))           --490
           and (v_count_reg<=(VD+VF+VR-1)) else --491
      '0';
   -- video on/off --- Jakob det her var Video_on har skifte den til VGA_OUT_BLANK_Z
   VGA_OUT_BLANK_Z <=
      '1' when (h_count_reg<HD) and (v_count_reg<VD) else
      '0';
   -- output signal
   hsync <= h_sync_reg;
   vsync <= v_sync_reg;
   pixel_x <= std_logic_vector(h_count_reg);
   pixel_y <= std_logic_vector(v_count_reg);
   p_tick <= pixel_tick;
end arch;
