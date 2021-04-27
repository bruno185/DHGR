* ROM routines
        lst off
*
home    equ $FC58
text    equ $FB2F
cout    equ $FDED
vtab    equ $FC22
getln   equ $FD6A
bascalc equ $FBC1
cr      equ $FD8E      ; print carriage return
clreop  equ $FC42      ; clear from cursor to end of page
clreol  equ $FC9C      ; clear from cursor to end of line
xtohex  equ $F944
rdkey   equ $FD0C      ; wait for keypress
auxmov  equ $C311
xfer    equ $C314
wait    equ $FCA8
*
* page 0
*
cv        equ $25
ch        equ $24 
wndlft    equ $20
wndwdth   equ $21
wndtop    equ $22
wndbtm    equ $23 
prompt    equ $33
*
ptr     equ $06
ptr2     equ $08
*

        org $8000
* init 
        lda #$00        ; init counter 
        sta scount
        sta scount+1
        lda sbase       ; init ptr to first free place
        sta ptr
        lda sbase+1
        sta ptr+1
*
        lda #$AA
        sta tempo
        lda #$DD
        sta tempo+1
        jsr psuh

        lda #$BB
        sta tempo
        lda #$CC
        sta tempo+1
        jsr psuh
    
        lda #$EE
        sta tempo
        lda #$FF
        sta tempo+1
        jsr psuh

        lda #$00
        sta tempo
        sta tempo+1
        jsr pop

        rts
*
; push a 16 bits value on stack
psuh    nop         
        ldy #$00        
        lda tempo       ; get value from tempo (lo)
        sta (ptr),y     ; drop on stack
        iny
        lda tempo+1     ; get value from tempo (hi)
        sta (ptr),y     ; drop on stack
*
        inc scount      ; scount++   
        bne doptr 
        inc scount+1 
* 
doptr   lda ptr         ; ptr + 2 
        clc
        adc #$02
        sta ptr
        lda ptr+1
        adc #$00
        sta ptr+1
epush   rts
*
; pop a 16 bits value from stack 
pop     nop             ; pop a 16 bits value from stack 
        lda ptr         ; set ptr to ptr-2
        sec
        sbc #$02
        sta ptr
        lda ptr+1
        sbc #$00
        sta ptr+1
*
        ldy #$00        ; get value
        lda (ptr),y 
        sta tempo       ; to tempo
        iny
        lda (ptr),y 
        sta tempo+1
*
        lda scount      ; scount--
        sec
        sbc #$01
        sta scount
        lda scount+1
        sbc #$00
        sta scount+1
        rts


* * * * DATA * * * *
scount  hex 0000
sbase   hex 0060        ; $6000
tempo   hex 0000
