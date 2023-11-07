library IEEE;
use IEEE.std_logic_1164.all;

entity Forward is
    port();
end Forward;

-- Forward when the following
-- 1. Instruction needs something from the reg file (most inst)
-- 2. EX/MEM (higher priority) or MEM/WB (lower priority) is going to write back to that register and data is ready
-- 3. Function in upper pipeline is not movn or movz
-- 
-- Therefore
-- if not(ex.rd = 0 or mem.rd = 0)
--      if not(if id inst = j, jal, break, or halt)
--          if(ex or mem inst = movn or movz)
--              if(ex.rd = id.rs or ex.rd = id.rt or mem.rd = id.rs or mem.rd = id.rt)
--                  flush_if = 1
--                  flush_id = 1
--         else
--              if(ex.rd = id.rs and ex.regwe)
--                  sel_rsd = 01
--              else if (mem.rd = id.rs and mem.regwe)
--                  sel_rsd = 10
--              if(ex.rd = id.rt and ex.regwe)
--                  sel_rtd = 01
--              else if (mem.rd = id.rt and mem.regwe)
--                  sel_rtd = 10
-- if(j(r), jal(r), branch)
--      flush_id = 1
--
-- if flush_if
--      pc = ex.pc4 (put it into o_rs and select line is 01)