; C517A-Symbole verfügbar machen
$NOMOD51
#include <Reg517a.inc>

NAME	main

; Symbole aus den Modulen importieren
EXTRN CODE (scheduler, startProcess)

; Variablen anlegen
dataSegment	SEGMENT DATA
RSEG dataSegment

STACK:	DS	4


; Interrupt-Routinen definieren
CSEG

ORG		0x0B	; Timer 0 Interrupt
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
SETB	ET0		; Timer 0-Interrupt für den Scheduler

; Timer-Konfiguration
MOV		TMOD,#00010000b ; Timer 1: 16 Bit Timer, Timer 2: 8 Bit Timer
SETB	TR1		; Timer 1 für Prozess A aktivieren

; Serial Mode 1: 8bit-UART bei Baudrate 9600
CLR		SM0
SETB	SM1

SETB	REN0			; Empfang ermöglichen
SETB	BD				; Baudraten-Generator aktivieren
MOV		S0RELL,#0xD9	; Baudrate einstellen
MOV		S0RELH,#0x03	; 9600 = 03D9H

; Stack Pointer auf reservierten Bereich setzen
MOV		SP,#STACK


;
; Initialisierungs-Programm
;

; Konsolenprozess starten
MOV		A,#0 ; Prozess 0
MOV		B,#0 ; höchste Priorität
CALL	startProcess

; Timer 0 fü
SETB	TR0

; Scheduler-Interrupt starten
SETB	TF0




infiniteLoop:
	
	NOP
	
JMP		infiniteLoop


END