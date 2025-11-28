@echo off
chcp 65001 >nul
echo ========================================
echo     تثبيت نظام كيان ERP تلقائياً
echo     KAYAN ERP - Automatic Installation
echo ========================================
echo.

echo [1/4] التحقق من Node.js...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ خطأ: Node.js غير مثبت!
    echo الرجاء تثبيت Node.js من: https://nodejs.org
    pause
    exit /b 1
)
echo ✓ Node.js مثبت بنجاح
echo.

echo [2/4] تثبيت المكتبات...
call npm install
if %errorlevel% neq 0 (
    echo ❌ فشل تثبيت المكتبات
    pause
    exit /b 1
)
echo ✓ تم تثبيت المكتبات بنجاح
echo.

echo [3/4] التحقق من ملف الإعدادات...
if not exist .env (
    echo ⚠ ملف .env غير موجود
    echo إنشاء ملف .env من القالب...
    (
        echo # بيانات قاعدة البيانات
        echo DB_SERVER=localhost
        echo DB_PORT=1433
        echo DB_NAME=KayanERP
        echo DB_USER=sa
        echo DB_PASSWORD=your_password_here
        echo.
        echo # إعدادات التطبيق
        echo VITE_APP_NAME=KAYAN ERP
        echo VITE_APP_VERSION=2.1.0
        echo.
        echo # الأمان
        echo JWT_SECRET=change-this-secret-key
        echo SESSION_SECRET=change-this-session-secret
    ) > .env
    echo ✓ تم إنشاء ملف .env
    echo ⚠ تحذير: الرجاء تحديث بيانات قاعدة البيانات في ملف .env
) else (
    echo ✓ ملف .env موجود
)
echo.

echo [4/4] بناء المشروع...
call npm run build
if %errorlevel% neq 0 (
    echo ❌ فشل بناء المشروع
    pause
    exit /b 1
)
echo ✓ تم بناء المشروع بنجاح
echo.

echo ========================================
echo ✓ تم التثبيت بنجاح!
echo ========================================
echo.
echo الخطوات التالية:
echo 1. قم بتحديث بيانات قاعدة البيانات في ملف .env
echo 2. نفذ ملفات SQL في مجلد DATABASE_SQL_SERVER
echo 3. شغل المشروع بالأمر: npm run dev
echo.
echo للدعم الفني: 0507132413
echo KAYAN Modern Creative
echo ========================================
pause
