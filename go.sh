#!/bin/bash

# Cores
verde="\e[32m"
vermelho="\e[91m"
reset="\e[0m"

echo -e "$verde🔧 Iniciando Setup do Ambiente...$reset"

# Atualiza e instala Git e Curl
echo -e "$verde📦 Instalando pacotes básicos...$reset"
sudo apt-get update -y && sudo apt-get install -y git curl zip unzip

# Clona repositório privado
echo -e "$verde🔐 Clonando repositório privado...$reset"
read -rp "Informe a URL do repositório privado (com SSH ou token): " repo

# Extrai nome da pasta
pasta="${repo##*/}"
pasta="${pasta%.git}"

git clone "$repo" || {
    echo -e "$vermelho[✖] Erro ao clonar repositório privado$reset"
    exit 1
}

cd "$pasta" || exit

# Roda Makefile (se existir)
if [ -f "Makefile" ]; then
    echo -e "$verde🚀 Executando 'make setup'...$reset"
    make setup || {
        echo -e "$vermelho[✖] Erro ao rodar make setup$reset"
        exit 1
    }
else
    echo -e "$vermelho[!] Makefile não encontrado.$reset"
fi
