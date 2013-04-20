; C517A-Symbole verfügbar machen
$NOMOD51
#include <Reg517a.inc>

; Symbol-Im- und -Exporte
NAME	ausgabea
EXTRN	CODE	(serialSend)
PUBLIC	processAusgabeAStart, processAusgabeAStop, processAusgabeAInt


dataSegmentPA SEGMENT DATA
RSEG dataSegmentPA

COUNT1:	DS 1
COUNT2:	DS 1

codeSegmentPA SEGMENT CODE
RSEG codeSegmentPA

;
; Sendet jede Sekunde ein 'a' auf dem seriellen Port
;
processAusgabeAStart:

	SETB	ET0	; Timer 0-Interrupt aktivieren
	
	; Timer konfigurieren
	MOV		TMOD,#00000001b ; Mode 1 - 16 Bit Timer

	; sofort erstes 'a' senden
	MOV COUNT1,#1
	MOV COUNT2,#1
	
	SETB	TR0	; Timer aktivieren
	
RET

processAusgabeAStop:

	CLR		TR0
	CLR		ET0
	
RET

processAusgabeAInt:
	
	DJNZ	COUNT1,processAusgabeAIntEnd
	MOV		COUNT1,#0x52
	
	DJNZ	COUNT2,processAusgabeAIntEnd
	MOV		COUNT2,#0x02
	
	MOV		A,#97 ; 'a' ASCII
	CALL	serialSend
	;MOV		TMOD,#00000001b
	
processAusgabeAIntEnd:
	; TF reset?
	
RETI

END