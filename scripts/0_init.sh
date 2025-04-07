#!/bin/bash

# Konfiguracja
USERNAME="maciolek"
REPO="utils-scripts"
BRANCH="master"
SOURCE_DIR="scripts"
SCRIPT1="1_install-required-tools.sh"
SCRIPT2="2_download-scripts.sh"

# URL plikow w formacie RAW
URL1="https://raw.githubusercontent.com/${USERNAME}/${REPO}/${BRANCH}/${SOURCE_DIR}/${SCRIPT1}"
URL2="https://raw.githubusercontent.com/${USERNAME}/${REPO}/${BRANCH}/${SOURCE_DIR}/${SCRIPT2}"

# Pobierz pliki
echo "Pobieranie plikow..."
wget -q -O "${SCRIPT1}" "${URL1}"
wget -q -O "${SCRIPT2}" "${URL2}"

# Sprawdź, czy pliki zostaly pobrane
if [ -f "${SCRIPT1}" ] && [ -f "${SCRIPT2}" ]; then
    echo "Gotowe! Pliki zostaly pobrane do katalogu glownego."
    
    # Nadaj uprawnienia 700
    echo "Nadaję uprawnienia 700..."
    chmod 700 "${SCRIPT1}"
    chmod 700 "${SCRIPT2}"
    
    echo "Uprawnienia nadane."
else
    echo "Blad: Nie udalo sie pobrać jednego lub obu plikow."
fi
