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

# Terraform / OpenTofu / Pulumi
- NEVER plan or apply infrastructure changes unless explicitly allowed.
- NEVER read state files of any kind unless explicitly allowed.

# Git
- Never commit any work.
- Never push, force-push, rebase, or amend commits unless explicitly requested.
- Do not revert user changes you did not make.
- Always create branches from updated main when starting a work session.
- Branch names should be prefixed with chore/, feat/ or fix/ depending on the work we're doing.

# Pull Requests
- When asked to open a PR, write a detailed PR description that clearly explains the change, impact, and validation.
- Include a final line in the PR description in the format: Built with 🤖 <model name>.
- Use the actual model name used for the work, for example: OpenAI ChatGPT 5.4 or Claude Opus 4.

# Observability
- When designing dashboards, always run the queries you will use for panels to verify data is correct.
- When proposing dashboards or alerts, prefer queries that can be validated against live data first.
- Call out assumptions about labels, metrics, or datasource names.
