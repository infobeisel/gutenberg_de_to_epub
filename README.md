# Projekt Gutenberg-DE - zu - EPUB
Ein linux bash script, um einen heruntergeladenen Text im html-Format von der Seite https://www.projekt-gutenberg.org/ in ein ebook im .epub-Format umzuwandeln.
Calibre muss auf dem System installiert sein. Das script überspringt alle Verweise auf andere Werke und führt dann Calibre's "ebook-convert" aus.
## Anleitung:
1. Lade alle zu einem Werk gehörigen html-Dateien von der Seite https://www.projekt-gutenberg.org/ herunter.
2. Platziere das script "gutenberg_de_to_epub.sh" neben die index.html-Datei und führe es aus.
3. Als Ergebnis sollte eine .epub Datei im selben Ordner auftauchen
