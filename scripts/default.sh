alias dotconf="dot --origin-suffix=.config --target-suffix=.config"

dot ".profile"
dot ".bashrc"
dot ".zshrc"
dot ".vimrc"
dot ".fonts.conf"

dotconf "fish" -r
dotconf "hypr" -r
dotconf "nvim" -r -d1

dotconf "tmux" -r -i ".tmux.conf"
