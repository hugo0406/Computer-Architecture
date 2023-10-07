.data 
    test1:    .dword 0x1122334455007788
    str1:     .string "The Leftmost 0-byte of"
    str2:     .string " is " 
.text
main:
    la   t0,test1             #a1_a0 =test1
    lw   a0,0(t0)
    lw   a1,4(t0)
    jal  ra,zbytel
    mv   t0,a0 
    
    la   a0,str1
    li   a7,4
    ecall
    
    la   a0,test1
    li   a7,3
    ecall
    
    la   a0,str2
    li   a7,4
    ecall
    
    mv   a0,t0
    li   a7,1
    ecall

    li   a7, 10   
    ecall
    
            
zbytel:
    addi  sp,sp,-12
    sw    ra,0(sp)
    sw    a0,4,(sp)
    sw    a1,8(sp)               
    mv    s0,a0                #s0:test1_half_right  
    mv    s1,a1                #s1:test1_half_left
    li    t0,0x7f7f7f7f
    and   s2,s0,t0            # s0 &  0x7f7f7f7f
    add   s2,s2,t0
    or    s2,s2,s0
    or    s2,s2,t0
    xori  s2,s2,-1          
    
    and  s3,s1,t0           #s2:y_half_right
    add  s3,s3,t0           #s3:y_half_left 
    or   s3,s3,s0
    or    s3,s3,t0
    xori  s3,s3,-1
    mv    a0,s2
    mv    a1,s3
    jal   clz
    lw    ra,0(sp)
    srli  a0,a0,3
    jr   ra
 
clz:
    andi  t1,a1,0x1
    srli  s4,a1,1
    srli  s5,a0,1
    slli  t1,t1,31
    or    s5,s5,t1
    or    a1,s4,a1
    or    a0,s5,a0
    
    andi  t1,a1,0x3
    srli  s4,a1,2
    srli  s5,a0,2
    slli  t1,t1,30
    or    s5,s5,t1
    or    a1,s4,a1
    or    a0,s5,a0
    

    andi  t1,a1,0xf
    srli  s4,a1,4
    srli  s5,a0,4
    slli  t1,t1,28
    or    s5,s5,t1
    or    a1,s4,a1
    or    a0,s5,a0
    

    andi  t1,a1,0xff
    srli  s4,a1,8
    srli  s5,a0,8
    slli  t1,t1,24
    or    s5,s5,t1
    or    a1,s4,a1
    or    a0,s5,a0
   
    li    t1,0xffff
    and   t1,a1,t1
    srli  s4,a1,16
    srli  s5,a0,16
    slli  t1,t1,16
    or    s5,s5,t1
    or    a1,s4,a1
    or    a0,s5,a0
    
    mv    s5,a1
    and   s4,a1,x0
    or    a1,s4,a1
    or    a0,s5,a0
    
    andi  t1,a1,0x1
    srli  s4,a1,1
    srli  s5,a0,1
    slli  t1,t1,31
    or    s5,s5,t1
    li    t1,0x55555555
    and   s4,s4,t1
    and   s5,s5,t1
    sub   a1,a1,s4
    sub   a0,a0,s5
    
    andi  t1,a1,0x3
    srli  s4,a1,2
    srli  s5,a0,2
    slli  t1,t1,30
    or    s5,s5,t1
    li    t1,0x33333333
    and   s4,s4,t1           #s4=>a1
    and   s5,s5,t1           #s5=>a0
    and   a1,a1,t1
    and   a0,a0,t1
    add   a1,a1,s4
    add   a0,a0,s5
    
    
    andi  t1,a1,0xf
    srli  s4,a1,4
    srli  s5,a0,4
    slli  t1,t1,28
    or    s5,s5,t1
    add   s4,s4,a1
    add   s5,s5,a0
    li    t1,0x0f0f0f0f
    and   a1,s4,t1
    and   a0,s5,t1
    
    andi  t1,a1,0xff
    srli  s4,a1,8
    srli  s5,a0,8
    slli  t1,t1,24
    or    s5,s5,t1
    add   a1,a1,s4
    add   a0,a0,s5
    
    li    t1,0xffff
    and   t1,t1,a1
    srli  s4,a1,16
    srli  s5,a0,16
    slli  t1,t1,16
    or    s5,s5,t1
    add   a1,a1,s4
    add   a0,a0,s5
    
    mv    s5,a1
    and   s4,a1,x0
    add   a1,a1,s4
    add   a0,a0,s5
    
    andi  a0,a0,0x7f
    li    t1,64
    sub   a0,t1,a0
    jr    ra

































    





















    