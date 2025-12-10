# ~/.config/fish/config.fish

# Sapling
abbr -a addremove sl addremove
abbr -a amend sl amend
abbr -a commit sl commit -m
abbr -a diff sl diff
abbr -a dr sl pr submit -d
abbr -a forget sl forget
abbr -a goto sl goto
abbr -a graft sl graft
abbr -a hide sl hide
abbr -a p sl pull --rebase
abbr -a prev sl prev
abbr -a revert sl revert
abbr -a show sl show
abbr -a shelve sl shelve
abbr -a sl:fix "git config --global --add safe.directory $PWD/.sl/store/git && git config --global credential.helper '!/usr/bin/env gh auth git-credential'"
abbr -a st sl st
abbr -a stat sl show --stat
abbr -a uncommit sl uncommit
abbr -a unshelve sl unshelve

# Other
abbr -a cp cp -i
abbr -a erase abbr --erase (abbr --list)
abbr -a mkdir mkdir -p
abbr -a mv mv -i
abbr -a rm rm -i
abbr -a src source ~/.config/fish/config.fish

eval (starship init fish)
zoxide init fish | source
