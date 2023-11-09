library IEEE;
use IEEE.std_logic_1164.all;

entity HF is
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

-- All outputs go back to zero when clk = 1, also anded by not clock in mips_processor

-- if not(ex.rd = 0 or mem.rd = 0)
--      if not(if id inst = j, jal, break, or halt)
--          if((ex or mem inst = movn or movz) or ex inst = lw)
--              if(ex.rd = id.rs or ex.rd = id.rt or mem.rd = id.rs or mem.rd = id.rt)
--                  flush_if = 1
--                  flush_id = 1
--                  pc_re = 1 (set pc input linkr to ex.pc4 and pc_sel to 01)
--         else
--              if(ex.rd = id.rs and ex.regwe)
--                  sel_rsd = 01
--              else if (mem.rd = id.rs and mem.regwe)
--                  sel_rsd = 10
--              if(ex.rd = id.rt and ex.regwe)
--                  sel_rtd = 01
--              else if (mem.rd = id.rt and mem.regwe)
--                  sel_rtd = 10
-- if ((sel_rsd != 00 or sel_rtd != 00) and id inst = jr, jalr)
--      flush_if = 1
--      flush_id = 1
--      pc_re = 1
-- if(id inst = j, jal)
--      flush if = 1
-- if(ex.inst = branch and ex.taken_ex != ex.taken_id)
--      flush_if = 1
--      flush_id = 1
--      pc_re = 1
--      if(ex.taken_id != 1)
--          pc_re_sel = 1 (if 1, use ex.CalcBr else ex.pc4)