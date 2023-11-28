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
        jump : in std_logic_vector(1 downto 0);
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
    signal id_break : std_logic;
    signal id_halt : std_logic;
    signal ex_rd_rs : std_logic;
    signal ex_rd_rt : std_logic;
    signal mem_rd_rs : std_logic;
    signal mem_rd_rt : std_logic;
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
    signal sel_rtd_pre : std_logic_vector(1 downto 0);
    signal pc_re_sel_pre : std_logic;

begin

    ex_rd_z <= not (ex_rd(0) or ex_rd(1) or ex_rd(2) or ex_rd(3) or ex_rd(4));
    mem_rd_z <= not (mem_rd(0) or mem_rd(1) or mem_rd(2) or mem_rd(3) or mem_rd(4));
    id_break <= (not id_inst(31)) and (not id_inst(30)) and (not id_inst(29)) and (not id_inst(28)) and id_inst(27) and (not id_inst(26)) and (not id_inst(5)) and (not id_inst(4)) and id_inst(3) and id_inst(2) and (not id_inst(1)) and id_inst(0);
    id_halt <= (not id_inst(31)) and id_inst(30) and (not id_inst(29)) and id_inst(28) and (not id_inst(27)) and (not id_inst(26));
    ex_rd_rs <= ex_wb(0) and (ex_rd(0) xnor id_inst(21)) and (ex_rd(1) xnor id_inst(22)) and (ex_rd(2) xnor id_inst(23)) and (ex_rd(3) xnor id_inst(24)) and (ex_rd(4) xnor id_inst(25));
    ex_rd_rt <= ex_wb(0) and (ex_rd(0) xnor id_inst(16)) and (ex_rd(1) xnor id_inst(17)) and (ex_rd(2) xnor id_inst(18)) and (ex_rd(3) xnor id_inst(19)) and (ex_rd(4) xnor id_inst(20));
    mem_rd_rs <= mem_wb(0) and (mem_rd(0) xnor id_inst(21)) and (mem_rd(1) xnor id_inst(22)) and (mem_rd(2) xnor id_inst(23)) and (mem_rd(3) xnor id_inst(24)) and (mem_rd(4) xnor id_inst(25));
    mem_rd_rt <= mem_wb(0) and (mem_rd(0) xnor id_inst(16)) and (mem_rd(1) xnor id_inst(17)) and (mem_rd(2) xnor id_inst(18)) and (mem_rd(3) xnor id_inst(19)) and (mem_rd(4) xnor id_inst(20));
    if_1 <= not(ex_rd_z and mem_rd_z);
    if_2 <= not (id_break or id_halt);
    if_3 <= (ex_wb(2) or ex_wb(1) or mem_wb(2) or mem_wb(1) or (lw and (ex_rd_rs or ex_rd_rt))) and (not jump(0));
    if_4 <= ex_rd_rs or ex_rd_rt or mem_rd_rs or mem_rd_rt;
    branching <= branch(0) or branch(1) or branch(2) or branch(3);

    sel_rsd_pre <= "01" when (if_1 and if_2 and (not if_3) and ex_rd_rs) else
               "10" when (if_1 and if_2 and (not if_3) and mem_rd_rs) else
               "00";

    sel_rtd_pre <= "01" when (if_1 and if_2 and (not if_3) and ex_rd_rt) else
               "10" when (if_1 and if_2 and (not if_3) and mem_rd_rt) else
               "00";

    flush_if_pre <= (if_1 and if_2 and if_3 and if_3 and if_4) or jump(0) or (branching and taken_ex);
    flush_id_pre <= (if_1 and if_2 and if_3 and if_3 and if_4) or jump(0) or (branching and taken_ex);
    pc_re_pre <= (if_1 and if_2 and if_3 and if_3 and if_4) or jump(1);
    pc_re_sel_pre <= (if_1 and if_2 and if_3 and if_3 and if_4 and ((mem_wb(2) or mem_wb(1)) and branching and taken_ex)) or jump(1);

    output_reset: process(clk, flush_if_pre) --flush_if_pre, flush_id_pre, pc_re_pre, sel_rsd_pre, sel_rtd_pre, pc_re_sel_pre
    begin
        if (clk) then
            flush_if <= '0';
        else 
            if(flush_if_pre'stable(10 ps)) then
                flush_if <= flush_if_pre;
            end if;
        end if;
    end process output_reset;

    output_reset1: process(clk, flush_id_pre) --flush_if_pre, flush_id_pre, pc_re_pre, sel_rsd_pre, sel_rtd_pre, pc_re_sel_pre
    begin
        if (clk) then
            flush_id <= '0';
        else
            if(flush_id_pre'stable(10 ps)) then
                flush_id <= flush_id_pre;
            end if;
        end if;
    end process output_reset1;

    output_reset2: process(clk, pc_re_pre) --flush_if_pre, flush_id_pre, pc_re_pre, sel_rsd_pre, sel_rtd_pre, pc_re_sel_pre
    begin
        if (clk) then
            pc_re <= '0';
        else 
            if(pc_re_pre'stable(10 ps)) then
                pc_re <= pc_re_pre;
            end if;
        end if;
    end process output_reset2;

    output_reset3: process(clk, sel_rsd_pre) --flush_if_pre, flush_id_pre, pc_re_pre, sel_rsd_pre, sel_rtd_pre, pc_re_sel_pre
    begin
        if (clk) then
            o_sel_rsd <= "00";
        else 
            o_sel_rsd <= sel_rsd_pre;
        end if;
    end process output_reset3;

    output_reset4: process(clk, sel_rtd_pre) --flush_if_pre, flush_id_pre, pc_re_pre, sel_rsd_pre, sel_rtd_pre, pc_re_sel_pre
    begin
        if (clk) then
            o_sel_rtd <= "00";
        else 
            o_sel_rtd <= sel_rtd_pre;
        end if;
    end process output_reset4;

    output_reset5: process(clk, pc_re_sel_pre) --flush_if_pre, flush_id_pre, pc_re_pre, sel_rsd_pre, sel_rtd_pre, pc_re_sel_pre
    begin
        if (clk) then
            pc_re_sel <= '0';
        else 
            if(pc_re_sel_pre'stable(10 ps)) then
                pc_re_sel <= pc_re_sel_pre;
            end if;
        end if;
    end process output_reset5;


end mixed;

-- if not(ex.rd = 0 and mem.rd = 0)
--      if not(if id inst = break, or halt)
--          if(((ex or mem inst = movn or movz) or ex inst = lw) and not jump)
--              if(ex.rd = id.rs or ex.rd = id.rt or mem.rd = id.rs or mem.rd = id.rt)
--                  flush_if = 1
--                  flush_id = 1
--                  pc_re = 1 (set pc input linkr to ex.pc4 and pc_sel to 01)
--                  if(mem inst = movn or movz and ex inst branch and ex.taken_ex)
--                      pc_re_sel = 1
--         else
--              if(ex.rd = id.rs and ex.regwe)
--                  sel_rsd = 01
--              else if (mem.rd = id.rs and mem.regwe)
--                  sel_rsd = 10
--              if(ex.rd = id.rt and ex.regwe)
--                  sel_rtd = 01
--              else if (mem.rd = id.rt and mem.regwe)
--                  sel_rtd = 10
-- if(ex inst = jump)
--      flush if = 1
--      flush_id = 1
--      if(jr or jalr)
--          pc_re = 1
--          pc_re_sel = 1
-- if(ex.inst = branch and ex.taken_ex)
--      flush_if = 1
--      flush_id = 1