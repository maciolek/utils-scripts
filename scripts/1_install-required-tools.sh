#!/bin/bash

# Funkcja sprawdzająca i instalująca wymagane narzędzia
install_if_missing() {
    local cmd=$1  # Nazwa polecenia (np. curl, jq, mc)
    if ! command -v "$cmd" &> /dev/null; then
        echo "$cmd nie jest zainstalowane. Instaluję..."
        apt update && apt install -y "$cmd"
        if [ $? -ne 0 ]; then
            echo "Błąd: Nie udało się zainstalować $cmd. Sprawdź połączenie internetowe lub uprawnienia"
            exit 1
        fi
    else
        echo "$cmd jest już zainstalowane"
    fi
}

# Lista wymaganych narzędzi
TOOLS=("curl" "jq")

# Iteracja po liście narzędzi i instalacja brakujących
for tool in "${TOOLS[@]}"; do
    install_if_missing "$tool"
done

echo "Wszystkie wymagane narzędzia są zainstalowane."