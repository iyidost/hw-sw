library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity vga_rom_obstacle2_inv is
   port(
      clk: in std_logic;
      addr: in std_logic_vector(8 downto 0);
      data: out std_logic_vector(15 downto 0)
   );
end vga_rom_obstacle2_inv;

architecture arch of vga_rom_obstacle2_inv is
   constant ADDR_WIDTH: integer:=9;
   constant DATA_WIDTH: integer:=16;
   type rom_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);
   -- ROM definition
   constant obstacle2_inv_ROM: rom_type:=(  -- 2^9-by-16
-- OBSTACLE2_inv
-- Tile #1
X"0000",X"0000",X"0000",X"000F",X"001F",X"003F",X"007F",X"007F",X"003F",X"0000",X"1FFF",X"1FFF",X"1FFF",X"0FFF",X"07FF",X"03FF",
-- Tile #2
X"0000",X"0000",X"0000",X"FFFE",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"0000",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFC",
-- Tile #3
X"0000",X"0000",X"0000",X"0000",X"0000",X"8000",X"8000",X"8000",X"83F0",X"03FF",X"83FF",X"803F",X"83C0",X"83FF",X"03FF",X"00FF",
-- Tile #4
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"E000",X"FC00",X"7E00",X"8000",X"FF00",X"FF00",
-- Tile #5
X"0000",X"0000",X"0000",X"01FF",X"03FF",X"07FF",X"0FFF",X"0FFF",X"07FF",X"03FF",X"01FF",X"0000",X"0001",X"0000",X"0000",X"0000",
-- Tile #6
X"0000",X"0000",X"0000",X"FFC0",X"FFE0",X"FFF0",X"FFF8",X"FFF8",X"FFF0",X"FFE0",X"FFC0",X"0000",X"F800",X"6000",X"0000",X"F000",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0FFF",X"0FFF",X"0C20",X"0C20",X"0C20",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"07FF",X"1C00",X"1800",X"1800",X"1800",X"1800",X"1800",X"D800",X"D800",X"5800",X"5FFF",X"4FFF",


-- Tile #7
X"01FF",X"00FF",X"007F",X"007F",X"007F",X"003F",X"003F",X"003F",X"003F",X"0838",X"08FB",X"0FFB",X"0FF7",X"0FF7",X"0FF7",X"0FF7",
-- Tile #8
X"FFFC",X"FFFC",X"FFFC",X"FFFC",X"FFFC",X"FFFC",X"FFFC",X"FFFE",X"FFFF",X"0080",X"FF3F",X"FEFF",X"F9FF",X"FBFF",X"FBFF",X"FBFF",
-- Tile #9
X"0001",X"001E",X"001F",X"000F",X"0010",X"001F",X"0001",X"001E",X"801F",X"0000",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",
-- Tile #10
X"FF00",X"00A0",X"FFB4",X"FFB4",X"01B5",X"FE17",X"FFD7",X"01DB",X"FECD",X"000E",X"FFF2",X"FFFA",X"FFFA",X"FFFA",X"FFFA",X"FFFA",
-- Tile #11
X"001F",X"007F",X"03FE",X"0FF8",X"7FF0",X"FFF8",X"FFCC",X"FF37",X"FCF7",X"F9F7",X"FBF7",X"FBF7",X"FBF7",X"FBF7",X"FBF7",X"FBF7",
-- Tile #12
X"F000",X"C000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"8000",X"C000",X"FE00",X"FF80",X"FFC0",X"FFC0",X"FFC0",X"FFC0",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0FFF",X"0FFF",X"0C20",X"0C20",X"0C20",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"07FF",X"1C00",X"1800",X"1800",X"1800",X"1800",X"1800",X"D800",X"D800",X"5800",X"5FFF",X"4FFF",

-- Tile #13
X"0FF7",X"0FF7",X"0FF7",X"0FFB",X"08FB",X"0838",X"003F",X"003F",X"003F",X"003F",X"007F",X"007F",X"007F",X"00FF",X"01FF",X"03FF",
-- Tile #14
X"FBFF",X"FBFF",X"F9FF",X"FEFF",X"FF3F",X"0080",X"FFFF",X"FFFE",X"FFFC",X"FFFC",X"FFFC",X"FFFC",X"FFFC",X"FFFC",X"FFFC",X"FFFC",
-- Tile #15
X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"0000",X"801F",X"001E",X"0001",X"001F",X"0010",X"000F",X"001F",X"001E",X"0001",X"00FF",
-- Tile #16
X"FFFA",X"FFFA",X"FFFA",X"FFFA",X"FFF2",X"000E",X"FECD",X"01DB",X"FFD7",X"FE17",X"01B5",X"FFB4",X"FFB4",X"00A0",X"FF00",X"FF00",
-- Tile #17
X"FBF7",X"FBF7",X"FBF7",X"FBF7",X"FBF7",X"F9F7",X"FCF7",X"FF37",X"FFCC",X"FFF8",X"7FF0",X"0FF8",X"03FE",X"007F",X"001F",X"0000",
-- Tile #18
X"FFC0",X"FFC0",X"FFC0",X"FF80",X"FE00",X"C000",X"8000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"C000",X"F000",X"F000",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0FFF",X"0FFF",X"0C20",X"0C20",X"0C20",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"07FF",X"1C00",X"1800",X"1800",X"1800",X"1800",X"1800",X"D800",X"D800",X"5800",X"5FFF",X"4FFF",


-- Tile #19
X"07FF",X"0FFF",X"1FFF",X"1FFF",X"1FFF",X"0000",X"003F",X"007F",X"007F",X"003F",X"001F",X"000F",X"0000",X"0000",X"0000",X"0000",
-- Tile #20
X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"0000",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFE",X"0000",X"0000",X"0000",X"0000",
-- Tile #21
X"03FF",X"83FF",X"83C0",X"803F",X"83FF",X"03FF",X"83F0",X"8000",X"8000",X"8000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #22
X"FF00",X"8000",X"7E00",X"FC00",X"E000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #23
X"0000",X"0000",X"0001",X"0000",X"01FF",X"03FF",X"07FF",X"0FFF",X"0FFF",X"07FF",X"03FF",X"01FF",X"0000",X"0000",X"0000",X"0000",
-- Tile #24
X"0000",X"6000",X"F800",X"0000",X"FFC0",X"FFE0",X"FFF0",X"FFF8",X"FFF8",X"FFF0",X"FFE0",X"FFC0",X"0000",X"0000",X"0000",X"0000",


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
   data <= obstacle2_inv_ROM(to_integer(unsigned(addr_reg)));
end arch;




