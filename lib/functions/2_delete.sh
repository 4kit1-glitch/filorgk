#!/usr/bin/env bash
# shellcheck disable=2154
#
# delete function script
#
#
delete_file() {
    local file="$1"
    local response
    printf "removing file %s\n" "$file"
    inform "removing file $file"
    rm -- "$file" || {
        printf "Failed to remove file.. force remove[Y/n]: "
        inform "Execution force option on $file"
        read -r response
        case "$response" in
            Y|y)
                rm -rf -- "$file"
                inform "Force remove $file"
                ;;
            *)
                return 1
                ;;
        esac
    }
    return 0
}

delete_empty_files() {
    local file

    while IFS= read -r file; do
        [[ -f "$file" && ! -s "$file" ]] && {
            delete_file "$file" || {
                echo "failed to delete $file" >&2
                error "failed to delete $file"
                exit 1
            }
        }
    done < "$found_files_store_path"
    return 0
}

delete_large_files() {
    local file
    while IFS= read -r file; do
        [[ -f "$file" ]] || continue
        if (( $(stat -c %s -- "$file" 2>/dev/null || echo 0) > 1073741824 )); then
            delete_file "$file"
        fi
    done < "$found_files_store_path"
}

delete_old_files() {
    local file
    printf "deleting files older that 30 days\n"
    inform "deletiing files older than 30 days"
    while IFS= read -r file; do
        [[ -f "$file" ]] || continue
        if [[ -n "$(find "$file" -mtime +30 -print -quit 2>/dev/null)" ]]; then
            delete_file "$file"
        fi
    done < "$found_files_store_path"

}

delete_by_extension() {
    local response
    local extension
    printf "Enter the extension: "
    read -r response
    extension="$response"
    while IFS= read -r file; do
        [[ -f "$file" && $extension == "$(get_extension "$file")" ]] && {
            delete_file "$file"
        }
    done < "$found_files_store_path"
}