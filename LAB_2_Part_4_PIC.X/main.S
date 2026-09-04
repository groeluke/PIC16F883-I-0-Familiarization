    ; Luke Groesbeck
    ; RCET3373
    ; First Program
    ; https://github.com/groeluke/PIC16F883-I-0-Familiarization/tree/main/LAB_2_Part_4_PIC.X
    
; PIC16F883 Configuration Bit Settings

; Assembly source line config statements

; CONFIG1
  CONFIG  FOSC = XT             ; Oscillator Selection bits (XT oscillator: Crystal/resonator on RA6/OSC2/CLKOUT and RA7/OSC1/CLKIN)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled and can be enabled by SWDTEN bit of the WDTCON register)
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  MCLRE = ON            ; RE3/MCLR pin function select bit (RE3/MCLR pin function is MCLR)
  CONFIG  CP = OFF              ; Code Protection bit (Program memory code protection is disabled)
  CONFIG  CPD = OFF             ; Data Code Protection bit (Data memory code protection is disabled)
  CONFIG  BOREN = OFF           ; Brown Out Reset Selection bits (BOR disabled)
  CONFIG  IESO = OFF            ; Internal External Switchover bit (Internal/External Switchover mode is disabled)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is disabled)
  CONFIG  LVP = OFF             ; Low Voltage Programming Enable bit (RB3 pin has digital I/O, HV on MCLR must be used for programming)

; CONFIG2
  CONFIG  BOR4V = BOR40V        ; Brown-out Reset Selection bit (Brown-out Reset set to 4.0V)
  CONFIG  WRT = OFF             ; Flash Program Memory Self Write Enable bits (Write protection off)

; config statements should precede project file includes.
#include <xc.inc>

; Reset Vector at 0000h. Execution starts here after reset.
PSECT resetVect,class=CODE,delta=2
ResetVector: 
    goto Setup


; Main code section starts at 0008h. User code goes here.
PSECT code,class=CODE,delta=2
 
