library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.MIPS_types.all;

entity mux32t1_array is
    port(s : in std_logic_vector(4 downto 0);
        data: in reg_data_array;
        output : out std_logic_vector(31 downto 0));
end mux32t1_array;

architecture dataflow of mux32t1_array is
begin
    output <= data(to_integer(unsigned(s)));
end dataflow;