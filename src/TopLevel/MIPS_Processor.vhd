-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0));

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic;
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0);
  signal s_DMemData     : std_logic_vector(N-1 downto 0);
  signal s_DMemOut      : std_logic_vector(N-1 downto 0);
 
  -- Required register file signals 
  signal s_RegWr        : std_logic;
  signal s_RegWrAddr    : std_logic_vector(4 downto 0);
  signal s_RegWrData    : std_logic_vector(N-1 downto 0);

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0);
  signal s_Inst         : std_logic_vector(N-1 downto 0);

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  component Control is
    port(opcode : in std_logic_vector(5 downto 0);
        funct : in std_logic_vector(5 downto 0);
        i_rd : in std_logic_vector(4 downto 0);
        o_rd : out std_logic_vector(4 downto 0);
        movz : out std_logic;
        movn : out std_logic;
        beq : out std_logic;
        bne : out std_logic;
        blez : out std_logic;
        bgtz : out std_logic;
        imm_ext : out std_logic;
        sel_y : out std_logic;
        rs_sel : out std_logic;
        ivu_sel : out std_logic;
        astype : out std_logic;
        shdir : out std_logic;
        alu_sel_2 : out std_logic;
        alu_sel_1 : out std_logic;
        alu_sel_0 : out std_logic;
        dmem_we : out std_logic;
        reg_we : out std_logic;
        reg_sel_1 : out std_logic;
        reg_sel_0 : out std_logic;
        rd_sel : out std_logic;
        pc_sel_1 : out std_logic;
        pc_sel_0 : out std_logic;
        det_o : out std_logic;
        halt : out std_logic);
  end component;

  component ALU is
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
  end component;

  component RegFile is
    port(data : in std_logic_vector(31 downto 0);
        i_rs : in std_logic_vector(4 downto 0);
        i_rt : in std_logic_vector(4 downto 0);
        i_rd : in std_logic_vector(4 downto 0);
        reset : in std_logic;
        clk : in std_logic;
        o_rs : out std_logic_vector(31 downto 0);
        o_rt : out std_logic_vector(31 downto 0));
  end component;

  component PC is
    port(linkr : in std_logic_vector(31 downto 0);
        JAddr : in std_logic_vector(25 downto 0);
        BAddr : in std_logic_vector(31 downto 0);
        pc_sel_1 : in std_logic;
        pc_sel_0 : in std_logic;
        clk : in std_logic;
        reset : in std_logic;
        halt : in std_logic;
        o_PC : out std_logic_vector(31 downto 0);
        o_PC4 : out std_logic_vector(31 downto 0);
        o_Branch : out std_logic_vector(31 downto 0));
  end component;

  component extend1632 is
    port(data : in std_logic_vector(15 downto 0);
        exttype : in std_logic;
        result : out std_logic_vector(31 downto 0));
  end component;

  component PipelineReg is
    port(Inst : in std_logic_vector(31 downto 0);
        PC4 : in std_logic_vector(31 downto 0);
        Control : in std_logic_vector(15 downto 0);
        rd : in std_logic_vector(4 downto 0);
        rsd : in std_logic_vector(31 downto 0);
        rtd : in std_logic_vector(31 downto 0);
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
        taken_id : in std_logic;
        taken_ex : in std_logic;
        o_Inst : out std_logic_vector(31 downto 0);
        o_Inst_ex : out std_logic_vector(31 downto 0);
        o_PC4_wb : out std_logic_vector(31 downto 0);
        o_ex : out std_logic_vector(7 downto 0);
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
        o_taken_id : out std_logic;
        o_Branch : out std_logic_vector(31 downto 0);
        o_brinst_ex : out std_logic_vector(3 downto 0);
        o_brinst_mem : out std_logic_vector(3 downto 0));
  end component;

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

  component HF
    port(id_inst : in std_logic_vector(31 downto 0);
        ex_rd : in std_logic_vector(4 downto 0);
        mem_rd : in std_logic_vector(4 downto 0);
        ex_wb : in std_logic_vector(2 downto 0);
        mem_wb : in std_logic_vector(2 downto 0);
        lw : in std_logic;
        branch : in std_logic_vector(3 downto 0);
        taken_ex : in std_logic;
        taken_id : in std_logic;
        clk : in std_logic;
        flush_if : out std_logic;
        flush_id : out std_logic;
        pc_re : out std_logic;
        o_sel_rsd : out std_logic_vector(1 downto 0);
        o_sel_rtd : out std_logic_vector(1 downto 0);
        pc_re_sel : out std_logic);
  end HF;

  signal o_rd : std_logic_vector(4 downto 0);
  signal movz : std_logic;
  signal movn : std_logic;
  signal beq : std_logic;
  signal bne : std_logic;
  signal blez : std_logic;
  signal bgtz : std_logic;
  signal imm_ext : std_logic;
  signal sel_y : std_logic;
  signal rs_sel : std_logic;
  signal ivu_sel : std_logic;
  signal astype : std_logic;
  signal shdir : std_logic;
  signal alu_sel_2 : std_logic;
  signal alu_sel_1 : std_logic;
  signal alu_sel_0 : std_logic;
  signal reg_we : std_logic;
  signal reg_sel_1 : std_logic;
  signal reg_sel_0 : std_logic;
  signal rd_sel : std_logic;
  signal pc_sel_1 : std_logic;
  signal pc_sel_0 : std_logic;
  signal det_o : std_logic;
  signal ext_res : std_logic_vector(31 downto 0);
  signal o_rs : std_logic_vector(31 downto 0);
  signal o_rt : std_logic_vector(31 downto 0);
  signal pc4o : std_logic_vector(31 downto 0);
  signal x : std_logic_vector(31 downto 0);
  signal y : std_logic_vector(31 downto 0);
  signal shamt : std_logic_vector(4 downto 0);
  signal z_id : std_logic;
  signal z_wb : std_logic;
  signal neg : std_logic;
  signal o : std_logic;
  signal pc_1 : std_logic;
  signal pc_0 : std_logic;
  signal pc_en : std_logic;
  signal dmem_we : std_logic;
  signal halt : std_logic;
  signal reg_sel : std_logic_vector(1 downto 0);
  signal inst : std_logic_vector(31 downto 0);
  signal rd : std_logic_vector(4 downto 0);
  signal ov_in : std_logic;
  signal ov_out : std_logic;
  signal o_ex : std_logic_vector(7 downto 0);
  signal o_alu : std_logic_vector(31 downto 0);
  signal o_shamt : std_logic_vector(4 downto 0);
  signal o_rsd_ex : std_logic_vector(31 downto 0);
  signal o_rsd_wb : std_logic_vector(31 downto 0);
  signal o_rtd_ex : std_logic_vector(31 downto 0);
  signal o_imm : std_logic_vector(31 downto 0);
  signal o_wb : std_logic_vector(6 downto 0);
  signal alu_wb : std_logic_vector(31 downto 0);
  signal pc4_wb : std_logic_vector(31 downto 0);
  signal dmem_wb : std_logic_vector(31 downto 0);
  signal control_in : std_logic_vector(15 downto 0);
  signal flush_if : std_logic;
  signal flush_id : std_logic;
  signal lw : std_logic;
  signal o_rd_mem : std_logic_vector(4 downto 0);
  signal CalcBr : std_logic_vector(31 downto 0);
  signal pc_re_sel : std_logic;
  signal mem_wb : std_logic_vector(2 downto 0);
  signal i_taken_id : std_logic;
  signal i_taken_ex : std_logic;
  signal o_taken_id : std_logic;
  signal o_taken_ex : std_logic;
  signal o_brinst_ex : std_logic_vector(3 downto 0);
  signal o_brinst_mem : std_logic_vector(3 downto 0);
  signal branch : std_logic_vector(3 downto 0);
  signal o_Inst_ex : std_logic_vector(31 downto 0);
  signal z_ex : std_logic;
  signal neg_ex : std_logic;
  signal wd_mem : std_logic_vector(31 downto 0);
  signal x_pre : std_logic_vector(31 downto 0);
  signal y_pre : std_logic_vector(31 downto 0);
  signal o_sel_rsd : std_logic_vector(1 downto 0);
  signal o_sel_rtd : std_logic_vector(1 downto 0);
  signal o_Branch : std_logic_vector(31 downto 0);
  signal pc_re : std_logic;
  signal linkr : std_logic_vector(31 downto 0);
  signal pc_1_in : std_logic;
  signal pc_0_in : std_logic;
begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 
  pipeReg : PipelineReg
  port MAP(Inst => s_Inst,
          PC4 => pc4o,
          Control => control_in, --sel_y, rs_sel, ivu_sel, astype, shdir, alu_sel_2,1,0 | dmem_we | movz, movn, reg_we, reg_sel_1,0, det_o, halt
          rd => rd,
          rsd => o_rs,
          rtd => o_rt,
          imm => ext_res,
          CalcBr => CalcBr,
          branch => branch,
          ALU => o_alu,
          Ov => ov_in,
          Dmem => s_DMemOut,
          clk => iCLK,
          reset => iRST,
          flush_if => flush_if,
          flush_id => flush_id,
          pc_re_sel => pc_re_sel,
          taken_id => i_taken_id,
          taken_ex => i_taken_ex,
          o_Inst => inst,
          o_Inst_ex => o_Inst_ex,
          o_PC4_wb => pc4_wb,
          o_ex => o_ex,
          o_shamt => o_shamt,
          o_rd => s_RegWrAddr,
          o_rd_mem => o_rd_mem,
          o_rsd_ex => o_rsd_ex,
          o_rsd_wb => o_rsd_wb,
          o_rtd_ex => o_rtd_ex,
          o_rtd_mem => s_DMemData,
          o_imm => o_imm,
          o_ALU_mem => s_DMemAddr,
          o_ALU_wb => alu_wb,
          o_Ov => ov_out,
          o_Dmem => dmem_wb,
          o_mem => s_DMemWr,
          o_wb => o_wb,
          o_halt => pc_en,
          wb_mem => mem_wb,
          o_lw_mem => lw,
          wd_mem => wd_mem,
          o_taken_ex => o_taken_ex,
          o_taken_id => o_taken_id,
          o_Branch => o_Branch,
          o_brinst_ex => o_brinst_ex,
          o_brinst_mem => o_brinst_mem);

  s_Halt <= o_wb(0);
  oALUOut <= alu_wb;
  
  Control0 : Control
  port MAP(opcode => inst(31 downto 26),
          funct => inst(5 downto 0),
          i_rd => inst(15 downto 11),
          o_rd => o_rd,
          movz => movz,
          movn => movn,
          beq => beq,
          bne => bne,
          blez => blez,
          bgtz => bgtz,
          imm_ext => imm_ext,
          sel_y => sel_y,
          rs_sel => rs_sel,
          ivu_sel => ivu_sel,
          astype => astype,
          shdir => shdir,
          alu_sel_2 => alu_sel_2,
          alu_sel_1 => alu_sel_1,
          alu_sel_0 => alu_sel_0,
          dmem_we => dmem_we,
          reg_we => reg_we,
          reg_sel_1 => reg_sel_1,
          reg_sel_0 => reg_sel_0,
          rd_sel => rd_sel,
          pc_sel_1 => pc_sel_1,
          pc_sel_0 => pc_sel_0,
          det_o => det_o,
          halt => halt);

  control_in <= sel_y & rs_sel & ivu_sel & astype & shdir & alu_sel_2 & alu_sel_1 & alu_sel_0 & dmem_we & movz & movn & reg_we & reg_sel_1 & reg_sel_0 & det_o & halt;

  Extender: extend1632
  port MAP(data => inst(15 downto 0),
          exttype => imm_ext,
          result => ext_res);

  rd <= o_rd when (rd_sel = '0') else
                  inst(20 downto 16) when (rd_sel = '1') else
                  "00000";
  
  z_wb <= not(alu_wb(31) or alu_wb(30) or alu_wb(29) or alu_wb(28) or alu_wb(27) or alu_wb(26) or alu_wb(25) or alu_wb(24) or alu_wb(23) or alu_wb(22) or alu_wb(21) or alu_wb(20) or alu_wb(19) or alu_wb(18) or alu_wb(17) or alu_wb(16) or alu_wb(15) or alu_wb(14) or alu_wb(13) or alu_wb(12) or alu_wb(11) or alu_wb(10) or alu_wb(9) or alu_wb(8) or alu_wb(7) or alu_wb(6) or alu_wb(5) or alu_wb(4) or alu_wb(3) or alu_wb(2) or alu_wb(1) or alu_wb(0));
  s_RegWr <= o_wb(4) or (o_wb(6) and z_wb) or (o_wb(5) and (not z_wb));

  reg_sel <= o_wb(3) & o_wb(2);

  with reg_sel select
    s_RegWrData <= alu_wb when "00",
                   dmem_wb when "01",
                   pc4_wb when "10",
                   o_rsd_wb when "11",
                   x"00000000" when others;

  reg : RegFile
  port MAP(data => s_RegWrData,
          i_rs => inst(25 downto 21),
          i_rt => inst(20 downto 16),
          i_rd => s_RegWrAddr,
          reset => iRST,
          clk => iCLK,
          o_rs => o_rs,
          o_rt => o_rt);

  with o_sel_rsd select
    x_pre <= o_rsd_ex when "00",
             wd_mem when "01",
             s_RegWrData when "10",
             x"00000000" when others;

  with o_ex(6) select
    x <= x_pre when '0',
         x"00000000" when others;

  with o_sel_rtd select
    y_pre <= o_rtd_ex when "00",
             wd_mem when "01",
             s_RegWrData when "10",
             x"00000000" when others;

  with o_ex(7) select
    y <= y_pre when '0',
         o_imm when '1',
         x"00000000" when others;

  with o_ex(5) select
    shamt <= o_shamt when '0',
             x_pre(4 downto 0) when '1',
             "00000" when others;

  ALU0 : ALU
  port MAP(X => x,
          Y => y,
          astype => o_ex(4),
          shamt => shamt,
          shdir => o_ex(3),
          ivu_sel => o_ex(5),
          alu_sel_0 => o_ex(0),
          alu_sel_1 => o_ex(1),
          alu_sel_2 => o_ex(2),
          result => o_alu,
          zero => z_ex,
          negative => neg_ex,
          overflow => ov_in);

  s_Ovfl <= ov_out and o_wb(1);
  i_taken_ex <= (o_brinst_ex(3) and z_ex) or (o_brinst_ex(2) and (not z_ex)) or (o_brinst_ex(1) and (z_ex or (neg_ex xor ov_in))) or (o_brinst_ex(0) and ((not z_ex) and (not (neg_ex xor ov_in))));

  Comp : CLA_32
  port MAP(X => o_rs,
          Y => o_rt,
          AddSub => '1',
          S => open,
          zero => z_id,
          negative => neg,
          overflow => o,
          carry => open);

  branch <= (beq & bne & blez & bgtz);
  i_taken_id <= (beq and z_id) or (bne and (not z_id)) or (blez and (z_id or (neg xor o))) or (bgtz and ((not z_id) and (not (neg xor o))));
  pc_1 <= pc_sel_1 or i_taken_id;
  pc_0 <= pc_sel_0 or i_taken_id;

  with pc_re select
    linkr <= o_rs when '0',
             o_Branch when '1',
             x"00000000" when others;

  with pc_re select
    pc_1_in <= pc_1 when '0',
               '0' when '1',
               '0' when others

  with pc_re select
  pc_0_in <= pc_0 when '0',
            '1' when '1',
            '0' when others

  progc : PC
  port MAP(linkr => linkr,
          JAddr => inst(25 downto 0),
          BAddr => ext_res,
          pc_sel_1 => pc_1_in,
          pc_sel_0 => pc_0_in,
          clk => iCLK,
          reset => iRST,
          halt => pc_en,
          o_PC => s_NextInstAddr,
          o_PC4 => pc4o,
          o_Branch => CalcBr);

  --TODO
  HF0 : HF
  port MAP(id_inst => o_Inst_ex,
          ex_rd => o_rd_mem,
          mem_rd => s_RegWrAddr,
          ex_wb => mem_wb,
          mem_wb => o_wb(6 downto 4),
          lw => lw,
          branch => o_brinst_mem,
          taken_ex => o_taken_ex,
          taken_id => o_taken_id,
          clk => iCLK,
          flush_if => flush_if,
          flush_id => flush_id,
          pc_re => pc_re,
          o_sel_rsd => o_sel_rsd,
          o_sel_rtd => o_sel_rtd,
          pc_re_sel => pc_re_sel);
                  
end structure;

