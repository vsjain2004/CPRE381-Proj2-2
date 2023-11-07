library IEEE;
use IEEE.std_logic_1164.all;

entity Neg_ext is
    port(neg : in std_logic;
        negext : out std_logic_vector(31 downto 0));
end Neg_ext;

architecture dataflow of Neg_ext is
begin
    negext <= x"0000000" & "000" & neg;
end dataflow;