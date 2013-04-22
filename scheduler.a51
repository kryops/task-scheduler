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

; Gesicherte Register für alle Prozesse (je 14 Byte)
; SP,A,B,PSW,DPH,DPL,R0..R7
processStatus:	DS	42	

; Zwischen-Sicherungsvariablen für A, B und R0
backupA:		DS	1
backupB:		DS	1
backupR0:		DS	1

firstRun:		DS	1	; Flag, ob der Scheduler bereits gelaufen ist




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
	
	; A, B und R0 vorsichern, da zur Offset-Berechnung benötigt
	MOV		backupA,A
	MOV		backupB,B
	MOV		backupR0,R0
	
	; Sicherung überspringen, wenn der Scheduler zum ersten mal läuft
	MOV		A,firstRun
	CJNE	A,#0xff,schedulerFindProcess
	
	MOV		A,currentProcess

	; Status des Prozesses sichern
	MOV		B,#14	; Größe des Status-Bereichs pro Prozess
	MUL		AB
	ADD		A,#processStatus
	MOV		R0,A
	
	; R0: Startadresse des Statusbereichs (alter Prozess)
	
	; Reihenfolge: SP,A,B,PSW,DPH,DPL,R0..R7
	
	MOV		@R0,SP
	INC		R0
	MOV		@R0,backupA
	INC		R0
	MOV		@R0,backupB
	INC		R0
	MOV		A,PSW
	MOV		@R0,A
	INC		R0
	MOV		A,DPH
	MOV		@R0,A
	INC		R0
	MOV		A,DPL
	MOV		@R0,A
	INC		R0
	MOV		@R0,backupR0
	INC		R0
	MOV		A,R1
	MOV		@R0,A
	INC		R0
	MOV		A,R2
	MOV		@R0,A
	INC		R0
	MOV		A,R3
	MOV		@R0,A
	INC		R0
	MOV		A,R4
	MOV		@R0,A
	INC		R0
	MOV		A,R5
	MOV		@R0,A
	INC		R0
	MOV		A,R6
	MOV		@R0,A
	INC		R0
	MOV		A,R7
	MOV		@R0,A
	
	; Nächsten Prozess auswählen
	schedulerFindProcess:
	
		; Prozesse 0,1 und 2 durchlaufen
		INC		currentProcess
		MOV		A,currentProcess
		CJNE	A,#3,schedulerNoReset
		MOV		currentProcess,#0
	
	schedulerNoReset:
	
		; Überprüfen ob currentProcess aktiv ist
		MOV		A,#processTable
		ADD		A,currentProcess
		MOV		R0,A
		
		CJNE	@R0,#0xff,schedulerFindProcess

	; Prozess-Aufrufe zählen
	MOV		A,currentProcess
	ADD		A,#processCount
	MOV		R0,A
	INC		@R0
	
	; Status des Prozesses wiederherstellen
	MOV		A,currentProcess
	MOV		B,#14	; Größe des Status-Bereichs pro Prozess
	MUL		AB
	ADD		A,#processStatus
	MOV		R0,A
	
	; R0: Startadresse des Statusbereichs (neuer Prozess)
	
	; Reihenfolge: SP,A,B,PSW,DPH,DPL,R0..R7
	
	MOV		A,@R0
	MOV		SP,A
	INC		R0
	MOV		backupA,@R0
	INC		R0
	MOV		backupB,@R0
	INC		R0
	MOV		A,@R0
	MOV		PSW,A
	INC		R0
	MOV		A,@R0
	MOV		DPH,A
	INC		R0
	MOV		A,@R0
	MOV		DPL,A
	INC		R0
	MOV		backupR0,@R0
	INC		R0
	MOV		A,@R0
	MOV		R1,A
	INC		R0
	MOV		A,@R0
	MOV		R2,A
	INC		R0
	MOV		A,@R0
	MOV		R3,A
	INC		R0
	MOV		A,@R0
	MOV		R4,A
	INC		R0
	MOV		A,@R0
	MOV		R5,A
	INC		R0
	MOV		A,@R0
	MOV		R6,A
	INC		R0
	MOV		A,@R0
	MOV		R7,A
	
	; an anderer Stelle zwischengespeicherte Werte für A, B und R0 einsetzen
	MOV		A,backupA
	MOV		B,backupB
	MOV		R0,backupR0
	
	; Flag setzen, dass der Scheduler durchgelaufen ist
	MOV		firstRun,#0xff
	
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
		
		; Prozess Konsole
		MOV		DPTR,#processConsole
		JMP		startProcessIndexFinish
	
	startProcessIndexNot0:
	CJNE	R7,#1,startProcessIndexNot1
		
		; Prozess AusgabeA
		MOV		DPTR,#processAusgabeA
		JMP		startProcessIndexFinish
	
	startProcessIndexNot1:
		
		; Prozess AusgabeB
		MOV		DPTR,#processAusgabeB
	
	startProcessIndexFinish:
	
	MOV		@R1,DPL
	INC		R1
	MOV		@R1,DPH
	
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
		INC		R0
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
	
	; setzt den Eintrag in der Prozesstabelle zurück
	MOV		B,A
	ADD		A,#processTable
	MOV		R0,A
	MOV		@R0,#0
	MOV		A,B
	
	; Scheduler-Interrupt starten
	SETB	TF0
	
RET


END