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

	SETB	ET1	; Timer 0-Interrupt aktivieren
	
	; Timer konfigurieren
	MOV		A,TMOD
	SETB	ACC.4
	CLR		ACC.5
	CLR		ACC.6
	CLR		ACC.7
	MOV		TMOD,A ; Mode 1 - 16 Bit Timer

	; sofort erstes 'a' senden
	MOV R0,#1
	
	SETB	TR1	; Timer aktivieren
	
processAloop:
	
	JNB 	TF1,processAloop;
	CLR		TF1
	
	DJNZ	R0,processAloop
	MOV		R0,#0x15

	
	MOV		A,#97 ; 'a' ASCII
	CALL	serialSend
	
	JMP	processAloop
	
RET

END