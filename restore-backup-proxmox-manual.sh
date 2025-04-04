#!/bin/bash

# uruchomienie:
# ./restore-backup-proxmox-manual.sh PLIK_BACKUP_PROXMOX.tar.gpg KATALOG_DOCELOWY "TwojeHasloSzyfrujace"

# Funkcja dodająca timestamp do każdego komunikatu
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $*"
}

# Sprawdź liczbę parametrów
if [ "$#" -ne 3 ]; then
    log "Błąd: Nieprawidłowa liczba parametrów."
    log "Użycie: $0 <plik_backupu.gpg> /ścieżka/docelowa <hasło_szyfrujące>"
    exit 1
fi

# Przypisz parametry do zmiennych
ENCRYPTED_FILE="${1}"
TARGET_PATH="${2}"
PASSPHRASE="${3}"

# Sprawdź, czy plik backupu istnieje
if [ ! -f "${ENCRYPTED_FILE}" ]; then
    log "Błąd: Plik backupu '${ENCRYPTED_FILE}' nie istnieje."
    exit 1
fi

# Sprawdź, czy ścieżka docelowa jest dostępna (lub ją utwórz)
if [ ! -d "${TARGET_PATH}" ]; then
    log "Tworzę katalog docelowy: ${TARGET_PATH}"
    mkdir -p "${TARGET_PATH}" || { log "Błąd: Nie udało się utworzyć katalogu."; exit 1; }
fi

# Tymczasowy plik po odszyfrowaniu
DECRYPTED_FILE="/tmp/proxmox_backup_decrypted.tar"

log "Odszyfrowywanie pliku backupu..."

# Odszyfruj plik za pomocą GPG
gpg --batch --yes --passphrase "${PASSPHRASE}" --output "${DECRYPTED_FILE}" --decrypt "${ENCRYPTED_FILE}" || {
    log "Błąd: Odszyfrowanie nie powiodło się (sprawdź hasło).";
    exit 1;
}

log "Rozpakowywanie danych do: ${TARGET_PATH}..."

# Rozpakuj archiwum
tar -xzf "${DECRYPTED_FILE}" -C "${TARGET_PATH}" || {
    log "Błąd: Rozpakowanie nie powiodło się.";
    rm -f "${DECRYPTED_FILE}";
    exit 1;
}

# Usuń tymczasowy plik
rm -f "${DECRYPTED_FILE}"

log "Backup został odszyfrowany i rozpakowany do: ${TARGET_PATH}"