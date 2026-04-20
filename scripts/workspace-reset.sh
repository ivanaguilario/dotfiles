#!/bin/sh

set -u

WORKSPACE=${1:-.}

if [ -t 1 ]; then
  BOLD=$(printf '\033[1m')
  GREEN=$(printf '\033[32m')
  RED=$(printf '\033[31m')
  RESET=$(printf '\033[0m')
  OK_ICON='✓'
  BLOCKED_ICON='!'
else
  BOLD=''
  GREEN=''
  RED=''
  RESET=''
  OK_ICON='OK'
  BLOCKED_ICON='BLOCKED'
fi

if [ ! -d "$WORKSPACE" ]; then
  printf 'Workspace not found: %s\n' "$WORKSPACE" >&2
  exit 1
fi

TMPDIR_ROOT=${TMPDIR:-/tmp}
RESULT_DIR=$(mktemp -d "$TMPDIR_ROOT/reset-workspace.XXXXXX") || exit 1

cleanup() {
  rm -rf "$RESULT_DIR"
}

trap cleanup EXIT INT TERM HUP

write_result() {
  result_file=$1
  status=$2
  message=$3

  printf '%s|%s\n' "$status" "$message" >"$result_file"
}

repo_result() {
  repo_dir=$1
  repo_name=$2
  result_file=$3

  if ! git -C "$repo_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    return 0
  fi

  if ! git -C "$repo_dir" remote get-url origin >/dev/null 2>&1; then
    write_result "$result_file" blocked 'missing origin remote'
    return 0
  fi

  if [ -n "$(git -C "$repo_dir" status --porcelain 2>/dev/null)" ]; then
    write_result "$result_file" blocked 'uncommitted changes'
    return 0
  fi

  current_branch=$(git -C "$repo_dir" symbolic-ref --quiet --short HEAD 2>/dev/null) || {
    write_result "$result_file" blocked 'detached HEAD'
    return 0
  }

  upstream_ref=$(git -C "$repo_dir" rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null) || {
    write_result "$result_file" blocked 'current branch has no upstream'
    return 0
  }

  ahead_behind=$(git -C "$repo_dir" rev-list --left-right --count "$upstream_ref...HEAD" 2>/dev/null) || {
    write_result "$result_file" blocked 'failed to compare current branch with upstream'
    return 0
  }

  local_only=$(printf '%s\n' "$ahead_behind" | cut -f2)

  if [ "$local_only" -gt 0 ]; then
    write_result "$result_file" blocked 'current branch has unpushed commits'
    return 0
  fi

  if ! git -C "$repo_dir" show-ref --verify --quiet refs/heads/main; then
    if ! git -C "$repo_dir" show-ref --verify --quiet refs/remotes/origin/main; then
      write_result "$result_file" blocked 'main branch not found'
      return 0
    fi

    if ! git -C "$repo_dir" checkout -b main --track origin/main >/dev/null 2>&1; then
      write_result "$result_file" blocked 'failed to create local main from origin/main'
      return 0
    fi
  elif [ "$current_branch" != "main" ]; then
    if ! git -C "$repo_dir" checkout main >/dev/null 2>&1; then
      write_result "$result_file" blocked 'failed to checkout main'
      return 0
    fi
  fi

  if ! git -C "$repo_dir" fetch origin main >/dev/null 2>&1; then
    write_result "$result_file" blocked 'failed to fetch origin/main'
    return 0
  fi

  if ! git -C "$repo_dir" show-ref --verify --quiet refs/remotes/origin/main; then
    write_result "$result_file" blocked 'origin/main not found'
    return 0
  fi

  main_compare=$(git -C "$repo_dir" rev-list --left-right --count origin/main...main 2>/dev/null) || {
    write_result "$result_file" blocked 'failed to compare main with origin/main'
    return 0
  }

  remote_only=$(printf '%s\n' "$main_compare" | cut -f1)
  main_only=$(printf '%s\n' "$main_compare" | cut -f2)

  if [ "$main_only" -gt 0 ] && [ "$remote_only" -gt 0 ]; then
    write_result "$result_file" blocked 'local main diverged from origin/main'
    return 0
  fi

  if [ "$main_only" -gt 0 ]; then
    write_result "$result_file" blocked 'local main has unpushed commits'
    return 0
  fi

  if [ "$remote_only" -eq 0 ]; then
    write_result "$result_file" updated 'already up to date'
    return 0
  fi

  if git -C "$repo_dir" pull --ff-only origin main >/dev/null 2>&1; then
    write_result "$result_file" updated 'pulled latest main'
    return 0
  fi

  write_result "$result_file" blocked 'pull failed'
}

for repo_dir in "$WORKSPACE"/*; do
  [ -d "$repo_dir" ] || continue

  repo_name=$(basename "$repo_dir")
  result_file="$RESULT_DIR/$repo_name.result"

  repo_result "$repo_dir" "$repo_name" "$result_file" &
done

wait

repo_count=0
updated_count=0
blocked_count=0
max_name_len=0

for repo_dir in "$WORKSPACE"/*; do
  [ -d "$repo_dir" ] || continue

  repo_name=$(basename "$repo_dir")
  result_file="$RESULT_DIR/$repo_name.result"

  if [ -f "$result_file" ]; then
    repo_count=$((repo_count + 1))
    name_len=${#repo_name}
    if [ "$name_len" -gt "$max_name_len" ]; then
      max_name_len=$name_len
    fi
  fi
done

printf '%sWorkspace reset report%s\n\n' "$BOLD" "$RESET"

for repo_dir in "$WORKSPACE"/*; do
  [ -d "$repo_dir" ] || continue

  repo_name=$(basename "$repo_dir")
  result_file="$RESULT_DIR/$repo_name.result"

  if [ -f "$result_file" ]; then
    IFS='|' read -r status message <"$result_file"

    if [ "$status" = "updated" ]; then
      updated_count=$((updated_count + 1))
      icon=$OK_ICON
      color=$GREEN
    else
      blocked_count=$((blocked_count + 1))
      icon=$BLOCKED_ICON
      color=$RED
    fi

    printf '%s%-7s%s %-*s %s\n' "$color" "$icon" "$RESET" "$max_name_len" "$repo_name" "$message"
  fi
done

if [ "$repo_count" -gt 0 ]; then
  printf '\n%s updated, %s blocked, %s total\n' "$updated_count" "$blocked_count" "$repo_count"
fi
