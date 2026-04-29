# git repo graph
```
alias git_log='git log --all --decorate --oneline --graph'
```
# sync internet time
```
alias sync_internet_time='sudo date -s "$(wget --method=HEAD -qSO- --max-redirect=0 google.com 2>&1 | sed -n '\''s/^ *Date: *//p'\'')"'
```
# enable touchpad
```
alias enable_touchpad='gsettings set org.gnome.desktop.peripherals.touchpad send-events enabled'
alias disable_touchpad='gsettings set org.gnome.desktop.peripherals.touchpad send-events disabled'
```
# pylint for python code checks
```
pylint --disable=all --enable=C0103,E0602,E1101 <python module>
```
