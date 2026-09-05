#!/usr/bin/env bash
# shellcheck source=/dev/null
# shellcheck disable=2154
# execute function script

execute_sub_option() {
    local sub_option="$1"
    case "$sub_option" in
        "delete_empty_files")
            delete_empty_files
        ;;
        "delete_large_files")
            delete_large_files
        ;;
        "delete_old_files")
            delete_old_files
        ;;
        "delete_by_extension")
            delete_by_extension
        ;;
        "move_by_extension")
            move_by_extension
        ;;
        "move_by_date")
            move_by_date
        ;;
        "auto_arrange_by_extension")
            auto_arrange_by_extension
        ;;
        "auto_arrange_by_size")
            auto_arrange_by_size
        ;;
        "auto_arrange_by_mtime")
            auto_arrange_by_mtime
        ;;
        *)
            echo "Invalid sub option: $sub_option" >&2
            error "Invalid sub option: $sub_option"
            exit 1
        ;;
    esac
}