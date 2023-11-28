library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
library std;
use std.env.all;
use std.textio.all;

entity stall_flush_tb is
	generic(gCLK_HPER   : time := 10 ns);
end stall_flush_tb;

architecture test of stall_flush_tb is
component PipelineReg
    port(Inst : in std_logic_vector(31 downto 0);
    PC4 : in std_logic_vector(31 downto 0);
    Control : in std_logic_vector(17 downto 0);
    rd : in std_logic_vector(4 downto 0);
    rsd : in std_logic_vector(31 downto 0);
    rtd : in std_logic_vector(31 downto 0);
    rsd_new : in std_logic_vector(31 downto 0);
    rtd_new : in std_logic_vector(31 downto 0);
    imm : in std_logic_vector(31 downto 0);
    CalcBr : in std_logic_vector(31 downto 0);
    branch : in std_logic_vector(3 downto 0);
    ALU : in std_logic_vector(31 downto 0);
    Ov : in std_logic;
    Dmem : in std_logic_vector(31 downto 0);
    clk : in std_logic;
    reset : in std_logic;
    flush_if : in std_logic;
    flush_id : in std_logic;
    pc_re_sel : in std_logic;
    taken_ex : in std_logic;
    jump : in std_logic_vector(1 downto 0);
    o_Inst : out std_logic_vector(31 downto 0);
    o_Inst_ex : out std_logic_vector(31 downto 0);
    o_PC4_wb : out std_logic_vector(31 downto 0);
    o_ex : out std_logic_vector(9 downto 0);
    o_shamt : out std_logic_vector(4 downto 0);
    o_rd : out std_logic_vector(4 downto 0);
    o_rd_mem : out std_logic_vector(4 downto 0);
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
    wb_mem : out std_logic_vector(2 downto 0);
    o_lw_mem : out std_logic;
    wd_mem : out std_logic_vector(31 downto 0);
    o_taken_ex : out std_logic;
    o_Branch : out std_logic_vector(31 downto 0);
    o_brinst_ex : out std_logic_vector(3 downto 0);
    o_brinst_mem : out std_logic_vector(3 downto 0);
    o_jump : out std_logic_vector(1 downto 0));
end component;

signal Inst : std_logic_vector(31 downto 0);
signal PC4 : std_logic_vector(31 downto 0);
signal Control : std_logic_vector(17 downto 0);
signal rd : std_logic_vector(4 downto 0);
signal rsd : std_logic_vector(31 downto 0);
signal rtd : std_logic_vector(31 downto 0);
signal rsd_new : std_logic_vector(31 downto 0);
signal rtd_new : std_logic_vector(31 downto 0);
signal imm : std_logic_vector(31 downto 0);
signal CalcBr : std_logic_vector(31 downto 0);
signal branch : std_logic_vector(3 downto 0);
signal ALU : std_logic_vector(31 downto 0);
signal Ov : std_logic;
signal Dmem : std_logic_vector(31 downto 0);
signal s_clk : std_logic;
signal reset : std_logic;
signal flush_if : std_logic;
signal flush_id : std_logic;
signal pc_re_sel : std_logic;
signal taken_ex : std_logic;
signal jump : std_logic_vector(1 downto 0);
signal o_Inst : std_logic_vector(31 downto 0);
signal o_Inst_ex : std_logic_vector(31 downto 0);
signal o_PC4_wb : std_logic_vector(31 downto 0);
signal o_ex : std_logic_vector(9 downto 0);
signal o_shamt : std_logic_vector(4 downto 0);
signal o_rd : std_logic_vector(4 downto 0);
signal o_rd_mem : std_logic_vector(4 downto 0);
signal o_rsd_ex : std_logic_vector(31 downto 0);
signal o_rsd_wb : std_logic_vector(31 downto 0);
signal o_rtd_ex : std_logic_vector(31 downto 0);
signal o_rtd_mem : std_logic_vector(31 downto 0);
signal o_imm : std_logic_vector(31 downto 0);
signal o_ALU_mem : std_logic_vector(31 downto 0);
signal o_ALU_wb : std_logic_vector(31 downto 0);
signal o_Ov : std_logic;
signal o_Dmem : std_logic_vector(31 downto 0);
signal o_mem : std_logic;
signal o_wb : std_logic_vector(6 downto 0);
signal o_halt : std_logic;
signal wb_mem : std_logic_vector(2 downto 0);
signal o_lw_mem : std_logic;
signal wd_mem : std_logic_vector(31 downto 0);
signal o_taken_ex : std_logic;
signal o_Branch : std_logic_vector(31 downto 0);
signal o_brinst_ex : std_logic_vector(3 downto 0);
signal o_brinst_mem : std_logic_vector(3 downto 0);
signal o_jump : std_logic_vector(1 downto 0);

