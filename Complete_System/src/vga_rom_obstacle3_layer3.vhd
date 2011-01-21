library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity vga_rom_obstacle3_layer3 is
   port(
      clk: in std_logic;
      addr: in std_logic_vector(8 downto 0);
      data: out std_logic_vector(15 downto 0)
   );
end vga_rom_obstacle3_layer3;

architecture arch of vga_rom_obstacle3_layer3 is
   constant ADDR_WIDTH: integer:=9;
   constant DATA_WIDTH: integer:=16;
   type rom_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);
   -- ROM definition
   constant obstacle3_ROM: rom_type:=(  -- 2^9-by-16
-- OBSTACLE 3 layer 3
-- Tile #1
X"0000",X"0000",X"0000",X"0000",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0000",X"0000",
-- Tile #2
X"0000",X"0000",X"01FF",X"0000",X"EFE0",X"EFE0",X"01E0",X"01E0",X"01E0",X"01E0",X"01E0",X"01E0",X"CFE0",X"CFE0",X"0000",X"0000",
-- Tile #3
X"0000",X"0000",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #4
X"0000",X"0000",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0001",
-- Tile #5
X"0000",X"0000",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"02FF",X"1EFF",X"7EFF",X"FEFE",X"FF7C",
-- Tile #6
X"0000",X"0000",X"FFFC",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"C000",X"B800",X"7E00",X"7F80",X"FC70",
-- Tile #7
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #8
X"0000",X"0000",X"0000",X"0000",X"0000",X"0360",X"0360",X"0360",X"0360",X"0360",X"0360",X"0360",X"0360",X"0360",X"0360",X"0360",




-- Tile #9
X"0000",X"0000",X"0000",X"0003",X"0007",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"7F7E",X"7F7E",X"7F7E",
-- Tile #10
X"0000",X"0010",X"0018",X"FE08",X"FFEC",X"1FEE",X"03DF",X"00FF",X"001F",X"001F",X"001F",X"001F",X"0000",X"FF7F",X"FF7F",X"FF7F",
-- Tile #11
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"8000",X"C00F",X"C00F",X"C00F",X"C00F",X"001F",X"FFFF",X"FFFF",
-- Tile #12
X"0002",X"0007",X"0007",X"000F",X"001F",X"0078",X"0007",X"07FF",X"0003",X"FFFB",X"FFFB",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF7",
-- Tile #13
X"FF79",X"0F73",X"F0A4",X"FFCB",X"F05F",X"0FFF",X"FFFF",X"FFFE",X"FFFE",X"8000",X"BBDF",X"8000",X"FFFE",X"FFFF",X"FFFF",X"FFFF",
-- Tile #14
X"F3FC",X"8FFF",X"7FF8",X"FC07",X"FFFF",X"FFFF",X"FFFF",X"07FF",X"F7FF",X"FBFF",X"F3FF",X"E7FF",X"CFFF",X"1FFF",X"FFFF",X"FFFF",
-- Tile #15
X"0000",X"0000",X"0000",X"F000",X"FE00",X"FF80",X"FFC0",X"FFC0",X"FFC0",X"FFC0",X"FFC0",X"FFC0",X"FFC0",X"FFC0",X"FFC0",X"FFC0",
-- Tile #16
X"0360",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",



-- Tile #17
X"7F7E",X"7F7E",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0007",X"0003",X"0000",X"0000",X"0000",X"0000",
-- Tile #18
X"FF7F",X"FF7F",X"0000",X"001F",X"001F",X"001F",X"001F",X"00FF",X"03DF",X"1FEE",X"FFEC",X"FE08",X"0018",X"0010",X"0000",X"0000",
-- Tile #19
X"FFFF",X"001F",X"C00F",X"C00F",X"C00F",X"C00F",X"8000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #20
X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFFB",X"FFFB",X"0003",X"07FF",X"0007",X"0078",X"001F",X"000F",X"0007",X"0007",X"0002",X"0001",
-- Tile #21
X"FFFF",X"FFFF",X"FFFE",X"FFFE",X"FFFE",X"FFFE",X"FFFE",X"FFFE",X"FFFF",X"1FFF",X"F03F",X"FF8B",X"F0A4",X"0F73",X"FF79",X"FF7C",
-- Tile #22
X"C9FF",X"BE7F",X"7FBF",X"FF7F",X"FF7F",X"FF7F",X"FF7F",X"7E7F",X"BCFF",X"DBFF",X"E7FF",X"FC07",X"7FF8",X"8FFF",X"F3FC",X"FC70",
-- Tile #23
X"FFC0",X"FFC0",X"FFC0",X"DDC0",X"BEC0",X"A2C0",X"A2C0",X"BEC0",X"80C0",X"FF80",X"FE00",X"F000",X"0000",X"0000",X"0000",X"0000",
-- Tile #24
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0360",X"0360",


-- Tile #25
X"0000",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #26
X"0000",X"CFE0",X"CFE0",X"01E0",X"01E0",X"01E0",X"01E0",X"01E0",X"01E0",X"EFE0",X"EFE0",X"0000",X"01FF",X"0000",X"0000",X"0000",
-- Tile #27
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"0000",X"0000",X"0000",
-- Tile #28
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"0000",X"0000",X"0000",
-- Tile #29
X"FEFE",X"7EFF",X"1EFF",X"02FF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"0000",X"0000",X"0000",
-- Tile #30
X"7F80",X"7E00",X"B800",X"C000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFC",X"0000",X"0000",X"0000",
-- Tile #31
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #32
X"0360",X"0360",X"0360",X"0360",X"0360",X"0360",X"0360",X"0360",X"0360",X"0360",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",


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
   data <= obstacle3_ROM(to_integer(unsigned(addr_reg)));
end arch;




