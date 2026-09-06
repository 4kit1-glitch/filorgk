#!/usr/bin/env bash
# shellcheck source=/dev/null
# shellcheck disable=2155,2154
# file handler script

get_files() {
    local directory="$1"
    local -a files=()
    mapfile -t files < <(find "$directory" -mindepth 1 -maxdepth 1  -type f 2> /dev/null)
    [[ ${#files[@]} -eq 0 ]] && {
        printf "No file found in %s" "$directory"
        info "No file found in $directory"
        exit 0
    }

    for file in "${files[@]}"; do
        printf "%s\n" "$file"
    done
}
get_extension() {
    local file_path="$1"
    local extension
    extension=${file_path##*.}
    [[ $extension == "$file_path" ]] && {
        extension="none"
    }
    printf "%s" "$extension"
}

get_mtime() {
    local file_path="$1"
    stat -c %y "$file_path" 2> /dev/null | awk  '{print $1}' || {
        printf "Failed to get mtime" >&2
        error "Failed to get mtime"
        exit 0
    }
}

get_size() {
    local file_path="$1"
    find "$file_path" -type f -printf "%s" 2> /dev/null || {
        printf "Failed to get size" >&2
        error "Failed to get size"
        exit 0
    }
}

find_files() {
    local -a files
    directory="$(find_all_matches)"
    mapfile -t files < <( get_files "$directory" )
    [[ ${#files[@]} -eq 0 ]] && {
        printf "No file found in %s" "$directory"
        info "No file found in $directory"
        exit 0
    }

    printf "\n************************************************\n\n"

    for file in "${files[@]}"; do
        printf "%s\n" "$file" >> "$found_files_store_path" || {
            printf "Failed to write to found files store path" >&2
            error "Failed to write to found files store path"
            exit 1
        }
    done
    printf "\n************************************************\n\n"

}
display_found_files() {
    local count=0
    clear
    printf "found files..\n"
    cat "$found_files_store_path" | while IFS= read -r file; do
        count=$((count + 1))
        printf "%d. %s\n" "$count" "$file"
    done
}