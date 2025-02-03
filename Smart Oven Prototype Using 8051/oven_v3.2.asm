   	ORG  00H 
   	RS  EQU P0.0 
   	RW  EQU P0.1 
   	E  EQU P0.2
   	KP_PORT EQU P3
   	SEVEN_SEG_PORT EQU P2
   	LJMP MAIN
   
        ORG 30H
MAIN:   MOV  SP, #80H 
        MOV  PSW, #00H
        MOV SEVEN_SEG_PORT,#00H ;MAKING 7 SEGMENT DISPLAY PORT AS OUTPUT
        CLR P0.3;MAKING THE CONTROL PINS FOR 7 SEGMENT AS OUTPUTS
        CLR P0.4
        CLR P0.5
        CLR P0.6; MAKING THE BUZZER AS OUPUT PORT
        MOV R0,#70H ; POINTER FOR STORING THE TIME IN SECONDS
        MOV R5,#0 ; TRACKING HOW MANY NUMEBRS COUNTED
        MOV IE,#10000000B ;ACTIVATING RESET INTERRUPT
        
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
   
	     MOV DPTR,#INTITIAL_MSG_PROMPT1
INITIAL_MSG1:CLR A
    	     MOVC A,@A+DPTR
	     JZ FINISH_INITIAL_MSG1
	     LCALL DATAWRT
	     LCALL DELAY
	     INC DPTR
	     SJMP INITIAL_MSG1

FINISH_INITIAL_MSG1:MOV DPTR,#INTITIAL_MSG_PROMPT2
		    MOV A,#0C0H; NEXT LINE
          	    LCALL COMNWRT
INITIAL_MSG2:CLR A
    	     MOVC A,@A+DPTR
	     JZ KEYBOARD_STARTS
	     LCALL DATAWRT
	     LCALL DELAY
	     INC DPTR
	     SJMP INITIAL_MSG2
 	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Keyboard starts;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
KEYBOARD_STARTS:MOV KP_PORT,#0FH
K1:CLR KP_PORT.7; WILL BE USD FOR LED OUTPUT
   CLR KP_PORT.6
   CLR KP_PORT.5
   CLR KP_PORT.4
   MOV A,KP_PORT
   ANL A,#00001111B
   CJNE A,#00001111B,K1
   
;CONFIGURING PUSH BUTTONS     
K2:LCALL DELAY
   MOV A,KP_PORT
   ANL A,#00001111B
   CJNE A,#00001111B,OVER
   SJMP K2
   
OVER:LCALL DELAY
     MOV A,KP_PORT
     ANL A,#00001111B
     CJNE A,#00001111B,OVER1
     SJMP K2 
   
OVER1:CLR KP_PORT.6
      SETB KP_PORT.7
      SETB KP_PORT.5
      SETB KP_PORT.4
      MOV A,KP_PORT
      ANL A,#00001111B
      CJNE A,#00001111B,ROW_0
      
      CLR KP_PORT.5
      SETB KP_PORT.6
      SETB KP_PORT.4
      MOV A,KP_PORT
      ANL A,#00001111B
      CJNE A,#00001111B,ROW_1
      
      CLR KP_PORT.4
      SETB KP_PORT.6
      SETB KP_PORT.5
      MOV A,KP_PORT
      ANL A,#00001111B
      CJNE A,#00001111B,ROW_2
      
ROW_0:MOV DPTR,#KCODE0
      SJMP FIND
ROW_1:MOV DPTR,#KCODE1
      SJMP FIND
ROW_2:MOV DPTR,#KCODE2
      SJMP FIND
      
FIND: RRC A
      JNC MATCH
      INC DPTR 
      SJMP FIND
      
MATCH:  CLR PSW.3 ;MAKING SURE REGISTER BANK 0 KEEPS SELECTED
        CLR PSW.4
        CLR A 
        MOVC A,@A+DPTR
        LCALL DATAWRT
        
        CLR A
        MOVC A,@A+DPTR ;AGAIN BRINGING THE NUMBER TO A IF GETS MODIFIED
        CJNE A,#'C',CHECK_START_BUTTON
        LJMP MAIN
        
