.define clear_color #0
.define dot_color #1
.ORG $8000
; reset Stack
start:
LDX #$FF
TXS

; Store in X initial offest of dot
LDX #0

loop:
; color curr position
LDA dot_color
STA $0200, X
; store input player to A
LDA $4000
; store A into $00
STA $00
; AND bit con 8
AND #$8
; se da 0 schippo
BEQ else_right
JSR clear
JSR right
else_right:
; Ricarico input da $00 in A
LDA $00
; AND bit con 4
AND #$4
; se da 0 schippo
BEQ else_left
JSR clear
JSR left
else_left:
; Ricarico input da $00 in A
LDA $00
; AND bit con 2
AND #$2
; se da 0 schippo
BEQ else_down
JSR clear
JSR down
else_down:
; Ricarico input da $00 in A
LDA $00
; AND bit con 1
AND #$1
; se da 0 schippo
BEQ else_top
JSR clear
JSR top
else_top:
; is nothing
JMP loop

top:
SEC
TXA
SBC #$10
TAX
RTS

down:
CLC
TXA
ADC #$10
TAX
RTS

left:
; controllo se sto per uscire dallo schermo
TXA
LDY #$04
loop_left_shift:
;butto via la parte di riga
ASL A
DEY
BNE loop_left_shift
; vedo se il numero terminava per 0
EOR #$00
BNE else_need_to_left_reset
JSR down
else_need_to_left_reset:
DEX
RTS

right:
; controllo se sto per uscire dallo schermo
TXA
LDY #$04
loop_right_shift:
;butto via la parte di riga
ASL A
DEY
BNE loop_right_shift
; vedo se il numero terminava per F
EOR #$F0
BNE else_need_to_right_shift
JSR top
else_need_to_right_shift:
INX
RTS

clear:
; set color Black
LDA clear_color
; color curr pixel to X
STA $0200, X
RTS

.goto $FFFA
.dw start ; non maskable
.dw start ; reset
.dw start ; interrupt