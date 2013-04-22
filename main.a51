; C517A-Symbole verfügbar machen
$NOMOD51
#include <Reg517a.inc>

NAME	main

; Symbole aus den Modulen importieren
EXTRN CODE (scheduler, serialSend, processConsole, processAusgabeA, processAusgabeB)

; Variablen anlegen
dataSegment	SEGMENT DATA
RSEG		dataSegment

STACK:	DS	4


; Interrupt-Routinen definieren
CSEG

ORG		0x0B	; Timer0
JMP		scheduler

; Systemstart-Anweisungen
ORG 0
JMP		start


codeSegment SEGMENT CODE
RSEG codeSegment

start:

;
; Prozessor-Konfiguration
;

; Interrupt-Flags
SETB	EAL		; Interrupts global aktivieren

SETB	ET0		; Timer 1-Interrupt für den Scheduler


; Serial Mode 1: 8bit-UART bei Baudrate 9600
CLR		SM0
SETB	SM1

SETB	REN0			; Empfang ermöglichen
SETB	BD				; Baudraten-Generator aktivieren
MOV		S0RELL,#0xD9	; Baudrate einstellen
MOV		S0RELH,#0x03	; 9600 = 03D9H

; Stack Pointer auf reservierten Bereich setzen
MOV		SP,#STACK

; Timer 1 für den Scheduler aktivieren
SETB	TR0


;
; Hauptprogramm
;

; Konsolenprozess starten
CALL	processConsole


END