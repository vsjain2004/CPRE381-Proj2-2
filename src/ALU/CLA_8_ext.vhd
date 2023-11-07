library IEEE;
use IEEE.std_logic_1164.all;

entity CLA_8_ext is
    port(X : in std_logic_vector(7 downto 0);
        Y : in std_logic_vector(7 downto 0);
        Cin : in std_logic;
        S : out std_logic_vector(7 downto 0);
        P : out std_logic;
        G : out std_logic;
        C : out std_logic);
end CLA_8_ext;

architecture dataflow of CLA_8_ext is
    signal g0 : std_logic;
    signal p0 : std_logic;
    signal g1 : std_logic;
    signal p1 : std_logic;
    signal g2 : std_logic;
    signal p2 : std_logic;
    signal g3 : std_logic;
    signal p3 : std_logic;
    signal g4 : std_logic;
    signal p4 : std_logic;
    signal g5 : std_logic;
    signal p5 : std_logic;
    signal g6 : std_logic;
    signal p6 : std_logic;
    signal g7 : std_logic;
    signal p7 : std_logic;
    signal Carry : std_logic_vector(7 downto 0);
begin
    Carry(0) <= Cin;

    g0 <= X(0) and Y(0);
    p0 <= X(0) or Y(0);
    S(0) <= X(0) xor Y(0) xor Carry(0);
    Carry(1) <= g0 or (p0 and Cin);

    g1 <= X(1) and Y(1);
    p1 <= X(1) or Y(1);
    S(1) <= X(1) xor Y(1) xor Carry(1);
    Carry(2) <= g1 or (p1 and g0) or (p1 and p0 and Cin);
    
    g2 <= X(2) and Y(2);
    p2 <= X(2) or Y(2);
    S(2) <= X(2) xor Y(2) xor Carry(2);
    Carry(3) <= g2 or (p2 and g1) or (p2 and p1 and g0) or (p2 and p1 and p0 and Cin);
    
    g3 <= X(3) and Y(3);
    p3 <= X(3) or Y(3);
    S(3) <= X(3) xor Y(3) xor Carry(3);
    Carry(4) <= g3 or (p3 and g2) or (p3 and p2 and g1) or (p3 and p2 and p1 and g0) or (p3 and p2 and p1 and p0 and Cin);
    
    g4 <= X(4) and Y(4);
    p4 <= X(4) or Y(4);
    S(4) <= X(4) xor Y(4) xor Carry(4);
    Carry(5) <= g4 or (p4 and g3) or (p4 and p3 and g2) or (p4 and p3 and p2 and g1) or (p4 and p3 and p2 and p1 and g0) or (p4 and p3 and p2 and p1 and p0 and Cin);
    
    g5 <= X(5) and Y(5);
    p5 <= X(5) or Y(5);
    S(5) <= X(5) xor Y(5) xor Carry(5);
    Carry(6) <= g5 or (p5 and g4) or (p5 and p4 and g3) or (p5 and p4 and p3 and g2) or (p5 and p4 and p3 and p2 and g1) or (p5 and p4 and p3 and p2 and p1 and g0) or (p5 and p4 and p3 and p2 and p1 and p0 and Cin);
    
    g6 <= X(6) and Y(6);
    p6 <= X(6) or Y(6);
    S(6) <= X(6) xor Y(6) xor Carry(6);
    Carry(7) <= g6 or (p6 and g5) or (p6 and p5 and g4) or (p6 and p5 and p4 and g3) or (p6 and p5 and p4 and p3 and g2) or (p6 and p5 and p4 and p3 and p2 and g1) or (p6 and p5 and p4 and p3 and p2 and p1 and g0) or (p6 and p5 and p4 and p3 and p2 and p1 and p0 and Cin);
    
    g7 <= X(7) and Y(7);
    p7 <= X(7) or Y(7);
    S(7) <= X(7) xor Y(7) xor Carry(7);

    P <= p7 and p6 and p5 and p4 and p3 and p2 and p1 and p0;
    G <= g7 or (p7 and g6) or (p7 and p6 and g5) or (p7 and p6 and p5 and g4) or (p7 and p6 and p5 and p4 and g3) or (p7 and p6 and p5 and p4 and p3 and g2) or (p7 and p6 and p5 and p4 and p3 and p2 and g1) or (p7 and p6 and p5 and p4 and p3 and p2 and p1 and g0);
    C <= Carry(7);
end dataflow;