    addi $0, $0, 0 # NOP
    addi $a0, $0, 5 # n = $a0 = 5
    addi $0, $0, 0 # NOP
    addi $0, $0, 0 # NOP
    sw $a0, 0($0)
    addi $t0, $0, 1 # t0 = 1, we use this as a constant
    addi $s0, $0, 1 # f = 1
    addi $0, $0, 0 # NOP
while: 
    slt $t1, $t0, $a0 # t0 < a0 ;   t1 = 1 < n ? 1 : 0
    addi $0, $0, 0 # NOP
    addi $0, $0, 0 # NOP
    beq $t1, $0, exit # if t1 == 0, then exit, because 1 >= n
    addi $0, $0, 0 # NOP to wait for branch result
    addi $0, $0, 0 # NOP
    addi $0, $0, 0 # NOP
    multu $s0, $a0 # $s0 * $a0 = Hi and Lo registers
    addi $0, $0, 0 # NOP
    addi $0, $0, 0 # NOP
    mflo $s0 # copy Lo to $s0
    sub $a0, $a0, $t0 # n = n - 1
    j while # jump to while
exit:
    sw $s0, 0x10($0)
