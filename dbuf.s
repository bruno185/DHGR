
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
ptr2    equ $08

        DO 0

m_inc   MAC             ; inc 16  bits integer
        inc ]1          ; usually a pointer
        bne m_incf
        inc ]1+1
m_incf  EOM

movmem  MAC
        lda #<]1        ; begining of memory to tranfer 
        sta $3C
        lda #>]1
        sta $3D
*
        lda #<]2        ; end of memory to tranfer
        sta $3E
        lda #>]2
        sta $3F
*
        lda #<]3        ; detination address   
        sta $42
        lda #>]3
        sta $43
*
        lda #]4         ; direction flag
        bne aux2m       
        clc             ; O (clc) = AUX to MAIN
        jmp mov
aux2m   sec             ; 1 (sec) = MAIN to AUX
mov     jsr auxmov      ; copy memory 
        EOM

        FIN


        org $8000
** don't do that 
*        sta col80off
*        ldx #$18
*        lda #$8D
*loop    jsr cout
*        dex 
*        bne loop
*
*        jsr rdkey


        lda #$11         ; 40 col. 
        jsr cout
        jsr prnincode
        str "40 col. step 1"+#$8D
        jsr rdkey
*
        lda #$3         ; = pr#3 ==> 80 col.
        jsr $FE95
        jsr prnincode
        str "80 col step 2"+#$8D
        jsr rdkey
*
        lda #$11        ; 40 col. 
        jsr cout
        jsr prnincode
        str "40 col.  step 3"+#$8D 
        jsr rdkey
* 
        lda #$12        ; 80 col. 
        jsr cout
        jsr prnincode
        str "80 col  step 4"+#$8D 
        jsr rdkey
*             
        lda #$15         ; turn off 80 col firmware
        jsr cout
        jsr prnincode
        str "40 col  step 5"+#$8D  
        jsr rdkey 

        jsr myhome
        jsr rdkey
        jsr clear1
        jsr clear2

        sta stor80
        lda mixon
        *lda mixoff      ; no text
        lda graphics    ; graphic mode

* * * * * * PAGE 1
        lda page1       ; go HGR
        lda hires       ; hgr 
        lda #$FF
        sta $2000
        jsr prnincode
        str "stor80 on, page 1, poke 2000,255"+#$8D

        jsr rdkey

* * * * * * PAGE 2
        lda page2
        jsr prnincode
        str "stor80 on, page 2, clear 1 with $FF" +#$8D 
        movmem $400;$800;$6000;$0
        jsr rdkey

* * * * * * PAGE 1 
        lda page1 
        lda #%10101010 
        sta color1
        jsr clear1 
        jsr prnincode
        str "stor80 on, page 1, clear 1 with %10101010" +#$8D              
        jsr rdkey
        jsr text
        rts

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

myhome  ldx #$18
homel   lda #$8D
        jsr cout
        dex
        bne homel
        rts

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
