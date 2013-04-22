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
	; Rechnung mit 24MHz Takt:
	; ((((24 * 10^6) / 12) / 2^16) / 30) = 1,01..
	DJNZ	R0,processAloop
	MOV		R0,#0x1E

	MOV		A,#97 ; 'a' ASCII
	CALL	serialSend
	
	JMP		processAloop
	
RET

END