; C517A-Symbole verfügbar machen
$NOMOD51
#include <Reg517a.inc>

; Symbol-Im- und -Exporte
NAME	ausgabeb
EXTRN	CODE	(serialSend)
PUBLIC	processAusgabeB


codeSegment SEGMENT CODE
RSEG codeSegment

;
; Sendet einmalig 54321 auf dem seriellen Port
;
processAusgabeB:
	
	MOV		R0,#53	; 53 == 5 ASCII
	
	processBLoop:
		
		MOV		A,R0
		CALL	serialSend
		
		DEC		R0
		
	CJNE	R0,#48,processBLoop
	
	
RET

END