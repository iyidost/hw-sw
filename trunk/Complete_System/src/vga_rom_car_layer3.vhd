library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity vga_rom_car_layer3 is
   port(
      clk: in std_logic;
      addr: in std_logic_vector(8 downto 0);
      data: out std_logic_vector(15 downto 0)
   );
end vga_rom_car_layer3;

architecture arch of vga_rom_car_layer3 is
   constant ADDR_WIDTH: integer:=9;
   constant DATA_WIDTH: integer:=16;
   type rom_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);
   -- ROM definition
   constant CAR_ROM: rom_type:=(  -- 2^9-by-16
----------------------------------------------------------
-- Memory data for the car pics  --
----------------------------------------------------------
-- Sprite 1
-- Tile #1
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #2
X"0000",X"0000",X"0000",X"0000",X"0000",X"03FF",X"07FF",X"07FF",X"0701",X"07FF",X"07FF",X"0400",X"07FF",X"07FF",X"0000",X"0000",
-- Tile #3
X"0000",X"0000",X"0000",X"0000",X"0000",X"8000",X"C000",X"C000",X"C000",X"C000",X"C000",X"4000",X"C000",X"C000",X"0000",X"0000",
-- Tile #4
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #5
X"0000",X"0000",X"0000",X"0000",X"07FF",X"0FFF",X"0FFF",X"0E03",X"0FFF",X"0FFF",X"0800",X"0FFF",X"0FFF",X"0000",X"0000",X"0010",
-- Tile #6
X"0000",X"0000",X"0000",X"0000",X"0000",X"8000",X"8000",X"8000",X"8000",X"8000",X"8000",X"8000",X"8000",X"0000",X"0000",X"0000",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",

-- Tile #7
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #8
X"0000",X"0000",X"0010",X"0010",X"0018",X"0018",X"001C",X"001C",X"001E",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #9
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0001",X"0007",X"0007",X"0000",
-- Tile #10
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFC0",X"3FE0",X"3FE0",X"3FE0",
-- Tile #11
X"0010",X"0010",X"0010",X"0010",X"0010",X"0030",X"0070",X"0070",X"0030",X"0010",X"0000",X"0000",X"0000",X"0000",X"C000",X"F000",
-- Tile #12
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 110
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",

-- Tile #13
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #14
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"001E",X"001C",X"001C",X"0018",X"0018",X"0010",X"0010",X"0000",X"0000",X"0000",
-- Tile #15
X"0007",X"0007",X"0001",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #16
X"3FE0",X"3FE0",X"FFC0",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #17
X"C000",X"0000",X"0000",X"0000",X"0000",X"0010",X"0030",X"0070",X"0070",X"0030",X"0010",X"0010",X"0010",X"0010",X"0010",X"0010",
-- Tile #18
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 110
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",

-- Tile #19
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #20
X"0000",X"07FF",X"07FF",X"0400",X"07FF",X"07FF",X"0701",X"07FF",X"07FF",X"03FF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #21
X"0000",X"C000",X"C000",X"4000",X"C000",X"C000",X"C000",X"C000",X"C000",X"8000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #22
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #23
X"0000",X"0000",X"0FFF",X"0FFF",X"0800",X"0FFF",X"0FFF",X"0E03",X"0FFF",X"0FFF",X"07FF",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #24
X"0000",X"0000",X"8000",X"8000",X"8000",X"8000",X"8000",X"8000",X"8000",X"8000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
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
   data <= CAR_ROM(to_integer(unsigned(addr_reg)));
end arch;