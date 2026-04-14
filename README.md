[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/d5nOy1eX)


APPROACH FOR Q3 PART-A:

TREASURE HUNTING FOR THE RIGHT INPUT 

STEP 0: trial and error, for the purpose of testing I gave input "HELLO" and "csoisnice"
and was met with the output "Sorry, try again." 

STEP 1: strings 
it gave me 100 or so printable strings and after using grep, both strcmp and strncmp was 
found, which means the final string obtained is getting compared with a given string 

STEP 2: objdump -d | grep -A 35 '<main>'
This helps me to get the part of code that starts with the main and prints 35 lines 
after it which is the assembly code equivalent of the source code. 

from this i come to know where the address of the input string is stored :

000000000001062a <main>:
   1062a:       1141                    addi    sp,sp,-16
   1062c:       e406                    sd      ra,8(sp)
   1062e:       e022                    sd      s0,0(sp)
   10630:       840a                    mv      s0,sp
   10632:       7139                    addi    sp,sp,-64
   10634:       00074517                auipc   a0,0x74
   10638:       94453503                ld      a0,-1724(a0) # 83f78 <_GLOBAL_OFFSET_TABLE_+0x8>
   1063c:       858a                    mv      a1,sp
   1063e:       297040ef                jal     150d4 <__scanf>

   it is stored at address stored in sp (s.c eq : scanf("%s",sp));

The next few lines:
 10642:       850a                    mv      a0,sp
   10644:       00074597                auipc   a1,0x74
   10648:       93c5b583                ld      a1,-1732(a1) # 83f80 <_GLOBAL_OFFSET_TABLE_+0x10>
   1064c:       5f7170ef                jal     28442 <strcmp>
   10650:       e901                    bnez    a0,10660 <.fail>

eq sc strcmp(a0,a1); a0 contains sp, which is the input string, which means 
a1 has the secret password 

next to it the address at which the address of the secret string has been given is what I am assuming, since 
since a1 is actually a pointer to the actual string. 


STEP 3: objdump -s : this helps me find what all is being stored in sections
because strings are generally stored as is in the .section .rodata or .section .data or 
smtg similar.

After a bit of scrolling I found :

Contents of section .got:
 83f60 ffffffff ffffffff 00000000 00000000  ................
 83f70 00000000 00000000 8ce00500 00000000  ................
 83f80 91e00500 00000000 bee00500 00000000  ................

91e00500 00000000 bee00500 00000000: is the address where string is stored 
we shall just find what is stored there using objdump -s but | less so that I can 
scroll and find the data stored at the address 

5e091 could not be found so I tried out with nearby addresses. 
5e090 00504e59 674a6868 786a767a 6158584b  .PNYgJhhxjvzaXXK
 5e0a0 424d6a65 70513253 67447a31 6170686f  BMjepQ2SgDz1apho
 5e0b0 6e702b63 48337566 6f2b5759 3d00596f  np+cH3ufo+WY=.Yo

5e091 is justfied since the first byte is 
a null byte

00 is null byte and hence '.' should not be included. 
so if I treat 00 as '\0' the string is exactly 
PNYgJhhxjvzaXXKBMjepQ2SgDz1aphonp+cH3ufo+WY=


APPROACH FOR Q3 - PART B


TREASURE HUNTING FOR RIGHT INPUT PART-2 

follow all steps of q 3 part A
  Q/4j9if=dfiw3t4FG. // this does not pass, question expects smtg else

We have to somehow make the output run 'You have passed'
So using objdump -d 


00000000000104c8 <main>:
   104c8:       1141                    addi    sp,sp,-16
   104ca:       e406                    sd      ra,8(sp)
   104cc:       e022                    sd      s0,0(sp)
   104ce:       840a                    mv      s0,sp
   104d0:       7131                    addi    sp,sp,-192
   104d2:       850a                    mv      a0,sp
   104d4:       00004097                auipc   ra,0x4
   104d8:       50e080e7                jalr    1294(ra) # 149e2 <_IO_gets>
   104dc:       850a                    mv      a0,sp
   104de:       00042597                auipc   a1,0x42
   104e2:       7d258593                addi    a1,a1,2002 # 52cb0 <secret>
   104e6:       e911                    bnez    a0,104fa <.fail>

00000000000104e8 <.pass>:
   104e8:       00042517                auipc   a0,0x42
   104ec:       7da50513                addi    a0,a0,2010 # 52cc2 <passed>
   104f0:       00001097                auipc   ra,0x1
   104f4:       93c080e7                jalr    -1732(ra) # 10e2c <_IO_printf>
   104f8:       a809                    j       1050a <.end>

00000000000104fa <.fail>:
   104fa:       00042517                auipc   a0,0x42
   104fe:       7da50513                addi    a0,a0,2010 # 52cd4 <fail>
   10502:       00001097                auipc   ra,0x1
   10506:       92a080e7                jalr    -1750(ra) # 10e2c <_IO_printf>

000000000001050a <.end>:
   1050a:       6129                    addi    sp,sp,192
   1050c:       6402                    ld      s0,0(sp)
   1050e:       60a2                    ld      ra,8(sp)
   10510:       0141                    addi    sp,sp,16
   10512:       4501                    li      a0,0
   10514:       8082                    ret

first we store ra which takes 8 bytes 
then we store s0 which takes another 8 bytes 
then we give 192 bytes of space to the string 

if we enter a input more than 192 bytes, it will start overflowing deeper

200 bytes the s0 info on stack gets wiped off(thats why the sp to it in the beginning
 has been preserved in s0 )

208 bytes and now the ra becomes the last 8 bytes of info , so we will end up going to 
that address instead.
Since we want to make it pass, our goal is to put the last 8 bytes that is exactly equal 
to the address where pass is executed. 

so 200 bytes of some data(string of 200 characters) and 8 bytes=pass function address
pass address :  00 00 00 00 00 01 04 e8 

obviously from pass it will execute fail first because the strcmp fails 

Now when jumping to ra address, since the ra address contains the 8 bytes(address of pass)
we jump to pass instead and that get executed. 


