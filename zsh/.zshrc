PROMPT='%(?..%F{red}%?%f )%B%F{white}%n%f%b %Bin%b %F{cyan}%2~%f → '
RPROMPT='%F{8} %*%f'

if [ -f "$HOME/.config/paths.sh" ]; then
    source "$HOME/.config/paths.sh"
fi

if [ -f "$ZSH_CONFIG_PATH/.zsh_modules" ]; then
    source "$ZSH_CONFIG_PATH/.zsh_modules"
fi


clear && echo