.data

test: .word 10

.text
addi $0, $0, 2
add $1, $1, $1
add $2, $1, $1
la $t0, test
lw $t1, 0($t0)
add $t2, $t1, $t1
lw $t3, 0($t0)
nop
add $t4, $t3, $t1
movn $t5, $t4, $t0
movz $t6, $t1, $0
add $t7, $t5, $t6
halt