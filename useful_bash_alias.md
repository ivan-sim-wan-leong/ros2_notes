# git repo graph
```
alias git_log='git log --all --decorate --oneline --graph'
```
# sync internet time
```
alias sync_internet_time='sudo date -s "$(wget --method=HEAD -qSO- --max-redirect=0 google.com 2>&1 | sed -n '\''s/^ *Date: *//p'\'')"'
```
