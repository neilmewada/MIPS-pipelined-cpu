	addi $0, $0, 0 # NOP for start
main:
	addi $sp, $0, 48 
	addi $a0, $0, 6 # set arg

	jal factorial # compute the factorial
	addi $0, $0, 0 # Branch delay slot
	
	add $s0, $v0, $0 # move result into $s0
	
	j end
	addi $0, $0, 0 # Branch delay slot

factorial:
	addi $sp, $sp, -8 # make room on stack
	
	sw $a0, 4($sp) # store $a0
	sw $ra, 0($sp) # store $ra

	addi $t0, $0, 2 # $t0 = 2

	slt $t1, $a0, $t0 # a <= 1 ?

	beq $t1, $0, else # no - goto else
	addi $0, $0, 0 # Branch delay slot

	addi $v0, $0, 1 # yes - return 1
	addi $sp, $sp, 8 # restore $sp
	
	jr $ra # return
	addi $0, $0, 0 # Branch delay slot

else:
	addi $a0, $a0, -1 # n = n - 1

	jal factorial # recursive call
	addi $0, $0, 0 # Branch delay slot

	lw $a0, 4($sp) # restore $a0
	lw $ra, 0($sp) # restore $ra
	
	addi $sp, $sp, 8 # restore $sp

	multu $a0, $v0 # n * factorial(n-1)

	mflo $v0 # mv result into $v0

	jr $ra
	addi $0, $0, 0 # Branch delay slot

end:
	addi $0, $0, 0 # NOP for end
