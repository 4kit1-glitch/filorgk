#!/usr/bin/env bash
# shellcheck source=/dev/null
# shellcheck disable=2155
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

store_files() {
    local -a files
    directory="$(find_all_matches)"
    mapfile -t files < <( get_files "$directory" )
    [[ ${#files[@]} -eq 0 ]] && {
        printf "No file found in %s" "$directory"
        info "No file found in $directory"
        exit 0
    }
    for file in "${files[@]}"; do
        printf "%s\n" "$file"
        echo extension: "$(get_extension "$file")"
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

get_file_count() {
    echo pass
}

get_all_mtimes() {
    echo pass

}