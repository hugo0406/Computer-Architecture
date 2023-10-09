.data 
    test1:    .dword 0x1122334455007700
    str1:     .string "The Leftmost 0-byte is "

.text
main:
    la   t0,test1             #a1a0 =test1
    lw   a0,0(t0)
    lw   a1,4(t0)
    jal  ra,zbytel
    mv   t0,a0 
    
    la   a0,str1
    li   a7,4
    ecall
    
        
    mv   a0,t0
    li   a7,1
    ecall

    li   a7, 10   
    ecall
    
            
zbytel:
    addi  sp,sp,-4             #push
    sw    ra,0(sp)              
    mv    s0,a0                #s0:test1_half_right  
    mv    s1,a1                #s1:test1_half_left
    
    #y = (x & 0x7F7F7F7F7F7F7F7F)+ 0x7F7F7F7F7F7F7F7F
    li    t0,0x7f7f7f7f
    and   s2,s0,t0          
    add   s2,s2,t0
    
    #y = ~(y | x |0x7F7F7F7F7F7F7F7F)
    or    s2,s2,s0
    or    s2,s2,t0
    xori  s2,s2,-1          #s2:y_half_right
    
    and  s3,s1,t0       
    add  s3,s3,t0        
    or   s3,s3,s0
    or    s3,s3,t0
    xori  s3,s3,-1          #s3:y_half_left
    
    mv    a0,s2          
    mv    a1,s3                
    jal   clz
    lw    ra,0(sp)
    addi  sp,sp,4           #pop 
    srli  a0,a0,3           #clz(y)>>3
    jr   ra
 
clz:
    #x |= (x >> 1)
    andi  t1,a1,0x1
    srli  s4,a1,1
    srli  s5,a0,1
    slli  t1,t1,31
    or    s5,s5,t1
    or    a1,s4,a1
    or    a0,s5,a0
    
    #x |= (x >> 2)
    andi  t1,a1,0x3
    srli  s4,a1,2
    srli  s5,a0,2
    slli  t1,t1,30
    or    s5,s5,t1
    or    a1,s4,a1
    or    a0,s5,a0
    
    #x |= (x >> 4)
    andi  t1,a1,0xf
    srli  s4,a1,4
    srli  s5,a0,4
    slli  t1,t1,28
    or    s5,s5,t1
    or    a1,s4,a1
    or    a0,s5,a0
    
    #x |= (x >> 8)
    andi  t1,a1,0xff
    srli  s4,a1,8
    srli  s5,a0,8
    slli  t1,t1,24
    or    s5,s5,t1
    or    a1,s4,a1
    or    a0,s5,a0
   
    #x |= (x >> 16)
    li    t1,0xffff
    and   t1,a1,t1
    srli  s4,a1,16
    srli  s5,a0,16
    slli  t1,t1,16
    or    s5,s5,t1
    or    a1,s4,a1
    or    a0,s5,a0
    
    #x |= (x >> 32)
    mv    s5,a1
    and   s4,a1,x0
    or    a1,s4,a1
    or    a0,s5,a0
    
    # x -= ((x >> 1) & 0x5555555555555555)
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
    
    #x = ((x >> 2) & 0x3333333333333333) + (x & 0x3333333333333333)
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
    
    #x = ((x >> 4) + x) & 0x0f0f0f0f0f0f0f0f;
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
    
    #x += (x >> 8)
    andi  t1,a1,0xff
    srli  s4,a1,8
    srli  s5,a0,8
    slli  t1,t1,24
    or    s5,s5,t1
    add   a1,a1,s4
    add   a0,a0,s5
    
    #x += (x >> 16)
    li    t1,0xffff
    and   t1,t1,a1
    srli  s4,a1,16
    srli  s5,a0,16
    slli  t1,t1,16
    or    s5,s5,t1
    add   a1,a1,s4
    add   a0,a0,s5
    
    #x += (x >> 32)
    mv    s5,a1
    and   s4,a1,x0
    add   a1,a1,s4
    add   a0,a0,s5
    
    #64 - (x & 0x7f)
    andi  a0,a0,0x7f
    li    t1,64
    sub   a0,t1,a0
    jr    ra
