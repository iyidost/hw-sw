library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity vga_rom_obstacle3_inv is
   port(
      clk: in std_logic;
      addr: in std_logic_vector(8 downto 0);
      data: out std_logic_vector(15 downto 0)
   );
end vga_rom_obstacle3_inv;

architecture arch of vga_rom_obstacle3_inv is
   constant ADDR_WIDTH: integer:=9;
   constant DATA_WIDTH: integer:=16;
   type rom_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);
   -- ROM definition
   constant obstacle3_inv_ROM: rom_type:=(  -- 2^9-by-16
-- OBSTACLE3_inv 
-- Tile #1
X"0000",X"0000",X"0000",X"0000",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0000",X"0007",
-- Tile #2
X"0000",X"0000",X"01FF",X"0000",X"EFE9",X"EFE1",X"01E1",X"4DE1",X"4DE1",X"4DE1",X"4DE1",X"01E1",X"CFE5",X"CFE3",X"0000",X"FFD3",
-- Tile #3
X"0000",X"0000",X"FFFF",X"0000",X"FE3F",X"FF8F",X"FFF3",X"FFFC",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"0000",X"FFF7",
-- Tile #4
X"0000",X"0000",X"FFFF",X"0000",X"FFEF",X"FF8F",X"FE6F",X"FEEF",X"3D4F",X"CD4F",X"FAAF",X"FAAF",X"F86F",X"F9EE",X"0000",X"F9FD",
-- Tile #5
X"0000",X"0000",X"FFFF",X"0000",X"FFFF",X"FFFD",X"FFFD",X"FFFC",X"FFFD",X"FFFD",X"FC00",X"E2FF",X"9EFF",X"7EFF",X"FEFE",X"FF7C",
-- Tile #6
X"0000",X"0000",X"FFFC",X"0000",X"FFEF",X"FFEF",X"FFEF",X"71EF",X"FFEF",X"FFEF",X"1FEF",X"C7EF",X"B9EF",X"7E2F",X"7F80",X"FC73",
-- Tile #7
X"0000",X"0000",X"0000",X"0000",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"0000",X"FFFF",
-- Tile #8
X"0000",X"0000",X"0000",X"0000",X"F800",X"FB60",X"FB60",X"FB60",X"FB60",X"FB60",X"FB60",X"FB60",X"FB60",X"FB60",X"7B60",X"9B60",


-- Tile #9
X"0007",X"0007",X"0004",X"0003",X"0007",X"0000",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0000",X"7F7E",X"7F7E",X"7F7E",
-- Tile #10
X"FFCC",X"FFD7",X"01DB",X"FE09",X"FFED",X"1FEE",X"E3DF",X"F8FF",X"FF1F",X"FFDF",X"FFDF",X"FFDF",X"0000",X"FF7F",X"FF7F",X"FF7F",
-- Tile #11
X"3FF7",X"C1FF",X"FC18",X"FFE7",X"FF97",X"FF37",X"7CF7",X"33F7",X"AFF0",X"DFEF",X"DFEF",X"DFEF",X"DFEF",X"001F",X"FFFF",X"FFFF",
-- Tile #12
X"E77A",X"1F77",X"FF67",X"FF6F",X"FF1F",X"FE78",X"F807",X"E7FF",X"0003",X"FFFB",X"FFFB",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF7",
-- Tile #13
X"FF79",X"0F73",X"F0A4",X"FFCB",X"F05F",X"0FFF",X"FFFF",X"FFFE",X"FFFE",X"8000",X"BBDF",X"8000",X"FFFE",X"FFFF",X"FFFF",X"FFFF",
-- Tile #14
X"F3FC",X"8FFF",X"7FF8",X"FC07",X"FFFF",X"FFFF",X"FFFF",X"07FF",X"F7FF",X"FBFF",X"F3FF",X"E7FF",X"CFFF",X"1FFF",X"FFFF",X"FFFF",
-- Tile #15
X"E7FD",X"39FD",X"067E",X"F19E",X"FE47",X"FF99",X"FFDE",X"FFDF",X"FFDD",X"FFDC",X"FFDF",X"FFDF",X"FFCF",X"FFCF",X"FFDF",X"FFDF",
-- Tile #16
X"E360",X"F800",X"FC00",X"FC00",X"7C00",X"3C00",X"BC00",X"DC00",X"CC00",X"FC00",X"3C00",X"9C00",X"EC00",X"F000",X"FC00",X"FC00",


-- Tile #17
X"7F7E",X"7F7E",X"0000",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0000",X"0007",X"0003",X"0004",X"0007",X"0007",X"0007",
-- Tile #18
X"FF7F",X"FF7F",X"0000",X"FFDF",X"FFDF",X"FFDF",X"FF1F",X"F8FF",X"E3DF",X"1FEE",X"FFED",X"FE09",X"01DB",X"FFD7",X"FFCC",X"FFD3",
-- Tile #19
X"FFFF",X"001F",X"DFEF",X"DFEF",X"DFEF",X"DFEF",X"AFF0",X"33F7",X"7CF7",X"FF37",X"FF97",X"FFE7",X"FC18",X"C1FF",X"3FF7",X"FFF7",
-- Tile #20
X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFFB",X"FFFB",X"0003",X"E7FF",X"F807",X"FE78",X"FF1F",X"FF6F",X"FF67",X"1F77",X"E77A",X"F9FD",
-- Tile #21
X"FFFF",X"FFFF",X"FFFE",X"FFFE",X"FFFE",X"FFFE",X"FFFE",X"FFFE",X"FFFF",X"1FFF",X"F03F",X"FF8B",X"F0A4",X"0F73",X"FF79",X"FF7C",
-- Tile #22
X"C9FF",X"BE7F",X"7FBF",X"FF7F",X"FF7F",X"FF7F",X"FF7F",X"7E7F",X"BCFF",X"DBFF",X"E7FF",X"FC07",X"7FF8",X"8FFF",X"F3FC",X"FC73",
-- Tile #23
X"FFDF",X"FFCF",X"FFCF",X"DDDF",X"BEDF",X"A2DC",X"A2DD",X"BEDF",X"80DE",X"FF99",X"FE47",X"F19E",X"067E",X"39FD",X"E7FD",X"FFFF",
-- Tile #24
X"FC00",X"F000",X"EC00",X"9C00",X"3C00",X"FC00",X"CC00",X"DC00",X"BC00",X"3C00",X"7C00",X"FC00",X"FC00",X"F800",X"E360",X"9B60",


-- Tile #25
X"0000",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0007",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #26
X"0000",X"CFE3",X"CFE5",X"01E1",X"4DE1",X"4DE1",X"4DE1",X"4DE1",X"01E1",X"EFE1",X"EFE9",X"0000",X"01FF",X"0000",X"0000",X"0000",
-- Tile #27
X"0000",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFC",X"FFF3",X"FF8F",X"FE3F",X"0000",X"FFFF",X"0000",X"0000",X"0000",
-- Tile #28
X"0000",X"F9EE",X"F86F",X"FAAF",X"FAAF",X"CD4F",X"3D4F",X"FEEF",X"FE6F",X"FF8F",X"FFEF",X"0000",X"FFFF",X"0000",X"0000",X"0000",
-- Tile #29
X"FEFE",X"7EFF",X"9EFF",X"E2FF",X"FC00",X"FFFD",X"FFFD",X"FFFC",X"FFFD",X"FFFD",X"FFFF",X"0000",X"FFFF",X"0000",X"0000",X"0000",
-- Tile #30
X"7F80",X"7E2F",X"B9EF",X"C7EF",X"1FEF",X"FFEF",X"FFEF",X"71EC",X"FFEF",X"FFEF",X"FFEF",X"0000",X"FFFC",X"0000",X"0000",X"0000",
-- Tile #31
X"0000",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"FFF7",X"03F7",X"FFF7",X"FFF7",X"FFF7",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #32
X"7B60",X"FB60",X"FB60",X"FB60",X"FB60",X"FB60",X"FB60",X"FB60",X"FB60",X"FB60",X"F800",X"0000",X"0000",X"0000",X"0000",X"0000",


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
   data <= obstacle3_inv_ROM(to_integer(unsigned(addr_reg)));
end arch;



