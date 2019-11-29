.data
	data: .space 1001
	output: .asciiz "\n"
	not_valid: .asciiz "NaN"
	commas: .asciiz ","
.text
main :
	#reads user input
	li $v0,8	
	la $a0,data	 
	li $a1, 1001	
	syscall
	jal Subprogram1 
	
jump:
	#jumps to the print function
	j print 
	
Subprogram1:
	#checks the input
	sub $sp, $sp,4 
	sw $a0, 0($sp) 
	lw $t0, 0($sp) 
	addi $sp,$sp,4 
	move $t6, $t0 

beginning:
	#check for spaces or tabs at the start and within the input
	li $t2,0 
	li $t7, -1 
	lb $s0, ($t0) 
	beq $s0, 0, in_substring 
	beq $s0, 10, in_substring  
	beq $s0, 44, invalid_loop 
	beq $s0, 9, pass  
	beq $s0, 32, pass 
	move $t6, $t0 
	j loop 
	
pass:
	#moves passed the spaces in the string
	addi $t0,$t0,1 
	j beginning 
loop:
	#goes through each character 
	lb $s0, ($t0) 
	beq $s0, 0, next
	beq $s0, 10, next  	
	addi $t0,$t0,1 	
	beq $s0, 44, substring 	
	

check_characters:
	#checks each character
	bgt $t2,0,invalid_loop 
	beq $s0, 9,  pass 
	beq $s0, 32, pass 
	ble $s0, 47, invalid_loop 
	ble $s0, 57, vaild 
	ble $s0, 64, invalid_loop 
	ble $s0, 85, vaild	
	ble $s0, 96, invalid_loop 
	ble $s0, 117, vaild 	
	bge $s0, 118, invalid_loop 

space:
	#keeps track of spaces/tabs
	addi $t2,$t2,-1 
	j loop

vaild:
	#keeps track of how many valid characters are in the substring
	addi $t3, $t3,1 
	mul $t2,$t2,$t7 
	j loop 	

invalid_loop:
	#keeps track of how many invalid characters are in the substring
	lb $s0, ($t0) 
	beq $s0, 0, in_substring
	beq $s0, 10, in_substring  	
	addi $t0,$t0,1 	
	beq $s0, 44, in_substring 
	j invalid_loop 


in_substring:
	#keeps track of the amount of characters in the substring 
	addi $t1,$t1,1 	
	sub $sp, $sp,4
	sw $t7, 0($sp) 
	move $t6,$t0  
	lb $s0, ($t0) 
	beq $s0, 0, jump
	beq $s0, 10, jump 
	beq $s0,44, invalid_loop 
	li $t3,0 
	li $t2,0 
	j beginning
	
substring:
	#checks if there was a space before a valid character in the substring
	mul $t2,$t2,$t7 
	
	
next:
	#checks the characters in the substring
	bgt $t2,0,in_substring 
	bge $t3,5,in_substring 
	addi $t1,$t1,1  	
	sub $sp, $sp,4 
	sw $t6, 0($sp) 
	move $t6,$t0  
	lw $t4,0($sp) 
	li $s1,0  
	jal Subprogram2
	lb $s0, ($t0) 
	beq $s0, 0, jump 
	beq $s0, 10, jump  
	beq $s0,44, invalid_loop 
	li $t2,0 
	j beginning


Subprogram2:
	#checks how many characters are left to convert
	beq $t3,0,done  
	addi $t3,$t3,-1 
	lb $s0, ($t4) 
	addi $t4,$t4,1	
	j Subprogram3 
	

continue:
	#stores the converted character
	sw $s1,0($sp)	
	j Subprogram2
	
Subprogram3:
	#stores the amount of characters left to use as an exponent
	move $t8, $t3	
	li $t9, 1	
	ble $s0, 57, number 
	ble $s0, 86, uppercase
	ble $s0, 118, lowercase

number:
	#converts the bits to intergers
	sub $s0, $s0, 48	 
	beq $t3, 0, combine	
	li $t9, 32		
	j exponent
	
uppercase:
	#converts the bits to uppercase letters
	sub $s0, $s0, 55 
	beq $t3, 0, combine 
	li $t9, 32
	j exponent
	
lowercase:
	#converts the bits to lowercase letters
	sub $s0, $s0, 87 
	beq $t3, 0, combine 
	li $t9, 32
	j exponent
exponent:
	#raises the base to a certain exponent 
	ble $t8, 1, combine	
	mul $t9, $t9, 32 	
	addi $t8, $t8, -1	
	j exponent	

combine:
	#adds the values together
	mul $s2, $t9, $s0	
	add $s1,$s1,$s2		 
	j continue

done: 
	#jumps back to substring
	jr $ra	

print:
	#prints out the values
	mul $t1,$t1,4 
	add $sp, $sp $t1 

finish:	
	#ends the program
	sub $t1, $t1,4	
	sub $sp,$sp,4 	
	lw $s7, 0($sp)	
	beq $s7,-1,invalid_print 
	li $v0, 1
	lw $a0, 0($sp) 
	syscall
left:	
	#checks if there are any characters left 
	beq $t1, 0,exit 
	li $v0, 4
	la $a0, commas 
	syscall
	j finish
