        put const

        DO 0


sup     MAC
* Set CARRY if ]1 > ]2 (16 bits values)
        lda ]1+1
        cmp ]2+1
        beq egal        ; hi(A) > hi (B) see lo
        jmp supe        ; if A > B : C = 1, if A < B : C = 0
egal    lda ]1
        cmp ]2
        bne supe  ; A = B : C= 0; else C is set accordingly 
        clc 
supe    EOM

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

        FIN

        org $8000

        sup un;deux
        php
        printm un
        plp
        bcc dono
        lda yes
        jsr cout
        jmp exit
dono    lda no
        jsr cout
        lda no+1
        jsr cout
        
exit    lda space
        jsr cout
        printm deux
        rts

un      hex 0103
deux    hex 0A02
yes     asc ">"
no      asc "<="
space   asc " "