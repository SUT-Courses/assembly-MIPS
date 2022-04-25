.text	
	lw	$s0,len 	# store length in s0
	la	$s1,arr 	# store arr address in s1
	jal	sort		# function call - sort array	
	j	print		# function call - print sorted array

exit:	
	addi	$v0,$zero,10		# finishing program
	syscall
	

# using genome sort(stupid sort)
sort:
	beq	$s0,1,print	# if array consisted of 1 cell then just end sorting
	addi 	$t7,$zero,1		# idx2 stored in t7
	addi	$t6,$zero,0		# idx1 stored in t6
	
	move 	$t5,$zero
	
	main_loop:
	add	$t7,$t7,$t5	# iterate array idx2
	add	$t6,$t6,$t5	# iterate array idx1
	beq	$t7,$s0,end_sort# if len == idx2 so it is end of sort 
	beq	$t7,$zero,incr_idx	# if idx2 == 0 is zero then idx1 = 0, idx2 = 1
	swap_part:
	move	$a0,$t6		# prepare swap call, input idx1 , idx2
	move	$a1,$t7		
	addi	$sp, $sp, -4 	# push
	sw 	$ra, 0($sp)	# ra saved in stack
	jal	swap		# function call - swap: swapped idx1, idx2 if arr[idx1] > arr[idx2]
	lw 	$ra,0($sp)	# load ra
	addi	$sp, $sp, 4 	# pop
	move 	$t5,$v0		# store return value in t5 
	j	main_loop	# end of loop 
	
	incr_idx:		
	addi	$t7,$t7,1	# increase idxs by 1
	addi	$t6,$t6,1
	j 	swap_part	# continue from swap part
	
	end_sort:		# if sort ended
	jr	$ra		# return to main
	
	
	
swap:
	mul	$a0,$a0,4	# byte index
	add 	$a0,$a0,$s1	# find i'th index
	
	lw 	$t0,0($a0)	# store i'th index in t0
	
	mul	$a1,$a1,4	# byte index
	add 	$a1,$a1,$s1	# find j'th index
	
	lw 	$t1,0($a1)	# store j'th index in t1
	
	slt 	$t2,$t1,$t0	# if ($t1<$t0) $t2=1
	addi	$v0,$zero,1		# iteration will be continued in array
	beq	$t2,$zero,end 	# if ($t2!=0) goto L

	sw	$t1,0($a0)	# store swaped amounts in the array
	sw	$t0,0($a1)	
	addi	$v0,$zero,-1		# iteration will begin from previous idx1 and idx2
	end:
	jr	$ra		# back to program
	
print:
	ori	$t0,$zero,0	# t0 = 0
	loop_print:
	beq 	$t0,$s0,exit	# end of print
			
	move	$t2,$t0		# t2 = t0
	mul	$t2,$t2,4	# byte address to the index
	add	$t2,$s1,$t2	# address to index
	lw 	$a0,0($t2)      # get the element from the array
    	ori     $v0, $0, 1      # $v0 = 1 to print an int value
    	syscall
	
	la      $a0, space	# print space
    	ori     $v0, $0, 4	# $v0 = 4 to print ascii
    	syscall
	
	addi	$t0,$t0,1	# t0 += 1
	j 	loop_print	# continue over loop

.data
arr: 1,-1,2,-10,100,-3
len: 6
space: ' '

## ____________________________________________________##
## first swap subroutine for the first part of question
#swap:
#	mul	$a0,$a0,4	# byte index
#	add 	$a0,$a0,$s1	# find i'th index
#	
#	lw 	$t0,0($a0)	# store i'th index in t0
#	
#	mul	$a1,$a1,4	# byte index
#	add 	$a1,$a1,$s1	# find j'th index
#	
#	lw 	$t1,0($a1)	# store j'th index in t1
#	sw	$t1,0($a0)	# store swaped amounts in the array
#	sw	$t0,0($a1)	
#	jr	$ra		# back to program
