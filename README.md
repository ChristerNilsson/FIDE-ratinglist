Givet FIDE-id hämtar programmet namn och elo-rating för alla spelare i hela världen, 1.7M  
Filen hämtas från FIDE och är cirka 273 MB stor. 
* Hämta den stora databasen från FIDE och se till att filen heter **fide.txt**
  * http://ratings.fide.com/download/players_list.zip
  * Detta ska ske den andra i varje månad
* Därefter körs pythonprogrammet **fide.py** som skapar 1000 json-filer i katalogen **shards**.
* När detta är gjort kan man via shards hämta en person.
  * Man skriver in ett FIDE-id och då hämtas personens namn och elo till en listbox
  * FIDE-id behövs för att kunna skapa en TRF16-fil.
* FIDE:s fil innehåller varken å, ä eller ö. 
  * Detta skulle kunna lösas via SSF:s databas, men prioriterades bort.

## FairPair - begränsningar i samband med elo uppdatering

* I första hand bör turneringen avslutas inom en kalendermånad.
* Det innebär att långpartier inte kan hanteras.
* Orsaken till denna begränsning är att FIDE vill att delrapporter ska skickas varje månad
* Om en rapport rejectas, t ex beroende på att någon medlem saknar FIDE-id, måste kan kunna sända en gång till.

## Min hantering av rapporter - Logg

Om vi håller oss till Berger och FairPair, så kan man spela partierna i vilken ordning som helst.  
Dock vill man helst att speldatum används för rapportering, inte rondernas datum.  
Ffa om man spelar en äldre rond ett par månader efteråt.  
För att hålla reda på detta loggas partier istf att använda r1 .. rn.  
I loggen kommer det att stå: vits id + svarts id + resultat. Detta kan lagras i fem tecken  
Loggen kommer att innehålla ett antal månadsgrupper.  
Längden på dessa månadsgrupper sparas i ett index.  
När man vill köra en rapport får man ange var man vill börja, mha detta index.  

  * Anger man 1 kommer allt rapporteras igen  
  * Anger man 2 kommer första månaden att ignoreras  
  * Anger man 3 blir rapporten tom.  
  
Då kan man alltså slå ihop två eller flera månader.  
När detta är gjort påbörjas en ny månadsgrupp.  

## Index med 8 spelare
```
AB1 # A slog B med vita pjäser
CD0
EF= # remi
AG1 # Parti spelat i förväg
=== # Månadskifte
AC=
BE0
DG=
GH1 # Denna match skulle egentligen spelats förra månaden
=== # Månadskifte
```

AB1 kan användas om en turnering har 64 eller färre deltagare.  
Har man fler deltagare används två tecken för att identifiera en spelare. Upp till 64*64=4096 spelare kan hanteras.  
Tecken 0123456789abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVWXYZ + två tecken till, t ex _ och -  

## TRF16

Dessa kolumner anger **inte** när partierna spelats.  
Det framgår istället av Första och Sista Speldatum  
Partierna kan skrivas ut horisontellt eller vertikalt, spelar inte roll.

```
12 Kalle 13w1 14b= ...
13 Pelle 16b0 ...
```

## Hur vet man att FIDE lyckats läsa in en fil?

https://ratings.fide.com/rated_tournaments.phtml?country=SWE  
Sortera t ex på namn och leta upp Seniorserien... resp Stockholmsmasterskapet veteran 2025...  
Sista kolumnen anger inläsningsdatum.  
Tyvärr får man inte reda på orsaken till en reject, men man kan prova att läsa in filen med flera olika verktyg.
* member.schack
* Swiss Manager
* FIDE?

Förklaring till koder använt på denna websida:
```
s = swiss
t = team
r = round robin dvs Berger
d = double Berger

sjukt att blanda ihop tre dimensioner så här.
1: Berger/Swiss
2: Individuell/Team
3: Single/Double
```

## Dan Israels förtida partier. Berger
Hanteringen av dessa tyder på att man rapporterar enligt ronddatum. Partier som spelades i oktober kommer att rapportera i december. Detta innebär att partierna skulle kunna rapporterat tidigare, vilket är bättre.  

Vad värre är: Missar man att spela ett uppskjutet parti inom månaden, kommer det troligen inte med i rapporten.
Hanteringen av detta är knölig. Partiet måste rapporteras som Uppskjutet och när det gäller Swiss använder man tendenslottning. Tendenslottning innebär att partiet räknas som vinst för den bättre spelaren om eloskillnaden är > 200, annars remi. När partiet sedan spelas gäller det riktiga resultatet.



