#!/bin/bash
#escoger numero 
echo "adivien el numero entre 1 y 100, tienes 5 intentos"
num=$(($RANDOM % 100 +1))

#contar los intentos
intentos=1
intentosmax=5
while [ $intentos -le $intentosmax ]; do
# respuesta del usuario
read -p "que numero es? " usun
if [ "$usun" -eq "$num" ]; then 
echo "felicidades, adivinaste el numero"
exit 0
elif [ "$usun" -lt "$num" ]; then
echo "===el numero es mayor==="
else
echo "el numero es menor"
fi
echo "intento $intentos de $intentosmax"
intentos=$((intentos+1))
done
echo "lo siento, no adivinaste el numero. el numero era $num"
