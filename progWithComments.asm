	 ORG 800H  
	 LXI H,TEKST1 ; TEKST PODANIA LICZBY  
	 RST 3  
	 MVI C,0 ; DLUGOSC WYRAZU  
INPUT  
	 RST 2 ; WPROWADZENIE DANYCH  
	 CPI 0DH ;Sprawdzenie czy uzytkownik podal enter  
	 JNZ STOS ;Jeœli nie, sprawdŸ i wpisz cyfr na stos  
	 JMP SUM ;W przeciwnym razie przejdŸ do obliczenia liczby dziesiêtnej  
STOS ;Wpisuje liczbe na stos, inkrementuje i sprawdza ile znaków zosta³o podanych  
	 SUI 48D ;Odjêcie z kodu ASCII  
	 PUSH PSW ;UMIESZCZENIE LICZBY NA STOSIE  
	 CALL ISNUMBER ;Walidacja czy podany znak jest cyfr¹  
	 INR C ;Kontrola d³ugoœci liczby  
	 MOV A,C  
	 STA DLUGOSC ;Przechowaj d³ugoœæ we wskazanym adresie.  
	 CPI 3  
	 JM INPUT ;Jeœli iloœæ znaków jest mniejsza od 3 Wczytaj kolejny znak.  
	 JMP SUM ;Liczba jest 3 cyfrowa skocz do dodawania.  
ISNUMBER ;Sprawdzenie czy znak jest cyfr¹.  
	 STC ;Ustawienie CY, aby póŸniej wyzerowaæ  
	 CMC ;Zerowanie flagi CY  
	 CPI 10D ;Sprawdzenie czy cyfra jest jest wiêksza od 10  
	 JNC NULL ;CY = 0, czyli cyfra jest wiêksza  
	 RET ;Powrót do wczytywania znaków  
SUM  
	 LDA DLUGOSC ;Zaladuj iloœæ znaków  
	 CPI 0  
	 JZ NULL ; SPRAWDZENIE CZY WYRAZ PUSTY  
	 POP PSW ;Wczytaj jednoœci do A  
	 MOV D,A ;Przechowaj jednoœci w D  
	 LDA DLUGOSC  
	 CPI 1  
	 JZ SHOWHEX ; SPRAWDZENIE CZY LICZBA MA DZIESIATKI, jeœli nie po prostu wyœwietl  
	 POP PSW ;Wczytaj dziesi¹tki  
	 JZ ENDDEC ;Jeœli cyfra dziesiêtna jest zerem, nie dodawaj  
	 MOV B,A ;Przechowaj w cyfrê dziesi¹tek w B  
SUMDEC ;Pêtla dodaj¹ca 10 do liczby. Podana cyfra dziesi¹tek odpowiada za iloœæ iteracji.  
	 MOV A,D ;wczytaj ju¿ policzon¹ liczbê dziesiêtn¹  
	 ADI 10D ;dodaj dziesiêæ  
	 MOV D,A ;"zaktualizuj" policzon¹ lb dziesiêtn¹  
	 DCR B ;Zmniejsz cyfrê dziesi¹tek o 1  
	 MOV A,B  
	 CPI 0D  
	 JNZ SUMDEC ;Jeœli B != 0 powtórz pêtle  
ENDDEC 	 LDA DLUGOSC ;Za³aduj d³ugoœæ  
	 CPI 2  
	 JZ SHOWHEX ; SPRAWDZENIE CZY LICZBA MA SETKI  
	 POP PSW ;Wczytaj setki  
	 JZ SHOWHEX ;SPRAWDZENIE CZY SETKI s¹ równe 0  
	 MOV B,A  
SUMHUN ;Podobna pêtla, tylko dodaje 100  
	 MOV A,D ;wczytaj ju¿ policzon¹ liczbê dziesiêtn¹  
	 ADI 100D ;Dodaj sto  
	 JC FULL ;Walidacja, sprawdzenie czy liczba przekracza bajt if(>255) CY=1  
	 MOV D,A ;Zachowaj liczbe  
	 DCR B  
	 MOV A,B  
	 CPI 0D  
	 JNZ SUMHUN ;Jeœli B != 0 wykonaj pêtle  
SHOWHEX  
	 LXI H,TEKST2 ; WYSWIETLENIE HEX  
	 RST 3  
	 MOV A,D  
	 RST 4 ;Wbudowany wyœwietlacz Hex  
	 MVI A,'h'  
	 RST 1  
SHOWBIN  
	 LXI H,TEKST3 ; ROZPOCZECIE WYSWIETLANIA BIN  
	 RST 3  
	 MOV A,D ;Przechowaj liczbê dziesiêtna  
	 MVI C,8D ;Pêtla bêdzie wykonywaæ siê 8 razy  
LOOPBIN  
	 RAL ;Przesuiêcie bitowe liczby w lewo. Najbardziej znacz¹cy bit trafia do flagi CY  
	 CNC SHOWZERO ;Jeœli CY==0, wyœwietl '0' na ekran  
	 CC SHOWONE ;Jeœli CY==1, wyœwietl '1' na ekran  
	 DCR C ;Zmniejsz iloœæ bitów do sprawdzenia  
	 JNZ LOOPBIN ;Jeœli nie sprawdzono wszystkich bitów powtórz pêtle  
	 JMP END ;Pêtla wykona³a siê 8 razy, skocz do zakoñczenia programu  
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
FULL ;Tekst dla walidacji jeœli podana liczba przekracza bajt  
	 LXI H,TEKST5  
	 RST 3  
	 HLT  
NULL ;Podany wyraz przez u¿ytkownika jest pusty lub nie jest cyfr¹  
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
DLUGOSC 	 DW 920H ;Sta³y adres do przechowania d³ugoœci podanej liczby   
