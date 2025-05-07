@echo off
wsl bash ./.copy_shared.sh

echo FINI

timeout /T 100>NUL


REM wsl bash dos2unix .copy_shared.sh