library IEEE;
use IEEE.std_logic_1164.all;

entity extend1632 is
    port(data : in std_logic_vector(15 downto 0);
        exttype : in std_logic;
        result : out std_logic_vector(31 downto 0));
end extend1632;

architecture dataflow of extend1632 is
begin
    result <= x"0000" & data when (exttype = '0' or (exttype='1' and data(15)='0')) else
              x"FFFF" & data when (exttype='1' and data(15)='1') else
              x"0000" & data;      
end dataflow;