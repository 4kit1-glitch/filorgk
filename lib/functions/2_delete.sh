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
    rm "$file" || {
        echo "Failed to remove file.. force remove[Y/n]: "
        imform "Execution force option on $file"
        read -r response
        [[ $response == "[Yy]" ]] && {
            rm -rf "$file"
            inform "Force remove $file"
        }
    }
    return 0
}
delete_empty_files() {
    local file

    while IFS= read -r file; do
        [[ ! -s "$file" ]] && {
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
        find "$file" -size +1G -delete 2> /dev/null
    done < "$found_files_store_path"
}

delete_old_files() {
    local file
    printf "deleting files older that 30 days"
    inform "deletiing files older than 30 days"
    while IFS= read -r file; do
        find "$file" -mtime +30 -delete 2> /dev/null
    done < "$found_files_store_path"

}

delete_by_extension() {
    local response
    local extension
    printf "Enter the extension: "
    read -r response
    extension="$response"
    while IFS= read -r file; do 
        [[ $extension == "$(get_extension "$file")" ]] && {
            delete_file "$file"
        }
    done < "$found_files_store_path"
}