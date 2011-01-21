library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity vga_rom_obstacle1_layer2 is
   port(
      clk: in std_logic;
      addr: in std_logic_vector(8 downto 0);
      data: out std_logic_vector(15 downto 0)
   );
end vga_rom_obstacle1_layer2;

architecture arch of vga_rom_obstacle1_layer2 is
   constant ADDR_WIDTH: integer:=9;
   constant DATA_WIDTH: integer:=16;
   type rom_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);
   -- ROM definition
   constant obstacle1_inv_ROM: rom_type:=(  -- 2^9-by-16
-- OBSTACLE 1 layer 2
-- Tile #1
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0003",X"01FF",X"0200",X"06FF",X"0DFF",X"0DFF",X"1BFF",X"17F8",
-- Tile #2
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"FFFE",X"0001",X"FFE3",X"FE1E",X"F0FC",X"8FFC",X"7FFC",
-- Tile #3
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0200",X"0600",X"F5FF",X"0000",X"C000",X"0000",X"0000",X"0000",X"0007",X"0007",
-- Tile #4
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"0000",X"0020",X"0020",X"0020",X"0001",X"FFFD",X"FFFD",
-- Tile #5
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"03FF",X"0600",X"3C03",X"E001",X"C000",X"C000",X"C000",
-- Tile #6
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"C000",X"FFA0",X"0030",X"FF98",X"FFC8",X"FFE8",X"7FE8",X"7FE8",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",


-- Tile #7
X"17C7",X"0C3F",X"21FF",X"2FFF",X"2FFF",X"2FFF",X"2FFF",X"2FFF",X"2FFF",X"2000",X"2FFF",X"2FFF",X"2FFF",X"2FFF",X"2FFF",X"21FF",
-- Tile #8
X"FFF8",X"FFF8",X"FF78",X"FFF8",X"FFF8",X"FFF0",X"FFF0",X"FFF0",X"FFF0",X"0000",X"FFF8",X"FFF8",X"FFF8",X"FFF8",X"FFF8",X"FF78",
-- Tile #9
X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",
-- Tile #10
X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",
-- Tile #11
X"C000",X"C000",X"C000",X"C000",X"C000",X"C000",X"C000",X"C000",X"C000",X"C000",X"C000",X"C000",X"C000",X"C000",X"C000",X"C000",
-- Tile #12
X"7FE8",X"7FF4",X"3FF4",X"3FF4",X"3FF4",X"3FF4",X"3FF4",X"1FF4",X"0004",X"1FF4",X"1FF4",X"3FF4",X"3FF4",X"3FF4",X"3FF4",X"7FF4",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",

-- Tile #13
X"2E3F",X"17C3",X"17FC",X"1BFF",X"0BFF",X"0DFF",X"05FF",X"06FF",X"033F",X"00CF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #14
X"FFF8",X"FFF8",X"7FFC",X"87FC",X"F0FC",X"FF1C",X"FFE0",X"FFFE",X"FFFF",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #15
X"0007",X"0007",X"0007",X"0007",X"0000",X"0000",X"0000",X"0000",X"8000",X"F1FF",X"0200",X"0300",X"0100",X"0000",X"0000",X"0000",
-- Tile #16
X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"0001",X"0020",X"0020",X"0020",X"0000",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #17
X"C000",X"C000",X"C000",X"C000",X"E000",X"7801",X"1C00",X"0300",X"01FF",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #18
X"7FF4",X"7FF4",X"7FEC",X"FFE8",X"FFE8",X"FFD8",X"FF18",X"00D0",X"FF80",X"C000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",


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




