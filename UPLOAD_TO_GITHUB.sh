#!/bin/bash

echo "=========================================="
echo "   رفع نظام كيان ERP إلى GitHub"
echo "=========================================="
echo ""

# 1. تهيئة Git
echo "[1/5] تهيئة Git..."
git init

# 2. إضافة الملفات
echo "[2/5] إضافة الملفات..."
git add .

# 3. Commit
echo "[3/5] إنشاء Commit..."
git commit -m "Initial commit - KAYAN ERP System - Ready for Production"

# 4. إضافة Remote (غيّر YOUR_USERNAME باسم مستخدمك)
echo "[4/5] ربط بـ GitHub..."
echo "⚠️  غيّر YOUR_USERNAME باسم مستخدمك على GitHub"
read -p "أدخل اسم المستخدم على GitHub: " username
git remote add origin https://github.com/$username/kayan-erp.git

# 5. رفع الملفات
echo "[5/5] رفع الملفات..."
git branch -M main
git push -u origin main

echo ""
echo "=========================================="
echo "✅ تم الرفع بنجاح!"
echo "=========================================="
