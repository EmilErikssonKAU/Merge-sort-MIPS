.data
	antal:		.word 0
	vek:		.word 4,5,2,2,1,-6,7,10,2,4,-1,4,87,76,65,3,4,-6

.text
	main:		# check for antal >= 0
			lw $t0, antal
			ble $t0, $zero, exit
	
			# Prepare for printArray call
			la $a0,	vek 
			lw $a1, antal
			subi $sp, $sp, 8
			jal printArray
			addi $sp, $sp 8
			
			
			# Prepare for mergeSort call
			la $a0,	vek 
			lw $a1, antal
			subi $sp, $sp, 8
			jal mergeSort
			addi $sp, $sp 8
			
			
			# Prepare for printArray call
			la $a0,	vek 
			lw $a1, antal
			subi $sp, $sp, 8
			jal printArray
			addi $sp, $sp 8
			
			
	exit: 		# Terminate execution
			li $v0, 10
			syscall
