.text	
	l.s 	$f5, f_one	# f5 = 1
	l.s 	$f8, f_three	# f8 = 3
	l.s 	$f16, f_four	# f16 = 4
	
	addi	$v0,$zero,6	# inputing
	syscall

	mov.s	$f1,$f0		# f1 is input for f func
	jal	f		# call function f

	addi 	$v0,$zero,2	# print output of function
	syscall
	
	addi 	$v0,$zero,10	# end of code
	syscall
	
f:		
	c.le.s	$f1,$f5		# if f1 < 1 then code = 1
	bc1t 	less_1		# if code == 1: jump to less_1
	
	addi 	$sp,$sp,-16	# sp adjusted
	sw	$ra,0($sp)	# store ra
	s.s	$f1,4($sp)	# store input
	s.s 	$f3,8($sp)	# store input
	s.s	$f7,12($sp)	# store input
	add.s	$f1,$f5,$f1	# make new input
	div.s	$f1,$f1,$f8 	# make new input 
	jal	f		# call func
	lw	$ra,0($sp)	# load ra
	l.s	$f1,4($sp)	# load input
	l.s	$f3,8($sp)	# load input
	l.s	$f7,12($sp)	# load input
	addi 	$sp,$sp,16	# sp adjusted
	mov.s	$f3,$f12	# f3 = f[(1/3) * (f1+1)]
	
	addi 	$sp,$sp,-16	# sp adjusted
	sw	$ra,0($sp)	# store ra
	s.s	$f1,4($sp)	# store input
	s.s 	$f3,8($sp)	# store input
	s.s	$f7,12($sp)	# store input
	add.s	$f1,$f5,$f1	# make new input
	div.s	$f1,$f1,$f16 	# make new input
	jal	f		# call func
	lw	$ra,0($sp)	# load ra
	l.s	$f1,4($sp)	# load input
	l.s	$f3,8($sp)	# load input
	l.s	$f7,12($sp)	# load input
	addi 	$sp,$sp,16	# sp adjusted
	mov.s	$f7,$f12	# f7 = f[(1/4) * (f1+1)]
	
	add.s	$f12,$f7,$f3	# f12 = f3 + f7
	jr	$ra		# return to ra
	
	less_1:			# end of function
	mov.s	$f12,$f5	# f12 = 1
	jr	$ra		# return to ra

.data	
f_one: .float 1.0		
f_three: .float 3.0
f_four: .float 4.0
