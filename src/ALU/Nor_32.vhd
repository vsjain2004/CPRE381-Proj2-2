library IEEE;
use IEEE.std_logic_1164.all;

entity Nor_32 is
    port(X : in std_logic_vector(31 downto 0);
        Y : in std_logic_vector(31 downto 0);
        output : out std_logic_vector(31 downto 0));
end Nor_32;

architecture dataflow of Nor_32 is
begin
    Nor32: for i in 0 to 31 generate
        output(i) <= X(i) nor Y(i);
    end generate Nor32;
end dataflow;