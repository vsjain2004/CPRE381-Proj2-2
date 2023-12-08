.data

size: .word 6

.text

addi $t0, $0, 6
addiu $t1, $0, -25
ori $t2, $0, 5
lui $t3, 0x1001
sll $t4, $t0, 1
srl $t5, $t0, 1
xori $t7, $t2, 4
lw $t8, 0($t3)
sra $t6, $t1, 1
slti $t9, $t2, 6
sltiu $s0, $t2, -6
sw $t8, 4($t3)
sllv $s1, $t0, $t7
srlv $s2, $t0, $t7
srav $s3, $t1, $t7
add $s4, $t9, $s0
addu $s5, $t8, $t7
sub $s6, $t9, $s0
subu $s7, $t1, $t1
jal link1
j ad
link1:
jr $31

ad:
andi $t0, $t2, 4
and $t1, $t2, $t2
or $t2, $t2, $t4
movn $t7, $t0, $0
movz $t7, $t0, $0
xor $t3, $t0, $t2
nor $t4, $t2, $t2

beq $0, $0, branch1
branch2:
blez $t6, branch3
branch4:
j Exit

branch1:
bne $0, $t0, branch2
branch3:
bgtz $t1, branch4
Exit:

halt
