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
