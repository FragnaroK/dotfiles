#!/bin/bash

print_log() {
    if [ $# -ne 2 ]; then
        echo "print_log - Usage: print_log <log_type> <message>"
        exit 1
    fi

    local log_type="$1"

    if [ "$log_type" = "DEBUG" ] && [ "${DEBUG_MODE:-1}" -ne 0 ]; then
        return 0
    fi

    local message="$2"
    local caller=""

    if [ -n "$BASH_VERSION" ]; then
        caller="${BASH_SOURCE[1]}:${BASH_LINENO[0]}"
    elif [ -n "$ZSH_VERSION" ]; then
        caller="${funcfiletrace[1]}"
    else
        caller="$(basename "$0")"
    fi

    echo "[$log_type] (${caller}): $message"
}

file_exists() {
    if [ -z "$1" ]; then
        print_log "ERROR" "Please, provide a file or directory"
    fi

    [ -f "$1" ];
}

run_script() {
    local shell_scripts_path="$COMMON_SCRIPTS_PATH/shell"

    print_log DEBUG "run_script: shell_scripts_path - $shell_scripts_path"

    if ! file_exists "$shell_scripts_path/$1.sh"; then
        echo "$1 script not found in $shell_scripts_path"
        return 1
    fi

    local bash_script="$1"
    shift
    local args="$@"

    print_log DEBUG "run_script: Running '$shell_scripts_path/$bash_script.sh $args'"
    bash "$shell_scripts_path/$bash_script.sh" "$args"
}

run_python_script() {
    local python_scripts_path="$COMMON_SCRIPTS_PATH/py"

    if [ -f "$python_scripts_path/$1.py" ]; then
        local py_script="$1"
        shift
        python3 "$python_scripts_path/$py_script.py" "$@"
    else
        echo "$1 python script not found in $python_scripts_path"
        return 1
    fi
}

open_app() {
    if [ "$#" -eq 0 ]; then
        echo "Please provide app name"
        echo "open_app: Usage - open_app <app_name> <...args>"
        return 1
    fi

    local app="$1"
    local app_path="/Applications/${app}.app"

    if ! file_exists "$app_path"; then
        print_log ERROR "App $app does not exists"
        return 1
    fi

    shift
    open -n "/Applications/${app}.app" --args "$@"
}