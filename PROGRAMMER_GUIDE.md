# دليل المبرمج - نظام كيان ERP
# Programmer's Guide - KAYAN ERP System

---

## 📚 نظرة عامة للمبرمج المحلي

هذا الدليل موجه للمبرمج الذي سيعمل على النظام محلياً. يحتوي على كل المعلومات التقنية اللازمة.

---

## 🛠️ التقنيات المستخدمة

### Frontend (الواجهة الأمامية)
- **React 18.3**: مكتبة بناء واجهات المستخدم
- **TypeScript**: لغة البرمجة (JavaScript مع أنواع البيانات)
- **Vite**: أداة البناء السريعة
- **Tailwind CSS**: إطار عمل CSS
- **Lucide React**: مكتبة الأيقونات

### Backend (قاعدة البيانات)
- **SQL Server 2016+**: قاعدة البيانات الرئيسية
- **Stored Procedures**: لتنفيذ العمليات المعقدة

### الأدوات
- **Node.js**: بيئة التشغيل
- **npm**: مدير الحزم
- **Git**: نظام التحكم بالإصدارات (اختياري)

---

## 📁 هيكل المشروع التفصيلي

```
kayan-erp/
│
├── src/                          # المصدر الرئيسي
│   ├── components/              # مكونات React
│   │   ├── Login.tsx           # صفحة تسجيل الدخول
│   │   ├── Dashboard.tsx       # لوحة التحكم الرئيسية
│   │   ├── POSSystem.tsx       # نظام نقاط البيع العادي
│   │   ├── FullScreenPOS.tsx   # نقطة البيع بشاشة كاملة
│   │   ├── InvoiceForm.tsx     # نموذج الفاتورة
│   │   ├── InvoicesList.tsx    # قائمة الفواتير
│   │   ├── UniversalManagement.tsx  # إدارة شاملة
│   │   ├── ChartOfAccounts.tsx # دليل الحسابات
│   │   ├── ReportsAnalytics.tsx # التقارير
│   │   └── ...                 # مكونات أخرى
│   │
│   ├── contexts/               # React Contexts
│   │   └── AuthContext.tsx    # سياق المصادقة
│   │
│   ├── lib/                    # مكتبات مساعدة
│   │   └── supabase.ts        # (قديم - سيتم استبداله بـ SQL Server)
│   │
│   ├── utils/                  # أدوات مساعدة
│   │   └── zatcaQRCode.ts     # توليد QR Code للفواتير
│   │
│   ├── styles/                 # ملفات الأنماط
│   │   └── designSystem.ts    # نظام التصميم الموحد
│   │
│   ├── App.tsx                 # المكون الرئيسي
│   ├── main.tsx               # نقطة الدخول
│   └── index.css              # الأنماط العامة
│
├── DATABASE_SQL_SERVER/         # ملفات قاعدة البيانات
│   ├── 01_CREATE_TABLES.sql   # إنشاء الجداول
│   └── 02_STORED_PROCEDURES.sql # الإجراءات المخزنة
│
├── public/                      # ملفات عامة
│   ├── kayan erp.jpg          # شعار النظام
│   └── ...                     # صور وأيقونات
│
├── package.json                # معلومات وتبعيات المشروع
├── tsconfig.json              # إعدادات TypeScript
├── vite.config.ts             # إعدادات Vite
├── tailwind.config.js         # إعدادات Tailwind
├── .env                       # متغيرات البيئة (تُنشأ يدوياً)
├── README_AR.md               # دليل المستخدم بالعربي
└── PROGRAMMER_GUIDE.md        # هذا الملف
```

---

## 🚀 البدء السريع

### 1. التثبيت الأولي

```bash
# انتقل لمجلد المشروع
cd kayan-erp

# ثبت المكتبات
npm install

# أو استخدم السكريبت الجاهز (Windows)
QUICK_INSTALL.bat
```

### 2. إعداد قاعدة البيانات

#### أ. إنشاء قاعدة البيانات
افتح SQL Server Management Studio ونفذ:

```sql
-- من ملف: DATABASE_SQL_SERVER/01_CREATE_TABLES.sql
-- هذا الملف سينشئ:
-- - قاعدة بيانات KayanERP
-- - جميع الجداول
-- - العلاقات والفهارس
```

