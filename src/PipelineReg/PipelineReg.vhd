library IEEE;
use IEEE.std_logic_1164.all;

entity PipelineReg is
    port(Inst : in std_logic_vector(31 downto 0);
        PC4 : in std_logic_vector(31 downto 0);
        Control : in std_logic_vector(15 downto 0);
        rd : in std_logic_vector(4 downto 0);
        rsd : in std_logic_vector(31 downto 0);
        rtd : in std_logic_vector(31 downto 0);
        imm : in std_logic_vector(31 downto 0);
        ALU : in std_logic_vector(31 downto 0);
        Ov : in std_logic;
        Dmem : in std_logic_vector(31 downto 0);
        clk : in std_logic;
        reset : in std_logic;
        flush_if : in std_logic;
        flush_id : in std_logic;
        o_Inst : out std_logic_vector(31 downto 0);
        o_Inst_ex : out std_logic_vector(31 downto 0);
        o_PC4_wb : out std_logic_vector(31 downto 0);
        o_ex : out std_logic_vector(7 downto 0);
        o_shamt : out std_logic_vector(4 downto 0);
        o_rd : out std_logic_vector(4 downto 0);
        o_rd_mem : out std_logic_vector(4 downto 0);
        o_rs : out std_logic_vector(4 downto 0);
        o_rt : out std_logic_vector(4 downto 0);
        o_rsd_ex : out std_logic_vector(31 downto 0);
        o_rsd_wb : out std_logic_vector(31 downto 0);
        o_rtd_ex : out std_logic_vector(31 downto 0);
        o_rtd_mem : out std_logic_vector(31 downto 0);
        o_imm : out std_logic_vector(31 downto 0);
        o_ALU_mem : out std_logic_vector(31 downto 0);
        o_ALU_wb : out std_logic_vector(31 downto 0);
        o_Ov : out std_logic;
        o_Dmem : out std_logic_vector(31 downto 0);
        o_mem : out std_logic;
        o_wb : out std_logic_vector(6 downto 0);
        o_halt : out std_logic;
        wb_mem : out std_logic_vector(2 downto 0));
end PipelineReg;

architecture structural of PipelineReg is
    
    component RegNBit is
        generic(N : integer := 32);
        port(clk : in std_logic;
            reset : in std_logic;
            we : in std_logic;
            data : in std_logic_vector(N-1 downto 0);
            o_data : out std_logic_vector(N-1 downto 0));
    end component;

    component dffg is
        port(i_CLK        : in std_logic;
             i_RST        : in std_logic;
             i_WE         : in std_logic;
             i_D          : in std_logic;
             o_Q          : out std_logic);
    end component;

    signal instruction : std_logic_vector(31 downto 0);
    signal memforward : std_logic;
    signal wbforward1 : std_logic_vector(6 downto 0);
    signal wbforward2 : std_logic_vector(6 downto 0);
    signal wb3 : std_logic_vector(6 downto 0);
    signal rdforward1 : std_logic_vector(4 downto 0);
    signal rdforward2 : std_logic_vector(4 downto 0);
    signal rsdforward1 : std_logic_vector(31 downto 0);
    signal rsdforward2 : std_logic_vector(31 downto 0);
    signal rtdforward1 : std_logic_vector(31 downto 0);
    signal pc4forward1 : std_logic_vector(31 downto 0);
    signal pc4forward2 : std_logic_vector(31 downto 0);
    signal pc4forward3 : std_logic_vector(31 downto 0);
    signal aluforward : std_logic_vector(31 downto 0);
    signal ovforward : std_logic;
    signal if_reset : std_logic;
    signal id_reset : std_logic;
