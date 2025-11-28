# تعليمات تحميل نظام كيان ERP
# KAYAN ERP Download Instructions

---

## 🎯 للحصول على النظام كاملاً

النظام جاهز للتحميل والاستخدام فوراً!

---

## 📦 المحتويات الكاملة

عند تحميل النظام، ستحصل على:

### ✅ الملفات الرئيسية:
- **Frontend كامل** (React + TypeScript + Tailwind)
- **قاعدة بيانات SQL Server** (Scripts جاهزة)
- **أدلة شاملة** (بالعربي والإنجليزي)
- **سكريبتات التثبيت** (تلقائية)
- **الصور والشعارات** (كاملة)

### ✅ الأدلة المرفقة:
1. **README_AR.md** - دليل المستخدم الشامل
2. **PROGRAMMER_GUIDE.md** - دليل المبرمج التفصيلي
3. **HOW_TO_DOWNLOAD_AND_USE.md** - دليل التحميل والاستخدام
4. **DOWNLOAD_INSTRUCTIONS.md** - هذا الملف

---

## 🚀 طريقة الحصول على الكود

### الطريقة 1: تحميل مباشر من المجلد الحالي

**أنت الآن في بيئة التطوير!**

النظام موجود في المسار:
```
/tmp/cc-agent/54831328/project/
```

**لتحميله:**

#### على Linux/Mac:
```bash
# إنشاء أرشيف مضغوط
cd /tmp/cc-agent/54831328/
tar -czf kayan-erp-full.tar.gz project/

# أو استخدم zip
zip -r kayan-erp-full.zip project/
```

#### على Windows:
```powershell
# استخدم PowerShell
Compress-Archive -Path project\ -DestinationPath kayan-erp-full.zip
```

### الطريقة 2: رفع على GitHub

```bash
# في مجلد المشروع
cd /tmp/cc-agent/54831328/project/

# تهيئة Git
git init
git add .
git commit -m "Initial commit - KAYAN ERP System"

# ربط بـ GitHub (بعد إنشاء repository)
git remote add origin https://github.com/your-username/kayan-erp.git
git branch -M main
git push -u origin main
```

بعدها يمكن التحميل من GitHub:
```bash
git clone https://github.com/your-username/kayan-erp.git
```

### الطريقة 3: رفع على Google Drive

1. اضغط الملفات كما في الطريقة 1
2. ارفع الملف المضغوط على Google Drive
3. شارك الرابط مع من تريد

---

## 📋 قائمة الملفات المهمة

تأكد من وجود هذه الملفات:

```
kayan-erp/
├── src/                    ✅ (كود المشروع)
├── public/                 ✅ (الصور والملفات)
├── DATABASE_SQL_SERVER/    ✅ (ملفات SQL)
│   ├── 01_CREATE_TABLES.sql
│   └── 02_STORED_PROCEDURES.sql
├── package.json           ✅
├── package-lock.json      ✅
├── vite.config.ts         ✅
├── tailwind.config.js     ✅
├── tsconfig.json          ✅
├── README_AR.md           ✅
├── PROGRAMMER_GUIDE.md    ✅
├── QUICK_INSTALL.bat      ✅
├── QUICK_START.bat        ✅
└── .gitignore             ✅
```

---

## ⚠️ ملفات لا يجب مشاركتها

احذف أو تجاهل هذه الملفات قبل المشاركة:

```
❌ .env                    # يحتوي على بيانات حساسة
❌ node_modules/           # ثقيل جداً (سيتم تثبيته بـ npm install)
❌ dist/                   # ملفات البناء
❌ .DS_Store               # ملف Mac
```

لحذفها:
```bash
rm -rf node_modules dist .env
```

---

## 📤 تجهيز الكود للمبرمج المحلي

### الخطوة 1: تنظيف المشروع

```bash
# في مجلد المشروع
npm run build           # بناء نسخة نهائية
rm -rf node_modules     # حذف المكتبات (سيتم إعادة تثبيتها)
```

### الخطوة 2: إنشاء ملف .env.example

أنشئ ملف `.env.example` (بدون بيانات حساسة):

```env
# بيانات قاعدة البيانات
DB_SERVER=localhost
DB_PORT=1433
DB_NAME=KayanERP
DB_USER=your_username
DB_PASSWORD=your_password

# إعدادات التطبيق
VITE_APP_NAME=KAYAN ERP
VITE_APP_VERSION=2.1.0

# الأمان (غيّر هذه القيم)
JWT_SECRET=your-secret-key-here
SESSION_SECRET=your-session-secret-here
```

### الخطوة 3: إنشاء ملف README للمبرمج

أنشئ ملف `FOR_PROGRAMMER.txt`:

```txt
مرحباً بك في نظام كيان ERP!

لبدء العمل:

1. ثبت Node.js (إصدار 18+) من nodejs.org
2. ثبت SQL Server
3. افتح Terminal في مجلد المشروع
4. نفذ: npm install
5. أنشئ ملف .env من .env.example
6. نفذ ملفات SQL من مجلد DATABASE_SQL_SERVER
7. نفذ: npm run dev

للمزيد من التفاصيل:
- README_AR.md للاستخدام العام
- PROGRAMMER_GUIDE.md للتطوير

الدعم الفني: 0507132413
KAYAN Modern Creative
```

