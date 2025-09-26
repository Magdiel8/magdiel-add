#!/bin/bash
# varibles de los paramaetros 
read -p "ingreasa la interfaz: " inter
read  -p "ingresa la ip: " ip
read -p "ingresa la mascara: " mask
read -p "ingresa la puerta de enlace: " puerta
read -p "ingresa el dns: " dns

<<<<<<< HEAD
#aplicar los parametros
sudo ip addr flush dev $inter
sudo ip addr add $ip/$mask dev $inter
sudo ip link set $inter up
sudo ip route add default via $puerta dev $inter
echo "nameserver $dns" | sudo tee -a /etc/resolv.conf
=======
#aplicar los parametros   #arreglar
sudo ifconfig $inter $ip netmask $mask up ;
sudo route add default gw $puerta 
echo "nameserver $dns" | sudo tee /etc/resolv.conf
>>>>>>> 85dcd817f529da00ee32ded50c1321a12a5d934e
#comprobando confi
echo -e "comprobando la configuracion"
ip -brief addr show && ip route show default && grep nameserver /etc/resolv.conf
