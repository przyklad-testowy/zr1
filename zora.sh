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
sed -i "s#YOUR_API_KEY_HERE#$API_KEY#" .env

# Uruchomienie Docker Compose w sesji screen w tle
screen -dmS log bash -c 'docker compose up --build; echo "Docker zbudowany. Możesz się odłączyć od sesji screen, naciskając CTRL + A, a następnie D. Aby powrócić do sesji, użyj screen -r log."; read -p "Naciśnij dowolny klawisz, aby kontynuować..."'

# Informacja dla użytkownika, że proces Docker jest uruchamiany
echo "Uruchamianie Docker Compose w sesji 'screen' o nazwie 'log'..."
echo "Proszę czekać na zakończenie procesu budowania..."
echo "Niech node bedzie z Toba ;)"
