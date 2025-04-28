    addi $0, $0, 0 # NOP
    
    addi $a0, $0, 5 # n = $a0 = 5
    addi $a0, $a0, 5
    sw   $a0, 0x10($0)

    lw   $a1, 0x10($0)
    addi $a1, $a1, -5

    addi $0, $0, 0 # NOP
    addi $0, $0, 0 # NOP
    addi $0, $0, 0 # NOP
    addi $0, $0, 0 # NOP
    addi $0, $0, 0 # NOP
    addi $0, $0, 0 # NOP

    
