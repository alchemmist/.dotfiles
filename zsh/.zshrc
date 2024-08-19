#autoswitch_virtualenv If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$HOME/.cargo/bin:$HOME/.python3.12/bin:/home/alchemmist/.local/lib/python3.12/site-packages:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

export EDITOR="nvim"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
source $ZSH/oh-my-zsh.sh

plugins=(
    git
    poetry
    zsh-autosuggestions
    zoxide
    zsh-you-should-use
    fzf
    shellfirm
    docker
)


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# alias python="/home/alchemmist/.python3.12/bin/python"
# alias pip="/home/alchemmist/.python3.12/bin/pip"

alias pbcopy='wl-copy'
alias pbpaste='wl-paste'

alias tuxsay="cowsay -f tux"
alias nvim_clear_swap="rm -rf ~/.local/state/nvim/swap/*"

alias cd="z"

hp-scan() {
    cd ~/Pictures/scans
    yes "" | /usr/bin/hp-scan -m color
    cd -
}

dot() {
    cd ~/.dotfiles
    dotter $argv
    cd -
}


# PROTECTION FOR RM COMMAND
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
STOP_MESSAGE="!!!    STOP     !!!\nWHAT ARE YOU DOING?"

BLACK_LIST=(
    "/*" 
    "/" 
    "~" 
    "~/*"
)

check_second_argument() {
    for str in "${BLACK_LIST[@]}"; do
        if [[ "$1" == "$str" ]]; then
            return 0
        fi
    done
    return 1
}

rm() {
    if [[ "$1" == "-rf" ]] && check_second_argument "$2"; then
        echo "$STOP_MESSAGE"
    else
        /bin/rm -i --preserve-root "$@"
    fi
}
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 


eval "fastfetch"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# SSH-agent
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent -s > /dev/null)"
fi



if [ "$(tty)" = "/dev/tty1" -o "$(tty)" = "/dev/tty2" ] && [ -z "$(printenv HYPRLAND_INSTANCE_SIGNATURE)" ]; then
  exec ~/.local/bin/wlinitrc
fi


# HA HA HA

