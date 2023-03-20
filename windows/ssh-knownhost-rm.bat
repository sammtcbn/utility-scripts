@echo off
if "%~1"=="" goto usage
ssh-keygen -R %1

exit /b

:usage
echo Usage: %~n0 [IP]