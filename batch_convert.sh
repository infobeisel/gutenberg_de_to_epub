#!/bin/bash
for authdir in */; do
    if [ -d "$authdir" ]; then
        echo converting "$authdir"
        cd $authdir
        for dir in */; do
            if [ -d "$dir" ]; then
                echo converting "$dir"
                cp ../gutenberg_de_to_epub.sh $dir
                cd $dir
                ./gutenberg_de_to_epub.sh
                rm gutenberg_de_to_epub.sh
                mv *.epub ..
                cd ..
            fi
        done
        cd ..
    fi
    
done