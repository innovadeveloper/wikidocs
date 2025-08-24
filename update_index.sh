#!/bin/bash

# Script para actualizar automáticamente el index.html con todos los archivos HTML del repositorio
# organizado por carpetas

echo "🔄 Actualizando lista de archivos HTML organizados por carpetas..."

# Buscar todos los archivos .html excepto index.html y crear JSON con estructura de carpetas
find . -name "*.html" -not -name "index.html" | sed 's|^\./||' | sort | jq -R -s 'split("\n")[:-1]' > files.json

# Contar archivos
total_files=$(cat files.json | jq '. | length')
echo "📁 Archivo files.json actualizado con $total_files archivos HTML"

# Mostrar archivos organizados por carpeta
echo ""
echo "📂 Estructura encontrada:"
cat files.json | jq -r '.[]' | while read file; do
    if [[ "$file" == *"/"* ]]; then
        folder=$(dirname "$file")
        filename=$(basename "$file")
        echo "  📁 $folder/"
        echo "    📄 $filename"
    else
        echo "  📄 $file (raíz)"
    fi
done | sort -u

echo ""
echo "✅ ¡Listo! El index.html detectará automáticamente:"
echo "   • La estructura de carpetas"
echo "   • Función de búsqueda por nombre y título"
echo "   • Carpetas colapsables"
echo ""
echo "💡 Para usar: abre index.html en tu navegador"