CHECK_START_BUTTON: CJNE A,#'S',NEXT_KEY_PRESS
       		    SJMP START_BAKING       
	
 
NEXT_KEY_PRESS:CLR C
       	       SUBB A,#30H
   	       MOV @R0,A ; STORING THE TIME DIGITS STARTING FROM 70H
   	       INC R0
    	       LJMP K1                      
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;KEYPAD ENDS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;COUNTER STARTS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
START_BAKING:	   SETB KP_PORT.7; USED FOR LED
		   MOV R2,72H;LSB
 		   MOV R3,71H
		   MOV R4,70H;MSB
		   LJMP LOOP1

	  LOOP3:   CJNE R4,#0,CONTINUE_LOOP3
	           LJMP FINISHED_BAKING
CONTINUE_LOOP3:    DEC R4
		   MOV R3,#9H
		   MOV R2,#9H
		   INC R5
		   SJMP LOOP1
  
	LOOP2:     CJNE R3,#0,CONTINUE_LOOP2
                   SJMP LOOP3 
CONTINUE_LOOP2:	   DEC R3
		   MOV R2,#9H
		   INC R5

	  LOOP1:   MOV A,R5
		   MOV B,#20
		   DIV AB;CHECKING 20S INTERVAL FOR PRINTING MESSAGE
		   MOV R1,B; BRINGING REMAINDER IN R1 FOR CHECKING
		   CJNE R1,#0,CONT_LOOP1
		   LCALL PRINT_MESSAGE ;PRINTS MESSAGEIF DIVIDES BY 20
		   
CONT_LOOP1:	  LCALL SHOW_7SEG; NO NEED TO PRINT MESSAGE
		  
	          CJNE R2,#0,CONTINUE_LOOP1
	     	  SJMP LOOP2
CONTINUE_LOOP1:	  DEC R2
		  INC R5;TRACKING HOW MANY NUMBERS COUNTED
		  SJMP LOOP1
	  
FINISHED_BAKING:CLR P0.3 ;KEEPING ALL THE 7 SEGMENT ON AFTER COUNT DOWN FINISHES
		CLR P0.4
		CLR P0.5
		SETB P0.6 ;BUZZER
		CLR KP_PORT.7; USED FOR LED  
		SJMP FINISHED_BAKING
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;COUNTER ENDS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
       MOV  R3, #2   
HERE2: MOV  R4, #255   
HERE:  DJNZ  R4, HERE   
       DJNZ   R3, HERE2
       CLR PSW.3
       CLR PSW.4 
       RET
       
;CREATING 1ms DELAY:       
SMALL_DELAY: SETB PSW.3
      	     SETB PSW.4  
	     MOV  R3, #4   
HERE4: 	     MOV  R4, #132   
HERE3: 	     DJNZ  R4, HERE3   
	     DJNZ   R3, HERE4
       	     CLR PSW.3
       	     CLR PSW.4 
     	     RET
      
;THIS FUNCTION WILL SHOW CONTENTS OF R2,R3,R4 IN THE 7 SEGMENT DISPLAY FOR 1S
SHOW_7SEG:	   MOV R7,#5			 ;2 MC
BLOCK_LOOP2:	   MOV R6,#62			 ;2 MC
		   
