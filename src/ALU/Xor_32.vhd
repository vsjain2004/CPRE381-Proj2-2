library IEEE;
use IEEE.std_logic_1164.all;

entity Xor_32 is
    port(X : in std_logic_vector(31 downto 0);
        Y : in std_logic_vector(31 downto 0);
        output : out std_logic_vector(31 downto 0));
end Xor_32;

architecture dataflow of Xor_32 is
begin
    Xor32: for i in 0 to 31 generate
        output(i) <= X(i) xor Y(i);
    end generate Xor32;
end dataflow;