.data

	.globl mergeSort
	
#	Arguments:
#	$a0 -> address of vector
#	$a1 -> size of vector
	
.text
	mergeSort:	# Store arguments
			sw $a0, 0($sp)
			sw $a1, 4($sp)
	
			# Activation block
			subi $sp, $sp, 20
			sw $ra, 16($sp)
			sw $s0, 12($sp)
			sw $s1, 8($sp)
			sw $s2, 4($sp)
			
			# Temporary saving because we are afraid of scary $sp
			move $s0, $a0
			move $s1, $a1
			
			# if
			bgt $s1, 1, recursion
			j end
			
			
	recursion:	# Calculate half = size/2, saved in $s2
			li $t0, 2
			div $s1, $t0
			mflo $s2
			
			# Lower recursion call
			move $a0, $s0
			move $a1, $s2
			subi $sp, $sp, 8
			jal mergeSort
			addi $sp, $sp, 8
			
			# Upper recursion call
			move $a0, $s0
			sll $t0, $s2, 2
			add $a0, $a0, $t0
			sub $a1, $s1, $s2
			subi $sp, $sp, 8
			jal mergeSort
			addi $sp, $sp, 8
			
			# Merge call
			move $a0, $s0
			move $a1, $s1
			subi $sp, $sp, 8
			jal merge
			addi $sp, $sp, 8
			
	
	end:		# Restore registers before return
			lw $ra, 16($sp)
			lw $s0, 12($sp)
			lw $s1, 8($sp)
			lw $s2, 4($sp)
			
			addi $sp, $sp, 20
			
			# Return
			jr $ra
