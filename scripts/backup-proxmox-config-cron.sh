#!/bin/bash

#Uruchomienie:
#./proxmox_backup.sh 
#wcześniej ustaw -> ŚCIEŻKA_DO_KATALOGU_DOCELOWEGO_BACKUP "TwojeHasloSzyfrujace" / "$BACKUP_PASSWORD"

# Ustaw liczbę kopii do zachowania
RETAIN_COUNT=60

# Ustaw ścieżka do pliku logów względem katalogu skryptu
SCRIPT_DIR=$(dirname $(readlink -f $0))
LOG_FILE="$SCRIPT_DIR/log/proxmox_backup.log"

# Ustaw nazwę pliku zaszyfrowanego
BACKUP_NAME="proxmox_backup_$(date +"%Y-%m-%d-%H-%M").tar.gpg"

# Tymczasowy katalog na kopię zapasową
TMP_DIR="/tmp/proxmox_backup"

# Ustaw ścieżkę docelową z pierwszego argumentu
TARGET_PATH=$(readlink -f "/mnt/auto/backup_drive/backups_proxmox_config/")

# Ustaw hasło szyfrujące w zmiennej środowiskowej w ~/.bashrc
PASSPHRASE="${BACKUP_PASSWORD}"

# Pobierz aktualną datę i godzinę
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Tymczasowy katalog na kopię zapasową
mkdir -p "${TMP_DIR}"

# Funkcja logująca z timestampem
log() {
    echo "${TIMESTAMP} $*" >> "${LOG_FILE}"
}

# Funkcja sprzątająca
cleanup() {
    rm -rf "${TMP_DIR}"
    rm -f "${BACKUP_NAME}"
}
trap cleanup EXIT

# Lista ścieżek do backupu
SOURCE_PATHS=(
    "/etc/pve"          	# Konfiguracja klastra i maszyn
    "/etc/network"      	# Ustawienia sieciowe
    "/var/lib/pve-cluster"  # Dane klastra
    "/etc/hosts"        	# Mapowanie hostów
    "/etc/resolv.conf"  	# Konfiguracja DNS
	"/etc/lvm/"				# Konfiguracja LVM (jeśli używasz Logical Volume Manager)
)

log "Rozpoczęto proces backupu..."

# Kopiowanie plików
for path in "${SOURCE_PATHS[@]}"; do
    if [ -e "${path}" ]; then
        rsync -avz --force "${path}" "${TMP_DIR}/$(basename ${path})"
        log "Skopiowano: ${path}"
    else
        log "Ostrzeżenie: ${path} nie istnieje"
    fi
done

# Kompresja i szyfrowanie
log "Kompresja i szyfrowanie..."
tar -czf - -C "${TMP_DIR}" . | gpg --batch --yes --symmetric --cipher-algo AES256 --passphrase "${PASSPHRASE}" -o "${BACKUP_NAME}" || {
    log "Błąd szyfrowania!"
    exit 1
}

# Tworzenie katalogu docelowego, jeśli nie istnieje
mkdir -p "${TARGET_PATH}"

# Przesyłanie backupu
log "Przesyłanie kopii..."
mv "${BACKUP_NAME}" "${TARGET_PATH}/" || {
    log "Błąd przesyłania!"
    exit 1
}

# Retencja backupów 
log "Sprawdzanie retencji backupów..."
BACKUP_LIST=$(ls -t "${TARGET_PATH}"/proxmox_backup_*.tar.gpg 2>/dev/null)
COUNT=$(echo "${BACKUP_LIST}" | wc -l)

if [ "${COUNT}" -gt "${RETAIN_COUNT}" ]; then
    TO_DELETE=$(echo "${BACKUP_LIST}" | tail -n +$((${RETAIN_COUNT} + 1)))
    log "Usuwanie starych backupów:"
    echo "${TO_DELETE}" | xargs rm -f || {
        log "Błąd podczas usuwania starych backupów!"
        exit 1;
    }
fi

log "Backup zakończony sukcesem: ${TARGET_PATH}/proxmox_backup_$(date +"%Y-%m-%d-%H-%M").tar.gpg"

echo "" >> "${LOG_FILE}"
