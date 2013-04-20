; C517A-Symbole verf�gbar machen
$NOMOD51
#include <Reg517a.inc>

; Symbol-Exporte
NAME	scheduler
PUBLIC	scheduler


codeSegment SEGMENT CODE
RSEG codeSegment

;
; Prozess-Scheduler
;
scheduler:
	
	; Watchdog-Reset
	; muss periodisch ausgef�hrt werden, sonst setzt der Watchdog die CPU zur�ck
	SETB	WDT
	SETB	SWDT
	
	NOP
	NOP
	NOP
	NOP
	NOP
	
	
	;
	; PC vom Stack holen und sichern
	;
	; Register sichern
	;
	; gesicherte Register des n�chsten Prozesses laden
	;
	; PC des n�chsten Prozesses auf den Stack schreiben
	;
	
	
RETI

END