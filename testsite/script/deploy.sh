#!/bin/bash

#aktuellen Pfad abfragen
  cd $(dirname $0)
  currentpath=$(PWD)

#aus aktuellem Pfad den Pfad des Jupyter Notebooks ableiten und dorthin wechseln
  contentpath=${currentpath/script/Lessons}/
  cd $contentpath
  echo $contentpath

#alle html Dateien in contentpath abgehen

for file in $contentpath*.ipynb ; do
# Notebooks in html mit basistemplate umwandeln
jupyter nbconvert $file to html --template basic

done

#Datum so umformatieren, dass hugo es erkennt --> Zeitzone +0200 zu +02:00
currenttime=$(date +%Y-%m-%dT%H:%M:%S%z)
currenttime=${currenttime/0200/02:00}
currenttime=${currenttime/0100/01:00}

for file in $contentpath*.html ; do
# front matter einfügen
sed -e '1s/.*$/+++\n\&&/g' $file
sed -e '1s/.*$/title = \"notebook4\"\n\&&/g' $file
sed -e '1s/.*$/draft = true\n\&&/g' $file
sed -e '1s/.*$/date = "$currenttime"\n\&&/g' $file
sed -e '1s/.*$/+++\n\&&/g' $file

# konvertierte Dateien ins Contentverzeichnis von Hugo schieben
echo "schleife 2"
done
