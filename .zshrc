autoload -U colors; colors
autoload -Uz vcs_info

setopt correct
setopt re_match_pcre
setopt prompt_subst

zstyle 'vcs_info:*' formats '(%b)'
zstyle 'vcs_info:*' actionformats '(%b|%a)'

function precmd () { vcs_info }

function branch-status-check {
	local prefix branchname suffix
		if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
			return
		fi
		branchname=`git-branch-name`
		if [[ -z $branchname ]]; then
			return
		fi
		prefix=`get-branch-status`
		suffix='%{'${reset_color}'%}'
		echo ${prefix}${branchname}${suffix}
}

function get-branch-name {
	echo `git rev-parse --abbrev-ref HEAD 2> /dev/null`
}

function get-branch-status {
	local res color
		output=`git status 2> /dev/null`
		if [[ -n `echo $output | | grep "^nothing to commit"` ]]; then
			res=':'
			color='%{'${fg[green]}'%}'
		elif [[ -n `echo $output | | grep "^# Untracked files:"` ]]; then
			res='?:'
			color='%{'${fg[yellow]}'%}'
                elif [[ -n `echo $output | | grep "^# Changes not staged for commit"` ]]; then
                        res='M:'
                        color='%{'${fg[red}'%}'
		else
                        res='A:'
                        color='%{'${fg[cyan]}'%}'
		fi
		echo ${color}
}

PROMPT="
[%n] %{${fg[yellow]}%}%~%{${reset_color}%}
%(?.%{$fg[green]%}.%{$fg[blue]%})%(?!(*'-') <!(*;-;%)? <)%{${reset_color}%} "
PROMPT2='[%n]> '
SPROMPT="%{$fg[red]%}%{$suggest%}(*'~'%)? < もしかして %B%r%b %{$fg[red]%}かな? [そう!(y), 違う!(n),a,e]:${reset_color} "

RPROMPT='%F{238}%D{%m/%d %T}%f [%(5C.%4C.%~)${vcs_info_msg_0_}]'
#RPROMPT='%F{238}%D{%m/%d %T}%f `branch-status-check`'

setopt transient_rprompt

export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=100000
setopt hist_ignore_dups
setopt EXTENDED_HISTORY
setopt share_history


