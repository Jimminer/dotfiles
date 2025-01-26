autoload -U compinit; compinit
autoload -U +X bashcompinit && bashcompinit


# p10k stuff

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Use powerline
USE_POWERLINE="true"

# Zsh config
if [[ -e ~/.zsh/zsh-config ]]; then
 source ~/.zsh/zsh-config
fi
# p10k initialization
if [[ -e ~/.zsh/zsh-prompt ]]; then
 source ~/.zsh/zsh-prompt
fi



export QT_STYLE_OVERRIDE=gtk2
export QT_QPA_PLATFORMTHEME=gtk2

# Set default editor
export EDITOR="/bin/nvim"
# Set default pager (mainly for manpages)
export PAGER="/bin/bat"


# Enable auto completion for programs that autocomplete themselves
completions=(penv)
for i in ${completions[@]}; do
	complete -C $i $i
done

# Ctrl-Delete to delete the next word
bindkey "\e[3;5~" kill-word

# Fork of exa (modern ls alternative)
alias ls="eza"
alias ll="eza -l"
alias la="eza -la"

# Cat replacement with better formatting and a pager
alias cat="bat"

# alias find="fd"
# alias grep="rg"


# Query the pacman repos and fuzzy find the results
pacfind(){
    RED="\e[38;5;1m"
    GREEN="\e[38;5;2m"
    BLUE="\e[38;5;4m"
    PURPLE="\e[38;5;5m"
    RESET="\e[0m"

	# packages=$(pacman -Ssq)
	# installedPackages=($(pacman -Q | awk '{print $1}'))
	# for package in $installedPackages; do
	# 	packages=$(echo "$packages" | sed "s/^$package$/$package \[installed\]/")
	# done

	# echo "$packages" | fzf -m --preview='echo -en "$(pacman -Si $(echo {} | sed "s/ \[installed\]//"))\n i hate balls"' --bind 'enter:execute(echo {} | sed "s/ \[installed\]//")'

	pacman -Ssq | fzf -m --preview='echo -en "Installed\t: $(pacman -Qi {} &> /dev/null>/dev/null 2>&1 && echo -e "\e[38;5;2mTrue\e[0m" || echo -e "\e[38;5;1mFalse\e[0m")\n$(pacman -Si {})"' --bind 'enter:execute(sudo pacman -S {})'
}

# Query the AUR and fuzzy find the results
yayfind(){
    RED="\e[38;5;1m"
    GREEN="\e[38;5;2m"
    BLUE="\e[38;5;4m"
    PURPLE="\e[38;5;5m"
    RESET="\e[0m"

	yay -Slaq | fzf -m --preview='echo -en "Installed\t\t      : $(yay -Qi {} &> /dev/null>/dev/null 2>&1 && echo "\e[38;5;2mTrue\e[0m" || echo "\e[38;5;1mFalse\e[0m")\n$(yay -Si {})"' --bind 'enter:execute(yay -S {})'
}

# Query already installed packages and fuzzy find the results
infind(){
    RED="\e[38;5;1m"
    GREEN="\e[38;5;2m"
    BLUE="\e[38;5;4m"
    PURPLE="\e[38;5;5m"
    RESET="\e[0m"

	yay -Qq | fzf -m --preview-window=right:60% --preview='echo -en "Repository\t: $(pacman -Qqm | grep ^{}$ >/dev/null 2>&1 && echo "'$PURPLE'AUR'$RESET'" || echo "'$BLUE'Arch Repos'$RESET'")\n$(yay -Qii {})"'
}
# To toggle the preview using the space bar:
# --bind 'space:toggle-preview'




# repeet(){
# 	while true; do
# 		$@ &> /dev/null && break
# 		echo "Finished execution of $1"
# 	done
# }

# Repeat a command until it exits with a specific exit code
# Usage: repeet <exit code> <command>
#
# Example: repeet 0 sleep 5
# In the given example, if Ctrl-C is pressed before sleep finishes, the sleep will be interrupted and it will be rerun
repeet() {
	# Catch Ctrl-C
    trap "echo" SIGINT

	# First argument is the expected exit code
	local exitOn=$1
	# Second argument and onwards is the command to run
	local args=("${@:2}")

	echo -e "Repeeting \e[38;5;2m${args[*]}\e[0m until exit code \e[38;5;3m$exitOn\e[0m is received"

    while true; do
		# Run the command and send it's output to /dev/null
        "${args[@]}" &> /dev/null

		# If the command exited with the expected exit code, break
		local received=$?
		if [[ "$received" -eq "$exitOn" ]]; then
			echo -e "Exit code received: \e[38;5;2m$received\e[0m, exiting"
			break
		fi

		echo -e "Exit code received: \e[38;5;1m$received\e[0m, repeeting"
    done

	# Re-enable Ctrl-C
    trap - SIGINT
}

# Kill all processes which include a provided string ex: destroy Firefox
destroy(){
	kill -2 $(ps aux | grep "$1" | awk '{print $2}')
}

# Same as destroy but in this case, this kills without asking (it enjoys killing lol)
obliterate(){
	kill -9 $(ps aux | grep "$1" | awk '{print $2}')
}

# Fix a corrupted zsh history
fixhistory(){
	strings -eS ~/.zsh_history | sponge ~/.zsh_history
}


# History file settings
HISTFILE=~/.zsh_history             # History file location
HISTSIZE=999999999                  # Set a big size for the shell's history
SAVEHIST=999999999                  # Set a big size for the history file
setopt EXTENDED_HISTORY             # Write the history file in the ":start:elapsed;command" format
setopt INC_APPEND_HISTORY           # Write to the history file immediately, not when the shell exits
setopt SHARE_HISTORY                # Share history between all sessions
setopt HIST_FIND_NO_DUPS            # Don't display duplicates in history search
unsetopt HIST_SAVE_NO_DUPS          # Save duplicates in history
unsetopt HIST_IGNORE_ALL_DUPS       # Don't ignore duplicate commands
unsetopt HIST_IGNORE_DUPS           # Don't ignore duplicate commands


# Necessary stuff :)
export BESTDEV="mitsos"


# Adding stuff to PATH
export PATH="$HOME/.local/bin:$PATH"
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export JAVA_HOME="/usr/lib/jvm/java-21-openjdk"
export PATH="$HOME/flutter/bin:$PATH"
# export PATH="$HOME/.bin:$PATH"

if [[ -t 0 ]]; then
#   welcomer
fi

# Something about debugging with gdb lol
export DEBUGINFOD_URLS="https://debuginfod.archlinux.org"

# Alacritty is not always recognized as a terminal with colors in some cases (like ssh)
export TERM="xterm-256color"

# Override gpu to gxf1030 (Navi 21) for ROCm compatibility
export HSA_OVERRIDE_GFX_VERSION='10.3.0'
