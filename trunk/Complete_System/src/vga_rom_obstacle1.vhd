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

-- Tile #1
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0007",X"03FC",X"0600",X"0DFF",X"1900",X"1200",X"3200",X"2400",X"2807",
-- Tile #2
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"0000",X"0001",X"FFFE",X"001C",X"01E1",X"0F02",X"7002",X"8002",
-- Tile #3
X"0000",X"0000",X"0000",X"0000",X"0300",X"0700",X"0500",X"F9FF",X"0A00",X"FFFF",X"3F80",X"C3F0",X"007C",X"000F",X"0008",X"0008",
-- Tile #4
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"0000",X"FFFF",X"3050",X"3050",X"3053",X"FFFE",X"0002",X"0002",
-- Tile #5
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"0000",X"FC00",X"39FF",X"C3FC",X"1C06",X"2003",X"2001",X"2000",
-- Tile #6
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"E000",X"3FE0",X"0050",X"FFC8",X"0064",X"0034",X"0014",X"8014",X"8014",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0FFF",X"0FFF",X"0C20",X"0C20",X"0C20",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"07FF",X"1C00",X"1800",X"1800",X"1800",X"1800",X"1800",X"D800",X"D800",X"5800",X"5FFF",X"4FFF",



-- Tile #7
X"2838",X"33C0",X"5E00",X"5000",X"5000",X"5000",X"5000",X"5000",X"5000",X"5FFF",X"5000",X"5000",X"5000",X"5000",X"5000",X"5E00",
-- Tile #8
X"0004",X"0004",X"0084",X"0004",X"0004",X"000C",X"000C",X"000C",X"000C",X"FFFC",X"0004",X"0004",X"0004",X"0004",X"0004",X"0084",
-- Tile #9
X"0008",X"0008",X"0008",X"0008",X"0008",X"0008",X"0008",X"0008",X"0008",X"0008",X"0008",X"0008",X"0008",X"0008",X"0008",X"0008",
-- Tile #10
X"0002",X"0002",X"0002",X"0002",X"0002",X"0002",X"0002",X"0002",X"0002",X"0002",X"0002",X"0002",X"0002",X"0002",X"0002",X"0002",
-- Tile #11
X"2000",X"2000",X"2000",X"2000",X"2000",X"2000",X"2000",X"2000",X"2000",X"2000",X"2000",X"2000",X"2000",X"2000",X"2000",X"2000",
-- Tile #12
X"8016",X"800A",X"400A",X"400A",X"400A",X"400A",X"400A",X"200A",X"3FFA",X"200A",X"200A",X"400A",X"400A",X"400A",X"400A",X"800A",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0FFF",X"0FFF",X"0C20",X"0C20",X"0C20",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"07FF",X"1C00",X"1800",X"1800",X"1800",X"1800",X"1800",X"D800",X"D800",X"5800",X"5FFF",X"4FFF",


-- Tile #13
X"51C0",X"283C",X"2803",X"2400",X"1400",X"1200",X"0A00",X"0900",X"0CC0",X"0330",X"01FF",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #14
X"0004",X"0004",X"8002",X"7802",X"0F02",X"00E3",X"001F",X"0001",X"0000",X"0000",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #15
X"0008",X"0008",X"0008",X"0008",X"000F",X"000C",X"8070",X"E180",X"7FFF",X"0E00",X"FDFF",X"0480",X"0280",X"0180",X"0000",X"0000",
-- Tile #16
X"0002",X"0002",X"0002",X"0002",X"FFFE",X"3051",X"3050",X"3050",X"FFFF",X"0000",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #17
X"2000",X"2000",X"2000",X"3001",X"1801",X"8602",X"63FF",X"1CFF",X"FE00",X"0000",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #18
X"800A",X"800A",X"8012",X"0014",X"0014",X"0024",X"00E4",X"FF2C",X"0078",X"3FC0",X"E000",X"0000",X"0000",X"0000",X"0000",X"0000",


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




