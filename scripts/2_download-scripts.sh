#!/bin/bash

# Użycie:
# ./2_download-scripts.sh NAZWA_BRANCHA

# Konfiguracja
USERNAME="maciolek"
REPO="utils-scripts"
BRANCH="master"
TARGET_DIR="scripts"

# Tymczasowy katalog do klonowania repozytorium
TEMP_DIR=$(mktemp -d)

# Klonowanie repozytorium
echo "Klonowanie repozytorium '${REPO}' (branch: '${BRANCH}')..."
git clone --branch "${BRANCH}" --depth 1 "https://github.com/${USERNAME}/${REPO}.git" "${TEMP_DIR}" > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Błąd: Nie udało się sklonować repozytorium. Sprawdź poprawność URL lub dostępność branchu."
    rm -rf "${TEMP_DIR}"
    exit 1
fi

# Sprawdzenie, czy katalog 'scripts' istnieje
if [ ! -d "${TEMP_DIR}/${TARGET_DIR}" ]; then
    echo "Błąd: Katalog '${TARGET_DIR}' nie istnieje w repozytorium."
    rm -rf "${TEMP_DIR}"
    exit 1
fi

# Kopiowanie plików z 'scripts' do katalogu głównego
echo "Kopiowanie plików z '${TARGET_DIR}' do katalogu głównego..."
cp -r "${TEMP_DIR}/${TARGET_DIR}/"* .

# Usuwanie tymczasowego katalogu
echo "Czyszczenie tymczasowych plików..."
rm -rf "${TEMP_DIR}"

echo "Gotowe! Wszystkie pliki zostały pobrane do katalogu głównego."
