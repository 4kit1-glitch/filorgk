#!/usr/bin/env bash
#
# directory finder script


read_directory() {
    local response
    printf "Enter the directory to organise (ENTER /bye to quit): "
    read -r response || {
        printf "Failed to read directory" 2> /dev/null
        exit 1
    }
    [[ $response == "/bye" ]] && { exit 0; }

    printf "%s" "$response"
    return 0
}