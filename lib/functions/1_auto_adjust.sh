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
    [[ ! -d "$destination" && ! -w "$destination" ]] && {
        printf "Creating directory %s\n" "$SCRIPT_DIR/$destination"
        inform "Creating directory $SCRIPT_DIR/$destination"

        create_dir "$HOME/$destination" || {
            echo "Failed to create directory $HOME/$destination" >&2
            error "Failed to create directory $HOME/$destination"
            exit 1
        }
    }
    
    while IFS= read -r file; do 
        extension="$(get_extension "$file")"
        printf "File: %s, Extension: %s\n" "$file" "$extension"
        [[ $extension != "" ]] && {
            create_dir "$destination/$extension"
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
    [[ ! -d "$destination" && ! -w "$destination" ]] && {
        create_dir "$SCRIPT_DIR/$destination"
        destination="$SCRIPT_DIR/$destination"
    }
    
    while IFS= read -r file; do 
        size="$(get_size "$file")"
        [[ $size != "" ]] && {
            create_dir "$destination/$size"
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
    [[ ! -d "$destination" && ! -w "$destination" ]] && {
        create_dir "$SCRIPT_DIR/$destination"
        destination="$SCRIPT_DIR/$destination"
    }
    
    while IFS= read -r file; do 
        mtime="$(get_mtime "$file")"
        [[ $mtime != "" ]] && {
            create_dir "$destination/$mtime"
            move_file "$file" "$destination/$mtime"
        }
    done < "$found_files_store_path"
}