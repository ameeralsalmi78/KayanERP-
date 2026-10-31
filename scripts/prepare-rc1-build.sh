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

# The repository root previously contained a Vite shell. Those files are not
# part of the RC1 Next.js runtime and make Next's TypeScript pass resolve Vite
# packages that are intentionally absent. Remove the stale shell before build.
printf '%s\n' 'KAYAN ERP staging: removing stale Vite shell files...'
rm -f vite.config.ts vite.config.js vite.config.mjs

printf '%s\n' 'KAYAN ERP staging: refreshing runtime dependency lock...'
rm -f package-lock.json
npm install --no-audit --no-fund

# The archived Next.js app uses Tailwind/PostCSS configuration but its package
# manifest omitted the build-time CSS toolchain. Install it explicitly for staging.
printf '%s\n' 'KAYAN ERP staging: ensuring CSS build toolchain...'
npm install --no-save --no-audit --no-fund tailwindcss@3.4.17 postcss@8 autoprefixer@10

printf '%s\n' 'KAYAN ERP staging: building Next.js application...'
npx next build
