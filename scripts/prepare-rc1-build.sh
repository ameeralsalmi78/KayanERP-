#!/usr/bin/env bash
set -euo pipefail

printf '%s\n' 'KAYAN ERP staging: preparing RC1 Next.js runtime...'

shopt -s nullglob
parts=(rc1/part-*.b64)
if [ ${#parts[@]} -eq 0 ]; then
  echo 'ERROR: no rc1/part-*.b64 runtime archive was found.' >&2
  exit 1
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

cat "${parts[@]}" | tr -d '\r\n' | base64 --decode > "$tmp_dir/rc1.tar.xz"
mkdir -p "$tmp_dir/extracted"
tar -xJf "$tmp_dir/rc1.tar.xz" -C "$tmp_dir/extracted"

pkg="$(find "$tmp_dir/extracted" -maxdepth 3 -type f -name package.json -print -quit)"
if [ -z "$pkg" ]; then
  echo 'ERROR: RC1 archive does not contain package.json.' >&2
  exit 1
fi

runtime_root="$(dirname "$pkg")"
if [ ! -d "$runtime_root/app" ]; then
  echo 'ERROR: RC1 package root does not contain Next.js app/ directory.' >&2
  exit 1
fi

printf '%s\n' 'KAYAN ERP staging: Next.js runtime found.'
cp -a "$runtime_root"/. ./

if [ ! -f package.json ] || [ ! -d app ]; then
  echo 'ERROR: runtime extraction did not produce a valid Next.js application.' >&2
  exit 1
fi

# The archived lockfile is stale relative to package.json. Regenerate it for staging
# instead of letting npm ci fail before the application can be validated.
printf '%s\n' 'KAYAN ERP staging: refreshing runtime dependency lock...'
rm -f package-lock.json
npm install --no-audit --no-fund

printf '%s\n' 'KAYAN ERP staging: building Next.js application...'
npx next build
