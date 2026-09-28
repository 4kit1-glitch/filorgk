#!/usr/bin/env bash
# shellcheck source=/dev/null
# shellcheck disable=2154
# move function script

prepare_destination_path() {
    local destination="$1"
    local absolute_destination="$destination"

    if [[ -z "$destination" ]]; then
        echo "" >&2
        return 1
    fi

    if [[ "$destination" != /* ]]; then
        absolute_destination="$PWD/$destination"
    fi

    if [[ ! -e "$absolute_destination" ]]; then
        mkdir -p "$absolute_destination" || {
            echo "Failed to create destination directory: $absolute_destination" >&2
            error "Failed to create destination directory: $absolute_destination"
            return 1
        }
    fi

    printf '%s\n' "$absolute_destination"
}

move_file() {
    local file="$1"
    local destination="$2"
    local final_destination
    local resolved_destination

    if [[ -z "$destination" ]]; then
        echo "Missing destination for file move" >&2
        error "Missing destination for file move"
        return 1
    fi

    if [[ "$destination" != /* ]]; then
        resolved_destination="$PWD/$destination"
    else
        resolved_destination="$destination"
    fi

    if [[ -d "$resolved_destination" || "$destination" == */ || ! -e "$resolved_destination" ]]; then
        mkdir -p "$resolved_destination" || {
            echo "Failed to create destination directory: $resolved_destination" >&2
            error "Failed to create destination directory: $resolved_destination"
            return 1
        }
        final_destination="$resolved_destination/$(basename "$file")"
    else
        mkdir -p "$(dirname "$resolved_destination")" || {
            echo "Failed to create destination parent directory: $(dirname "$resolved_destination")" >&2
            error "Failed to create destination parent directory: $(dirname "$resolved_destination")"
            return 1
        }
        final_destination="$resolved_destination"
    fi

    printf "moving file %s to %s\n" "$file" "$final_destination"
    inform "moving file $file to $final_destination"
    mv -- "$file" "$final_destination" || {
        echo "Failed to move file $file to $final_destination" >&2
        error "Failed to move file $file to $final_destination"
        return 1
    }
}

move_by_extension() {
    local file
    local extension
    local destination

    printf "Enter the extension: "
    read -r extension
    printf "Enter the destination directory: "
    read -r destination

    destination="$(prepare_destination_path "$destination")" || return 1

    while IFS= read -r file; do
        [[ $extension == "$(get_extension "$file")" ]] && {
            move_file "$file" "$destination"
        }
    done < "$found_files_store_path"

}

move_by_date() {
    local file
    local destination
    local date_bucket

    printf "Enter the destination directory: "
    read -r destination
    destination="$(prepare_destination_path "$destination")" || return 1

    while IFS= read -r file; do
        [[ -f "$file" ]] || continue
        date_bucket="$(date -d "@$(stat -c %Y -- "$file")" +%Y-%m-%d 2>/dev/null || printf '%s' "unknown")"
        move_file "$file" "$destination/$date_bucket"
    done < "$found_files_store_path"
}

