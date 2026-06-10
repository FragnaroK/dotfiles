 
# Shell scripts
find_links() {
    run_script "find_links"
}

# Python scripts
scrap() {
    run_python_script "scrap-page.py" "$@"
}

create-hype() {
   run_python_script "create-hype" "$@"
}

optimage() {
   run_python_script "optimage" "$@"
}

code() {
    run_python_script "open-code" "$@"
}