library IEEE;
use IEEE.std_logic_1164.all;

entity Shifter is
    port(data : in std_logic_vector(31 downto 0);
        shamt : in std_logic_vector(4 downto 0);
        shdir : in std_logic;
        shtype : in std_logic;
        output : out std_logic_vector(31 downto 0));
end Shifter;

architecture dataflow of Shifter is

    signal msb : std_logic_vector(30 downto 0);
    signal logical : std_logic_vector(31 downto 0);
    signal arithmetic : std_logic_vector(31 downto 0);
begin
    msb <= (others => data(31));

    with (shdir & shamt) select
        logical <= data when "000000",
                   data(30 downto 0) & '0' when "000001",
                   data(29 downto 0) & "00" when "000010",
                   data(28 downto 0) & "000" when "000011",
                   data(27 downto 0) & "0000" when "000100",
                   data(26 downto 0) & "00000" when "000101",
                   data(25 downto 0) & "000000" when "000110",
                   data(24 downto 0) & "0000000" when "000111",
                   data(23 downto 0) & "00000000" when "001000",
                   data(22 downto 0) & "000000000" when "001001",
                   data(21 downto 0) & "0000000000" when "001010",
                   data(20 downto 0) & "00000000000" when "001011",
                   data(19 downto 0) & "000000000000" when "001100",
                   data(18 downto 0) & "0000000000000" when "001101",
                   data(17 downto 0) & "00000000000000" when "001110",
                   data(16 downto 0) & "000000000000000" when "001111",
                   data(15 downto 0) & "0000000000000000" when "010000",
                   data(14 downto 0) & "00000000000000000" when "010001",
                   data(13 downto 0) & "000000000000000000" when "010010",
                   data(12 downto 0) & "0000000000000000000" when "010011",
                   data(11 downto 0) & "00000000000000000000" when "010100",
                   data(10 downto 0) & "000000000000000000000" when "010101",
                   data(9 downto 0) & "0000000000000000000000" when "010110",
                   data(8 downto 0) & "00000000000000000000000" when "010111",
                   data(7 downto 0) & "000000000000000000000000" when "011000",
                   data(6 downto 0) & "0000000000000000000000000" when "011001",
                   data(5 downto 0) & "00000000000000000000000000" when "011010",
                   data(4 downto 0) & "000000000000000000000000000" when "011011",
                   data(3 downto 0) & "0000000000000000000000000000" when "011100",
                   data(2 downto 0) & "00000000000000000000000000000" when "011101",
                   data(1 downto 0) & "000000000000000000000000000000" when "011110",
                   data(0) & "0000000000000000000000000000000" when "011111",
                   data when "100000",
                   '0' & data(31 downto 1) when "100001",
                   "00" & data(31 downto 2) when "100010",
                   "000" & data(31 downto 3) when "100011",
                   "0000" & data(31 downto 4) when "100100",
                   "00000" & data(31 downto 5) when "100101",
                   "000000" & data(31 downto 6) when "100110",
                   "0000000" & data(31 downto 7) when "100111",
                   "00000000" & data(31 downto 8) when "101000",
                   "000000000" & data(31 downto 9) when "101001",
                   "0000000000" & data(31 downto 10) when "101010",
                   "00000000000" & data(31 downto 11) when "101011",
                   "000000000000" & data(31 downto 12) when "101100",
                   "0000000000000" & data(31 downto 13) when "101101",
                   "00000000000000" & data(31 downto 14) when "101110",
                   "000000000000000" & data(31 downto 15) when "101111",
                   "0000000000000000" & data(31 downto 16) when "110000",
                   "00000000000000000" & data(31 downto 17) when "110001",
                   "000000000000000000" & data(31 downto 18) when "110010",
                   "0000000000000000000" & data(31 downto 19) when "110011",
                   "00000000000000000000" & data(31 downto 20) when "110100",
                   "000000000000000000000" & data(31 downto 21) when "110101",
                   "0000000000000000000000" & data(31 downto 22) when "110110",
                   "00000000000000000000000" & data(31 downto 23) when "110111",
                   "000000000000000000000000" & data(31 downto 24) when "111000",
                   "0000000000000000000000000" & data(31 downto 25) when "111001",
                   "00000000000000000000000000" & data(31 downto 26) when "111010",
                   "000000000000000000000000000" & data(31 downto 27) when "111011",
                   "0000000000000000000000000000" & data(31 downto 28) when "111100",
                   "00000000000000000000000000000" & data(31 downto 29) when "111101",
                   "000000000000000000000000000000" & data(31 downto 30) when "111110",
                   "0000000000000000000000000000000" & data(31) when "111111",
                   x"00000000" when others;
    
    with shamt select
        arithmetic <= data when "00000",
                      msb(0) & data(31 downto 1) when "00001",
                      msb(1 downto 0) & data(31 downto 2) when "00010",
                      msb(2 downto 0) & data(31 downto 3) when "00011",
                      msb(3 downto 0) & data(31 downto 4) when "00100",
                      msb(4 downto 0) & data(31 downto 5) when "00101",
                      msb(5 downto 0) & data(31 downto 6) when "00110",
                      msb(6 downto 0) & data(31 downto 7) when "00111",
                      msb(7 downto 0) & data(31 downto 8) when "01000",
                      msb(8 downto 0) & data(31 downto 9) when "01001",
                      msb(9 downto 0) & data(31 downto 10) when "01010",
                      msb(10 downto 0) & data(31 downto 11) when "01011",
                      msb(11 downto 0) & data(31 downto 12) when "01100",
                      msb(12 downto 0) & data(31 downto 13) when "01101",
                      msb(13 downto 0) & data(31 downto 14) when "01110",
                      msb(14 downto 0) & data(31 downto 15) when "01111",
                      msb(15 downto 0) & data(31 downto 16) when "10000",
                      msb(16 downto 0) & data(31 downto 17) when "10001",
                      msb(17 downto 0) & data(31 downto 18) when "10010",
                      msb(18 downto 0) & data(31 downto 19) when "10011",
                      msb(19 downto 0) & data(31 downto 20) when "10100",
                      msb(20 downto 0) & data(31 downto 21) when "10101",
                      msb(21 downto 0) & data(31 downto 22) when "10110",
                      msb(22 downto 0) & data(31 downto 23) when "10111",
                      msb(23 downto 0) & data(31 downto 24) when "11000",
                      msb(24 downto 0) & data(31 downto 25) when "11001",
                      msb(25 downto 0) & data(31 downto 26) when "11010",
                      msb(26 downto 0) & data(31 downto 27) when "11011",
                      msb(27 downto 0) & data(31 downto 28) when "11100",
                      msb(28 downto 0) & data(31 downto 29) when "11101",
                      msb(29 downto 0) & data(31 downto 30) when "11110",
                      msb(30 downto 0) & data(31) when "11111",
                      x"00000000" when others;
    
    with shtype select
        output <= logical when '0',
                  arithmetic when '1',
                  x"00000000" when others;
end dataflow;