begin
    
    --IF/ID
    
    if_reset <= reset or flush_if;

    IFID : RegNBit
    port MAP(clk => clk,
            reset => if_reset,
            we => '1',
            data => Inst,
            o_data => instruction);
    
    o_Inst <= instruction;

    --PC + 4
    PC4reg : RegNBit
    port MAP(clk => clk,
            reset => if_reset,
            we => '1',
            data => PC4,
            o_data => pc4forward1);

    --ID/EX

    id_reset <= reset or flush_id;

    --Instruction
    IFID : RegNBit
    port MAP(clk => clk,
            reset => id_reset,
            we => '1',
            data => instruction,
            o_data => o_Inst_ex);

    --EX controls
    EXControl : RegNBit --sel_y, rs_sel, ivu_sel, astype, shdir, alu_sel_2,1,0
    generic MAP(N => 8)
    port MAP(clk => clk,
            reset => id_reset,
            we => '1',
            data => Control(15 downto 8),
            o_data => o_ex);

    --MEM controls
    MEMControl : dffg --dmem_we
    port MAP(i_CLK => clk,
            i_RST => id_reset,
            i_WE => '1',
            i_D => Control(7),
            o_Q => memforward);

    --WB controls
    WBControl : RegNBit --movz, movn, reg_we, reg_sel_1,0, det_o, halt
    generic MAP(N => 7)
    port MAP(clk => clk,
            reset => id_reset,
            we => '1',
            data => Control(6 downto 0),
            o_data => wbforward1);
    
    --rd
    DestReg : RegNBit
    generic MAP(N => 5)
    port MAP(clk => clk,
            reset => id_reset,
            we => '1',
            data => rd,
            o_data => rdforward1);

    --rs
    DestReg : RegNBit
    generic MAP(N => 5)
    port MAP(clk => clk,
            reset => id_reset,
            we => '1',
            data => instruction(25 downto 21),
            o_data => o_rs);

    --rt
    DestReg : RegNBit
    generic MAP(N => 5)
    port MAP(clk => clk,
            reset => id_reset,
            we => '1',
            data => instruction(20 downto 16),
            o_data => o_rt);
    
    --rs data
    rsData : RegNBit
    port MAP(clk => clk,
            reset => id_reset,
            we => '1',
            data => rsd,
            o_data => rsdforward1);
    
    o_rsd_ex <= rsdforward1;
    
    --rt data
    rtData : RegNBit
    port MAP(clk => clk,
            reset => id_reset,
            we => '1',
            data => rtd,
            o_data => rtdforward1);
    
    o_rtd_ex <= rtdforward1;

    --shamt
    ShiftAmt : RegNBit
    generic MAP(N => 5)
    port MAP(clk => clk,
            reset => id_reset,
            we => '1',
            data => instruction(10 downto 6),
            o_data => o_shamt);

    --imm
    ImmData : RegNBit
    port MAP(clk => clk,
            reset => id_reset,
            we => '1',
            data => imm,
            o_data => o_imm);
    
    --PC + 4
    PC4reg2 : RegNBit
    port MAP(clk => clk,
            reset => id_reset,
            we => '1',
            data => pc4forward1,
            o_data => pc4forward2);

    --EX/MEM
    --MEM Controls
    MEMControl2 : dffg
    port MAP(i_CLK => clk,
            i_RST => reset,
            i_WE => '1',
            i_D => memforward,
            o_Q => o_mem);

    --WB Controls
    WBControl2 : RegNBit
    generic MAP(N => 7)
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => wbforward1,
            o_data => wbforward2);

    wb_mem <= wbforward2(6 downto 4);

    --rd
    DestReg2 : RegNBit
    generic MAP(N => 5)
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => rdforward1,
            o_data => rdforward2);

    o_rd_mem <= rdforward2;
    
    --rs data
    rsData2 : RegNBit
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => rsdforward1,
            o_data => rsdforward2);
        
    --rt data
    rtData2 : RegNBit
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => rtdforward1,
            o_data => o_rtd_mem);

    --ALU data
    ALUdata : RegNBit
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => ALU,
            o_data => aluforward);

    o_ALU_mem <= aluforward;

    --Overflow
    Ovfl : dffg
    port MAP(i_CLK => clk,
            i_RST => reset,
            i_WE => '1',
            i_D => Ov,
            o_Q => ovforward);

    --PC + 4
    PC4reg3 : RegNBit
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => pc4forward2,
            o_data => pc4forward3);

    --MEM/WB
    --WB Controls
    WBControl3 : RegNBit
    generic MAP(N => 7)
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => wbforward2,
            o_data => wb3);

    o_wb <= wb3;

    --rd
    DestReg3 : RegNBit
    generic MAP(N => 5)
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => rdforward2,
            o_data => o_rd);
    
    --rs data
    rsData3 : RegNBit
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => rsdforward2,
            o_data => o_rsd_wb);

    --ALU data
    ALUdata2 : RegNBit
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => aluforward,
            o_data => o_ALU_wb);

    --Overflow
    Ovfl2 : dffg --dmem_we
    port MAP(i_CLK => clk,
            i_RST => reset,
            i_WE => '1',
            i_D => ovforward,
            o_Q => o_Ov);

    --DMEM data
    DMEMdata : RegNBit
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => Dmem,
            o_data => o_Dmem);

    --PC + 4
    PC4reg4 : RegNBit
    port MAP(clk => clk,
            reset => reset,
            we => '1',
            data => pc4forward3,
            o_data => o_PC4_wb);

    o_halt <= Control(0) or wbforward1(0) or wbforward2(0) or wb3(0);

end structural;