.text

# Open (for writing) a file that does not exist
addi 	$v0,$zero,13 	# system call for open file
la 	$a0, fout 	# output file name
addi 	$a1,$zero,1 		# Open for writing (flags are 0: read, 1: write)
addi 	$a2,$zero,0		# mode is ignored
syscall 		# open a file (file descriptor returned in $v0)
move $s6, $v0 		# save the file descriptor

# Open (for reading) a file
addi 	$v0,$zero,13 	# system call for open file
la 	$a0, fin 	# input file name
addi 	$a1,$zero,0 		# Open for reading
addi 	$a2,$zero,0		# mode is ignored
syscall 		# open a file (file descriptor returned in $v0)
move $s7, $v0 		# save the file descriptor

addi 	$t0,$zero,0	# counter
addi 	$t1,$zero,0	# fib first element
addi 	$t2,$zero,1	# fib sec  element
loop:

# Read from file
addi 	$v0,$zero,14 	# system call for read
move 	$a0, $s7	# file descriptor
la 	$a1, buffer 	# address of buffer from which to read
addi 	$a2,$zero,1		# read file
syscall

beq	$v0,$zero,end	# if end of file is reached
beq	$t0,$t2,is_fib	# equals to fib num
beq	$t0,$t1,is_fib	# equals to fib num

# Write to file 
addi 	$v0,$zero,15 	# system call for write to file
move 	$a0, $s6	# file descriptor
la 	$a1, buffer 	# address of buffer from which to write
addi 	$a2,$zero,1		# hardcoded buffer length
syscall 		# write to file

addi	$t0,$t0,1	# counter ++
j	loop		# iterate over file

end:
# Close the file
addi 	$v0,$zero,16 	# system call for close file
move 	$a0, $s6 	# file descriptor to close
syscall 		# close file

# Close the file
addi 	$v0,$zero,16 	# system call for close file
move 	$a0, $s7 	# file descriptor to close
syscall 		# close file

# close running
addi	$v0,$zero,10		# end of code
syscall

is_fib:
move 	$t3,$t2		# find next fib_pair numbers
add 	$t2,$t2,$t1		
move	$t1,$t3		
addi	$t0,$t0,1	# counter ++
j	loop		


.data
	fout: .asciiz "testout.txt" # filename for output
	fin: .asciiz "testin.txt" # filename for input
	buffer: .space 2