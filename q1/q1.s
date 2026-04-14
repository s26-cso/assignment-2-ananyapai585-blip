# BST functions 

.section .rodata
.text

.globl make_node 
.globl insert 
.globl get
.globl getAtMost


# function definition

# FUNCTION 1 
make_node: # val is in a0

addi sp, sp, -16
sd ra, 8(sp)
sd s10, 0(sp)


add s10, a0, x0  # s10=val 

li a0, 24 # val needs 8 bytes, left and right pointer need 8 bytes each 
call malloc # node address is in a0

sw s10, 0(a0) # node value is val 

sd x0, 8(a0) # left and right pointers are NULL;
sd x0, 16(a0)

ld s10, 0(sp)
ld ra, 8(sp)
addi sp, sp, 16

ret # node address is returned 





# FUNCTION 2: inserting a node, iterative 
insert: # root address is in a0, val is in a1

addi sp, sp, -48
sd ra, 40(sp)
sd a0, 32(sp)
sd s0, 24(sp)
sd s1, 16(sp)
sd s2, 8(sp)
sd s3, 0(sp)


add s0, a0, x0 # s0 has curr root address 
add s1, a1, x0 # s1 has value to be inserted 

add s2, a0, x0 # s2 is prev node 

loop_1: # finding the right place to insert
    beq s0, x0, main_step # (if curr==NULL)

    lw s3, 0(s0) # s3=curr->value

    blt s1, s3 , left # val < curr->val move left
    bgt s1, s3 , right # val > curr->val move right

left:
add s2, s0, x0 # prev=curr
ld s0, 8(s0) # curr=curr->left
beq x0, x0, loop_1

right:
add s2, s0, x0 # prev=curr
ld s0, 16(s0) # curr=curr->right
beq x0, x0, loop_1


main_step: # either prev->right=node or prev->left=node
add a0, s1, x0 
call make_node

beq s2, x0, root_make # root itself is NULL

lw s3, 0(s2) # s3 = prev->val
blt s1, s3, insert_left
bgt s1, s3, insert_right 

insert_left: #prev->left=node
sd a0, 8(s2)
beq x0, x0, end_1 

insert_right: #prev->right=node
sd a0, 16(s2)
beq x0, x0, end_1 

root_make:
# this directly returns the new root address in a0, the one on stack is of no use if og root=NULL
ld s3, 0(sp)
ld s2, 8(sp)
ld s1, 16(sp)
ld s0, 24(sp)
ld ra, 40(sp)
addi sp, sp, 48
ret 

end_1:
ld s3, 0(sp)
ld s2, 8(sp)
ld s1, 16(sp)
ld s0, 24(sp)
ld a0, 32(sp)
ld ra, 40(sp)
addi sp, sp, 48
ret # returns a0 which now has root address 





# FUNCTION 3: getting a node, iterative 
get:

addi sp, sp, -32
sd ra, 24(sp)
sd s0, 16(sp)
sd s1, 8(sp)
sd s2, 0(sp)

add s0, a0, x0 # s0=curr root address
add s1, x0 ,x0 # our return value which is currently NULL 

add t0, a1, x0 # t0 = int val 

loop_2:
    beq s0, x0, end_2 # if s0==NULL 

    lw s2, 0(s0) # curr->val 
   
    beq t0, s2, equal # val=curr->val
    blt t0, s2, move_left # val < curr->val , curr=curr->left 
    bgt t0, s2, move_right # val > curr->val, curr=curr->right 

equal:
add s1, s0, x0  # s1 has the required node address 
beq x0, x0, end_2

move_left:
ld s0, 8(s0) # curr=curr->left
beq x0, x0, loop_2

move_right:
ld s0, 16(s0) # curr=curr->right
beq x0, x0, loop_2

end_2:
    add a0, s1, x0 # return found node address 
    
    ld s2, 0(sp)
    ld s1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32

    ret 





# FUNCTION 4: get max value <= given value , iterative
getAtMost:

addi sp, sp, -48
sd ra, 32(sp)
sd s0, 24(sp)
sd s1, 16(sp)
sd s2, 8(sp)
sd s3, 0(sp)

add s1, a0, x0 # s1=val
add s0, a1, x0 # s0= curr root address

addi s3, x0, -1 # our return value which is currently -1 

loop_3:
beq s0, x0, end_3

lw s2, 0(s0) # curr->val 

beq s1, s2, exact_val #val = curr->val
blt s1, s2, find_left  #val < curr->val

# if val > curr->val 
add s3, s2, x0 # updating final answer since it satisfies condition and is the max most val till now
ld s0, 16(s0) # curr = curr->right
beq x0, x0, loop_3

find_left:
ld s0, 8(s0) # curr = curr->left 
beq x0, x0, loop_3

exact_val:
add s3, s2, x0
beq x0, x0, end_3

end_3:

add a0, s3, x0 
    
    ld s3, 0(sp)
    ld s2, 8(sp)
    ld s1, 16(sp)
    ld s0, 24(sp)
    ld ra, 32(sp)
    addi sp, sp, 48


ret 

