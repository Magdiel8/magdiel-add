#!/bin/bash
#pedir el nombre del fichero
read -p "introduce el nombre del fichero: " fic
#comprobar si existe
resultado=(sudo find / type f -name "$fic" 2>/dev/null)
#si existe, mostrar su contenido
if [ -n $resultado ] ; then
    echo "el fichero existe: $resultado"

else
    echo "el fichero no existe"
    exit 1
fi
exit 0
