library IEEE;
use IEEE.std_logic_1164.all;

entity Forward is
    port();
end Forward;

-- Update PipielineReg for the below ops

-- Forward when the following
-- 1. Instruction needs something from the reg file (most inst)
-- 2. EX/MEM (higher priority) or MEM/WB (lower priority) is going to write back to that register and data is ready
-- 3. Function in upper pipeline is not movn or movz
-- 
-- Therefore
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