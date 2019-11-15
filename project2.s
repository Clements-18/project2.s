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
