# AGENTS.md

# General
- NEVER read .env, .vault_password or any other files that contain credentials. Ask if unsure.
- NEVER read any SSH or GPG private keys. Ask if unsure.
- Never print, copy, or summarize secret values found in config files.
- Prefer environment-variable references over hardcoded credentials when suggesting config changes.
- Prefer minimal, targeted changes and avoid unrelated refactors.
- Do not modify generated files or lockfiles unless the task requires it.
- After making changes, run the smallest relevant verification step available.
- If verification cannot be run, state that clearly.
- Ask before performing destructive, external, or high-impact actions.

# Kubernetes
- NEVER read Kubernetes secrets.
- NEVER apply manifests, install / update helm releases, etc. without confirmation.

# Git
- Never commit any work.
- Never push, force-push, rebase, or amend commits unless explicitly requested.
- Do not revert user changes you did not make.
- Always create branches from updated main when starting a work session.
- Branch names should be prefixed with chore/, feat/ or fix/ depending on the work we're doing.

# Observability
- When designing dashboards, always run the queries you will use for panels to verify data is correct.
- When proposing dashboards or alerts, prefer queries that can be validated against live data first.
- Call out assumptions about labels, metrics, or datasource names.
