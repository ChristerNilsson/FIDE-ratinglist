Givet FIDE-id hämtar programmet namn och elo-rating för alla spelare.

* Hämta den stora databasen från FIDE och se till att filen heter players_list_foa.txt
	* http://ratings.fide.com/download/players_list.zip
	* Detta ska ske en gång per månad eller före turneringen
* Därefter körs pythonprogrammet **main.py** som filtrerar fram country=="SWE" or S >= 2000 och lägger dem i **databas.json**
* När detta är gjort kan man anropa detta program från FairPair.
	* Man skriver in FIDE-id för alla spelare som ska deltaga i turneringen.
	* Kopiera den högra textarean och klistra in i FairPair
	* När alla spelare är med klickas på Save som sparar textfilen **turnering.txt**
	* Denna fil behövs vid elo-rapporteringen till FIDE.
	* Alternativt: Hämta med http://ratings.fide.com/profile/1712233
* Nu kan turneringen startas

* FIDE:s fil innehåller varken å, ä eller ö. Man får manuellt fixa detta eller uppdatera filen **pretty.json**.
	* I första hand hämtas namnet från pretty.json
	* I andra hand hämtas namnet från databas.json

|Namn|Elo|
|-|-|
|Christer|1650|
|Jouko|1550|

