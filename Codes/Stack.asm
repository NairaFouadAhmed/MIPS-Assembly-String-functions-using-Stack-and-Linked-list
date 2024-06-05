#array
#push pop isempty isfull peek
#array max_size top
# S0 --> top of array
#push ,pop and peek use V0
#t1 hold temp address in pop to call the peek 
#t3  hold temp address in reverse to call pop and peek
#isempty and isfull us t0
.data 
    array:  .byte  100  #(up to 10 items) * (1 bytes)
    string1: .space 64 
    string2: .space 64
    correct:.asciiz "The word is a palindrome"
    error:.asciiz "The word is not a palindrome"
    newline:.asciiz "\n"
    options:.asciiz "Please type in one of the number below and press enter: \n1 - Exit program \n2 - IsFull \n3 - IsEmpty \n4 - Peek \n5 - push \n6 - Pop \n7 - Convert the word to lowercase\n8 - Convert the word to Uppercase \n9 - Reverse the word \n10 - Check the word is palindrome \n11 - Reset\n"
    sentince : .asciiz "Please enter the word\n"
    sentince2 : .asciiz "THANK YOU:)\n"
    sentince3 : .asciiz "Not empty\n"
    sentince4 : .asciiz "Stack is empty\n"
    sentince5 : .asciiz "Stack is full\n"
    sentince6 : .asciiz "Stack still has free space\n"
    sentince7 : .asciiz "Please insert a character\n"
    peekvalue : .asciiz "The peek value in the stack is \n"
    resetmsg : .asciiz "Stack reseted\n"
    sentincecheck : .asciiz "Please enter the word you want to check\n"
.text
main:
    addi $s0,$zero,0 
    addi $t2,$zero,1
    
    loop_display:
    li $v0, 4               # syscall code for print string
    la $a0, options         # load address of the prompt string
    syscall
    li $v0, 5               # syscall code for read integer
    syscall
    move $t0, $v0
    beq $t0, 1, exit
    beq $t0, 2, doisfull
    beq $t0, 3, doisempty 
    beq $t0, 4, dopeek
    beq $t0, 5, dopush  
    beq $t0, 6, dopop
    beq $t0, 7, dotolower
    beq $t0, 8, dotoUpper
    beq $t0, 9, doreverse
    beq $t0, 10, docheck_palindrome
    beq $t0, 11, doreset
    j loop_display 
    
    dotolower:
    li $v0, 4               # syscall code for print string
    la $a0, sentince        # load address of the prompt string
    syscall
    li $v0, 8               # Load syscall number for reading a string
    la $a0, string1         # Load address of the buffer to store the string
    li $a1, 64              # Maximum number of characters to read (adjust as needed)
    syscall
    jal tolower 
    jal pprint
    j loop_display
    
    dotoUpper:
    li $v0, 4               # syscall code for print string
    la $a0, sentince        # load address of the prompt string
    syscall
    li $v0, 8               # Load syscall number for reading a string
    la $a0, string1         # Load address of the buffer to store the string
    li $a1, 64              # Maximum number of characters to read (adjust as needed)
    syscall
    jal toUpper
    jal pprint 
    j loop_display
    
    doisfull:
    jal isfull
    beq $t0 ,$zero ,fady
    li $v0, 4              # syscall code for print string
    la $a0, sentince5      # load address of the prompt string
    syscall
    beq $t0, $t2 ,loop_display
    fady:
    li $v0, 4              # syscall code for print string
    la $a0, sentince6      # load address of the prompt string
    syscall
    b loop_display
    
    doisempty:
    jal isempty
    beq $t0 ,$zero ,mesfady
    li $v0, 4              # syscall code for print string
    la $a0, sentince4      # load address of the prompt string
    syscall
    beq $t0, $t2 ,loop_display
    mesfady:
    li $v0, 4              # syscall code for print string
    la $a0, sentince3      # load address of the prompt string
    syscall
    b loop_display
    
    dopush:
    li $v0, 4              # syscall code for print string
    la $a0, sentince7      # load address of the prompt string
    syscall
    li $v0,12
    syscall
    jal push
    li $v0,4
    la $a0, newline
    syscall
    b loop_display
    
    dopop:
    li $v0,4
    la $a0, newline
    syscall
    jal pop
    move $a0,$v0
    li $v0,11
    syscall
    li $v0,4
    la $a0, newline
    syscall
    b loop_display
    
    dopeek:
    li $v0,4
    la $a0, peekvalue
    syscall
    jal peek
    move $a0,$v0
    li $v0,11
    syscall
    li $v0,4
    la $a0, newline
    syscall
    b loop_display
    
    doreset:
    li $v0,4
    la $a0, resetmsg
    syscall
    jal rst
    b loop_display
    
    doreverse:
    li $v0, 4               # syscall code for print string
    la $a0, sentince        # load address of the prompt string
    syscall
    li $v0, 8               # Load syscall number for reading a string
    la $a0, string1         # Load address of the buffer to store the string
    li $a1, 64              # Maximum number of characters to read (adjust as needed)
    syscall
    jal reverse 
    li $v0,4
    la $a0,string2
    syscall
    li $v0,4
    la $a0, newline
    syscall
    b loop_display
    
    docheck_palindrome:
    li $v0, 4           # syscall code for print string
    la $a0, sentincecheck      # load address of the prompt string
    syscall
    li $v0, 8               # Load syscall number for reading a string
    la $a0, string1          # Load address of the buffer to store the string
    li $a1, 64              # Maximum number of characters to read (adjust as needed)
    syscall
    jal check_palindrome 
    li $v0,4
    la $a0, newline
    syscall
    b loop_display
    
    exit:
    li $v0, 4              # syscall code for print string
    la $a0, sentince2      # load address of the prompt string
    syscall
    li $v0, 10 
    syscall
    
