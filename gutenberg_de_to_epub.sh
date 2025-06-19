#!/bin/bash

#name of the ebook: author name _ title
COMBINED_NAME="$(basename "$(dirname "$PWD")")_$(basename "$PWD")"

#option to rm everything except X
extglob_was_enabled=$(shopt -p extglob)
shopt -s extglob

#make a directory "conversionTemp", copy everything
rm -rf conversionTemp
mkdir conversionTemp
cp -r !(conversionTemp) conversionTemp


#replace certain html sections from the files, as they lead to including the whole book library
for file in *.html; do
    if [[ "$file" != "index.html" && -f "$file" ]]; then
        sed -i '/<div class="navi-gb">/,/weiter&nbsp;&gt;&gt;<\/a>&nbsp;<\/hr>/d' $file
        sed -i '/<hr size="1" color="#808080">&nbsp/,/<\/div>/d' $file
        sed -i 's/..\/..\///g' $file
    elif [[ "$file" == "index.html" && -f "$file"  ]]; then
        echo filename:
        echo $file
        sed -i '/<div class="navi-gb">/,/<\/div>/d' $file
        sed -i '/^<p><h5><a href=/d' $file
        #sed -i '/<p><h5><a href="..\/..\/autoren\/namen\//,/<\/a><\/h5>/d' $file
        sed -i '/<div class="bottomnavi-gb">/,/<\/div>/d' $file
    fi
done

#convert to ebook
ebook-convert index.html "$COMBINED_NAME.epub"

#restore original files from temp
mv *.epub conversionTemp
rm -rf !(conversionTemp)
mv conversionTemp/* .
rm -rf conversionTemp


# Restore previous extglob state
eval "$extglob_was_enabled"