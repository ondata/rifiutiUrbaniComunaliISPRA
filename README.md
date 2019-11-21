# Rifiuti Urbani: dati comunali di produzione e raccolta differenziata

ISPRA pubblica in questa pagina [https://www.catasto-rifiuti.isprambiente.it/index.php?pg=downloadComune](https://www.catasto-rifiuti.isprambiente.it/index.php?pg=downloadComune) i **dati comunali** di **produzione** e **raccolta differenziata** sui **Rifiuti Urbani**, in file con **raccolte annuali** (ad oggi) dal 2010 al 2017. Sono pubblicati in formato `ods` (foglio di calcolo in formato _open document_).

In questo repo uno script per scaricarli, pulirli, ristrutturarli e convertirli in un [**unico CSV**](https://github.com/ondata/rifiutiUrbaniComunaliISPRA/raw/master/ispraRifiuti.csv) e per l'appunto il file di insieme.

**NOTA BENE**:

- il campo `PERCRD` esprime le percentuali in valori divisi per 100, quindi `0.67` equivale al `67%`;
- sul sito sorgente, i dati sono stati pubblicati in CSV e non più in in formato _open document_.

## Lo script

È [scritto](./catastoRifiutiISPRA.sh) in bash e sfrutta queste utility:

- scrape, per estrarre gli URL degli ODS via XPATH https://github.com/aborruso/scrape-cli/releases
- pyexcel, per convertire fogli elettronici in CSV https://github.com/pyexcel/pyexcel
- pyexcel-ods, estende pyexcel per abilitare la conversione di file `ods` https://github.com/pyexcel/pyexcel-ods
- Miller, nella sua versione da compilare come indicato [qui](http://johnkerl.org/miller/doc/build.html#From_git_clone_using_autoconfig), in modo da avere una comoda funzione non disponibile ancora nella versione in produzione.

Si occupa di:

- fare il download dei file `ods`;
- convertirli in `csv`;
- rimuove un'inutile riga di intestazione;
- rimuove spazi bianchi in più (come `Piemonte • • •`) e righe vuote;
- gestisce il cambio di ordine e numero di campi che avviene al passaggio dall'anno 2015 al 2016;
- aggiunge il campo con l'anno;
- fa il merge in unico file `csv` di output.
