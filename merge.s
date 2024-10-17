.data

	.globl merge
	
#	Arguments:
#	$a0 -> address of vector
#	$a1 -> size of vector
	
.text
	merge:		# Store arguments
			sw $a0, 0($sp)
			sw $a1, 4($sp)
	
			# Activation block
			subi $sp, $sp, 40
			sw $ra, 36($sp)
			sw $s0, 32($sp)
			sw $s1, 28($sp)
			sw $s2, 24($sp)
			sw $s3, 20($sp)
			sw $s4, 16($sp)
			sw $s5, 12($sp)
			sw $s6, 8($sp)		

			
			# Temporary saving because we are afraid of scary $sp
			move $s0, $a0
			move $s1, $a1
			
			# Calculate half = size/2, saved in $s2
			li $t0, 2
			div $s1, $t0
			mflo $s2
			
			
			# attempt at stack allocation
			sll $t0, $s1, 2
			subu $sp, $sp, $t0
			move $s6, $sp
			
			
			# i=$s3, j=$s4, k=$s5, base of b= $s6
			move $s3, $zero
			move $s4, $s2
			move $s5, $zero

			
			# Simple array copying sequence
	copy_arr:	move $t0, $s0		# $t0 = start address of array
   			move $t1, $s6		# $t1 = start addres of copy_array
 			move $t2, $zero		# $t2 = index, starting at 0
    			move $t3, $s1		# $t3 = size, upper limit
    			
	
	copy_loop:	beq $t2, $t3, while_1	# break if index == upper limit
    			lw $t4, 0($t0)		# $t4 = a[index]
    			sw $t4, 0($t1)		# b[index] = $t4
    			addi $t0, $t0, 4	# increment arrays and index
    			addi $t1, $t1, 4
    			addi $t2, $t2, 1
    			j copy_loop
	
		
	while_1:	# End of copy-sequence
			bge $s3, $s2, while_2	# branch if i >= half
			bge $s4, $s1, while_2	# branch if j >= size
			
			sll $t0, $s3, 2		# $t0 = 4*i
			sll $t1, $s4, 2		# $t1 = 4*j
			
			add $t2, $s6, $t0	# $t2 = address of b[i]
			add $t3, $s6, $t1	# $t3 = address of b[j]
			
			lw $t6, 0($t2)    	# Load b[i] into $t6
			lw $t7, 0($t3)     	# Load b[j] into $t7
			
			bge $t6, $t7, else_1	# branch if b[i] >= b[j]
			
			# if-body
			sll $t4, $s5, 2		# $t4 = k * 4
			add $t5, $s0, $t4	# $t5 = address of a[k]
			lw $t7, 0($t2)		# $t7 = b[i]
			sw $t7, 0($t5)		# a[k] = $t7
			addi $s3, $s3, 1	# i++
			j end_if_1
			
		
	else_1:		# else-body
			sll $t4, $s5, 2		# $t4 = k * 4
			add $t5, $s0, $t4	# $t5 = address of a[k]
			lw $t7, 0($t3)		# $t7 = b[j]
			sw $t7, 0($t5)		# a[k] = $t7
			addi $s4, $s4, 1	# j++
			j end_if_1
	
	
	end_if_1:	# increment k
			addi $s5, $s5, 1	# k++
			j while_1		
			
				
	while_2:	# second while loop
			bge $s3, $s2, while_3	# branch if i >= half
			sll $t0, $s5, 2		# $t0 = 4*k
			add $t1, $s0, $t0	# $t1 = address of a[k]
			sll $t2, $s3, 2		# $t2 = 4*i
			add $t3, $s6, $t2	# $t3 = address of b[i]
			lw $t4, 0($t3)		# $t4 = b[i]
			sw $t4, 0($t1)		# a[k] = $t4
			addi $s3, $s3, 1	# i++
			addi $s5, $s5, 1	# k++
			j while_2
			
			
	while_3:	# third while loop
			bge $s4, $s1, end	# branch if j>=size
			sll $t0, $s5, 2		# $t0 = 4*k
			add $t1, $s0, $t0	# $t1 = address of a[k]
			sll $t2, $s4, 2		# $t2 = 4*j
			add $t3, $s6, $t2	# $t3 =  address of b[j]
			lw $t4, 0($t3)		# $t4 = b[j]
			sw $t4, 0($t1)		# a[k] = $t4
			addi $s4, $s4, 1	# j++
			addi $s5, $s5, 1	# k++
			j while_3
			
	
	end:		sll $t0, $s1, 2
			add $sp, $sp, $t0
			
			# Restore registers before return
			lw $ra, 36($sp)
			lw $s0, 32($sp)
			lw $s1, 28($sp)
			lw $s2, 24($sp)
			lw $s3, 20($sp)
			lw $s4, 16($sp)
			lw $s5, 12($sp)
			lw $s6, 8($sp)
			
			addi $sp, $sp, 40
			
			# Return
			jr $ra
