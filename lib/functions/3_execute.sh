#!/usr/bin/env bash
# shellcheck source=/dev/null
# shellcheck disable=2154
# execute function script


run_precaution() {
    read -r answer
    [[ "$answer" != "[Y][y]" ]] && {
        echo "Operation cancelled by user" >&2
        exit 1
    }
}
execute_sub_option() {
    local sub_option="$1"
    case "$sub_option" in
        "delete_empty_files")
            printf "Are you sure you want to delete empty files? [Y/y] to confirm: "
            run_precaution
            clear
            delete_empty_files
        ;;
        "delete_large_files")
            printf "Are you sure you want to delete large files? [Y/y] to confirm: "
            run_precaution
            clear
            delete_large_files
        ;;
        "delete_old_files")
            printf "Are you sure you want to delete old files? [Y/y] to confirm: "
            run_precaution
            clear
            delete_old_files
        ;;
        "delete_by_extension")
            printf "Are you sure you want to delete files by extension? [Y/y] to confirm: "
            run_precaution
            clear
            delete_by_extension
        ;;
        "move_by_extension")
            printf "Are you sure you want to move files by extension? [Y/y] to confirm: "
            run_precaution
            clear
            move_by_extension
        ;;
        "move_by_date")
            printf "Are you sure you want to move files by date? [Y/y] to confirm: "
            run_precaution
            clear
            move_by_date
        ;;
        "auto_arrange_by_extension")
            printf "Are you sure you want to auto arrange files by extension? [Y/y] to confirm: "
            run_precaution
            clear
            auto_arrange_by_extension
        ;;
        "auto_arrange_by_size")
            printf "Are you sure you want to auto arrange files by size? [Y/y] to confirm: "
            run_precaution
            clear
            auto_arrange_by_size
        ;;
        "auto_arrange_by_mtime")
            printf "Are you sure you want to auto arrange files by modification time? [Y/y] to confirm: "
            run_precaution
            clear
            auto_arrange_by_mtime
        ;;
        *)
            echo "Invalid sub option: $sub_option" >&2
            error "Invalid sub option: $sub_option"
            exit 1
        ;;
    esac
}