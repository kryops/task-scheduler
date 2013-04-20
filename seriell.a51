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
	
	; Interrupts deaktivieren, damit der Scheduler nicht w�hrend des Sendens aktiviert wird
	CLR		EAL
	
	; Daten schreiben
	MOV		S0BUF,A
	
	; warten, bis Senden abgeschlossen (TI0 gesetzt wurde)
	sendWait:
		NOP
		JNB		TI0,sendWait
	
	CLR		TI0		; nach Senden TI0 zur�cksetzen
	
	; Interrupts wieder aktivieren
	; die Aktivierung des n�chsten Interrupts dauert laut Doku mindestens 2 Cycles, also sollte der
	; RET-Befehl vorher noch ausgef�hrt werden
	SETB	EAL
	
RET

END