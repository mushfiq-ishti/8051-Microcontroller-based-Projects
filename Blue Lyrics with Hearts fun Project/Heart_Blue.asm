   	ORG  00H 
   	RS  EQU P0.0 
   	RW  EQU P0.1 
   	E  EQU P0.2
   	LCD_COL EQU P3
   	LCD_ROW EQU P2
   	LJMP MAIN
   
        ORG 30H
MAIN:   MOV  SP, #80H 
        MOV  PSW, #00H
        MOV LCD_COL,#00H
        MOV LCD_ROW,#00H 
        
        
LCD_IN: MOV  A, #38H   ;init. LCD 2 lines, 5x7 matrix 
   	ACALL COMNWRT   ;call command subroutine 
   	ACALL  DELAY   ;give LCD some time 
   	MOV   A, #0FH   ;dispplay on, cursor on 
   	ACALL COMNWRT   ;call command subroutine 
   	ACALL  DELAY   ;give LCD some time 
   	MOV  A, #01    ;clear LCD 
   	ACALL COMNWRT   ;call command subroutine 
   	ACALL  DELAY   ;give LCD some time 
   	MOV  A, #06H   ;shift cursor right 
   	ACALL COMNWRT   ;call command subroutine 
   	ACALL  DELAY   ;give LCD some time 
   	MOV  A, #80H   ;cursor at line 1 postion 4 
   	ACALL COMNWRT   ;call command subroutine 
   	ACALL  DELAY   ;give LCD some time

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CHECKING MATRIX DISPLAY;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV LCD_ROW,#00000000B
MOV LCD_COL,#11111111B

LCALL DELAY_1S
LCALL DELAY_1S
LCALL DELAY_1S
LCALL DELAY_1S
LCALL DELAY_1S
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;BLUE INITIAL LYRICS START;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
	     MOV DPTR,#BLUE_LYRICS_11
     BLUE11: CLR A
    	     MOVC A,@A+DPTR
	     JZ FINISH_BLUE11
	     LCALL DATAWRT
	     LCALL DELAY
	     INC DPTR
	     SJMP BLUE11

FINISH_BLUE11:MOV DPTR,#BLUE_LYRICS_12
              MOV A,#0C0H; NEXT LINE
              LCALL COMNWRT
     BLUE12: CLR A
    	     MOVC A,@A+DPTR
	     JZ WAIT_1
	     LCALL DATAWRT
	     LCALL DELAY
	     INC DPTR
	     SJMP BLUE12
	     
WAIT_1:	    LCALL DELAY_1S
	    MOV A,#01H
	    LCALL COMNWRT
	    
	     MOV DPTR,#BLUE_LYRICS_21
     BLUE21: CLR A
    	     MOVC A,@A+DPTR
	     JZ FINISH_BLUE21
	     LCALL DATAWRT
	     LCALL DELAY
	     INC DPTR
	     SJMP BLUE21

FINISH_BLUE21:MOV DPTR,#BLUE_LYRICS_22
              MOV A,#0C0H; NEXT LINE
              LCALL COMNWRT
     BLUE22: CLR A
    	     MOVC A,@A+DPTR
	     JZ WAIT_2
	     LCALL DATAWRT
	     LCALL DELAY
	     INC DPTR
	     SJMP BLUE22
	     
WAIT_2:	    LCALL DELAY_1S
	    MOV A,#01H
	    LCALL COMNWRT
	    
     MOV DPTR,#BLUE_LYRICS_31
     BLUE31: CLR A
    	     MOVC A,@A+DPTR
	     JZ FINISH_BLUE31
	     LCALL DATAWRT
	     LCALL DELAY
	     INC DPTR
	     SJMP BLUE31

FINISH_BLUE31:MOV DPTR,#BLUE_LYRICS_32
              MOV A,#0C0H; NEXT LINE
              LCALL COMNWRT
     BLUE32: CLR A
    	     MOVC A,@A+DPTR
	     JZ FINISH_BLUE32
	     LCALL DATAWRT
	     LCALL DELAY
	     INC DPTR
	     SJMP BLUE32
	     
 FINISH_BLUE32:LCALL DELAY_1S	
 	       MOV DPTR,#BLUE_LYRICS_33
               MOV A,#01H
               LCALL COMNWRT
 
 BLUE33:     CLR A
    	     MOVC A,@A+DPTR
	     JZ FINISH_BLUE33
	     LCALL DATAWRT
	     LCALL DELAY
	     INC DPTR
	     SJMP BLUE33
	     
FINISH_BLUE33:	MOV DPTR,#BLUE_LYRICS_34
              MOV A,#0C0H
              LCALL COMNWRT
 
 BLUE34:     CLR A
    	     MOVC A,@A+DPTR
	     JZ FINISH_BLUE34
	     LCALL DATAWRT
	     LCALL DELAY
	     INC DPTR
	     SJMP BLUE34
	     
FINISH_BLUE34: LCALL DELAY_1S
	       LCALL DELAY_1S
	       LCALL DELAY_1S
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;BLUE INITIAL LYRICS END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;START MAKING HEARTS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MAKE_HEART: 
	     MOV R3,#25
MAKE_HEART1: MOV DPTR,#HEART_1
   	     MOV R2,#8
	     MOV LCD_COL,#11111110B
	     
HEART1_L1:   CLR A
	     MOVC A,@A+DPTR	
	     MOV LCD_ROW,A
	     LCALL SMALL_DELAY
	     MOV A,LCD_COL
	     RL A
	     MOV LCD_COL,A
	     INC DPTR
	     DJNZ R2,HEART1_L1
	     DJNZ R3,MAKE_HEART1
	     
	     MOV R3,#25
