#/bin/bash

#Colours

endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
echo -e "${redColour}\n\n[!] Saliendo${endColour}"
tput cnorm && exit 1 
}

trap ctrl_c INT

declare -i contador=0


function helpPanel(){
echo -e "\n\n${yellowColour}[+]${endColour} ${grayColour}USO:${endColour}"

echo -e "\t${purpleColour}u)${endColour} ${grayColour}Descargar o Actualizar Archivos Necesario...${endColour}"
echo -e "\t${purpleColour}m)${endColour} ${grayColour}Buscar por un Nombre de Maquina${endColour}"
echo -e "\t${purpleColour}s)${endColour} ${grayColour}Buscar Maquina Por Skills${endColour}"
echo -e "\t${purpleColour}y)${endColour} ${grayColour}Obtener Link de Resolucion de la maquina en Youtube${endColour}"
echo -e "\t${purpleColour}o)${endColour} ${grayColour}Buscar Maquina Por Sistema Operativo${endColour}"
echo -e "\t${purpleColour}i)${endColour} ${grayColour}Buscar por una Direccion IP${endColour}"
echo -e "\t${purpleColour}d)${endColour} ${grayColour}Buscar por Dificultad${endColour}"
echo -e "\t${purpleColour}h)${endColour} ${grayColour}Mostrar Panel de Ayuda${endColour}"
}


function fileUpdate(){

  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Descargando Archivos Necesario...${endColour}"
  if [ ! -f bundle.js ]; then
  curl -s https://htbmachines.github.io/bundle.js |js-beautify |sponge bundle.js
echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Todos los Archivos han Sido Descargado${enddColour}"
else

  curl -s https://htbmachines.github.io/bundle.js |js-beautify |sponge bundle.temp.js
  bundle_original=$(md5sum bundle.js |awk '{print $1}' )
  bundle_temporal=$(md5sum bundle.temp.js |awk '{print $1}')
  if [ "$bundle_original" == "$bundle_temporal" ]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}no se encontraron nuevas Actualizaciones lo tienes todo al Dia${endColour}"
    rm bundle.temp.js
else
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Se Han Encontrado Actualizaciones Disponibles${endColour}"
  curl -s X GET https://htbmachines.github.io/bundle.js |js-beautify |sponge bundle.js
echo -e "${yellowColour}[+]${endColour} ${grayColour}los Archivos han Sido Actualizado Correctamente${endColour}"
  fi
  fi
}




function searchMachine(){

machineName=$1
machineName_cheker="$(cat bundle.js |awk "/name: \"$machineName\"/,/resuelta:/" |grep -vE "id:|like:|resuelta:|sku:" |tr -d "," |tr -d '"' |sed 's/ //g')"
if [  "$machineName_cheker" ]; then

echo -e "\n${yellowColour}[+]${endColour} ${grayColour}listando la Propiedades de la Maquina${endColour} ${redColour}$machineName${endColour}${grayColour}:${endColour}\n"
cat bundle.js |awk "/name: \"$machineName\"/,/resuelta:/" |grep -vE "id:|like:|resuelta:|sku:" |tr -d "," |tr -d '"' |sed 's/ //g'
else
  echo -e "\n${redColour}[!] la Maquina Proporcionada no existe ${endColour}\n"
fi
}

function searchIpaddress(){
ip=$1
ipaddress_cheker="$(cat bundle.js |grep "ip: \"$ip\"" -B 3 |grep "name:" |tr -d "," |tr -d '"' |awk '{print $2}')"
if [ $ipaddress_cheker ]; then 
machineName=$(cat bundle.js |grep "ip: \"$ip\"" -B 3 |grep "name:" |tr -d "," |tr -d '"' |awk '{print $2}')
echo -e "\n${yellowColour}[+]${endColour} ${grayColour}la Maquina Correspondiente para la IP${endColour} ${blueColour}$ip${endColour} ${grayColour}es${endColour} ${redColour}$machineName${endColour}"
else
  echo -e "\n${redColour}[!] la IP Proporcionada no Corresponde a Ninguna Maquina Existente${endColour}\n"
fi
}

 
function searchYoutube(){
youtube="$1"
youtube_cheker="$(cat bundle.js |awk "/name: \"$youtube\"/,/resuelta/" |grep "youtube:" |tr -d "," |tr -d '"' |awk '$NF{print $NF}')"

