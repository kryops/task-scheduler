; C517A-Symbole verfügbar machen
$NOMOD51
#include <Reg517a.inc>

; Symbol-Im- und -Exporte
NAME	console
PUBLIC	processConsole
EXTRN CODE (startProcess, stopProcess)

codeSegment SEGMENT CODE
RSEG codeSegment

;
; Liest Zeichen von der seriellen Schnittstelle ein
; a: Startet Prozess AusgabeA
; b: Beendet Prozess AusgabeA
; c: Startet Prozess AusgabeB
; anderes Zeichen: Keine Aktion
;
processConsole:
	
	; Serielle Schnittstelle durch Polling auslesen
	JNB		RI0,processConsole
	
	MOV		A,S0BUF		; Daten auf Port1 lesen
	CLR		RI0			; Empfangs-Flag wieder löschen
	
	;
	; Gelesenes Zeichen analysieren
	;
	
	CJNE	A,#97,consoleNotA
	
	; a gelesen: Prozess AusgabeA starten
	
	MOV		A,#1
	CALL	startProcess
	
	JMP		processConsole
	
	consoleNotA:
	
	CJNE	A,#98,consoleNotB
	
	; b gelesen: Prozess AusgabeA beenden
	
	MOV		A,#1
	CALL	stopProcess
	
	JMP		processConsole
	
	consoleNotB:
	
	CJNE	A,#99,processConsole
	
	; c gelesen: Prozess AusgabeB starten
	
	MOV		A,#2
	CALL	startProcess
	
	JMP processConsole

END