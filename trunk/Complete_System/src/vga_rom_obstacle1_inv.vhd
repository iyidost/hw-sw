library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity vga_rom_obstacle1_inv is
   port(
      clk: in std_logic;
      addr: in std_logic_vector(8 downto 0);
      data: out std_logic_vector(15 downto 0)
   );
end vga_rom_obstacle1_inv;

architecture arch of vga_rom_obstacle1_inv is
   constant ADDR_WIDTH: integer:=9;
   constant DATA_WIDTH: integer:=16;
   type rom_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);
   -- ROM definition
   constant obstacle1_inv_ROM: rom_type:=(  -- 2^9-by-16
-- OBSTACLE_inv SPRITE #1

-- Tile #1
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0003",X"05FF",X"0C00",X"19FF",X"13FF",X"17FF",X"17FE",X"17FE",
-- Tile #2
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"FFC0",X"0063",X"C03C",X"9FC7",X"3FFB",X"7FFB",X"FFFB",
-- Tile #3
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"0000",X"F5F3",X"F5F3",X"35F3",X"8000",X"BFFF",X"BFFF",
-- Tile #4
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0040",X"0060",X"FFAF",X"0000",X"FE03",X"F03C",X"C1FF",X"0FFF",X"EFFF",X"EFFF",
-- Tile #5
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"7FFF",X"8000",X"C7FF",X"787F",X"BF0F",X"BFF1",X"BFFE",
-- Tile #6
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"C000",X"FF80",X"0040",X"FF60",X"FFB0",X"FFB0",X"FFD8",X"1FE8",
-- Sprite empty 7 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0FFF",X"0FFF",X"0C20",X"0C20",X"0C20",
-- Sprite empty 8
X"0000",X"0000",X"0000",X"0000",X"07FF",X"1C00",X"1800",X"1800",X"1800",X"1800",X"1800",X"D800",X"D800",X"5800",X"5FFF",X"4FFF",


-- Tile #9
X"17FE",X"2FFE",X"2FFD",X"2FFD",X"2FFD",X"2FFD",X"2FFD",X"2FFB",X"2003",X"2FFB",X"2FFB",X"2FFD",X"2FFD",X"2FFD",X"2FFD",X"2FFE",
-- Tile #10
X"FFFB",X"FFFB",X"FFFB",X"FFFB",X"FFFB",X"FFFB",X"FFFB",X"FFFB",X"FFFB",X"FFFB",X"FFFB",X"FFFB",X"FFFB",X"FFFB",X"FFFB",X"FFFB",
-- Tile #11
X"BFFF",X"BFFF",X"BFFF",X"BFFF",X"BFFF",X"BFFF",X"BFFF",X"BFFF",X"BFFF",X"BFFF",X"BFFF",X"BFFF",X"BFFF",X"BFFF",X"BFFF",X"BFFF",
-- Tile #12
X"EFFF",X"EFFF",X"EFFF",X"EFFF",X"EFFF",X"EFFF",X"EFFF",X"EFFF",X"EFFF",X"EFFF",X"EFFF",X"EFFF",X"EFFF",X"EFFF",X"EFFF",X"EFFF",
-- Tile #13
X"DFFF",X"DFFF",X"DEFF",X"DFFF",X"DFFF",X"CFFF",X"CFFF",X"CFFF",X"CFFF",X"C000",X"DFFF",X"DFFF",X"DFFF",X"DFFF",X"DFFF",X"DEFF",
-- Tile #14
X"E3E8",X"FC30",X"FF84",X"FFF4",X"FFF4",X"FFF4",X"FFF4",X"FFF4",X"FFF4",X"0004",X"FFF4",X"FFF4",X"FFF4",X"FFF4",X"FFF4",X"FF84",
-- Sprite empty 15 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0FFF",X"0FFF",X"0C20",X"0C20",X"0C20",
-- Sprite empty 16
X"0000",X"0000",X"0000",X"0000",X"07FF",X"1C00",X"1800",X"1800",X"1800",X"1800",X"1800",X"D800",X"D800",X"5800",X"5FFF",X"4FFF",


-- Tile #17
X"2FFE",X"2FFE",X"37FE",X"17FF",X"17FF",X"1BFF",X"18FF",X"0B00",X"01FF",X"0003",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #18
X"FFFB",X"FFFB",X"FFFB",X"7FF3",X"7FE7",X"BF9E",X"0039",X"00C7",X"FF80",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #19
X"BFFF",X"BFFF",X"BFFF",X"BFFF",X"8000",X"75F3",X"F5F3",X"F5F3",X"0000",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #20
X"EFFF",X"EFFF",X"EFFF",X"EFFF",X"0FFF",X"CFFF",X"F1FE",X"FE78",X"0001",X"FF8F",X"0040",X"00C0",X"0080",X"0000",X"0000",X"0000",
-- Tile #21
X"DFFF",X"DFFF",X"BFFE",X"BFE1",X"BF0F",X"38FF",X"07FF",X"7FFF",X"FFFF",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #22
X"FC74",X"C3E8",X"3FE8",X"FFD8",X"FFD0",X"FFB0",X"FFA0",X"FF60",X"FCC0",X"F300",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
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
   data <= obstacle1_inv_ROM(to_integer(unsigned(addr_reg)));
end arch;




