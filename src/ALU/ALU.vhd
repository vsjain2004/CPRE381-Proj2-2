library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is
    port(X : in std_logic_vector(31 downto 0);
        Y : in std_logic_vector(31 downto 0);
        astype : in std_logic;
        shamt : in std_logic_vector(4 downto 0);
        shdir : in std_logic;
        ivu_sel : in std_logic;
        alu_sel_0 : in std_logic;
        alu_sel_1 : in std_logic;
        alu_sel_2 : in std_logic;
        result : out std_logic_vector(31 downto 0);
        zero : out std_logic;
        negative : out std_logic;
        overflow : out std_logic);
end ALU;

architecture structural of ALU is

    component CLA_32
        port(X : in std_logic_vector(31 downto 0);
            Y : in std_logic_vector(31 downto 0);
            AddSub : in std_logic;
            S : out std_logic_vector(31 downto 0);
            zero : out std_logic;
            negative : out std_logic;
            overflow : out std_logic;
            carry : out std_logic);
    end component;

    component Shifter
        port(data : in std_logic_vector(31 downto 0);
            shamt : in std_logic_vector(4 downto 0);
            shdir : in std_logic;
            shtype : in std_logic;
            output : out std_logic_vector(31 downto 0));
    end component;

    component LUI
        port(input : in std_logic_vector(31 downto 0);
            output : out std_logic_vector(31 downto 0));
    end component;

    component Nor_32
        port(X : in std_logic_vector(31 downto 0);
            Y : in std_logic_vector(31 downto 0);
            output : out std_logic_vector(31 downto 0));
    end component;

    component Or_32
        port(X : in std_logic_vector(31 downto 0);
            Y : in std_logic_vector(31 downto 0);
            output : out std_logic_vector(31 downto 0));
    end component;

    component Xor_32
        port(X : in std_logic_vector(31 downto 0);
            Y : in std_logic_vector(31 downto 0);
            output : out std_logic_vector(31 downto 0));
    end component;

    component And_32
        port(X : in std_logic_vector(31 downto 0);
            Y : in std_logic_vector(31 downto 0);
            output : out std_logic_vector(31 downto 0));
    end component;

    component Neg_ext
        port(neg : in std_logic;
            negext : out std_logic_vector(31 downto 0));
    end component;

    signal add_out : std_logic_vector(31 downto 0);
    signal n : std_logic;
    signal o : std_logic;
    signal c : std_logic;
    signal sh_out : std_logic_vector(31 downto 0);
    signal lui_out : std_logic_vector(31 downto 0);
    signal nor_out : std_logic_vector(31 downto 0);
    signal or_out : std_logic_vector(31 downto 0);
    signal xor_out : std_logic_vector(31 downto 0);
    signal and_out : std_logic_vector(31 downto 0);
    signal neg_out : std_logic_vector(31 downto 0);
    signal less : std_logic;
    signal alu_sel : std_logic_vector(2 downto 0);
begin
    cla : CLA_32
    port MAP(X => X,
            Y => Y,
            AddSub => astype,
            S => add_out,
            zero => zero,
            negative => n,
            overflow => o,
            carry => c);
    
    negative <= n;
    overflow <= o;
    with ivu_sel select
        less <= (not c) when '1',
                (n xor o) when '0',
                '0' when others;

    shift : Shifter
    port MAP(data => Y,
            shamt => shamt,
            shdir => shdir,
            shtype => astype,
            output => sh_out);
    
    lui32 : LUI
    port MAP(input => Y,
            output => lui_out);
    
    nor3_2 : Nor_32
    port MAP(X => X,
            Y => Y,
            output => nor_out);

    or3_2 : Or_32
    port MAP(X => X,
            Y => Y,
            output => or_out);
    
    xor3_2 : Xor_32
    port MAP(X => X,
            Y => Y,
            output => xor_out);
    
    and3_2 : And_32
    port MAP(X => X,
            Y => Y,
            output => and_out);
    
    negex : Neg_ext
    port MAP(neg => less,
            negext => neg_out);

    alu_sel <= alu_sel_2 & alu_sel_1 & alu_sel_0;

    with alu_sel select
        result <= add_out when "000",
                  sh_out when "001",
                  lui_out when "010",
                  nor_out when "011",
                  or_out when "100",
                  xor_out when "101",
                  and_out when "110",
                  neg_out when "111",
                  x"00000000" when others;
end structural;