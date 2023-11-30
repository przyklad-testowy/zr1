#!/bin/bash

# Aktualizacja pakietów
sudo apt-get update && sudo apt-get upgrade -y

# Instalacja wymaganych narzędzi
sudo apt install curl build-essential git screen jq pkg-config libssl-dev libclang-dev ca-certificates gnupg lsb-release -y

# Konfiguracja klucza Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Dodanie repozytorium Docker
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

# Instalacja Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose -y

# Klonowanie repozytorium
git clone https://github.com/conduitxyz/node.git

