@echo off
lfind . -iname "*%1*" -type f -not -path '*/\.git/*'
