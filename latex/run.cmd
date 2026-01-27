@echo off
color 0A
title Tu dong bien dich LaTeX (Bo qua loi)

echo Dang chay Xelatex lan 1...
:: Them -interaction=nonstopmode de khong dung lai khi gap loi
xelatex -interaction=nonstopmode -synctex=1 main.tex

echo.
echo Dang chay Xelatex lan 2 (de cap nhat Muc luc va Tham chieu)...
:: Chay lan 2 de dam bao so trang va muc luc dung
xelatex -interaction=nonstopmode -synctex=1 main.tex

echo.
echo ============================================
echo   DA BIEN DICH XONG (DA TU DONG SKIP LOI)!
echo   Kiem tra file main.pdf nhe.
echo ============================================
echo.

pause > nul