/*
  ================================
  إضافة Super Admin الرئيسي
  ================================

  المستخدم: Ameer Al-Salmi
  البريد: ameer.alsalmi90@gmail.com

  ⚠️ ملاحظة مهمة: يجب عليك أولاً تسجيل حساب في النظام بهذا البريد
  ثم تنفيذ هذا الكود SQL في Supabase SQL Editor
*/

DO $$
DECLARE
  user_uuid uuid;
  user_exists boolean := false;
BEGIN
  -- البحث عن المستخدم في auth.users
  SELECT id INTO user_uuid
  FROM auth.users
  WHERE email = 'ameer.alsalmi90@gmail.com';

  -- التحقق من وجود المستخدم
  IF user_uuid IS NOT NULL THEN
    user_exists := true;

    -- إضافة المستخدم كـ Super Admin
    INSERT INTO super_admins (
      user_id,
      full_name,
      email,
      phone,
      permissions,
      is_active,
      created_at,
      last_login
    )
    VALUES (
      user_uuid,
      'Ameer Al-Salmi',
      'ameer.alsalmi90@gmail.com',
      NULL, -- يمكن إضافة رقم الهاتف لاحقاً
      jsonb_build_object(
        'manage_tenants', true,
        'manage_subscriptions', true,
        'manage_users', true,
        'view_analytics', true,
        'system_settings', true,
        'full_access', true
      ),
      true,
      now(),
      NULL
    )
    ON CONFLICT (user_id)
    DO UPDATE SET
      is_active = true,
      full_name = 'Ameer Al-Salmi',
      permissions = jsonb_build_object(
        'manage_tenants', true,
        'manage_subscriptions', true,
        'manage_users', true,
        'view_analytics', true,
        'system_settings', true,
        'full_access', true
      ),
      updated_at = now();

    -- تحديث الـ profile إذا كان موجود
    UPDATE profiles
    SET role = 'admin'
    WHERE user_id = user_uuid;

    RAISE NOTICE '✅ تم إضافة Super Admin بنجاح!';
    RAISE NOTICE 'User ID: %', user_uuid;
    RAISE NOTICE 'Email: ameer.alsalmi90@gmail.com';
    RAISE NOTICE 'Full Name: Ameer Al-Salmi';
    RAISE NOTICE 'جميع الصلاحيات: مفعلة ✓';

  ELSE
    RAISE EXCEPTION '❌ خطأ: المستخدم غير موجود! يجب عليك أولاً:

    1. فتح النظام في المتصفح
    2. تسجيل حساب جديد باستخدام:
       - البريد: ameer.alsalmi90@gmail.com
       - كلمة المرور: 778778778
    3. ثم تنفيذ هذا الكود SQL مرة أخرى
    ';
  END IF;
END $$;

-- التحقق من النتيجة
SELECT
  sa.id,
  sa.full_name,
  sa.email,
  sa.is_active,
  sa.permissions,
  sa.created_at,
  u.email as auth_email,
  u.created_at as user_created_at
FROM super_admins sa
JOIN auth.users u ON sa.user_id = u.id
WHERE sa.email = 'ameer.alsalmi90@gmail.com';
