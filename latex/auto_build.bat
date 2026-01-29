@echo off
cd /d "%~dp0"
title LATEX AUTO-BUILD (PowerShell Core)

echo ========================================================
echo   HE THONG TU DONG BIEN DICH LATEX (CHE DO WATCH)
echo   - Tu dong bo qua loi (Skip Error)
echo   - Chong Spam Save (Chi chay khi file luu xong)
echo ========================================================
echo.

:: --- GỌI POWERSHELL ĐỂ XỬ LÝ LOGIC (KHÔNG BỊ LỖI CÚ PHÁP CMD) ---
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$file = 'main.tex'; " ^
    "if (-not (Test-Path $file)) { Write-Host 'Loi: Khong tim thay file main.tex'; exit } " ^
    "$last = (Get-Item $file).LastWriteTime; " ^
    "Write-Host ' [READY] Da san sang. Hay sua code va bam Ctrl+S...'; " ^
    "while($true) { " ^
        "Start-Sleep -Seconds 1; " ^
        "$curr = (Get-Item $file).LastWriteTime; " ^
        "if ($curr -ne $last) { " ^
            "Clear-Host; " ^
            "Write-Host ' [PHAT HIEN SAVE] Dang cho 1 giay de luu han...'; " ^
            "Start-Sleep -Seconds 1; " ^
            "$curr = (Get-Item $file).LastWriteTime; " ^
            "Write-Host ' [RUNNING] Dang chay Xelatex...'; " ^
            "cmd /c 'taskkill /F /IM xelatex.exe >nul 2>&1'; " ^
            "cmd /c 'xelatex -interaction=nonstopmode -synctex=1 main.tex'; " ^
            "$last = $curr; " ^
            "Write-Host '---------------------------------------------'; " ^
            "Write-Host ' [DONE] Da xong. Kiem tra PDF.'; " ^
        "} " ^
    "}"