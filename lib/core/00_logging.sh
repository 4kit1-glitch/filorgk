#!/usr/bin/env bash
# shellcheck disable=2154
# script for creating logs
#

inform() {
    local message="$1"
    echo -e "[INFO] $message\n" >> "$current_info_log_path"
}

error() {
    local message="$1"
    echo -e "[ERROR] $message\n" >> "$current_err_log_path"
}

create_dir(){
    mkdir -p "$@" || {
        echo "failed to create directory: $*" 2> /dev/null
        return 1
    }
}