BLOCK_LOOP1:	   MOV DPTR,#DIGIT_DRIVE_PATTERN ;2 MC
		   SETB P0.3 			; 1MC
		   SETB P0.4			 ;1 MC
		   CLR P0.5;FOR LSB	         ;1 MC
		   MOV A,R2		         ;1 MC
		   MOVC A,@A+DPTR		 ; 2MC
		   MOV SEVEN_SEG_PORT,A          ;1 MC
		   ACALL SMALL_DELAY	         ;1075 MC
		   
		   SETB P0.3 
		   SETB P0.5
		   CLR P0.4;FOR MID BIT
		   MOV A,R3
		   MOVC A,@A+DPTR
		   MOV SEVEN_SEG_PORT,A
		   ACALL SMALL_DELAY
		   
		   SETB P0.5
		   SETB P0.4
		   CLR P0.3;FOR MSB
		   MOV A,R4
		   MOVC A,@A+DPTR
		   MOV SEVEN_SEG_PORT,A
		   ACALL SMALL_DELAY
		   
		   DJNZ R6,BLOCK_LOOP1  ;2 MC
		   DJNZ R7,BLOCK_LOOP2	;2 MC	
		   RET			;TOTAL 3267 MC FOR EXECUTING THE BLOCK 1 TIME. SO EXECUTING THIS BLOCK 310 TIMES WILL MAKE AROUND 1S
		   
;THIS FUNCTION WILL PRINT MESSAGE ACCORDING TO CERTAIN CONDITION AND STATE
      FINISH_MSG:     LJMP FINISH_MSG_ULTIMATE ;TEMPORARY LABEL TO AVOID OUT OF RANGE ERROR
SHOW_OWN_MESSAGE_TEMP:LJMP SHOW_OWN_MESSAGE ;TEMPORARY LABEL TO AVOID OUT OF RANGE ERROR
      
PRINT_MESSAGE:	   PUSH 0E0H; TEMPORARY STORING THE DIVIDEND IN A
		   MOV A,#01H;CLEARING THE DISPLAY
		   LCALL COMNWRT

		   CLR C ;CHECKING IF NUMBER WAS GREATER THAN 60 OR NOT
		   MOV A,71H
		   SUBB A,#6H
		   JNC SHOW_FACTS; IF MID BIT IS GREATER THAN OR EQUAL TO 6 THAN TIME WAS MORE THAN 60S
		   CLR C
		   MOV A,70H; CHECKING MSB
		   CJNE A,#0,SHOW_FACTS; IF MSB IS NOT EUALS TO 0 THAN ALSO TIME IS GREATER THAN 60
		   SJMP SHOW_OWN_MESSAGE_TEMP ; TIME LESS THAN 60S

    SHOW_FACTS:	   POP 73H ; RESTORING THE DIVIDEND IN RAM 73H																																																																																																												
		   MOV A,73H ;BRINGING THE DIVIDEND IN A
           
		   CJNE A,#0,CHECK_FACT1
		   MOV DPTR,#FACT0
       FACT0_MSG:  CLR A
	           MOVC A,@A+DPTR
		   JZ FINISH_MSG
	           LCALL DATAWRT
	           LCALL DELAY
		   INC DPTR
		   SJMP FACT0_MSG

      CHECK_FACT1: CJNE A,#1,CHECK_FACT2
		   MOV DPTR,#FACT1
	FACT1_MSG: CLR A
		   MOVC A,@A+DPTR
		   JZ FINISH_MSG
		   LCALL DATAWRT
		   LCALL DELAY
		   INC DPTR
		   SJMP FACT1_MSG

      CHECK_FACT2: CJNE A,#2,CHECK_FACT3
		   MOV DPTR,#FACT2
	FACT2_MSG: CLR A
	           MOVC A,@A+DPTR
	           JZ FINISH_MSG
	           LCALL DATAWRT
	           LCALL DELAY
	           INC DPTR
	           SJMP FACT2_MSG

      CHECK_FACT3: CJNE A,#3,CHECK_FACT4
      	           MOV DPTR,#FACT3
       FACT3_MSG:  CLR A
       		   MOVC A,@A+DPTR
       		   JZ FINISH_MSG
       		   LCALL DATAWRT
       		   LCALL DELAY
       		   INC DPTR
       		   SJMP FACT3_MSG

      CHECK_FACT4: CJNE A,#4,CHECK_FACT5
		   MOV DPTR,#FACT4
	FACT4_MSG: CLR A
		   MOVC A,@A+DPTR
