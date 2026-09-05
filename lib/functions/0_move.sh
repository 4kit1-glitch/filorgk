#!/usr/bin/env bash
# shellcheck source=/dev/null
# shellcheck disable=2154
# move function script


create_dir() {
    local dir="$1"
    local sub_dir="$2"
    [[ ! -d "$dir" && ! -w "$dir" ]] && {
        mkdir -p "$dir/$sub_dir" || {
        echo "Failed to create directory $dir/$sub_dir" >&2
        echo "move operation failed" >&2
        error "move operation failed"
        error "Failed to create directory $dir/$sub_dir"
        exit 1
    }
        dir="$dir/$sub_dir"
    }
}
move_file() {
    local file="$1"
    local destination="$2"
    printf "moving file %s to %s\n" "$file" "$destination"
    inform "moving file $file to $destination"
    mv "$file" "$destination" || {
        echo "Failed to move file $file to $destination" >&2
        error "Failed to move file $file to $destination"
        exit 1
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
    [[ ! -d "$destination" && ! -w "$destination" ]] && {
        create_dir "$SCRIPT_DIR" "$destination"
    }
    
    while IFS= read -r file; do 
        [[ $extension == "$(get_extension "$file")" ]] && {
            move_file "$file" "$destination"
        }
    done < "$found_files_store_path"

}

