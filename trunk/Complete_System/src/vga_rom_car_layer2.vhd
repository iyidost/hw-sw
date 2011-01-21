library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity vga_rom_car_layer2 is
   port(
      clk: in std_logic;
      addr: in std_logic_vector(8 downto 0);
      data: out std_logic_vector(15 downto 0)
   );
end vga_rom_car_layer2;

architecture arch of vga_rom_car_layer2 is
   constant ADDR_WIDTH: integer:=9;
   constant DATA_WIDTH: integer:=16;
   type rom_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);
   -- ROM definition
   constant CAR_ROM: rom_type:=(  -- 2^9-by-16
----------------------------------------------------------
-- Memory data for the car pics  --
----------------------------------------------------------
-- Tile #1
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"03DF",X"03DF",X"03DF",
-- Tile #2
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"8000",X"8000",X"8000",
-- Tile #3
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0007",
-- Tile #4
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",
-- Tile #5
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"8000",
-- Tile #6
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",

-- Tile #7
X"03DF",X"03DF",X"03DE",X"03DC",X"03D8",X"03D0",X"03D0",X"03D0",X"03C0",X"03C0",X"03C0",X"03D8",X"03D8",X"03C7",X"03DF",X"03DF",
-- Tile #8
X"8000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"003F",X"1FFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",
-- Tile #9
X"000F",X"001F",X"003F",X"007F",X"00FF",X"01FF",X"03FF",X"07FF",X"0FFF",X"0000",X"FFFF",X"FFFE",X"FFF8",X"FFF0",X"FFF0",X"FFF0",
-- Tile #10
X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"F801",X"07FC",X"FFFF",X"001F",X"0008",X"000C",X"000E",X"000E",
-- Tile #11
X"C000",X"E000",X"F000",X"F800",X"F800",X"FC00",X"FE00",X"FF01",X"FF80",X"7FC1",X"1FC1",X"C7FD",X"F1FD",X"1C7D",X"071D",X"03C5",
-- Tile #12
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"E1E0",X"0000",X"E1E0",X"E1E0",X"E1E0",X"E1E0",X"E1E0",X"E1E0",X"E1E0",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",

-- Tile #13
X"03DF",X"03C7",X"03D8",X"03D8",X"03C0",X"03C0",X"03C0",X"03D0",X"03D0",X"03D0",X"03D8",X"03DC",X"03DE",X"03DF",X"03DF",X"03DF",
-- Tile #14
X"FFFF",X"FFFF",X"FFFF",X"1FFF",X"003F",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"8000",X"8000",
-- Tile #15
X"FFF0",X"FFF0",X"FFF8",X"FFFE",X"FFFF",X"0000",X"0FFF",X"07FF",X"03FF",X"01FF",X"00FF",X"007F",X"003F",X"001F",X"000F",X"0007",
-- Tile #16
X"000E",X"000C",X"0008",X"001F",X"FFFF",X"07FC",X"F801",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",
-- Tile #17
X"071D",X"1C7D",X"F1FD",X"C7FD",X"1FC1",X"7FC1",X"FF81",X"FF01",X"FE00",X"FC01",X"F800",X"F800",X"F000",X"E000",X"C000",X"8000",
-- Tile #18
X"E1E0",X"E1E0",X"E1E0",X"E1E0",X"E1E0",X"E1E0",X"E1E0",X"E1E0",X"0000",X"E1E0",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 110 
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Sprite empty 111
X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",

-- Tile #19
X"03DF",X"03DF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
-- Tile #20
X"8000",X"8000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",
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