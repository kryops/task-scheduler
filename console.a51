; C517A-Symbole verf�gbar machen
$NOMOD51
#include <Reg517a.inc>

; Symbol-Im- und -Exporte
NAME	console
PUBLIC	processConsole

codeSegment SEGMENT CODE
RSEG codeSegment

processConsole:
	
	; Watchdog zur�cksetzen
	; TODO sp�ter im Scheduler
	SETB	WDT
	SETB	SWDT
	
	
	; Serielle Schnittstelle durch Polling auslesen
	JNB		RI0,processConsole
	
	MOV		A,S0BUF		; Daten auf Port1 lesen
	CLR		RI0			; Empfangs-Flag wieder l�schen
	
	;
	; Gelesenes Zeichen analysieren
	;
	
	CJNE	A,#97,consoleNotA
	
	; a gelesen: Prozess AusgabeA starten
	
	NOP
	;
	;
	;
	
	JMP		processConsole
	
	consoleNotA:
	
	CJNE	A,#98,consoleNotB
	
	; b gelesen: Prozess AusgabeA beenden
	
	NOP
	;
	;
	;
	
	JMP		processConsole
	
	consoleNotB:
	
	CJNE	A,#99,processConsole
	
	; c gelesen: Prozess AusgabeB starten
	
	NOP
	;
	;
	;
	
	JMP processConsole

END