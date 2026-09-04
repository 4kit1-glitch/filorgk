#!/usr/bin/env bash
# shellcheck source=/dev/null
# shellcheck disable=2155
# option parser script for filorgk

get_option() {
    local options=("$@")
    local PS3="Select Operation: "
    select opt in "${options[@]}"; do
        if [[ -n "$opt" ]]; then
            printf "%s" "$opt"
            break
        else
            echo "Invalid option. Please try again."
        fi
    done

}


get_main_option() {
    local -a options=("delete" "move" "auto-arrange")
    get_option "${options[@]}" || {
        echo "failed to get main option" >&2
        error "failed to get main option"
        exit 1
    }
}
get_sub_option() {
    local main_option="$1"
    case "$main_option" in
        "delete")
            local -a sub_options=("delete_empty_files" "delete_large_files" 
            "delete_old_files" "delete_by_extension")
            ;;
        "move")
            local -a sub_options=("move_by_extension" "move_by_size" "move_by_date")
        ;;
        "auto-arrange")
            local -a sub_options=("auto_arrange_by_extension" "auto_arrange_by_size" "auto_arrange_by_mtime")
        ;;
        *)
            echo "Invalid main option: $main_option" >&2
            error "Invalid main option: $main_option"
            exit 1
        ;;
    esac
    get_option "${sub_options[@]}" || {
        echo "Failed to get sub option for main option: $main_option" >&2
        error "Failed to get sub option for main option: $main_option"
        exit 1
    }
}