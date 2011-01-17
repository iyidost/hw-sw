library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity vga_rom_sprites is
   port(
      clk: in std_logic;
      addr: in std_logic_vector(8 downto 0);
      data: out std_logic_vector(15 downto 0)
   );
end vga_rom_sprites;

architecture arch of vga_rom_sprites is
   constant ADDR_WIDTH: integer:=9;
   constant DATA_WIDTH: integer:=16;
   type rom_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);
   -- ROM definition
   constant HEX2LED_ROM: rom_type:=(  -- 2^9-by-16
----------------------------------------------------------
-- Memory data for the car pics (current one tile only) --
----------------------------------------------------------
-- Sprite 1
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0FFF",X"0FFF",X"0C20",X"0C20",X"0C20",
-- Sprite 2
X"0000",X"0000",X"0000",X"0000",X"07FF",X"1C00",X"1800",X"1800",X"1800",X"1800",X"1800",X"D800",X"D800",X"5800",X"5FFF",X"4FFF",
-- Sprite 3
X"0000",X"0000",X"0000",X"0000",X"C000",X"7000",X"3000",X"3000",X"3000",X"3000",X"3000",X"3000",X"3000",X"3000",X"F00F",X"E018",
-- Sprite 4
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"0000",
-- Sprite 5
X"0000",X"0000",X"0000",X"0FFF",X"3800",X"3000",X"3000",X"3000",X"3000",X"3000",X"3000",X"3000",X"3000",X"3FFF",X"9FFF",X"4068",
-- Sprite 6
X"0000",X"0000",X"0000",X"8000",X"E000",X"6000",X"6000",X"6000",X"6000",X"6000",X"6000",X"6000",X"6000",X"E000",X"C000",X"0000",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0FFF",X"0FFF",X"0C20",X"0C20",X"0C20",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"07FF",X"1C00",X"1800",X"1800",X"1800",X"1800",X"1800",X"D800",X"D800",X"5800",X"5FFF",X"4FFF",

-- Sprite 7
X"0C20",X"0C20",X"0C21",X"0C22",X"0C24",X"0C28",X"0C28",X"0C28",X"0C30",X"0C30",X"0C38",X"0C27",X"0C27",X"0C38",X"0C20",X"0C20",
-- Sprite 8
X"4078",X"C078",X"806C",X"006E",X"0066",X"0067",X"0063",X"0063",X"0061",X"007F",X"3FC0",X"E000",X"0000",X"0000",X"0000",X"0000",
-- Sprite 9
X"0030",X"0060",X"00C0",X"0180",X"0300",X"0600",X"0C00",X"9800",X"F000",X"FFFF",X"0000",X"0001",X"0006",X"0008",X"0008",X"000F",
-- Sprite 10
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"07FE",X"F803",X"0000",X"FFE0",X"0037",X"C013",X"C011",X"C011",
-- Sprite 11
X"2068",X"1068",X"0868",X"0468",X"0668",X"02C8",X"018B",X"008A",X"004B",X"802A",X"E03E",X"3802",X"0E02",X"E382",X"38E2",X"0C3A",
-- Sprite 12
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFF8",X"1218",X"FFF8",X"1218",X"1218",X"1218",X"1218",X"1218",X"1218",X"1218",
-- Sprite empty 110
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0FFF",X"0FFF",X"0C20",X"0C20",X"0C20",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"07FF",X"1C00",X"1800",X"1800",X"1800",X"1800",X"1800",X"D800",X"D800",X"5800",X"5FFF",X"4FFF",

-- Sprite 13
X"0C20",X"0C38",X"0C27",X"0C27",X"0C38",X"0C30",X"0C30",X"0C28",X"0C28",X"0C28",X"0C24",X"0C22",X"0C21",X"0C20",X"0C20",X"0C20",
-- Sprite 14
X"0000",X"0000",X"0000",X"E000",X"3FC0",X"007F",X"0061",X"0063",X"0063",X"0067",X"0066",X"006E",X"806C",X"C078",X"4078",X"4FFF",
-- Sprite 15
X"0008",X"0008",X"0006",X"0001",X"0000",X"FFFF",X"F000",X"9800",X"0C00",X"0600",X"0300",X"0180",X"00C0",X"0060",X"0030",X"E018",
-- Sprite 16
X"C011",X"C013",X"0037",X"FFE0",X"0000",X"F803",X"07FE",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite 17
X"38E2",X"E382",X"0E02",X"3802",X"E03E",X"802A",X"004A",X"008A",X"018B",X"02CA",X"066B",X"0468",X"0868",X"1068",X"2068",X"4068",
-- Sprite 18
X"1218",X"1218",X"1218",X"1218",X"1218",X"1218",X"1218",X"1218",X"FFF8",X"1218",X"FFF8",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 110
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0FFF",X"0FFF",X"0C20",X"0C20",X"0C20",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"07FF",X"1C00",X"1800",X"1800",X"1800",X"1800",X"1800",X"D800",X"D800",X"5800",X"5FFF",X"4FFF",

-- Sprite 19
X"0C20",X"0C20",X"0FFF",X"0FFF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite 20
X"5FFF",X"5800",X"D800",X"D800",X"1800",X"1800",X"1800",X"1800",X"1800",X"1C00",X"07FF",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite 21
X"F00F",X"3000",X"3000",X"3000",X"3000",X"3000",X"3000",X"3000",X"3000",X"7000",X"C000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite 22
X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite 23
X"9FFF",X"3FFF",X"3000",X"3000",X"3000",X"3000",X"3000",X"3000",X"3000",X"3000",X"3800",X"0FFF",X"0000",X"0000",X"0000",X"0000",
-- Sprite 24
X"C000",X"E000",X"6000",X"6000",X"6000",X"6000",X"6000",X"6000",X"6000",X"6000",X"E000",X"8000",X"0000",X"0000",X"0000",X"0000",
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
   data <= HEX2LED_ROM(to_integer(unsigned(addr_reg)));
end arch;