TMP_FNS_MSG_LBL1:  JZ FINISH_MSG ;USING INTERMEDIATE LABEL FOR FINISHED MESSAGES BELOW
		   LCALL DATAWRT
		   LCALL DELAY
		   INC DPTR
		   SJMP FACT4_MSG

      CHECK_FACT5: CJNE A,#5,CHECK_FACT6
		   MOV DPTR,#FACT5
        FACT5_MSG: CLR A
        	   MOVC A,@A+DPTR
        	   JZ TMP_FNS_MSG_LBL1
        	   LCALL DATAWRT
        	   LCALL DELAY
        	   INC DPTR
        	   SJMP FACT5_MSG

      CHECK_FACT6: CJNE A,#6,CHECK_FACT7
	           MOV DPTR,#FACT6
	FACT6_MSG: CLR A
	           MOVC A,@A+DPTR
	           JZ TMP_FNS_MSG_LBL1
	           LCALL DATAWRT
	           LCALL DELAY
	           INC DPTR
	           SJMP FACT6_MSG

      CHECK_FACT7: CJNE A,#7,CHECK_FACT8
	           MOV DPTR,#FACT7
        FACT7_MSG: CLR A
                   MOVC A,@A+DPTR
                   JZ TMP_FNS_MSG_LBL1
                   LCALL DATAWRT
                   LCALL DELAY
                   INC DPTR
                   SJMP FACT7_MSG

      CHECK_FACT8: CJNE A,#8,CHECK_FACT9
		   MOV DPTR,#FACT8
	FACT8_MSG: CLR A
	           MOVC A,@A+DPTR
	           JZ TMP_FNS_MSG_LBL1
	           LCALL DATAWRT
	           LCALL DELAY
	           INC DPTR
	           SJMP FACT8_MSG

      CHECK_FACT9: CJNE A,#9,CHECK_FACT10
		   MOV DPTR,#FACT9
	FACT9_MSG: CLR A
		   MOVC A,@A+DPTR
		   JZ TMP_FNS_MSG_LBL1
		   LCALL DATAWRT
		   LCALL DELAY
		   INC DPTR
		   SJMP FACT9_MSG

     CHECK_FACT10: CJNE A,#10,CHECK_FACT11
		   MOV DPTR,#FACT10
       FACT10_MSG: CLR A
       	           MOVC A,@A+DPTR
TMP_FNS_MSG_LBL2:  JZ TMP_FNS_MSG_LBL1
       	           LCALL DATAWRT
       	           LCALL DELAY
       	           INC DPTR
       	           SJMP FACT10_MSG

     CHECK_FACT11: CJNE A,#11,CHECK_FACT12
		   MOV DPTR,#FACT11
       FACT11_MSG: CLR A
	           MOVC A,@A+DPTR
	           JZ TMP_FNS_MSG_LBL2
	           LCALL DATAWRT
	           LCALL DELAY
	           INC DPTR
	           SJMP FACT11_MSG

    CHECK_FACT12: CJNE A,#12,CHECK_FACT13
		  MOV DPTR,#FACT12
      FACT12_MSG: CLR A
	          MOVC A,@A+DPTR
	          JZ TMP_FNS_MSG_LBL2
	          LCALL DATAWRT
	          LCALL DELAY
	          INC DPTR
	          SJMP FACT12_MSG

    CHECK_FACT13: CJNE A,#13,CHECK_FACT14
		  MOV DPTR,#FACT13
      FACT13_MSG: CLR A
      		  MOVC A,@A+DPTR
      		  JZ FINISH_MSG_ULTIMATE
      		  LCALL DATAWRT
      		  LCALL DELAY
      		  INC DPTR
      		  SJMP FACT13_MSG

   CHECK_FACT14: CJNE A,#14,CHECK_FACT15
		 MOV DPTR,#FACT14
     FACT14_MSG: CLR A
     		 MOVC A,@A+DPTR
     		 JZ FINISH_MSG_ULTIMATE
     		 LCALL DATAWRT
     		 LCALL DELAY
     		 INC DPTR
     		 SJMP FACT14_MSG

   CHECK_FACT15: CJNE A,#15,NO_MORE_FACTS
		 MOV DPTR,#FACT15
     FACT15_MSG: CLR A
	         MOVC A,@A+DPTR
	         JZ FINISH_MSG_ULTIMATE
	         LCALL DATAWRT
	         LCALL DELAY
	         INC DPTR
	         SJMP FACT15_MSG

