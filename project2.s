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
