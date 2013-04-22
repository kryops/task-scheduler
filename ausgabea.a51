; C517A-Symbole verfügbar machen
$NOMOD51
#include <Reg517a.inc>

; Symbol-Im- und -Exporte
NAME	ausgabea
EXTRN	CODE	(serialSend)
PUBLIC	processAusgabeA

codeSegmentPA SEGMENT CODE
RSEG codeSegmentPA

;
; Sendet jede Sekunde ein 'a' auf dem seriellen Port
;
processAusgabeA:

	; sofort erstes 'a' senden
	MOV R0,#1
	
processAloop:
	
	; Timer 1 Polling
	JNB 	TF1,processAloop
	CLR		TF1
	
	; Counter für ca. 1s
	DJNZ	R0,processAloop
	MOV		R0,#0x15

	MOV		A,#97 ; 'a' ASCII
	CALL	serialSend
	
	JMP		processAloop
	
RET

END