ZSH_CONFIG_MODULES_PATH="$ZSH_CONFIG_PATH/modules"

# Load common shell utils
for util_file in $COMMON_UTILS_PATH/shell/*.sh(N.); do
    source "$util_file" || echo "[ERROR:zsh] (zsh_modules.zsh): Could not source util file - $util_file"
done

# Load zsh custom modules
for file in $ZSH_CONFIG_MODULES_PATH/*.zsh(N.); do
    print_log DEBUG "Run 'source $file'"
    source "$file" || print_log ERROR "Could not source module file - $file"
done