#### ب. إنشاء الإجراءات المخزنة
```sql
-- من ملف: DATABASE_SQL_SERVER/02_STORED_PROCEDURES.sql
-- هذا الملف يحتوي على:
-- - sp_register_user
-- - sp_login_user
-- - sp_create_invoice
-- - sp_update_inventory
-- - والمزيد...
```

### 3. إعداد ملف .env

أنشئ ملف `.env` في الجذر:

```env
# قاعدة البيانات
DB_SERVER=localhost
DB_PORT=1433
DB_NAME=KayanERP
DB_USER=sa
DB_PASSWORD=YourStrongPassword123

# التطبيق
VITE_APP_NAME=KAYAN ERP
VITE_APP_VERSION=2.1.0

# الأمان
JWT_SECRET=your-random-secret-key-min-32-chars
SESSION_SECRET=your-session-secret-key
```

### 4. تشغيل المشروع

```bash
# للتطوير
npm run dev

# أو استخدم
QUICK_START.bat
```

---

## 🔧 العمل مع قاعدة البيانات

### الاتصال بـ SQL Server

سنحتاج لمكتبة للاتصال بـ SQL Server من Node.js:

```bash
npm install mssql
npm install @types/mssql --save-dev
```

### مثال على الاتصال

أنشئ ملف `src/lib/database.ts`:

```typescript
import sql from 'mssql';

const config: sql.config = {
  server: process.env.DB_SERVER || 'localhost',
  port: parseInt(process.env.DB_PORT || '1433'),
  database: process.env.DB_NAME || 'KayanERP',
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  options: {
    encrypt: false, // للاتصال المحلي
    trustServerCertificate: true,
  },
};

let pool: sql.ConnectionPool | null = null;

export async function getConnection() {
  if (!pool) {
    pool = await sql.connect(config);
  }
  return pool;
}

// مثال: تسجيل الدخول
export async function loginUser(email: string, passwordHash: string) {
  const connection = await getConnection();
  const result = await connection
    .request()
    .input('email', sql.NVarChar, email)
    .input('password_hash', sql.NVarChar, passwordHash)
    .execute('sp_login_user');

  return result.recordset[0];
}

// مثال: إنشاء فاتورة
export async function createInvoice(data: any) {
  const connection = await getConnection();
  const result = await connection
    .request()
    .input('organization_id', sql.UniqueIdentifier, data.org_id)
    .input('branch_id', sql.UniqueIdentifier, data.branch_id)
    .input('customer_id', sql.UniqueIdentifier, data.customer_id)
    .input('invoice_type', sql.NVarChar, data.invoice_type)
    .input('payment_method', sql.NVarChar, data.payment_method)
    .input('created_by', sql.UniqueIdentifier, data.user_id)
    .input('items', sql.NVarChar, JSON.stringify(data.items))
    .execute('sp_create_invoice');

  return result.recordset[0];
}
```

---

## 🎨 نظام التصميم

### الألوان الأساسية

```typescript
// في src/styles/designSystem.ts
export const colors = {
  // الألوان الرئيسية
  primary: {
    50: '#f0fdf4',
    500: '#10b981',  // الأخضر الرئيسي
    600: '#059669',
    700: '#047857',
  },
  secondary: {
    500: '#06b6d4',  // السماوي
    600: '#0891b2',
  },
  accent: {
    500: '#3b82f6',  // الأزرق
  },
  // الحالات
  success: '#10b981',
  warning: '#f59e0b',
  error: '#ef4444',
  info: '#3b82f6',
};
```

### المسافات

```typescript
// النظام يستخدم 8px Grid
export const spacing = {
  xs: '0.25rem',  // 4px
  sm: '0.5rem',   // 8px
  md: '1rem',     // 16px
  lg: '1.5rem',   // 24px
  xl: '2rem',     // 32px
  '2xl': '3rem',  // 48px
};
```

### الخطوط

```typescript
export const fonts = {
  sizes: {
    xs: '0.75rem',    // 12px
    sm: '0.875rem',   // 14px
    base: '1rem',     // 16px
    lg: '1.125rem',   // 18px
    xl: '1.25rem',    // 20px
    '2xl': '1.5rem',  // 24px
  },
  weights: {
    normal: 400,
    medium: 500,
    semibold: 600,
    bold: 700,
  },
};
```

