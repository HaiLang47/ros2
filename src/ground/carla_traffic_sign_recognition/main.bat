@echo off
REM Carla Traffic Sign Recognition 启动入口
cd /d %~dp0
if exist D:\WWW\venv_carla310\Scripts\python.exe (
    D:\WWW\venv_carla310\Scripts\python.exe main.py
) else (
    echo [ERROR] Venv not found at D:\WWW\venv_carla310
    python main.py
)
pause
