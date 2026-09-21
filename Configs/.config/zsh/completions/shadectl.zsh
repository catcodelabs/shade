    # shadectl tab completion
    if command -v shadectl &>/dev/null; then
        compdef _shadectl shadectl
        eval "$(shadectl completion zsh)"
    fi
