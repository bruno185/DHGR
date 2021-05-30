        put const

        DO 0

printm  MAC
* print 16 bits value pointed by ]1
        lda #"$"
        jsr cout
        ldx ]1+1
        jsr xtohex
        ldx ]1
        jsr xtohex
        lda #$A0
        jsr cout
        EOM

sup     MAC
* Set CARRY if ]1 > ]2 (16 bits UNSIGNED values)
        lda ]1+1
        cmp ]2+1
        beq egal        ; hi(A) > hi (B) see lo
        jmp supe        ; if A > B : C = 1, if A < B : C = 0
egal    lda ]1
        cmp ]2
        bne supe  ; A = B : C= 0; else C is set accordingly 
        clc 
supe    EOM

supeq   MAC
* Set CARRY if ]1 >= ]2 (16 UNSIGNED bits values)
        lda ]1+1
        cmp ]2+1
        beq egal2       ; hi(A) > hi (B) see lo
        jmp supeqe      ; if A >= B : C = 1, if A < B : C = 0
egal2   lda ]1
        cmp ]2
supeqe  EOM

*
ssupeq  MAC
* Set CARRY if ]1 >= ]2 (16 bits SIGNED values)
        sec
        lda ]1+1
        sbc ]2+1
        beq egal3
        bmi less0
        bvc more
less1   clc 
        jmp ssupeqe
less0   bvc less1
more    sec
        jmp ssupeqe
*
egal3   sec
        lda ]1
        sbc ]2
        beq ssupeqe
        bmi less2
        bvc more2
less3   clc
        jmp ssupeqe
less2   bvc less3 
more2   sec
ssupeqe EOM

equal   MAC
*
        lda ]1
        cmp ]2
        bne noteq
        lda ]1+1
        cmp ]2+1
        bne noteq
        jmp okequal
noteq   clc
        jmp outeq
okequal sec
outeq   EOM

        FIN

        org $8000

* Test macro "sup" (C=1 if A>B)
        sup un;deux
        php
        printm un
        plp
        bcc dono
        lda yes
        jsr cout
        jmp suite1
dono    lda no
        jsr cout
        lda no+1
        jsr cout
suite1  lda space
        jsr cout
        printm deux

* Test macro "supeq" (C=1 if A>=B)
        jsr cr
        supeq un;deux
        php
        printm un
        lda space 
        jsr cout
        printm deux
        lda space 
        jsr cout
        plp
        bcc nocarry

        jmp suite2
nocarry lda cns 
        jsr cout
        jmp suite22
suite2
        lda cs 
        jsr cout
suite22 jsr cr

*
* Test macro "ssupeq" (C=1 if A>=B SIGNED )

        ssupeq un;deux
        php
        printm un
        lda space 
        jsr cout
        printm deux
        lda space 
        jsr cout
        plp
        bcc nocar2
        lda cs 
        jsr cout
        jmp suite3
nocar2  lda cns 
        jsr cout


suite3
        jsr cr
        equal un;deux
        php
        printm un
        lda space 
        jsr cout
        printm deux
        lda space 
        jsr cout
        plp
        bcc pnoteq
        lda eg
        jsr cout
        jmp suite4
pnoteq  lda noteg
        jsr cout

suite4
        jsr cr
        jsr cr
        rts

un      hex 0400
deux    hex FCFF
yes     asc ">"
no      asc "<="
space   asc " "
cs      asc "1"
cns     asc "0"
eg      asc "="
noteg   asc "N"
