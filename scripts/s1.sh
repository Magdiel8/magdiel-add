#!/bin/bash

#preguntar el año
 read -p "indica el año " anio
#op de calculo
if ((anio % 4==0 && anio % 100 != 0 ||anio % 400 ==0)); then
    echo "el $anio es bicisiesto"
else
    echo "el $anio no es bicisiesto"

fi
