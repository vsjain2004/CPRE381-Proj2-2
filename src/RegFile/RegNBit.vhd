library IEEE;
use IEEE.std_logic_1164.all;

entity RegNBit is
    generic(N : integer := 32);
    port(clk : in std_logic;
         reset : in std_logic;
         we : in std_logic;
         data : in std_logic_vector(N-1 downto 0);
         o_data : out std_logic_vector(N-1 downto 0));
end RegNBit;

architecture structural of RegNBit is

    component dffg is
        port(i_CLK        : in std_logic;
             i_RST        : in std_logic;
             i_WE         : in std_logic;
             i_D          : in std_logic;
             o_Q          : out std_logic);
    end component;

begin
    NDFF : for i in 0 to N-1 generate
        DFFI : dffg
        port MAP(i_CLK => clk,
                 i_RST => reset,
                 i_WE => we,
                 i_D => data(i),
                 o_Q => o_data(i));
        end generate NDFF;
end structural;