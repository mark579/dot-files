# A multiline prompt with username, hostname, full path, return status, git branch, git dirty status, git remote status
COLOR_GREY="%{$fg[grey]%}"
COLOR_RED="%{$fg[red]%}"
COLOR_YELLOW="%{$fg[yellow]%}"
COLOR_WHITE="%{$fg[white]%}"
COLOR_BLUE="%{$fg[blue]%}"
COLOR_CYAN="%{$fg[cyan]%}"
COLOR_MAGENTA="%{$fg[magenta]%}"

KUBE="$COLOR_WHITE"("$COLOR_CYAN"⎈"$(kubectl config current-context)$COLOR_WHITE")

local return_status="$COLOR_RED%(?..⏎)%{$reset_color%}"

PROMPT='%{$reset_color%}$COLOR_BLUE%10c%{$reset_color%} $(git_prompt_info)$(git_remote_status) $KUBE
$COLOR_CYAN❯%{$reset_color%} '


RPROMPT='${return_status}%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="$COLOR_GREY($COLOR_RED"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="$COLOR_GREY)$COLOR_YELLOW⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="$COLOR_GREY)"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="$COLOR_MAGENTA↓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="$COLOR_MAGENTA↑%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="$COLOR_MAGENTA↕%{$reset_color%}"