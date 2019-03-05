function user {
	echo %{$fg[green]%}%n%{$reset_color%}@%{$fg[cyan]%}%m
}

function path {
	echo %{$fg[white]%}%~
}

function bracket {
	echo %{$fg[blue]%}'['$1%{$fg[blue]%}']'
}

function venv_prompt_info {
	[ $VIRTUAL_ENV ] && echo ' '$(bracket %{$fg[cyan]%}v:`basename $VIRTUAL_ENV`)
}

function conda_prompt_info {
	[ $CONDA_DEFAULT_ENV ] && echo ' '$(bracket %{$fg[cyan]%}"c:$CONDA_DEFAULT_ENV")
}

PROMPT=$'%{$fg[blue]%}┌$(bracket $(user)) $(bracket $(path))$(git_prompt_info)$(venv_prompt_info)$(conda_prompt_info)
%{$fg[blue]%}└%{$fg[blue]%}[%(?.%{$fg[magenta]%}.%{$fg[red]%})%(!.#.$)%{$fg[blue]%}] '

RPS1=$'%{$fg[blue]%}[%{\e[0;33m%}%D{%I:%M%P, %m/%d}%{$fg[blue]%}]%{$reset_color%}%b'

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[blue]%}[%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%}]"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*"
ZSH_THEME_GIT_PROMPT_CLEAN=""