---

## 🔐 نظام المصادقة

### تشفير كلمة المرور

```typescript
import bcrypt from 'bcrypt';

// عند التسجيل
async function register(email: string, password: string) {
  const hashedPassword = await bcrypt.hash(password, 10);

  // حفظ في قاعدة البيانات
  await connection
    .request()
    .input('email', sql.NVarChar, email)
    .input('password_hash', sql.NVarChar, hashedPassword)
    .execute('sp_register_user');
}

// عند تسجيل الدخول
async function login(email: string, password: string) {
  // جلب المستخدم من قاعدة البيانات
  const user = await getUserByEmail(email);

  // مقارنة كلمة المرور
  const isValid = await bcrypt.compare(password, user.password_hash);

  if (!isValid) {
    throw new Error('كلمة المرور غير صحيحة');
  }

  return user;
}
```

### JWT Tokens

```bash
npm install jsonwebtoken
npm install @types/jsonwebtoken --save-dev
```

```typescript
import jwt from 'jsonwebtoken';

const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key';

// إنشاء token
function generateToken(user: any) {
  return jwt.sign(
    {
      id: user.id,
      email: user.email,
      role: user.role,
    },
    JWT_SECRET,
    { expiresIn: '7d' }
  );
}

// التحقق من token
function verifyToken(token: string) {
  try {
    return jwt.verify(token, JWT_SECRET);
  } catch (error) {
    throw new Error('Token غير صالح');
  }
}
```

---

## 📊 العمل مع البيانات

### مثال: جلب المنتجات

```typescript
// في component
import { useEffect, useState } from 'react';

interface Product {
  id: string;
  name: string;
  barcode: string;
  selling_price: number;
  quantity: number;
}

function ProductList() {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadProducts();
  }, []);

  async function loadProducts() {
    try {
      const response = await fetch('/api/products');
      const data = await response.json();
      setProducts(data);
    } catch (error) {
      console.error('خطأ في تحميل المنتجات:', error);
    } finally {
      setLoading(false);
    }
  }

  if (loading) return <div>جاري التحميل...</div>;

  return (
    <div className="grid grid-cols-3 gap-4">
      {products.map(product => (
        <div key={product.id} className="p-4 border rounded">
          <h3>{product.name}</h3>
          <p>السعر: {product.selling_price} ريال</p>
          <p>الكمية: {product.quantity}</p>
        </div>
      ))}
    </div>
  );
}
```

### مثال: إنشاء فاتورة

```typescript
async function createNewInvoice(cartItems: any[], customerId: string) {
  const invoice = {
    org_id: currentOrganization.id,
    branch_id: currentBranch.id,
    customer_id: customerId,
    invoice_type: 'مبيعات',
    payment_method: 'نقدي',
    user_id: currentUser.id,
    items: cartItems.map(item => ({
      product_id: item.product.id,
      quantity: item.quantity,
      unit_price: item.product.selling_price,
      tax_rate: item.product.tax_rate || 15,
    })),
  };

  const result = await fetch('/api/invoices', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(invoice),
  });

  return result.json();
}
```

---

## 🧩 المكونات الرئيسية

### 1. نظام نقاط البيع (FullScreenPOS.tsx)

الوظائف الرئيسية:
- عرض المنتجات حسب الفئات
- إضافة للسلة
- حساب الضريبة
- معالجة الدفع
- طباعة الفاتورة

### 2. لوحة التحكم (Dashboard.tsx)

المميزات:
- إحصائيات يومية
- مبيعات اليوم
- المنتجات الأكثر مبيعاً
- تنبيهات المخزون

### 3. الإدارة الشاملة (UniversalManagement.tsx)

يشمل:
- إدارة المنتجات
- إدارة الفئات
- إدارة العملاء
- إدارة المستخدمين
- الإعدادات

---

## 🔄 API Endpoints المطلوبة

ستحتاج لإنشاء API endpoints (يمكن استخدام Express.js):

