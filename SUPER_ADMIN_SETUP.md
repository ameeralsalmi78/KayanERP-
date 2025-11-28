# إعداد Super Admin الرئيسي

## المستخدم الرئيسي
- **الاسم**: ameer
- **البريد الإلكتروني**: ameer.alsalmi90@gmail.com
- **كلمة المرور**: 778778778

## خطوات الإعداد

### 1. تسجيل المستخدم في النظام

قم بتسجيل الدخول إلى النظام أولاً لإنشاء حساب المستخدم:

1. افتح النظام في المتصفح
2. انقر على "تسجيل حساب جديد" / "Sign Up"
3. أدخل المعلومات التالية:
   - الاسم الكامل: Ameer Al-Salmi
   - البريد الإلكتروني: ameer.alsalmi90@gmail.com
   - كلمة المرور: 778778778
   - الوظيفة/الدور: Admin

### 2. إضافة المستخدم كـ Super Admin

بعد إنشاء الحساب، قم بتنفيذ الكود SQL التالي في Supabase SQL Editor:

```sql
-- الحصول على user_id من جدول auth.users
DO $$
DECLARE
  user_uuid uuid;
BEGIN
  -- البحث عن المستخدم
  SELECT id INTO user_uuid
  FROM auth.users
  WHERE email = 'ameer.alsalmi90@gmail.com';

  -- التحقق من وجود المستخدم
  IF user_uuid IS NOT NULL THEN
    -- إضافة المستخدم كـ Super Admin
    INSERT INTO super_admins (
      user_id,
      full_name,
      email,
      phone,
      permissions,
      is_active
    )
    VALUES (
      user_uuid,
      'Ameer Al-Salmi',
      'ameer.alsalmi90@gmail.com',
      NULL,
      jsonb_build_object(
        'manage_tenants', true,
        'manage_subscriptions', true,
        'manage_users', true,
        'view_analytics', true,
        'system_settings', true
      ),
      true
    )
    ON CONFLICT (user_id)
    DO UPDATE SET
      is_active = true,
      permissions = jsonb_build_object(
        'manage_tenants', true,
        'manage_subscriptions', true,
        'manage_users', true,
        'view_analytics', true,
        'system_settings', true
      );

    RAISE NOTICE 'Super Admin added successfully: %', user_uuid;
  ELSE
    RAISE EXCEPTION 'User not found. Please create the user account first.';
  END IF;
END $$;
```

### 3. التحقق من الإعداد

للتحقق من نجاح الإعداد، قم بتنفيذ:

```sql
-- التحقق من Super Admin
SELECT
  sa.id,
  sa.full_name,
  sa.email,
  sa.is_active,
  sa.permissions,
  sa.created_at,
  u.email as auth_email
FROM super_admins sa
JOIN auth.users u ON sa.user_id = u.id
WHERE sa.email = 'ameer.alsalmi90@gmail.com';
```

### 4. تسجيل الدخول كـ Super Admin

1. افتح النظام في المتصفح
2. سجل الدخول باستخدام:
   - البريد: ameer.alsalmi90@gmail.com
   - كلمة المرور: 778778778
3. يجب أن يظهر زر "سوبر أدمن" في الهيدر
4. انقر على الزر للوصول إلى لوحة التحكم الشاملة

## الصلاحيات الكاملة

بصفتك Super Admin، لديك صلاحيات كاملة:

✅ إدارة جميع العملاء (Tenants)
✅ إدارة الاشتراكات والباقات
✅ إدارة مستخدمي جميع العملاء
✅ عرض التحليلات والإحصائيات الشاملة
✅ التحكم في إعدادات النظام العامة
✅ تعليق/تفعيل حسابات العملاء
✅ تتبع الاستخدام والفواتير
✅ الوصول الكامل لجميع البيانات

## ملاحظات أمنية مهمة

⚠️ **احتفظ بهذه المعلومات في مكان آمن**
⚠️ **لا تشارك بيانات الدخول مع أي شخص**
⚠️ **قم بتغيير كلمة المرور بعد أول تسجيل دخول**
⚠️ **فعّل المصادقة الثنائية إذا كانت متاحة**

## إضافة Super Admin آخر (اختياري)

لإضافة مستخدم آخر كـ Super Admin:

```sql
-- استبدل القيم بمعلومات المستخدم الجديد
INSERT INTO super_admins (
  user_id,
  full_name,
  email,
  permissions,
  is_active
)
SELECT
  id,
  'اسم المستخدم الجديد',
  email,
  jsonb_build_object(
    'manage_tenants', true,
    'manage_subscriptions', true,
    'manage_users', true,
    'view_analytics', true,
    'system_settings', true
  ),
  true
FROM auth.users
WHERE email = 'email@example.com';
```

## استكشاف الأخطاء

### المشكلة: لا يظهر زر Super Admin
**الحل**: تأكد من:
1. تم تنفيذ SQL بنجاح
2. المستخدم موجود في جدول `super_admins`
3. `is_active = true`
4. تم تسجيل الخروج وإعادة تسجيل الدخول

### المشكلة: لا أستطيع الوصول لبيانات العملاء
**الحل**: تحقق من صلاحيات RLS في Supabase

---

**تم إنشاء النظام بواسطة KAYAN Modern Creative**
**جميع الحقوق محفوظة © 2024**
