library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity vga_rom is
   port(
      clk: in std_logic;
      addr: in std_logic_vector(8 downto 0);
      data: out std_logic_vector(7 downto 0)
   );
end vga_rom;

architecture arch of vga_rom is
   constant ADDR_WIDTH: integer:=9;
   constant DATA_WIDTH: integer:=8;
   type rom_type is array (0 to 2**ADDR_WIDTH-1)
        of std_logic_vector(DATA_WIDTH-1 downto 0);
   -- ROM definition
   constant HEX2LED_ROM: rom_type:=(  -- 2^4-by-7
-----------------------------------------
-- Memory data for the background pics --
-----------------------------------------

-- Bytes 0 to 7 of BackgroundID = 0 (Name = 0) 
X"00", X"1e", X"21", X"23", X"25", X"29", X"31", X"1e", 

-- Bytes 0 to 7 of BackgroundID = 1 (Name = 1) 
X"00", X"04", X"0c", X"14", X"04", X"04", X"04", X"1f", 

-- Bytes 0 to 7 of BackgroundID = 2 (Name = 2) 
X"00", X"1e", X"21", X"01", X"1e", X"20", X"20", X"3f", 

-- Bytes 0 to 7 of BackgroundID = 3 (Name = 3) 
X"00", X"1e", X"21", X"01", X"0e", X"01", X"21", X"1e", 

-- Bytes 0 to 7 of BackgroundID = 4 (Name = 4) 
X"00", X"06", X"0a", X"12", X"22", X"3f", X"02", X"02", 

-- Bytes 0 to 7 of BackgroundID = 5 (Name = 5) 
X"00", X"3f", X"20", X"3e", X"01", X"01", X"21", X"1e", 

-- Bytes 0 to 7 of BackgroundID = 6 (Name = 6) 
X"00", X"1e", X"21", X"20", X"3e", X"21", X"21", X"1e", 

-- Bytes 0 to 7 of BackgroundID = 7 (Name = 7) 
X"00", X"3f", X"01", X"02", X"04", X"08", X"08", X"08", 

-- Bytes 0 to 7 of BackgroundID = 8 (Name = 8) 
X"00", X"1e", X"21", X"21", X"1e", X"21", X"21", X"1e", 

-- Bytes 0 to 7 of BackgroundID = 9 (Name = 9) 
X"00", X"1e", X"21", X"21", X"1f", X"01", X"21", X"1e", 

-- Bytes 0 to 7 of BackgroundID = 10 (Name = floor) 
X"fb", X"00", X"bf", X"00", X"ef", X"00", X"00", X"00", 

-- Bytes 0 to 7 of BackgroundID = 11 (Name = stairLeft) 
X"30", X"30", X"30", X"3f", X"3f", X"30", X"30", X"30", 

-- Bytes 0 to 7 of BackgroundID = 12 (Name = stairRight) 
X"0c", X"0c", X"0c", X"fc", X"fc", X"0c", X"0c", X"0c", 

-- Bytes 0 to 7 of BackgroundID = 13 (Name = egg) 
X"38", X"7e", X"ff", X"ff", X"ff", X"7e", X"38", X"00", 

-- Bytes 0 to 7 of BackgroundID = 14 (Name = food) 
X"00", X"00", X"00", X"10", X"28", X"54", X"aa", X"00", 

-- Bytes 0 to 7 of BackgroundID = 15 (Name = life) 
X"00", X"00", X"1c", X"1c", X"7f", X"00", X"00", X"00", 

-- Bytes 0 to 7 of BackgroundID = 16 (Name = score1) 
X"63", X"94", X"84", X"64", X"14", X"14", X"94", X"63", 

-- Bytes 0 to 7 of BackgroundID = 17 (Name = score2) 
X"19", X"a5", X"25", X"25", X"25", X"25", X"a5", X"19", 

-- Bytes 0 to 7 of BackgroundID = 18 (Name = score3) 
X"cf", X"28", X"28", X"ce", X"48", X"48", X"28", X"2f", 

-- Bytes 0 to 7 of BackgroundID = 19 (Name = player1) 
X"00", X"f2", X"8a", X"8a", X"f2", X"82", X"82", X"83", 

-- Bytes 0 to 7 of BackgroundID = 20 (Name = player2) 
X"00", X"0e", X"11", X"11", X"1f", X"11", X"11", X"d1", 

-- Bytes 0 to 7 of BackgroundID = 21 (Name = player3) 
X"00", X"45", X"45", X"29", X"11", X"11", X"11", X"11", 

-- Bytes 0 to 7 of BackgroundID = 22 (Name = player4) 
X"00", X"ee", X"09", X"09", X"ee", X"09", X"09", X"e9", 

-- Bytes 0 to 7 of BackgroundID = 23 (Name = level1) 
X"00", X"87", X"84", X"84", X"87", X"84", X"84", X"f7", 

-- Bytes 0 to 7 of BackgroundID = 24 (Name = level2) 
X"00", X"a2", X"22", X"22", X"a2", X"22", X"14", X"88", 

-- Bytes 0 to 7 of BackgroundID = 25 (Name = level3) 
X"00", X"f4", X"84", X"84", X"f4", X"84", X"84", X"f7", 

-- Bytes 0 to 7 of BackgroundID = 26 (Name = bonus1) 
X"00", X"e3", X"94", X"94", X"e4", X"94", X"94", X"e3", 

-- Bytes 0 to 7 of BackgroundID = 27 (Name = bonus2) 
X"00", X"25", X"a5", X"b5", X"ad", X"a5", X"a5", X"24", 

-- Bytes 0 to 7 of BackgroundID = 28 (Name = bonus3) 
X"00", X"26", X"29", X"28", X"26", X"21", X"29", X"c6", 

-- Bytes 0 to 7 of BackgroundID = 29 (Name = time1) 
X"00", X"fb", X"20", X"20", X"20", X"20", X"20", X"23", 

-- Bytes 0 to 7 of BackgroundID = 30 (Name = time2) 
X"00", X"e8", X"8c", X"8b", X"88", X"88", X"88", X"e8", 

-- Bytes 0 to 7 of BackgroundID = 31 (Name = time3) 
X"00", X"5e", X"d0", X"50", X"5e", X"50", X"50", X"5e", 

-- Bytes 0 to 7 of BackgroundID = 32 (Name = cage1) 
X"00", X"00", X"07", X"0c", X"08", X"0c", X"07", X"01", 

-- Bytes 0 to 7 of BackgroundID = 33 (Name = cage2) 
X"00", X"00", X"c0", X"60", X"20", X"60", X"c0", X"00", 

-- Bytes 0 to 7 of BackgroundID = 34 (Name = cage3) 
X"00", X"00", X"03", X"05", X"0a", X"15", X"29", X"2a", 

-- Bytes 0 to 7 of BackgroundID = 35 (Name = cage4) 
X"1f", X"e0", X"18", X"67", X"89", X"11", X"11", X"21", 

-- Bytes 0 to 7 of BackgroundID = 36 (Name = cage5) 
X"f0", X"0e", X"31", X"cc", X"22", X"11", X"11", X"08", 

-- Bytes 0 to 7 of BackgroundID = 37 (Name = cage6) 
X"00", X"00", X"80", X"40", X"a0", X"50", X"28", X"a8", 

-- Bytes 0 to 7 of BackgroundID = 38 (Name = cage7) 
X"52", X"52", X"52", X"52", X"72", X"5a", X"57", X"52", 

-- Bytes 0 to 7 of BackgroundID = 39 (Name = cage8) 
X"21", X"21", X"21", X"21", X"21", X"21", X"21", X"df", 

-- Bytes 0 to 7 of BackgroundID = 40 (Name = cage9) 
X"08", X"08", X"08", X"08", X"08", X"08", X"09", X"fe", 

-- Bytes 0 to 7 of BackgroundID = 41 (Name = cage10) 
X"94", X"94", X"94", X"94", X"9c", X"b4", X"d4", X"94", 

-- Bytes 0 to 7 of BackgroundID = 42 (Name = cage11) 
X"52", X"52", X"52", X"52", X"72", X"5a", X"57", X"52", 

-- Bytes 0 to 7 of BackgroundID = 43 (Name = cage12) 
X"21", X"21", X"21", X"21", X"21", X"21", X"21", X"df", 

-- Bytes 0 to 7 of BackgroundID = 44 (Name = cage13) 
X"08", X"08", X"08", X"08", X"08", X"08", X"09", X"fe", 

-- Bytes 0 to 7 of BackgroundID = 45 (Name = cage14) 
X"94", X"94", X"94", X"94", X"9c", X"b4", X"d4", X"94", 

-- Bytes 0 to 7 of BackgroundID = 46 (Name = cage15) 
X"52", X"52", X"52", X"52", X"32", X"0a", X"07", X"00", 

-- Bytes 0 to 7 of BackgroundID = 47 (Name = cage16) 
X"21", X"21", X"21", X"21", X"21", X"21", X"21", X"ff", 

-- Bytes 0 to 7 of BackgroundID = 48 (Name = cage17) 
X"08", X"08", X"08", X"08", X"08", X"08", X"09", X"fe", 

-- Bytes 0 to 7 of BackgroundID = 49 (Name = cage18) 
X"94", X"94", X"94", X"94", X"98", X"b0", X"c0", X"00", 

-- Bytes 0 to 7 of BackgroundID = 50 (Name = black) 
X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00", 

-- Bytes 0 to 7 of BackgroundID = 51 (Name = red) 
X"00", X"00", X"00", X"00", X"00", X"00", X"00", X"00",

others => X"00");
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