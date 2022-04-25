.text
	addi	$v0,$zero,4		# print_string syscall code = 4
	la	$a0, msg1	
	syscall
	
	addi	$v0,$zero,5		# read_int syscall code = 5
	syscall			# read         ------- M -------	
	move	$s0,$v0		# syscall results returned in $v0
	
	
	addi	$v0,$zero,4		# print_string syscall code = 4
	la	$a0, msg2	
	syscall
	
	addi	$v0,$zero,5		# read_int syscall code = 5
	syscall			# read         ------- N -------
	move	$s1,$v0		# syscall results returned in $v0
	
	
	addi	$v0,$zero,4		# print_string syscall code = 4
	la	$a0, msg3	
	syscall
	
	addi	$v0,$zero,5		# read_int syscall code = 5
	syscall			# read         ------- P -------		
	move	$s2,$v0		# syscall results returned in $v0
	
	# compute number of elements in each array 
	mult 	$s1,$s0		# number of elements in array1
	mflo 	$s3		# store in s3
	
	mult 	$s0,$s2		# number of elements in array2
	mflo 	$s4		# store in s4
	
	# input array1
	mul 	$t3,$s3,4 	# number of bytes needed to save array1
	move 	$a0,$t3		# these four lines allocate memory for array1
	addi 	$v0,$zero,9		
	syscall
	
	move 	$s5,$v0		# address of array1  ____________ s5 _______________
	
	# loop to for input array1
	move 	$t0,$zero	# for loop until (t0 == n*m) then break
	
loop1:	
	addi	$v0,$zero,5		# read_int syscall code = 5
	syscall			# read         ------- M -------	
	move	$t1,$v0		# syscall results returned in $v0
	
	mul 	$t3,$t0,4	# array element index
	
	add 	$t2,$s5,$t3	# address of element
	sw 	$t1,0($t2)	# store input in corresponding location
	
	addi 	$t0,$t0,1	# add 1 step to loop counter
	beq	$t0,$s3,after_l1# if loop is ended junp to label
	j 	loop1		# if loop is not ended jump to label(although there is no condition in 'j' instruction)
after_l1:

	# input array
	mul 	$t3,$s4,4 	# number of bytes needed to save array2
	move 	$a0,$t3		# these four lines allocate memory for array2
	addi 	$v0,$zero,9
	syscall
	
	move 	$s6,$v0		# address of array2 ____________ s6 _______________
	
	# lopp to for input
	move 	$t0,$zero	# for loop until (t0 == m*p) then break
	
loop2:	
	addi	$v0,$zero,5		# read_int syscall code = 5
	syscall			# read         ------- M -------	
	move	$t1,$v0		# syscall results returned in $v0
	
	mul 	$t3,$t0,4	# array element index
		
	add 	$t2,$s6,$t3	# address of element
	sw 	$t1,0($t2)	# store input in corresponding location
	
	addi 	$t0,$t0,1	# add 1 step to loop counter
	beq	$t0,$s4,after_l2# if loop is ended junp to label	
	j 	loop2		# if loop is not ended jump to label(although there is no condition in 'j' instruction)
	
after_l2:	#### untill now we have two arrays saved in the heap 
	
		
	move 	$t9,$zero	# loop counter if t9 = n*p then break
loop_main:		

	div 	$t9,$s2		# find which row col is iteration in
	mfhi 	$s4		# #col
	mflo	$s3		# #row
	
	mul 	$s4,$s4,4	# array first element(column) index * 4
	
	mul	$s3,$s0,$s3	# array first element(row) index
	mul	$s3,$s3,4	# index * 4 (byte addressing)
	
	move 	$t3,$zero	# sum of dot product of one row and one col will be stored in t3
	
	move 	$t0,$s5		# address array1
	add 	$t0,$s3,$t0	# pointer to specific row
		
	move 	$t1,$s6		# address array2	
	add 	$t1,$s4,$t1	# pointer to specific col
	
	move	$t7, $zero 	# end loop check		

loop_row_col_mult: 	# inner loop

	lw	$t4,0($t0)	# load number from array1
	lw	$t5,0($t1)	# load number from array2
	
	addi	$t0,$t0,4	# next element array1
	
	mul	$t8,$s2,4	# distance from next number needed in byte
	add	$t1,$t1,$t8	# next element array2
	
	mul 	$t4,$t4,$t5	# dot product multiplication part
	add 	$t3,$t3,$t4	# dot product sumation part
	
	addi 	$t7,$t7,1	# loop counter plus 1
	
	beq	$t7,$s0,after_loop_row_col_mult # end of loop
	j	loop_row_col_mult 		# loop is not ended

after_loop_row_col_mult:

	addi 	$t9,$t9,1   	# loop counter plus 1 (outer loop)
	
	move 	$a0,$t3		# print element
	addi 	$v0,$zero,1		# print-int
	syscall 		
	
	addi	$v0,$zero,4		# print_string syscall code = 4
	la	$a0, space	# print space
	syscall
	
	div 	$t9,$s2		# loop counter % P
	mfhi 	$s4		# remainder stored in s4
	beq 	$s4,$zero,newline 	# print new line if row is new
	j	after_newline	# jump to label if not new line
newline:
	addi	$v0,$zero,4		# print_string syscall code = 4
	la	$a0, n_line	# print new line
	syscall	
after_newline:

	mul 	$s7,$s1,$s2	# size of array output
				
	beq 	$s7,$t9,after_loop_main	# end loop if size output == n*p
	j	loop_main	# loop is not ended
	
after_loop_main:
	addi	$v0,$zero,10		# exit
	syscall

	
.data

msg1: .asciiz "input M"
msg2: .asciiz "input N"
msg3: .asciiz "input P"
space: .asciiz " "
n_line: .asciiz "\n"