```typescript
// server.ts (مثال)
import express from 'express';
import { loginUser, createInvoice, getProducts } from './lib/database';

const app = express();
app.use(express.json());

// تسجيل الدخول
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await loginUser(email, password);
    res.json({ success: true, user });
  } catch (error) {
    res.status(401).json({ error: error.message });
  }
});

// جلب المنتجات
app.get('/api/products', async (req, res) => {
  try {
    const products = await getProducts();
    res.json(products);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// إنشاء فاتورة
app.post('/api/invoices', async (req, res) => {
  try {
    const invoice = await createInvoice(req.body);
    res.json(invoice);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.listen(3000, () => {
  console.log('API Server running on port 3000');
});
```

---

## 🐛 Debugging والاختبار

### استخدام Console

```typescript
// للتطوير فقط
console.log('البيانات:', data);
console.error('خطأ:', error);
console.table(products); // عرض جدول
```

### React Developer Tools

ثبت الإضافة في Chrome:
- React Developer Tools
- Redux DevTools (إذا استخدمت Redux)

### SQL Server Profiler

لمراقبة الاستعلامات:
1. افتح SQL Server Profiler
2. أنشئ Trace جديد
3. راقب الاستعلامات المنفذة

---

## 📦 البناء والنشر

### بناء للإنتاج

```bash
npm run build
```

هذا ينشئ مجلد `dist` يحتوي على:
- HTML, CSS, JS مُحسّنة
- ملفات مضغوطة
- جاهزة للرفع

### النشر على IIS (Windows Server)

1. ثبت IIS
2. أنشئ موقع جديد
3. أشر للمجلد `dist`
4. أضف web.config:

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <system.webServer>
    <rewrite>
      <rules>
        <rule name="React Routes" stopProcessing="true">
          <match url=".*" />
          <conditions logicalGrouping="MatchAll">
            <add input="{REQUEST_FILENAME}" matchType="IsFile" negate="true" />
            <add input="{REQUEST_FILENAME}" matchType="IsDirectory" negate="true" />
          </conditions>
          <action type="Rewrite" url="/" />
        </rule>
      </rules>
    </rewrite>
  </system.webServer>
</configuration>
```

---

## 🎓 نصائح للمبرمج الجديد

### 1. فهم React Hooks

الـ Hooks المستخدمة بكثرة:
- `useState`: لحالة المكون
- `useEffect`: للعمليات الجانبية
- `useContext`: للبيانات المشتركة

### 2. فهم TypeScript

```typescript
// أنواع البيانات
interface User {
  id: string;
  name: string;
  email: string;
  role: 'admin' | 'user' | 'cashier';
}

// دالة مع أنواع
function calculateTotal(price: number, quantity: number): number {
  return price * quantity;
}
```

### 3. استخدام Tailwind CSS

```tsx
// مثال على التصميم
<div className="bg-white rounded-lg shadow-md p-4 hover:shadow-lg transition-shadow">
  <h2 className="text-xl font-bold text-gray-800 mb-2">
    العنوان
  </h2>
  <p className="text-gray-600 text-sm">
    النص
  </p>
</div>
```

### 4. إدارة الأخطاء

```typescript
try {
  // الكود
} catch (error) {
  console.error('خطأ:', error);
  // عرض رسالة للمستخدم
  alert('حدث خطأ: ' + error.message);
}
```

---

## 📞 الدعم والمساعدة

إذا واجهت أي مشكلة:

1. **راجع ملف README_AR.md**: يحتوي على حلول للمشاكل الشائعة
2. **تحقق من Console**: (F12 في المتصفح)
3. **راجع SQL Server Logs**: للأخطاء في قاعدة البيانات
4. **اتصل بالدعم الفني**: 0507132413

---

## ✅ Checklist للمبرمج

قبل البدء، تأكد من:

- [ ] تثبيت Node.js
- [ ] تثبيت SQL Server
- [ ] تنفيذ ملفات SQL
- [ ] إنشاء ملف .env
- [ ] تشغيل npm install
- [ ] اختبار الاتصال بقاعدة البيانات
- [ ] فتح المشروع في VS Code
- [ ] تثبيت الإضافات الموصى بها

---

## 📚 مصادر إضافية

- [React Docs](https://react.dev)
- [TypeScript Handbook](https://www.typescriptlang.org/docs)
- [Tailwind CSS](https://tailwindcss.com/docs)
- [SQL Server Docs](https://docs.microsoft.com/sql)
- [Node.js Docs](https://nodejs.org/docs)

---

**حظاً موفقاً في التطوير!**

KAYAN Modern Creative © 2025
