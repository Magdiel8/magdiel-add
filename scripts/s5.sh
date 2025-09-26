#!/bin/bash

read -p "Introduce el directorio: " dir

if [ -d "$dir" ]; then
    count=$(find "$dir" -maxdepth 1 -type f | wc -l)
    echo "Hay $count ficheros en el directorio $dir."
else
    echo "El directorio no existe."
fi