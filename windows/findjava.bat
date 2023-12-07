@echo off
lfind . -iname "*.java" -type f -not -path '*/\.git/*' -print0 | xargs -0 grep -F "%1"
