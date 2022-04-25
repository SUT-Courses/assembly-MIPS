.text
	addi	$v0,$zero,5		# read_int syscall code = 5
	syscall			# syscall results returned in $v0
	move	$s0,$v0		# strore input into s0

	addi	$v0,$zero,5		# read_int syscall code = 5
	syscall			# syscall results returned in $v0
	move	$s1,$v0		# store input into s1

	# shift s0
	sll     $s0,$s0,24     	# shift s0 3*8 bit to right (logical)
	srl     $s0,$s0,24	# shift s0 3*8 bit to left
	
	# shift s1     
	srl     $s1,$s1,24  	# shift s1 3*8 bit to right (logical)
		
	# mult
	multu   $s0,$s1		# multiply s0 and s1, value stored in hi and lo
	
	mflo	$s2		# s2 = lo note that whole number can be stored in 16 bits
	sll  	$s2,$s2,8	# shift s2 1*8 bit to left
	
	# Print sum
	addi	$v0,$zero,1		# print_int syscall code = 1
	move	$a0,$s2		# int to print must be loaded into $a0
	syscall
	
	

	addi	$v0,$zero,10		# exit
	syscall
