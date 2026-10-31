/*
  KAYAN ERP — Promote an existing authenticated user to Super Admin

  SECURITY:
  - This script never creates users and never contains passwords.
  - Create/reset the account through Supabase Auth using a strong unique password.
  - Set the target email below before running this script in Supabase SQL Editor.
*/

DO $$
DECLARE
  target_email text := 'ameer.alsalmi90@gmail.com';
  target_name text := 'Ameer Al-Salmi';
  user_uuid uuid;
BEGIN
  SELECT id INTO user_uuid
  FROM auth.users
  WHERE email = target_email;

  IF user_uuid IS NULL THEN
    RAISE EXCEPTION 'User % does not exist in Supabase Auth. Create or reset the account securely first.', target_email;
  END IF;

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
    target_name,
    target_email,
    NULL,
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
    full_name = EXCLUDED.full_name,
    email = EXCLUDED.email,
    permissions = EXCLUDED.permissions,
    updated_at = now();

  UPDATE profiles
  SET role = 'admin'
  WHERE user_id = user_uuid;

  RAISE NOTICE 'Super Admin privileges granted to %.', target_email;
END $$;

SELECT
  sa.id,
  sa.full_name,
  sa.email,
  sa.is_active,
  sa.permissions,
  sa.created_at,
  u.created_at AS user_created_at
FROM super_admins sa
JOIN auth.users u ON sa.user_id = u.id
WHERE sa.email = 'ameer.alsalmi90@gmail.com';
