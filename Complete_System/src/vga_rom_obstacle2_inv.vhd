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
-- OBSTACLE2 #1
X"0000",X"0000",X"001F",X"0030",X"0060",X"00C0",X"0080",X"0080",X"00C0",X"3FFF",X"2000",X"2000",X"2000",X"3000",X"1800",X"0400",
-- Tile #2
X"0000",X"0000",X"FFFF",X"0001",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0003",
-- Tile #3
X"0000",X"0000",X"0000",X"8000",X"C000",X"6000",X"6000",X"67F0",X"640F",X"C400",X"4400",X"47C0",X"443F",X"4400",X"8400",X"0300",
-- Tile #4
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0380",X"F380",X"1F80",X"03C0",X"81C0",X"7FE0",X"00E0",X"00F4",
-- Tile #5
X"0000",X"0000",X"03FF",X"0600",X"0C00",X"1800",X"1000",X"1000",X"1800",X"0C00",X"0600",X"03FF",X"0006",X"0001",X"0007",X"001F",
-- Tile #6
X"0000",X"0000",X"FFE0",X"0030",X"0018",X"000C",X"0004",X"0004",X"000C",X"0018",X"0030",X"FFE0",X"0700",X"9C00",X"F000",X"0C00",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0FFF",X"0FFF",X"0C20",X"0C20",X"0C20",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"07FF",X"1C00",X"1800",X"1800",X"1800",X"1800",X"1800",X"D800",X"D800",X"5800",X"5FFF",X"4FFF",


-- Tile #7
X"0200",X"0100",X"0080",X"0080",X"1080",X"1040",X"1840",X"1840",X"1840",X"15C7",X"1704",X"1004",X"1008",X"1008",X"1008",X"1008",
-- Tile #8
X"0002",X"0002",X"0002",X"0002",X"0002",X"0002",X"0003",X"0001",X"0000",X"FF7F",X"00C0",X"0100",X"0600",X"0400",X"0400",X"0400",
-- Tile #9
X"00FE",X"0021",X"0020",X"0030",X"002F",X"0020",X"003E",X"8021",X"6020",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #10
X"00FC",X"FF5C",X"004A",X"004B",X"FE4A",X"01E8",X"0028",X"FE24",X"0132",X"FFF1",X"000D",X"0005",X"0005",X"0005",X"0005",X"0005",
-- Tile #11
X"01E0",X"0F80",X"7C01",X"F007",X"800C",X"0006",X"0033",X"00C8",X"0308",X"0608",X"0408",X"0408",X"0408",X"0408",X"0408",X"0408",
-- Tile #12
X"0C00",X"3000",X"C000",X"0000",X"0000",X"0180",X"0180",X"C1C0",X"78C0",X"3FC0",X"01E0",X"0070",X"0030",X"0030",X"0030",X"0030",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0FFF",X"0FFF",X"0C20",X"0C20",X"0C20",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"07FF",X"1C00",X"1800",X"1800",X"1800",X"1800",X"1800",X"D800",X"D800",X"5800",X"5FFF",X"4FFF",


-- Tile #13
X"1008",X"1008",X"1008",X"1004",X"1704",X"15C7",X"1840",X"1840",X"1840",X"1040",X"1080",X"0080",X"0080",X"0100",X"0200",X"0400",
-- Tile #14
X"0400",X"0400",X"0600",X"0100",X"00C0",X"FF7F",X"0000",X"0001",X"0003",X"0002",X"0002",X"0002",X"0002",X"0002",X"0002",X"0003",
-- Tile #15
X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"6020",X"8021",X"003E",X"0020",X"002F",X"0030",X"0020",X"0021",X"00FE",X"0300",
-- Tile #16
X"0005",X"0005",X"0005",X"0005",X"000D",X"FFF1",X"0132",X"FE24",X"0028",X"01E8",X"FE4A",X"004B",X"004A",X"FF5C",X"00FC",X"00F4",
-- Tile #17
X"0408",X"0408",X"0408",X"0408",X"0408",X"0608",X"0308",X"00C8",X"0033",X"0006",X"800C",X"F007",X"7C01",X"0F80",X"01E0",X"001F",
-- Tile #18
X"0030",X"0030",X"0030",X"0070",X"01E0",X"3FC0",X"78C0",X"C1C0",X"0180",X"0180",X"0000",X"0000",X"C000",X"3000",X"0C00",X"0C00",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0FFF",X"0FFF",X"0C20",X"0C20",X"0C20",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"07FF",X"1C00",X"1800",X"1800",X"1800",X"1800",X"1800",X"D800",X"D800",X"5800",X"5FFF",X"4FFF",



-- Tile #19
X"1800",X"3000",X"2000",X"2000",X"2000",X"3FFF",X"00C0",X"0080",X"0080",X"00C0",X"0060",X"0030",X"001F",X"0000",X"0000",X"0000",
-- Tile #20
X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0001",X"FFFF",X"0000",X"0000",X"0000",
-- Tile #21
X"8400",X"4400",X"443F",X"47C0",X"4400",X"C400",X"640F",X"67F0",X"6000",X"6000",X"C000",X"8000",X"0000",X"0000",X"0000",X"0000",
-- Tile #22
X"00E0",X"7FE0",X"81C0",X"03C0",X"1F80",X"F380",X"0380",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #23
X"0007",X"0001",X"0006",X"03FF",X"0600",X"0C00",X"1800",X"1000",X"1000",X"1800",X"0C00",X"0600",X"03FF",X"0000",X"0000",X"0000",
-- Tile #24
X"F000",X"9C00",X"0700",X"FFE0",X"0030",X"0018",X"000C",X"0004",X"0004",X"000C",X"0018",X"0030",X"FFE0",X"0000",X"0000",X"0000",


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




