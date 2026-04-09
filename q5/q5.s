.section .rodata 
f_name: .asciz "input.txt"
yes_str: .asciz "Yes" 
no_str: .asciz "No"
fmt_n: .asciz "\n"

.text
.globl main

main:
addi sp, sp, -96
sd ra, 0(sp)
sd s0, 16(sp)
sd s1, 32(sp)
sd s2, 48(sp)
sd s3, 64(sp)
sd s4, 80(sp)


# equivalent c code fp=open("input.txt", "r");

la a0, f_name     # name of file
li a1, 0          # mode of opening file : read only(0)
call open
add s0, a0, x0    # s0 = file pointer

# equivalent pseudo code char x= fseek(fp,0,SEEK_END(2)/SEEK_SET(0)/SEEK_CUR(1))

add a0, s0, x0    # fp
addi a1, x0, 0    # offset = 0 (offset=-1 would give n-1)
addi a2, x0, 2    # SEEK_END 
call fseek        # moves the file pointer to the eof
call ftell        # returns the index where fp is in a0 
add s1, a0, x0    # s1=file size(s1=n) 
srli s1, s1, 1    # s1=n//2

li s2, 0 # s2 is the iterator 

LOOP_CHECK:
beq s2, s1, IS_palindrome

# code main logic 
add a0, s0, x0 # fp
add a1, s2, x0 # offset
add a2, x0, x0 # seek_set
call fseek # moves the fp to the index i
call fgetc # gets the charecter stored at index i and places it in a0 
add s3, a0, x0 # s3=str[i]

add a0, s0, x0  # fp
# offset n-1 offset=-1, n-2 offset=-2 , n-i-1 offset= -(i+1)
sub a1, x0, s2  # offset -i
addi a1, a1, -1 # offset -i-1
addi a2, x0, 2  # seek_end
call fseek
call fgetc
add s4, a0, x0 # s4=str[n-1-i]

bne s3, s4, NOT_palindrome

# code main logic ends 

addi s2, s2, 1
beq x0, x0, LOOP_CHECK


IS_palindrome:
la a0, yes_str
call printf
beq x0, x0, END

NOT_palindrome:
la a0, no_str
call printf
beq x0, x0, END

END:
la a0, fmt_n
call printf

# closing the file c equivalent  fclose(fp)
add a0, s0, x0 
call fclose

ld s4, 80(sp)
ld s3, 64(sp)
ld s2, 48(sp)
ld s1, 32(sp)
ld s0, 16(sp)
ld ra, 0(sp) 
addi sp, sp, 96

add a0, x0, x0
ret

# check if input.txt ends with \n, if yes do addi s1, s1, -1 before halving