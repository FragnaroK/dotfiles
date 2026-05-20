PROMPT='%(?..%F{red}%?%f )%B%F{white}%n%f%b %Bin%b %F{cyan}%2~%f → '
RPROMPT='%F{8} %*%f'

DEBUG_MODE=1

if [ ! -f "$HOME/.config/paths.sh" ]; then
    (( DEBUG_MODE == 0 )) && echo "[DEBUG:zsh] (.zshrc): $HOME/paths.sh file not found"
else
    source "$HOME/.config/paths.sh"
fi

ZSH_CONFIG_MODULES="$ZSH_CONFIG_PATH/zsh_modules.zsh"
if [ ! -f "$ZSH_CONFIG_MODULES" ]; then
    (( DEBUG_MODE == 0 )) && echo "[DEBUG:zsh] (.zshrc): $ZSH_CONFIG_MODULES file not found"
else
    source "$ZSH_CONFIG_MODULES"
fi

clear && echo
