	addi $0, $0, 0 # NOP
main:
	addi $sp, $0, 48 
	addi $a0, $0, 5 # set arg

	jal factorial # compute the factorial
	addi $0, $0, 0 # NOP
	addi $0, $0, 0 # NOP
	addi $0, $0, 0 # NOP
	
	add $s0, $v0, $0 # move result into $s0
	
	j end
	addi $0, $0, 0 # NOP
	addi $0, $0, 0 # NOP
	addi $0, $0, 0 # NOP

factorial:
	addi $sp, $sp, -8 # make room on stack
	addi $0, $0, 0 # NOP to wait for arithmetic instruction
	addi $0, $0, 0 # NOP
	
	sw $a0, 4($sp) # store $a0
	sw $ra, 0($sp) # store $ra

	addi $t0, $0, 2 # $t0 = 2
	addi $0, $0, 0 # NOP
	addi $0, $0, 0 # NOP

	slt $t1, $a0, $t0 # a <= 1 ?
	addi $0, $0, 0 # NOP
	addi $0, $0, 0 # NOP

	beq $t1, $0, else # no - goto else
	addi $0, $0, 0 # NOP to wait for branch result
	addi $0, $0, 0 # NOP
	addi $0, $0, 0 # NOP

	addi $v0, $0, 1 # yes - return 1
	addi $sp, $sp, 8 # restore $sp
	
	jr $ra # return
	addi $0, $0, 0 # NOP to wait for return
	addi $0, $0, 0 # NOP
	addi $0, $0, 0 # NOP

else:
	addi $a0, $a0, -1 # n = n - 1

	jal factorial # recursive call
	addi $0, $0, 0 # NOP to wait for jal to compute jump address
	addi $0, $0, 0 # NOP
	addi $0, $0, 0 # NOP

	lw $a0, 4($sp) # restore $a0
	lw $ra, 0($sp) # restore $ra
	
	addi $sp, $sp, 8 # restore $sp

	multu $a0, $v0 # n * factorial(n-1)
	addi $0, $0, 0 # NOP to wait for multu result
	addi $0, $0, 0 # NOP

	mflo $v0 # mv result into $v0

	jr $ra
	addi $0, $0, 0 # NOP to wait for jr to compute jump address
	addi $0, $0, 0 # NOP
	addi $0, $0, 0 # NOP

end:
	addi $0, $0, 0 # NOP
