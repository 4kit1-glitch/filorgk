#!/usr/bin/env bash
# shellcheck source=/dev/null
# shellcheck disable=2155
# directory finder script


read_directory() {
    local response
    read -r response || {
        printf "Failed to read directory" 2> /dev/null
        error "Failed to read directory exited"
        exit 1
    }
    [[ $response == "/bye" ]] && { 
        inform "safe exit at getting directory"
        exit 0
    }

    printf "%s" "$response"
    return 0
}

select_directory() {
    local -a matches=("$@")
    local PS3="Please select a directory (/bye or type 0 to cancel): "
    select dir in "${matches[@]}"; do
        if [[ -n $dir ]]; then
            printf "%s" "$dir"
            return 0
        elif (( REPLY == 0 )); then
            inform "safe exit at getting directory"
            exit 0
        else
            printf "Invalid selection. Please try again.\n"
            error "Invalid selection. Please try again."
        fi
    done

}

find_all_matches() {
    local user_input=$(read_directory)
    local -a found_matches
    
    mapfile -t found_matches < <(find ~ -maxdepth 2 -type d -iname "*$user_input*" )

    [[ ${#found_matches[@]} -eq 0 ]] && {
        printf "No directory with name %s found\n" "$user_input" 2> /dev/null
        inform "No directory with name $user_input found"
        exit 0
    }
    select_directory "${found_matches[@]}" || {
        printf "Failed to select a directory" 2> /dev/null
        error "Failed to select a directory"
        exit 1
    }
    return 0
}