check_palindrome: 
    move $s3 ,$ra
    jal tolower
    jal reverse    
    move $ra ,$s3
    move $t6,$zero
    loop73:
        lb $s5,string1($t6)
        lb $s6,string2($t6)
        beq $s5,'\n',true
        bne  $s6,$s5,false
        add $t6,$t6,$t2
        
        j loop73


true:
    li $v0,4
    la $a0,correct
    syscall
    j jump

false:
    li $v0,4
    la $a0,error
    syscall
    j jump

tolower:
    
    add $t5,$zero,$zero
        loopxd:
                lb $t6,string1($t5)
                beq $t6,'\n',jump
                ori $t6,$t6,32
                sb $t6,string1($t5)
                addi $t5,$t5,1
                j loopxd

toUpper:
    add $t5,$zero,$zero
        loopx:
                lb $t7,string1($t5)
                beq $t7,'\n',jump
                andi $t7,$t7,223
                sb $t7,string1($t5)
                addi $t5,$t5,1
                j loopx

pprint:
	li $v0,4
	la $a0,string1
	syscall
	li $v0,4
	la $a0,newline
	syscall    
j jump	             
                
jump:jr $ra                

push:
    add $s0,$s0,$t2
    sb $v0,array($s0)
    jr $ra

pop:
    add $t1,$ra,$zero
    jal peek
    add $ra,$t1,$zero
    addi $s0,$s0,-1
    jr $ra



peek:
    lb $v0,array($s0)
    jr $ra


isempty:
    add $t0,$zero,$zero
    bne $s0,$zero,jump
    addi $t0,$zero,1
    j jump

isfull:
    add $t0,$zero,$zero
    bne $s0,100,jump
    addi $t0,$zero,1
    j jump

rst:
    move $s0,$zero
    jr $ra


reverse:
    
    move $t3,$ra
    move $t6,$zero
    
    loop1:
        lb $s6,string1($t6)
        beq $s6,'\n',print_2
        move $v0,$s6
        jal push
        addi $t6,$t6,1
        j loop1
    
print_2:
    move $t6,$zero
    loop2:
        jal isempty
        beq $t0,1,goto_jump
        jal pop
        sb $v0,string2($t6)
        addi $t6,$t6,1
    j loop2
    

goto_jump:move $ra,$t3
    sb $zero,string2($t6)
    jr $ra