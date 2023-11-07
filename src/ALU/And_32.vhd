library IEEE;
use IEEE.std_logic_1164.all;

entity And_32 is
    port(X : in std_logic_vector(31 downto 0);
        Y : in std_logic_vector(31 downto 0);
        output : out std_logic_vector(31 downto 0));
end And_32;

architecture dataflow of And_32 is
begin
    And32: for i in 0 to 31 generate
        output(i) <= X(i) and Y(i);
    end generate And32;
end dataflow;