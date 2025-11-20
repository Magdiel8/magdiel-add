#!/bin/bash

# Definir nombre de archivo para guarad los resultado
ARCHIVO_SALIDA="resultado_filtro.txt"

# Creamos archivo vacío 
echo "Reporte de errores encontrados:" > "$ARCHIVO_SALIDA"

#recorrer lso archivos 
for archivo in /var/log/*; do

    # Comprobamos
    if [ -f "$archivo" ]; then
        
        encontrado=$(grep -iE "error|fail" "$archivo" 2>/dev/null)

        #ver si tiene algo
        if [ -n "$encontrado" ]; then
            
            # Si encontró algo, escribimos el encabezado y luego los errores
            echo "--------------------------------------------------" >> "$ARCHIVO_SALIDA"
            echo "ARCHIVO: $archivo" >> "$ARCHIVO_SALIDA"
            echo "--------------------------------------------------" >> "$ARCHIVO_SALIDA"
            echo "$encontrado" >> "$ARCHIVO_SALIDA"
            echo "" >> "$ARCHIVO_SALIDA" # Una línea en blanco para separar
        fi
    fi
done

echo "Proceso terminado. Se ha creado el archivo: $ARCHIVO_SALIDA"
