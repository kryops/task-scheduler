; C517A-Symbole verfügbar machen
$NOMOD51
#include <Reg517a.inc>

NAME	main

; Symbole aus den Modulen importieren
EXTRN CODE (serialSend, processConsole, processAusgabeB)


; Variablen anlegen
dataSegment	SEGMENT DATA
RSEG		dataSegment

STACK:	DS	4


; Interrupt-Routinen definieren
CSEG

;ORG		0x23
;JMP		serialInterrupt



; Systemstart-Anweisungen
ORG 0
JMP		start

codeSegment SEGMENT CODE
RSEG codeSegment


start:

;
; Prozessor-Konfiguration
;

; Interrupts
SETB	EAL		; Interrupts global aktivieren

; Serielles Interrupt vorerst deaktiviert -> in Prozessen über Polling lösen?
;MOV		A,IEN0	; Interrupt-Flag auf ES0 = IEN0.4
;SETB	ACC.4
;MOV		IEN0,A


; Serial Mode 1: 8bit-UART bei Baudrate 9600
CLR		SM0
SETB	SM1

SETB	REN0			; Empfang ermöglichen
SETB	BD				; Baudraten-Generator aktivieren
MOV		S0RELL,#0xD9	; Baudrate einstellen
MOV		S0RELH,#0x03	; 9600 = 03D9H

; Stack Pointer auf reservierten Bereich setzen
MOV		SP,#STACK


CALL	processConsole


pointlessLoop:
	
	; Watchdog-Reset
	; muss periodisch ausgeführt werden, sonst setzt der Watchdog die CPU zurück
	; und die Ausgaben gehen verloren
	SETB	WDT
	SETB	SWDT
	
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	
	
	JMP pointlessLoop

END