	addi $0, $0, 0 # NOP
main:
	addi $t0, $0, 1 # set $t0 to 0x8000
	addi $s0, $0, 6 # set arg
	addi $t1, $0, 1 # set $t1 to 1
	sll $t0, $t0, 15 # shift left to get 0x8000
	
	sw $s0, 0($t0) # fact[0] = 5
	sw $t1, 4($t0) # fact[1] = 1 (Go signal)

poll:
	lw $t2, 8($t0) # load fact[2] (status)

	beq $t2, $0, poll # wait for signal
	addi $0, $0, 0 # Branch delay slot

	lw $s0, 0xC($t0) # load fact[3] (result)

end:
	addi $0, $0, 0 # NOP at the end

	
