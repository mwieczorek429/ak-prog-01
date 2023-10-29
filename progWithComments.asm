	 ORG 800H  
	 LXI H,TEKST1 ; TEKST PODANIA LICZBY  
	 RST 3  
	 MVI C,0 ; DLUGOSC WYRAZU  
INPUT  
	 RST 2 ; WPROWADZENIE DANYCH  
	 CPI 0DH ;Sprawdzenie czy uzytkownik podal enter  
	 JNZ STOS ;Je�li nie, sprawd� i wpisz cyfr na stos  
	 JMP SUM ;W przeciwnym razie przejd� do obliczenia liczby dziesi�tnej  
STOS ;Wpisuje liczbe na stos, inkrementuje i sprawdza ile znak�w zosta�o podanych  
	 SUI 48D ;Odj�cie z kodu ASCII  
	 PUSH PSW ;UMIESZCZENIE LICZBY NA STOSIE  
	 CALL ISNUMBER ;Walidacja czy podany znak jest cyfr�  
	 INR C ;Kontrola d�ugo�ci liczby  
	 MOV A,C  
	 STA DLUGOSC ;Przechowaj d�ugo�� we wskazanym adresie.  
	 CPI 3  
	 JM INPUT ;Je�li ilo�� znak�w jest mniejsza od 3 Wczytaj kolejny znak.  
	 JMP SUM ;Liczba jest 3 cyfrowa skocz do dodawania.  
ISNUMBER ;Sprawdzenie czy znak jest cyfr�.  
	 STC ;Ustawienie CY, aby p�niej wyzerowa�  
	 CMC ;Zerowanie flagi CY  
	 CPI 10D ;Sprawdzenie czy cyfra jest jest wi�ksza od 10  
	 JNC NULL ;CY = 0, czyli cyfra jest wi�ksza  
	 RET ;Powr�t do wczytywania znak�w  
SUM  
	 LDA DLUGOSC ;Zaladuj ilo�� znak�w  
	 CPI 0  
	 JZ NULL ; SPRAWDZENIE CZY WYRAZ PUSTY  
	 POP PSW ;Wczytaj jedno�ci do A  
	 MOV D,A ;Przechowaj jedno�ci w D  
	 LDA DLUGOSC  
	 CPI 1  
	 JZ SHOWHEX ; SPRAWDZENIE CZY LICZBA MA DZIESIATKI, je�li nie po prostu wy�wietl  
	 POP PSW ;Wczytaj dziesi�tki  
	 JZ ENDDEC ;Je�li cyfra dziesi�tna jest zerem, nie dodawaj  
	 MOV B,A ;Przechowaj w cyfr� dziesi�tek w B  
SUMDEC ;P�tla dodaj�ca 10 do liczby. Podana cyfra dziesi�tek odpowiada za ilo�� iteracji.  
	 MOV A,D ;wczytaj ju� policzon� liczb� dziesi�tn�  
	 ADI 10D ;dodaj dziesi��  
	 MOV D,A ;"zaktualizuj" policzon� lb dziesi�tn�  
	 DCR B ;Zmniejsz cyfr� dziesi�tek o 1  
	 MOV A,B  
	 CPI 0D  
	 JNZ SUMDEC ;Je�li B != 0 powt�rz p�tle  
ENDDEC 	 LDA DLUGOSC ;Za�aduj d�ugo��  
	 CPI 2  
	 JZ SHOWHEX ; SPRAWDZENIE CZY LICZBA MA SETKI  
	 POP PSW ;Wczytaj setki  
	 JZ SHOWHEX ;SPRAWDZENIE CZY SETKI s� r�wne 0  
	 MOV B,A  
SUMHUN ;Podobna p�tla, tylko dodaje 100  
	 MOV A,D ;wczytaj ju� policzon� liczb� dziesi�tn�  
	 ADI 100D ;Dodaj sto  
	 JC FULL ;Walidacja, sprawdzenie czy liczba przekracza bajt if(>255) CY=1  
	 MOV D,A ;Zachowaj liczbe  
	 DCR B  
	 MOV A,B  
	 CPI 0D  
	 JNZ SUMHUN ;Je�li B != 0 wykonaj p�tle  
SHOWHEX  
	 LXI H,TEKST2 ; WYSWIETLENIE HEX  
	 RST 3  
	 MOV A,D  
	 RST 4 ;Wbudowany wy�wietlacz Hex  
	 MVI A,'h'  
	 RST 1  
SHOWBIN  
	 LXI H,TEKST3 ; ROZPOCZECIE WYSWIETLANIA BIN  
	 RST 3  
	 MOV A,D ;Przechowaj liczb� dziesi�tna  
	 MVI C,8D ;P�tla b�dzie wykonywa� si� 8 razy  
LOOPBIN  
	 RAL ;Przesui�cie bitowe liczby w lewo. Najbardziej znacz�cy bit trafia do flagi CY  
	 CNC SHOWZERO ;Je�li CY==0, wy�wietl '0' na ekran  
	 CC SHOWONE ;Je�li CY==1, wy�wietl '1' na ekran  
	 DCR C ;Zmniejsz ilo�� bit�w do sprawdzenia  
	 JNZ LOOPBIN ;Je�li nie sprawdzono wszystkich bit�w powt�rz p�tle  
	 JMP END ;P�tla wykona�a si� 8 razy, skocz do zako�czenia programu  
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
FULL ;Tekst dla walidacji je�li podana liczba przekracza bajt  
	 LXI H,TEKST5  
	 RST 3  
	 HLT  
NULL ;Podany wyraz przez u�ytkownika jest pusty lub nie jest cyfr�  
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
DLUGOSC 	 DW 920H ;Sta�y adres do przechowania d�ugo�ci podanej liczby   
