.text	
	addi	$v0,$v0,5       # input n
	syscall
	#############################################
	move	$s1,$v0		# s1 = n
	
	move 	$a0,$s1		# input for F_a
	jal	F_a		# first part of the question ## this function properly will work for n <= 12 
	move	$t3,$v0		# store output in t3
	#############################################
	addi	$v0,$zero,1	# print output of F_a
	move	$a0,$t3
	syscall
	#############################################
	addi	$v0,$zero,4	# print new line
	la	$a0,n_l
	syscall
	addi	$v0,$zero,4	# print new line
	la	$a0,n_l
	syscall
	#############################################
	move 	$a0,$s1		# input for F_b
	jal	F_b		# sec part of question ## this function will properly work for n <= 20
	move	$t3,$v0		# output (lo)
	move	$t4,$v1		# output (hi)
	#############################################	 
	addi	$v0,$zero,1	# print int
	move	$a0,$t3		# print lo
	syscall

	addi	$v0,$zero,4	# print new line
	la	$a0,n_l		
	syscall
		
	addi	$v0,$zero,1	# print int
	move	$a0,$t4		# print hi
	syscall
	############################################# 		 		 	
	addi	$v0,$zero,10	# finishing program
	syscall

F_a: ## this function properly will work for n <= 12 
	move	$t0,$a0		# t0 = n
	beq 	$t0,1,end	# if t0==1 goto end
	
	addi	$sp,$sp,-8	# prepare stack pointer
	sw	$a0,0($sp)	# push a0
	sw	$ra,4($sp)	# push ra
	addi	$a0,$a0,-1	# input 
	jal	F_a		# function call 
	lw	$a0,0($sp)	# pop a0
	lw	$ra,4($sp)	# pop ra
	addi	$sp,$sp,8	# pointer adjustment
		
	move	$t1,$v0		# store output
	mulu	$t1,$a0,$t1	# compute f(n)
	addiu	$t1,$t1,1	# compute f(n)
	move	$v0,$t1		# store output
	jr	$ra		# return 
	
	end:
		addi	$v0,$zero,2	# v0 = 2
		jr	$ra	# return
		
F_b: ## this function will properly work for n <= 20
	move	$t0,$a0		# t0 = n
	beq 	$t0,1,end_b	# if t0==1 goto end
	
	addi	$sp,$sp,-8	# prepare stack pointer
	sw	$a0,0($sp)	# push a0
	sw	$ra,4($sp)	# push ra
	addi	$a0,$a0,-1	# input 
	jal	F_b		# function call 
	lw	$a0,0($sp)	# pop a0
	lw	$ra,4($sp)	# pop ra
	addi	$sp,$sp,8	# pointer adjustment
		
	move	$t1,$v0		# store output first 32 bit
	move	$t2,$v1		# store output first 32 bit
	
	multu	$a0,$t1		# compute f(n)
	
	mflo	$v0		# store lo in v0
	mfhi	$v1		# store hi in v1
	
	mulu 	$t2,$t2,$a0	# t2 = t2 * a0
	addu	$v1,$v1,$t2	# v1 += t2
	
	sltu	$t7,$v0,$s7	# if v0 equals to max 32 bit unsigned number t7 = 0		
	
	sltu	$t7,$v0,$zero	# check if v0 is negative
	beq	$t7,$zero,add_v0_pos_1	# if positive v0++ 
	
	addi	$v0,$v0,-1	# because it is negetavie v0--
	jr	$ra		# return 	
	
	
	add_v0_pos_1:
	addi	$v0,$v0,1	# v0 ++
	jr	$ra		# return 
	
	end_b:
		addi	$v0,$zero,2	# v0 = 2
		addi	$v1,$zero,0 	# v1 = 0
		jr	$ra	# return

.data
n_l : '\n'
