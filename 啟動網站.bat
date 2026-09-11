@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

title 區域網路 HTML 伺服器

echo.
echo ================================================
echo          區域網路 HTML 伺服器
echo ================================================
echo.

:: 取得 BAT 所在資料夾
set "WEBROOT=%~dp0"
cd /d "%WEBROOT%"

echo 網站目錄：
echo %WEBROOT%
echo.

:: 檢查 index.html
if not exist "%WEBROOT%index.html" (
    echo [錯誤] 找不到 index.html
    echo.
    echo 請把「啟動網站.bat」放在 index.html 所在的資料夾。
    echo.
    pause
    exit /b
)

:: 檢查 Python
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo [錯誤] 找不到 Python。
    echo.
    echo 請先安裝 Python，並確保 Python 已加入 PATH。
    echo.
    pause
    exit /b
)

:: 設定連接埠
set "PORT=8000"

:: 取得本機區域網路 IPv4
set "IP="

for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /R /C:"IPv4"') do (
    set "TEMPIP=%%A"
    set "TEMPIP=!TEMPIP: =!"

    :: 排除 127.0.0.1
    if not "!TEMPIP!"=="127.0.0.1" (
        set "IP=!TEMPIP!"
    )
)

echo ================================================
echo 伺服器已準備啟動
echo ================================================
echo.
echo 本機訪問：
echo http://127.0.0.1:%PORT%
echo.

if defined IP (
    echo 區域網路訪問：
    echo http://!IP!:%PORT%
    echo.
) else (
    echo [警告] 無法自動取得區域網路 IP。
    echo 請使用 ipconfig 手動查看 IPv4 位址。
    echo.
)

echo ================================================
echo 使用方法
echo ================================================
echo.
echo 1. 你的電腦可以訪問：
echo    http://127.0.0.1:%PORT%
echo.
if defined IP (
    echo 2. 同一區域網路的其他裝置可以訪問：
    echo    http://!IP!:%PORT%
    echo.
)
echo 3. 關閉此視窗即可停止網站。
echo.
echo ================================================
echo 正在啟動伺服器……
echo ================================================
echo.

:: 自動開啟本機網站
start "" "http://127.0.0.1:%PORT%"

:: 啟動 Python HTTP 伺服器
python -m http.server %PORT% --bind 0.0.0.0

echo.
echo ================================================
echo 伺服器已停止。
echo ================================================
pause