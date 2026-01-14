#!/bin/bash

# -- byad12.pages.dev/proxmox.sh
# -- www.chemahosting.es
# -- Script hecho por Adrián L. G. P.

##############################################################
# CODIFICACIÓN DEL ARCHIVO
##############################################################
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

##############################################################
# INSTALAR DEPENDENCIAS
##############################################################
apt update
apt install -y cowsay curl

##############################################################
# DEFINIR BUCLE
##############################################################
while true; do
    clear
    /usr/games/cowsay -f tux CHEMA HOSTING

    Ne=$'\033[1m'
    Ro=$'\033[31;1m'
    Ve=$'\033[32;1m'
    Am=$'\033[33;1m'
    Az=$'\033[34;1m'
    Bl=$'\033[0m'

    echo -e "Script hecho por ${Az}Adrián L. G. P.${Bl}\n   ${Ne}2025${Bl} - ${Az}www.chemahosting.es\n${Bl}"

    printf "%b\n" \
        " | ${Az}CLÚSTER ${Bl}" \
            " | ===================" \
            "${Ne}1${Bl} | Crear un clúster" \
            "${Ne}2${Bl} | Unirse a un clúster" \
            "${Ne}3${Bl} | Eliminar un clúster" \
            " | " \
        " | ${Az}CLOUDFLARED ${Bl}" \
            " | =============================" \
            "${Ne}4${Bl} | Instalar e iniciar sesión" \
            "${Ne}5${Bl} | Crear un túnel - HTTP(S)" \
            "${Ne}6${Bl} | Crear un túnel - Servicio TCP" \
            "${Ne}7${Bl} | Purgar cloudflared" \
            " | " \
        " | ${Az}AUTOMATIZAR ${Bl}" \
            " | =============================" \
            "${Ne}8${Bl} | Configurar apagado automático" \
            " | " \
        " | ${Az}DOCKER ${Bl}" \
            " | ========================" \
            "${Ne}9${Bl} | Instalar docker - Debian" \
            "${Ne}10${Bl} | favonia/cloudflare-ddns" \
            " | " \
        " | ${Az}PROXMOX ${Bl}" \
            " | =====================" \
            "${Ne}11${Bl} | CT - Crear backup" \
            "${Ne}12${Bl} | CT - Restaurar backup" \
            "${Ne}13${Bl} | Restaurar local-lvm" \
            "${Ne}14${Bl} | Instalar temas" \
            " | " \
        " | ${Az}VPN - NETBIRD ${Bl}" \
            " | ============================" \
            "${Ne}15${Bl} | Instalar y entrar en Netbird" \
            " | " \
        " | ${Az}NFS ${Bl}" \
            " | ====================" \
            "${Ne}16${Bl} | Compartir un recurso" \
            " | " \
        " | ${Az}UPTIME-KUMA ${Bl}" \
            " | ==================" \
            "${Ne}17${Bl} | Cambiar de versión" \
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
    # CREAR CLUSTER
    ##############################################################
    1)
        clear
        read -p 'Nombre del clúster a crear: ' nombre_cluster

        echo -e "\n${Az}Creando clúster con nombre $nombre_cluster...${Bl}"
        pvecm create "$nombre_cluster"

        echo -e "\n${Az}Actualizando certificados...${Bl}"
        pvecm updatecerts --force

        echo -e "\n${Ve}¡Se ha creado el clúster correctamente!${Bl}"
        ;;

    ##############################################################
    # UNIRSE A CLUSTER
    ##############################################################
    2)
        clear
        echo -e "${Ro}!!! INSTALE ANTES NETBIRD !!!${Bl}"
        read -p 'Nodo máster (coruna1): ' nodo_nombre

        echo -e "\n${Az}Actualizando certificados...${Bl}"
        pvecm updatecerts --force

        echo -e "\n${Az}Intentando unirse al clúster $nodo_nombre...${Bl}"
        pvecm add "$nodo_nombre"

        echo -e "\n${Ve}¡Se unió al clúster correctamente!${Bl}"
        ;;

    ##############################################################
    # ELIMINAR CLUSTER
    ##############################################################
    3)
        clear
        echo -e "${Az}Parando servicios...${Bl}"
        systemctl stop pve-cluster corosync
        killall pmxcfs

        echo -e "\n${Az}Eliminando configuraciones...${Bl}"
        rm -rf /etc/corosync/*
        rm -f /etc/pve/corosync.conf
        rm -f /etc/pve/.members
        rm -f /etc/pve/.cluster.*
        rm -f /etc/pve/.corosync.*

        echo -e "\n${Az}Haciendo copia de seguridad de /etc/pve...${Bl}"
        mkdir -p /root/pve_backup
        cp -r /etc/pve/* /root/pve_backup/

        echo -e "\n${Az}Renombrando /etc/pve...${Bl}"
        mv /etc/pve /etc/pve.bak
        mkdir /etc/pve

        echo -e "\n${Az}Iniciando pmxcfs en modo local...${Bl}"
        pmxcfs -l

        echo -e "\n${Az}Iniciando servicios...${Bl}"
        systemctl start pve-cluster

        echo -e "\n${Ve}¡Se ha salido del clúster correctamente!${Bl}"
        ;;

    ##############################################################
    # INSTALAR E INICIAR SESIÓN EN CLOUDFLARED
    ##############################################################
    4)
        clear

        echo -e "${Az}Instalando Cloudflared...${Bl}"
        curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cloudflared.deb
        apt install -y ./cloudflared.deb

        echo -e "${Az}Eliminando el archivo temporal...${Bl}"
        rm -f ./cloudflared.deb

        echo -e "\n${Az}Instalando el servicio de cloudflared...${Bl}"
        cloudflared service install

        echo -e "\n${Az}Habilitando el servicio de cloudflared...${Bl}"
        systemctl enable --now cloudflared

        echo -e "\n${Az}Inicie sesión con la siguiente URL...${Bl}"
        cloudflared login

        echo -e "\n${Ve}¡Instalado y configurado correctamente!${Bl}"
        ;;

    ##############################################################
    # CREAR TÚNEL CLOUDFLARED - HTTP(S)
    ##############################################################
    5)
        clear
        echo -e "${Ro}!!! INSTALE E INICIE SESIÓN EN CLOUDFLARED !!!${Bl}"
        echo -e "${Ro}!!! ELIMINE EL REGISTRO DNS SI EXISTE !!!${Bl}"
        read -p 'Nombre del túnel a crear (sin espacios): ' nombre_tunel
        read -p 'Nombre del subdominio (solo subdominio): ' nombre_dominio
        read -p 'Puerto del servicio web: ' puerto_web
        read -p 'http/https: ' tipo_conexion

        echo -e "\n${Az}Creando túnel...${Bl}"
        info=$(cloudflared tunnel create "$nombre_tunel")

        # EXTRAER UUID
        uuid=$(echo "$info" | grep -oE '[0-9a-fA-F-]{36}' | head -n 1)

        echo -e "UUID del túnel: ${Am}$uuid${Bl}"

        echo -e "\n${Az}Creando la carpeta /etc/cloudflared...${Bl}"
        mkdir -p /etc/cloudflared

        echo -e "\n${Az}Creando y configurando el archivo config.yml...${Bl}"
        cat <<EOF > /etc/cloudflared/config.yml
tunnel: $uuid
credentials-file: /etc/cloudflared/$uuid.json
loglevel: debug
originRequest:
  noTLSVerify: true

ingress:
  - hostname: $nombre_dominio.chemahosting.es
    service: $tipo_conexion://localhost:$puerto_web
  - service: http_status:404
EOF

        echo -e "\n${Az}Copiando credenciales del túnel...${Bl}"
        cp ~/.cloudflared/"$uuid".json /etc/cloudflared/

        chmod 600 /etc/cloudflared/"$uuid".json
        chown root:root /etc/cloudflared/"$uuid".json

        echo -e "\n${Az}Creando registro DNS CNAME...${Bl}"
        cloudflared tunnel route dns "$nombre_tunel" "$nombre_dominio"

        echo -e "\n${Az}Instalando el servicio de cloudflared...${Bl}"
        cloudflared service install

        echo -e "\n${Az}Habilitando el servicio de Cloudflared...${Bl}"
        systemctl enable cloudflared

        echo -e "\n${Az}Reiniciando el servicio de Cloudflared...${Bl}"
        systemctl restart cloudflared

        echo -e "\n${Ve}¡Túnel creado correctamente!${Bl}"
        ;;

    ##############################################################
    # CREAR TÚNEL CLOUDFLARED - SERVICIO TCP
    ##############################################################
    6)
        clear
        echo -e "${Ro}!!! INSTALE E INICIE SESIÓN EN CLOUDFLARED !!!${Bl}"
        echo -e "${Ro}!!! ELIMINE EL REGISTRO DNS SI EXISTE !!!${Bl}"
        read -p 'Nombre del túnel a crear (sin espacios): ' nombre_tunel
        read -p 'Nombre del subdominio (solo subdominio): ' nombre_dominio
        read -p 'Puerto del servicio web: ' puerto_web

        echo -e "\n${Az}Creando túnel...${Bl}"
        info=$(cloudflared tunnel create "$nombre_tunel")

        # EXTRAER UUID
        uuid=$(echo "$info" | grep -oE '[0-9a-fA-F-]{36}' | head -n 1)

        echo -e "UUID del túnel: ${Am}$uuid${Bl}"

        echo -e "\n${Az}Creando carpeta /etc/cloudflared...${Bl}"
        mkdir -p /etc/cloudflared

        echo -e"\n${Az}Creando archivo $nombre_tunel.yml...${Bl}"
        cat <<EOF > /etc/cloudflared/$nombre_tunel.yml
tunnel: $uuid
credentials-file: /etc/cloudflared/$uuid.json
loglevel: debug
originRequest:
  noTLSVerify: true

ingress:
  - hostname: $nombre_dominio.chemahosting.es
    service: tcp://localhost:$puerto_web
  - service: http_status:404
EOF

        echo -e "\n${Az}Copiando credenciales del túnel...${Bl}"
        cp ~/.cloudflared/"$uuid".json /etc/cloudflared/

        chmod 600 /etc/cloudflared/"$uuid".json
        chown root:root /etc/cloudflared/"$uuid".json

        echo -e "\n${Az}Creando registro DNS CNAME...${Bl}"
        cloudflared tunnel route dns "$nombre_tunel" "$nombre_dominio"

        echo -e "\n${Az}Instalando el servicio de cloudflared...${Bl}"
        cloudflared service install

        echo -e "\n${Az}Habilitando el servicio de Cloudflared...${Bl}"
        systemctl enable cloudflared

        echo -e "\n${Az}Reiniciando el servicio de Cloudflared...${Bl}"
        systemctl restart cloudflared

        echo -e "\n${Ve}¡Túnel creado correctamente!${Bl}"
        ;;

    ##############################################################
    # PURGAR CLOUDFLARED
    ##############################################################
    7)
        clear

        echo -e "\n${Az}Parando el servicio 'cloudflared'...${Bl}"
        systemctl stop cloudflared

        echo -e "\n${Az}Deshabilitando el servicio 'cloudflared'...${Bl}"
        systemctl disable cloudflared

        echo -e "\n${Az}Purgando el paquete 'cloudflared'...${Bl}"
        apt purge cloudflared -y

        echo -e "\n${Az}Eliminando configuraciones...${Bl}"
        rm -rf /etc/cloudflared/*
        rm -rf /root/.cloudflared/*

        echo -e "\n${Ve}¡Cloudflared purgado correctamente!${Bl}"
        echo -e "\n${Am}(Los registros DNS deben eliminarse manualmente)${Bl}"
        ;;

    ##############################################################
    # APAGADO AUTOMÁTICO - CRONTAB
    ##############################################################
    8)
        clear
        read -p 'Hora a apagar: ' hora
        read -p 'Minutos a apagar: ' minuto
        read -p 'Segundos a apagar: ' segundos

        echo -e "\n${Az}Verificando...${Bl}"
        if ! [[ "$hora" =~ ^[0-9]+$ ]] || ! [[ "$minuto" =~ ^[0-9]+$ ]] || ! [[ "$segundos" =~ ^[0-9]+$ ]]; then
            echo -e "${Ro}Error: Solo se permiten números.${Bl}"
            exit 1
        fi

        if [ "$hora" -gt 23 ] || [ "$minuto" -gt 59 ] || [ "$segundos" -gt 59 ]; then
            echo -e "${Ro}Error: Hora, minuto o segundos fuera de rango.${Bl}"
            exit 1
        fi

        echo -e "\n${Az}Editando Crontab...${Bl}"
        tarea="$minuto $hora * * * /sbin/shutdown -h now"
        (crontab -l 2>/dev/null; echo "$tarea") | crontab -

        echo -e "\n${Ve}¡Política creada correctamente!${Bl}"
        ;;

    ##############################################################
    # INSTALAR DOCKER
    ##############################################################
    9)
        clear

        echo -e "${Az}Instalando...${Bl}"
        apt remove $(dpkg --get-selections docker.io docker-compose docker-doc podman-docker containerd runc | cut -f1)
        apt update
        apt install -y ca-certificates curl
        install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
        chmod a+r /etc/apt/keyrings/docker.asc
        tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
        apt update
        apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        systemctl start docker

        echo -e "\n${Az}Verificando...${Bl}"
        systemctl status docker

        echo -e "\n${Ve}¡Docker instalado correctamente!${Bl}"
        ;;

    ##############################################################
    # CLOUDFLARE DDNS
    # GitHub: https://github.com/favonia/cloudflare-ddns
    ##############################################################
    10)
        clear
        read -p 'Nombre del subdominio (solo subdominio): ' subdominio
        read -p 'CLOUDFLARE_API_TOKEN: ' api_token

        echo -e "\n${Az}Creando docker...${Bl}"
        docker run -d --restart=unless-stopped --network host -e CLOUDFLARE_API_TOKEN=$api_token -e DOMAINS=$subdominio.chemahosting.es -e PROXIED=false favonia/cloudflare-ddns:latest

        echo -e "\n${Az}Verificando...${Bl}"
        docker ps -a | grep favonia/cloudflare-ddns

        echo -e "${Ve}¡Docker creado correctamente!${Bl}"
        ;;

    ##############################################################
    # CT - CREAR BACKUP
    ##############################################################
    11)
        clear
        read -p 'ID del contenedor a hacer una backup: ' id_ct
        read -p 'Almacenamiento (local): ' almacenamiento

        echo -e "\n${Az}Creando backup...${Bl}"
        vzdump $id_ct --mode stop --compress lzo --storage $almacenamiento

        echo -e "\n${Ve}¡Backup creado correctamente!${Bl}"
        ;;

    ##############################################################
    # CT - RESTAURAR BACKUP
    ##############################################################
    12)
        clear
        read -p 'ID del contenedor a restaurar una backup: ' id_ct
        read -p 'Ruta al backup (.tar.lzo): ' ruta
        read -p 'Almacenamiento (local-lvm): ' almacenamiento

        echo -e "\n${Az}Restaurando backup...${Bl}"
        pct restore $id_ct $ruta --storage $almacenamiento

        echo -e "\n${Az}¡Backup restaurado correctamente!${Bl}"
        ;;

    ##############################################################
    # RESTAURAR LOCAL-LVM
    ##############################################################
    13)
        clear

        host=$(hostname)

        case "$host" in
            coruna1) valor="co1" ;;
            coruna2) valor="co2" ;;
            malaga1) valor="ma1" ;;
            malaga2) valor="ma2" ;;
            *)
                echo -e "\nHostname no reconocido: $host"
                echo "No se puede continuar."
                break
                ;;
        esac

        echo -e "\n${Az}Restaurando local-lvm...${Bl}"
        pvesm add lvmthin local-lvm-$valor --thinpool data --vgname pve --nodes "$host"

        echo -e "\n${Az}¡local-lvm restaurado correctamente!${Bl}"
        ;;

    ##############################################################
    # INSTALAR TEMAS
    ##############################################################
    14)
        clear

        echo -e "\n${Az}Descargando la carpeta...${Bl}"
        git clone https://github.com/Happyrobot33/PVEThemes

        echo -e "\n${Az}Haciendo 'cd' dentro de la carpeta...${Bl}"
        cd PVEThemes

        echo -e "\n${Az}Dando permisos al script...${Bl}"
        chmod +x install.sh
        
        echo -e "\n${Az}Ejecutando el script...${Bl}"
        echo -e "\n${Am}(EJECUTE LA OPCIÓN 'instalar')${Bl}"
        ./install.sh

        echo -e "\n${Az}Temas instalados correctamente!${Bl}"
        echo -e "\n${Am}(Borre la caché de la página web y luego ve al apartado de 'temas')${Bl}"
        ;;

    ##############################################################
    # INSTALAR Y ENTRAR A NETBIRD
    ##############################################################
    15)
        clear
        read -p 'Set-up key de Netbird: ' llave_netbird

        echo -e "\n${Az}Descargando Netbird...${Bl}"
        curl -fsSL https://pkgs.netbird.io/install.sh | bash

        echo -e "\n${Az}Iniciando conexión en Netbird...${Bl}"
        netbird up --setup-key "$llave_netbird" --allow-server-ssh --enable-ssh-root

        echo -e "\n${Az}Habilitando el servicio de Netbird...${Bl}"
        systemctl enable --now netbird

        echo -e "\n${Az}Añadiendo los nodos a /etc/hosts...${Bl}"
        grep -q "coruna1" /etc/hosts || cat <<EOF >> /etc/hosts
172.16.0.100 coruna1
172.16.0.101 coruna2
172.16.0.102 malaga1
172.16.0.103 malaga2
EOF

        echo -e "\n${Ve}¡Netbird instalado correctamente!${Bl}"
        ;;

    ##############################################################
    # NFS - COMPARTIR UN RECURSO 
    ##############################################################
    16)
        clear
        read -p 'Carpeta local a compartir: ' carpeta_local
        read -p 'Permisos (rw,ro): ' permisos        
        echo -e "\n${Am}* - Todos\nDirección_red/Máscara - A toda la subred\nIPv4 o hostname - A un equipo en concreto${Bl}"
        read -p 'A quien dar permiso (mirar la guía de arriba): ' permitido


        echo -e "\n${Az}Instalando dependencias...${Bl}"
        apt install -y nfs-kernel-server nfs-common

        echo -e "\n${Az}Configurando '/etc/exports'...${Bl}"
        echo "$carpeta_local $permitido($permisos,sync,no_subtree_check,no_root_squash)" >> /etc/exports

        echo -e "\n${Az}Aplicando cambios...${Bl}"
        exportfs -ra

        echo -e "\n${Az}Reiniciando servicio...${Bl}"
        systemctl restart nfs-kernel-server

        echo -e "\n${Ve}¡Recurso compartido correctamente!${Bl}"
        ;;

    ##############################################################
    # UPTIME-KUMA - ACTUALIZAR VERSIÓN 
    ##############################################################
    17)
        clear
        read -p 'Versión de GitHub a actualizar: ' version_github


        echo -e "\n${Az}Parando servicios...${Bl}"
        pm2 stop uptime-kuma

        echo -e "\n${Az}Obteniendo versiones...${Bl}"
        cd /opt/uptime-kuma
        git fetch --all
        git checkout "$version_github"

        echo -e "\n${Az}Instalando actualizaciones...${Bl}"
        npm install --omit=dev --no-audit
        npm run download-dist

        echo -e "\n${Az}Reiniciando servicios...${Bl}"
        pm2 restart uptime-kuma
        pm2 save

        echo -e "\n${Ve}¡Uptime-kuma actualizado correctamente!${Bl}"
        ;;

    ##############################################################

    *)
        echo -e "${Ro}Valor inválido${Bl}"
        ;;
    esac

    echo
    read -p "Pulse ENTER para reiniciar el programa: " _
done
