.data 
 NoInputMessage: .asciiz "Please Input A Number."
 LongMessage: .asciiz "Input is too long."
 ErrorMessage: .asciiz "Invalid base-35 number."
 Input: .space 1000
 .text
 
 
main:
 li $v0, 8 
 la $a0, Input 
 li $a1, 1000
 
 
 syscall 
 addi $sp, $sp, -8
 sw $a0, 4($sp)
 sw $ra, 0($sp) 
 
 jal Input_loop
 lw $t8, 0($sp) 
 addi $sp, $sp, 4 
 addi $sp, $sp, -8 
 sw $t8, 4($sp) 
 sw $ra, 0($sp)
 jal Sum
 j end
 
 
 Input_loop:
 addi $sp, $sp, -4
 sw $ra, 0($sp) 
 jal RemoveLeadingSp
 jal removespaceafter
 jal ckLength
 lw $ra, 4($sp) 
 lw $t8, 0($sp)
 addi $sp, $sp, 8 
 addi $sp, $sp, -4
 sw $t8, 0($sp) 
 jr $ra 
 
 RemoveLeadingSp:
 li $t8, 32 
 lw $a0, 8($sp)
 
 
 RemoveFrontSpace: 
 lb $t6, 0($a0) 
 beq $t8, $t6, removefirstcharacter 
 move $t6, $a0 
 jr $ra


removefirstcharacter:
 addi $a0, $a0, 1
 j RemoveFrontSpace
 
 
removespaceafter:
 la $t2, Input
 sub $t2, $t6, $t2 
 li $t1, 0 
 li $t8, 0 
 
 
removespaceafter_loop:
 add $t4, $t2, $t8
 addi $t4, $t4, -1000
 beqz $t4, end_removespaceafter 
 add $t4, $t8, $a0
 lb $t4, 0($t4) 
 beq $t4, $zero, end_removespaceafter 
 addi $t4, $t4, -10
 beqz $t4, end_removespaceafter 
 addi $t4, $t4, -22
 bnez $t4, updatelastIndex 
 
 
RM_spaceAfterIncrement:
 addi $t8, $t8, 1 
 j removespaceafter_loop
 
 
updatelastIndex:
 move $t1, $t8 
 j RM_spaceAfterIncrement
 
 
end_removespaceafter:
 add $t4, $zero, $a0 
 add $t4, $t4, $t1 
 addi $t4, $t4, 1 
 sb $zero, 0($t4) 
 jr $ra
 
 
ckLength:
 li $t0, 0
 add $a0, $t6, $zero
 lb $t2, 0($a0)
 addi $t2, $t2, -10 
 beq $t2, $zero, null_error 
 
ckLength_Loop:
 lb $t2, 0($a0)
 or $t1, $t2, $t0
 beq $t1, $zero, null_error
 beq $t2, $zero, strFin
 addi $a0, $a0, 1
 addi $t0, $t0, 1
 j ckLength_Loop


strFin:
 slti $t5, $t0, 5
 beq $t5, $zero, length_error
 bne $t5, $zero, check_String
null_error:
 li $v0, 4
 la $a0, NoInputMessage
 syscall
 j end

length_error:
 li $v0, 4
 la $a0, LongMessage
 syscall
 j end

check_String:
 move $a0, $t6 

check_StringLoop:
 li $v0, 11
 lb $t3, 0($a0)
 move $t8, $a0
 move $a0, $t3
 move $a0, $t8
 li $t8, 10 
 beq $t3, $zero, base_converter
 slti $t4, $t3, 48 
 bne $t4, $zero, base_error
 slti $t4, $t3, 58 
 bne $t4, $zero, Increment
 slti $t4, $t3, 65 
 bne $t4, $zero, base_error 
 slti $t4, $t3, 90 
 bne $t4, $zero, Increment
 slti $t4, $t3, 97 
 bne $t4, $zero, base_error 
 slti $t4, $t3, 122 
 bne $t4, $zero, Increment
 bgt $t3, 117, base_error 
 li $t8, 10 
 beq $t3, $t8, base_converter 

Increment:
 addi $a0, $a0, 1
 j check_StringLoop

base_error:
 li $v0, 4
 la $a0, ErrorMessage
 syscall
 j end

base_converter:
 move $a0, $t6 
 li $t2, 10
 li $t8, 0 
 add $s7, $s7, $t0
 addi $s7, $s7, -1 
 li $s2, 3
 li $s5, 2
 li $s6, 1
 li $s1, 0


convertString: 
 lb $s5, 0($a0)
 beqz $s5, Sum	
 beq $s5, $t2, Sum 
 slti $t4, $s5, 58 
 bne $t4, $zero, zero_to_nine
 slti $t4, $s5, 90 
 bne $t4, $zero, A_to_Y
 slti $t4, $s5, 122 
 bne $t4, $zero, a_to_Y

zero_to_nine:
 addi $s5, $s5, -48
 j next_step
A_to_Y:
 addi $s5, $s5, -55
 j next_step
a_to_Y:
 addi $s5, $s5, -87

next_step:
 beq $s7, $s2, Base_raised_toThree
 beq $s7, $s3, Base_raised_toTwo
 beq $s7, $s6, BasesOneToOne
 beq $s7, $s1, Base_raised_toZero
Base_raised_toThree:
 li $s4, 29791
 mult $s5, $s4
 mflo $s0
 add $t8, $t8, $s0
 addi $s7, $s7, -1
 addi $a0, $a0, 1
 j convertString

Base_raised_toTwo:
 li $s4, 961
 mult $s5, $s4
 mflo $s0
 add $t8, $t8, $s0
 addi $s7, $s7, -1
 addi $a0, $a0, 1
 j convertString

BasesOneToOne:
 li $s4, 31
 mult $s5, $s4
 mflo $s0
 add $t8, $t8, $s0
 addi $s7, $s7, -1
 addi $a0, $a0, 1
 j convertString

Base_raised_toZero:
 li $s4, 1
 mult $s5, $s4
 mflo $s0
 add $t8, $t8, $s0

Obtained_value:
 addi $sp, $sp, -4
 sw $t8, 0($sp) 
 jr $ra 

Sum:
 li $v0, 1
 lw $a0, 4($sp) 
 syscall
 jr $ra


end:
 li $v0,10 
 syscall
