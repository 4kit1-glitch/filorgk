#!/usr/bin/env bash
# shellcheck source=/dev/null
# shellcheck disable=2154
# flag parser script for filorgk


usage() {
    printf "%s\n" "\
    FILORGK - File Organizer and Cleaner for Linux

    detailed usage:
        delete, move, and auto-arrange files based on various criteria.

    (Usage: filorgk [OPTION])

    NOTE: still in development.

    options:
        -h, --help           Show this help message and exit
        -v, --version        Show version information and exit
        -r, --reset          Delete all logs and reset runstate
        -i, --info           Print the latest info log
        -e, --error          Print the latest error log

    or
    (usage with no options will prompt for interactive mode)

    Author: Kengah Ireneaus
    github: 4kit1-glitch
    "
}

latest_log_file() {
    local log_type="$1"
    local pattern=""
    local current_log_path=""
    local latest_log=""

    case "$log_type" in
        info)
            pattern="info_*.log"
            current_log_path="${current_info_log_path:-}"
            ;;
        error)
            pattern="err_*.log"
            current_log_path="${current_err_log_path:-}"
            ;;
        *)
            echo "Unsupported log type: $log_type" >&2
            return 1
            ;;
    esac

    if [[ -n "$current_log_path" && -f "$current_log_path" ]]; then
        printf '%s\n' "$current_log_path"
        return 0
    fi

    latest_log=$(find "$LOGS_DIR" -maxdepth 1 -type f -name "$pattern" -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -n 1 | awk '{print $2}')

    if [[ -z "$latest_log" || ! -f "$latest_log" ]]; then
        echo "No $log_type log found in $LOGS_DIR" >&2
        return 1
    fi

    printf '%s\n' "$latest_log"
    return 0
}

show_log() {
    local log_type="$1"
    local target_log

    target_log=$(latest_log_file "$log_type") || return 1
    cat "$target_log"
    return 0
}

parse_flags() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                usage
                exit 0
                ;;
            -v|--version)
                echo "filorgk version: $VERSION"
                exit 0
                ;;
            -r|--reset)
                reset_logs_and_runstate
                exit 0
                ;;
            -i|--info)
                show_log "info"
                exit 0
                ;;
            -e|--error)
                show_log "error"
                exit 0
                ;;
            *)
                echo "Unknown option: $1" >&2
                usage
                exit 1
                ;;
        esac
    done
}