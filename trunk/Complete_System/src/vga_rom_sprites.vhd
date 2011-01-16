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
X"03FC",X"07FF",X"0FFF",X"1FFB",X"3F03",X"7FFF",X"FF03",X"FF7B",
X"FF03",X"FFFF",X"7FFB",X"3F03",X"1FFF",X"0FFF",X"07FF",X"03FC",
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