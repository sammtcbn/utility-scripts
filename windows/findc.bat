@echo off
lfind . -iname "*.c" -type f -not -path '*/\.git/*' | xargs grep "%1"
