* Fill screen in DHGR with a byte
* loop for 256 values of this byte
*
*  ROM routines
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

        jsr dovbl
main    sta page2
loopx2c lda color
loopx2  sta $2000,x
        inx 
        bne loopx2
        inc loopx2+2
        lda loopx2+2
        cmp #$40
        bne loopx2c
        lda #$20 
        sta loopx2+2
*
        jsr dovbl
        sta page1
        ldx #$00
loopxc  lda color
loopx   sta $2000,x
        inx 
        bne loopx
        inc loopx+2
        lda loopx+2
        cmp #$40
        bne loopxc
        lda #$20 
        sta loopx+2

        inc color
        bne main
        rts
        rts

*
* wait for VBL
dovbl   nop
        pha
loopvbl lda vbl
        bmi loopvbl
        pla 
        rts

color   hex 00

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




