@echo off
lfind . -iname "*.py" -type f -not -path '*/\.git/*' -print0 | xargs -0 grep -F "%1"
