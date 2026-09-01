@echo off
setlocal
cd /d "%~dp0"
set "MYSQL_ROOT=C:\Program Files\MySQL\MySQL Server 8.4"
set "MYSQL_DATA=%~dp0.mysql-data"

rem Clean stale crash-recovery files so MySQL can restart after an interrupted shutdown.
if exist "%MYSQL_DATA%\undo_001" del /f /q "%MYSQL_DATA%\undo_001"
if exist "%MYSQL_DATA%\undo_002" del /f /q "%MYSQL_DATA%\undo_002"
if exist "%MYSQL_DATA%\undo_1_trunc.log" del /f /q "%MYSQL_DATA%\undo_1_trunc.log"
if exist "%MYSQL_DATA%\undo_2_trunc.log" del /f /q "%MYSQL_DATA%\undo_2_trunc.log"

netstat -ano | findstr ":3306" >nul
if errorlevel 1 start "School MySQL" /B "%MYSQL_ROOT%\bin\mysqld.exe" --basedir="%MYSQL_ROOT%" --datadir="%MYSQL_DATA%" --innodb-undo-directory="%MYSQL_DATA%" --port=3306

timeout /t 3 /nobreak >nul
start "School Server" /B cmd /c "npm.cmd start"
timeout /t 3 /nobreak >nul

set "IP="
for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /R /C:"IPv4 Address"') do set "IP=%%A"
set "IP=%IP: =%"

echo.
echo ========================================
echo Webpage is available on this Wi-Fi:
echo http://%IP%:3000/
echo ========================================
echo Use that URL on your cellphone or other device.
echo Keep this window open while using the webpage.
start "" "http://%IP%:3000/"
pause
