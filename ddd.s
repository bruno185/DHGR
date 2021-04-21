* Fill screen in DHGR with a consistent color (needs 4 bytes)
* loop for 16 availables colors in DHGR
* poke values in AUX memory for the whole screen 
* => even columns of each line
* then poke values in MAIN memory for the whole screen
* => odd columns of each line

* ROM routines
        lst off
*
home    equ $FC58
text    equ $FB2F
col80off equ $C00C
col80on  equ $C00D
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
graphics equ $C050
mixoff   equ $C052
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
* init DHGR
        sta graphics
        sta hires
        sta mixoff
        sta dhgr
        sta col80on
        sta stor80
*
main
        lda color       ; set ptr -> color table
        sta ptr
        lda color+1
        sta ptr+1
*
* page2
        ldy #$00        ; even columns
        ldx #$00
        sta page2       ; poke in page 2
loop    lda (ptr),y
poke2   sta $2000,x
*
        iny             ; update y (0>2>)
        iny
        tya
        and #$02
        tay        
*
        inx             ; x loop
        bne loop
*
        inc poke2+2     ; next page (self modify code)
        lda poke2+2     
        cmp #$40        ; end ($4000) ?
        bne loop
*
* page 1
        ldy #$01        ; odd columns
        ldx #$00
        sta page1       ; poke in page 1
loop2   lda (ptr),y
poke1   sta $2000,x
* 
        iny              ; update y (1>3>)
        iny         
        tya
        and #$03
        tay
*
        inx 
        bne loop2
*
        inc poke1+2     ; next page (self modify code)
        lda poke1+2
        cmp #$40
        bne loop2
* reset code
        lda #$20
        sta poke1+2
        sta poke2+2
*
        inc colnum
        lda colnum
        cmp #$10
        beq exit
        jsr rdkey
        lda color
        clc 
        adc #$04
        sta color
        bcc noadd
        inc color+1
noadd   jmp main
exit    jsr text
        rts 

*
* wait for VBL
dovbl   nop
        pha
loopvbl lda vbl
        bmi loopvbl
        pla
        rts

color   da c0
colnum  hex 00

c0      hex 00000000    ; black
c1      hex 08112244    ; magenta
c2      hex 44081122    ; brown
c3      hex 4C193366    ; orange
c4      hex 22440811    ; dark green
c5      hex 2A552A55    ; grey 1
c6      hex 664C1933    ; green
c7      hex 6E5D3B77    ; yellow
c8      hex 11224408    ; dark blue
c9      hex 1933664C    ; violet
c10     hex 552A552A    ; grey 2
c11     hex 5D3B776E    ; pink
c12     hex 33664C19    ; medium blue
c13     hex 3B776E5D    ; light blue
c14     hex 776E5D3B    ; aqua
c15     hex 7F7F7F7F    ; white
*
