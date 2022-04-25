.text	
	### main
	addi 	$a0,$zero,12		# input #1
	addi	$a1,$zero,5		# input #2
	jal	is_pyth		# function call 
	
	addi	$v0,$zero,10		# finishing program
	syscall
	
is_pyth:
	move 	$t0,$a0		# store inputs in t0 and t1
	move	$t1,$a1
	
	mul 	$t0,$t0,$t0	# power 2 of inputs
	mul	$t1,$t1,$t1
	
	add	$t0,$t0,$t1	# store a^2 + b^2
	
	move	$a0,$t0		# input store in a0
	addi	$sp,$sp,-8	# make space for push
	sw	$ra,0($sp)	# push ra
	sw	$t0,4($sp)	# push t0
	jal	is_squared	# function call - check if t0 is power 2 of sum natural number
	lw	$ra,0($sp)	# pop ra
	lw	$t0,4($sp)	# pop t0
	addi	$sp,$sp,8	# change sp to last stack element
	move	$t1,$v0		# store output
	
	mul	$t2,$t1,$t1	# compute power 2 of output
	
	beq	$t0,$t2,is	# if c^2 == t0 goto label is
	
	addi	$v0,$zero,4		# print msg
	la	$a0,msg		# not pyth.
	syscall		
	
	jr	$ra		# end of subroutine
	is:
		move	$a0,$t1	# print number
		addi	$v0,$zero,1	
		syscall	
		
		jr	$ra	# end of subroutine

is_squared:
	move 	$t0,$zero	# first number in t0
	loop:
		addi	$t0,$t0,1		# t0++
		mul	$t1,$t0,$t0		# t1=t0^2
		slt	$t2,$t1,$a0		# if t^2 < a0: t2 = 1
		move	$v0,$t0			# store output
		beq	$t2,$zero,end_funct	# if t2 == 0 then end of is_squared
		j 	loop			# continue checking if a0 is squared
			
	end_funct:
		jr	$ra	# go back to function call
	
.data
msg: .asciiz "not Pythagorean"	
