; C517A-Symbole verfügbar machen
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
	; muss periodisch ausgeführt werden, sonst setzt der Watchdog die CPU zurück
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
	; gesicherte Register des nächsten Prozesses laden
	;
	; PC des nächsten Prozesses auf den Stack schreiben
	;
	
	
RETI

END