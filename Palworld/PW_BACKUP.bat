@echo off
title PW_Backup
setlocal enabledelayedexpansion

REM Place this .BAT in your Palworld server's root folder
REM     and edit the 'User Configuration' sections as needed

REM ******************
REM User Configuration
REM ******************

set "backupFolder=.\backup"
set "numberBackupDaysToKeep=10"
set "winrarPath=C:\Program Files\WinRAR\rar.exe"
set "backupStatus=** FAILED **"

:do_backup
REM  Ensure the server is still running
tasklist | find /i "PalServer.exe" > nul
if %errorlevel% neq 0 (
    EXIT /B 1
)

:prep
mkdir "%backupFolder%"

:purge
forfiles /P "%backupFolder%" /S /M *.RAR /D -%numberBackupDaysToKeep% /C "cmd /c ECHO @path & DEL /Q @path"

REM Get timestamp for backup folder (date and time without seconds)
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set "datetime=%%I"
set "timestamp=!datetime:~0,4!_!datetime:~4,2!_!datetime:~6,2!-!datetime:~8,2!_!datetime:~10,2!_!datetime:~12,2!"

set "backupName=%backupFolder%\Backup_%timestamp%.RAR"

REM Create RAR, exluding all but the CONFIG & SAVE folders/files
"%winrarPath%" a -r -ep1 -m5 -t -x*\Crashes\* -x*\Crashes\ -x*\ImGui\* -x*\ImGui\ -x*\Logs\* -x*\Logs\ -x*\Config\CrashReportClient\* -x*\Config\CrashReportClient\ -x*\SaveGames\0\*\backup\ "!backupName!" ".\Pal\Saved\*"
set backupExitCode=%ERRORLEVEL%

endlocal
IF %backupExitCode% EQ 0 (
    set backupStatus=success
)

EXIT /B
