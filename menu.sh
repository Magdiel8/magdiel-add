#!/bin/bash
#variable para la ruta de los scripts
dir_scr="$(dirname"$0")scripts"
#menu 
while true; do
   clear
   echo "====MENU PRINCIPAL===="
   echo " 1) Bisiesto"
   echo " 2) configuracion de red"
    echo " 3) Adivina el numero"
   echo " 0) Salir"
   echo "======================"
   read -p " elige opcion: " opcion
   case $opcion in
       1) bash "$dir_scr/s1.sh"; read -p "enter para volver al menu" ;;
       2) bash "$dir_scr/s2.sh"; read -p "enter para volver al menu" ;;
       3) bash "$dir_scr/s3.sh"; read -p "enter para volver al menu" ;;
       0) echo "saliendo..."; break;;
       *) echo "opcion invalida";sleep 1;;
   esac
done