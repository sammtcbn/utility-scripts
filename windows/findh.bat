@echo off
lfind . -iname "*.h" -type f -not -path '*/\.git/*' -print0 | xargs -0 grep "%1"
