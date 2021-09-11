#!/bin/env fish
#
ulimit -n 20480

bind -M insert \cf accept-autosuggestion

alias emacs 'flatpak run org.gnu.emacs'

function tmux1 -d "create tmux on first tag"
    set -x NAME  (tmux ls | grep First |cut -d: -f 1)
    if test -n "$NAME"
        tmux a -t First
    else
        tmux new -s First
    end
end

# Rename this file to match the name of the function
# e.g. ~/.config/fish/functions/n.fish
# or, add the lines to the 'config.fish' file.

function n --description 'support nnn quit and change directory'
    # Block nesting of nnn in subshells
    if test -n "$NNNLVL"
        if [ (expr $NNNLVL + 0) -ge 1 ]
            echo "nnn is already running"
            return
        end
    end

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "-x" as in:
    #    set NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    if test -n "$XDG_CONFIG_HOME"
        set -x NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
    else
        set -x NNN_TMPFILE "$HOME/.config/nnn/.lastd"
    end

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn $argv

    if test -e $NNN_TMPFILE
        source $NNN_TMPFILE
        rm $NNN_TMPFILE
    end
end
#

#python virtualenv
function _env_test
    if test "$WORKON_HOME" = ""
        set -g WORKON_HOME $HOME/.virtualenvs
    end
end
function workon  -d "switch virtual environment"
    if test "$argv" = ""
        echo "virtualenv name should be specified"
        echo "workon VENV_NAME"
	return 1
    end
    _env_test
    set venv "$WORKON_HOME/$argv[1]"
    set activate "$venv/bin/activate.fish"
    if not test -f "$activate"
        echo "No virtualenv at $venv"
        return 1
    end
    . "$activate"
end

function lsvenv -d "list available environment(s)"
    _env_test
    ls -F1 $WORKON_HOME | grep -E "/" | sed s/.\$//
end
