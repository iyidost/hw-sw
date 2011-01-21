library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity vga_rom_obstacle2_layer2 is
   port(
      clk: in std_logic;
      addr: in std_logic_vector(8 downto 0);
      data: out std_logic_vector(15 downto 0)
   );
end vga_rom_obstacle2_layer2;

architecture arch of vga_rom_obstacle2_layer2 is
   constant ADDR_WIDTH: integer:=9;
   constant DATA_WIDTH: integer:=16;
   type rom_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);
   -- ROM definition
   constant obstacle2_inv_ROM: rom_type:=(  -- 2^9-by-16
-- OBSTACLE 2 layer 2

-- Tile #1
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"001F",X"0006",X"0000",X"000F",
-- Tile #2
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"8000",X"0000",X"0000",X"0000",
-- Tile #3
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #4
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0001",X"0001",X"0001",X"0001",X"0000",X"0000",
-- Tile #5
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"3FFF",
-- Tile #6
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFF8",X"FFF8",X"FFF8",X"FFF0",X"FFE0",X"FFC0",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",


-- Tile #7
X"000F",X"0003",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0001",X"0003",X"007F",X"01FF",X"03FF",X"03FF",X"03FF",X"03FF",
-- Tile #8
X"F800",X"FE00",X"7FC0",X"1FF0",X"0FFE",X"1FFF",X"33FF",X"E0FF",X"E03F",X"E01F",X"E01F",X"E01F",X"E01F",X"E01F",X"E01F",X"E01F",
-- Tile #9
X"0000",X"0400",X"2C00",X"2C00",X"AC00",X"E800",X"E800",X"D800",X"B000",X"7000",X"4FFF",X"5FFF",X"5FFF",X"5FFF",X"5FFF",X"5FFF",
-- Tile #10
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0001",X"0000",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",
-- Tile #11
X"3FFF",X"3FFF",X"3FFF",X"3FFF",X"3FFF",X"3FFF",X"3FFF",X"7FFF",X"FFFF",X"0100",X"FC00",X"FF00",X"FF80",X"FFC0",X"FFC0",X"FFC0",
-- Tile #12
X"FF80",X"FF00",X"FE00",X"FE00",X"FE00",X"FC00",X"FC00",X"FC00",X"FC00",X"1C10",X"1F10",X"1FF0",X"0FF0",X"0FF0",X"0FF0",X"0FF0",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",


-- Tile #13
X"03FF",X"03FF",X"03FF",X"01FF",X"007F",X"0003",X"0001",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0003",X"000F",X"000F",
-- Tile #14
X"E01F",X"E01F",X"E01F",X"E01F",X"E01F",X"E01F",X"E03F",X"E0FF",X"33FF",X"1FFF",X"0FFE",X"1FF0",X"7FC0",X"FE00",X"F800",X"0000",
-- Tile #15
X"5FFF",X"5FFF",X"5FFF",X"5FFF",X"4FFF",X"7000",X"B000",X"D800",X"E800",X"E800",X"AC00",X"2C00",X"2C00",X"0400",X"0000",X"0000",
-- Tile #16
X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"0000",X"0001",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #17
X"FFC0",X"FFC0",X"FF80",X"FF00",X"FC00",X"0100",X"FFFF",X"7FFF",X"3FFF",X"3FFF",X"3FFF",X"3FFF",X"3FFF",X"3FFF",X"3FFF",X"3FFF",
-- Tile #18
X"0FF0",X"0FF0",X"0FF0",X"1FF0",X"1F10",X"1C10",X"FC00",X"FC00",X"FC00",X"FC00",X"FE00",X"FE00",X"FE00",X"FF00",X"FF80",X"FFC0",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",


-- Tile #19
X"0000",X"0006",X"001F",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #20
X"0000",X"0000",X"8000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #21
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #22
X"0000",X"0001",X"0001",X"0001",X"0001",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #23
X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #24
X"FFE0",X"FFF0",X"FFF8",X"FFF8",X"FFF8",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",

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




