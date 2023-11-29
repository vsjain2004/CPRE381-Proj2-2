.text

lui $t0, 32768
lui $t1, 0
ori $t1, 45
add $t2, $t1, $t0
addi $t3, $t2, -1000
addu $t4, $t0, $t1
addiu $t5, $t4, 1000
and $t6, $t1, $t2
andi $t7, $t1, 5
nor $t8, $t1, $t2
xor $t9, $t1, $t0
xori $t2, $t1, 2
or $t3, $t1, $t2
ori $t4, $t1, 5
slt $t5, $t0, $t1
slti $t6, $t1, 50
sll $t7, $t1, 1
srl $t8, $t0, 1
sra $t9, $t0, 1
sub $t2, $t0, $t1
subu $t3, $t0, $t1
halt