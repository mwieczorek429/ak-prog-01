	 ORG 800H  
	 LXI H,TEKST1  
	 RST 3  
	 MVI C,0  
INPUT  
	 RST 2  
	 CPI 0DH  
	 JNZ STOS  
	 JMP SUM  
STOS  
	 SUI 48D  
	 PUSH PSW  
	 CALL ISNUMBER  
	 INR C  
	 MOV A,C  
	 STA DLUGOSC  
	 CPI 3  
	 JM INPUT  
	 JMP SUM  
ISNUMBER  
	 STC  
	 CMC  
	 CPI 10D  
	 JNC NULL  
	 RET  
SUM  
	 LDA DLUGOSC  
	 CPI 0  
	 JZ NULL  
	 POP PSW  
	 MOV D,A  
	 LDA DLUGOSC  
	 CPI 1  
	 JZ SHOWHEX  
	 POP PSW  
	 JZ ENDDEC  
	 MOV B,A  
SUMDEC  
	 MOV A,D  
	 ADI 10D  
	 MOV D,A  
	 DCR B  
	 MOV A,B  
	 CPI 0D  
	 JNZ SUMDEC  
ENDDEC 	 LDA DLUGOSC  
	 CPI 2  
	 JZ SHOWHEX  
	 POP PSW  
	 JZ SHOWHEX  
	 MOV B,A  
SUMHUN  
	 MOV A,D  
	 ADI 100D  
	 JC FULL  
	 MOV D,A  
	 DCR B  
	 MOV A,B  
	 CPI 0D  
	 JNZ SUMHUN  
SHOWHEX  
	 LXI H,TEKST2  
	 RST 3  
	 MOV A,D  
	 RST 4  
	 MVI A,'h'  
	 RST 1  
SHOWBIN  
	 LXI H,TEKST3  
	 RST 3  
	 MOV A,D  
	 MVI C,8D  
LOOPBIN  
	 RAL  
	 CNC SHOWZERO  
	 CC SHOWONE  
	 DCR C  
	 JNZ LOOPBIN  
	 JMP END  
SHOWZERO  
	 MOV B,A  
	 MVI A,'0'  
	 RST 1  
	 MOV A,B  
	 RET  
SHOWONE  
	 MOV B,A  
	 MVI A,'1'  
	 RST 1  
	 MOV A,B  
	 RET  
END  
	 HLT  
FULL  
	 LXI H,TEKST5  
	 RST 3  
	 HLT  
NULL  
	 LXI H,TEKST4  
	 RST 3  
	 HLT  
;Pola z danymi:	    
TEKST1  
	 DB 'PODAJ LICZBE:@'                      
TEKST2  
	 DB 10,13,'REPREZENTACJA HEXADECYMALNA:',10,13,'@'                      
TEKST3  
	 DB 10,13,'REPREZENTACJA BINARNA:',10,13,'@'                      
TEKST4  
	 DB 10,13,'NIEPOPRAWNE DANE!@'              
TEKST5  
	 DB 10,13,'ZA DUZA LICZBA!@'             
DLUGOSC 	 DW 920H   
