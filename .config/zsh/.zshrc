if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zmodload zsh/zprof
fi

source $ZDOTDIR/config.zsh

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" ||\
    printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

export FZF_DEFAULT_OPTS=" \
--color=spinner:#f2d5cf,hl:#e78284 \
--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
--color=marker:#babbf1,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284 \
--color=selected-bg:#51576d \
--layout reverse \
--multi"

source <(fzf --zsh)

autoload -U compinit
compinit -C

source "$ZDOTDIR/ensure-zinit.zsh"

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

zinit ice has 'fzf'
zinit light Aloxaf/fzf-tab

zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

zinit ice has'eza' atinit'AUTOCD=1' atload'alias la="eza -a $eza_params"' silent
zinit light z-shell/zsh-eza

function zvm_after_init {
  zvm_bindkey viins "^R" fzf-history-widget
}

function Fv {
    fd --hidden --color=always --type f "${*:-}" |
        fzf \
        --ansi \
        --preview="bat -p --color=always {}" \
        --bind "enter:become(nvim {})"
}

function Fg {
    rg --color=always --line-number --hidden --no-heading --smart-case "${*:-}" |
        fzf --ansi \
        --delimiter : \
        --preview "bat --color=always {1} --highlight-line {2} --style=numbers" \
        --preview-window "down,60%,border-top,+{2}+3/3" \
        --bind "enter:become(nvim {1} +{2})"
}

unalias zi
eval "$(zoxide init zsh)"

alias nivm="nvim"
alias ngit='nvim -c "Neogit" -c "bd 1"'
alias cat="bat"

# alias -g -- -h="-h 2>&1 | bat --language=help --style=plain"
alias -g -- --help="--help 2>&1 | bat --language=help --style=plain"
function bathelp() {
    "$@" | bat --language=help --style=plain
}

export MANPAGER='nvim +Man!'

[ -f "/home/irmel/.ghcup/env" ] && . "/home/irmel/.ghcup/env" # ghcup-env

if [ -n "${ZSH_DEBUGRC+1}" ]; then
    zprof
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
