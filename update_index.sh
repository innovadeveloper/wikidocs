#!/bin/bash

# Script para actualizar automáticamente el index.html con todos los archivos HTML del repositorio

echo "Actualizando lista de archivos HTML..."

# Buscar todos los archivos .html excepto index.html y crear JSON
find . -name "*.html" -not -name "index.html" | sed 's|^\./||' | sort | jq -R -s 'split("\n")[:-1]' > files.json

echo "Archivo files.json actualizado con $(cat files.json | jq '. | length') archivos HTML"

# Mostrar lista de archivos encontrados
echo "Archivos encontrados:"
cat files.json | jq -r '.[]' | sed 's/^/  - /'

echo "¡Listo! El index.html se actualizará automáticamente al cargar la página."