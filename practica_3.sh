#!/bin/bash
#870313, Gonzalez Pardo, Juan, T, 1, A
#871820 Fabra Roque, Pablo Nicolás, T, 1, A
if [ "$#" -ne 2 ]; then
	echo "Numero incorrecto de parametros" 1>&2
	exit 1
fi
if [ "$EUID" -ne 0 ]; then
	echo "Este script necesita privilegios de administracion" 1>&2
	exit 1
fi
separador=$IFS
IFS=,
if [ ! -e "$2" ]; then
       exit 1
fi       

if [ "$1" = "-a" ]; then
	cat "$2" | while read nombre password nomCompleto resto
	do
		if [ -z "$nombre" ] || [ -z "$password" ] || [ -z "$nomCompleto" ]; then
			echo "Campo invalido" 1>&2
			exit 1
		fi
		useradd -K PASS_MAX_DAYS=30 -K UID_MIN=1815 -U -m -k /etc/skel -c "$nomCompleto" "$nombre"
		if [ $? -eq 0 ]; then
			echo "$nombre:$password" | chpasswd
		        usermod -U "$nombre"	
			echo "$nomCompleto ha sido creado"	
		else
			echo "El usuario $nombre ya existe" 
		fi
	done

	
elif [ "$1" = "-s" ]; then
	if [ ! -d "/extra" ]; then
		mkdir /extra/
	fi
	if [ ! -d "/extra/backup" ]; then
		mkdir /extra/backup/
	fi

        cat "$2" | while read nombre resto
	do
		if [ -z "$nombre" ]; then
			echo "Campo invalido" 1<&2
			exit 1
		fi
		if [ $( grep -c " $nombre: " /etc/passwd) -ne 0 ] && [ "$nombre" != "root" ]; then
	       		exit 1
			  
		elif [ -n "$nombre" ]; then
			if tar cfP "/extra/backup/$nombre.tar" "$(cat /etc/passwd | grep "$nombre:" | cut -d':' -f6)"
			then
				userdel -r "$nombre" 2>/dev/null
			fi	 
		fi
	done	
else
	echo "Opcion invalida"
fi
IFS=$separador
