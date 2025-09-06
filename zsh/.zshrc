############### CONFIGS DO ZSH ########################
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="spaceship"

CASE_SENSITIVE="false"

ENABLE_CORRECTION="true"

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
	zsh-syntax-highlighting
	zsh-autosuggestions
    fzf
    eza
    grc
    sudo
    tmux
)

ZSH_COLORIZE_STYLE="colorful" #config do plugin colorize 
ZSH_TMUX_AUTOSTART=true #config do plugin tmux para inciar o tmux automaticamente ao abrir o terminal

source $ZSH/oh-my-zsh.sh

################## ALIASES #############################
alias fvim='vim $(fzf -m --preview="batcat --color=always {}")'
alias cat='batcat'
alias nmap='grc nmap'

#eh necessario instalar uma NerdFont para que os icones funcionem direito
alias ls='eza -a --color=always --group-directories-first --icons' 
alias la='eza -la --color=always --group-directories-first --icons'


################## ALIASES #############################



################# FZF CONFIG ###########################

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

export FZF_DEFAULT_COMMAND="fdfind --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# alt+c is directory tree with preview in eza
export FZF_ALT_C_COMMAND="fdfind --type=d --hidden --strip-cwd-prefix"

export FZF_DEFAULT_OPTS="--height 70% --layout=reverse --border --color=hl:#2dd4bf"

# fzf default for tmux, change window size to preference
export FZF_TMUX_OPTS=" -p100%,100% "

# pwd without nano
#export FZF_CTRL_T_OPTS="--preview 'batcat --color=always -n --line-range :500 {}'"

# open with nano, or your editor of choice
export FZF_CTRL_T_OPTS="--preview 'batcat --color=always -n --line-range :500 {}' --bind 'enter:execute(vim {})'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

################# FZF CONFIG ###########################


SPACESHIP_PROMPT_ORDER=(
  user # Username section
  dir # Current directory section
  host # Hostname section
  git # Git section (git_branch + git_status)
  hg # Mercurial section (hg_branch + hg_status)
  exec_time # Execution time
  line_sep # Line break
  jobs # Background jobs indicator
  exit_code # Exit code section
  char # Prompt character
)

SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "


############### CONFIGS DO ZSH ########################















################ CONFIGS DO UV ######################
eval "$(uv generate-shell-completion zsh)"
eval "$(uv generate-shell-completion zsh)"
#compdef nxc
# Run something, muting output or redirecting it to the debug stream
# depending on the value of _ARC_DEBUG.
# If ARGCOMPLETE_USE_TEMPFILES is set, use tempfiles for IPC.
__python_argcomplete_run() {
    if [[ -z "${ARGCOMPLETE_USE_TEMPFILES-}" ]]; then
        __python_argcomplete_run_inner "$@"
        return
    fi
    local tmpfile="$(mktemp)"
    _ARGCOMPLETE_STDOUT_FILENAME="$tmpfile" __python_argcomplete_run_inner "$@"
    local code=$?
    cat "$tmpfile"
    rm "$tmpfile"
    return $code
}

__python_argcomplete_run_inner() {
    if [[ -z "${_ARC_DEBUG-}" ]]; then
        "$@" 8>&1 9>&2 1>/dev/null 2>&1 </dev/null
    else
        "$@" 8>&1 9>&2 1>&9 2>&1 </dev/null
    fi
}

_python_argcomplete() {
    local IFS=$'\013'
    local script=""
    if [[ -n "${ZSH_VERSION-}" ]]; then
        local completions
        completions=($(IFS="$IFS" \
            COMP_LINE="$BUFFER" \
            COMP_POINT="$CURSOR" \
            _ARGCOMPLETE=1 \
            _ARGCOMPLETE_SHELL="zsh" \
            _ARGCOMPLETE_SUPPRESS_SPACE=1 \
            __python_argcomplete_run ${script:-${words[1]}}))
        local nosort=()
        local nospace=()
        if is-at-least 5.8; then
            nosort=(-o nosort)
        fi
        if [[ "${completions-}" =~ ([^\\]): && "${match[1]}" =~ [=/:] ]]; then
            nospace=(-S '')
        fi
        _describe "${words[1]}" completions "${nosort[@]}" "${nospace[@]}"
    else
        local SUPPRESS_SPACE=0
        if compopt +o nospace 2> /dev/null; then
            SUPPRESS_SPACE=1
        fi
        COMPREPLY=($(IFS="$IFS" \
            COMP_LINE="$COMP_LINE" \
            COMP_POINT="$COMP_POINT" \
            COMP_TYPE="$COMP_TYPE" \
            _ARGCOMPLETE_COMP_WORDBREAKS="$COMP_WORDBREAKS" \
            _ARGCOMPLETE=1 \
            _ARGCOMPLETE_SHELL="bash" \
            _ARGCOMPLETE_SUPPRESS_SPACE=$SUPPRESS_SPACE \
            __python_argcomplete_run ${script:-$1}))
        if [[ $? != 0 ]]; then
            unset COMPREPLY
        elif [[ $SUPPRESS_SPACE == 1 ]] && [[ "${COMPREPLY-}" =~ [=/:]$ ]]; then
            compopt -o nospace
        fi
    fi
}
if [[ -z "${ZSH_VERSION-}" ]]; then
    complete -o nospace -o default -o bashdefault -F _python_argcomplete nxc
else
    # When called by the Zsh completion system, this will end with
    # "loadautofunc" when initially autoloaded and "shfunc" later on, otherwise,
    # the script was "eval"-ed so use "compdef" to register it with the
    # completion system
    autoload is-at-least
    if [[ $zsh_eval_context == *func ]]; then
        _python_argcomplete "$@"
    else
        compdef _python_argcomplete nxc
    fi
fi
