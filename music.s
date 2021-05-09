* http://eightbitsoundandfury.ld8.org/programming.html
* Attention: the musical notes are shifted in the table of this article
* C is a G, D is a A, and so on

        put const.s

        DO 0

nonote  MAC
        hex 010100
        EOM

        FIN

        org $8000

        jmp main
freq    hex 00          ; frequency
dura    hex 00          ; duration      
dummy   hex 00          
savx    hex 00          ; to save x register

main  
        ldx #$00
donote  lda music,x     ; get freqency
        beq end         ; flag for end of tune
        sta freq        
        inx
        lda music,x     ; get duration
        sta dura
        inx
        stx savx        ; save x 
        lda music,x     ; get flag
        beq np          ; 0 : no play
        jsr play        ; <>0 : play
        jmp nextnot
np      jsr noplay
nextnot ldx savx        ; restore X
        inx             ; prepare for next note
        jmp donote      ; loop
end     rts



play    lda bell        ; clic
loop1   dey             ; y loop, for duration 
        bne suite1
        dec dura        ; 
        beq endplay     ; exit when duration=0
suite1  dex             ; x loop for frequency
        bne loop1       ; clic when x = 0
        ldx freq        ; reload frequency
        jmp play        ; loop
endplay rts

noplay  lda dummy       ; same but no bell
loop2   dey
        bne suite1
        dec dura
        beq endplay
suite2  dex
        bne loop1
        ldx freq
        jmp play
endnopl rts

* 3 bytes for each note :
* frequency, duration, flag 
* flag : 01 ==> play ; 00 ==> no play (silence)
music   hex 604001      ; C
        nonote
        hex 554001      ; D
        nonote
        hex 4C8001      ; E     
        nonote
        hex 558001      ; D
        nonote
        hex 608001      ; C
        nonote
        hex 00
