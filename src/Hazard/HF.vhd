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

architecture mixed of HF is

    signal ex_rd_z : std_logic;
    signal mem_rd_z : std_logic;
    signal id_j : std_logic;
    signal id_jal : std_logic;
    signal id_break : std_logic;
    signal id_halt : std_logic;
    signal ex_rd_rs : std_logic;
    signal ex_rd_rt : std_logic;
    signal mem_rd_rs : std_logic;
    signal mem_rd_rt : std_logic;
    signal id_jr : std_logic;
    signal id_jalr : std_logic;
    signal if_1 : std_logic;
    signal if_2 : std_logic;
    signal if_3 : std_logic;
    signal if_4 : std_logic;
    signal if_5 : std_logic;
    signal branching : std_logic;
    signal flush_if_pre : std_logic;
    signal flush_id_pre : std_logic;
    signal pc_re_pre : std_logic;
    signal sel_rsd_pre : std_logic_vector(1 downto 0);
    signal sel_rtd_pre : std_logic(1 downto 0);
    signal pc_re_sel_pre : std_logic;

begin

    ex_rd_z <= ex_rd(0) nor ex_rd(1) nor ex_rd(2) nor ex_rd(3) nor ex_rd(4);
    mem_rd_z <= mem_rd(0) nor mem_rd(1) nor mem_rd(2) nor mem_rd(3) nor mem_rd(4);
    id_j <= (not id_inst(31)) and (not id_inst(30)) and (not id_inst(29)) and (not id_inst(28)) and id_inst(27) and (not id_inst(26));
    id_jal <= (not id_inst(31)) and (not id_inst(30)) and (not id_inst(29)) and (not id_inst(28)) and id_inst(27) and id_inst(26);
    id_break <= (not id_inst(31)) and (not id_inst(30)) and (not id_inst(29)) and (not id_inst(28)) and id_inst(27) and (not id_inst(26)) and (not id_inst(5)) and (not id_inst(4)) and id_inst(3) and id_inst(2) and (not id_inst(1)) and id_inst(0);
    id_halt <= (not id_inst(31)) and id_inst(30) and (not id_inst(29)) and id_inst(28) and (not id_inst(27)) and (not id_inst(26));
    ex_rd_rs <= ex_wb(0) and (ex_rd(0) xnor id_inst(21)) and (ex_rd(1) xnor id_inst(22)) and (ex_rd(2) xnor id_inst(23)) and (ex_rd(3) xnor id_inst(24)) and (ex_rd(4) xnor id_inst(25));
    ex_rd_rt <= ex_wb(0) and (ex_rd(0) xnor id_inst(16)) and (ex_rd(1) xnor id_inst(17)) and (ex_rd(2) xnor id_inst(18)) and (ex_rd(3) xnor id_inst(19)) and (ex_rd(4) xnor id_inst(20));
    mem_rd_rs <= mem_wb(0) and (mem_rd(0) xnor id_inst(21)) and (mem_rd(1) xnor id_inst(22)) and (mem_rd(2) xnor id_inst(23)) and (mem_rd(3) xnor id_inst(24)) and (mem_rd(4) xnor id_inst(25));
    mem_rd_rt <= mem_wb(0) and (mem_rd(0) xnor id_inst(16)) and (mem_rd(1) xnor id_inst(17)) and (mem_rd(2) xnor id_inst(18)) and (mem_rd(3) xnor id_inst(19)) and (mem_rd(4) xnor id_inst(20));
    id_jr <= (not id_inst(31)) and (not id_inst(30)) and (not id_inst(29)) and (not id_inst(28)) and id_inst(27) and (not id_inst(26)) and (not id_inst(5)) and (not id_inst(4)) and id_inst(3) and (not id_inst(2)) and (not id_inst(1)) and (not id_inst(0));
    id_jalr <= (not id_inst(31)) and (not id_inst(30)) and (not id_inst(29)) and (not id_inst(28)) and id_inst(27) and (not id_inst(26)) and (not id_inst(5)) and (not id_inst(4)) and id_inst(3) and (not id_inst(2)) and (not id_inst(1)) and id_inst(0);
    if_1 <= ex_rd_z nor mem_rd_z;
    if_2 <= id_j nor id_jal nor id_break nor id_halt;
    if_3 <= ex_wb(2) or ex_wb(1) or mem_wb(2) or mem_wb(1) or lw;
    if_4 <= ex_rd_rs or ex_rd_rt or mem_rd_rs or mem_rd_rt;
    branching <= branch(0) or branch(1) or branch(2) or branch(3);
    
    output_reset: process(flush_if_pre, flush_id_pre, pc_re_pre, sel_rsd_pre, sel_rtd_pre, pc_re_sel_pre, clk)
    begin
        if rising_edge(clk) then
            flush_if <= '0';
            flush_id <= '0';
            pc_re <= '0';
            sel_rsd <= "00";
            sel_rtd <= "00";
            pc_re_sel <= '0';
        else
            flush_if <= flush_if_pre;
            flush_id <= flush_id_pre;
            pc_re <= pc_re_pre;
            sel_rsd <= sel_rsd_pre;
            sel_rtd <= sel_rtd_pre;
            pc_re_sel <= pc_re_sel_pre;
        end if;
    end process output_reset;

    sel_rsd_pre <= "01" when (if_1 and if_2 and (not if_3) and ex_rd_rs) else
                   "10" when (if_1 and if_2 and (not if_3) and mem_rd_rs) else
                   "00" when others;

    sel_rtd_pre <= "01" when (if_1 and if_2 and (not if_3) and ex_rd_rt) else
                   "10" when (if_1 and if_2 and (not if_3) and mem_rd_rt) else
                   "00" when others;

    if_5 <= (sel_rsd_pre(0) or sel_rsd_pre(1) or sel_rtd_pre(0) or sel_rtd_pre(1)) and (id_jr or id_jalr);

    flush_if_pre <= '1' when ((if_1 and if_2 and if_3 and if_4) or if_5 or id_j or id_jal or (branching and (taken_ex xor taken_id))) else
                    '0' when others;

    flush_id_pre <= '1' when ((if_1 and if_2 and if_3 and if_4) or if_5 or id_j or id_jal or (branching and (taken_ex xor taken_id))) else
                    '0' when others;

    pc_re_pre <= '1' when ((if_1 and if_2 and if_3 and if_4) or if_5 or id_j or id_jal or (branching and (taken_ex xor taken_id))) else
                 '0' when others;

    pc_re_sel_pre <= '1' when (branching and (taken_ex xor taken_id) and (not taken_id)) else
                     '0' when others;

end mixed;

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