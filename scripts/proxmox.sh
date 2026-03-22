#!/bin/bash

# -- byad12.pages.dev/proxmox.sh
# -- www.chemahosting.es

##############################################################
# CODIFICACIÓN DEL ARCHIVO
##############################################################
export LANG=C.UTF-8
export LC_ALL=C.UTF-8

##############################################################
# INSTALAR DEPENDENCIAS
##############################################################
apt update
apt install -y cowsay cmatrix curl 
clear
if command -v cmatrix &> /dev/null; then
    cmatrix -b &
    PID=$!
    sleep 2
    kill $PID 2>/dev/null
    wait $PID 2>/dev/null
fi
clear

##############################################################
# DEFINIR BUCLE
##############################################################
while true; do
    clear
    /usr/games/cowsay -f tux CHEMA HOSTING

    Ne=$'\033[1m' # Texto en negrita
    Bl=$'\033[0m' # Resetear formato

    Ro=$'\033[31;1m' # Texto en negrita y en rojo
    Ro_=$'\033[31m' # Texto en rojo

    Ve=$'\033[32;1m' # Texto en negrita y en verde
    Ve_=$'\033[32m' # Texto en verde

    Am=$'\033[33;1m' # Texto en negrita y en amarillo
    Am_=$'\033[33m' # Texto en amarillo

    Az=$'\033[34;1m' # Texto en negrita y en azul
    Az_=$'\033[34m' # Texto en azul

    echo -e "Script hecho por ${Az}byAd12.pages.dev${Bl}\n   ${Ne}2025${Bl} - ${Az}www.chemahosting.es\n${Bl}"

    printf "%b\n" \
        " | ${Az}CONFIGURACIÓN BÁSICA ${Bl}" \
        " | ================================" \
            "${Ne}1${Bl} | Configuración inicial de un nodo" \
            "${Ne}2${Bl} | Configurar apagado automático" \
            " | " \
        " | ${Az}CLÚSTER ${Bl}" \
        " | ==========================" \
            "${Ne}3${Bl} | Crear un clúster" \
            "${Ne}4${Bl} | Unirse a un clúster" \
            "${Ne}5${Bl} | Quitar un nodo del clúster" \
            "${Ne}6${Bl} | Eliminar un clúster" \
            "${Ne}7${Bl} | Corosync - Configurar" \
            " | " \
        " | ${Az}CLOUDFLARED ${Bl}" \
        " | =============================" \
            "${Ne}8${Bl} | Instalar e iniciar sesión" \
            "${Ne}9${Bl} | Crear un túnel - HTTP(S)" \
            "${Ne}10${Bl} | Crear un túnel - Servicio TCP" \
            "${Ne}11${Bl} | Purgar cloudflared" \
            " | " \
        " | ${Az}DOCKER ${Bl}" \
        " | ========================" \
            "${Ne}12${Bl} | Instalar docker - Debian" \
            "${Ne}13${Bl} | favonia/cloudflare-ddns" \
            " | " \
        " | ${Az}PROXMOX ${Bl}" \
        " | ============================" \
            "${Ne}14${Bl} | CT - Crear backup" \
            "${Ne}15${Bl} | CT - Restaurar backup" \
            "${Ne}16${Bl} | Restaurar local-lvm" \
            "${Ne}17${Bl} | Instalar temas" \
            "${Ne}18${Bl} | LXC - Desbloquear contenedor" \
            " | " \
        " | ${Az}VPN - NETBIRD ${Bl}" \
        " | ============================" \
            "${Ne}19${Bl} | Instalar y entrar en Netbird" \
            "${Ne}20${Bl} | Desinstalar y purgar Netbird" \
            " | " \
        " | ${Az}NFS ${Bl}" \
        " | ====================" \
            "${Ne}21${Bl} | Compartir un recurso" \
            " | " \
        " | ${Az}UPTIME-KUMA ${Bl}" \
        " | ==================" \
            "${Ne}22${Bl} | Cambiar de versión" \
            " | " \
        " | ${Az}SERVICIOS ${Bl}" \
        " | =====================================" \
            "${Ne}23${Bl} | Ejecutar un archivo .py como servicio" \
            "${Ne}24${Bl} | Alertas de Discord" \
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
    # CONFIGURACIÓN INICIAL DE UN NODO
    ##############################################################
    1)
        clear

        echo -e "\n${Az}Configuración actual de timedatectl...${Bl}"
        timedatectl

        echo -e "\n${Az}Ajustando la hora de la BIOS a RTC + 1...${Bl}"
        timedatectl set-local-rtc 1 --adjust-system-clock

        echo -e "\n${Az}Verificando cambios de timedatectl...${Bl}"
        timedatectl

        echo -e "\n${Az}Instalando dependencias...${Bl}"
        apt install -y fastfetch

        echo -e "\n${Az}Aplicando configuración básica...${Bl}"
        if ! grep -q "clear" ~/.bashrc; then
            echo "clear" >> ~/.bashrc
        fi
        if ! grep -q "fastfetch" ~/.bashrc; then
            echo "fastfetch" >> ~/.bashrc
            echo "echo ''" >> ~/.bashrc
        fi

        echo -e "\n${Ve}¡Se ha aplicado la configuración inicial correctamente!${Bl}"
        ;;

    ##############################################################
    # APAGADO AUTOMÁTICO - CRONTAB
    ##############################################################
    2)
        clear

        echo -e "${Ro}Requisitos:${Bl}"
        echo -e "${Ro_}  1.  Ejecutar la opción 'BIOS: Arreglo de la zona horaria'.${Bl}"
        echo -e ""

        read -p 'Hora a apagar: ' hora; [[ -z "${hora// /}" || "$hora" == "exit" ]] && continue
        read -p 'Minutos a apagar: ' minuto; [[ -z "${minuto// /}" || "$minuto" == "exit" ]] && continue
        read -p 'Segundos a apagar: ' segundos; [[ -z "${segundos// /}" || "$segundos" == "exit" ]] && continue

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
    # CREAR CLUSTER
    ##############################################################
    3)
        clear

        read -p 'Nombre del clúster a crear: ' nombre_cluster; [[ -z "${nombre_cluster// /}" || "$nombre_cluster" == "exit" ]] && continue

        echo -e "\n${Az}Creando clúster con nombre $nombre_cluster...${Bl}"
        pvecm create "$nombre_cluster"

        echo -e "\n${Az}Actualizando certificados...${Bl}"
        pvecm updatecerts --force

        echo -e "\n${Ve}¡Se ha creado el clúster correctamente!${Bl}"
        ;;

    ##############################################################
    # UNIRSE A CLUSTER
    ##############################################################
    4)
        clear

        echo -e "${Ro}Requisitos:${Bl}"
        echo -e "${Ro_}  1.  No tener ningún CT ni VM creada en el sistema.${Bl}"
        echo -e "${Ro_}  2.  Ejecutar la opción 'Instalar y entrar en Netbird'.${Bl}"
        echo -e "${Ro_}  3.  Seleccionar el nodo máster que creó el clúster.${Bl}"
        echo -e "${Ro_}  4.  Saber la contraseña del nodo máster.${Bl}"
        echo -e ""

        read -p 'Nodo máster (coruna1): ' nodo_nombre; [[ -z "${nodo_nombre// /}" || "$nodo_nombre" == "exit" ]] && continue

        echo -e "\n${Az}Comprobando conexión con el nodo máster...${Bl}"
        ping -c 2 "$nodo_nombre"
        if [ $? -ne 0 ]; then
            echo -e "\n${Ro}ERROR: ${Ro_}No se puede alcanzar a '${Az}$nodo_nombre${Ro_}'.${Bl}"
            read -p "\nPulse ENTER para reiniciar el programa:"
            continue
        fi

        echo -e "\n${Az}Actualizando certificados...${Bl}"
        pvecm updatecerts --force

        echo -e "\n${Az}Intentando unirse al clúster $nodo_nombre...${Bl}"
        pvecm add "$nodo_nombre"

        echo -e "\n${Ve}¡Se unió al clúster correctamente!${Bl}"
        ;;

    ##############################################################
    # SALIRSE DE UN CLUSTER
    ##############################################################
    5)
        clear

        # Evitar quitar un nodo si no es desde coruna1
        if [ "$(hostname)" != "coruna1" ]; then
            echo -e "${Am}No puedes ejecutar esta opción en un nodo esclavo.${Bl}"
            read -p "\nPulse ENTER para reiniciar el programa:"
            continue
        fi

        read -p "${Ro_}1/2 ¿Estás seguro de querer quitar este nodo del clúster? (s/${Ro}n${Ro_}): ${Bl}" verificacion1; [[ "$verificacion1" != "s" && "$verificacion1" != "S" ]] && continue
        read -p "${Ro_}2/2 ¿Estás seguro de querer quitar este nodo del clúster? (s/${Ro}n${Ro_}): ${Bl}" verificacion2; [[ "$verificacion2" != "s" && "$verificacion2" != "S" ]] && continue
        echo -e ""
        read -p "${Am}Ingrese la contraseña para ejecutar esta función: ${Bl}" verificacion3; [[ -z "${verificacion3// /}" || "$verificacion3" == "exit" ]] && continue

        hash_ingresado=$(echo -n "$verificacion3" | sha256sum | awk '{print $1}')

        if [ "$hash_ingresado" == "f2e53c927c66fe711e8e88ef9b37a8e3187f1652216b313fc8eb2513883dd360" ]; then
            read -p 'Nodo a quitar del clúster: ' nodo_nombre; [[ -z "${nodo_nombre// /}" || "$nodo_nombre" == "exit" ]] && continue

            echo -e "\n${Az}Intentando quitar del clúster a $nodo_nombre...${Bl}"
            pvecm del "$nodo_nombre"

            echo -e "\n${Ve}¡Se eliminó el nodo del clúster correctamente!${Bl}"
        else
            echo -e "${Ro_}Contraseña incorrecta${Bl}"
        fi
        ;;

    ##############################################################
    # ELIMINAR CLUSTER
    ##############################################################
    6)
        clear

        # Evitar eliminar el clúster desde coruna1
        if [ "$(hostname)" == "coruna1" ]; then
            echo -e "${Am}No puedes ejecutar esta opción en el nodo maestro.${Bl}"
            read -p "\nPulse ENTER para reiniciar el programa:"
            continue
        fi

        read -p "${Ro_}1/2 ¿Estás seguro de querer eliminar el clúster? (s/${Ro}n${Ro_}): ${Bl}" verificacion1; [[ "$verificacion1" != "s" && "$verificacion1" != "S" ]] && continue
        read -p "${Ro_}2/2 ¿Estás seguro de querer eliminar el clúster? (s/${Ro}n${Ro_}): ${Bl}" verificacion2; [[ "$verificacion2" != "s" && "$verificacion2" != "S" ]] && continue
        echo -e ""
        read -p "${Am}Ingrese la contraseña para ejecutar esta función: ${Bl}" verificacion4; [[ -z "${verificacion4// /}" || "$verificacion4" == "exit" ]] && continue

        hash_ingresado=$(echo -n "$verificacion4" | sha256sum | awk '{print $1}')

        if [ "$hash_ingresado" == "f2e53c927c66fe711e8e88ef9b37a8e3187f1652216b313fc8eb2513883dd360" ]; then
            echo -e "${Ve_}Contraseña correcta${Bl}"

            echo -e "${Az}Parando servicios...${Bl}"
            systemctl stop pve-cluster corosync
            killall -9 pmxcfs 2>/dev/null

            echo -e "${Az}Haciendo copia de seguridad de Corosync...${Bl}"
            mkdir -p /root/pve_backup
            cp -r /etc/pve/corosync.conf /root/pve_backup/ 2>/dev/null

            echo -e "${Az}Limpiando archivos de configuración de Corosync...${Bl}"
            rm -f /etc/pve/corosync.conf
            rm -rf /etc/corosync/*
            
            pmxcfs -l
            pvecm updatecerts --force
            
            systemctl restart pve-cluster
            systemctl stop corosync
            systemctl disable corosync

            echo -e "\n${Ve}¡Se ha salido del clúster correctamente!${Bl}"
            echo -e "${Ve}Copia de seguridad de /etc/pve en /root/pve_backup${Bl}"
        else
            echo -e "${Ro_}Contraseña incorrecta${Bl}"
        fi

        ;;

    ##############################################################
    # EDITAR LA CONFIGURACIÓN DE COROSYNC
    ##############################################################
    7)
        clear

        if [ "$(hostname)" != "coruna1" ]; then
            echo -e "${Am}No puedes ejecutar esta opción en un nodo esclavo.${Bl}"
            read -p "\nPulse ENTER para reiniciar el programa:"
            continue
        fi

        echo -e "\n${Az}Parando servicio(s)...${Bl}"
        systemctl stop pve-cluster

        echo -e "\n${Az}Iniciando pmxcfs en local...${Bl}"
        pmxcfs -l

        echo -e "\n${Az}Abriendo el editor nano...${Bl}"
        /usr/bin/nano /etc/pve/corosync.conf

        echo -e "\n${Az}Cerrando pmxcfs...${Bl}"
        killall pmxcfs

        echo -e "\n${Az}Iniciando servicios...${Bl}"
        systemctl start pve-cluster pvedaemon pvestatd

        echo -e "\n${Ve}¡Se configuró corosync correctamente!${Bl}"
        ;;

    ##############################################################
    # INSTALAR E INICIAR SESIÓN EN CLOUDFLARED
    ##############################################################
    8)
        clear

        echo -e "${Ro}Requisitos:${Bl}"
        echo -e "${Ro_}  1.  El administrador debe estar activo para permitir el inicio de sesión.${Bl}"
        echo -e ""

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
    9)
        clear

        echo -e "${Ro}Requisitos:${Bl}"
        echo -e "${Ro_}  1.  Ejecutar la opción 'Instalar e iniciar sesión' de Cloudflared.${Bl}"
        echo -e "${Ro_}  2.  El administrador debe eliminar el registro DNS si existe.${Bl}"
        echo -e "${Ro_}  3.  No tener ningún túnel previamente creado.${Bl}"
        echo -e ""

        read -p 'Nombre del túnel a crear (sin espacios): ' nombre_tunel; [[ -z "${nombre_tunel// /}" || "$nombre_tunel" == "exit" ]] && continue
        read -p 'Nombre del subdominio (solo subdominio): ' nombre_dominio; [[ -z "${nombre_dominio// /}" || "$nombre_dominio" == "exit" ]] && continue
        read -p 'Puerto del servicio web: ' puerto_web; [[ -z "${puerto_web// /}" || "$puerto_web" == "exit" ]] && continue
        read -p 'http/https: ' tipo_conexion; [[ -z "${tipo_conexion// /}" || "$tipo_conexion" == "exit" ]] && continue

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
    10)
        clear

        echo -e "${Ro}Requisitos:${Bl}"
        echo -e "${Ro_}  1.  Ejecutar la opción 'Instalar e iniciar sesión' de Cloudflared.${Bl}"
        echo -e "${Ro_}  2.  El administrador debe eliminar el registro DNS si existe.${Bl}"
        echo -e "${Ro_}  3.  No tener ningún túnel previamente creado.${Bl}"
        echo -e ""

        read -p 'Nombre del túnel a crear (sin espacios): ' nombre_tunel; [[ -z "${nombre_tunel// /}" || "$nombre_tunel" == "exit" ]] && continue
        read -p 'Nombre del subdominio (solo subdominio): ' nombre_dominio; [[ -z "${nombre_dominio// /}" || "$nombre_dominio" == "exit" ]] && continue
        read -p 'Puerto del servicio web: ' puerto_web; [[ -z "${puerto_web// /}" || "$puerto_web" == "exit" ]] && continue

        echo -e "\n${Az}Creando túnel...${Bl}"
        info=$(cloudflared tunnel create "$nombre_tunel")

        # EXTRAER UUID
        uuid=$(echo "$info" | grep -oE '[0-9a-fA-F-]{36}' | head -n 1)

        echo -e "UUID del túnel: ${Am}$uuid${Bl}"

        echo -e "\n${Az}Creando carpeta /etc/cloudflared...${Bl}"
        mkdir -p /etc/cloudflared

        echo -e "\n${Az}Creando archivo config.yml...${Bl}"
        cat <<EOF > /etc/cloudflared/config.yml
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
    11)
        clear

        echo -e "${Am}Aviso:${Bl}"
        echo -e "${Am}  Los túneles creados se eliminarán localmente, pero no en Cloudflare.${Bl}"
        echo -e ""

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
    # INSTALAR DOCKER
    ##############################################################
    12)
        clear

        echo -e "${Am}Aviso:${Bl}"
        echo -e "${Am}  Esta instalación se basa en Debian.${Bl}"
        echo -e ""

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
    13)
        clear

        echo -e "${Ro}Requisitos:${Bl}"
        echo -e "${Ro_}  1.  El administrador debe eliminar el registro DNS si existe.${Bl}"
        echo -e "${Ro_}  2.  Debes tener el API TOKEN de Cloudflare.${Bl}"
        echo -e ""

        echo -e "${Am}Importante:${Bl}"
        echo -e "${Am_}  Debes proteger tu red mediante reglas de Firewall ya que la IPv4 pública será expuesta.${Bl}"
        echo -e ""

        read -p 'Nombre del subdominio (solo subdominio): ' subdominio; [[ -z "${subdominio// /}" || "$subdominio" == "exit" ]] && continue
        read -p 'CLOUDFLARE_API_TOKEN: ' api_token; [[ -z "${api_token// /}" || "$api_token" == "exit" ]] && continue

        echo -e "\n${Az}Creando docker...${Bl}"
        docker run -d --restart=unless-stopped --network host -e CLOUDFLARE_API_TOKEN=$api_token -e DOMAINS=$subdominio.chemahosting.es -e PROXIED=false favonia/cloudflare-ddns:latest

        echo -e "\n${Az}Verificando...${Bl}"
        docker ps -a | grep favonia/cloudflare-ddns

        echo -e "${Ve}¡Docker creado correctamente!${Bl}"
        ;;

    ##############################################################
    # CT - CREAR BACKUP
    ##############################################################
    14)
        clear

        read -p 'ID del contenedor a hacer una backup: ' id_ct; [[ -z "${id_ct// /}" || "$id_ct" == "exit" ]] && continue
        read -p 'Almacenamiento (local): ' almacenamiento; [[ -z "${almacenamiento// /}" || "$almacenamiento" == "exit" ]] && continue

        echo -e "\n${Az}Creando backup...${Bl}"
        vzdump $id_ct --mode stop --compress lzo --storage $almacenamiento

        echo -e "\n${Ve}¡Backup creado correctamente!${Bl}"
        ;;

    ##############################################################
    # CT - RESTAURAR BACKUP
    ##############################################################
    15)
        clear

        read -p 'ID del contenedor a restaurar una backup: ' id_ct; [[ -z "${id_ct// /}" || "$id_ct" == "exit" ]] && continue
        read -p 'Ruta al backup (.tar.lzo): ' ruta; [[ -z "${ruta// /}" || "$ruta" == "exit" ]] && continue
        read -p 'Almacenamiento (local-lvm): ' almacenamiento; [[ -z "${almacenamiento// /}" || "$almacenamiento" == "exit" ]] && continue

        echo -e "\n${Az}Restaurando backup...${Bl}"
        pct restore $id_ct $ruta --storage $almacenamiento

        echo -e "\n${Az}¡Backup restaurado correctamente!${Bl}"
        ;;

    ##############################################################
    # RESTAURAR LOCAL-LVM
    ##############################################################
    16)
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
    17)
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
    # LXC - DESBLOQUEAR CONTENEDOR
    ##############################################################
    18)
        clear

        read -p 'ID del contenedor: ' id_contenedor; [[ -z "${id_contenedor// /}" || "$id_contenedor" == "exit" ]] && continue

        echo -e "\n${Az}Estado el contenedor...${Bl}"
        pct status $id_contenedor

        echo -e "\n${Az}Desbloqueando el contenedor...${Bl}"
        pct unlock $id_contenedor

        echo -e "\n${Az}Estado el contenedor...${Bl}"
        pct status $id_contenedor

        echo -e "\n${Am}Si no funcionó lo anterior, puede eliminar el lock manualmente con:${Bl}"
        echo -e "rm /var/lock/lxc/${id_contenedor}.lock"

        echo -e "\n${Ve}¡Contenedor desbloqueado correctamente!${Bl}"
        ;;

    ##############################################################
    # INSTALAR Y ENTRAR A NETBIRD
    ##############################################################
    19)
        clear

        echo -e "${Ro}Requisitos:${Bl}"
        echo -e "${Ro_}  1.  Debes tener el Set-up key de Netbird.${Bl}"
        echo -e "${Ro_}  2.  Un administrador debe cambiar la IPv4 desde el panel de administración.${Bl}"
        echo -e "${Ro_}  3.  La IPv4 que se vaya a configurar debe estar libre.${Bl}"
        echo -e "${Ro_}  4.  Se debe eliminar del archivo '${Az}/etc/hosts${Ro_}' cualquier registro antigüo.${Bl}"
        echo -e ""

        read -p 'Set-up key de Netbird: ' llave_netbird; [[ -z "${llave_netbird// /}" || "$llave_netbird" == "exit" ]] && continue
        read -p 'Nombre que se le asignará en NetBird: ' nombre_equipo; [[ -z "${nombre_equipo// /}" || "$nombre_equipo" == "exit" ]] && continue

        echo -e "\n${Az}Descargando Netbird...${Bl}"
        curl -fsSL https://pkgs.netbird.io/install.sh | bash

        echo -e "\n${Az}Iniciando conexión con Netbird...${Bl}"
        netbird up --setup-key "$llave_netbird" --allow-server-ssh --enable-ssh-root --hostname "$nombre_equipo"

        echo -e "\n${Az}Habilitando el servicio de Netbird...${Bl}"
        systemctl enable --now netbird

        echo -e "\n${Az}Añadiendo los nodos a /etc/hosts...${Bl}"
        grep -q "coruna1" /etc/hosts || cat <<EOF >> /etc/hosts
172.16.0.100 coruna1
172.16.0.101 coruna2

172.16.0.102 malaga1
172.16.0.103 malaga2
172.16.0.104 malaga3
172.16.0.106 malaga4
EOF

        echo -e "\n${Az}Tu IPv4 de NetBird actual es:${Bl}"
        netbird status --ipv4

        echo -e "\n${Am}Cambie ahora la IPv4 del nodo desde el panel de administración de Netbird, luego puse ENTER.${Bl}"
        read -p '' _

        echo -e "\n${Az}Reiniciando conexión con Netbird...${Bl}"
        netbird down
        systemctl restart netbird # Aquí se debería hacer el netbird up automáticamente
        sleep 2

        echo -e "\n${Az}Verificando conexión con Netbird...${Bl}"
        netbird up --setup-key "$llave_netbird" --allow-server-ssh --enable-ssh-root --hostname "$nombre_equipo"

        echo -e "\n${Az}Tu IPv4 de NetBird actual es:${Bl}"
        netbird status --ipv4

        echo -e "\n${Ve}¡Netbird instalado correctamente!${Bl}"
        ;;

    ##############################################################
    # DESINSTALAR Y PURGAR NETBIRD
    ##############################################################
    20)
        clear

        read -p "${Ro_}¿Estás seguro de querer desinstalar Netbird? (s/${Ro}n${Ro_}): ${Bl}" verificacion1; [[ "$verificacion1" != "s" && "$verificacion1" != "S" ]] && continue

        echo -e "\n${Az}Desconectando el peer de la red...${Bl}"
        netbird down

        echo -e "\n${Az}Quitando el peer de la red...${Bl}"
        netbird deregister

        echo -e "\n${Az}Parando servicios...${Bl}"
        systemctl stop netbird
        systemctl disable netbird

        echo -e "\n${Az}Desinstalando Netbird...${Bl}"
        apt remove --purge netbird -y

        echo -e "\n${Az}Eliminando el repositorio y clave GPG...${Bl}"
        rm -f /etc/apt/sources.list.d/netbird.list
        rm -f /usr/share/keyrings/netbird-archive-keyring.gpg

        echo -e "\n${Az}Borrando archivos y carpetas de configuración...${Bl}"
        rm -rf /etc/netbird
        rm -rf /var/lib/netbird
        rm -rf /var/log/netbird
        rm -rf ~/.config/netbird
        rm -rf ~/.netbird

        echo -e "\n${Ve}¡Netbird desinstalado correctamente!${Bl}"
        ;;

    ##############################################################
    # NFS - COMPARTIR UN RECURSO 
    ##############################################################
    21)
        clear

        echo -e "${Ne}Nota:${Bl}"
        echo -e "  Puedes editar esta configuración en un futuro con el archivo '${Az}/etc/exports${Bl}'."
        echo -e ""

        read -p 'Carpeta local a compartir: ' carpeta_local; [[ -z "${carpeta_local// /}" || "$carpeta_local" == "exit" ]] && continue
        read -p 'Permisos (rw,ro): ' permisos; [[ -z "${permisos// /}" || "$permisos" == "exit" ]] && continue        
        echo -e "\n${Am}* - Todos\nDirección_red/Máscara - A toda la subred\nIPv4 o hostname - A un equipo en concreto${Bl}"
        read -p 'A quien dar permiso (mirar la guía de arriba): ' permitido; [[ -z "${permitido// /}" || "$permitido" == "exit" ]] && continue

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
    22)
        clear

        echo -e "\n${Am}Para ver la última versión disponible: ${Az}https://github.com/louislam/uptime-kuma/releases${Bl}"
        read -p 'Versión de GitHub a actualizar: ' version_github; [[ -z "${version_github// /}" || "$version_github" == "exit" ]] && continue

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
    # PYTHON - EJECUTAR UN ARCHIVO COMO SERVICIO 
    ##############################################################
    23)
        clear

        echo -e "${Ro}Requisitos:${Bl}"
        echo -e "${Ro_}  1.  Hay que tener python previamente instalado.${Bl}"
        echo -e "${Ro_}  2.  Al principio del archivo .py debe haber esta línea: '${Az}#!/usr/bin/env python3${Ro_}'.${Bl}"
        echo -e ""

        read -p 'Ruta absoluta al archivo: ' ruta_archivo; [[ -z "${ruta_archivo// /}" || "$ruta_archivo" == "exit" ]] && continue

        echo -e "\n${Az}Verificando versión de python...${Bl}"
        python --version
        python3 --version

        echo -e "\n${Az}Asignando permisos al archivo...${Bl}"
        chmod +x $ruta_archivo

        echo -e "\n${Az}Asignando permisos al archivo...${Bl}"
        cat <<EOF > /etc/systemd/system/script-python.service
[Unit]
Description=Script de Python: $(basename "$ruta_archivo")
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/bin/python3 "$ruta_archivo"
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

        echo -e "\n${Az}Recargando systemd...${Bl}"
        systemctl daemon-reload

        echo -e "\n${Az}Arrancando servicio...${Bl}"
        systemctl start script-python.service


        echo -e "\n${Az}Habilitando el servicio...${Bl}"
        systemctl enable script-python.service

        echo -e "\n${Az}Para editar parámetros edite el siguiente archivo: ${Az}/etc/systemd/system/script-python.service${Bl}"

        echo -e "\n${Ve}¡Archivo asignado como servicio correctamente!${Bl}"
        ;;

    ##############################################################
    # ALERTAS 
    ##############################################################
    24)
        clear

        read -p 'Webhook de Discord: ' webhook; [[ -z "${webhook// /}" || "$webhook" == "exit" ]] && continue

        echo -e "\n${Az}Instalando dependencias...${Bl}"
        apt install -y curl

        echo -e "\n${Az}Creando script...${Bl}"
        cat <<'EOF' > /usr/local/bin/discord-alerta.sh
#!/bin/bash
[[ -z "$1" || "$1" == *"discord-alerta.sh"* || "$1" == "history"* ]] && exit 0

WEBHOOK="REPLACEME_WEBHOOK"
HOSTNAME=$(hostname)
USER_NAME=$(whoami)
USER_ID=$(id -u)
IP_CON=$(who am i | awk '{print $NF}' | tr -d '()')
CLEAN_CMD=$(echo "$1" | sed 's/"/\\"/g')

MESSAGE="### host $HOSTNAME • $USER_NAME (\`$IP_CON\`) • uid \`$USER_ID\`\n\n\`\`\`bash\n$CLEAN_CMD\n\`\`\`"

PAYLOAD="{\"content\": \"$MESSAGE\"}"
curl -s -H "Content-Type: application/json" -X POST -d "$PAYLOAD" "$WEBHOOK" > /dev/null 2>&1 &
EOF

        sed -i "s|REPLACEME_WEBHOOK|$webhook|" /usr/local/bin/discord-alerta.sh
        chmod +x /usr/local/bin/discord-alerta.sh

        echo -e "\n${Az}Inyectando hook en /etc/bash.bashrc...${Bl}"
        if ! grep -q "Monitor Discord" /etc/bash.bashrc; then
            cat <<'EOF' >> /etc/bash.bashrc

# --- Monitor Discord ---
logger_discord() {
    if [ "$BASH_COMMAND" != "$LAST_CMD" ]; then
        /usr/local/bin/discord-alerta.sh "$BASH_COMMAND"
        LAST_CMD="$BASH_COMMAND"
    fi
}
trap 'logger_discord' DEBUG
# -----------------------
EOF
            echo -e "${Ve}Hook inyectado en /etc/bash.bashrc correctamente.${Bl}"
        else
            echo -e "${Ro}El hook ya existe en /etc/bash.bashrc, saltando...${Bl}"
        fi

        echo -e "\n${Ve}¡Configurado! REINICIA LA SESIÓN para activar las alertas.${Bl}"
        ;;

    ##############################################################

    *)
        echo -e "${Ro}Valor inválido${Bl}"
        ;;
    esac

    echo
    read -p "Pulse ENTER para reiniciar el programa: " _
done
