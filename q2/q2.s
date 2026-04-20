# start of code 

.section .rodata 
fmt: .asciz "%lld "
fmt_n: .asciz "\n"
fmt_last: .asciz "%lld"

.text
.globl main

main: 

# return address storage on stack 

addi sp, sp, -64
sd ra, 48(sp)
sd s0, 40(sp)
sd s1, 32(sp)
sd s2, 24(sp)
sd s3, 16(sp)
sd s4, 8(sp)
sd s5, 0(sp)

# my main code 

addi a0, a0, -1 # number of elements in array
addi a1, a1, 8 # base address of array 


add s0, a0, x0 # s0 now has number of elements 
add s1, a1, x0 # s1 now has base address of array

# Conversion of string args to integer 

add s2, x0, x0  # iterator s2

LOOP: 
beq s2, s0, EXIT_1

add s3, s2, x0 # converting string to integer
slli s3, s3, 3
add s3, s3, s1
ld a0, 0(s3)

call atoll
sd a0 , 0(s3)


addi s2, s2, 1
beq x0, x0, LOOP

EXIT_1:

# stack pointer s2
addi s2, x0, -1

# making a stack array 
add t0, s0, x0 # t0=n
slli t0, t0, 3 # t0=n*8

add a0, t0, x0
call malloc 

add s3, a0, x0 # s3 has address of stack array 

# making a result array

add t0, s0, x0 # t0=n
slli t0, t0, 3 # t0=n*8

add a0, t0, x0
call malloc 
add s4, a0, x0
# s4 has the address of the result array

# main logic 
addi t0, s0, -1 # iterator starting from n-1
addi s5, x0, -1 

LOOP_LOGIC:

beq t0, s5, EXIT_2 

# current value arr[i]
add t4, t0, x0
slli t4, t4, 3
add t4, t4, s1
ld t4, 0(t4)

# final output storage address in result result[i]
addi t1, t0, 0
slli t1, t1, 3
add t1, t1, s4 


INNER_LOOP: 
  beq s2, s5, no_output
  # stack top value in t3
  add t3, s2, x0
  slli t3, t3, 3
  add t3, t3, s3 # stack[top], index
  ld t3, 0(t3) 
  slli t5, t3, 3 
  add t5, t5, s1 # arr [stack[top]]
  ld t5, 0(t5)

  bgt t5, t4, normal_output # next greater element found

  addi s2, s2, -1 # pop from stack 
  beq x0, x0, INNER_LOOP

no_output: 
  addi t2, x0, -1  # storing -1 in result[i]
  sd t2, 0(t1)
  beq x0, x0, PUSH
  
normal_output: 
   add t2, t3, x0 # storing arr[stack[top]]>arr[i] in result[i]
   sd t2, 0(t1)
   beq x0, x0, PUSH

PUSH:
   addi s2, s2, 1 # PUSHING INDEX ONTO STACK
   add t1, s2, x0
   slli t1, t1, 3
   add t1, t1, s3 
   sd t0, 0(t1)


addi t0, t0, -1
beq x0, x0, LOOP_LOGIC 

EXIT_2:
# printing the final answer
add s2, x0, x0 # iterator 
add s5, s0, x0 # n

PRINT_LOOP:
beq s2, s5, EXIT_3

addi t6, s5, -1
beq s2, t6, LAST_PRINT


la a0, fmt 
add t1, s2, x0 # getting value result[i]
slli t1, t1, 3
add t1, t1, s4
ld a1, 0(t1)
call printf

addi s2, s2, 1 
beq x0, x0, PRINT_LOOP

LAST_PRINT:

la a0, fmt_last
add t1, s2, x0 # getting value result[i]
slli t1, t1, 3
add t1, t1, s4
ld a1, 0(t1)
call printf
beq x0, x0, EXIT_3


EXIT_3:
la a0, fmt_n  # print nextline
call printf


ld s5, 0(sp)
ld s4, 8(sp)
ld s3, 16(sp)
ld s2, 24(sp)
ld s1, 32(sp)
ld s0, 40(sp)
ld ra, 48(sp)
addi sp, sp, 64

add a0, x0, x0

ret # return 0 after function ends