NO_MORE_FACTS:  MOV DPTR,#NO_MORE_FACT_MSG
   NO_FACT_MSG: CLR A
   		MOVC A,@A+DPTR
   		JZ FINISH_MSG_ULTIMATE
   		LCALL DATAWRT
   		LCALL DELAY
   		INC DPTR
   		SJMP NO_FACT_MSG                
		

SHOW_OWN_MESSAGE: POP 73H ;RESTORING THE DIVIDEND
		  MOV A,73H
		  
		  CJNE A,#0,CHECK_MY_MSG1
		  MOV DPTR,#MY_MSG0
     MY_MSG0_MSG: CLR A
	          MOVC A,@A+DPTR
	          JZ FINISH_MSG_ULTIMATE
	          LCALL DATAWRT
	          LCALL DELAY
	          INC DPTR
	          SJMP MY_MSG0_MSG

   CHECK_MY_MSG1: CJNE A,#1,CHECK_MY_MSG2
		  MOV DPTR,#MY_MSG1
     MY_MSG1_MSG: CLR A
     		  MOVC A,@A+DPTR
     		  JZ FINISH_MSG_ULTIMATE
     		  LCALL DATAWRT
     		  LCALL DELAY
     		  INC DPTR
     		  SJMP MY_MSG1_MSG

   CHECK_MY_MSG2: CJNE A,#2,FINISH_MSG_ULTIMATE
		  MOV DPTR,#MY_MSG2
     MY_MSG2_MSG: CLR A
     	          MOVC A,@A+DPTR
     	          JZ FINISH_MSG_ULTIMATE
     	          LCALL DATAWRT
     	          LCALL DELAY
     	          INC DPTR
     	          SJMP MY_MSG2_MSG

FINISH_MSG_ULTIMATE:RET

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;LOOK UP TABLES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Q
;ASCII LOOK-UP TABLE FOR EACH ROW  
KCODE0: DB '4','3','2','1'    ;ROW 0 
KCODE1: DB '8','7','6','5'    ;ROW 1 
KCODE2: DB 'C','S','0','9'    ;ROW 2   

DIGIT_DRIVE_PATTERN: DB 3FH, 06H,5BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH

INTITIAL_MSG_PROMPT1: DB 'TIME IN SECONDS(',0
INTITIAL_MSG_PROMPT2: DB 'IN 3 DIGITS):',0

FACT0: DB 'Klopp is German',0
FACT1: DB 'Klopp loves hugs',0
FACT2: DB 'Reds wear red',0
FACT3: DB 'LFC has 8FA Cups',0
FACT4: DB 'LFC motto: YNWA ',0
FACT5: DB 'Gerrard is icon',0
FACT6: DB 'Salah is star',0
FACT7: DB 'Rival: Man Utd ',0
FACT8: DB 'Anfield is home',0
FACT9: DB 'LFC 19 titles',0
FACT10: DB 'YNWA since 1900',0
FACT11: DB 'Anfield Kop',0
FACT12: DB 'LFC owns 6 CL',0
FACT13: DB 'Klopp loves LFC',0
FACT14: DB 'LFC founded 1892',0
FACT15: DB 'Famous Reds kit',0

NO_MORE_FACT_MSG: DB 'BEYOND 300S',0

MY_MSG0: DB 'C > ASSEMBLY',0
MY_MSG1: DB 'LONGEST SEMESTER',0 
MY_MSG2: DB 'VERY TIRED',0

END 