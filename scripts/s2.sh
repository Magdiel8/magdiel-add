#!/bin/bash
# varibles de los paramaetros 
read -p "ingreasa la interfaz: " inter
read  -p "ingresa la ip: " ip
read -p "ingresa la mascara: " mask
read -p "ingresa la puerta de enlace: " puerta
read -p "ingresa el dns: " dns

#aplicar los parametros
sudo ip addr flush dev $inter
sudo ip addr add $ip/$mask dev $inter
sudo ip link set $inter up
sudo ip route add default via $puerta dev $inter
echo "nameserver $dns" | sudo tee -a /etc/resolv.conf
#comprobando confi
echo -e "comprobando la configuracion"
ip -brief addr show && ip route show default && grep nameserver /etc/resolv.conf
