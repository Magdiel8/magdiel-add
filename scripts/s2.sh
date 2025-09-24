#!/bin/bash
# varibles de los paramaetros 
read -p "ingreasa la interfaz: " inter
read  -p "ingresa la ip: " ip
read -p "ingresa la mascara: " mask
read -p "ingresa la puerta de enlace: " puerta
read -p "ingresa el dns: " dns

#aplicar los parametros
sudo ifconfig $inter $ip netmask $mask up ;
sudo route add default gw $puerta 
echo "nameserver $dns" | sudo tee /etc/resolv.conf
#comprobando confi
echo -e "comprobando la configuracion"
ip -brief addr show && ip route show default && grep nameserver /etc/resolv.conf
