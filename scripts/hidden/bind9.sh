#!/bin/bash

clear
trap 'exit' SIGINT SIGTSTP SIGQUIT EXIT

declare -A preguntas=(
    ["Definición: Autoridad que administra los dominios\ngeográficos de cada país y asigna IPs garantizando\nque sean únicas"]="0e1733efb669979a709f05ba0a8d2725095193cf81fd05b75b7cefe5c48e03f9"
    ["¿Alternativa clásica a dig?"]="120313e8b11d8c6c1c2608c92d35c85226728b202779f48ae543f83a14b29bdd"
    ["¿Archivo de configuración de SSH servidor?"]="83ca950c7adaf0f96800e5a6b2157f72b14a68a476292fcca2c8fd3d7284be96"
    ["¿Un Docker permite escalabilidad? (si/no)"]="97a62ad21d79c01cceb7767952acec4fec86bfe909b06e5f3f6963365cf91ab8"
    ["¿Archivo de configuración de un servicio dhcp?"]="1faadb83010c6bf194ad356e97cfa24c051a66e4a0ff6e9657492a693befdceb"
    ["¿Comando de Docker para listar todos los dockers?"]="162035ec2d281b1bbcb04ab3942d79b23465716ebc2d183f90cac10f91c6e567"
    ["¿Qué registro DNS se usa para alias?"]="6a2839784c7ad5f19e7c4c924b6aece058676f151671d0ded7ca1dcd2e756af8"
    ["¿Comando de Docker para listar redes?"]="e9f8851ccd23367bbc9e67deaf5ae40f1b2c080dd309f035bbb532b98c17e04d"
    ["¿Qué comando se usa para consultar DNS?"]="ebbde58a4bbe357e599b29131e48c6f883a9cb7003571bf54243391a4f80aacf"
    ["¿Ficheros de registros de errores del sistema? (Debian)"]="6170ec3837f15d64f5b63dfca1db13ace08066bbfd0cceeea8cae352cb4ad4e6"
    ["¿Qué puerto usa DNS?"]="2858dcd1057d3eae7f7d5f782167e24b61153c01551450a628cee722509f6529"
    ["¿Número de puerto que usa el servicio dhcp?"]="49d180ecf56132819571bf39d9b7b342522a2ac6d23c1418d3338251bfe469c8"
    ["¿Comando de Docker para instalar una imagen?"]="c88a9536a858b33d369f2ae1cfaf7860d3f0c6f7f5d8a6a55ff1607605ee8ac5"
    ["¿Se suele usar el reenvío de puertos en SSH? (si/no)"]="97a62ad21d79c01cceb7767952acec4fec86bfe909b06e5f3f6963365cf91ab8"
    ["¿DNS usa TCP, UDP o ambos?"]="0b2c6b193891023c8b7217f3817b560724d2f596511adf52d1eaba5382813bbd"
    ["¿Fichero de sitios Virtuales disponibles en apache2?"]="3f6669189b0630b7461f847e0b0633815b0b100d095dbcb5b3f5e939279ce039"
    ["¿Que puerto usa SSH?"]="785f3ec7eb32f30b90cd0fcf3657d388b5ff4297f2f9716ff66e9b69c05ddd09"
    ["¿Fichero de configuración por defecto de apache2?"]="f91db4633742f5c66d674c454d180148abc9f0a657067e220a3f3a881ef5a60a"
    ["¿De cuantos puertos requiere FTP? (numéricamente)"]="d4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35"
    ["¿Protocolo seguro para copiar archivos remotamente?"]="a4a6172074384f943a78b96c7018ed9776cc3ab005ea58b20111288b8b72fe62"
    ["¿Comando de Docker para parar un docker?"]="22a424d612905eb55f0f153f80a78b9ed1c3eb6d34cebb7b1051ec59d8af22b0"
    ["¿Nombre del usuario anónimo de FTP?"]="2f183a4e64493af3f377f745eda502363cd3e7ef6e4d266d444758de0a85fcc8"
    ["¿Fichero de zonas de bind9?"]="ee6313fed5f5629a6e1190e6f372b42fad82ba935da385516f84841cae85c810"
    ["¿Fichero de Configuración del DNS en bind9?"]="49ed0dbe318605cbe52348626cf30c30b03943ce9ee83f7e1558009e9e98bc8d"
    ["¿La parte de la ICANN que autoriza estos TLD es?"]="665f157b92fe14b8e90249c6ccf1dc9b605ed0670f5cf23d571cb6678ea5068c"
    ["¿Cuantas versiones de ssh existen? (numéricamente)"]="d4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35"
    ["¿Fichero de Configuración del servidor de bind9?"]="c93e09db7b401e464a0b38e0969ebb1e341e4652431c048aa8a915efef171f72"
    ["¿Fichero de puertos a usar en apache2?"]="bd3bd0de6935d646c64adc80aaba15e545be60c3ca4503ca98fab2bad9a0d0c6"
    ["¿Con que protocolo se reciben emails? (versión 3)"]="1f744acf08618614de8daad9363dcb56b7273d3c2696a2f04462aca698611a9a"
    ["¿Fichero principal de configuración de apache2?"]="75cb1b73573ef48c2ee20ce24afa2b10633a8f56f4e8e74247afa01435ae20b9"
    ["¿Abreviatura home personal de tu usuario?"]="7ace431cb61584cb9b8dc7ec08cf38ac0a2d649660be86d349fb43108b542fa4"
    ["¿Que version de SSH es mas segura? (SSHv.)"]="143a09b731f30f4c9bf203e0eff95c5891d3e18d19d4a0a738cb6fce5faace51"
    ["¿Directorio de logs de Linux?"]="9a6a409e26d4fd90b43d526e1d61dcfbc287a72f952784d9d26331d6aaf25624"
    ["¿Comando para generar claves SSH?"]="a24f7bf3c615ad233a251863a4ed0db7f5f286205ea837daddc21bdcce35b907"
    ["¿Fichero de zonas por defecto de bind9?"]="af04723c1b6b0e9ed64136867e378db69d2acb332102ea133207a8f789e70755"
    ["¿Comando de Docker para iniciar un docker?"]="cd4bc216e7f6a9ea5753b722880968263a9c977e6e490e307d0995604a49782e"
    ["¿Qué tipo de registro DNS define el servidor DNS autoritativo?"]="7bfba6e0021f1fd1183dfefe60216f13140365788780f2a26fd8fc1f08b2aa2c"
    ["¿Directorio raíz de apache2?"]="69dd2b02e1f3a65918182048ea4e29979a849d8942e8f53ed20a4bf10e529b36"
    ["¿Que comando de conexión remota es seguro?"]="7f5a55cf3f88be936fb9440249cb449f3067ccee4b525d0027dc9278a29c32c1"
    ["¿Directorio de configuraciones del sistema?"]="2824684de3d1a19390ca88cf826e77c6f750657e552edb83d466666c37521a08"
    ["¿Puerto de datos FTP en modo activo?"]="f5ca38f748a1d6eaf726b8a42fb575c3c71f1864a8143301782de13da2d9202b"
    ["¿Con que protocolo se envían emails?"]="4ae524ef0a54bc56e3844482dff66d3dd1c07170a36531500327556e4eb58a66"
    ["¿Qué servicio resuelve nombres a IP?"]="dd75a9d6fb309c4399fe425cd5f90ff95eba135d6924fb91766ee5d3726b168a"
    ["¿Qué puerto usa HTTP?"]="48449a14a4ff7d79bb7a1b6f3d488eba397c36ef25634c111b49baf362511afc"
    ["Definición: Dominios de 1º nivel que cuelgan\ndirectamente del nodo raíz. Son gestionados por ICANN"]="1eaec7aae93cc9a626296d6bc1e78ca9f0530fd128f1bf1f57b3df06e7c7b0b3"
    ["¿Que comando de conexión remota NO es seguro?"]="5a4f77d09a9b2832e2e548152026ceb71b9bcea7d2cadf4b44cc8d23c428001d"
    ["¿Qué puerto usa HTTPS?"]="6d05621ab7cb7b4fb796ca2ffbe1a141e0d4319d3deb6a05322b9de85d69b923"
    ["¿Nombre del servicio FTP en Linux?"]="42af412d8659682b424ae18b14522fcdc5bd83d19a4932ee8802f5a565946947"
    ["¿Comando de Linux permite des/cifrar archivos?"]="6858a423dc9e04f67929d2c0bdf95e246efa280e0551e3152db2ec9d274e378a"
    ["¿Por que puerto hay que acceder al servidor FTP?"]="6f4b6612125fb3a0daecd2799dfd6c9c299424fd920f9b308110a2c1fbd8f443"
    ["¿Cómo se llama la versión segura de FTP?"]="224ab2a03cfa58059b7be114fb62e741ad45d0722cc493728e4d3871a2ec23d4"
    ["¿Comando de Docker para listar dockers en ejecución?"]="3fe570f4395819898decbc3e8a55e0597bf7edf491d61fbc74b4138faa9e99bd"
    ["¿Qué tipo de registro DNS define el servidor de correo?"]="d7f890c4f72a3d49b69870b2dc2850c698e7b841eb2dd7cd21e4de551a29f4c4"
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
        respuesta_usuario=$(echo "$respuesta_usuario" | tr '[:upper:]' '[:lower:]')
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
        } | whiptail --title "Verificando respuesta..." --gauge "Tu respuesta: '${respuesta_usuario}'\nPregunta:\n'${p}'\n\nPor favor, espera un momento..." 15 60 0


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
