#!/bin/bash

# Konfiguracja
USERNAME="maciolek"
REPO="utils-scripts"
BRANCH="master"
TARGET_DIR="scripts"
SCRIPT1="1_install-required-tools.sh"
SCRIPT2="2_download-scripts.sh"

# URL plików w formacie RAW
URL1="https://raw.githubusercontent.com/${USERNAME}/${REPO}/${BRANCH}/${TARGET_DIR}/${SCRIPT1}"
URL2="https://raw.githubusercontent.com/${USERNAME}/${REPO}/${BRANCH}/${TARGET_DIR}/${SCRIPT2}"

# Pobierz pliki
echo "Pobieranie plików..."
wget -q -O "${SCRIPT1}" "${URL1}"
wget -q -O "${SCRIPT2}" "${URL2}"

# Sprawdź, czy pliki zostały pobrane
if [ -f "${SCRIPT1}" ] && [ -f "${SCRIPT2}" ]; then
    echo "Gotowe! Pliki zostały pobrane do katalogu głównego."
    
    # Nadaj uprawnienia 700
    echo "Nadaję uprawnienia 700..."
    chmod 700 "${SCRIPT1}"
    chmod 700 "${SCRIPT2}"
    
    echo "Uprawnienia nadane."
else
    echo "Błąd: Nie udało się pobrać jednego lub obu plików."
fi
