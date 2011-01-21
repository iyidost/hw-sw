library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity vga_rom_obstacle2_layer3 is
   port(
      clk: in std_logic;
      addr: in std_logic_vector(8 downto 0);
      data: out std_logic_vector(15 downto 0)
   );
end vga_rom_obstacle2_layer3;

architecture arch of vga_rom_obstacle2_layer3 is
   constant ADDR_WIDTH: integer:=9;
   constant DATA_WIDTH: integer:=16;
   type rom_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);
   -- ROM definition
   constant obstacle2_ROM: rom_type:=(  -- 2^9-by-16
-- OBSTACLE2 
-- Tile #1
X"0000",X"0000",X"0000",X"03FF",X"07FF",X"0FFF",X"1FFF",X"1FFF",X"0FFF",X"07FF",X"03FF",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #2
X"0000",X"0000",X"0000",X"FF80",X"FFC0",X"FFE0",X"FFF0",X"FFF0",X"FFE0",X"FFC0",X"FF80",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #3
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0007",X"003F",X"007E",X"0001",X"00FF",X"00FF",
-- Tile #4
X"0000",X"0000",X"0000",X"0000",X"0000",X"0001",X"0001",X"0001",X"0FC1",X"FFC0",X"FFC0",X"FC00",X"03C0",X"FFC0",X"FFC0",X"FF00",
-- Tile #5
X"0000",X"0000",X"0000",X"7FFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #6
X"0000",X"0000",X"0000",X"F000",X"F800",X"FC00",X"FE00",X"FE00",X"FC00",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",


-- Tile #7
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #8
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0C00",X"0F00",X"0F80",X"0FC0",X"0FC0",X"0FC0",X"0FC0",X"0FC0",X"0FC0",
-- Tile #9
X"00FF",X"0100",X"01FF",X"01FF",X"0180",X"007F",X"03FF",X"0380",X"037F",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #10
X"8000",X"7800",X"F800",X"F000",X"0800",X"F800",X"8000",X"7800",X"F800",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #11
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"00FF",X"007F",X"001F",X"001F",X"001F",X"001F",
-- Tile #12
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"C000",X"C000",X"E000",X"E000",X"E000",X"E000",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",


-- Tile #13
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #14
X"0FC0",X"0FC0",X"0FC0",X"0FC0",X"0FC0",X"0F80",X"0F00",X"0C00",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #15
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"037F",X"0380",X"03FF",X"007F",X"0180",X"01FF",X"01FF",X"0100",X"00FF",X"00FF",
-- Tile #16
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"F800",X"7800",X"8000",X"F800",X"0800",X"F000",X"F800",X"7800",X"8000",X"FF00",
-- Tile #17
X"001F",X"001F",X"001F",X"007F",X"00FF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #18
X"E000",X"E000",X"E000",X"C000",X"C000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",



-- Tile #19
X"0000",X"0000",X"0000",X"0000",X"03FF",X"07FF",X"0FFF",X"1FFF",X"1FFF",X"0FFF",X"07FF",X"03FF",X"0000",X"0000",X"0000",X"0000",
-- Tile #20
X"0000",X"0000",X"0000",X"0000",X"FF80",X"FFC0",X"FFE0",X"FFF0",X"FFF0",X"FFE0",X"FFC0",X"FF80",X"0000",X"0000",X"0000",X"0000",
-- Tile #21
X"00FF",X"0001",X"007E",X"003F",X"0007",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #22
X"FFC0",X"FFC0",X"03C0",X"FC00",X"FFC0",X"FFC0",X"0FC1",X"0001",X"0001",X"0001",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #23
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"7FFF",X"0000",X"0000",X"0000",X"0000",
-- Tile #24
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FC00",X"FE00",X"FE00",X"FC00",X"F800",X"F000",X"0000",X"0000",X"0000",X"0000",

others => X"0000");
signal addr_reg: std_logic_vector(ADDR_WIDTH-1 downto 0);
begin
   -- addr register to infer block RAM
   process (clk)
   begin
      if (clk'event and clk = '1') then
        addr_reg <= addr;
      end if;
   end process;
   data <= obstacle2_ROM(to_integer(unsigned(addr_reg)));
end arch;




