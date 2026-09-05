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
    
    or 
    (usage with no options will prompt for interactive mode)

    Author: Kengah Ireneaus
    github: 4kit1-glitch
    "
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
            *)
                echo "Unknown option: $1" >&2
                usage
                exit 1
                ;;
        esac
    done
}