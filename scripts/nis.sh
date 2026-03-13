#!/bin/bash

# -- byad12.pages.dev/nis.sh

##############################################################
# CODIFICACIÓN DEL ARCHIVO
##############################################################
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

##############################################################
# DEFINIR BUCLE
##############################################################
while true; do
    clear

    Ne=$'\033[1m'
    Ro=$'\033[31;1m'
    Ve=$'\033[32;1m'
    Am=$'\033[33;1m'
    Az=$'\033[34;1m'
    Bl=$'\033[0m'

    echo -e "Script hecho por ${Az}byAd12.pages.dev${Bl}\n   ${Ne}2026${Bl}\n${Bl}"

    printf "%b\n" \
        " | ${Az}SERVIDOR ${Bl}" \
        " | ================================" \
            "${Ne}1${Bl} | Configurar el equipo como master" \
            "${Ne}2${Bl} | Configurar el equipo como slave" \
            "${Ne}3${Bl} | Actualizar base de datos" \
            " | " \
        " | ${Az}CLIENTE ${Bl}" \
        " | ================================" \
            "${Ne}4${Bl} | Configurar apagado automático" \
            " | " \
        " | ${Az}MENÚ ${Bl}" \
        " | ======" \
            "${Ne}0${Bl} | Cerrar" \
            | column --table --separator '|' --keep-empty-lines
    echo ""
    read -p "Opción: ${Am}" var
    echo -e "${Bl}"

    case $var in

    ##############################################################
    # CERRAR PROGRAMA
    ##############################################################
    0) break ;;
    q) break ;;
    quit) break ;;
    exit) break ;;

    ##############################################################
    # SERVIDOR MASTER - CONFIGURACIÓN
    ##############################################################
    1)
        clear
        read -p 'Nombre de dominio: ' nombre_dominio
        read -p 'Nombre de este equipo / hostname: ' nombre_hostname
        read -p 'Dirección de red (sin máscara): ' ip_red
        read -p 'Máscara punteada de la dirección de red (ej. 255.255.255.0): ' mascara_red

        echo -e "\n${Az}Instalando NIS...${Bl}"
        apt update
        apt install -y nis

        echo -e "\n${Az}Configurando el dominio...${Bl}"
        echo "${nombre_dominio}" > /etc/defaultdomain

        echo -e "\n${Az}Verificación del dominio...${Bl}"
        nisdomainname

        echo -e "\n${Az}Configurando el nombre de equipo / hostname...${Bl}"
        hostnamectl set-hostname "${nombre_hostname}.${nombre_dominio}"

        echo -e "\n${Az}Configurando NIS...${Bl}"
        echo "NISSERVER=master" >> /etc/default/nis
        echo "NISCLIENT=false" >> /etc/default/nis
        echo "ypserver ${nombre_hostname}.${nombre_dominio}" >> /etc/yp.conf

        echo -e "\n${Az}Configurando las redes seguras...${Bl}"
        echo "${mascara_red} ${ip_red}" >> /etc/ypserv.securenets
        sed -i 's/0.0.0.0    0.0.0.0/# 0.0.0.0    0.0.0.0/g' /etc/ypserv.securenets
        sed -i 's/::/0/# ::\/0/g' /etc/ypserv.securenets
        
        echo -e "\n${Az}Configurando los registros DNS internos...${Bl}"
        while [ condición ]; do
            echo -e "\n${Am}Nuevo registro DNS Interno ('exit' para cerrar):${Bl}"
            read -p 'IP de un equipo de la red: ' ip_dns
            if [ "$ip_dns" == "exit" ]; then
                break
            fi
            read -p 'Registro DNS a asignar (ej. CLIENTE01): ' registro_dns
            if [ "$registro_dns" == "exit" ]; then
                break
            fi
            echo "${ip_dns}   ${registro_dns} ${registro_dns}.${nombre_dominio}" >> /etc/default/nis
            echo -e "\n${Am}Nuevo registro de /etc/hosts añadido: '${ip_dns}   ${registro_dns} ${registro_dns}.${nombre_dominio}'${Bl}"
        done

        echo -e "\n${Az}Generando base de datos...${Bl}"
        /usr/lib/yp/ypinit -m

        echo -e "\n${Az}Reiniciando y habilitando servicios...${Bl}"
        systemctl restart rpcbind ypserv ypbind yppasswdd ypxfrd
        systemctl enable rpcbind ypserv ypbind yppasswdd ypxfrd


        echo -e "\n${Ve}¡Se ha configurado el servidor master!${Bl}"
        echo -e "\n${Am}Porfavor, reinicie el sistema.${Bl}"
        ;;

    ##############################################################
    # SERVIDOR SLAVE - CONFIGURACIÓN
    ##############################################################
    2)
        clear
        read -p 'Nombre de dominio: ' nombre_dominio
        read -p 'Nombre de este equipo / hostname: ' nombre_hostname
        read -p 'Nombre del servidor / hostname: ' hostname_servidor
        read -p 'Dirección de red (sin máscara): ' ip_red
        read -p 'Máscara punteada de la dirección de red (ej. 255.255.255.0): ' mascara_red

        echo -e "\n${Az}Instalando NIS...${Bl}"
        apt update
        apt install -y nis

        echo -e "\n${Az}Configurando el dominio...${Bl}"
        echo "${nombre_dominio}" > /etc/defaultdomain

        echo -e "\n${Az}Verificación del dominio...${Bl}"
        nisdomainname

        echo -e "\n${Az}Configurando el nombre de equipo / hostname...${Bl}"
        hostnamectl set-hostname "${nombre_hostname}.${nombre_dominio}"

        echo -e "\n${Az}Configurando NIS...${Bl}"
        echo "NISSERVER=slave" >> /etc/default/nis
        echo "NISCLIENT=false" >> /etc/default/nis
        echo "ypserver ${nombre_hostname}.${nombre_dominio}" >> /etc/yp.conf

        echo -e "\n${Az}Configurando las redes seguras...${Bl}"
        echo "${mascara_red} ${ip_red}" >> /etc/ypserv.securenets
        sed -i 's/0.0.0.0    0.0.0.0/# 0.0.0.0    0.0.0.0/g' /etc/ypserv.securenets
        sed -i 's/::/0/# ::\/0/g' /etc/ypserv.securenets
        
        echo -e "\n${Az}Configurando los registros DNS internos...${Bl}"
        while [ condición ]; do
            echo -e "\n${Am}Nuevo registro DNS Interno ('exit' para cerrar):${Bl}"
            read -p 'IP de un equipo de la red: ' ip_dns
            if [ "$ip_dns" == "exit" ]; then
                break
            fi
            read -p 'Registro DNS a asignar (ej. CLIENTE01): ' registro_dns
            if [ "$registro_dns" == "exit" ]; then
                break
            fi
            echo "${ip_dns}   ${registro_dns} ${registro_dns}.${nombre_dominio}" >> /etc/default/nis
            echo -e "\n${Am}Nuevo registro de /etc/hosts añadido: '${ip_dns}   ${registro_dns} ${registro_dns}.${nombre_dominio}'${Bl}"
        done

        echo -e "\n${Az}Generando base de datos...${Bl}"
        /usr/lib/yp/ypinit -s "${hostname_servidor}.${nombre_dominio}"

        echo -e "\n${Az}Reiniciando y habilitando servicios...${Bl}"
        systemctl restart rpcbind ypserv ypbind yppasswdd ypxfrd
        systemctl enable rpcbind ypserv ypbind yppasswdd ypxfrd


        echo -e "\n${Ve}¡Se ha configurado el servidor slave!${Bl}"
        echo -e "\n${Am}Porfavor, reinicie el sistema.${Bl}"
        ;;

    ##############################################################
    # SERVIDOR - ACTUALIZAR BASE DE DATOS
    ##############################################################
    3)
        clear

        echo -e "\n${Az}Actualizando la base de datos...${Bl}"
        make -C /var/yp

        echo -e "\n${Ve}¡Se actualizó la base de datos!${Bl}"
        ;;

    ##############################################################
    # CLIENTE - CONFIGURACIÓN
    ##############################################################
    4)
        clear
        read -p 'Nombre de dominio: ' nombre_dominio
        read -p 'Nombre de este equipo / hostname: ' nombre_hostname
        read -p 'Dirección de red (sin máscara): ' ip_red
        read -p 'Máscara punteada de la dirección de red (ej. 255.255.255.0): ' mascara_red

        echo -e "\n${Az}Instalando NIS...${Bl}"
        apt update
        apt install -y nis

        echo -e "\n${Az}Configurando el dominio...${Bl}"
        echo "${nombre_dominio}" > /etc/defaultdomain

        echo -e "\n${Az}Verificación del dominio...${Bl}"
        nisdomainname

        echo -e "\n${Az}Configurando el nombre de equipo / hostname...${Bl}"
        hostnamectl set-hostname "${nombre_hostname}.${nombre_dominio}"

        echo -e "\n${Az}Configurando NIS...${Bl}"
        echo "NISSERVER=false" >> /etc/default/nis
        echo "NISCLIENT=true" >> /etc/default/nis
        echo "ypserver ${nombre_hostname}.${nombre_dominio}" >> /etc/yp.conf
        
        echo -e "\n${Az}Configurando los registros DNS internos...${Bl}"
        while [ condición ]; do
            echo -e "\n${Am}Nuevo registro DNS Interno ('exit' para cerrar):${Bl}"
            read -p 'IP de un equipo de la red: ' ip_dns
            if [ "$nombre_dominio" == "exit" ]; then
                break
            fi
            read -p 'Registro DNS a asignar (ej. CLIENTE01): ' registro_dns
            if [ "$nombre_dominio" == "exit" ]; then
                break
            fi
            echo "${ip_dns}   ${registro_dns} ${registro_dns}.${nombre_dominio}" >> /etc/default/nis
            echo -e "\n${Am}Nuevo registro de /etc/hosts añadido: '${ip_dns}   ${registro_dns} ${registro_dns}.${nombre_dominio}'${Bl}"
        done

        echo -e "\n${Az}Reiniciando y habilitando servicios...${Bl}"
        systemctl restart rpcbind ypbind nscd
        systemctl enable rpcbind ypbind nscd

        echo -e "\n${Az}Configurando /etc/nsswitch.conf...${Bl}"
        sed -i 's/files systemd/files systemd nis/g' /etc/nsswitch.conf

        echo -e "\n${Az}Verificando usuarios de NIS...${Bl}"
        ypcat passwd

        echo -e "\n${Ve}¡Se ha configurado el cliente!${Bl}"
        echo -e "\n${Am}Porfavor, reinicie el sistema.${Bl}"
        ;;

    ##############################################################
    ##############################################################

    *)
        echo -e "${Ro}Valor inválido${Bl}"
        ;;
    esac

    echo
    read -p "Pulse ENTER para reiniciar el programa: " _
done
