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
 
