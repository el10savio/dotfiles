plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
    autojump
    fzf
)

PROMPT=" $ %B%F{40}%n%f%b%F{40}@%f%B%F{40}%m%f%b:%~"

emacs () {
    readonly file=${1:?"file to be opened"}
    open -a Emacs "$file"
}
