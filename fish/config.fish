set -g fish_key_bindings fish_user_key_bindings
source $HOME/.config/fish/functions/csy.fish
bass source $HOME/.profile


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /home/charles/Developments/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

