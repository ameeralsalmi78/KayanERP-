# 👨‍💻 دليل المطورين - KAYAN ERP

## 📚 المحتويات

1. [البدء السريع](#البدء-السريع)
2. [بنية المشروع](#بنية-المشروع)
3. [قاعدة البيانات](#قاعدة-البيانات)
4. [API Reference](#api-reference)
5. [أمثلة الاستخدام](#أمثلة-الاستخدام)
6. [الأمان](#الأمان)
7. [التطوير](#التطوير)

---

## 🚀 البدء السريع

### المتطلبات:
```bash
Node.js >= 18
npm >= 9
Supabase Account
```

### التثبيت:
```bash
# Clone the repository
git clone <repository-url>
cd kayan-erp

# Install dependencies
npm install

# Setup environment variables
cp .env.example .env
# Edit .env with your Supabase credentials

# Run migrations
npx supabase db push

# Start development server
npm run dev
```

---

## 📁 بنية المشروع

```
kayan-erp/
├── src/
│   ├── components/          # React Components
│   │   ├── Dashboard.tsx
│   │   ├── AdvancedDashboard.tsx
│   │   ├── BranchAnalytics.tsx
│   │   ├── POSSystem.tsx
│   │   ├── InvoiceForm.tsx
│   │   └── ...
│   │
│   ├── contexts/            # React Contexts
│   │   └── AuthContext.tsx
│   │
│   ├── lib/                 # Libraries & Utils
│   │   └── supabase.ts      # Supabase Client
│   │
│   ├── utils/               # Utility Functions
│   │   └── zatcaQRCode.ts
│   │
│   └── App.tsx             # Main App Component
│
├── supabase/
│   └── migrations/         # Database Migrations
│       ├── 20251127000001_complete_accounting_system.sql
│       ├── 20251127000002_saas_multi_tenant_subscriptions.sql
│       └── 20251127000003_seed_subscription_plans.sql
│
├── public/                 # Static Assets
│
└── package.json
```

---

## 🗄️ قاعدة البيانات

### الاتصال بقاعدة البيانات:

```typescript
import { supabase } from './lib/supabase';

// Query data
const { data, error } = await supabase
  .from('products')
  .select('*');

// Insert data
const { data, error } = await supabase
  .from('products')
  .insert({ name: 'Product Name', price: 100 });
```

### Database Functions:

#### 1. إنشاء عميل جديد:

```sql
SELECT create_new_tenant(
  'My Company',          -- company_name
  'user-uuid',          -- owner_id
  'plan-uuid'           -- plan_id (optional)
);
```

```typescript
const { data, error } = await supabase.rpc('create_new_tenant', {
  p_company_name: 'My Company',
  p_owner_id: userId,
  p_plan_id: planId
});
```

#### 2. تتبع الاستخدام:

```sql
SELECT track_usage(
  'tenant-uuid',        -- tenant_id
  'invoices',          -- metric_name
  1                    -- increment
);
```

```typescript
await supabase.rpc('track_usage', {
  p_tenant_id: tenantId,
  p_metric_name: 'invoices',
  p_increment: 1
});
```

#### 3. حساب رصيد الحساب:

```sql
SELECT calculate_account_balance(
  'account-uuid',      -- account_id
  '2024-12-31'        -- as_of_date (optional)
);
```

```typescript
const { data } = await supabase.rpc('calculate_account_balance', {
  p_account_id: accountId,
  p_as_of_date: '2024-12-31'
});
```

#### 4. إنشاء قيد من فاتورة:

```sql
SELECT create_journal_entry_from_invoice(
  'invoice-uuid'       -- invoice_id
);
```

```typescript
await supabase.rpc('create_journal_entry_from_invoice', {
  p_invoice_id: invoiceId
});
```

---

## 🔌 API Reference

### Authentication:

```typescript
// Sign Up
const { data, error } = await supabase.auth.signUp({
  email: 'user@example.com',
  password: 'password123'
});

// Sign In
const { data, error } = await supabase.auth.signInWithPassword({
  email: 'user@example.com',
  password: 'password123'
});

// Sign Out
await supabase.auth.signOut();

// Get Current User
const { data: { user } } = await supabase.auth.getUser();
```

### Tenants:

```typescript
// Get user's tenants
const { data: tenants } = await supabase
  .from('tenants')
  .select('*, user_tenants!inner(*)')
  .eq('user_tenants.user_id', userId);

// Get tenant details
const { data: tenant } = await supabase
  .from('tenants')
  .select('*, subscription:subscriptions(*)')
  .eq('id', tenantId)
  .single();
```

### Subscription Plans:

```typescript
// Get all active plans
const { data: plans } = await supabase
  .from('subscription_plans')
  .select('*, plan_features(*)')
  .eq('is_active', true)
  .order('sort_order');

// Get plan details
const { data: plan } = await supabase
  .from('subscription_plans')
  .select('*, plan_features(*)')
  .eq('id', planId)
  .single();
```

### Subscriptions:

```typescript
// Get tenant subscription
const { data: subscription } = await supabase
  .from('subscriptions')
  .select('*, plan:subscription_plans(*), usage:subscription_usage(*)')
  .eq('tenant_id', tenantId)
  .eq('status', 'ACTIVE')
  .single();

// Check usage limits
const { data: usage } = await supabase
  .from('subscription_usage')
  .select('*')
  .eq('tenant_id', tenantId)
  .gte('period_start', startDate)
  .lte('period_end', endDate);
```

### Products:

```typescript
// Get all products
const { data: products } = await supabase
  .from('products')
  .select('*')
  .order('name');

// Create product
const { data: product } = await supabase
  .from('products')
  .insert({
    name: 'Product Name',
    selling_price: 100,
    cost_price: 50,
    current_stock: 10
  })
  .select()
  .single();

// Update product
await supabase
  .from('products')
  .update({ selling_price: 120 })
  .eq('id', productId);
```

### Invoices:

```typescript
// Create invoice
const { data: invoice } = await supabase
  .from('invoices')
  .insert({
    invoice_number: 'INV-001',
    customer_id: customerId,
    invoice_date: new Date().toISOString(),
    subtotal: 100,
    tax_amount: 15,
    total_amount: 115
  })
  .select()
  .single();

// Get invoices
const { data: invoices } = await supabase
  .from('invoices')
  .select('*, customer:customers(*), items:invoice_items(*)')
  .order('invoice_date', { ascending: false });
```

### Chart of Accounts:

```typescript
// Get all accounts
const { data: accounts } = await supabase
  .from('chart_of_accounts_advanced')
  .select('*')
  .eq('tenant_id', tenantId)
  .eq('is_active', true)
  .order('account_code');

// Get account by type
const { data: assets } = await supabase
  .from('chart_of_accounts_advanced')
  .select('*')
  .eq('account_type', 'ASSET')
  .eq('tenant_id', tenantId);
```

### Journal Entries:

```typescript
// Create journal entry
const { data: entry } = await supabase
  .from('journal_entries')
  .insert({
    tenant_id: tenantId,
    entry_number: 'JE-001',
    entry_date: new Date().toISOString(),
    entry_type: 'REGULAR',
    description_ar: 'قيد يومي',
    total_debit: 1000,
    total_credit: 1000,
    status: 'POSTED'
  })
  .select()
  .single();

// Add journal lines
await supabase
  .from('journal_entry_lines')
  .insert([
    {
      journal_entry_id: entry.id,
      line_number: 1,
      account_id: debitAccountId,
      debit_amount: 1000,
      description_ar: 'مدين'
    },
    {
      journal_entry_id: entry.id,
      line_number: 2,
      account_id: creditAccountId,
      credit_amount: 1000,
      description_ar: 'دائن'
    }
  ]);
```

---

## 📝 أمثلة الاستخدام

### مثال 1: إنشاء عميل جديد بخطة تجريبية

```typescript
import { supabase } from './lib/supabase';

async function createNewCustomer() {
  // 1. Sign up user
  const { data: authData, error: authError } = await supabase.auth.signUp({
    email: 'customer@example.com',
    password: 'securepassword123'
  });

  if (authError) throw authError;

  // 2. Get free trial plan
  const { data: plan } = await supabase
    .from('subscription_plans')
    .select('id')
    .eq('plan_slug', 'free-trial')
    .single();

  // 3. Create tenant
  const { data: tenantId } = await supabase.rpc('create_new_tenant', {
    p_company_name: 'Customer Company',
    p_owner_id: authData.user.id,
    p_plan_id: plan.id
  });

  return tenantId;
}
```

### مثال 2: إنشاء فاتورة مع قيد محاسبي تلقائي

```typescript
async function createInvoiceWithAccounting(tenantId: string) {
  // 1. Create invoice
  const { data: invoice } = await supabase
    .from('invoices')
    .insert({
      invoice_number: 'INV-' + Date.now(),
      customer_id: customerId,
      invoice_date: new Date().toISOString(),
      subtotal: 1000,
      tax_amount: 150,
      total_amount: 1150
    })
    .select()
    .single();

  // 2. Create journal entry automatically
  await supabase.rpc('create_journal_entry_from_invoice', {
    p_invoice_id: invoice.id
  });

  // 3. Track usage
  await supabase.rpc('track_usage', {
    p_tenant_id: tenantId,
    p_metric_name: 'invoices',
    p_increment: 1
  });

  return invoice;
}
```

### مثال 3: التحقق من حدود الاستخدام

```typescript
async function checkUsageLimits(tenantId: string) {
  const { data: usage } = await supabase
    .from('subscription_usage')
    .select('*')
    .eq('tenant_id', tenantId)
    .gte('period_start', new Date().toISOString().split('T')[0])
    .single();

  if (usage.exceeded) {
    throw new Error(`Usage limit exceeded for ${usage.metric_name}`);
  }

  return {
    current: usage.metric_value,
    limit: usage.limit_value,
    remaining: usage.limit_value - usage.metric_value
  };
}
```

### مثال 4: إنشاء قيد محاسبي يدوي

```typescript
async function createManualJournalEntry(
  tenantId: string,
  entries: { accountId: string; debit?: number; credit?: number }[]
) {
  // Calculate totals
  const totalDebit = entries.reduce((sum, e) => sum + (e.debit || 0), 0);
  const totalCredit = entries.reduce((sum, e) => sum + (e.credit || 0), 0);

  if (totalDebit !== totalCredit) {
    throw new Error('Journal entry must be balanced');
  }

  // Create entry
  const { data: entry } = await supabase
    .from('journal_entries')
    .insert({
      tenant_id: tenantId,
      entry_number: 'JE-' + Date.now(),
      entry_date: new Date().toISOString(),
      entry_type: 'MANUAL',
      description_ar: 'قيد يدوي',
      total_debit: totalDebit,
      total_credit: totalCredit,
      status: 'POSTED'
    })
    .select()
    .single();

  // Create lines
  await supabase
    .from('journal_entry_lines')
    .insert(
      entries.map((e, i) => ({
        journal_entry_id: entry.id,
        line_number: i + 1,
        account_id: e.accountId,
        debit_amount: e.debit || 0,
        credit_amount: e.credit || 0
      }))
    );

  return entry;
}
```

---

## 🔐 الأمان

### Row Level Security (RLS):

جميع الجداول محمية بـ RLS:

```sql
-- مثال: سياسة للتأكد من أن المستخدم يمكنه رؤية بيانات tenant الخاص به فقط
CREATE POLICY "Users can view their tenant data"
  ON products FOR SELECT
  TO authenticated
  USING (
    tenant_id IN (
      SELECT tenant_id FROM user_tenants
      WHERE user_id = auth.uid()
    )
  );
```

### Best Practices:

1. **استخدم RLS دائماً** - لا تعتمد على Frontend validation فقط
2. **تحقق من الصلاحيات** - تأكد من role المستخدم قبل العمليات الحساسة
3. **لا تخزن Secrets** - استخدم Environment Variables
4. **Log كل شيء** - استخدم audit_logs للعمليات المهمة
5. **Rate Limiting** - طبق حدود على API calls

---

## 🛠️ التطوير

### إضافة Migration جديد:

```bash
# Create new migration
supabase migration new my_feature_name

# Edit the migration file
# supabase/migrations/YYYYMMDDHHMMSS_my_feature_name.sql

# Apply migration
supabase db push
```

### إضافة Component جديد:

```typescript
// src/components/MyNewComponent.tsx
import React from 'react';

interface MyNewComponentProps {
  language: 'ar' | 'en';
  isDarkMode: boolean;
}

export function MyNewComponent({ language, isDarkMode }: MyNewComponentProps) {
  return (
    <div className={isDarkMode ? 'bg-slate-800' : 'bg-white'}>
      {/* Your component code */}
    </div>
  );
}
```

### Testing:

```bash
# Run linter
npm run lint

# Build for production
npm run build

# Preview production build
npm run preview
```

---

## 📊 Monitoring & Analytics

### Usage Tracking:

```typescript
// Track feature usage
async function trackFeatureUsage(tenantId: string, featureKey: string) {
  await supabase
    .from('feature_usage')
    .insert({
      tenant_id: tenantId,
      feature_key: featureKey,
      usage_count: 1,
      metadata: { timestamp: new Date().toISOString() }
    });
}
```

### Get Usage Metrics:

```typescript
// Get daily metrics
const { data: metrics } = await supabase
  .from('usage_metrics')
  .select('*')
  .eq('tenant_id', tenantId)
  .order('metric_date', { ascending: false })
  .limit(30);
```

---

## 🚀 Deployment

### Environment Variables:

```env
VITE_SUPABASE_URL=your_supabase_url
VITE_SUPABASE_ANON_KEY=your_anon_key
```

### Build & Deploy:

```bash
# Build for production
npm run build

# Deploy to your hosting (example: Vercel)
vercel deploy

# Or deploy to Netlify
netlify deploy
```

---

## 📞 Support

- GitHub Issues: [Link to issues]
- Email: support@kayan-erp.com
- Documentation: [Link to docs]

---

## 🎯 Next Steps

1. إضافة ZATCA Phase 2
2. تطوير Mobile Apps
3. إضافة Workflow Engine
4. تطوير Super Admin Dashboard
5. إضافة Multi-Company Support

---

**Happy Coding! 🎉**
