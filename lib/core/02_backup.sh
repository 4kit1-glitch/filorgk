#!/usr/bin/env bash
# shellcheck source=/dev/null
# shellcheck disable=2155,2154
# script creates a backup for affected files
#

backup_files() {
    local response
    printf "Backup files before change[y/N]: "
    read -r response

    [[ $response == [Y][y] ]] && {
        printf "\ncreating backup...\n"
        tar -cf "$current_backup_path" -T "$found_files_store_path" || {
        echo "Backup process failed" >&2
        error "Backup process failed"
        return 1
        }
        printf "Backup done\n"
        return 0
    }
    inform "Backup cancelled"
    return 0
}