if [ $youtube_cheker ]; then 
you="$(cat bundle.js |awk "/name: \"$youtube\"/,/resuelta/" |grep "youtube:" |tr -d "," |tr -d '"' |awk '$NF{print $NF}')"
echo -e "\n ${yellowColour}[+]${endColour} ${grayColour}el Link de Youtube Correspondiente para la Maquina es -->${endColour} ${blueColour} $you ${endColour}\n"
else
  echo -e "${redColour}\n[!] el Link de Youtube no existe para la Maquina Proporcionada ${endColour}\n"
fi
}

function searchDificultad(){
dificultad="$1"
dificultad_cheker="$(cat bundle.js | grep "dificultad: \"$dificultad\"" -B 5 | grep "name:" | tr -d "," | tr -d '"'|awk '{print $NF}' | column)"
if [ "$dificultad_cheker" ]; then 

dif="$(cat bundle.js | grep "dificultad: \"$dificultad\"" -B 5 | grep "name:" | tr -d "," | tr -d '"'|awk '{print $NF}' | column)"
echo -e "\n${yellowColour}[+]${endColour} ${grayColour}la Dificultad perteneciontente a la Siguiente Cartegoria Son las Siguientes Maquinas${endColour}\n\n ${blueColour}$dif${endColour}"

else

echo -e "\n${redColour}[!] la Dificultad no existe ${endColour}\n"
fi
}


function searchSistemaOperativo(){
SOS="$1"
SOS_cheker="$(cat bundle.js |grep "so: \"$SOS\"" -B 5 | tr -d "," | tr -d '"' | grep "name:" | awk '{print $NF}' | column)"
if [ "$SOS_cheker" ]; then 

sistem="$(cat bundle.js |grep "so: \"$SOS\"" -B 5 | tr -d "," | tr -d '"' | grep "name:" | awk '{print $NF}' | column)"
echo -e "\n${yellowColour}[+]${endColour} ${grayColour}el Sistema Operativo Correspondiente para la Categoria Proporcionada son las Siguientes${endColour}${yellowColour}:${endColour}${blueColour}\n\n$sistem${endColour}\n"
else 
    echo -e "\n${redColour}[!] la Categoria para los Sistemas Operativo Proporcionado no Existen${endColour}\n"
fi
}


function searchSkills(){
skills="$1"
skill_checker="$(cat bundle.js | grep "name:" -B 5 | grep "$skills" -i -B 4 | grep "name:" | awk '{print $NF}' |tr -d "," |tr -d '"' |column)"

if [ "$skill_checker" ]; then 
  ski="$(cat bundle.js | grep "name:" -B 5 | grep "$skills" -i -B 4 | grep "name:" | awk '{print $NF}' |tr -d "," |tr -d '"' |column)"
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}la Skill Proporcionada pertenecen a las Maquinas${endColour} ${yellowColour}:${endColour} ${blueColour}\n\n$ski${endColour}\n"
else
  echo -e "\n${redColour}[!] no se Encontraron Maquinas Para estas Skills${endColour}"
fi
} 



while getopts "hum:i:y:d:o:s:" arg; do

  case $arg in 
  h) ;;
  m) MachineName=$OPTARG;  let contador+=1;;
  i) ip=$OPTARG; let contador+=2;;
  u) update=$OPTARG; let contador+=3;;
  y) youtube=$OPTARG; let contador+=4;;
  d) dificultad=$OPTARG; let contador+=5;;
  o) SOS=$OPTARG; let contador+=6;;
  s) skills=$OPTARG; let contador+=7;;
esac
done



if [ $contador -eq 1 ]; then 
  searchMachine $MachineName

elif [ $contador -eq 2 ]; then
searchIpaddress $ip $MachineName

elif [ $contador -eq 3 ]; then 
  fileUpdate $update

elif [ $contador -eq 4 ]; then 
  searchYoutube $youtube
elif [ $contador -eq 5 ]; then 
  searchDificultad $dificultad
  
elif [ $contador -eq 6 ]; then 
  searchSistemaOperativo $SOS

elif [ $contador -eq 7 ]; then 
  searchSkills $skills
else
  helpPanel
fi


