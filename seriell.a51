; C517A-Symbole verf�gbar machen
$NOMOD51
#include <Reg517a.inc>

; Symbol-Exporte
NAME	seriell
PUBLIC	serialSend


codeSegment SEGMENT CODE
RSEG codeSegment

;
; Sendet ein Byte vom Akkumulator auf den seriellen Port
;
serialSend:
	
	; Interrupts f�r die Dauer der seriellen �bertragung deaktivieren
	CLR		EAL
	
	; Daten schreiben
	MOV		S0BUF,A
	
	; warten, bis Senden abgeschlossen (TI0 gesetzt wurde)
	sendWait:
		NOP
		JNB		TI0,sendWait
	
	CLR		TI0		; nach Senden TI0 zur�cksetzen
	
	; Interrupts wieder aktivieren
	SETB	EAL
	
RET

END