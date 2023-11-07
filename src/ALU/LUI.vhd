library IEEE;
use IEEE.std_logic_1164.all;

entity LUI is
    port(input : in std_logic_vector(31 downto 0);
        output : out std_logic_vector(31 downto 0));
end LUI;

architecture dataflow of LUI is
begin
    output <= input(15 downto 0) & x"0000";
end dataflow;