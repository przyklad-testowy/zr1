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

# Aktualizacja i instalacja Docker
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose -y

# Klonowanie repozytorium i konfiguracja
git clone https://github.com/conduitxyz/node.git
cd node
./download-config.py zora-mainnet-0

# Ustawienie zmiennej środowiskowej
export CONDUIT_NETWORK=zora-mainnet-0

# Konfiguracja pliku .env
cp .env.example .env

# Pytanie użytkownika o klucz API
echo "Proszę wprowadzić swój klucz API:"
read API_KEY

# Wstawienie klucza API do pliku .env
sed -i "s|YOUR_API_KEY_HERE|$API_KEY|" .env

# Uruchomienie Docker Compose
echo "Uruchamianie Docker Compose..."
screen -S log
echo " wklej teraz to: docker compose up --build i poczekaj az wszystkie obrazy sie zbuduja.
Twój węzeł jest uruchomiony.
Możesz odłączyć się od ekranu naciskając CTRL + A + D"

# Komunikat końcowy
echo "Node.js zainstalowany pomyślnie. Życzymy owocnego airdropa!"
