#!/usr/bin/env bash
# shellcheck source=/dev/null
# shellcheck disable=2154
# auto adjust function script

auto_arrange_by_extension() {
    local file
    local extension
    local destination

    printf "Enter the destination directory: "
    read -r destination
    destination="$(prepare_destination_path "$destination")" || return 1

    while IFS= read -r file; do
        [[ -f "$file" ]] || continue
        extension="$(get_extension "$file")"
        printf "File: %s, Extension: %s\n" "$file" "$extension"
        [[ -n "$extension" && "$extension" != "none" ]] && {
            move_file "$file" "$destination/$extension"
        }
    done < "$found_files_store_path"

}

auto_arrange_by_size() {
    local file
    local size
    local destination

    printf "Enter the destination directory: "
    read -r destination
    destination="$(prepare_destination_path "$destination")" || return 1

    while IFS= read -r file; do
        [[ -f "$file" ]] || continue
        size="$(get_size "$file")"
        [[ -n "$size" ]] && {
            move_file "$file" "$destination/$size"
        }
    done < "$found_files_store_path"

}

auto_arrange_by_mtime() {
    local file
    local mtime
    local destination

    printf "Enter the destination directory: "
    read -r destination
    destination="$(prepare_destination_path "$destination")" || return 1

    while IFS= read -r file; do
        [[ -f "$file" ]] || continue
        mtime="$(get_mtime "$file")"
        [[ -n "$mtime" ]] && {
            local safe_mtime
            safe_mtime="${mtime//:/-}"
            move_file "$file" "$destination/$safe_mtime"
        }
    done < "$found_files_store_path"
}