MAKE_HEART2: MOV DPTR,#HEART_2
   	     MOV R2,#8
	     MOV LCD_COL,#11111110B
	     
HEART1_L2:   CLR A
	     MOVC A,@A+DPTR	
	     MOV LCD_ROW,A
	     LCALL SMALL_DELAY
	     MOV A,LCD_COL
	     RL A
	     MOV LCD_COL,A
	     INC DPTR
	     DJNZ R2,HEART1_L2
	     DJNZ R3,MAKE_HEART2
	     
	     MOV R3,#25
MAKE_HEART3: MOV DPTR,#HEART_3
   	     MOV R2,#8
	     MOV LCD_COL,#11111110B
	     
HEART1_L3:   CLR A
	     MOVC A,@A+DPTR	
	     MOV LCD_ROW,A
	     LCALL SMALL_DELAY
	     MOV A,LCD_COL
	     RL A
	     MOV LCD_COL,A
	     INC DPTR
	     DJNZ R2,HEART1_L3
	     DJNZ R3,MAKE_HEART3
	     
	     MOV R3,#25
MAKE_HEART4: MOV DPTR,#HEART_4
   	     MOV R2,#8
	     MOV LCD_COL,#11111110B
	     
HEART1_L4:   CLR A
	     MOVC A,@A+DPTR	
	     MOV LCD_ROW,A
	     LCALL SMALL_DELAY
	     MOV A,LCD_COL
	     RL A
	     MOV LCD_COL,A
	     INC DPTR
	     DJNZ R2,HEART1_L4
	     DJNZ R3,MAKE_HEART4
	     
	     MOV R3,#25
MAKE_HEART5: MOV DPTR,#HEART_5
   	     MOV R2,#8
	     MOV LCD_COL,#11111110B
	     
HEART1_L5:   CLR A
	     MOVC A,@A+DPTR	
	     MOV LCD_ROW,A
	     LCALL SMALL_DELAY
	     MOV A,LCD_COL
	     RL A
	     MOV LCD_COL,A
	     INC DPTR
	     DJNZ R2,HEART1_L5
	     DJNZ R3,MAKE_HEART5

DONE_HEART:LJMP MAKE_HEART
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;DEFINED FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
COMNWRT: LCALL READY   ;send command to LCD 
   MOV  P1, A    ;copy reg A to port 1 
   CLR  RS    ;RS=0 for command 
   CLR  RW    ;R/W=0 for write 
   SETB  E    ;E-1 for high pulse  
   ACALL DELAY   ;give LCD some time 
   CLR  E    ;E=0 for H-to-L pulse 
   RET 

 
DATAWRT: LCALL READY   ;write data to LCD 
  	 MOV  P1, A    ;copy reg A to port1 
  	 SETB  RS    ;RS=1 for data 
	 CLR  RW    ;R/W=0 for write 
 	 SETB  E    ;E=1 for high pulse 
   	 ;ACALL DELAY   ;give LCD some time 
   	 CLR  E    ;E=0 for H-to-L pulse 
   	 RET 
   
READY:  SETB  P1.7 
   	CLR  RS 
    	SETB  RW 
WAIT:   CLR  E 
   	LCALL DELAY 
   	SETB  E 
   	JB  P1.7, WAIT 
   	RET 
 
DELAY: SETB PSW.3
       SETB PSW.4  
       MOV  R3, #50   ;50 or higher for fast CPUs 
HERE2: MOV  R4, #255   ;R4=255 
HERE:  DJNZ  R4, HERE   ;stay untill R4 becomes 0 
       DJNZ   R3, HERE2
       CLR PSW.3
       CLR PSW.4 
       RET
       
;CREATING 1ms DELAY:       
SMALL_DELAY: SETB PSW.3
      	     SETB PSW.4  
	     MOV  R3, #4   
HERE4: 	     MOV  R4, #132   
HERE3: 	     DJNZ  R4, HERE3   ;stay untill R4 becomes 0 
	     DJNZ   R3, HERE4
       	     CLR PSW.3
       	     CLR PSW.4 
     	     RET

DELAY_1S: SETB PSW.3
          SETB PSW.4 
          MOV R2,#8 	;Z
HERE7:    MOV  R3, #225  ;Y
HERE6:    MOV  R4, #255 ;X   
HERE5:    DJNZ  R4, HERE5   
          DJNZ   R3, HERE6
          DJNZ R2,HERE7
          CLR PSW.3
          CLR PSW.4 
          RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;LOOK UP TABLES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Q
  
BLUE_LYRICS_11: DB 'Its Stuck with',0
BLUE_LYRICS_12: DB 'You Forever..',0
BLUE_LYRICS_21: DB 'So Promise You',0
BLUE_LYRICS_22: DB 'Wont let it Go',0
BLUE_LYRICS_31: DB 'Ill trust the',0
BLUE_LYRICS_32: DB 'universe will',0
BLUE_LYRICS_33: DB 'always Bring ',0
BLUE_LYRICS_34: DB 'Me to You......',0

;LOOK-UP TABLE OF ROWS FOR EACH ANIMATION
HEART_1: DB 00000000B,00000000B,00000000B,00000000B,00011000B,00011000B,00000000B,00000000B
HEART_2: DB 00000000B,00000000B,00000000B,00011000B,00111100B,00111100B,00011000B,00000000B
HEART_3: DB 00000000B,00000000B,01100110B,11111111B,11111111B,01111110B,00111100B,00011000B
HEART_4: DB 00000000B,01100110B,11111111B,11111111B,01111110B,00111100B,00011000B,00000000B
HEART_5: DB 01100110B,11111111B,11111111B,01111110B,00111100B,00011000B,00000000B,00000000B
END 