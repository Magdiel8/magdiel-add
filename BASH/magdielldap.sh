#!/bin/bash
# Variables de entorno
DOM="dc=magdiel2025,dc=ldap"
ADM="cn=admin,$DOM"
OPT=0

# Bucle condicional until
until [ "$OPT" == "4" ]; do
    
    # Mostrar menú opciones
    echo "1. Eliminar correo"
    echo "2. Modificar correo"
    echo "3. Realizar búsquedas"
    echo "4. Salir"
    read -p "Opción: " OPT

    case $OPT in
        1)
            # Pedir ruta completa
            read -p "DN completo: " DN
            # Borrar atributo mail
            ldapmodify -x -D "$ADM" -W <<EOF
dn: $DN
changetype: modify
delete: mail
EOF
            ;;
        2)
            # Pedir datos nuevos
            read -p "DN completo: " DN
            read -p "Nuevo correo: " MAIL
            # Cambiar atributo mail
            ldapmodify -x -D "$ADM" -W <<EOF
dn: $DN
changetype: modify
replace: mail
mail: $MAIL
EOF
            ;;
        3)
            # Elegir tipo búsqueda
            read -p "1.Concreto 2.Todos: " SUB
            if [ "$SUB" == "1" ]; then
                # Buscar usuario exacto
                read -p "Nombre (cn): " CN
                ldapsearch -x -LLL -b "$DOM" "(cn=$CN)" cn mail
            else
                # Listar a todos
                ldapsearch -x -LLL -b "$DOM" "(cn=*)" cn mail
            fi
            ;;
        4)
            # Fin del programa
            echo "Saliendo..."
            ;;
        *)
            # Opción no válida
            echo "Error."
            ;;
    esac
done
