#!/bin/bash
for dir in */; do
    echo converting "$dir"
    cp gutenberg_de_to_epub.sh $dir
    cd $dir
    ./gutenberg_de_to_epub.sh
    rm gutenberg_de_to_epub.sh
    mv *.epub ..
    cd ..
done