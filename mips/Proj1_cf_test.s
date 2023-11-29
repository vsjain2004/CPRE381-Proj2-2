.data


.text
addi $a0, $0, 4

#execute recursive fibonacci
jal fibonacci
j Exit

fibonacci:
bne $a0, $0, base_1
add $v0, $0, $0
jr $ra

base_1:
addi $v0, $0, 1
beq $a0, $v0, End

recursion:
addi $sp, $sp, -8
sw $a0, 0($sp)
sw $ra, 4($sp)
addi $a0, $a0, -1
jal fibonacci
lw $a0, 0($sp)
sw $v0, 0($sp)
addi $a0, $a0, -2
jal fibonacci
lw $t0, 0($sp)
lw $ra, 4($sp)
addi $sp, $sp, 8
add $v0, $v0, $t0
jr $ra

End:
jr $ra

Exit:
halt