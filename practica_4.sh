#!/bin/bash
# 870313, Gonzalez Pardo, Juan, T, 1, A
# 871820, Fabra Roque, Pablo Nicolas, T, 1, A

if [$# -eq 3 ] then;
	while IFS= read -r ip
	do
		if ping -c 1 "$ip" >/dev/null then;
			scp -q -i "~/.ssh/id_as_ed25519" "./practica_3.sh" "$2" "as@ip:~"
			ssh -q -i "~/.ssh/id_as_ed25519" "as@ip" "sudo ~/./practica_3.sh "$1" "$2" ;rm ~/practica_3.sh ~/$2" < /dev/null
		else
			echo "${ip} no es accesible"
		fi
	done < "$3"
else
	echo "Numero incorrecto de parametros"
fi
