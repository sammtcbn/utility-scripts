@echo off
lfind . -iname "*.go" -type f -not -path '*/\.git/*' -print0 | xargs -0 grep -F "%1"
