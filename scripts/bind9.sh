#!/bin/bash

clear
trap 'exit' SIGINT SIGTSTP SIGQUIT EXIT

declare -A preguntas=(
    ["Definición: Autoridad que administra los dominios\ngeográficos de cada país y asigna IPs garantizando\nque sean únicas"]="65df858ff84fb90000dedb8598048433644250517e4eaa8e3afb4265f8ef472f"
    ["¿Archivo de configuración de un servicio dhcp?"]="1faadb83010c6bf194ad356e97cfa24c051a66e4a0ff6e9657492a693befdceb"
    ["¿Comando de Docker para listar todos los dockers?"]="162035ec2d281b1bbcb04ab3942d79b23465716ebc2d183f90cac10f91c6e567"
    ["¿Un Docker es escalable? (si/no)"]="97a62ad21d79c01cceb7767952acec4fec86bfe909b06e5f3f6963365cf91ab8"
    ["¿Que puerto usa ssh?"]="785f3ec7eb32f30b90cd0fcf3657d388b5ff4297f2f9716ff66e9b69c05ddd09"
    ["¿Ficheros de registros de errores del sistema?"]="6170ec3837f15d64f5b63dfca1db13ace08066bbfd0cceeea8cae352cb4ad4e6"
    ["¿Número de puerto que usa el servicio dhcp?"]="49d180ecf56132819571bf39d9b7b342522a2ac6d23c1418d3338251bfe469c8"
    ["¿Comando de Docker para instalar una imagen?"]="c88a9536a858b33d369f2ae1cfaf7860d3f0c6f7f5d8a6a55ff1607605ee8ac5"
    ["¿Fichero de sitios Virtuales disponibles en apache2?"]="3f6669189b0630b7461f847e0b0633815b0b100d095dbcb5b3f5e939279ce039"
    ["¿Fichero de configuración por defecto de apache2?"]="f91db4633742f5c66d674c454d180148abc9f0a657067e220a3f3a881ef5a60a"
    ["¿Comando de Docker para parar un docker?"]="22a424d612905eb55f0f153f80a78b9ed1c3eb6d34cebb7b1051ec59d8af22b0"
    ["¿Nombre del usuario anónimo de FTP?"]="2f183a4e64493af3f377f745eda502363cd3e7ef6e4d266d444758de0a85fcc8"
    ["¿Comando de Docker para las redes y de que tipos son?"]="e9f8851ccd23367bbc9e67deaf5ae40f1b2c080dd309f035bbb532b98c17e04d"
    ["¿Fichero de zonas de bind9?"]="ee6313fed5f5629a6e1190e6f372b42fad82ba935da385516f84841cae85c810"
    ["¿Fichero de Configuración del DNS en bind9?"]="49ed0dbe318605cbe52348626cf30c30b03943ce9ee83f7e1558009e9e98bc8d"
    ["¿La parte de la ICANN que autoriza estos TLD es?"]="6cc2f04ca32fc7a1089164b07554d13d42cb681dcd8c4692237eb7384a4143f4"
    ["¿Cuantas versiones de ssh existen? (numéricamente)"]="d4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35"
    ["¿Fichero de Configuración del servidor de bind9?"]="c93e09db7b401e464a0b38e0969ebb1e341e4652431c048aa8a915efef171f72"
    ["¿Como se llama la versión segura de FTP?"]="224ab2a03cfa58059b7be114fb62e741ad45d0722cc493728e4d3871a2ec23d4"
    ["¿Fichero de puertos a usar en apache2?"]="bd3bd0de6935d646c64adc80aaba15e545be60c3ca4503ca98fab2bad9a0d0c6"
    ["¿Con que protocolo se reciben emails? (versión 3)"]="1f744acf08618614de8daad9363dcb56b7273d3c2696a2f04462aca698611a9a"
    ["¿Abreviatura home personal de tu usuario?"]="7ace431cb61584cb9b8dc7ec08cf38ac0a2d649660be86d349fb43108b542fa4"
    ["¿Que version de ssh es mas segura?"]="138eb794291063f84a0892de979d4c69264cfcdfe2fa2bb80ca80ac4b0677b5f"
    ["¿Se suele usar el reenvío de puertos en ssh?(si/no)"]="97a62ad21d79c01cceb7767952acec4fec86bfe909b06e5f3f6963365cf91ab8"
    ["¿Fichero de zonas por defecto de bind9?"]="af04723c1b6b0e9ed64136867e378db69d2acb332102ea133207a8f789e70755"
    ["¿Comando de Docker para iniciar un docker?"]="0e2c4018ed08f5a04d7a0bdf778ece611e221beb9ebb21b8569236f8e76548fc"
    ["¿Directorio raíz de apache2?"]="69dd2b02e1f3a65918182048ea4e29979a849d8942e8f53ed20a4bf10e529b36"
    ["¿Que comando de conexión remota es seguro?"]="7f5a55cf3f88be936fb9440249cb449f3067ccee4b525d0027dc9278a29c32c1"
    ["¿Con que protocolo se envían emails?"]="4ae524ef0a54bc56e3844482dff66d3dd1c07170a36531500327556e4eb58a66"
    ["¿Fichero de zonas del servidor de apache2?"]="75cb1b73573ef48c2ee20ce24afa2b10633a8f56f4e8e74247afa01435ae20b9"
    ["Definición: Dominios de 1º nivel que cuelgan\ndirectamente del nodo raíz. Son gestionados por ICANN"]="c623e88a36fefda563e01ebc8f50ad998c2bbc92dd66d9f3f254ad691f99e9a2"
    ["¿Que comando de conexión remota NO es seguro?"]="5a4f77d09a9b2832e2e548152026ceb71b9bcea7d2cadf4b44cc8d23c428001d"
    ["¿Nombre del servicio FTP en Linux?"]="42af412d8659682b424ae18b14522fcdc5bd83d19a4932ee8802f5a565946947"
    ["¿De cuantos puertos requiere FTP?(numéricamente)"]="d4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35"
    ["¿Comando de Linux permite des/cifrar archivos?"]="6858a423dc9e04f67929d2c0bdf95e246efa280e0551e3152db2ec9d274e378a"
    ["¿Por que puerto hay que acceder al servidor FTP?"]="6f4b6612125fb3a0daecd2799dfd6c9c299424fd920f9b308110a2c1fbd8f443"
    ["¿Comando de Docker para listar dockers en ejecución?"]="3fe570f4395819898decbc3e8a55e0597bf7edf491d61fbc74b4138faa9e99bd"
    ["Definición (DNS): Crea un alias para un nombre para\nque varios nombres apunten a la misma IP"]="76b26edb75578663ca0fd6515ec7880ca04046bdbab298938981c9f0bd3907dd"
    ["¿Fichero de sitios Virtuales habilitados en apache2?"]="7d556f4189a97b3432f06f57e25d8a0ecab817fcde2f0fc5dbb1d0948d8ffe5e"
)

