@echo off
set currpath=%cd%
set zipfile=%1
set destdir=%currpath%

if exist "C:\Program Files\7-Zip\7z.exe" (
    "C:\Program Files\7-Zip\7z" x %zipfile% -o%destdir%
) else (
    powershell -command "Expand-Archive -Force %zipfile% %destdir%"
)

cd /d "%currpath%"
