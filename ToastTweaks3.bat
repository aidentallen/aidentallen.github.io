@echo off
color 05
mode 75, 30
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting admin privileges...
    powershell start-process -verb runas -filepath "%~f0"
    exit /b
)
chcp 65001
:start
cls
title 
color 04
echo ████████╗ ██████╗  █████╗ ███████╗████████╗
echo ╚══██╔══╝██╔═══██╗██╔══██╗██╔════╝╚══██╔══╝
echo    ██║   ██║   ██║███████║███████╗   ██║   
echo    ██║   ██║   ██║██╔══██║╚════██║   ██║   
echo    ██║   ╚██████╔╝██║  ██║███████║   ██║██╗
echo    ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝   ╚═╝╚═╝
echo Select a tweak to run:
echo ┌────┬──────────────────────────────────────┐
echo │ 1. │ Disable UAC Prompt (not recommended) │
echo │ 2. │ Disable Windows Auto Restore Points  │
echo │ 3. │ Create Registry Backup               │
echo │ 4. │ Optimize Network Settings            │
echo │ 5. │ Run Hellzerg Optimizer               │
echo │ 6. │ Run Chris Titus Utility              │
echo │ 7. │ Exit                                 │
echo └────┴──────────────────────────────────────┘
echo.
set /p choice="number?: "

if "%choice%"=="1" goto DisableUAC
if "%choice%"=="2" goto DisableAutoRestore
if "%choice%"=="3" goto CreateRegistryBackup
if "%choice%"=="4" goto OptimizeNetwork
if "%choice%"=="5" goto Optimizer
if "%choice%"=="6" goto christitusutility
if "%choice%"=="7" goto Exit

:DisableUAC
echo Disabling User Account Control (UAC)...
reg.exe ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f
echo UAC Disabled.
goto countdown

:DisableAutoRestore
echo Disabling Windows Auto Restore...
reg.exe ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager" /v BackupCount /t REG_DWORD /d 0 /f
echo Auto Restore Disabled.
goto countdown

:CreateRegistryBackup
echo Creating a registry backup...
mkdir C:\RegBackup
regedit.exe /E C:\RegBackup\Backup.reg
echo Registry backup created at C:\RegBackup\Backup.reg.
goto countdown

:OptimizeNetwork
echo Optimizing Network Settings...
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global rss=enabled
netsh int tcp set global chimney=enabled
echo Network settings optimized.
goto countdown

:Optimizer
set "url=https://github.com/hellzerg/optimizer/releases/download/16.6/Optimizer-16.6.exe"
set "output=Optimizer-16.6.exe"

echo Downloading %url%...
start powershell -Command "Invoke-WebRequest -Uri '%url%' -OutFile '%output%'"

if not exist "%output%" (
    echo Failed to download %url%
    exit /b 1
)

echo Running %output% as administrator...
start powershell -NoExit -Command "Start-Process '%cd%\%output%' -Verb RunAs"
echo Optimizer executed successfully.
goto start

:christitusutility
echo Running the ChrisTitusUtility...
start powershell -NoExit -Command "iwr -useb https://christitus.com/win | iex; exit"
echo Script executed successfully.
goto start

:countdown
echo Please wait while we prepare for the next operation...
for /L %%i in (5,-1,1) do (
    echo %%i
    timeout /t 1 >nul
)
goto start

:Exit
exit
