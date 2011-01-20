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
-- OBSTACLE1_inv  #1
-- Tile #1
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0003",X"01FF",X"0200",X"06FF",X"0DFF",X"0DFF",X"1BFF",X"17F8",
-- Tile #2
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"FFFE",X"0001",X"FFE3",X"FE1E",X"F0FD",X"8FFD",X"7FFD",
-- Tile #3
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0200",X"0600",X"F5FF",X"0000",X"C07F",X"3C0F",X"FF83",X"FFF0",X"FFF7",X"FFF7",
-- Tile #4
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"0000",X"CFAF",X"CFAF",X"CFAC",X"0001",X"FFFD",X"FFFD",
-- Tile #5
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"03FF",X"C600",X"3C03",X"E3F9",X"DFFC",X"DFFE",X"DFFF",
-- Tile #6
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"C000",X"FFA0",X"0030",X"FF98",X"FFC8",X"FFE8",X"7FE8",X"7FE8",
-- Sprite empty 7 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0FFF",X"0FFF",X"0C20",X"0C20",X"0C20",
-- Sprite empty 8
X"0000",X"0000",X"0000",X"0000",X"07FF",X"1C00",X"1800",X"1800",X"1800",X"1800",X"1800",X"D800",X"D800",X"5800",X"5FFF",X"4FFF",


-- Tile #7
X"17C7",X"0C3F",X"21FF",X"2FFF",X"2FFF",X"2FFF",X"2FFF",X"2FFF",X"2FFF",X"2000",X"2FFF",X"2FFF",X"2FFF",X"2FFF",X"2FFF",X"21FF",
-- Tile #8
X"FFFB",X"FFFB",X"FF7B",X"FFFB",X"FFFB",X"FFF3",X"FFF3",X"FFF3",X"FFF3",X"0003",X"FFFB",X"FFFB",X"FFFB",X"FFFB",X"FFFB",X"FF7B",
-- Tile #9
X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF7",
-- Tile #10
X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"FFFD",
-- Tile #11
X"DFFF",X"DFFF",X"DFFF",X"DFFF",X"DFFF",X"DFFF",X"DFFF",X"DFFF",X"DFFF",X"DFFF",X"DFFF",X"DFFF",X"DFFF",X"DFFF",X"DFFF",X"DFFF",
-- Tile #12
X"7FE8",X"7FF4",X"BFF4",X"BFF4",X"BFF4",X"BFF4",X"BFF4",X"DFF4",X"C004",X"DFF4",X"DFF4",X"BFF4",X"BFF4",X"BFF4",X"BFF4",X"7FF4",
-- Sprite empty 15 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0FFF",X"0FFF",X"0C20",X"0C20",X"0C20",
-- Sprite empty 16
X"0000",X"0000",X"0000",X"0000",X"07FF",X"1C00",X"1800",X"1800",X"1800",X"1800",X"1800",X"D800",X"D800",X"5800",X"5FFF",X"4FFF",

-- Tile #13
X"2E3F",X"17C3",X"17FC",X"1BFF",X"0BFF",X"0DFF",X"05FF",X"06FF",X"033F",X"00CF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #14
X"FFFB",X"FFFB",X"7FFD",X"87FD",X"F0FD",X"FF1C",X"FFE0",X"FFFE",X"FFFF",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #15
X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF0",X"FFF3",X"7F8F",X"1E7F",X"8000",X"F1FF",X"0200",X"0300",X"0100",X"0000",X"0000",X"0000",
-- Tile #16
X"FFFD",X"FFFD",X"FFFD",X"FFFD",X"0001",X"CFAE",X"CFAF",X"CFAF",X"0000",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #17
X"DFFF",X"DFFF",X"DFFF",X"CFFE",X"E7FE",X"79FD",X"9C00",X"E300",X"01FF",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
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




