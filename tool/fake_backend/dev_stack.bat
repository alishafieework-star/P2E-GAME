@echo off
REM My-Game dev stack: fake OTP API (:8787) + fake media (:8788) + two
REM Cloudflare quick tunnels. Keep the windows open: closing a tunnel window
REM invalidates its URL and the APK must be rebuilt with the new URLs.
setlocal
cd /d "%~dp0..\.."

set "CLOUDFLARED=%ProgramFiles(x86)%\cloudflared\cloudflared.exe"
if not exist "%CLOUDFLARED%" set "CLOUDFLARED=cloudflared"

echo [1/3] Starting fake media server (:8788)...
start "dev-media" cmd /k "dart run tool/fake_media/media_server.dart"

echo [2/3] Starting Cloudflare tunnels (API + media)...
start "tunnel-api" cmd /k ""%CLOUDFLARED%" tunnel --url http://localhost:8787 --no-autoupdate"
start "tunnel-media" cmd /k ""%CLOUDFLARED%" tunnel --url http://localhost:8788 --no-autoupdate"

echo [3/3] Copy the two https://xxxx.trycloudflare.com URLs from the tunnel windows.
set /p API_URL=API tunnel URL   (tunnel-api window):
set /p MEDIA_URL=Media tunnel URL (tunnel-media window):

echo Starting fake OTP API server with FAKE_MEDIA_BASE=%MEDIA_URL% ...
start "dev-api" cmd /k "set FAKE_MEDIA_BASE=%MEDIA_URL%&& dart run tool/fake_backend/server.dart"

echo.
echo ==== URLs of this run ====
echo   FAKE_API_BASE   = %API_URL%
echo   FAKE_MEDIA_BASE = %MEDIA_URL%
echo.
echo Build and install (from the repo root):
echo   flutter build apk --profile --no-pub --split-per-abi --target-platform android-arm64 --dart-define-from-file=config/dev.json --dart-define=FAKE_API_BASE=%API_URL% --dart-define=FAKE_MEDIA_BASE=%MEDIA_URL%
echo   adb install -r build\app\outputs\flutter-apk\app-arm64-v8a-profile.apk
echo.
echo OTP dev codes: phone ending 2222 = new account, 1111 = saved password (Play123!), 0000 = blocked, verify code = P12345
pause
