#!/usr/bin/env bash
# shellcheck disable=2154
# script for creating logs
#

info() {
    local message="$1"
    echo -e "[INFO] $message\n" >> "$current_info_log_path"
    return 0
}

error() {
    local message="$1"
    echo -e "[ERROR] $message\n" >> "$current_err_log_path"
    return 0
}

create_dir(){
    mkdir -p "$1" || {
        echo "failed to create directory: $1"
        return 1
    }
}