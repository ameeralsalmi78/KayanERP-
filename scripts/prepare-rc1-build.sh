#!/usr/bin/env bash
set -euo pipefail

printf '%s\n' 'KAYAN ERP staging: preparing RC1 runtime source...'

if [ ! -d src ]; then
  shopt -s nullglob
  parts=(rc1/part-*.b64)
  if [ ${#parts[@]} -eq 0 ]; then
    echo 'ERROR: src/ is missing and no rc1/part-*.b64 runtime archive was found.' >&2
    exit 1
  fi

  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' EXIT

  cat "${parts[@]}" | tr -d '\r\n' | base64 --decode > "$tmp_dir/rc1.tar.xz"
  mkdir -p "$tmp_dir/extracted"
  tar -xJf "$tmp_dir/rc1.tar.xz" -C "$tmp_dir/extracted"

  src_dir="$(find "$tmp_dir/extracted" -type d -name src -print -quit)"
  if [ -z "$src_dir" ]; then
    echo 'RC1 archive layout (first 120 entries):' >&2
    find "$tmp_dir/extracted" -maxdepth 5 -printf '%P\n' | sed '/^$/d' | sort | head -120 >&2
    echo 'ERROR: the RC1 runtime archive does not contain a src/ directory.' >&2
    exit 1
  fi

  cp -a "$src_dir" ./src

  archive_root="$(dirname "$src_dir")"
  if [ -d "$archive_root/public" ] && [ ! -d public ]; then
    cp -a "$archive_root/public" ./public
  fi
fi

if [ ! -f src/main.tsx ]; then
  echo 'ERROR: src/main.tsx is missing after RC1 runtime preparation.' >&2
  exit 1
fi

printf '%s\n' 'KAYAN ERP staging: source ready; building Vite application...'
npx vite build
