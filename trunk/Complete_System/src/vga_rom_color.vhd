library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity vga_rom_tile_color is
   port(
      clk: in std_logic;
      addr: in std_logic_vector(4 downto 0);
      data: out std_logic_vector(15 downto 0)
   );
end vga_rom_tile_color;

architecture arch of vga_rom_tile_color is
   constant ADDR_WIDTH: integer:=5;
   constant DATA_WIDTH: integer:=16;
   type rom_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);
   -- ROM definition
   constant TILE_COLOR_ROM: rom_type:=(  -- 2^4-by-7
-----------------------------------------
-- Memory data for color for tiles --
-----------------------------------------

-- Bytes 0 to 7 of color for tiles 0 to 3
-- Frontcolor is 15 to 8 Background is 7 to 0
X"FFAA",X"0000",X"0000",X"0000",
-- Bytes 0 to 7 of color for tiles 4 to 7
X"0000",X"0000",X"0000",X"0000",
-- Bytes 0 to 7 of color for tiles 8 to 11
X"0000",X"0000",X"0000",X"0000",
-- Bytes 0 to 7 of color for tiles 12 to 15
X"0000",X"0000",X"0000",X"0000",
-- Bytes 0 to 7 of color for tiles 16 to 19
X"0000",X"0000",X"0000",X"0000",
-- Bytes 0 to 7 of color for tiles 20 to 23
X"0000",X"0000",X"0000",X"0000",
-- Bytes 0 to 7 of color for tiles 24 to 27
X"0000",X"0000",X"0000",X"0000",
-- Bytes 0 to 7 of color for tiles 28 to 31
X"0000",X"0000",X"0000",X"0000");
   signal addr_reg: std_logic_vector(ADDR_WIDTH-1 downto 0);
begin
   -- addr register to infer block RAM
   process (clk)
   begin
      if (clk'event and clk = '1') then
        addr_reg <= addr;
      end if;
   end process;
   data <= TILE_COLOR_ROM(to_integer(unsigned(addr_reg)));
end arch;