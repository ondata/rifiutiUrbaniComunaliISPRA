#!/bin/bash

set -x

<<requisiti
- scrape https://github.com/aborruso/scrape-cli/releases
- pyexcel https://github.com/pyexcel/pyexcel
- pyexcel-ods https://github.com/pyexcel/pyexcel-ods
- versione head di Miller, da compilare come indicato qui http://johnkerl.org/miller/doc/build.html#From_git_clone_using_autoconfig
requisiti

# rimuovi file eventualmente scaricati e convertiti
rm ./*.ods
rm ./*.csv

#scarica i dati
curl "https://www.catasto-rifiuti.isprambiente.it/index.php?pg=downloadComune" | \
scrape -e '//div[@id="content"]//table//tr/td/a/@href' | tr "\t" "\n" | \
mlr --nidx put '$1="https://www.catasto-rifiuti.isprambiente.it/".$1' | grep 'ods' | xargs -I _ wget _

# converti file ods in csv
for i in *.ods; 
do 
  #crea una variabile per estrarre nome e estensione
  filename=$(basename "$i")
  #estrai estensione
  extension="${filename##*.}"
  #estrai nome file
  filename="${filename%.*}"
  pyexcel transcode --sheet-index 0 "$filename".ods "$filename".csv
done

# rimuovi inutile riga di intestazione
sed -i -e '1,1d' ./*.csv

# rimuovi spazi bianchi inutili e righe vuote
mlr -I --csv clean-whitespace then skip-trivial-records then put '$anno=FILENAME' ./*.csv

# fai il merge dei CSV. Si usa unsparsify perché nel 2016 cambiano ordine e numero campi
mlr --csv unsparsify --fill-with ""  ./*.csv >./ispraRifiuti.csv

# metti campo anno all'inizio e estrai anno
mlr -I --csv reorder -f anno then put '$anno=regextract_or_else($anno, "[0-9]+", "")' ./ispraRifiuti.csv
