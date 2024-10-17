.data	
	newline:	.asciiz "\n"	
	number_format:	.asciiz "%d "
	
	.globl printArray
#	Arguments:
#	$a0 -> address of vector
#	$a1 -> size of vector

.text
	printArray:	# Store arguments
			sw $a0, 0($sp)
			sw $a1, 4($sp)
	
			# Activation block
			subi $sp, $sp, 32
			sw $ra, 28($sp)
			sw $s0, 24($sp)
			sw $s1, 20($sp)
			
			# Temporary saving because we are afraid of scary $sp
			move $s0, $a0
			move $s1, $a1
	
			# Print initial newline		
			la $a0, newline
			subi $sp, $sp, 16
			jal print
			addi $sp, $sp, 16
			
			move $s3, $zero
			
	while:		# We increment $s3 every lap
			# and exit when $s3 >= $a1
			
			# Store format string in $a0
			la $a0, number_format
			
			# Store a[i] in $a1
			move $t0, $s0
			sll $t1, $s3, 2
			add $t2, $t0, $t1
			lw $a1, ($t2)
			
			# Print call
			subi $sp, $sp, 16
			jal print
			addi $sp, $sp, 16
			
			# increment
			addi $s3, $s3, 1
			beq $s3, $s1, end
			j while
	
			
	end:		# Print final newline		
			la $a0, newline
			subi $sp, $sp, 16
			jal print
			addi $sp, $sp, 16
	
			# Restore registers before return
			lw $ra, 28($sp)
			lw $s0, 24($sp)
			lw $s1, 20($sp)
			
			addi $sp, $sp, 32
			
			# Return
			jr $ra
					
			
