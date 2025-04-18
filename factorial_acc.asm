	addi $0, $0, 0 # NOP
main:
	addi $t0, $0, 0x8000 # set $t0 to 0x8000
	addi $s0, $0, 5 # set arg
	addi $t1, $0, 1 # set $t1 to 1

	addi $0, $0, 0 # NOP
	
	sw $s0, 0($t0) # fact[0] = 5
	sw $t1, 4($t0) # fact[1] = 1 (Go signal)

poll:
	lw $t2, 8($t0) # load fact[2] (status)
	addi $0, $0, 0 # NOP
	addi $0, $0, 0 # NOP
	addi $0, $0, 0 # NOP

	beq $t2, $0, poll # wait for signal
	addi $0, $0, 0 # NOP
	addi $0, $0, 0 # NOP
	addi $0, $0, 0 # NOP

	lw $s0, 0xC($t0) # load fact[3] (result)
	addi $0, $0, 0 # NOP
	addi $0, $0, 0 # NOP

	

