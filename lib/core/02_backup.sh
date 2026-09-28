#!/usr/bin/env bash
# shellcheck source=/dev/null
# shellcheck disable=2155,2154
# script creates a backup for affected files
#

backup_files() {
    local response
    local archive_path="${current_backup_path:-$BACKUP_DIR/backup_${DATE}.tar}"
    local files_path="${found_files_store_path:-}"

    [[ -n "$files_path" && -f "$files_path" ]] || {
        printf "No files available to back up.\n"
        return 0
    }

    printf "Backup files before change[y/N]: "
    read -r response

    case "$response" in
        Y|y)
            mkdir -p "$(dirname "$archive_path")" || {
                echo "Backup directory could not be created" >&2
                error "Backup directory could not be created"
                return 1
            }
            printf "\ncreating backup...\n"
            tar -cf "$archive_path" -T "$files_path" || {
                echo "Backup process failed" >&2
                error "Backup process failed"
                return 1
            }
            printf "Backup done\n"
            return 0
            ;;
        *)
            inform "Backup cancelled"
            return 0
            ;;
    esac
}