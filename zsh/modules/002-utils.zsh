run_script() {
    if [ -f "$UTILS_PATH/$1.sh" ]; then
        local bash_script="$1"
        shift
        bash "$UTILS_PATH/$bash_script.sh" "$@"
    else
        echo "$1 script not found in $UTILS_PATH"
        return 1
    fi
}

run_python_script() {
    if [ -f "$PYTHON_SCRIPTS_PATH/$1.py" ]; then
        local py_script="$1"
        shift
        python3 "$PYTHON_SCRIPTS_PATH/$py_script.py" "$@"
    else
        echo "$1 python script not found in $PYTHON_SCRIPTS_PATH"
        return 1
    fi
}

# Functions
open_app() {
    local with_args
    if [ "$#" -gt 0 ]; then
        local app="$1"
        shift
        open -n "/Applications/${app}.app" --args "$@"
    else
        echo "No application specified"
    fi
}

# Bash scripts
find_links() {
    run_script "find_links"
}

# Python scripts
create-hype() {
   run_python_script "create-hype" "$@"
}

optimage() {
   run_python_script "optimage" "$@"
}

code() {
    run_python_script "open-code" "$@"
}