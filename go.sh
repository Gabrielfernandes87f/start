#!/bin/bash

# Cores
amarelo="\e[33m"
verde="\e[32m"
branco="\e[97m"
vermelho="\e[91m"
azul="\e[34m"
reset="\e[0m"

banner_gfnet() {
    clear
    echo -e "$verde███████████████████████████████████████████████████████████████████████████████████████████████████████$reset"
    echo -e "$verde██╔═════════════════════════════════════════════════════════════════════════════════════════════════$verde╗██$reset"
    echo -e "$verde██║                                                                                                 $verde║██$reset"
    echo -e "$verde██║              $amarelo   ██████╗ ██╗████████╗     ██████╗██╗      ██████╗ ███╗   ██╗███████╗             $verde║██$reset"
    echo -e "$verde██║              $amarelo  ██╔════╝ ██║╚══██╔══╝    ██╔════╝██║     ██╔═══██╗████╗  ██║██╔════╝             $verde║██$reset"
    echo -e "$verde██║              $amarelo  ██║  ███╗██║   ██║       ██║     ██║     ██║   ██║██╔██╗ ██║█████╗               $verde║██$reset"
    echo -e "$verde██║              $amarelo  ██║   ██║██║   ██║       ██║     ██║     ██║   ██║██║╚██╗██║██╔══╝               $verde║██$reset"
    echo -e "$verde██║              $amarelo  ╚██████╔╝██║   ██║       ╚██████╗███████╗╚██████╔╝██║ ╚████║███████╗             $verde║██$reset"
    echo -e "$verde██║              $amarelo   ╚═════╝ ╚═╝   ╚═╝        ╚═════╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝             $verde║██$reset"
    echo -e "$verde██║                                                                                                 $verde║██$reset"
    echo -e "$verde██║                           $azul  ██████╗ ██████╗███╗   ██╗███████╗████████╗                          $verde║██$reset"
    echo -e "$verde██║                           $azul ██╔════╝ ██╔═══╝████╗  ██║██╔════╝╚══██╔══╝                          $verde║██$reset"
    echo -e "$verde██║                           $azul ██║  ███╗██████╗██╔██╗ ██║█████╗     ██║                             $verde║██$reset"
    echo -e "$verde██║                           $azul ██║   ██║██╔═══╝██║╚██╗██║██╔══╝     ██║                             $verde║██$reset"
    echo -e "$verde██║                           $azul ╚██████╔╝██║    ██║ ╚████║███████╗   ██║                             $verde║██$reset"
    echo -e "$verde██║                           $azul  ╚═════╝ ╚═╝    ╚═╝  ╚═══╝╚══════╝   ╚═╝                             $verde║██$reset"
    echo -e "$verde██╚═════════════════════════════════════════════════════════════════════════════════════════════════$verde╝██$reset"
    echo -e "$verde███████████████████████████████████████████████████████████████████████████████████████████████████████$reset"
    echo ""
}

msg_passo() {
    echo -e "$verde[✔]$reset $1"
}

msg_progresso() {
    echo -e "$amarelo[~]$reset $1"
}

msg_erro() {
    echo -e "$vermelho[✖] ERRO:$reset $1"
    exit 1
}

clone_projeto() {
    echo -ne "$brancoInforme a URL do repositório (ex: https://x-access-token:TOKEN@github.com/user/repo.git):$reset "
    read repo
    repo=$(echo "$repo" | xargs)
    pasta_destino="${repo##*/}"
    pasta_destino="${pasta_destino%.git}"

    mkdir -p ~/projetos
    cd ~/projetos || msg_erro "Falha ao acessar a pasta ~/projetos"

    if [ -d "$pasta_destino" ]; then
        msg_erro "A pasta '$pasta_destino' já existe."
    fi

    msg_progresso "Clonando o repositório..."
    git clone "$repo" || msg_erro "Falha ao clonar o repositório."

    msg_passo "Repositório clonado em ~/projetos/$pasta_destino"

    echo ""
    read -rp "Deseja renomear a pasta do projeto? (s/n): " resposta
    if [[ "$resposta" =~ ^[Ss]$ ]]; then
        read -rp "Digite o novo nome da pasta: " novo_nome
        if [ -n "$novo_nome" ]; then
            mv "$pasta_destino" "$novo_nome"
            pasta_destino="$novo_nome"
            msg_passo "Pasta renomeada para ~/projetos/$pasta_destino"
        else
            echo -e "${vermelho}❌ Nome inválido. A pasta não foi renomeada.${reset}"
        fi
    fi

    cd "$pasta_destino" || msg_erro "Não foi possível acessar a pasta $pasta_destino"

    if [ -f "Makefile" ]; then
        msg_progresso "Executando 'make install'..."
        make install || msg_erro "Erro ao executar 'make install'"
        msg_passo "'make install' executado com sucesso."
    else
        msg_erro "Makefile não encontrado na raiz do projeto."
    fi
}

### Execução ###
banner_gfnet
clone_projeto

echo ""
msg_passo "Setup finalizado com sucesso! 🎉"
echo ""
