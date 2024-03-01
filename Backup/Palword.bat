@echo off
setlocal enabledelayedexpansion

REM Suggest placing this .BAT in your Palworld server's root folder
REM     and edit the 'User Configuration' sections as needed.  Else,
REM     adjust the paths as needed
REM
REM NOTE:  Requires WinRAR, or change the backup process to your utilize of choice
REM

REM ******************
REM User Configuration
REM ******************

set "backupFolder=.\Backup"
set "intervalMinutes=90"
set "numberBackupDaysToKeep=3"
set "winrarPath=C:\Program Files\WinRAR\rar.exe"
set "serverParameters=EpicApp=PalServer -servername=^"Server Name^" -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS"

REM ******
REM Do NOT edit this section (unless you know what you're doing)
REM ******
set /a "intervalSeconds=%intervalMinutes%*60"

:setup
mkdir "%backupFolder%"

:purge
forfiles /P "%backupFolder%" /S /M *.zip /D -%numberBackupDaysToKeep% /C "cmd /c ECHO @path & DEL /Q @path"

:Start_Server
REM ECHO ./PalServer.exe %serverParameters%

:backupLoop
echo Waiting for next iteration...
timeout /t %intervalSeconds% /nobreak >nul

REM Get timestamp for backup folder (date and time without seconds)
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set "datetime=%%I"
set "timestamp=!datetime:~0,4!_!datetime:~4,2!_!datetime:~6,2!-!datetime:~8,2!_!datetime:~10,2!_!datetime:~12,2!"

set "backupName=%backupFolder%\Backup_%timestamp%.zip"

REM Create ZIP, exluding all but the CONFIG & SAVE folders/files
"%winrarPath%" a -r -ep1 -m5 -x*\Crashes\* -x*\Crashes\ -x*\ImGui\* -x*\ImGui\ -x*\Logs\* -x*\Logs\ -x*\Config\CrashReportClient\* -x*\Config\CrashReportClient\ "!backupName!" ".\Pal\Saved\*" 

echo:
REM Uncomment to have BAT process exit is backup fails
REM IF %ERRORLEVEL% GEQ 1 EXIT /B %ERRORLEVEL%
echo Backup successful: %backupName%
echo:
echo:

goto backupLoop
