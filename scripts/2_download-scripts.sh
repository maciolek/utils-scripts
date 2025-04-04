#!/bin/bash

# Użycie:
# ./2_download-scripts.sh NAZWA_BRANCHA

# Stałe zdefiniowane w skrypcie
USERNAME="maciolek"
REPO="utils-scripts"
TARGET_DIR="scripts"

# Sprawdź czy podano branch
if [ "$#" -ne 1 ]; then
    echo "Użycie: $0 <nazwa-brancha>"
    echo "Przykład: $0 init"
    exit 1
fi

BRANCH="$1"

# URL API GitHub
API_URL="https://api.github.com/repos/${USERNAME}/${REPO}/git/trees/${BRANCH}?recursive=1"

# Pobierz listę plików w katalogu scripts
echo "Szukam plików w katalogu '${TARGET_DIR}' na branchu '${BRANCH}'..."
FILES=$(curl -s "${API_URL}" | jq -r --arg dir "${TARGET_DIR}/" '.tree[] | select(.type == "blob" and .path | startswith($dir)) | .path')

# Sprawdź poprawność odpowiedzi
if [ -z "$FILES" ]; then
    echo "Błąd: Nie znaleziono plików lub branch nie istnieje."
    exit 1
fi

# Przygotuj lokalny katalog
LOCAL_DIR="utils-scripts_${BRANCH}_scripts"
mkdir -p "${LOCAL_DIR}"

# Pobierz pliki
echo "Rozpoczynam pobieranie do katalogu: ${LOCAL_DIR}"
for file in $FILES; do
    RAW_URL="https://raw.githubusercontent.com/${USERNAME}/${REPO}/${BRANCH}/${file}"
    LOCAL_PATH="${LOCAL_DIR}/${file#${TARGET_DIR}/}"
    
    mkdir -p "$(dirname "${LOCAL_PATH}")"
    echo "Pobieram: ${file}"
    curl -s -o "${LOCAL_PATH}" "${RAW_URL}"
done

echo "Gotowe! Pobrano $(echo "$FILES" | wc -l) plików."
