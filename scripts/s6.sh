#!/bin/bash
#pedir ruta 
read -p "Introduce la ruta del archivo o directorio: " ruta
# Comprobar si se pasó un argumento
if [ $# -ne 1 ]; then
    echo "Uso: $0 ruta_absoluta"
    exit 1
fi

# Obtener permisos en octal (incluyendo especiales)
permisos=$(stat -c "%a" "$ruta")

echo "Permisos octales de $ruta: $permisos"