begin

	test_reg: PipelineReg
	port MAP(Inst => Inst,
            PC4 => PC4,
            Control => Control,
            rd => rd,
            rsd => rsd,
            rtd => rtd,
            rsd_new => rsd_new,
            rtd_new => rtd_new,
            imm => imm,
            CalcBr => CalcBr,
            branch => branch,
            ALU => ALU,
            Ov => Ov,
            Dmem => Dmem,
            clk => s_clk,
            reset => reset,
            flush_if => flush_if,
            flush_id => flush_id,
            pc_re_sel => pc_re_sel,
            taken_ex => taken_ex,
            jump => jump,
            o_Inst => o_Inst,
            o_Inst_ex => o_Inst_ex,
            o_PC4_wb => o_PC4_wb,
            o_ex => o_ex,
            o_shamt => o_shamt,
            o_rd => o_rd,
            o_rd_mem => o_rd_mem,
            o_rsd_ex => o_rsd_ex,
            o_rsd_wb => o_rsd_wb,
            o_rtd_ex => o_rtd_ex,
            o_rtd_mem => o_rtd_mem,
            o_imm => o_imm,
            o_ALU_mem => o_ALU_mem,
            o_ALU_wb => o_ALU_wb,
            o_Ov => o_Ov,
            o_Dmem => o_Dmem,
            o_mem => o_mem,
            o_wb => o_wb,
            o_halt => o_halt,
            wb_mem => wb_mem,
            o_lw_mem => o_lw_mem,
            wd_mem => wd_mem,
            o_taken_ex => o_taken_ex,
            o_Branch => o_Branch,
            o_brinst_ex => o_brinst_ex,
            o_brinst_mem => o_brinst_mem,
            o_jump => o_jump);

    P_CLK: process
    begin
        s_clk <= '0';
        wait for gCLK_HPER;
        s_clk <= '1';
        wait for gCLK_HPER;
    end process;

	Test_cases: process
	begin
		wait for gCLK_HPER/2;
        --clear Regs
		reset <= '1';
        wait for gCLK_HPER;
        reset <= '0';

		--Set Values
        Inst <= x"20020001";
        PC4 <= x"00400004";
        Control <= "00" & x"1234";
        rd <= "00010";
        rsd <= x"10000000";
        rtd <= x"00000001";
        rsd_new <= x"00000001";
        rtd_new <= x"10000000";
        imm <= x"00000001";
        CalcBr <= x"00400008";
        branch <= x"0";
        ALU <= x"10000001";
        Ov <= '0';
        Dmem <= x"00000023";
        flush_if <= '0';
        flush_id <= '0';
        pc_re_sel <= '0';
        taken_ex <= '0';
        jump <= "00";
        wait for gCLK_HPER/2;
		wait for gCLK_HPER*10;
		
		--flush_id
        flush_id <= '1';
        wait for gCLK_HPER*2;

        --flush_if
        flush_if <= '1';
        flush_id <= '0';
        wait for gCLK_HPER*2;
        flush_if <= '0';
        wait;

	end process;

end test;