@echo off
@rem lfind . -iname "*.c" -type f -not -path '*/\.git/*' | xargs grep "%1"
lfind . -iname "*.c" -type f -not -path '*/\.git/*' -print0 | xargs -0 grep -F "%1"
