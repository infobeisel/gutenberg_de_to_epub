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

        #delete top navigation section (assumes 35 lines)
        sed -i '/<div class="navi-gb">/,+34d' $file

        #delete content table (if not titlepage)
        if [[ "$file" != "titlepage.html" && -f "$file" ]]; then
            # Get line number of first prefix occurrence
            start_line=$(grep -n '<p><h5></h5>' "$file" | head -n1 | cut -d: -f1)
            # Get line number of last suffix occurrence after start_line
            end_line=$(tail -n +"$start_line" "$file" | grep -n 'Autorenseite</a><br/><hr size' | tail -n1 | cut -d: -f1)
            # Calculate actual line number of suffix in full file
            if [[ -n $end_line ]]; then
            end_line=$((start_line + end_line - 1))
            # Delete lines from start_line to end_line inclusive
            sed -i "${start_line},${end_line}d" "$file"
            else
            echo "Suffix not found after prefix"
            fi

            #delete forward backward
            sed -i '/<hr size="1" color="#808080">&nbsp/d' $file
        fi

        #delete bottom navigation section (assumes 12 lines)
        sed -i '/<div class="bottomnavi-gb">/,+12d' $file

        #destroy remaining parent links if still existent
        sed -i -E 's|\.\./\.\./([^"]*\.html)|\1|g' $file

    elif [[ "$file" == "index.html" && -f "$file"  ]]; then
        echo filename:
        echo $file
        sed -i '/<div class="navi-gb">/,+34d' $file
        sed -i '/^<p><h5><a href=/d' $file
        sed -i '/<div class="bottomnavi-gb">/,+14d' $file
        echo "</ul>" >> $file
        echo "</body>" >> $file
        echo "</html>" >> $file

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