while true; do
    mapfile -t lista_preguntas < <(printf "%s\n" "${!preguntas[@]}" | shuf)
    total=${#preguntas[@]}
    aciertos=0

    for p in "${lista_preguntas[@]}"; do
        [[ -z "$p" ]] && continue

        if [ $aciertos == 10 ]; then
            break
        fi

        # INPUT
        respuesta_correcta_hash="${preguntas[$p]}"
        respuesta_usuario=$(whiptail --title "Pregunta ($((aciertos+1))/10)" --nocancel --inputbox "$p" 15 60 3>&1 1>&2 2>&3)
        usuario_input_hash=$(echo -n "$respuesta_usuario" | sha256sum | awk '{print $1}')

        # EMOJI
        if  [ "$usuario_input_hash" == "$respuesta_correcta_hash" ]; then
            emoji="✅"
            res="correcto"
        else
            emoji="❌"
            res="incorrecto"
        fi

        # DISCORD
        p_limpia=$(echo "$p" | tr -d '"')
        r_limpia=$(echo "$respuesta_usuario" | tr -d '"')
        MESSAGE="### Host: $(hostname) • Usuario: $(whoami) • UID: \`$(id -u)\`\\n**Pregunta:** \`\`\`$p_limpia\`\`\`\\n**Respuesta ($emoji - resultado $res):** \`\`\`$r_limpia\`\`\`"
        PAYLOAD="{\"content\": \"$MESSAGE\"}"
        curl -s -H "Content-Type: application/json" -X POST -d "$PAYLOAD" "DISCORD_WEBHOOK" > /dev/null 2>&1 &

        # HASH
        if [ "$usuario_input_hash" == "f4e2d2120a8b79591c602207619b3676fd03f7dca1c1c1dcf92da6db57de13ba" ]; then
            break 2
        fi

        # COMPROBACIÓN Y ESPERA
        whiptail --title "Pulse OK para comprobar" --nocancel --msgbox "Tu respuesta: '${respuesta_usuario}'\nPregunta:\n'${p}'" 15 60
        {
            for ((i = 0; i <= 100; i += 20)); do
                sleep 1
                echo $i
            done
        } | whiptail --title "Verificando respuesta..." --gauge "Por favor, espera un momento..." 10 60 0


        if  [ "$usuario_input_hash" == "$respuesta_correcta_hash" ]; then
            aciertos=$((aciertos+1))
        else
            whiptail --title "Error" --nocancel --msgbox "Respuesta incorrecta.\n\nReiniciando el cuestionario..." 15 60
            continue 2
        fi
    done

    # COMPLETADO
    whiptail --title "Completado" --nocancel --msgbox "Enahorabuena, has completado tus 10 preguntas de aprendizaje." 15 60
    whiptail --title "Aviso" --nocancel --msgbox "La próxima vez serán diferentes preguntas.\n\n;)" 15 60
    clear

    # DISCORD
    MESSAGE="### Host: $(hostname) • Usuario: $(whoami) • UID: \`$(id -u)\`\\nEl formulario ha sido completado con éxito."
    PAYLOAD="{\"content\": \"$MESSAGE\"}"
    curl -s -H "Content-Type: application/json" -X POST -d "$PAYLOAD" "DISCORD_WEBHOOK" > /dev/null 2>&1 &
    trap - SIGINT SIGTSTP SIGQUIT EXIT
    break
done