Setup:
    ; add device setup here
    
    ;       Bank 0
    BCF 0x03,6  ;Set Bank 0
    BCF 0x03,5  ;Set Bank 0
    CLRF 0x06   ;Setting PortB on reset low known
    CLRF 0x07   ;Set PortC on reset to LOW
    
    ;       Bank 1
    BCF 0x03,6  ;Set Bank 1
    BSF 0x03,5  ;Set Bank 1
    CLRF 0x0B   ;Set INTCON low to remove interrupt flags 
    CLRF 0x87   ;Set PortC as an Output TRISC
    MOVLW 0xF0  ;Make RB0-RB3 outputs for the rows and RB4-RB7 inputs for the colums
    MOVWF 0x86  ;Setting PortB I/O from TRISB
    BCF 0x81,7  ; Make PortB have weak pull-ups OPTION_REG 
    
    ;       Bank 2
    ;BSF 0x03,6  ;Set Bank 2
    ;BCF 0x03,5  ;Set Bank 2
    
    ;       Bank 3
    BSF 0x03,6  ;Set Bank 3
    BSF 0x03,5  ;Set Bank 3
    CLRF 0x89   ;Setting the I/O to digital PortB ANSELH
    
    GOTO Main
    
    
    Main:
	; main code goes here
	CLRF 0x20    ;Clear register lower keys is set low
	CLRF 0x21    ;Clear register higher keys is set low
	
	;    Sacn Row 1 (RB0) 
	BCF 0x03,6   ;Set Bank 1
	BSF 0x03,5   ;Set Bank 1
	MOVLW 0xFE   ;RB0 output is low, RB1-RB7 input
	MOVWF 0x86   ;Send W to PortB
        BCF 0x03,6   ;Set Bank 0
        BCF 0x03,5   ;Set Bank 0

        BTFSS 0x06,4    ;Check Column 1 for 1
        BSF 0x20,1      ;Set test 1 high if selected
        BTFSS 0x06,5    ;Check Column 2 for 2
        BSF 0x20,2      ;Set test 2 high if selected
        BTFSS 0x06,6    ;Check Column 3 for 3
        BSF 0x20,3      ;Set test 3 high if selected
        BTFSS 0x06,7    ;Check Column 4 for A
        BSF 0x21,2      ;Set test A high if selected

        ;   Scan Row 2 (RB1)
        BCF 0x03,6      ;Set Bank 1
        BSF 0x03,5      ;Set Bank 1
        MOVLW 0xFD      ;RB1 output-low, rest input
        MOVWF 0x86      ;Send W to PortB
        BCF 0x03,6      ;Set Bank 0
        BCF 0x03,5      ;Set Bank 0

        BTFSS 0x06,4    ;Check Column 1 for 4
        BSF 0x20,4      ;Set test 4 high if selected
        BTFSS 0x06,5    ;Check Column 2 for 5
        BSF 0x20,5      ;Set test 5 high if selected
        BTFSS 0x06,6    ;Check Column 3 for 6
        BSF 0x20,6      ;Set test 6 high if selected
        BTFSS 0x06,7    ;Check Column 4 for B
        BSF 0x21,3      ;Set test B high if selected

        ;   Scan Row 3 (RB2) 
        BCF 0x03,6      ;Set Bank 1
        BSF 0x03,5      ;Set Bank 1
        MOVLW 0xFB      ;RB2 output-low, rest input
        MOVWF 0x86      ;Send W to PortB
        BCF 0x03,6      ;Set Bank 0
        BCF 0x03,5      ;Set Bank 0

        BTFSS 0x06,4    ;Check Column 1 for 7
        BSF 0x20,7      ;Set test 7 high if selected
        BTFSS 0x06,5    ;Check Column 2 for 8
        BSF 0x21,0      ;Set test 8 high if selected
        BTFSS 0x06,6    ;Check Column 3 for 9
        BSF 0x21,1      ;Set test 9 high if selected
        BTFSS 0x06,7    ;Check Column 4 for C
        BSF 0x21,4      ;Set test C high if selected

        ;   Scan Row 4 (RB3)
        BCF 0x03,6      ;Set Bank 1
        BSF 0x03,5      ;Set Bank 1
        MOVLW 0xF7      ;RB3 output-low, rest input
        MOVWF 0x86      ;Send W to PortB
        BCF 0x03,6      ;Set Bank 0
        BCF 0x03,5      ;Set Bank 0

        BTFSS 0x06,4    ;Check Column 1 for *
        BSF 0x21,6      ;Set test * high if selected
        BTFSS 0x06,5    ;Check Column 2 for 0
        BSF 0x20,0      ;Set test 0 high if selected
        BTFSS 0x06,6    ;Check Column 3 for #
        BSF 0x21,7      ;Set test # high if selected
        BTFSS 0x06,7    ;Check Column 4 for D
        BSF 0x21,5      ;Set test D high if selected

        ;Set TRISB (all rows Hi-Z) before testing 
        BCF 0x03,6      ;Set Bank 1
        BSF 0x03,5      ;Set Bank 1
        MOVLW 0xF0      ;Reset TrisB for all the I/O
        MOVWF 0x86      ;Send W to PortB
        BCF 0x03,6      ;Set Bank 0
        BCF 0x03,5      ;Set Bank 0

        GOTO TestHash


    TestHash:
    BTFSS 0x21,7    ;Test if # is pressed 
    GOTO TestStar   ;GOTO Test for *
    GOTO DisplayHash;GOTO the Display for #

    TestStar:
    BTFSS 0x21,6    ;Test if * is pressed 
    GOTO TestD      ;GOTO Test for D
    GOTO DisplayStar;GOTO the Display for *

    TestD:
    BTFSS 0x21,5    ;Test if D is pressed 
    GOTO TestC      ;GOTO Test for C
    GOTO DisplayD   ;GOTO the Display for D
    
    TestC:
    BTFSS 0x21,4    ;Test if C is pressed 
    GOTO TestB      ;GOTO Test for B
    GOTO DisplayC   ;GOTO the Display for C

    TestB:
    BTFSS 0x21,3    ;Test if B is pressed 
    GOTO TestA      ;GOTO Test for A
    GOTO DisplayB   ;GOTO the Display for B

    TestA:
    BTFSS 0x21,2    ;Test if A is pressed 
    GOTO Test9      ;GOTO Test for 9
    GOTO DisplayA   ;GOTO the Display for A

    Test9:
    BTFSS 0x21,1    ;Test if 9 is pressed 
    GOTO Test8      ;GOTO Test for 8
    GOTO Display9   ;GOTO the Display for 9

    Test8:
    BTFSS 0x21,0    ;Test if 8 is pressed 
    GOTO Test7      ;GOTO Test for 7
    GOTO Display8   ;GOTO the Display for 8

    Test7:
    BTFSS 0x20,7    ;Test if 7 is pressed 
    GOTO Test6      ;GOTO Test for 6
    GOTO Display7   ;GOTO the Display for 7

    Test6:
    BTFSS 0x20,6    ;Test if 6 is pressed 
    GOTO Test5      ;GOTO Test for 5
    GOTO Display6   ;GOTO the Display for 6

    Test5:
    BTFSS 0x20,5    ;Test if 5 is pressed 
    GOTO Test4      ;GOTO Test for 4
    GOTO Display5   ;GOTO the Display for 5

    Test4:
    BTFSS 0x20,4    ;Test if 4 is pressed 
    GOTO Test3      ;GOTO Test for 3
    GOTO Display4   ;GOTO the Display for 4

    Test3:
    BTFSS 0x20,3    ;Test if 3 is pressed 
    GOTO Test2      ;GOTO Test for 2
    GOTO Display3   ;GOTO the Display for 3

    Test2:
    BTFSS 0x20,2    ;Test if 2 is pressed 
    GOTO Test1      ;GOTO Test for 1
    GOTO Display2   ;GOTO the Display for 2

    Test1:
    BTFSS 0x20,1    ;Test if 1 is pressed 
    GOTO Test0      ;GOTO the Display for 0
    GOTO Display1   ;GOTO the Display for 1

    Test0:
    BTFSS 0x20,0    ;Test if 0 is pressed 
    GOTO DisplayDal ;GOTO the Display for $
    GOTO Display0   ;GOTO the Display for 0
    
    DisplayDal:
    MOVLW 0x24      ;Select the character set for display $ or whatever
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    DisplayHash:
    MOVLW 0x23      ;Select the character set for display #
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    DisplayStar:
    MOVLW 0x2A      ;Select the character set for display *
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    DisplayD:
    MOVLW 0x44      ;Select the character set for display D
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    DisplayC:
    MOVLW 0x43      ;Select the character set for display C
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    DisplayB:
    MOVLW 0x42      ;Select the character set for display B
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    DisplayA:
    MOVLW 0x41      ;Select the character set for display A
    MOVWF 0x07      ;Send W to PortC
    GOTO Main
    
    Display9:
    MOVLW 0x39      ;Select the character set for display 9
    MOVWF 0x07      ;Send W to PortC
    GOTO Main

    Display8:
    MOVLW 0x38      ;Select the character set for display 8
    MOVWF 0x07      ;Send W to PortC
    GOTO Main

    Display7:
    MOVLW 0x37      ;Select the character set for display 7
    MOVWF 0x07      ;Send W to PortC
    GOTO Main

    Display6:
    MOVLW 0x36      ;Select the character set for display 6
    MOVWF 0x07      ;Send W to PortC
    GOTO Main

    Display5:
    MOVLW 0x35      ;Select the character set for display 5
    MOVWF 0x07      ;Send W to PortC
    GOTO Main

    Display4:
    MOVLW 0x34      ;Select the character set for display 4
    MOVWF 0x07      ;Send W to PortC
    GOTO Main

    Display3:
    MOVLW 0x33      ;Select the character set for display 3
    MOVWF 0x07      ;Send W to PortC
    GOTO Main

    Display2:
    MOVLW 0x32      ;Select the character set for display 2
    MOVWF 0x07      ;Send W to PortC
    GOTO Main

    Display1:
    MOVLW 0x31      ;Select the character set for display 1
    MOVWF 0x07      ;Send W to PortC
    GOTO Main

    Display0:
    MOVLW 0x30      ;Select the character set for display 0
    MOVWF 0x07      ;Send W to PortC
    GOTO Main

    GOTO Main
	
    End