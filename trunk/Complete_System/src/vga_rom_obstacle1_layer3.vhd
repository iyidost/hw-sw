library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity vga_rom_obstacle1_layer3 is
   port(
      clk: in std_logic;
      addr: in std_logic_vector(8 downto 0);
      data: out std_logic_vector(15 downto 0)
   );
end vga_rom_obstacle1_layer3;

architecture arch of vga_rom_obstacle1_layer3 is
   constant ADDR_WIDTH: integer:=9;
   constant DATA_WIDTH: integer:=16;
   type rom_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);
   -- ROM definition
   constant obstacle1_ROM: rom_type:=(  -- 2^9-by-16
-- OBSTACLE SPRITE #1
-- Tile #1
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #2
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0001",X"0001",X"0001",
-- Tile #3
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"007F",X"3C0F",X"FF83",X"FFF0",X"FFF0",X"FFF0",
-- Tile #4
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"CF8F",X"CF8F",X"CF8C",X"0000",X"0000",X"0000",
-- Tile #5
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"C000",X"0000",X"03F8",X"1FFC",X"1FFE",X"1FFF",
-- Tile #6
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",




-- Tile #7
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #8
X"0003",X"0003",X"0003",X"0003",X"0003",X"0003",X"0003",X"0003",X"0003",X"0003",X"0003",X"0003",X"0003",X"0003",X"0003",X"0003",
-- Tile #9
X"FFF0",X"FFF0",X"FFF0",X"FFF0",X"FFF0",X"FFF0",X"FFF0",X"FFF0",X"FFF0",X"FFF0",X"FFF0",X"FFF0",X"FFF0",X"FFF0",X"FFF0",X"FFF0",
-- Tile #10
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #11
X"1FFF",X"1FFF",X"1FFF",X"1FFF",X"1FFF",X"1FFF",X"1FFF",X"1FFF",X"1FFF",X"1FFF",X"1FFF",X"1FFF",X"1FFF",X"1FFF",X"1FFF",X"1FFF",
-- Tile #12
X"0000",X"0000",X"8000",X"8000",X"8000",X"8000",X"8000",X"C000",X"C000",X"C000",X"C000",X"8000",X"8000",X"8000",X"8000",X"0000",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",


-- Tile #13
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #14
X"0003",X"0003",X"0001",X"0001",X"0001",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #15
X"FFF0",X"FFF0",X"FFF0",X"FFF0",X"FFF0",X"FFF3",X"7F8F",X"1E7F",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #16
X"0000",X"0000",X"0000",X"0000",X"0000",X"CF8E",X"CF8F",X"CF8F",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #17
X"1FFF",X"1FFF",X"1FFF",X"0FFE",X"07FE",X"01FC",X"8000",X"E000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #18
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",


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
   data <= obstacle1_ROM(to_integer(unsigned(addr_reg)));
end arch;
