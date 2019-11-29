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
