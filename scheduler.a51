; C517A-Symbole verfügbar machen
$NOMOD51
#include <Reg517a.inc>

; Symbol-Im- und -Exporte
NAME	scheduler
PUBLIC	scheduler, startProcess, stopProcess
EXTRN	CODE	(processConsole, processAusgabeA, processAusgabeB)

; Variablen
dataSegment SEGMENT DATA
RSEG dataSegment

processTable:	DS	3	; Welche Prozesse sind gerade aktiv? (je 1 Byte)
processCount:	DS	3	; Prozess-Aufrufzähler (je 1 Byte)
currentProcess:	DS	1	; Welcher Prozess läuft gerade?
processStack:	DS	12	; Stack für alle Prozesse (je 4 Bytes)


backupA:		DS	1
backupB:		DS	1
backupR0:		DS	1

; Gesicherte Register für alle Prozesse (je 14 Byte)
; SP,A,B,PSW,DPH,DPL,R0..R7
processStatus:	DS	42	


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
	
	
RETI


;
; Prozess starten
; A: Prozess-Index
;	0 = console
;	1 = ausgabea
;	2 = ausgabeb
;
startProcess:
	
	; R7: Zwischenspeicher für Prozess-Index
	
	; Eintrag in Prozess-Tabelle aktivieren
	MOV		R7,A
	ADD		A,#processTable
	MOV		R0,A
	MOV		@R0,#0xff
	MOV		A,R7
	
	; R0: Adresse Prozesstabellen-Eintrag
	
	; Stack-Adresse ermitteln
	MOV		B,#4	; Größe des Stack-Bereichs pro Prozess
	MUL		AB
	ADD		A,#processStack
	MOV		R1,A
	
	; R1: Stack-Startadresse des Prozesses
	
	; Prozess-Startadresse ermitteln
	CJNE	R7,#0,startProcessIndexNot0
	
		MOV		DPTR,#processConsole
		JMP		startProcessIndexFinish
	
	startProcessIndexNot0:
	CJNE	R7,#1,startProcessIndexNot1
	
		MOV		DPTR,#processAusgabeA
		JMP		startProcessIndexFinish
	
	startProcessIndexNot1:
	
	MOV		DPTR,#processAusgabeB
	
	startProcessIndexFinish:
	
	
	;;; TODO richtige Reihenfolge?
	
	MOV		@R1,DPH
	INC		R1
	MOV		@R1,DPL
	INC		R1
	
	MOV		A,R7
	
	; Status des Prozesses zurücksetzen
	MOV		B,#14	; Größe des Status-Bereichs pro Prozess
	MUL		AB
	ADD		A,#processStatus
	MOV		R0,A
	
	; R0: Startadresse des Statusbereichs
	
	MOV		A,R1
	MOV		@R0,A	; Stack auf Anfang setzen
	
	MOV		A,R0
	INC		R0
	MOV		R1,#1
	
	; R1: Zählvariable 1-14
	
	startProcessStatusResetLoop:
		MOV		@R0,#0
		INC		R1
	CJNE	R1,#14,startProcessStatusResetLoop
	
RET

;
; Prozess beenden
; A: Prozess-Index
;	0 = console
;	1 = ausgabea
;	2 = ausgabeb
;
stopProcess:
	
	MOV		B,A
	ADD		A,#processTable
	MOV		R0,A
	MOV		@R0,#0
	MOV		A,B
	
	; Scheduler-Interrupt starten
	SETB	TF0
	
RET


END