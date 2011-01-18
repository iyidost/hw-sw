library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity vga_rom_obstacle1 is
   port(
      clk: in std_logic;
      addr: in std_logic_vector(8 downto 0);
      data: out std_logic_vector(15 downto 0)
   );
end vga_rom_obstacle1;

architecture arch of vga_rom_obstacle1 is
   constant ADDR_WIDTH: integer:=9;
   constant DATA_WIDTH: integer:=16;
   type rom_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);
   -- ROM definition
   constant obstacle1_ROM: rom_type:=(  -- 2^9-by-16
-- OBSTACLE SPRITE #1
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0007",X"07FC",X"0A00",X"13FF",X"2600",X"2C00",X"2800",X"2801",X"2801",
-- Tile #2
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"0000",X"003F",X"FF9C",X"3FC3",X"6038",X"C004",X"8004",X"0004",
-- Tile #3
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"0000",X"FFFF",X"0A0C",X"0A0C",X"CA0C",X"7FFF",X"4000",X"4000",
-- Tile #4
X"0000",X"0000",X"0000",X"0000",X"00C0",X"00E0",X"00A0",X"FF9F",X"0050",X"FFFF",X"01FC",X"0FC3",X"3E00",X"F000",X"1000",X"1000",
-- Tile #5
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"0000",X"8000",X"7FFF",X"3800",X"8780",X"40F0",X"400E",X"4001",
-- Tile #6
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"E000",X"3FC0",X"0060",X"FFB0",X"0098",X"0048",X"004C",X"0024",X"E014",

-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0FFF",X"0FFF",X"0C20",X"0C20",X"0C20",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"07FF",X"1C00",X"1800",X"1800",X"1800",X"1800",X"1800",X"D800",X"D800",X"5800",X"5FFF",X"4FFF",

-- Tile #7
X"6801",X"5001",X"5002",X"5002",X"5002",X"5002",X"5002",X"5004",X"5FFC",X"5004",X"5004",X"5002",X"5002",X"5002",X"5002",X"5001",
-- Tile #8
X"0004",X"0004",X"0004",X"0004",X"0004",X"0004",X"0004",X"0004",X"0004",X"0004",X"0004",X"0004",X"0004",X"0004",X"0004",X"0004",
-- Tile #9
X"4000",X"4000",X"4000",X"4000",X"4000",X"4000",X"4000",X"4000",X"4000",X"4000",X"4000",X"4000",X"4000",X"4000",X"4000",X"4000",
-- Tile #10
X"1000",X"1000",X"1000",X"1000",X"1000",X"1000",X"1000",X"1000",X"1000",X"1000",X"1000",X"1000",X"1000",X"1000",X"1000",X"1000",
-- Tile #11
X"2000",X"2000",X"2100",X"2000",X"2000",X"3000",X"3000",X"3000",X"3000",X"3FFF",X"2000",X"2000",X"2000",X"2000",X"2000",X"2100",
-- Tile #12
X"1C14",X"03CC",X"007A",X"000A",X"000A",X"000A",X"000A",X"000A",X"000A",X"FFFA",X"000A",X"000A",X"000A",X"000A",X"000A",X"007A",

-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0FFF",X"0FFF",X"0C20",X"0C20",X"0C20",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"07FF",X"1C00",X"1800",X"1800",X"1800",X"1800",X"1800",X"D800",X"D800",X"5800",X"5FFF",X"4FFF",

-- Tile #13
X"5001",X"5001",X"4801",X"2800",X"2800",X"2400",X"2700",X"34FF",X"1E00",X"03FC",X"0007",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #14
X"0004",X"0004",X"0004",X"800C",X"8018",X"4061",X"FFC6",X"FF38",X"007F",X"0000",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #15
X"4000",X"4000",X"4000",X"4000",X"7FFF",X"8A0C",X"0A0C",X"0A0C",X"FFFF",X"0000",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #16
X"1000",X"1000",X"1000",X"1000",X"F000",X"3000",X"0E01",X"0187",X"FFFE",X"0070",X"FFBF",X"0120",X"0140",X"0180",X"0000",X"0000",
-- Tile #17
X"2000",X"2000",X"4001",X"401E",X"40F0",X"C700",X"F800",X"8000",X"0000",X"0000",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #18
X"038A",X"3C14",X"C014",X"0024",X"0028",X"0048",X"0050",X"0090",X"0330",X"0CC0",X"FF80",X"0000",X"0000",X"0000",X"0000",X"0000",
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




