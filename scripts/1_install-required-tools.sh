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

# Funkcja dodająca alias do .bashrc
add_alias_to_bashrc() {
    local alias_command=$1
    local bashrc_path=~/.bashrc

    if grep -qF "$alias_command" "$bashrc_path"; then
        echo "Alias jest już dodany do .bashrc"
    else
        echo "Dodaję alias do .bashrc..."
        echo "$alias_command" >> "$bashrc_path"
        if [ $? -eq 0 ]; then
            echo "Alias dodany pomyślnie"
        else
            echo "Błąd: Nie udało się dodać aliasu do .bashrc"
        fi
    fi
}

# Lista wymaganych narzędzi
TOOLS=("curl" "wget" "vim" "git" "ntfs-3g" "exfatprogs")

# Iteracja po liście narzędzi i instalacja brakujących
for tool in "${TOOLS[@]}"; do
    install_if_missing "$tool"
done

# Dodanie aliasu
alias_command="alias ll='ls -lh --color=auto'"
add_alias_to_bashrc "$alias_command"

echo "Wszystkie wymagane narzędzia są zainstalowane"
