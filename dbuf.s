
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
* ROM switches
*
stor80   equ $C001
col80off equ $C00C
col80on  equ $C00D
graphics equ $C050
mixoff   equ $C052
mixon    equ $C053
hires    equ $C057
dhgr     equ $C05E
page1    equ $C054
page2    equ $C055
clr80col equ $C000
vbl      equ $C019
kbd      equ $C000
kbdstrb  equ $C010
*
ptr     equ $06
ptr2    equ $08


        org $8000
        lda col80on
        ldx #$18
homel   lda #$8D
        jsr cout
        dex
        bne homel

        *lda #17         ; 40 col. 
        *jsr cout

        jsr clear1
        jsr clear2
        sta stor80
        lda mixon
        *lda mixoff      ; no text
        lda graphics    ; graphic mode

* PAGE 1
        lda page1       ; go HGR
        lda hires       ; hgr 
        lda #$FF
        sta $2000
        jsr prnincode
        str "stor80 on, page 1, poke 2000,255"+#$8D

        jsr rdkey

* PAGE 2
        lda page2
        lda #$AA 
        sta color1
        jsr clear1  
        jsr prnincode
        str "stor80 on, page 2, clear 1 with $FF" +#$8D 
        jsr movex2 
        jsr rdkey

* PAGE 1
        lda page1 
        lda #%10101010 
        sta color1
        jsr clear1 
        jsr prnincode
        str "stor80 on, page 1, clear 1 with %10101010" +#$8D              
        jsr rdkey
        jsr text
        rts

movex
        lda mains       ; begining of memory to tranfer 
        sta $3C
        lda mains+1
        sta $3D
*
        lda maine       ; end of memory to tranfer
        sta $3E
        lda maine+1
        sta $3F
*
        lda auxs        ; detination address   
        sta $42
        lda auxs+1
        sta $43
        sec
        jsr auxmov      ; tranfer to  aux. mem.
        rts

mains   hex 0040        ; start address in main
maine   hex FF5F        ; $ 5FFF = end address in main 
auxs    hex 0020
*
movex2
        lda mains2       ; begining of memory to tranfer 
        sta $3C
        lda mains2+1
        sta $3D
*
        lda maine2       ; end of memory to tranfer
        sta $3E
        lda maine2+1
        sta $3F
*
        lda auxs2        ; detination address   
        sta $42
        lda auxs2+1
        sta $43
        clc
        jsr auxmov      ; tranfer from  aux. mem.
        rts

mains2  hex 0020        ; start address in aux
maine2  hex FF3F        ; $ 3FFF = end address in aux 
auxs2   hex 0060


clear1  
        ldx #$00
        lda color1
doclr1  sta $2000,x 
        inx
        bne doclr1
        inc doclr1+2
        ldy doclr1+2
        cpy #$40
        bne doclr1
        lda #$20 
        sta doclr1+2
        rts

* clear2 clears $4000 (page 2)
clear2 
        ldx #$00
        lda color1
doclr2  sta $4000,x 
        inx
        bne doclr2
        inc doclr2+2
        ldy doclr2+2
        cpy #$60
        bne doclr2
        lda #$40 
        sta doclr2+2
        lda #$00
        sta doclr2+1
        rts

color1  hex 00

prnincode   
        jmp picode
pg1     equ $100
stack   hex 00
long    hex 00
picode  tsx ; rcup stack 
        stx stack ; stack
        lda  pg1+1,x 
        sta ptr ; save hi
        lda  pg1+2,x ; hi
        sta ptr+1 ; save hi
        ldy #$01
        lda (ptr),y  
        sta long
        iny 
        ldx long
looppic lda (ptr),y 
        jsr cout
        iny
        dex
        bne looppic
*
        ldx stack
        lda ptr   
        sec
        adc long
        sta  pg1+1,x 
        bcc suite
        lda ptr+1
        adc #$00
        sta  pg1+2,x
suite   rts

        STA $C050 ;TURN ON GRAPHICS
        STA $C057 ;TURN ON HIRES
        STA mixoff ;TURN ON FULLSCREEN
        STA $C00D ;TURN ON 80 COLUMNS
        STA $C001 ;TURN ON 805TORE
        STA $C055 ;TURN ON PAGE2


        sta $C00C

        lda page1       ; go HGR
        lda mixoff      ; no text
        lda graphics    ; graphic mode
        lda hires       ; hgr 