### الخطوة 4: الضغط والإرسال

```bash
# ضغط الملفات
zip -r kayan-erp-for-programmer.zip . -x "node_modules/*" "dist/*" ".git/*"

# أو
tar -czf kayan-erp-for-programmer.tar.gz --exclude=node_modules --exclude=dist --exclude=.git .
```

---

## 🔐 الأمان والخصوصية

### قبل إرسال الكود:

1. ✅ **احذف .env** (يحتوي كلمات مرور)
2. ✅ **راجع الكود** (لا توجد بيانات حساسة)
3. ✅ **أزل التعليقات الحساسة** (إن وجدت)
4. ✅ **تأكد من إضافة .env.example**

### .gitignore موصى به:

```gitignore
# البيئة
.env
.env.local
.env.production

# المكتبات
node_modules/
bower_components/

# البناء
dist/
build/

# IDE
.vscode/
.idea/
*.swp
*.swo
*.swn

# OS
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*
```

---

## 📨 إرسال الكود للمبرمج

### الخيار 1: عبر البريد الإلكتروني

```
الموضوع: نظام كيان ERP - الكود المصدري

مرفق معك الكود الكامل لنظام كيان ERP.

📦 المحتويات:
- كود المشروع كاملاً
- قاعدة بيانات SQL Server
- أدلة الاستخدام والتطوير
- سكريبتات التثبيت

📋 ما تحتاجه:
- Node.js 18+
- SQL Server 2016+
- محرر أكواد (VS Code موصى به)

📄 ابدأ من:
1. اقرأ README_AR.md
2. للتطوير: اقرأ PROGRAMMER_GUIDE.md

للاستفسارات: 0507132413

بالتوفيق!
```

### الخيار 2: عبر Google Drive

```
1. ارفع الملف المضغوط
2. اجعله قابل للمشاركة
3. أرسل الرابط مع التعليمات أعلاه
```

### الخيار 3: عبر USB/Hard Drive

```
1. انسخ المجلد الكامل
2. أرفق ملف نصي بالتعليمات
3. سلّمه للمبرمج
```

---

## 🎯 ماذا يجب أن يفعل المبرمج؟

### بعد استلام الكود:

```bash
# 1. فك الضغط
unzip kayan-erp-for-programmer.zip
cd kayan-erp

# 2. تثبيت المكتبات
npm install

# 3. إنشاء .env من .env.example
cp .env.example .env
# ثم تحديث البيانات في .env

# 4. تشغيل SQL Scripts
# افتح SSMS ونفذ الملفات من DATABASE_SQL_SERVER/

# 5. تشغيل المشروع
npm run dev

# 6. فتح المتصفح على
# http://localhost:5173
```

---

## 📊 حجم الملفات المتوقع

| الملف/المجلد | الحجم التقريبي |
|--------------|----------------|
| src/ | ~2 MB |
| public/ | ~5 MB |
| DATABASE_SQL_SERVER/ | ~100 KB |
| الأدلة (MD files) | ~200 KB |
| **بدون node_modules** | **~7 MB** |
| **مع node_modules** | **~400 MB** |

**توصية:** أرسل الكود **بدون node_modules**

---

## ✅ Checklist قبل الإرسال

تأكد من:

- [ ] حذف node_modules/
- [ ] حذف dist/
- [ ] حذف .env
- [ ] إضافة .env.example
- [ ] إضافة README_AR.md
- [ ] إضافة PROGRAMMER_GUIDE.md
- [ ] إضافة ملفات SQL
- [ ] إضافة QUICK_INSTALL.bat
- [ ] إضافة QUICK_START.bat
- [ ] اختبار الملف المضغوط

---

## 🆘 دعم ما بعد التسليم

**للمبرمج المحلي:**

إذا واجهت أي مشكلة:

1. راجع **PROGRAMMER_GUIDE.md**
2. راجع **README_AR.md**
3. تحقق من الـ Console في المتصفح (F12)
4. راجع SQL Server Logs
5. اتصل بالدعم: 0507132413

---

## 📞 معلومات الاتصال

**الشركة:** KAYAN Modern Creative
**الهاتف:** 0507132413
**البريد الإلكتروني:** (حسب الحاجة)

**ساعات الدعم:**
- الأحد - الخميس: 9 صباحاً - 5 مساءً
- الجمعة - السبت: إجازة

---

## 📜 الترخيص والملكية

هذا النظام ملك لـ **KAYAN Modern Creative**

**الاستخدام:**
- ✅ مسموح للاستخدام الداخلي
- ✅ مسموح للتطوير والتحسين
- ❌ ممنوع البيع أو إعادة التوزيع
- ❌ ممنوع إزالة حقوق الملكية

---

## 🎉 كلمة أخيرة

تم تجهيز النظام بالكامل ليكون:
- ✅ جاهز للاستخدام
- ✅ سهل التثبيت
- ✅ موثّق بالكامل
- ✅ قابل للتطوير
- ✅ متوافق مع SQL Server

**نتمنى لك ولفريقك التوفيق!** 🚀

---

**آخر تحديث:** نوفمبر 2025
**الإصدار:** 2.1.0
**© 2025 KAYAN Modern Creative**
