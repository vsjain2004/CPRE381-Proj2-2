library IEEE;
use IEEE.std_logic_1164.all;

entity CLA_32 is
    port(X : in std_logic_vector(31 downto 0);
        Y : in std_logic_vector(31 downto 0);
        AddSub : in std_logic;
        S : out std_logic_vector(31 downto 0);
        zero : out std_logic;
        negative : out std_logic;
        overflow : out std_logic;
        carry : out std_logic);
end CLA_32;

architecture structural of CLA_32 is

    component CLA_8_ext
        port(X : in std_logic_vector(7 downto 0);
        Y : in std_logic_vector(7 downto 0);
        Cin : in std_logic;
        S : out std_logic_vector(7 downto 0);
        P : out std_logic;
        G : out std_logic;
        C : out std_logic);
    end component;

    signal c8 : std_logic;
    signal g8 : std_logic;
    signal p8 : std_logic;
    signal c16 : std_logic;
    signal g16 : std_logic;
    signal p16 : std_logic;
    signal c24 : std_logic;
    signal g24 : std_logic;
    signal p24 : std_logic;
    signal c31 : std_logic;
    signal c32 : std_logic;
    signal g32 : std_logic;
    signal p32 : std_logic;
    signal Y_xor : std_logic_vector(31 downto 0);
    signal s_out : std_logic_vector(31 downto 0);
begin
    Yxor : for i in 0 to 31 generate
        Y_xor(i) <= Y(i) xor AddSub;
    end generate;

    CLA1 : CLA_8_ext
    port MAP(X => X(7 downto 0),
            Y => Y_xor(7 downto 0),
            Cin => AddSub,
            S => s_out(7 downto 0),
            P => p8,
            G => g8,
            C => open);
    
    c8 <= g8 or (p8 and AddSub);

    CLA2 : CLA_8_ext
    port MAP(X => X(15 downto 8),
            Y => Y_xor(15 downto 8),
            Cin => c8,
            S => s_out(15 downto 8),
            P => p16,
            G => g16,
            C => open);
    
    c16 <= g16 or (p16 and g8) or (p16 and p8 and AddSub);

    CLA3 : CLA_8_ext
    port MAP(X => X(23 downto 16),
            Y => Y_xor(23 downto 16),
            Cin => c16,
            S => s_out(23 downto 16),
            P => p24,
            G => g24,
            C => open);
    
    c24 <= g24 or (p24 and g16) or (p24 and p16 and g8) or (p24 and p16 and p8 and AddSub);

    CLA4 : CLA_8_ext
    port MAP(X => X(31 downto 24),
            Y => Y_xor(31 downto 24),
            Cin => c24,
            S => s_out(31 downto 24),
            P => p32,
            G => g32,
            C => c31);
    
    c32 <= g32 or (p32 and g24) or (p32 and p24 and g16) or (p32 and p24 and p16 and g8) or (p32 and p24 and p16 and p8 and AddSub);
    S <= s_out;
    zero <= not(s_out(31) or s_out(30) or s_out(29) or s_out(28) or s_out(27) or s_out(26) or s_out(25) or s_out(24) or s_out(23) or s_out(22) or s_out(21) or s_out(20) or s_out(19) or s_out(18) or s_out(17) or s_out(16) or s_out(15) or s_out(14) or s_out(13) or s_out(12) or s_out(11) or s_out(10) or s_out(9) or s_out(8) or s_out(7) or s_out(6) or s_out(5) or s_out(4) or s_out(3) or s_out(2) or s_out(1) or s_out(0));
    negative <= s_out(31);
    overflow <= c31 xor c32;
    carry <= c32;

end structural;