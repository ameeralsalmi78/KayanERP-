@echo off
chcp 65001 >nul
echo ========================================
echo     تشغيل نظام كيان ERP
echo     KAYAN ERP - Quick Start
echo ========================================
echo.

echo جاري تشغيل النظام...
echo.
echo المتصفح سيفتح تلقائياً على:
echo http://localhost:5173
echo.
echo للإيقاف: اضغط Ctrl+C
echo ========================================
echo.

start http://localhost:5173
call npm run dev
