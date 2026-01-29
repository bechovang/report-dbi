@echo off
cd /d "%~dp0"
title LATEX AUTO-BUILD (SILENT MODE)

echo ========================================================
echo   HE THONG TU DONG BIEN DICH (CHE DO GON GANG)
echo   - Tu dong an toan bo lenh chay (Silent Mode)
echo   - Hien thi thanh trang thai don gian
echo ========================================================
echo.

:: --- GỌI POWERSHELL ---
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$file = 'main.tex'; " ^
    "if (-not (Test-Path $file)) { Write-Host 'Loi: Khong tim thay file main.tex'; exit } " ^
    "$last = (Get-Item $file).LastWriteTime; " ^
    "Write-Host ' [READY] Da san sang. Hay sua code va bam Ctrl+S...' -ForegroundColor Green; " ^
    "while($true) { " ^
        "Start-Sleep -Seconds 1; " ^
        "$curr = (Get-Item $file).LastWriteTime; " ^
        "if ($curr -ne $last) { " ^
            "Clear-Host; " ^
            "Write-Host ' [SAVE] Phat hien thay doi. Dang chuan bi...' -ForegroundColor Yellow; " ^
            "Start-Sleep -Seconds 1; " ^
            "$curr = (Get-Item $file).LastWriteTime; " ^
            "Write-Host ' [1/2] Dang chay Xelatex lan 1... ' -NoNewline -ForegroundColor Cyan; " ^
            "cmd /c 'taskkill /F /IM xelatex.exe >nul 2>&1'; " ^
            "cmd /c 'xelatex -interaction=nonstopmode -synctex=1 main.tex >nul 2>&1'; " ^
            "Write-Host 'OK.' -ForegroundColor Green; " ^
            "Write-Host ' [2/2] Dang chay Xelatex lan 2 (Fix khung)... ' -NoNewline -ForegroundColor Cyan; " ^
            "cmd /c 'xelatex -interaction=nonstopmode -synctex=1 main.tex >nul 2>&1'; " ^
            "Write-Host 'OK.' -ForegroundColor Green; " ^
            "$last = $curr; " ^
            "Write-Host '---------------------------------------------' -ForegroundColor Gray; " ^
            "Write-Host ' [DONE] Xong. Moi chi kiem tra PDF.' -ForegroundColor White; " ^
        "} " ^
    "}"