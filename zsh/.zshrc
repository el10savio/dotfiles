# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

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
plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
    autojump
    fzf
)

source $ZSH/oh-my-zsh.sh

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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export CARGO_NET_GIT_FETCH_WITH_CLI=true

PROMPT="%F{10}$%f%F{214}%~%f: "

alias cat='bat --paging=never'
alias vscodium='open -a vscodium'
alias br='broot'

alias got="git"
alias gs="git status"
alias ga="git add"
alias gp="git push"
alias gc="git commit"
alias gru="git remote update; git fetch -a; git gc"
alias gd="git diff --name-status"
alias gu="git stash; gru; git pull; git --no-pager log --decorate=short --pretty=oneline -n1"

#eval "$(saml2aws --completion-script-zsh)"

export JIRA_API_TOKEN="token"
export JIRA_AUTH_TYPE="bearer"

emacs () {
		readonly file=$1
		if [ -n "$1" ];
		  then /usr/local/bin/emacs "$file";
		  else /usr/local/bin/emacs;
		fi
}

gotest () { 
		readonly run=$1
		if [ -n "$1" ];
		  then go vet ./... && go test -v -race -failfast --cover -run ^$run$ ./...; echo $?;
		  else go vet ./... && go test -v -race -failfast --cover ./...; echo $?;
		fi
		# fswatch -or . | xargs -n1 -I{} zsh -c 'source ~/.zshrc; gotest TestCase'
}

function stackoverflow { 
	lynx https://duckduckgo.com/lite\?q\="stackoverflow $1" 
}

tmux-split-cmd() { 
	tmux split-window -dv -t $TMUX_PANE "zsh" 
}

# fzfp scripts
function fzfp_scripts() {
		echo $(gfind ~/scripts -maxdepth 1 -type f  -name "*.sh" -printf "%f\n") $(gfind ~/scripts/vri -maxdepth 2 -type f -name "*.sh" -printf "%f\n") | tr " " "\n" | sort | ~/utils/fzfp --layout=reverse | xargs -I{} sh -c "echo {}; bash ~/scripts/{} "
}

# fzfp scripts split (ctrl-\)
function fzfp_scripts_split() {
	 tmux split-window "source ~/.zshrc; fzfp_scripts; zsh -i"
}
zle -N fzfp_scripts_split
bindkey '^\' fzfp_scripts_split 

# autoload -U compinit && compinit
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
		compinit
done
compinit -C


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

zle-upify() {
    buf="$(echo "$BUFFER" | sed 's/[ |]*$//')"
    tmp="$(mktemp)"
    eval "$buf |& up --unsafe-full-throttle -o '$tmp' 2>/dev/null"
    cmd="$(tail -n +2 "$tmp")"
    rm -f "$tmp"
    BUFFER="$BUFFER | $cmd"
    zle end-of-line
}
zle -N zle-upify

bindkey '^U' zle-upify
export PATH="/usr/local/smlnj/bin:/usr/local/opt/libpq/bin:$PATH"
# source /Users/e.savio/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source /Users/e.savio/.config/broot/launcher/bash/br

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/e.savio/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/e.savio/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/e.savio/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/e.savio/google-cloud-sdk/completion.zsh.inc'; fi
