library IEEE;
use IEEE.std_logic_1164.all;

entity Or_32 is
    port(X : in std_logic_vector(31 downto 0);
        Y : in std_logic_vector(31 downto 0);
        output : out std_logic_vector(31 downto 0));
end Or_32;

architecture dataflow of Or_32 is
begin
    Or32: for i in 0 to 31 generate
        output(i) <= X(i) or Y(i);
    end generate Or32;
end dataflow;