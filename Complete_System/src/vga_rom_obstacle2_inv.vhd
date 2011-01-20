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
X"0000",X"0000",X"0000",X"03FF",X"07FF",X"0FFF",X"1FFF",X"1FFF",X"0FFF",X"07FF",X"03FF",X"0000",X"001F",X"0006",X"0000",X"000F",
-- Tile #2
X"0000",X"0000",X"0000",X"FF80",X"FFC0",X"FFE0",X"FFF0",X"FFF0",X"FFE0",X"FFC0",X"FF80",X"0000",X"8000",X"0000",X"0000",X"0000",
-- Tile #3
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0007",X"003F",X"007E",X"0001",X"00FF",X"00FF",
-- Tile #4
X"0000",X"0000",X"0000",X"0000",X"0000",X"0001",X"0001",X"0001",X"0FC1",X"FFC0",X"FFC1",X"FC01",X"03C1",X"FFC1",X"FFC0",X"FF00",
-- Tile #5
X"0000",X"0000",X"0000",X"7FFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"0000",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"3FFF",
-- Tile #6
X"0000",X"0000",X"0000",X"F000",X"F800",X"FC00",X"FE00",X"FE00",X"FC00",X"0000",X"FFF8",X"FFF8",X"FFF8",X"FFF0",X"FFE0",X"FFC0",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0FFF",X"0FFF",X"0C20",X"0C20",X"0C20",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"07FF",X"1C00",X"1800",X"1800",X"1800",X"1800",X"1800",X"D800",X"D800",X"5800",X"5FFF",X"4FFF",


-- Tile #7
X"000F",X"0003",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0001",X"0003",X"007F",X"01FF",X"03FF",X"03FF",X"03FF",X"03FF",
-- Tile #8
X"F800",X"FE00",X"7FC0",X"1FF0",X"0FFE",X"1FFF",X"33FF",X"ECFF",X"EF3F",X"EF9F",X"EFDF",X"EFDF",X"EFDF",X"EFDF",X"EFDF",X"EFDF",
-- Tile #9
X"00FF",X"0500",X"2DFF",X"2DFF",X"AD80",X"E87F",X"EBFF",X"DB80",X"B37F",X"7000",X"4FFF",X"5FFF",X"5FFF",X"5FFF",X"5FFF",X"5FFF",
-- Tile #10
X"8000",X"7800",X"F800",X"F000",X"0800",X"F800",X"8000",X"7800",X"F801",X"0000",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",
-- Tile #11
X"3FFF",X"3FFF",X"3FFF",X"3FFF",X"3FFF",X"3FFF",X"3FFF",X"7FFF",X"FFFF",X"0100",X"FCFF",X"FF7F",X"FF9F",X"FFDF",X"FFDF",X"FFDF",
-- Tile #12
X"FF80",X"FF00",X"FE00",X"FE00",X"FE00",X"FC00",X"FC00",X"FC00",X"FC00",X"1C10",X"DF10",X"DFF0",X"EFF0",X"EFF0",X"EFF0",X"EFF0",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0FFF",X"0FFF",X"0C20",X"0C20",X"0C20",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"07FF",X"1C00",X"1800",X"1800",X"1800",X"1800",X"1800",X"D800",X"D800",X"5800",X"5FFF",X"4FFF",


-- Tile #13
X"03FF",X"03FF",X"03FF",X"01FF",X"007F",X"0003",X"0001",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0003",X"000F",X"000F",
-- Tile #14
X"EFDF",X"EFDF",X"EFDF",X"EFDF",X"EFDF",X"EF9F",X"EF3F",X"ECFF",X"33FF",X"1FFF",X"0FFE",X"1FF0",X"7FC0",X"FE00",X"F800",X"0000",
-- Tile #15
X"5FFF",X"5FFF",X"5FFF",X"5FFF",X"4FFF",X"7000",X"B37F",X"DB80",X"EBFF",X"E87F",X"AD80",X"2DFF",X"2DFF",X"0500",X"00FF",X"00FF",
-- Tile #16
X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"0000",X"F801",X"7800",X"8000",X"F800",X"0800",X"F000",X"F800",X"7800",X"8000",X"FF00",
-- Tile #17
X"FFDF",X"FFDF",X"FF9F",X"FF7F",X"FCFF",X"0100",X"FFFF",X"7FFF",X"3FFF",X"3FFF",X"3FFF",X"3FFF",X"3FFF",X"3FFF",X"3FFF",X"3FFF",
-- Tile #18
X"EFF0",X"EFF0",X"EFF0",X"DFF0",X"DF10",X"1C10",X"FC00",X"FC00",X"FC00",X"FC00",X"FE00",X"FE00",X"FE00",X"FF00",X"FF80",X"FFC0",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0FFF",X"0FFF",X"0C20",X"0C20",X"0C20",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"07FF",X"1C00",X"1800",X"1800",X"1800",X"1800",X"1800",X"D800",X"D800",X"5800",X"5FFF",X"4FFF",


-- Tile #19
X"0000",X"0006",X"001F",X"0000",X"03FF",X"07FF",X"0FFF",X"1FFF",X"1FFF",X"0FFF",X"07FF",X"03FF",X"0000",X"0000",X"0000",X"0000",
-- Tile #20
X"0000",X"0000",X"8000",X"0000",X"FF80",X"FFC0",X"FFE0",X"FFF0",X"FFF0",X"FFE0",X"FFC0",X"FF80",X"0000",X"0000",X"0000",X"0000",
-- Tile #21
X"00FF",X"0001",X"007E",X"003F",X"0007",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #22
X"FFC0",X"FFC1",X"03C1",X"FC01",X"FFC1",X"FFC0",X"0FC1",X"0001",X"0001",X"0001",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #23
X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"0000",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"7FFF",X"0000",X"0000",X"0000",X"0000",
-- Tile #24
X"FFE0",X"FFF0",X"FFF8",X"FFF8",X"FFF8",X"0000",X"FC00",X"FE00",X"FE00",X"FC00",X"F800",X"F000",X"0000",X"0000",X"0000",X"0000",

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




